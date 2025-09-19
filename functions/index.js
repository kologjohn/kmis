import { onDocumentCreated } from "firebase-functions/v2/firestore";
import admin from "firebase-admin";
import { v4 as uuidv4 } from "uuid"; // install with: npm install uuid

if (!admin.apps.length) {
  admin.initializeApp();
}

const db = admin.firestore();

export const createLedgerOnBilling = onDocumentCreated("billed/{billId}", async (event) => {
  const snapshot = event.data;
  if (!snapshot) {
    console.log("No billed document found.");
    return;
  }

  const billedData = snapshot.data();
  if (!billedData) {
    console.log("Empty billed data.");
    return;
  }

  const billedRef = snapshot.ref; // reference to update billed doc
  const { level, yeargroup, schoolId, amount, term, activityType } = billedData;

  try {
    // 1. Get matching students
    const studentsSnap = await db
      .collection("students")
      .where("level", "==", level)
      .where("yeargroup", "==", yeargroup)
      .get();

    if (studentsSnap.empty) {
      console.log(`No students found for ${level}, ${yeargroup}, ${schoolId}`);
      await billedRef.update({
        ledgerStatus: "failed",
        ledgerMessage: `No students found for ${level}, ${yeargroup}, ${schoolId}`,
      });
      return;
    }

    // 2. Get system activity by name
    const activitySnap = await db
      .collection("systemActivity")
      .where("name", "==", activityType)
      .limit(1)
      .get();

    if (activitySnap.empty) {
      console.log(`SystemActivity with name '${activityType}' not found.`);
       await db.collection("errors").add({
        message: `SystemActivity with name '${activityType}' not found.`,
        billedId: event.params.billId,
        timestamp: admin.firestore.FieldValue.serverTimestamp(),
      });
      await billedRef.update({
        ledgerStatus: "failed",
        ledgerMessage: `SystemActivity '${activityType}' not found.`,
      });
      return;
    }

    const activityData = activitySnap.docs[0].data();
    const { crAccount, crAccountClass, drAccount, drAccountClass } = activityData;

    // 3. Batch ledger entries (two per student)
    const batch = db.batch();

    studentsSnap.forEach((studentDoc) => {
      const student = studentDoc.data();
      const transactionId = uuidv4(); // unique per student
      // Debit entry
      const debitRef = db.collection("ledger").doc();
      batch.set(debitRef, {
        transactionId,
        entryType: "Debit",
        account: drAccount ?? null,
        accountClass: drAccountClass || null,
        studentId: studentDoc.id,
        studentName: student.name || null,
        schoolId,
        activityType,
        term,
        level,
        yeargroup,
        amount: Number(amount),
        billedId: event.params.billId,
        createdAt: admin.firestore.FieldValue.serverTimestamp(),
      });

      // Credit entry
      const creditRef = db.collection("ledger").doc();
      batch.set(creditRef, {
        transactionId,
        entryType: "Credit",
        account: crAccount ?? null,
        accountClass: crAccountClass || null,
        studentId: studentDoc.id,
        studentName: student.name || null,
        schoolId,
        activityType,
        term,
        level,
        yeargroup,
        amount: Number(amount),
        billedId: event.params.billId,
        createdAt: admin.firestore.FieldValue.serverTimestamp(),
      });
    });

    await batch.commit();

    // Update billed document with success
    await billedRef.update({
      ledgerStatus: "success",
      ledgerMessage: `Ledger created for ${studentsSnap.size} students (${studentsSnap.size * 2} entries).`,
    });

    console.log(
      `Ledger created (${studentsSnap.size * 2} entries) for ${studentsSnap.size} students under ${activityType}.`
    );
  } catch (error) {
    console.error("Error creating ledger entries:", error);
    await snapshot.ref.update({
      ledgerStatus: "failed",
      ledgerMessage: `Error: ${error.message}`,
    });
  }
});

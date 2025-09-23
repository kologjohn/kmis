// Ledger posting for feepayment collection
export const createLedgerOnFeePayment = onDocumentCreated(
  "feepayment/{paymentId}",
  async (event) => {
    const snapshot = event.data;
    if (!snapshot) {
      console.log("No feepayment document found.");
      return;
    }
    const paymentData = snapshot.data();
    if (!paymentData) {
      console.log("Empty feepayment data.");
      return;
    }
    const paymentRef = snapshot.ref;
  const { studentId, schoolId, amount, term, receivedaccount, feeName, level, yeargroup } = paymentData;
    try {
      // Get student
      const studentDoc = await db.collection("students").doc(`${schoolId}_${studentId}`).get();
      if (!studentDoc.exists) {
        await paymentRef.update({
          ledgerStatus: "failed",
          ledgerMessage: `Student ${studentId} not found`,
        });
        return;
      }
      const student = studentDoc.data();

      // Get system activity for 'fee payment'
      const activitySnap = await db
        .collection("systemActivity")
        .where("name", "==", "Fee Payment")
        .limit(1)
        .get();
      if (activitySnap.empty) {
        await db.collection("errors").add({
          message: `SystemActivity with name 'fee payment' not found.`,
          paymentId: event.params.paymentId,
          timestamp: admin.firestore.FieldValue.serverTimestamp(),
        });
        await paymentRef.update({
          ledgerStatus: "failed",
          ledgerMessage: `SystemActivity 'fee payment' not found.`,
        });
        return;
      }
      const activityData = activitySnap.docs[0].data();
      const { crAccount, crAccountClass, crAccountSubClass } = activityData;

      // Get mainaccounts data for debit account
      let debitAccountClass = null;
      let debitSubClass = null;
      if (receivedaccount) {
        const mainAccDoc = await db.collection("mainaccounts").where("name", "==", receivedaccount).get();
        if (!mainAccDoc.empty) {
          const mainAccData = mainAccDoc.docs[0].data();
          debitAccountClass = mainAccData.accountType ?? null;
          debitSubClass = mainAccData.subType ?? null;
        }
      }

      // Ledger entry
      const transactionId = uuidv4();
      const ledgerId = `${event.params.paymentId}_${studentId}`;
      const ledgerRef = db.collection("ledger").doc(ledgerId);
      await ledgerRef.set({
        transactionId,
        studentId,
        studentName: student.name || null,
        schoolId,
        activityType: "fee payment",
        feeName,
        term,
        level,
        yeargroup,
        amount: String(amount),
        paymentId: event.params.paymentId,
        createdAt: admin.firestore.FieldValue.serverTimestamp(),
        accounts: {
          debit: {
            account: receivedaccount ?? null,
            accountClass: debitAccountClass,
            value: String(amount),
            subClass: debitSubClass,
          },
          credit: {
            account: crAccount ?? null,
            accountClass: crAccountClass ?? null,
            value: String(amount),
            subClass: crAccountSubClass ?? null,
          },
        },
      });

      await paymentRef.update({
        ledgerStatus: "success",
        ledgerMessage: `Ledger created for fee payment by student ${studentId}.`,
      });
      console.log(`Ledger created for fee payment by student ${studentId}`);
    } catch (error) {
      console.error("Error creating feepayment ledger entry:", error);
      await paymentRef.update({
        ledgerStatus: "failed",
        ledgerMessage: `Error: ${error.message}`,
      });
    }
  }
);
// Ledger posting for singlebilled (top-up or unbilled students)

import { onDocumentCreated } from "firebase-functions/v2/firestore";
import admin from "firebase-admin";
import { v4 as uuidv4 } from "uuid"; // install with: npm install uuid

if (!admin.apps.length) {
  admin.initializeApp();
}

const db = admin.firestore();

export const createLedgerOnSingleBilling = onDocumentCreated(
  "singlebilled/{singleBillId}",
  async (event) => {
    const snapshot = event.data;
    if (!snapshot) {
      console.log("No singlebilled document found.");
      return;
    }

    const billData = snapshot.data();
    if (!billData) {
      console.log("Empty singlebilled data.");
      return;
    }

    const billRef = snapshot.ref;
    const { studentId, schoolId, amount, term, activityType, feeName, level, yeargroup,ledgerid } = billData;
    try {
      // Get student
      const studentDoc = await db.collection("students").doc(`${schoolId}_${studentId}`).get();
      if (!studentDoc.exists) {
        await billRef.update({
          ledgerStatus: "failed",
          ledgerMessage: `Student ${studentId} not found`,
        });
        return;
      }
      const student = studentDoc.data();

      // Get system activity
      const activitySnap = await db.collection("systemActivity").where("name", "==", activityType).limit(1).get();
      if (activitySnap.empty) {
        await db.collection("errors").add({
          message: `SystemActivity with name '${activityType}' not found.`,
          singleBillId: event.params.singleBillId,
          timestamp: admin.firestore.FieldValue.serverTimestamp(),
        });
        await billRef.update({
          ledgerStatus: "failed",
          ledgerMessage: `SystemActivity '${activityType}' not found.`,
        });
        return;
      }
      const activityData = activitySnap.docs[0].data();
      const { crAccount, crAccountClass, drAccount, drAccountClass, staff, crAccountSubClass, drAccountSubClass } = activityData;

      // Ledger entry
      const transactionId = uuidv4();
      const note = `Being ${feeName} single billed  for ${term} Term`;
      const status=true;
     // const ledgerId = `${event.params.singleBillId}_${studentId}`;
      const ledgerRef = db.collection("ledger").doc(ledgerid);
      await ledgerRef.set({
        transactionId,
        studentId,
        studentName: student.name || null,
        schoolId,
        activityType,
        feeName,
        term,
        note,
        status,
        level,
        staff,
        yeargroup,
        amount: String(amount),
        singleBillId: event.params.singleBillId,
        createdAt: admin.firestore.FieldValue.serverTimestamp(),
        accounts: {
          debit: {
            account: drAccount ?? null,
            accountClass: drAccountClass ?? null,
            value: String(amount),
            subClass: drAccountSubClass ?? null,
          },
          credit: {
            account: crAccount ?? null,
            accountClass: crAccountClass ?? null,
            value: String(amount),
            subClass: crAccountSubClass ?? null,
          },
        },
      });

      await billRef.update({
        ledgerStatus: "success",
        ledgerMessage: `Ledger created for student ${studentId}.`,
      });
      console.log(`Ledger created for singlebilled student ${studentId}`);
    } catch (error) {
      console.error("Error creating singlebilled ledger entry:", error);
      await billRef.update({
        ledgerStatus: "failed",
        ledgerMessage: `Error: ${error.message}`,
      });
    }
  }
);

export const createLedgerOnBilling = onDocumentCreated(
  "billed/{billId}",
  async (event) => {
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

    const billedRef = snapshot.ref;
    const { level, yeargroup, schoolId, amount, term, activityType,feeName } = billedData;

    try {
      // 1. Get matching students
      const studentsSnap = await db
        .collection("students")
        .where("level", "==", level)
        .where("yeargroup", "==", yeargroup)
        .where("schoolId", "==", schoolId)
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
      const { crAccount, crAccountClass, drAccount, drAccountClass, staff,crAccountSubClass,drAccountSubClass } = activityData;

      // 3. Batch ledger entries
      const batch = db.batch();

      studentsSnap.forEach((studentDoc) => {
        const student = studentDoc.data();
        const transactionId = uuidv4();

        // Use billId + studentId for ledger doc ID
              const note = `Being ${feeName} billed  for ${term} Term`;

        const ledgerId = `${event.params.billId}_${studentDoc.id}`;
        const ledgerRef = db.collection("ledger").doc(ledgerId);
        const status=true;
        batch.set(ledgerRef, {
          transactionId,
          studentId: studentDoc.id,
          studentName: student.name || null,
          schoolId,
          activityType,
          feeName,
          term,
          note,
          level,
          staff,
          status,
          yeargroup,
          amount: String(amount), // ensure stored as string
          billedId: event.params.billId,
          createdAt: admin.firestore.FieldValue.serverTimestamp(),
          accounts: {
            debit: {
              account: drAccount ?? null,
              accountClass: drAccountClass ?? null,
              value: String(amount), // string
              subClass:drAccountSubClass??null
            },
            credit: {
              account: crAccount ?? null,
              accountClass: crAccountClass ?? null,
              value: String(amount), // string
              subClass:crAccountSubClass??null
            },
          },
        });
      });

      await batch.commit();

      // Update billed document with success
      await billedRef.update({
        ledgerStatus: "success",
        ledgerMessage: `Ledger created for ${studentsSnap.size} students.`,
      });

      console.log(
        `Ledger created for ${studentsSnap.size} students under ${activityType}.`
      );
    } catch (error) {
      console.error("Error creating ledger entries:", error);
      await snapshot.ref.update({
        ledgerStatus: "failed",
        ledgerMessage: `Error: ${error.message}`,
      });
    }
  }
);



export const updateReportsOnLedger = onDocumentCreated(
  "ledger/{ledgerId}",
  async (event) => {
    const snapshot = event.data;
    if (!snapshot) return;

    const ledger = snapshot.data();
    if (!ledger) return;

    const { schoolId, term, accounts, activityType } = ledger;

    try {
      // === 1. Update Trial Balance ===
      const trialBalanceRef = db
        .collection("trialBalance")
        .doc(`${schoolId}_${term}`);

      await db.runTransaction(async (t) => {
        const trialDoc = await t.get(trialBalanceRef);
        let trialData = trialDoc.exists ? trialDoc.data() : { accounts: {} };

        // Debit account
        if (accounts.debit?.account) {
          const acc = accounts.debit.account;
          const value = parseFloat(accounts.debit.value || "0");
          if (!trialData.accounts[acc]) {
            trialData.accounts[acc] = { debit: 0, credit: 0 };
          }
          trialData.accounts[acc].debit += value;
        }

        // Credit account
        if (accounts.credit?.account) {
          const acc = accounts.credit.account;
          const value = parseFloat(accounts.credit.value || "0");
          if (!trialData.accounts[acc]) {
            trialData.accounts[acc] = { debit: 0, credit: 0 };
          }
          trialData.accounts[acc].credit += value;
        }

        trialData.updatedAt = admin.firestore.FieldValue.serverTimestamp();
        t.set(trialBalanceRef, trialData);
      });

      // === 2. Update Income & Expenditure ===
      const incExpRef = db
        .collection("incomeExpenditure")
        .doc(`${schoolId}_${term}`);

      await db.runTransaction(async (t) => {
        const incDoc = await t.get(incExpRef);
        let incData = incDoc.exists
          ? incDoc.data()
          : { income: 0, expenditure: 0, breakdown: {} };

        // Check debit side → usually Expenditure
        if (accounts.debit?.accountClass === "Expenditure") {
          const value = parseFloat(accounts.debit.value || "0");
          incData.expenditure += value;
          incData.breakdown[accounts.debit.account] =
            (incData.breakdown[accounts.debit.account] || 0) + value;
        }

        // Check credit side → usually Income
        if (accounts.credit?.accountClass === "Income") {
          const value = parseFloat(accounts.credit.value || "0");
          incData.income += value;
          incData.breakdown[accounts.credit.account] =
            (incData.breakdown[accounts.credit.account] || 0) + value;
        }

        incData.updatedAt = admin.firestore.FieldValue.serverTimestamp();
        t.set(incExpRef, incData);
      });

      console.log(
        `Reports updated for school ${schoolId}, term ${term}, activity ${activityType}`
      );
    } catch (error) {
      console.error("Error updating reports:", error);
      await db.collection("errors").add({
        type: "reporting",
        message: error.message,
        ledgerId: event.params.ledgerId,
        schoolId,
        term,
        timestamp: admin.firestore.FieldValue.serverTimestamp(),
      });
    }
  }
);

// === Imports ===
const { onRequest } = require("firebase-functions/v2/https");
const { onDocumentWritten } = require("firebase-functions/v2/firestore");
const logger = require("firebase-functions/logger");
const fetch = require("node-fetch");
const admin = require("firebase-admin");

if (!admin.apps.length) admin.initializeApp();

// === Constants (move secrets to env config in production) ===
const WHATSAPP_TOKEN = "EAAJ5UzelaX8BO7eSHIpv1NNZAlgYxw0caPjzHyRPGdc2YUSOfeC6XmXxeUZCBZBV77pNeKj6J2i7bLyRRvqWLM9qk24lhOhThXvr6h0VZAf158SyIqIRNB47dBlYac8WKLXFcMHCGSTJJzCDbKhMHKwFOkLfSlD7B1idnAPaF5YqiHZAHZCqTy8fXsC8VJyGdwYAZDZD";
const PHONE_NUMBER_ID = "607972565731740";
const VERIFY_TOKEN = "your_custom_verify_token";
const SMS_API_KEY = "SXlMVlJCcmlTV1dwVGRyZkVneUs"; // Replace with your actual API key

// === Helpers ===
async function sendWhatsappMessage(phone, template, messageText, url = "https://kologsoft.com") {
  const payload = {
    messaging_product: "whatsapp",
    to: phone,
    type: "template",
    template: {
      name: template,
      language: { code: "en_US" },
      components: [
        {
          type: "body",
          parameters: [
            { type: "text", text: "John Doe" }, // {{1}}
            { type: "text", text: messageText } // {{2}}
          ]
        },
        {
          type: "button",
          sub_type: "url",
          index: 0,
          parameters: [{ type: "text", text: url }]
        }
      ]
    }
  };

  const response = await fetch(
    `https://graph.facebook.com/v19.0/${PHONE_NUMBER_ID}/messages`,
    {
      method: "POST",
      body: JSON.stringify(payload),
      headers: {
        Authorization: `Bearer ${WHATSAPP_TOKEN}`,
        "Content-Type": "application/json"
      }
    }
  );
  return response.json();
}

async function sendSms(phone, senderId, message) {
  const url = `https://sms.kologsoft.com/sms/api?action=send-sms&api_key=${encodeURIComponent(
    SMS_API_KEY
  )}&to=${encodeURIComponent(phone)}&from=${encodeURIComponent(
    senderId
  )}&sms=${encodeURIComponent(message)}`;

  const response = await fetch(url, { method: "GET" });
  return response.text();
}

// Helper to generate password: email + random 6 digits
function generateEmailPassword(email) {
  const randomDigits = Math.floor(100000 + Math.random() * 900000).toString();
  return randomDigits;
}

// Convert phone number to E.164 format
function toE164(phone) {
  // If phone starts with '+', assume it's already E.164
  if (typeof phone === 'string' && phone.startsWith('+')) return phone;
  // Example: Ghana local numbers (replace '233' with your country code)
  if (typeof phone === 'string') {
    // Remove leading zeros and non-digit characters
    const cleaned = phone.replace(/[^\d]/g, '').replace(/^0+/, '');
    return '+233' + cleaned;
  }
  return phone;
}

// === HTTP Functions ===

// Send WhatsApp notification
exports.metanotification = onRequest(async (req, res) => {
  const { phone, template, messageText } = req.body;
  if (!phone || !template || !messageText) {
    return res.status(400).json({ error: "Missing phone, template, or messageText" });
  }

  try {
    const result = await sendWhatsappMessage(phone, template, messageText);
    res.status(200).json(result);
  } catch (error) {
    res.status(500).json({ error: error.message });
  }
});

// Verify WhatsApp webhook
exports.metaWhatsappVerify = onRequest((req, res) => {
  if (req.method !== "GET") return res.status(405).send("Method Not Allowed");

  const { ["hub.mode"]: mode, ["hub.verify_token"]: token, ["hub.challenge"]: challenge } =
    req.query;

  if (mode === "subscribe" && token === VERIFY_TOKEN) {
    res.status(200).send(challenge);
  } else {
    res.status(403).send("Verification failed");
  }
});

// Send account verification via WhatsApp
exports.sendAccountVerification = onRequest(async (req, res) => {
  const { phone, code } = req.body;
  if (!phone || !code) {
    return res.status(400).json({ error: "Missing phone or code" });
  }

  try {
    const result = await sendWhatsappMessage(phone, "verifaction", code);
    res.status(200).json(result);
  } catch (error) {
    res.status(500).json({ error: error.message });
  }
});

// === Firestore Triggers ===

// SMS Queue
exports.sendSmsOnCreate = onDocumentWritten("smsQueue/{smsId}", async (event) => {
  if (!event.data || event.data.before.exists) return;

  const { phone, senderId, message } = event.data.after.data();
  const smsId = event.params.smsId;
  if (!phone || !senderId || !message) return;

  try {
    const apiResponse = await sendSms(phone, senderId, message);
    await admin.firestore().collection("smsQueue").doc(smsId).update({
      smsApiResponse: apiResponse,
      smsSentAt: admin.firestore.FieldValue.serverTimestamp()
    });
    logger.info("SMS sent", { phone, senderId, message });
  } catch (error) {
    await admin.firestore().collection("smsQueue").doc(smsId).update({
      smsApiError: error.message
    });
    logger.error("SMS send error", { error: error.message, phone, senderId });
  }
});

// WhatsApp Queue
exports.sendWhatsappOnCreate = onDocumentWritten("whatsappQueue/{waId}", async (event) => {
  if (!event.data || event.data.before.exists) return;

  const { phone, template, messageText } = event.data.after.data();
  const waId = event.params.waId;
  if (!phone || !template || !messageText) return;

  try {
    const apiResponse = await sendWhatsappMessage(phone, template, messageText);
    await admin.firestore().collection("whatsappQueue").doc(waId).update({
      whatsappApiResponse: apiResponse,
      whatsappSentAt: admin.firestore.FieldValue.serverTimestamp()
    });
    logger.info("WhatsApp sent", { phone, template, messageText });
  } catch (error) {
    await admin.firestore().collection("whatsappQueue").doc(waId).update({
      whatsappApiError: error.message
    });
    logger.error("WhatsApp send error", { error: error.message, phone, template });
  }
});

// Firestore trigger: Create Firebase Auth user when new staff is added
exports.createStaffAuthAccount = onDocumentWritten("staff/{staffId}", async (event) => {
  // Only run on new document creation
  if (!event.data || event.data.before.exists) return;

  const staffData = event.data.after.data();
  const staffId = event.params.staffId;

  const { email, phone, displayName } = staffData;
  const password = generateEmailPassword(email);
  const phoneE164 = toE164(phone);

  if (!email || !phoneE164) {
    logger.error("Missing required staff fields", { staffId, email, phone });
    return;
  }

  try {
    // Create Firebase Auth user
    const userRecord = await admin.auth().createUser({
      email,
      password,
      phoneNumber: phoneE164,
      displayName: displayName || email.split("@")[0],
      disabled: false,
    });

    // Update staff doc with Auth UID and password (optional, for admin reference)
    await admin.firestore().collection("staff").doc(staffId).update({
      authUid: userRecord.uid,
      accountCreatedAt: admin.firestore.FieldValue.serverTimestamp(),
      password: password // Optional: remove if you don't want to store
    });

    // Add SMS queue message with password
    await admin.firestore().collection("smsQueue").add({
      phone: phoneE164,
      message: `Welcome! Your login password is ${password}`,
      senderId: "KologSoft",
      createdat: admin.firestore.FieldValue.serverTimestamp(),
      status: "pending",
    });

    logger.info("Staff account created and SMS queued", {
      staffId,
      authUid: userRecord.uid,
      email,
      phone: phoneE164,
      password,
    });
  } catch (error) {
    logger.error("Failed to create staff Auth account", {
      error: error.message,
      staffId,
      email,
    });

    // Store error info in Firestore for debugging
    await admin.firestore().collection("staff").doc(staffId).update({
      authError: error.message,
      accountCreatedAt: admin.firestore.FieldValue.serverTimestamp(),
    });
  }
});

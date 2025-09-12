const { onRequest, onCall } = require("firebase-functions/v2/https");
const logger = require("firebase-functions/logger");
const fetch = require('node-fetch');
const { onDocumentWritten } = require("firebase-functions/v2/firestore");
const admin = require('firebase-admin');
const functions = require('firebase-functions');
const nodemailer = require('nodemailer');
const { FieldValue } = require('firebase-admin').firestore;
if (!admin.apps.length) admin.initializeApp();

const WHATSAPP_TOKEN = 'EAAJ5UzelaX8BO7eSHIpv1NNZAlgYxw0caPjzHyRPGdc2YUSOfeC6XmXxeUZCBZBV77pNeKj6J2i7bLyRRvqWLM9qk24lhOhThXvr6h0VZAf158SyIqIRNB47dBlYac8WKLXFcMHCGSTJJzCDbKhMHKwFOkLfSlD7B1idnAPaF5YqiHZAHZCqTy8fXsC8VJyGdwYAZDZD';
const PHONE_NUMBER_ID = '607972565731740';
const VERIFY_TOKEN = 'your_custom_verify_token'; // Set this to your chosen token


exports.metanotification = onRequest(async (req, res) => {
  // Accept POST with JSON body: { phone: "...", template: "...", messageText: "..." }
  const { phone, template, messageText } = req.body;
  if (!phone || !template || !messageText) {
    res.status(400).json({ error: "Missing phone, template, or messageText" });
    return;
  }

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
            { type: "text", text: "John Doe" },      // This will replace {{1}}
            { type: "text", text: "123456" }         // This will replace {{2}}
          ]
        },
        {
          type: "button",
          sub_type: "url",
          index: 0,
          parameters: [
            { type: "text", text: "https://your-verification-link.com" } // URL for the button
          ]
        }
      ]
    }
  };

  try {
    const response = await fetch(`https://graph.facebook.com/v19.0/${PHONE_NUMBER_ID}/messages`, {
      method: 'POST',
      body: JSON.stringify(payload),
      headers: {
        'Authorization': `Bearer ${WHATSAPP_TOKEN}`,
        'Content-Type': 'application/json'
      }
    });
    const result = await response.json();
    res.status(response.status).json(result);
  } catch (error) {
    res.status(500).json({ error: error.message });
  }
});




// Firestore trigger: Send SMS using kologsoft API when a document is created in 'smsQueue' collection
exports.sendSmsOnCreate = onDocumentWritten({document: 'smsQueue/{smsId}'}, async (event) => {
  // Only send SMS on create
  if (!event.data || event.data.before.exists) return;
  const data = event.data.after.data();
  const phone = data.phone;
  const senderId = data.senderId;
  const message = data.message;
  const smsId = event.params.smsId;
  if (!phone || !senderId || !message) return;
  // Kologsoft SMS API details
  const apiKey = 'SXlMVlJCcmlTV1dwVGRyZkVneUs'; // Replace with your actual API key
  const url = `https://sms.kologsoft.com/sms/api?action=send-sms&api_key=${encodeURIComponent(apiKey)}&to=${encodeURIComponent(phone)}&from=${encodeURIComponent(senderId)}&sms=${encodeURIComponent(message)}`;
  let apiResponse = null;
  let apiError = null;
  try {
    const response = await fetch(url, { method: 'GET' });
    apiResponse = await response.text();
    logger.info('SMS sent', { phone, senderId, message, apiResponse });
  } catch (error) {
    apiError = error.message;
    logger.error('SMS send error', { error: apiError, phone, senderId });
  }
  // Store the API response (or error) in the smsQueue document
  try {
    await admin.firestore().collection('smsQueue').doc(smsId).update({
      smsApiResponse: apiResponse,
      smsApiError: apiError,
      smsSentAt: admin.firestore.FieldValue.serverTimestamp(),
    });
  } catch (e) {
    logger.error('Failed to update smsQueue doc with API response', { error: e.message, smsId });
  }
});

// Firestore trigger: Send WhatsApp message using WhatsApp Cloud API when a document is created in 'whatsappQueue' collection
exports.sendWhatsappOnCreate = onDocumentWritten({document: 'whatsappQueue/{waId}'}, async (event) => {
  // Only send WhatsApp message on create
  if (!event.data || event.data.before.exists) return;
  const data = event.data.after.data();
  const phone = data.phone;
  const template = data.template;
  const messageText = data.messageText;
  const waId = event.params.waId;
  if (!phone || !template || !messageText) return;

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
            { type: "text", text: "John Doe" },      // This will replace {{1}}
            { type: "text", text: "123456" }         // This will replace {{2}}
          ]
        },
        {
          type: "button",
          sub_type: "url",
          index: 0,
          parameters: [
            { type: "text", text: "https://your-verification-link.com" } // URL for the button
          ]
        }
      ]
    }
  };

  let apiResponse = null;
  let apiError = null;
  try {
    const response = await fetch(`https://graph.facebook.com/v19.0/${PHONE_NUMBER_ID}/messages`, {
      method: 'POST',
      body: JSON.stringify(payload),
      headers: {
        'Authorization': `Bearer ${WHATSAPP_TOKEN}`,
        'Content-Type': 'application/json'
      }
    });
    apiResponse = await response.json();
    logger.info('WhatsApp sent', { phone, template, messageText, apiResponse });
  } catch (error) {
    apiError = error.message;
    logger.error('WhatsApp send error', { error: apiError, phone, template });
  }
  // Store the API response (or error) in the whatsappQueue document
  try {
    await admin.firestore().collection('whatsappQueue').doc(waId).update({
      whatsappApiResponse: apiResponse,
      whatsappApiError: apiError,
      whatsappSentAt: admin.firestore.FieldValue.serverTimestamp(),
    });
  } catch (e) {
    logger.error('Failed to update whatsappQueue doc with API response', { error: e.message, waId });
  }
});



// Firestore trigger: Verify WhatsApp webhook subscription
exports.metaWhatsappVerify = onRequest((req, res) => {
  if (req.method === 'GET') {
    const mode = req.query['hub.mode'];
    const token = req.query['hub.verify_token'];
    const challenge = req.query['hub.challenge'];

    if (mode && token && mode === 'subscribe' && token === VERIFY_TOKEN) {
      res.status(200).send(challenge);
    } else {
      res.status(403).send('Verification failed');
    }
  } else {
    res.status(405).send('Method Not Allowed');
  }
});

// HTTP function: Send account verification code via WhatsApp
exports.sendAccountVerification = onRequest(async (req, res) => {
  const { phone, code } = req.body;
  if (!phone || !code) {
    res.status(400).json({ error: "Missing phone or code" });
    return;
  }
  const payload = {
    messaging_product: "whatsapp",
    to: phone,
    type: "template",
    template: {
      name: "verifaction", // Replace with your actual template name
      language: { code: "en_US" },
     components: [
  {
    type: "body",
    parameters: [
      { type: "text", text: "John Doe" },      // {{1}}
      { type: "text", text: "123456" }         // {{2}}
    ]
  },
  {
    type: "button",
    sub_type: "url",
    index: 0,
    parameters: [
      { type: "text", text: "https://kologsoft.com" } // The required URL
    ]
  }
]
    }
  };
  try {
    const response = await fetch(`https://graph.facebook.com/v19.0/${PHONE_NUMBER_ID}/messages`, {
      method: 'POST',
      body: JSON.stringify(payload),
      headers: {
        'Authorization': `Bearer ${WHATSAPP_TOKEN}`,
        'Content-Type': 'application/json'
      }
    });
    const result = await response.json();
    res.status(response.status).json(result);
  } catch (error) {
    res.status(500).json({ error: error.message });
  }
});

/// Configure transporter with Gmail
const mailTransport = nodemailer.createTransport({
  service: "gmail",
  auth: {
    user: process.env.GMAIL_EMAIL || "", // fallback in case config not set
    pass: process.env.GMAIL_PASSWORD || "",
  },
});

// Send email function
exports.sendMail = onCall(async (request) => {
  const { to, subject, text, html } = request.data;

  const mailOptions = {
    from: `"KologSoft" <${process.env.GMAIL_EMAIL}>`,
    to,
    subject,
    text,
    html: html || `<p>${text}</p>`,
  };

  try {
    await mailTransport.sendMail(mailOptions);
    return { success: true, message: "Email sent successfully" };
  } catch (error) {
    logger.error("Error sending email:", error);
    return { success: false, error: error.message };
  }
});


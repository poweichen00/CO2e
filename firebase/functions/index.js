const functions = require("firebase-functions");
const admin = require("firebase-admin");
admin.initializeApp();

exports.onUserDeleted = functions.auth.user().onDelete(async (user) => {
  let firestore = admin.firestore();
  let userRef = firestore.doc("users/" + user.uid);
  await firestore.collection("users").doc(user.uid).delete();
});

// ---------------------------------------------------------------------------
// OpenAI chat proxy
//
// The OpenAI API key MUST stay server-side. A key shipped inside the Flutter
// app (mobile or web) can be extracted from the binary by anyone, so the client
// never sees it. The app sends its Firebase ID token; this function verifies the
// caller is a signed-in user, then forwards the chat to OpenAI using the key
// stored in the OPENAI_API_KEY environment variable.
//
// Set the key (never commit it):
//   firebase functions:secrets:set OPENAI_API_KEY
//   # or, for local emulation, put it in functions/.env (git-ignored)
// ---------------------------------------------------------------------------

const OPENAI_MODEL = "ft:gpt-3.5-turbo-1106:personal:traintest2:9sXMKBsk";

exports.chatCompletion = functions
    .runWith({secrets: ["OPENAI_API_KEY"]})
    .https.onRequest(async (req, res) => {
      // CORS (required for the Flutter web build)
      res.set("Access-Control-Allow-Origin", "*");
      res.set("Access-Control-Allow-Methods", "POST, OPTIONS");
      res.set("Access-Control-Allow-Headers", "Authorization, Content-Type");

      if (req.method === "OPTIONS") {
        res.status(204).send("");
        return;
      }
      if (req.method !== "POST") {
        res.status(405).json({error: "Method not allowed"});
        return;
      }

      // 1. Require a valid Firebase ID token.
      const authHeader = req.get("Authorization") || "";
      const match = authHeader.match(/^Bearer (.+)$/);
      if (!match) {
        res.status(401).json({error: "Missing Firebase ID token"});
        return;
      }
      try {
        await admin.auth().verifyIdToken(match[1]);
      } catch (e) {
        res.status(401).json({error: "Invalid Firebase ID token"});
        return;
      }

      // 2. Validate the chat payload.
      const messages = req.body && req.body.messages;
      if (!Array.isArray(messages)) {
        res.status(400).json({error: "Body must contain a 'messages' array"});
        return;
      }

      // 3. Forward to OpenAI with the server-side key.
      const apiKey = process.env.OPENAI_API_KEY;
      if (!apiKey) {
        res.status(500).json({error: "OPENAI_API_KEY is not configured"});
        return;
      }
      try {
        const upstream = await fetch("https://api.openai.com/v1/chat/completions", {
          method: "POST",
          headers: {
            "Content-Type": "application/json",
            "Authorization": `Bearer ${apiKey}`,
          },
          body: JSON.stringify({model: OPENAI_MODEL, messages}),
        });
        const data = await upstream.json();
        res.status(upstream.status).json(data);
      } catch (e) {
        functions.logger.error("OpenAI request failed", e);
        res.status(502).json({error: "Upstream request failed"});
      }
    });

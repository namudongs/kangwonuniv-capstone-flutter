/**
 * Import function triggers from their respective submodules:
 *
 * const {onCall} = require("firebase-functions/v2/https");
 * const {onDocumentWritten} = require("firebase-functions/v2/firestore");
 *
 * See a full list of supported triggers at https://firebase.google.com/docs/functions
 */

// const {onRequest} = require("firebase-functions/v2/https");
// const logger = require("firebase-functions/logger");

// Create and deploy your first functions
// https://firebase.google.com/docs/functions/get-started

// exports.helloWorld = onRequest((request, response) => {
//   logger.info("Hello logs!", {structuredData: true});
//   response.send("Hello from Firebase!");
// });

const functions = require("firebase-functions");
const admin = require("firebase-admin");
admin.initializeApp();

exports.sendPushNotification = functions.https.onRequest(async (req, res) => {
  const userId = req.body.userId; // 요청으로부터 사용자 ID 받기
  const title = req.body.title; // 알림 제목
  const message = req.body.message; // 알림 메시지
  const type = req.body.type; // 알림 타입
  const articleId = req.body.articleId; // 알림을 보낼 게시글 ID

  try {
    // 사용자의 토큰 문서 조회
    const tokenDoc = await admin.firestore()
        .collection("users")
        .doc(userId)
        .collection("tokens")
        .doc("token")
        .get();


    if (!tokenDoc.exists) {
      throw new Error("토큰 문서가 없습니다.");
    }

    const tokenData = tokenDoc.data();
    const token = tokenData ? tokenData.token : null;

    if (!token) {
      throw new Error("토큰이 유효하지 않습니다.");
    }

    // 푸시 알림 데이터
    const payload = {
      notification: {
        title: title,
        body: message,
      },
      data: {
        type: type,
        articleId: articleId,
      },
    };

    // 푸시 알림 전송
    const response = await admin.messaging().sendToDevice(token, payload);

    res.status(200).send(response);
  } catch (error) {
    console.error("(status500)알림 전송에 실패했습니다.:", error);
    res.status(500).send(error);
  }
});

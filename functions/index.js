const fs = require("fs");
const functions = require("firebase-functions");
const admin = require("firebase-admin");
const nodemailer = require("nodemailer");
const axios = require("axios");
axios.defaults.headers.post["Authorization"] =
  "key=AAAA79TIQBg:APA91bHHSzzidwyVGEjlJ1PgQRaUHetxM5Ww0krfBuYEMaeS_BqTHMCgpUKHPzpYrcvWOEz_32zAaXIUq_ahKeniT0yWSq2R-DAGHM1A2bnG57CynjJGqZn7xjxZ4Z4Xo-sS9D_BR4GD";
axios.defaults.headers.post["Content-Type"] = "application/json";

admin.initializeApp({
  storageBucket: "gs://dodact-7ccd3.appspot.com/",
  credential: admin.credential.applicationDefault(),
});
const db = admin.firestore();

//REFS
const postsRef = db.collection("posts");
const usersRef = db.collection("users");
const eventsRef = db.collection("events");
const groupsRef = db.collection("groups");
const invitationsRef = db.collection("invitations");
const tokensRef = db.collection("tokens");
const reportsRef = db.collection("reports");
const spinnerResultsRef = db.collection("spinner_results");
const favoritesRef = db.collection("user_favorites");

//Mail

const mailAddress = "no-reply@dodact.com";
const mailPassword = "$Dodact_159753$";
var mailTransport = nodemailer.createTransport({
  host: "srvc109.turhost.com",
  port: 465,
  secure: true,
  auth: {
    user: mailAddress,
    pass: mailPassword,
  },
});

exports.sendWelcomeEmail = functions.auth.user().onCreate((user) => {
  var welcomeHtmlMail = fs.readFileSync("./welcome.html", "utf-8").toString();
  const recipent_email = user.email;

  const mailOptions = {
    from: `Dodact <no-reply@dodact.com>`,
    to: recipent_email,
    subject: `Dodact'e hoş geldin!`,
    html: welcomeHtmlMail,
  };

  try {
    mailTransport.sendMail(mailOptions);
    console.log("mail sent successfuly");
  } catch (error) {
    console.error("There was an error while sending the email:", error);
  }
});

exports.decrementPostDodders = functions.firestore
  .document("posts/{postId}/dodders/{dodderId}")
  .onDelete((snapshot, context) => {
    const userId = context.params.dodderId;
    const postId = context.params.postId;

    postsRef.doc(postId).update({
      dodCounter: admin.firestore.FieldValue.increment(-1),
    });
  });

exports.sendInvitationNotificationToUser = functions.firestore
  .document("invitations/{invitationId}")
  .onCreate(async (snapshot, context) => {
    const invitationId = context.params.invitationId;
    const invitation = snapshot.data();
    const invitedUserId = invitation.receiverId;

    if (invitation.type == "InvitationType.GroupMembership") {
      //get sender group info
      const groupRef = groupsRef.doc(invitation.senderId);
      const groupSnapshot = await groupRef.get();
      const groupData = groupSnapshot.data();

      // const payload = {
      //   type: "Topluluk Katılım Daveti",
      //   body: groupData.groupName + " tarafından davet edildin.",
      // };



      //send notification to receiver user
      var tokenRef = await tokensRef.doc(invitedUserId).get();
      const tokenObject = tokenRef.data();
      sendNotification("Topluluğa Davet Edildin", groupData.groupName + " tarafından davet edildin.", tokenObject.token, "basic_channel", "Default", null, null);


      // admin.messaging().sendToDevice(tokenObject.token, payload);
    }
  });

exports.addUserToGroup = functions.https.onCall(async (data, context) => {
  const groupId = data.groupId;
  console.log(groupId);

  const userId = data.userId;
  console.log(userId);
  const invitationId = data.invitationId;
  console.log(invitationId);

  const groupRef = groupsRef.doc(groupId);
  const groupSnapshot = await groupRef.get();

  const groupData = groupSnapshot.data();

  if (!groupSnapshot.exists) {
    console.log("Topluluk bulunamadı");
    return {
      result: "GROUP_NOT_FOUND",
    };
  } else {
    if (groupData.groupMemberList.includes(userId)) {
      //delete invitation
      invitationsRef.doc(invitationId).delete();

      return {
        result: "USER_ALREADY_IN_GROUP",
      };
    } else {
      await groupRef.update({
        groupMemberList: admin.firestore.FieldValue.arrayUnion(userId),
      });

      //delete invitation
      invitationsRef.doc(invitationId).delete();

      let payload = {
        notification: {
          title: "Topluluğa başarıyla dahil oldun!",
          body: `${groupData.groupName} ile güzel günlere!`,
          sound: "default",
        },
        // data:{
        //     title: 'Gruba başarıyla dahil oldun!',
        //     body: `${groupData.groupName} ile güzel günlere!`,
        // }
      };

      //send notification to post creator
      var tokenRef = await tokensRef.doc(userId).get();
      const tokenObject = tokenRef.data();
      // admin.messaging().sendToDevice(tokenObject.token, payload);

      sendNotification(
        "Topluluğa başarıyla dahil oldun!",
        `${groupData.groupName} topluluğuna başarıyla dahil oldun. Birlikte sanat dolu günlere!`,
        tokenObject.token,
        "basic_channel",
        "Default",
        payload,
        null
      );

      return {
        result: "USER_ADDED_TO_GROUP",
      };
    }
  }
});

exports.deleteUserData = functions.auth.user().onDelete(async (user) => {
  const userId = user.uid;

  try {
    //0. delete user database entities
    await usersRef
      .doc(userId)
      .delete()
      .then(() => {
        console.log("user firestore data deleted successfuly");
      });

    //1. delete user posts
    const userPosts = await postsRef.where("ownerId", "==", userId).get();
    userPosts.forEach(async (doc) => {
      await postsRef.doc(doc.id).delete();
    });
    console.log("User posts deleted from database");

    //2. delete users group memberships

    //3. delete user invitations

    const userInvitations = await invitationsRef
      .where("receiverId", "==", userId)
      .get();
    userInvitations.forEach(async (doc) => {
      await invitationsRef.doc(doc.id).delete();
    });
    console.log("User invitations deleted from database");

    //4. delete user token
    await tokensRef
      .doc(userId)
      .delete()
      .then(() => {
        console.log("user token deleted successfuly");
      });

    //5. delete user reports
    const userReports = await reportsRef
      .where("reporterId", "==", userId)
      .get();
    userReports.forEach(async (doc) => {
      await reportsRef.doc(doc.id).delete();
    });
    console.log("User reports deleted from database");

    //6. delete user storage files(profile picture)
    try {
      const bucket = admin.storage().bucket();
      await bucket.deleteFiles({
        prefix: `users/${userId}`,
      });
      console.log("User files deleted successfully: " + userId);
    } catch (e) {
      console.log("Error occured while deleting user files: " + userId + e);
    }
    console.log("User storage files deleted from database");

    //7. delete user events

    const userEvents = await eventsRef.where("ownerId", "==", userId).get();
    userEvents.forEach(async (doc) => {
      await eventsRef.doc(doc.id).delete();
    });
    console.log("User events deleted from database");

    //8. delete user messages
    // const userMessages = await messagesRef.where('senderId', '==', userId).get();

    //9. delete user spinner results
    const userSpinnerResults = await spinnerResultsRef
      .where("userId", "==", userId)
      .get();
    userSpinnerResults.forEach(async (doc) => {
      await spinnerResultsRef.doc(doc.id).delete();
    });
    console.log("User spinner results deleted from database");

    //10. delete user favorites

    await favoritesRef
      .doc(userId)
      .delete()
      .then(() => {
        console.log("user favorites deleted successfuly");
      });
  } catch (err) {
    console.log(err);
  }
});

exports.sendNotificationToUser = functions.https.onCall(
  async (data, context) => {
    const userId = data.userId;
    const tokenRef = await tokensRef.doc(userId).get();

    const token = tokenRef.data();

    const payload = {
      notification: {
        title: "Örnek bildirim",
        body: "Örnek bildirim",
        sound: "default",
      },
    };

    const response = await admin
      .messaging()
      .sendToDevice(token.token, payload)
      .then((value) => {
        console.log("Notification sent successfully.");
      })
      .catch((error) => {
        console.log(error);
      });
  }
);

exports.deleteGroupMedia = functions.https.onCall(async (data, context) => {
  var result;
  const mediaUrl = data.url;

  const bucket = admin.storage().bucket();
  await bucket
    .file(mediaUrl)
    .delete()
    .then(() => {
      console.log("Group media deleted successfully: " + mediaUrl);
      result = true;
      return result;
    })
    .catch((error) => {
      console.log(error);
      result = false;
      return result;
    });
});

exports.incrementPostDodders = functions.firestore
  .document("posts/{postId}/dodders/{dodderId}")
  .onCreate((snapshot, context) => {
    const userId = context.params.dodderId;
    const postId = context.params.postId;

    postsRef.doc(postId).update({
      dodCounter: admin.firestore.FieldValue.increment(1),
    });
  });

exports.deletePostFiles = functions.firestore
  .document("posts/{postId}")
  .onDelete(async (snapshot, context) => {
    const postId = context.params.postId;
    const postData = snapshot.data();
    var hasFile = !postData.isLocatedInYoutube;

    if (hasFile) {
      try {
        var bucket = admin.storage().bucket();
        await bucket.deleteFiles({
          prefix: `posts/${postId}`,
        });
        console.log("Post files deleted successfully: " + postId);
      } catch (e) {
        console.log("Error occured while deleting post file: " + postId + e);
      }
    } else {
      console.log("Post has no file: " + postId);
    }
  });

exports.deleteEventFiles = functions.firestore
  .document("events/{eventId}")
  .onDelete(async (snapshot, context) => {
    const eventId = context.params.eventId;
    try {
      var bucket = admin.storage().bucket();
      await bucket.deleteFiles({
        prefix: `events/${eventId}`,
      });
      console.log("Event files deleted successfully: " + eventId);
    } catch (e) {
      console.log("Error occured while deleting event file: " + eventId + e);
    }
  });

exports.checkPostReports = functions.firestore
  .document("reports/{reportId}")
  .onCreate(async (snapshot, context) => {
    const report = snapshot.data();

    if (report.reportedObjectType == "Post") {
      var postId = report.reportedObjectId;

      //Post raporlarını say ve kontrol et, ona göre postu pasif duruma getir
      const postRef = postsRef.doc(postId);
      const postSnapshot = await postRef.get();
      const postData = postSnapshot.data();

      if (postData.reportCounter < 2) {
        postRef.update({
          reportCounter: admin.firestore.FieldValue.increment(1),
        });
      } else {
        await postRef.update({
          visible: false,
        });

        if (postData.ownerType == "User") {
          const payload = {
            notification: {
              title: "Oluşturduğun gönderi incelemeye alındı",
              body: "Oluşturduğun gönderi 3 defa rapor edildiği için gönderi incelemeye alındı.",
              sound: "default",
            },
          };

          //send notification to post creator
          var tokenRef = await tokensRef.doc(postData.ownerId).get();
          const tokenObject = tokenRef.data();
          // admin.messaging().sendToDevice(tokenObject.token, payload);
          sendNotification(
            "Oluşturduğun gönderi incelemeye alındı",
            `${postData.postTitle} başlıklı gönderin çok sayıda bildirildiği için incelemeye alındı ve pasif hali getirildi.`,
            tokenObject.token,
            "basic_channel",
            "Default",
            payload,
            null
          );
        }
        //Postu oluşturan kişi grup ise, grup kurucusunun bilgileri alınır ve ona token gönderilir.
        else {
          const groupRef = groupsRef.doc(postData.ownerId);
          const groupSnapshot = await groupRef.get();
          const groupData = groupSnapshot.data();

          const payload = {
            notification: {
              title: "Oluşturduğun gönderi incelemeye alındı",
              body: "Oluşturduğun gönderi 3 defa rapor edildiği için gönderi incelemeye alındı.",
              sound: "default",
            },
          };

          //send notification to post creator
          var tokenRef = await tokensRef.doc(groupData.founderId).get();
          const tokenObject = tokenRef.data();
          sendNotification(
            "Oluşturduğun gönderi incelemeye alındı",
            `${postData.postTitle} başlıklı gönderin çok sayıda bildirildiği için incelemeye alındı ve pasif hali getirildi.`,
            tokenObject.token,
            "basic_channel",
            "Default",
            payload,
            null
          );


        }
      }
    }
  });

exports.commentNotificationToCreator = functions.firestore
  .document("posts/{postId}/comments/{commentId}")
  .onCreate(async (snapshot, context) => {
    const comment = snapshot.data();
    const postId = context.params.postId;
    const commentId = context.params.commentId;

    const postRef = postsRef.doc(postId);
    const postSnapshot = await postRef.get();
    const postData = postSnapshot.data();

    if (postData.ownerType == "User") {
      const userRef = usersRef.doc(postData.ownerId);
      const userSnapshot = await userRef.get();
      const userData = userSnapshot.data();

      if (
        userData.notificationSettings["allow_comment_notifications"] == true
      ) {
        const payload = {
          notification: {
            title: `Gönderine yorum yapıldı.`,
            body: `${postData.postTitle} başlıklı içeriğine yorum yapıldı.`,
            sound: "default",
          },
        };

        //send notification to post creator
        var tokenRef = await tokensRef.doc(postData.ownerId).get();
        const tokenObject = tokenRef.data();

        sendNotification("Gönderine yorum yapıldı", `${postData.postTitle} başlıklı gönderine yorum yapıldı.`, tokenObject.token, "basic_channel", "Default", null, null);

        // admin.messaging().sendToDevice(tokenObject.token, payload);
      }
    } else {
      const groupRef = groupsRef.doc(postData.ownerId);
      const groupSnapshot = await groupRef.get();
      const groupData = groupSnapshot.data();

      const founderUserRef = usersRef.doc(groupData.founderId);
      const founderUserSnapshot = await founderUserRef.get();
      const founderUserData = founderUserSnapshot.data();

      if (
        founderUserData.notificationSettings[
          "allow_group_comment_notifications"
        ] == true
      ) {
        const payload = {
          notification: {
            title: `Topluluğunun gönderisine yorum yapıldı.`,
            body: `${postData.postTitle} başlıklı topluluk gönderisine yorum yapıldı.`,
            sound: "default",
          },
        };

        //send notification to post creator
        var tokenRef = await tokensRef.doc(groupData.founderId).get();
        const tokenObject = tokenRef.data();
        sendNotification(`Topluluğunun gönderisine yorum yapıldı.`, `${postData.postTitle} başlıklı topluluk gönderisinde yorum yapıldı.`, tokenObject.token, "basic_channel", "Default", null, null, );
      }
      //TODO: Notificationlara kaydet
    }
  });

exports.messageReceiverNotification = functions.firestore
  .document("chatrooms/{user_ids}/messages/{messageId}")
  .onCreate(async (snapshot, context) => {
    const userIDs = context.params.user_ids.split("_");

    const message = snapshot.data();

    const firstUserId = userIDs[0];
    const secondUserId = userIDs[1];

    const receiverId =
      message.senderId != firstUserId ? firstUserId : secondUserId;
    const senderId = message.senderId;

    console.log("receiver:" + receiverId + " senderId:" + senderId);

    const receiverIdRef = usersRef.doc(receiverId);
    const receiverUserSnapshot = await receiverIdRef.get();
    const receiverUserData = receiverUserSnapshot.data();

    if (
      receiverUserData.notificationSettings[
        "allow_private_message_notifications"
      ] == true
    ) {
      const senderUserRef = usersRef.doc(senderId);
      const senderUserSnapshot = await senderUserRef.get();
      const senderUserData = senderUserSnapshot.data();

      //send notification to receiver
      var tokenRef = await tokensRef.doc(receiverId).get();
      const tokenObject = tokenRef.data();

      const payload = {
        type: "message",
        from: senderUserData.uid,
      };
      const actionButtons = [{
        key: "REPLY",
        label: "Cevapla",
        autoDismissable: true,
        buttonType: "InputField",
      }, ];
      sendNotification(
        senderUserData.nameSurname,
        message.message,
        tokenObject.token,
        "basic_channel",
        "Default",
        payload,
        null
      );

      // admin.messaging().sendToDevice(tokenObject.token, payload);
    }
  });

function getRandomInt(max) {
  return Math.floor(Math.random() * max);
}

sendNotificationToUser = async (userId, payload) => {
  var tokenRef = await tokensRef.doc(userId).get();
  const tokenObject = tokenRef.data();
  admin.messaging().sendToDevice(tokenObject.token, payload);
};

deleteInvitation = async (invitationId) => {
  const invitationRef = invitationsRef.doc(invitationId);
  const invitation = await invitationRef.get();

  if (invitation.exists) {
    invitationRef.delete();
  }
};

function sendNotification(
  title,
  body,
  token,
  channel,
  layout,
  payload,
  actionButtons
) {
  const notification = {
    to: token,
    click_action: "FLUTTER_NOTIFICATION_CLICK",
    data: {
      click_action: "FLUTTER_NOTIFICATION_CLICK",
      content: {
        id: getRandomInt(999999),
        title: title,
        body: body,
        channelKey: channel,
        notificationLayout: layout,
        payload: payload,
      },
      actionButtons: actionButtons,
    },
    mutable_content: true,
    content_available: true,
    priority: "high",
  };

  axios
    .post("https://fcm.googleapis.com/fcm/send", notification)
    .then((res) => {
      console.log(`Notification "${title}" status: ${res.status}`);
      // console.log(payload);
      // console.log(res);
    })
    .catch((error) => {
      console.error(error);
    });
}

function sendNotificationTopic(
  title,
  body,
  topic,
  channel,
  layout,
  payload,
  actionButtons
) {
  const notification = {
    to: `/topics/${topic}`,
    click_action: "FLUTTER_NOTIFICATION_CLICK",
    data: {
      click_action: "FLUTTER_NOTIFICATION_CLICK",
      content: {
        id: getRandomInt(999999),
        title: title,
        body: body,
        channelKey: channel,
        notificationLayout: layout,
        payload: payload,
      },
      actionButtons: actionButtons,
    },
    mutable_content: true,
    content_available: true,
    priority: "high",
  };

  axios
    .post("https://fcm.googleapis.com/fcm/send", notification)
    .then((res) => {
      console.log(`Notification "${title}" status: ${res.status}`);
      // console.log(payload);
      // console.log(res);
    })
    .catch((error) => {
      console.error(error);
    });
}

// exports.deletePost = functions.firestore.document('posts/{postId}').onDelete((snapshot, context) => {
//     const postId = context.params.postId;
//     var post = snapshot.data();

//     //delete storage files for post

//     const storage = new Storage();
//     const bucket = storage.bucket(functions.config().firebase.storageBucket);
//     bucket.deleteFiles({
//         prefix: `posts/${postId}/`
//     });
// });
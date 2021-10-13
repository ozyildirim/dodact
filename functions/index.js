const fs = require('fs');
const functions = require('firebase-functions');
const admin = require('firebase-admin');
const {
    Storage
} = require("@google-cloud/storage");
const nodemailer = require('nodemailer');

admin.initializeApp({
    storageBucket: "gs://dodact-7ccd3.appspot.com/",
    credential: admin.credential.applicationDefault()
});
const db = admin.firestore();

//REFS
const postsRef = db.collection('posts');
const usersRef = db.collection('users');
const groupsRef = db.collection('groups');
const invitationsRef = db.collection('invitations');
const tokensRef = db.collection('tokens');
const reportsRef = db.collection('reports');


//Mail

const mailAddress = 'no-reply@dodact.com';
const mailPassword = '$Dodact_159753$';
var mailTransport = nodemailer.createTransport({
    host: 'srvc109.turhost.com',
    port: 465,
    secure: true,
    auth: {
        user: mailAddress,
        pass: mailPassword
    }
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
        console.log('mail sent successfuly');

    } catch (error) {
        console.error('There was an error while sending the email:', error);
    }
});




exports.decrementPostDodders = functions.
firestore.document('posts/{postId}/dodders/{dodderId}')
    .onDelete((snapshot, context) => {
        const userId = context.params.dodderId;
        const postId = context.params.postId;

        postsRef.doc(postId).update({
            'dodCounter': admin.firestore.FieldValue.increment(-1)
        });
    });


exports.sendInvitationNotificationToUser = functions.firestore.document('invitations/{invitationId}')
    .onCreate(async (snapshot, context) => {
        const invitationId = context.params.invitationId;
        const invitation = snapshot.data();
        const invitedUserId = invitation.receiverId;


        if (invitation.type == "InvitationType.GroupMembership") {
            //get sender group info
            const groupRef = groupsRef.doc(invitation.senderId);
            const groupSnapshot = await groupRef.get();
            const groupData = groupSnapshot.data();

            const payload = {
                notification: {
                    title: 'Grup Katılım Daveti',
                    body: groupData.groupName + ' tarafından davet edildin.'
                }
            };

            //send notification to receiver user
            var tokenRef = await tokensRef.doc(invitedUserId).get();
            const tokenObject = tokenRef.data();
            admin.messaging().sendToDevice(tokenObject.token, payload)

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
        console.log("Grup bulunamadı");
        return {
            result: 'GROUP_NOT_FOUND'
        }

    } else {
        if (groupData.groupMemberList.includes(userId)) {

            //delete invitation
            invitationsRef.doc(invitationId).delete();

            return {
                result: 'USER_ALREADY_IN_GROUP'
            }
        } else {
            await groupRef.update({
                'groupMemberList': admin.firestore.FieldValue.arrayUnion(userId)
            });

            //delete invitation
            invitationsRef.doc(invitationId).delete();


            let payload = {
                notification: {
                    title: 'Gruba başarıyla dahil oldun!',
                    body: `${groupData.groupName} ile güzel günlere!`,
                    sound: "default",
                },
                // data:{
                //     title: 'Gruba başarıyla dahil oldun!',
                //     body: `${groupData.groupName} ile güzel günlere!`,
                // }
            }

            //send notification to post creator
            var tokenRef = await tokensRef.doc(userId).get();
            const tokenObject = tokenRef.data();
            admin.messaging().sendToDevice(tokenObject.token, payload)
            return {
                result: 'USER_ADDED_TO_GROUP'
            }
        }
    }
})

exports.sendNotificationToUser = functions.https.onCall(async (data, context) => {
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
        .sendToDevice(token.token, payload).then((value) => {
            console.log("Notification sent successfully.");
        }).catch((error) => {
            console.log(error);
        });
})



exports.incrementPostDodders = functions.
firestore.document('posts/{postId}/dodders/{dodderId}')
    .onCreate((snapshot, context) => {
        const userId = context.params.dodderId;
        const postId = context.params.postId;

        postsRef.doc(postId).update({
            'dodCounter': admin.firestore.FieldValue.increment(1)
        });
    });



exports.deletePostFiles = functions.
firestore.document('posts/{postId}').onDelete(async (snapshot, context) => {
    const postId = context.params.postId;
    const postData = snapshot.data();
    var hasFile = !postData.isLocatedInYoutube;

    if (hasFile) {
        try {
            var bucket = admin.storage().bucket();
            await bucket.deleteFiles({
                prefix: `posts/${postId}`
            });
            console.log('Post files deleted successfully: ' + postId);
        } catch (e) {
            console.log("Error occured while deleting post file: " + postId + e);
        }
    } else {
        console.log('Post has no file: ' + postId);
    }
});

exports.deleteEventFiles = functions.
firestore.document('events/{eventId}').onDelete(async (snapshot, context) => {
    const eventId = context.params.eventId;
    try {
        var bucket = admin.storage().bucket();
        await bucket.deleteFiles({
            prefix: `events/${eventId}`
        });
        console.log('Event files deleted successfully: ' + eventId);
    } catch (e) {
        console.log("Error occured while deleting event file: " + eventId + e);
    }
});

exports.checkPostReports = functions.
firestore.document('reports/{reportId}')
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
                    'reportCounter': admin.firestore.FieldValue.increment(1)
                });
            } else {
                await postRef.update({
                    'visible': false
                });

                if (postData.ownerType == "User") {
                    const payload = {
                        notification: {
                            title: 'Oluşturduğun içerik incelemeye alındı',
                            body: 'Oluşturduğun içerik 3 defa rapor edildiği için içerik incelemeye alındı.',
                            sound: "default",
                        }
                    }

                    //send notification to post creator
                    var tokenRef = await tokensRef.doc(postData.ownerId).get();
                    const tokenObject = tokenRef.data();
                    admin.messaging().sendToDevice(tokenObject.token, payload)
                }
                //Postu oluşturan kişi grup ise, grup kurucusunun bilgileri alınır ve ona token gönderilir.
                else {
                    const groupRef = groupsRef.doc(postData.ownerId);
                    const groupSnapshot = await groupRef.get();
                    const groupData = groupSnapshot.data();

                    const payload = {
                        notification: {
                            title: 'Oluşturduğun içerik incelemeye alındı',
                            body: 'Oluşturduğun içerik 3 defa rapor edildiği için içerik incelemeye alındı.',
                            sound: "default",
                        }
                    }

                    //send notification to post creator
                    var tokenRef = await tokensRef.doc(groupData.founderId).get();
                    const tokenObject = tokenRef.data();
                    admin.messaging().sendToDevice(tokenObject.token, payload)

                    sendNo
                }
            }
        }
    });

exports.commentNotificationToCreator = functions.firestore.document('posts/{postId}/comments/{commentId}').onCreate(async (snapshot, context) => {
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

        if (userData.notificationSettings['allow_comment_notifications'] == true) {
            const payload = {
                notification: {
                    title: `İçeriğine yorum yapıldı.`,
                    body: `${postData.postTitle} başlıklı içeriğine yorum yapıldı.`,
                    sound: "default",
                }
            }

            //send notification to post creator
            var tokenRef = await tokensRef.doc(postData.ownerId).get();
            const tokenObject = tokenRef.data();
            admin.messaging().sendToDevice(tokenObject.token, payload);
        }
    } else {
        const groupRef = groupsRef.doc(postData.ownerId);
        const groupSnapshot = await groupRef.get();
        const groupData = groupSnapshot.data();

        const founderUserRef = usersRef.doc(groupData.founderId);
        const founderUserSnapshot = await founderUserRef.get();
        const founderUserData = founderUserSnapshot.data();

        if (founderUserData.notificationSettings['allow_group_comment_notifications'] == true) {
            const payload = {
                notification: {
                    title: `Grubunun içeriğine yorum yapıldı.`,
                    body: `${postData.postTitle} başlıklı grup içeriğine yorum yapıldı.`,
                    sound: "default",
                }
            }

            //send notification to post creator
            var tokenRef = await tokensRef.doc(groupData.founderId).get();
            const tokenObject = tokenRef.data();
            admin.messaging().sendToDevice(tokenObject.token, payload)
        }
        //TODO: Notificationlara kaydet
    }
});


exports.messageReceiverNotification = functions.firestore.document('chatrooms/{user_ids}/messages/{messageId}').onCreate(async (snapshot, context) => {

    const userIDs = context.params.user_ids.split("_");

    const message = snapshot.data();

    const firstUserId = userIDs[0];
    const secondUserId = userIDs[1];


    const receiverId = message.senderId != firstUserId ? firstUserId : secondUserId;
    const senderId = message.senderId;

    console.log("receiver:" + receiverId + " senderId:" + senderId);

    const receiverIdRef = usersRef.doc(receiverId);
    const receiverUserSnapshot = await receiverIdRef.get();
    const receiverUserData = receiverUserSnapshot.data();



    if (receiverUserData.notificationSettings['allow_private_message_notifications'] == true) {
        const senderUserRef = usersRef.doc(senderId);
        const senderUserSnapshot = await senderUserRef.get();
        const senderUserData = senderUserSnapshot.data();

        const payload = {
            notification: {
                title: `${senderUserData.nameSurname}`,
                body: `${message.message}`,
                sound: "default",
            }
        }

        //send notification to receiver
        var tokenRef = await tokensRef.doc(receiverId).get();
        const tokenObject = tokenRef.data();
        admin.messaging().sendToDevice(tokenObject.token, payload)
    }
});





sendNotificationToUser = async (userId, payload) => {
    var tokenRef = await tokensRef.doc(userId).get();
    const tokenObject = tokenRef.data();
    admin.messaging().sendToDevice(tokenObject.token, payload)
}

deleteInvitation = async (invitationId) => {
    const invitationRef = invitationsRef.doc(invitationId);
    const invitation = await invitationRef.get();

    if (invitation.exists) {
        invitationRef.delete();
    }
};




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
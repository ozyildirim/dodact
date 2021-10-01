const fs = require('fs');
const functions = require('firebase-functions');
const admin = require('firebase-admin');
const {
    Storage
} = require("@google-cloud/storage");
const nodemailer = require('nodemailer');

admin.initializeApp({
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


exports.incrementPostDodders = functions.
firestore.document('posts/{postId}/dodders/{dodderId}')
    .onCreate((snapshot, context) => {
        const userId = context.params.dodderId;
        const postId = context.params.postId;

        postsRef.doc(postId).update({
            'dodCounter': admin.firestore.FieldValue.increment(1)
        });
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

exports.addUserToGroup = functions.https.onCall(async (req, res) => {
    const groupId = req.query.groupId;
    const userId = req.query.userId;
    const invitationId = req.query.invitationId;

    const groupRef = groupsRef.doc(groupId);
    const userRef = usersRef.doc(userId);

    const group = await groupRef.doc(groupId).get();
    const user = await userRef.doc(userId).get();

    if (!group.exists) {
        res.status(404).send('GROUP_NOT_FOUND');
    } else if (!user.exists) {
        res.status(404).send('USER_NOT_FOUND');
    } else {
        const groupData = group.data();
        const userData = user.data();

        if (groupData.groupMemberList.includes(userId)) {
            res.status(400).send('USER_ALREADY_IN_GROUP');
            await deleteInvitation(invitationId);
        } else {
            await groupRef.update({
                'groupMemberList': admin.firestore.FieldValue.arrayUnion(userId)
            });

            res.status(200).send('USER_ADDED_TO_GROUP');
            await deleteInvitation(invitationId);

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
            sendNotificationToUser(userId, payload);

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
                            title: 'Oluşturduğun içerikle alakalı',
                            body: 'Oluşturduğun içerik 3 defa rapor edildiği için içerik incelemeye alındı.',
                            sound: "default",
                        }
                    }
                    this.sendNotificationToUser(postData.ownerId, payload);
                }
                //Postu oluşturan kişi grup ise, grup kurucusunun bilgileri alınır ve ona token gönderilir.
                else {
                    const groupRef = groupsRef.doc(postData.ownerId);
                    const groupSnapshot = await groupRef.get();
                    const groupData = groupSnapshot.data();

                    const payload = {
                        notification: {
                            title: 'Oluşturduğun içerikle alakalı',
                            body: 'Oluşturduğun içerik 3 defa rapor edildiği için içerik incelemeye alındı.',
                            sound: "default",
                        }
                    }
                    sendNotificationToUser(groupData.founderId, payload);
                }
            }
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
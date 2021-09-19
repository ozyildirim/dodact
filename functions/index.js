const functions = require('firebase-functions');
const admin = require('firebase-admin');
const {
    Storage
} = require("@google-cloud/storage");

admin.initializeApp();
const db = admin.firestore();

const postsRef = db.collection('posts');
const usersRef = db.collection('users');
const groupsRef = db.collection('groups');
const requestsRef = db.collection('requests');



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


// exports.deletePost = functions.firestore.document('posts/{postId}').onDelete((snapshot, context) => {
//     const postId = context.params.postId;
//     var post = snapshot.data();

//     //delete request for post
//     const requestRef = requestsRef.where('subjectId', '==', postId).get();
//     requestRef.forEach(async (doc) => {
//         await doc.ref.delete();
//     });


//     //delete storage files for post

//     const storage = new Storage();
//     const bucket = storage.bucket(functions.config().firebase.storageBucket);
//     bucket.deleteFiles({
//         prefix: `posts/${postId}/`
//     });
// });
const functions = require('firebase-functions');
const admin = require('firebase-admin');
admin.initializeApp();
const db = admin.firestore();

const postRef = db.collection('posts');
const usersRef = db.collection('users');
const groupsRef = db.collection('groups');


exports.likePost = functions.https.onRequest(async (req, res) => {
    
});


// If the number of likes gets deleted, recount the number of likes
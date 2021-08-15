const functions = require('firebase-functions');
const admin = require('firebase-admin');
admin.initializeApp();


// If the number of likes gets deleted, recount the number of likes
exports.countlikechange = functions.firestore.document('posts/{docId}/supportersId/{supporterId}').onWrite(async (change) => {
    const collectionRef = change.after.ref.parent;
    const countRef = collectionRef.parent.child('dodCounter');

    let increment;
    if (change.after.exists() && !change.before.exists()) {
        increment = 1;
    } else if (!change.after.exists() && change.before.exists()) {
        increment = -1;
    } else {
        return null;
    }

    // Return the promise from countRef.transaction() so our function
    // waits for this async event to complete before it exits.
    await countRef.transaction((current) => {
        return (current || 0) + increment;
    });
    functions.logger.log('Counter updated.');
    return null;
});


// If the number of likes gets deleted, recount the number of likes
exports.recountlikes = functions.firestore.document('posts/{docId}/supportersId/{supporterId}').onDelete(async (snap) => {
    const counterRef = snap.ref;
    const collectionRef = counterRef.parent.child('likes');

    // Return the promise from counterRef.set() so our function
    // waits for this async event to complete before it exits.
    const messagesData = await collectionRef.once('value');
    return await counterRef.set(messagesData.numChildren());
});
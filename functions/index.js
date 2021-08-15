const functions = require('firebase-functions');
const admin = require('firebase-admin');
admin.initializeApp();


// If the number of likes gets deleted, recount the number of likes
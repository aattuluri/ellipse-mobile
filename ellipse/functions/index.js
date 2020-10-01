const functions = require('firebase-functions');
const admin = require('firebase-admin');
admin.initializeApp();

exports.sendNotification = functions.https.onRequest(async (req,res) => {
    // const password = req.query.password;
    // if(password === "1234"){
    const title = req.query.title;
    const userToken = req.query.token;
    const messageText = req.query.message;
    console.log(messageText);
    const payload = {
        notification:{
            title: title,
            body: messageText
        }
    };
    const response = await admin.messaging().sendToDevice(userToken,payload);
    response.results.forEach((result,index)=>{
        const error = result.error;
        if(error){
          console.error('Failure sending notification to', userToken[index], error);
        }
    });
    res.end();
// }
// else{
//     res.end();
// }
    // return res.result.toString();
});

// // Create and Deploy Your First Cloud Functions
// // https://firebase.google.com/docs/functions/write-firebase-functions
//
// exports.helloWorld = functions.https.onRequest((request, response) => {
//  response.send("Hello from Firebase!");
// });


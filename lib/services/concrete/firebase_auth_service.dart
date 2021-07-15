import 'package:dodact_v1/config/constants/firebase_constants.dart';
import 'package:dodact_v1/model/user_model.dart';
import 'package:dodact_v1/services/abstract/auth_base.dart';
import 'package:firebase_auth/firebase_auth.dart';

import 'package:google_sign_in/google_sign_in.dart';

class FirebaseAuthService implements AuthBase {
  final FirebaseAuth _firebaseAuth = FirebaseAuth.instance;

  @override
  Future<UserObject> currentUser() async {
    try {
      User user = await _firebaseAuth.currentUser;
      return _userFromFirebase(user);
    } catch (e) {
      print("FirebaseAuthService currentUser error: " + e.toString());
    }
  }

  UserObject _userFromFirebase(User user) {
    if (user == null) {
      return null;
    }
    return UserObject(uid: user.uid, email: user.email);
  }

  @override
  Future<UserObject> signInAnonymously() async {
    try {
      UserCredential result = await _firebaseAuth.signInAnonymously();
      return _userFromFirebase(result.user);
    } catch (e) {
      print("FirebaseAuthService signInAnonymously error:" + e.toString());
      return null;
    }
  }

  @override
  Future<bool> signOut() async {
    //user must sign out from all these providers(google,facebook etc.)
    await _firebaseAuth.signOut();
    GoogleSignIn _googleSignIn = GoogleSignIn();
    await _googleSignIn.signOut();
    print("User signed out.");
    return true;
  }

  @override
  Future<UserObject> signInWithGoogle() async {
    GoogleSignIn _google = GoogleSignIn();
    GoogleSignInAccount _gUser = await _google.signIn();

    if (_gUser != null) {
      GoogleSignInAuthentication _googleAuth = await _gUser.authentication;
      if (_googleAuth.idToken != null && _googleAuth.accessToken != null) {
        UserCredential result = await _firebaseAuth.signInWithCredential(
            GoogleAuthProvider.credential(
                idToken: _googleAuth.idToken,
                accessToken: _googleAuth.accessToken));
        User _user = result.user;
        print("User logged in by Google account.");
        return _userFromFirebase(_user);
      }
    } else {
      return null;
    }
  }

  // @override
  // Future<UserObject> signInWithFacebook() async {
  //   final _facebookLogin = FacebookLogin();
  //
  //   FacebookLoginResult _facebookResult =
  //       await _facebookLogin.logIn(["public_profile", "email"]);
  //
  //   switch (_facebookResult.status) {
  //     case FacebookLoginStatus.loggedIn:
  //       if (_facebookResult.accessToken != null) {
  //         UserCredential _firebaseResult = await _firebaseAuth
  //             .signInWithCredential(FacebookAuthProvider.credential(
  //                 _facebookResult.accessToken.token));
  //
  //         User _user = _firebaseResult.user;
  //         return _userFromFirebase(_user);
  //       }
  //
  //       break;
  //
  //     case FacebookLoginStatus.cancelledByUser:
  //       print("User cancelled login by Facebook.");
  //       break;
  //     case FacebookLoginStatus.error:
  //       print("Error: " + _facebookResult.errorMessage);
  //       break;
  //   }
  // }

  @override
  Future<UserObject> createAccountWithEmailAndPassword(
      String email, String password) async {
    UserCredential result = await _firebaseAuth.createUserWithEmailAndPassword(
        email: email, password: password);
    UserObject user = _userFromFirebase(result.user);
    if (user != null) {
      return user;
    } else {
      return null;
    }
  }

  @override
  Future<UserObject> signInWithEmail(String email, String password) async {
    UserCredential result = await _firebaseAuth.signInWithEmailAndPassword(
        email: email, password: password);
    UserObject user = _userFromFirebase(result.user);
    if (user != null) {
      return user;
    } else {
      return null;
    }
  }

  Future<void> forgotPassword(String email) async {
    return await _firebaseAuth.sendPasswordResetEmail(email: email);
  }

  Future<UserObject> getUserByID(String userId) async {
    var userObjectDoc = await usersRef.doc(userId).get();
    return UserObject.fromDoc(userObjectDoc);
  }

  Future<void> changeEmail(String newEmail) async {
    try {
      if (_firebaseAuth.currentUser != null) {
        await _firebaseAuth.currentUser.updateEmail(newEmail);
      }
    } catch (e) {
      print(e);
    }
  }

  Future<void> updatePassword(String pass) async {
    if (_firebaseAuth.currentUser != null) {
      await _firebaseAuth.currentUser.updatePassword(pass);
    }
  }

  Future<void> updateCurrentUser(
      Map<String, dynamic> newData, String uid) async {
    await usersRef.doc(uid).update(newData);
  }
}

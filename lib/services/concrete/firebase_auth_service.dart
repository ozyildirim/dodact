import 'package:dodact_v1/common/methods.dart';
import 'package:dodact_v1/config/constants/firebase_constants.dart';
import 'package:dodact_v1/config/navigation/navigation_service.dart';
import 'package:dodact_v1/model/user_model.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/widgets.dart';
import 'package:google_sign_in/google_sign_in.dart';

class FirebaseAuthService {
  final FirebaseAuth _firebaseAuth = FirebaseAuth.instance;

  User currentUser() {
    try {
      User user = _firebaseAuth.currentUser;
      return user;
    } catch (e) {
      print("FirebaseAuthService currentUser error: " + e.toString());
      return null;
    }
  }

  Future<bool> signOut() async {
    //user must sign out from all these providers(google,facebook etc.)
    await _firebaseAuth.signOut();
    GoogleSignIn _googleSignIn = GoogleSignIn();
    await _googleSignIn.signOut();
    print("User signed out.");
    return true;
  }

  Future<User> signInWithGoogle(BuildContext context) async {
    final GoogleSignIn googleSignIn = GoogleSignIn();

    final GoogleSignInAccount googleSignInAccount = await googleSignIn.signIn();

    CommonMethods().showLoaderDialog(context, "Lütfen Bekleyin");

    if (googleSignInAccount != null) {
      final GoogleSignInAuthentication googleSignInAuthentication =
          await googleSignInAccount.authentication;

      final AuthCredential credential = GoogleAuthProvider.credential(
        accessToken: googleSignInAuthentication.accessToken,
        idToken: googleSignInAuthentication.idToken,
      );

      try {
        final UserCredential userCredential =
            await _firebaseAuth.signInWithCredential(credential);

        var user = userCredential.user;
        NavigationService.instance.pop();
        return user;
      } on FirebaseAuthException catch (e) {
        if (e.code == 'account-exists-with-different-credential') {
          // handle the error here
        } else if (e.code == 'invalid-credential') {
          // handle the error here
        }
        NavigationService.instance.pop();
      } catch (e) {
        // handle the error here
      }
    } else {
      NavigationService.instance.pop();
      return null;
    }
  }

  Future<User> createAccountWithEmailAndPassword(
      String email, String password) async {
    UserCredential result = await _firebaseAuth.createUserWithEmailAndPassword(
        email: email, password: password);

    User user = result.user;

    try {
      if (user != null) {
        await result.user.sendEmailVerification();
        print("verif maili gönderildi");
        return user;
      } else {
        return null;
      }
    } catch (e) {
      print("hata: $e");
    }
  }

  Future<User> signInWithEmail(String email, String password) async {
    UserCredential result = await _firebaseAuth.signInWithEmailAndPassword(
        email: email, password: password);

    if (result.user.emailVerified) {
      return result.user;
    } else {
      _firebaseAuth.signOut();
      throw FirebaseAuthException(code: 'email-not-verified');
    }
  }

  Future<void> forgotPassword(String email) async {
    return await _firebaseAuth.sendPasswordResetEmail(email: email);
  }

  Future<UserObject> getUserByID(String userId) async {
    var userObjectDoc = await usersRef.doc(userId).get();
    return UserObject.fromDoc(userObjectDoc);
  }

  Future<void> updateEmail(String newEmail) async {
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

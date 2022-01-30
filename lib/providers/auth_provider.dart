import 'dart:io';

import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:myref/models/user_model.dart';
import 'package:myref/utils/encrypt.dart';


enum Status {
  unInitialized,
  authenticated,
  authenticating,
  unAuthenticated,
  registering,
  registered
}
/*
The UI will depends on the Status to decide which screen/action to be done.
- unInitialized - Checking user is logged or not, the Splash Screen will be shown
- authenticated - User is authenticated successfully, Home Page will be shown
- authenticating - Sign In button just been pressed, progress bar will be shown
- unAuthenticated - User is not authenticated, login page will be shown
- registering - User just pressed registering, progress bar will be shown
- registered - User success to registering
Take note, this is just an idea. You can remove or further add more different
status for your UI or widgets to listen.
 */

class AuthProvider extends ChangeNotifier {
  //Firebase Auth object
  late FirebaseAuth _auth;

  //Default status
  Status _status = Status.unInitialized;

  Status get status => _status;

  Stream<UserModel> get user => _auth.authStateChanges().map(_userFromFirebase);

  // Secure Storage
  static const storage = FlutterSecureStorage();

  AuthProvider() {
    //initialise object
    _auth = FirebaseAuth.instance;

    //listener for authentication changes such as user sign in and sign out
    // 직접 컨트롤
    // _auth.authStateChanges().listen(onAuthStateChanged);

  }

  //Create user object based on the given User
  UserModel _userFromFirebase(User? user) {
    if (user == null) {
      return UserModel(uid: 'null');
    }

    return UserModel(
        uid: user.uid,
        email: user.email
    );
  }

  //Method to detect live auth changes such as user sign in and sign out
  Future<void> onAuthStateChanged(User? firebaseUser) async {
    if (firebaseUser == null) {
      _status = Status.unAuthenticated;
    } else {
      _userFromFirebase(firebaseUser);
      _status = Status.authenticated;
    }
    notifyListeners();
  }

  //Method for new user registration using email and password
  Future<UserModel> registerWithEmailAndPassword(
      String email, String password) async {
    try {
      _status = Status.registering;
      notifyListeners();
      final UserCredential result = await _auth.createUserWithEmailAndPassword(
          email: email, password: password);
      _status = Status.registered;

      // registering success
      UserModel user = _userFromFirebase(result.user);
      // TODO for dev
      storage.deleteAll();
      // TODO 값 암호화 연구
      storage.write(key: 'email', value: user.email);
      storage.write(key: 'uid', value: user.uid);

      Encrypt sec = Encrypt();
      sec.init().then((_) {
        storage.write(key: 'enc_email', value: sec.encryption(user.email));
        storage.write(key: 'enc_uid', value: sec.encryption(user.uid));
      });
      // TODO 신규회원 안내

      return user;
    } catch (e) {
      _status = Status.unAuthenticated;
      notifyListeners();
      rethrow;
    }
  }

  //Method to handle user sign in using email and password
  Future<bool> signInWithEmailAndPassword(String email, String password) async {
    try {
      _status = Status.authenticating;
      notifyListeners();
      final UserCredential result = await _auth.signInWithEmailAndPassword(
          email: email, password: password
      );
      _status = Status.authenticated;
      // login success
      UserModel user = _userFromFirebase(result.user);
      // TODO for dev
      storage.deleteAll();

      // TODO 값 암호화 연구
      storage.write(key: 'email', value: user.email);
      storage.write(key: 'uid', value: user.uid);
      Encrypt sec = Encrypt();
      sec.init().then((_) {
        storage.write(key: 'enc_email', value: sec.encryption(user.email));
        storage.write(key: 'enc_uid', value: sec.encryption(user.uid));
      });


      return true;
    } catch (e) {
      print("Error on the sign in = " + e.toString());
      _status = Status.unAuthenticated;
      notifyListeners();
      return false;
    }
  }

  //Method to handle password reset email
  Future<void> sendPasswordResetEmail(String email) async {
    await _auth.sendPasswordResetEmail(email: email);
  }

  //Method to handle user signing out
  Future signOut() async {
    _auth.signOut();
    _status = Status.unAuthenticated;
    notifyListeners();
    return Future.delayed(Duration.zero);
  }
}
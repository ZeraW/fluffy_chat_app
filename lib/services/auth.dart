import 'package:chat_app/models/db_model.dart';
import 'package:chat_app/screens/wrapper.dart';
import 'package:chat_app/services/database.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';


class AuthService {

  final FirebaseAuth _auth = FirebaseAuth.instance;

  // create user obj based on firebase user
  User _userFromFirebaseUser(FirebaseUser user) {
    return user != null ? User(id: user.uid) : null;
  }

  // auth change user stream
  Stream<User> get user {
    return _auth.onAuthStateChanged
    //.map((FirebaseUser user) => _userFromFirebaseUser(user));
        .map(_userFromFirebaseUser);
  }

  // sign in anon
  Future signInAnon() async {
    try {
      AuthResult result = await _auth.signInAnonymously();
      FirebaseUser user = result.user;
      return _userFromFirebaseUser(user);
    } catch (e) {
      print(e.toString());
      return null;
    }
  }

  // sign in with email and password
  Future signInWithEmailAndPassword(String email, String password) async {
    try {
      AuthResult result = await _auth.signInWithEmailAndPassword(email: email, password: password);
      FirebaseUser user = result.user;
      return user;
    } catch (error) {
      print(error.toString());
      return null;
    }
  }

  // register with email and password
  Future registerWithEmailAndPassword(User newUser) async {
    try {

      AuthResult result = await _auth.createUserWithEmailAndPassword(email: '${newUser.phone}@unicorp.com', password: newUser.password);
      print('XDA : '+ result.user.uid);

      FirebaseUser fbUser = result.user;
      newUser.id = fbUser.uid;
      // create a new document for the user with the uid
      await DatabaseService(uid: fbUser.uid).updateUserData(user: newUser);
      //await DatabaseService(uid: fbUser.uid).addItemToUserCart();

      return _userFromFirebaseUser(fbUser);
    } catch (error) {
      print(error.toString());
      return null;
    }
  }

  // sign out
  Future signOut(BuildContext context) async {
    try {
      return await _auth.signOut().then((_){
        Firestore.instance.collection('Users')
            .document(Wrapper.UID)
            .updateData({'status': false});

      });
    } catch (error) {
      print(error.toString());
      return null;
    }
  }

}
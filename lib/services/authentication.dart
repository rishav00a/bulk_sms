import 'dart:async';
import 'dart:convert';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:shared_preferences/shared_preferences.dart';

abstract class BaseAuth {
  Future<String> signIn(String email, String password);

  Future<String> signUp(String email, String password);

  Future<FirebaseUser> getCurrentUser();

  Future<void> sendEmailVerification();

  Future<void> signOut();

  Future<bool> isEmailVerified();
}

class Auth implements BaseAuth {
  final FirebaseAuth _firebaseAuth = FirebaseAuth.instance;

  Future<String> signIn(String email, String password) async {
    bool hasAccess = false;
    AuthResult result = await _firebaseAuth.signInWithEmailAndPassword(
        email: email, password: password);

//    _setUserProf();
//     hasAccess = await userValid(result.user);
//     print(hasAccess);
//     if(!hasAccess){
//       _firebaseAuth.signOut();
//     }
    FirebaseUser user = result.user;
    return user.uid ;
  }

  Future<bool> userValid(FirebaseUser user) async {
    bool valid=false;

    DocumentSnapshot ds = await Firestore.instance
        .collection('user_profile')
        .document(user.email)
        .get();


    DocumentSnapshot dsrole = await ds.data["role"].get();
    valid = dsrole.data["role_id"]==3;
    if(valid){
      _setAssignedLocation(user);
    }
    return valid;

  }

  Future<String> signUp(String email, String password) async {
    AuthResult result = await _firebaseAuth.createUserWithEmailAndPassword(
        email: email, password: password);
    FirebaseUser user = result.user;
    return user.uid;
  }

  Future _setAssignedLocation(FirebaseUser user) async {
    List <String> districts=List();
    SharedPreferences prefs = await SharedPreferences.getInstance();



    DocumentSnapshot ds = await Firestore.instance
        .collection('partners')
        .document(user.email)
        .get();

    for(var dsl in ds.data["assigned_locations"]){
      print(dsl.get());
      DocumentSnapshot dsls = await dsl.get();
      districts.add(dsls.data["district"]);
    }
    await prefs.setStringList('districts', districts);
  }

  Future<FirebaseUser> getCurrentUser() async {
    FirebaseUser user = await _firebaseAuth.currentUser();
    return user;
  }

  Future<void> signOut() async {
    return _firebaseAuth.signOut();
  }

  Future<void> sendEmailVerification() async {
    FirebaseUser user = await _firebaseAuth.currentUser();
    user.sendEmailVerification();
  }

  Future<bool> isEmailVerified() async {
    FirebaseUser user = await _firebaseAuth.currentUser();
    return user.isEmailVerified;
  }
}
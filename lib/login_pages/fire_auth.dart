// ignore_for_file: avoid_print, deprecated_member_use, body_might_complete_normally_nullable, unused_local_variable

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:pricedb/model_pages/model.dart';
import 'package:shared_preferences/shared_preferences.dart';

class FireAuth1 {
  Future<User?> registerUsingEmailPassword(
      {required String email,
      required String password,
      required String number,
      required BuildContext context}) async {
    FirebaseAuth auth = FirebaseAuth.instance;
    User? user;
    try {
      UserCredential credential =
          await FirebaseAuth.instance.createUserWithEmailAndPassword(
        email: email,
        password: password,
      );
      saveUserId(credential.user!.uid);

      DatabaseManager()
          .createUser(credential.user!.uid, number, email, password);
      Navigator.pushNamed(context,'/VerifyEmail');
    } on FirebaseAuthException catch (e) {
      if (e.code == 'weak-password') {
        print('The password provided is too weak.');
        Fluttertoast.showToast(
          msg: "The password provided is too weak.",
          gravity: ToastGravity.BOTTOM,
          toastLength: Toast.LENGTH_SHORT,
          textColor: Colors.grey,
        );
      } else if (e.code == 'email-already-in-use') {
        print('The account already exists for that email.');
        Navigator.of(context).pop();
        Fluttertoast.showToast(
          msg: "The account already exists for that email.",
          gravity: ToastGravity.BOTTOM,
          toastLength: Toast.LENGTH_SHORT,
          textColor: Colors.grey,
        );
      }
    } catch (e) {
      print(e);
    }
  }

  Future<User?> signInUsingEmailPassword({
    required String email,
    required String password,
    required BuildContext context,
  }) async {
    FirebaseAuth auth = FirebaseAuth.instance;
    User? user;

    try {
      UserCredential userCredential = await auth.signInWithEmailAndPassword(
        email: email,
        password: password,
      );
      user = userCredential.user;
      saveUserId(user?.uid);
      FirebaseFirestore.instance
          .collection('Users')
          .doc(userCredential.user?.uid)
          .collection("Login details")
          .doc('1')
          .update({'Password': password});
    } on FirebaseAuthException catch (e) {
      if (e.code == 'user-not-found') {
        print('No user found for that email.');
        Fluttertoast.showToast(
          msg: "'No user found for that email.",
          gravity: ToastGravity.BOTTOM,
          toastLength: Toast.LENGTH_SHORT,
          textColor: Colors.grey,
        );
      } else if (e.code == 'wrong-password') {
        print('Wrong password provided.');
        Fluttertoast.showToast(
          msg: "Wrong password provided.",
          gravity: ToastGravity.BOTTOM,
          toastLength: Toast.LENGTH_SHORT,
          textColor: Colors.grey,
        );
      }
    }

    return user;
  }

  Future<void> saveUserId(path) async {
    SharedPreferences preferences = await SharedPreferences.getInstance();
    preferences.setString("userid", path);
  }

  Future<String> getUserId() async {
    SharedPreferences preferences = await SharedPreferences.getInstance();
    String? id = preferences.getString("userid");
    return id ?? "user";
  }
}

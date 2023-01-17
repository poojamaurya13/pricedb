// ignore_for_file: prefer_const_constructors_in_immutables, non_constant_identifier_names, avoid_print, prefer_const_constructors, unused_local_variable, unnecessary_null_comparison

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:pricedb/login_pages/fire_auth.dart';
import 'package:pricedb/login_pages/login_page.dart';
import 'package:pricedb/login_pages/verify_email_page.dart';
import 'package:pricedb/model_pages/model.dart';
import 'package:pricedb/screens/homepage.dart';

class Wrapper extends StatefulWidget {
  Wrapper({Key? key}) : super(key: key);

  @override
  State<Wrapper> createState() => _WrapperState();
}

class _WrapperState extends State<Wrapper> {
  String? uuid;

  @override
  void initState() {
    WidgetsBinding.instance?.addPostFrameCallback(
      (timeStamp) async {
        final FireAuth1 object = FireAuth1();
        uuid = await object.getUserId();
      },
    );

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    if (user == null) {
      print("null");
      return LoginPage();
    }
     else {
      print("loged");
      isEmailVerfied = FirebaseAuth.instance.currentUser!.emailVerified;
      return isEmailVerfied ? HomePage() : LoginPage();
    }
  }
}

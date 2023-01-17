// ignore_for_file: camel_case_types, unused_field, avoid_print, invalid_return_type_for_catch_error, unnecessary_this, deprecated_member_use

import 'dart:io';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:pricedb/login_pages/fire_auth.dart';
import 'package:pricedb/login_pages/verify_email_page.dart';
import 'package:pricedb/model_pages/model.dart';
import 'package:sizer/sizer.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({Key? key}) : super(key: key);

  @override
  _LoginPageState createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final TextEditingController _passwordController = TextEditingController();
  final TextEditingController _emailController = TextEditingController();

  AuthCredential? _phoneAuthCredential;
  String? _verificationId;
  int? _code;

  @override
  void initState() {
    super.initState();
    _emailController.clear();
    _passwordController.clear();
  }

  @override
  void dispose() {
    super.dispose();
    _emailController.dispose();
    _passwordController.dispose();
  }

  final _formKey = GlobalKey<FormState>();
  RegExp emailRegExp = RegExp(
      r"^[a-zA-Z0-9.!#$%&'*+/=?^_`{|}~-]+@[a-zA-Z0-9](?:[a-zA-Z0-9-]{0,253}[a-zA-Z0-9])?(?:\.[a-zA-Z0-9](?:[a-zA-Z0-9-]{0,253}[a-zA-Z0-9])?)*$");

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () => exit(0),
      child: Scaffold(
        body: SingleChildScrollView(
          child: SizedBox(
            height: MediaQuery.of(context).size.height,
            width: MediaQuery.of(context).size.width,
            child: Stack(
              children: <Widget>[
                ClipPath(
                    clipper: WaveShape(),
                    child: Container(
                        height: 30.h,
                        width: 100.w,
                        color: const Color.fromARGB(255, 65, 105, 119))),
                Align(
                  alignment: Alignment.center,
                  child: SizedBox(
                    height: 80.h,
                    width: 100.w,
                    child: Form(
                      key: _formKey,
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: <Widget>[
                          Padding(
                            padding: const EdgeInsets.only(left: 10),
                            child: Text(
                              "Login",
                              style: TextStyle(
                                  fontSize: 35.sp,
                                  color:
                                      const Color.fromARGB(255, 65, 105, 119),
                                  fontWeight: FontWeight.bold),
                            ),
                          ),
                          SizedBox(
                            height: 15.h,
                          ),
                          logintextforfield(
                            controller: _emailController,
                            hintText: "Email Address",
                            validator: (email) {
                              if (email!.isEmpty) {
                                return null;
                              } else if (!emailRegExp.hasMatch(email)) {
                                return 'Enter a correct email';
                              }

                              return null;
                            },
                          ),
                          logintextforfield(
                            obscureText: true,
                            controller: _passwordController,
                            hintText: "Enter Password",
                            prefixIcon: const Icon(
                              Icons.key,
                              color: Color.fromARGB(255, 65, 105, 119),
                            ),
                            validator: (password) {
                              if (password == null) {
                                return null;
                              }
                              if (password.isEmpty) {
                                return 'Password can\'t be empty';
                              } else if (password.length < 6) {
                                return 'Enter a password with length at least 6';
                              }

                              return null;
                            },
                          ),
                          Align(
                            alignment: Alignment.topRight,
                            child: TextButton(
                                onPressed: () {
                                  Navigator.pushNamed(context,'/ForgetPassword');
                                },
                                child: const Text(
                                  "Forget Password ?",
                                  style: TextStyle(
                                    color: Color.fromARGB(255, 65, 105, 119),
                                  ),
                                )),
                          ),
                          SizedBox(
                            height: 10.h,
                          ),
                          Padding(
                            padding: const EdgeInsets.only(left: 50),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceAround,
                              children: <Widget>[
                                login_buttons(
                                  height: 6.h,
                                  width: 35.w,
                                  onPressed: () async {
                                    if (_formKey.currentState!.validate()) {
                                      User? user = await FireAuth1()
                                          .signInUsingEmailPassword(
                                        email: _emailController.text,
                                        password: _passwordController.text,
                                        context: context,
                                      );

                                      if (user != null) {
                                        isEmailVerfied = FirebaseAuth.instance
                                            .currentUser!.emailVerified;
                                        isEmailVerfied
                                            ?Navigator.pushNamed(context,'/HomePage')
                                            : Navigator.pushNamed(context,'/VerifyEmail');
                                      }
                                    }
                                  },
                                  text: "Login",
                                ),
                                login_buttons(
                                  height: 6.h,
                                  width: 35.w,
                                  onPressed: () async {
                                    Navigator.pushNamed(context,'/LoginPage');
                                  },
                                  text: "Register",
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
                Align(
                  alignment: Alignment.bottomCenter,
                  child: ClipPath(
                      clipper: BottomWaveShape(),
                      child: Container(
                          height: 30.h,
                          width: 100.w,
                          color: const Color.fromARGB(255, 65, 105, 119))),
                )
              ],
            ),
          ),
        ),
      ),
    );
  }
}

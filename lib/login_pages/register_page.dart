// ignore_for_file: camel_case_types, unused_field, avoid_print, invalid_return_type_for_catch_error, unnecessary_this, deprecated_member_use, unused_local_variable, duplicate_ignore

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:pricedb/login_pages/fire_auth.dart';
import 'package:pricedb/login_pages/verify_email_page.dart';
import 'package:pricedb/model_pages/model.dart';
import 'package:sizer/sizer.dart';

class RegisterPage extends StatefulWidget {
  const RegisterPage({Key? key}) : super(key: key);

  @override
  _RegisterPageState createState() => _RegisterPageState();
}

class _RegisterPageState extends State<RegisterPage> {
  final TextEditingController _passwordController = TextEditingController();
  final TextEditingController _passwordController1 = TextEditingController();
  final TextEditingController _emailController = TextEditingController();

  @override
  void initState() {
    super.initState();
    _emailController.clear();
    _passwordController.clear();
    _passwordController1.clear();
  }

  @override
  void dispose() {
    super.dispose();
    _emailController.dispose();
    _passwordController.dispose();
    _passwordController1.dispose();
  }

  final _formKey = GlobalKey<FormState>();

  Future sendverificationemail() async {
    try {
      final user = FirebaseAuth.instance.currentUser!;
      await user.sendEmailVerification();
      setState(() {
        canresendemail = false;
      });
      await Future.delayed(const Duration(seconds: 10));
      setState(() {
        canresendemail = true;
      });
    } catch (e) {
      // ignore: avoid_print
      print(e.toString());
    }
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () {
        Navigator.pushNamed(context,'/LoginPage');
        return Future.value(true);
      },
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
                              "Register",
                              style: TextStyle(
                                  fontSize: 28.sp,
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
                            prefixIcon: const Icon(
                              Icons.email,
                              color: Color.fromARGB(255, 65, 105, 119),
                            ),
                            validator: (email) {
                              RegExp emailRegExp = RegExp(
                                  r"^[a-zA-Z0-9.!#$%&'*+/=?^_`{|}~-]+@[a-zA-Z0-9](?:[a-zA-Z0-9-]{0,253}[a-zA-Z0-9])?(?:\.[a-zA-Z0-9](?:[a-zA-Z0-9-]{0,253}[a-zA-Z0-9])?)*$");

                              if (email!.isEmpty) {
                                return "Email can't be empty";
                              } else if (!emailRegExp.hasMatch(email)) {
                                return 'Enter a correct email';
                              }

                              return null;
                            },
                          ),
                          logintextforfield(
                            obscureText: true,
                            controller: _passwordController,
                            hintText: "Create Password",
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
                          logintextforfield(
                            obscureText: true,
                            controller: _passwordController1,
                            hintText: "Confirm Password",
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
                              } else if (_passwordController.text != password) {
                                return 'Enter correct password';
                              }

                              return null;
                            },
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
                                    Navigator.pushNamed(context,'/LoginPage');
                                  },
                                  text: "Login",
                                ),
                                login_buttons(
                                    height: 6.h,
                                    width: 35.w,
                                    onPressed: () async {
                                      if (_formKey.currentState!.validate()) {
                                        User? user = await FireAuth1()
                                            .registerUsingEmailPassword(
                                                number: "",
                                                email: _emailController.text,
                                                password:
                                                    _passwordController.text,
                                                context: context);
                                        isEmailVerfied = FirebaseAuth.instance
                                            .currentUser!.emailVerified;

                                        if (!isEmailVerfied) {
                                          sendverificationemail();
                                        }
                                      }
                                    },
                                    text: "Register"),
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

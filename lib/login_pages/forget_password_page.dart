// ignore_for_file: deprecated_member_use, avoid_print, non_constant_identifier_names

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:pricedb/model_pages/model.dart';
import 'package:sizer/sizer.dart';

class ForgetPassword extends StatefulWidget {
  const ForgetPassword({Key? key}) : super(key: key);

  @override
  State<ForgetPassword> createState() => _ForgetPasswordState();
}

class _ForgetPasswordState extends State<ForgetPassword> {
  final _formKey = GlobalKey<FormState>();
  final TextEditingController _emailController = TextEditingController();
  RegExp emailRegExp = RegExp(
      r"^[a-zA-Z0-9.!#$%&'*+/=?^_`{|}~-]+@[a-zA-Z0-9](?:[a-zA-Z0-9-]{0,253}[a-zA-Z0-9])?(?:\.[a-zA-Z0-9](?:[a-zA-Z0-9-]{0,253}[a-zA-Z0-9])?)*$");

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
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: <Widget>[
                          SizedBox(
                            height: 4.h,
                          ),
                          Text(
                            "Reset Password",
                            style: TextStyle(
                                fontSize: 22.sp, fontWeight: FontWeight.w600),
                          ),
                          Padding(
                            padding: const EdgeInsets.only(
                                top: 8.0, left: 8.0, right: 8.0, bottom: 2.0),
                            child: Text(
                              "Enter email and press on button to receive email",
                              style: TextStyle(
                                  fontSize: 12.0.sp,
                                  fontWeight: FontWeight.w600,
                                  color: const Color.fromARGB(255, 93, 93, 93)),
                            ),
                          ),
                          Text(
                            "for password change",
                            style: TextStyle(
                                fontSize: 12.0.sp,
                                fontWeight: FontWeight.w600,
                                color: const Color.fromARGB(255, 93, 93, 93)),
                          ),
                          SizedBox(
                            height: 4.h,
                          ),
                          logintextforfield(
                            controller: _emailController,
                            hintText: "Email Address",
                            validator: (email) {
                              if (email!.isEmpty) {
                                return 'Email can\'t be empty';
                              } else if (!emailRegExp.hasMatch(email)) {
                                return 'Enter a correct email';
                              }

                              return null;
                            },
                          ),
                          SizedBox(
                            height: 10.h,
                          ),
                          login_buttons(
                            height: 6.h,
                            width: 60.w,
                            onPressed: () async {
                              if (_formKey.currentState!.validate()) {
                                try {
                                  await FirebaseAuth.instance
                                      .sendPasswordResetEmail(
                                          email: _emailController.text.trim())
                                      .then((value) {
                                    Psswordalert().then(
                                        (value) => Navigator.of(context).pop());
                                  });
                                } on FirebaseAuthException catch (e) {
                                  if (e.code == 'user-not-found') {
                                    print('No user found for that email.');
                                    Fluttertoast.showToast(
                                      msg: "'No user found for that email.",
                                      gravity: ToastGravity.BOTTOM,
                                      toastLength: Toast.LENGTH_SHORT,
                                      textColor: Colors.grey,
                                    );
                                  }
                                }
                              }
                            },
                            text: "Reset Password",
                          )
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

  Future<void> Psswordalert() async {
    return await showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          content: SingleChildScrollView(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: <Widget>[
                Image.asset("assets/p5.png"),
                Text(
                  "Link has been send to your mail",
                  style:
                      TextStyle(fontSize: 13.sp, fontWeight: FontWeight.w600),
                ),
                SizedBox(
                  height: 0.5.h,
                ),
                Text(
                  "for password change.",
                  style:
                      TextStyle(fontSize: 13.sp, fontWeight: FontWeight.w600),
                ),
                SizedBox(height: 3.h),
                login_buttons(
                    height: 6.h,
                    width: 40.w,
                    onPressed: () {
                      Navigator.of(context).pop();
                    },
                    text: "OK")
              ],
            ),
          ),
        );
      },
    );
  }
}

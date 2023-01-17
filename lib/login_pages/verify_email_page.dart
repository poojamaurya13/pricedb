import 'dart:async';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:pricedb/login_pages/add_number_page.dart';
import 'package:pricedb/model_pages/model.dart';
import 'package:sizer/sizer.dart';

bool isEmailVerfied = false;
bool canresendemail = false;

class VerifyEmail extends StatefulWidget {
  const VerifyEmail({Key? key}) : super(key: key);

  @override
  State<VerifyEmail> createState() => _VerifyEmailState();
}

class _VerifyEmailState extends State<VerifyEmail> {
  Timer? timer;

  Future<void> _logout() async {
    await FirebaseAuth.instance.signOut();
    // user = null;
  }

  @override
  void initState() {
    super.initState();
    isEmailVerfied = FirebaseAuth.instance.currentUser!.emailVerified;

    if (!isEmailVerfied) {
      timer = Timer.periodic(const Duration(seconds: 5), (__) {
        checkemailverified();
      });
    }
  }

  @override
  void dispose() {
    timer?.cancel();
    super.dispose();
  }

  Future checkemailverified() async {
    await FirebaseAuth.instance.currentUser!.reload();
    setState(() {
      isEmailVerfied = FirebaseAuth.instance.currentUser!.emailVerified;
    });
  }

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
  Widget build(BuildContext context) => isEmailVerfied
      ? const Add_number()
      : WillPopScope(
          onWillPop: () {
            Navigator.pushNamed(context,'/LoginPage');
            return Future.value(true);
          },
          child: Scaffold(
            appBar: appbar(text: "Verify Email"),
            body: Center(
              child: Padding(
                padding: const EdgeInsets.only(left: 10, right: 10),
                child: Card(
                  elevation: 2.0,
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10)),
                  child: Padding(
                    padding: const EdgeInsets.all(10.0),
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: <Widget>[
                        Image.asset(
                          "assets/p3.png",
                          height: 25.h,
                          width: 25.h,
                        ),
                        Text(
                          "A verification email has been sent to your email.",
                          style: TextStyle(fontSize: 12.sp,fontWeight: FontWeight.w600),
                        ),
                        SizedBox(
                          height: 0.5.h,
                        ),
                        Text(
                          "Please check your mail.",
                          style: TextStyle(fontSize: 12.sp,fontWeight: FontWeight.w500),
                        ),
                        SizedBox(
                          height: 5.h,
                        ),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceAround,
                          children: <Widget>[
                            login_buttons(
                              height: 6.h,
                              width: 35.w,
                              onPressed: () {
                                canresendemail ? sendverificationemail() : null;
                              },
                              text: "Resend email",
                            ),
                            login_buttons(
                              height: 6.h,
                              width: 35.w,
                              onPressed: () {
                                _logout().then(
                                  (value) => Navigator.pushNamed(context,'/LoginPage'));
                              },
                              text: "Cancel",
                            ),
                          ],
                        ),
                        SizedBox(
                          height: 2.h,
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ),
          ),
        );
}

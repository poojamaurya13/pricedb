// ignore_for_file: camel_case_types

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:pricedb/login_pages/fire_auth.dart';
import 'package:pricedb/model_pages/model.dart';
import 'package:sizer/sizer.dart';

class Add_number extends StatefulWidget {
  const Add_number({Key? key}) : super(key: key);

  @override
  State<Add_number> createState() => _Add_numberState();
}

class _Add_numberState extends State<Add_number> {
  final _formKey = GlobalKey<FormState>();
  final TextEditingController _phoneNumberController = TextEditingController();

  @override
  void initState() {
    _phoneNumberController.clear();
    super.initState();
  }

  @override
  void dispose() {
    _phoneNumberController.dispose();
    super.dispose();
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
          child: Stack(
            children: <Widget>[
              SizedBox(
                height: MediaQuery.of(context).size.height,
                width: MediaQuery.of(context).size.width,
                child: Padding(
                  padding: const EdgeInsets.all(10.0),
                  child: Form(
                    key: _formKey,
                    child: Column(children: <Widget>[
                      SizedBox(
                        height: 8.h,
                      ),
                      Image.asset("assets/p6.png"),
                      const Text(
                        "Congratulations you have successfully",
                        style: TextStyle(fontWeight: FontWeight.bold),
                      ),
                      SizedBox(
                        height: 0.5.h,
                      ),
                      const Text(
                        "verified your email.",
                        style: TextStyle(fontWeight: FontWeight.bold),
                      ),
                      SizedBox(
                        height: 4.h,
                      ),
                      logintextforfield(
                        controller: _phoneNumberController,
                        hintText: "Phone Number",
                        prefixIcon: const Icon(
                          Icons.phone,
                          color: Color.fromARGB(255, 65, 105, 119),
                        ),
                        keyboardType: TextInputType.phone,
                        validator: (number) {
                          String pattern = r'(^(?:[+0]9)?[0-9]{10,10}$)';
                          RegExp regExp = RegExp(pattern);
                          if (number!.isEmpty) {
                            return "Number can't be empty";
                          } else if (!regExp.hasMatch(number)) {
                            return 'Please enter valid mobile number';
                          }
                          return null;
                        },
                      ),
                      SizedBox(
                        height: 10.h,
                      ),
                      login_buttons(
                          height: 6.h,
                          width: 50.w,
                          onPressed: () async {
                            final FireAuth1 object = FireAuth1();
                            String uuid = await object.getUserId();

                            if (_formKey.currentState!.validate()) {
                              FirebaseFirestore.instance
                                  .collection("Users")
                                  .doc(uuid)
                                  .collection("Login details")
                                  .doc("1")
                                  .update({
                                'Number': _phoneNumberController.text
                              }).then((value) => Navigator.pushNamed(context,'/HomePage'));
                            }
                          },
                          text: "Save"),
                    ]),
                  ),
                ),
              ),
              Positioned(
                right: 2.0.w,
                bottom: 1.0.h,
                child: InkWell(
                  onTap: () {
                    Navigator.pushNamed(context,'/HomePage');
                  },
                  child: Container(
                    height: 6.h,
                    width: 25.w,
                    decoration: BoxDecoration(
                        color: const Color.fromARGB(255, 151, 150, 150),
                        borderRadius: BorderRadius.circular(20)),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: <Widget>[
                        Text(
                          "Skip",
                          style:
                              TextStyle(color: Colors.white, fontSize: 13.sp),
                        ),
                        const Icon(
                          Icons.skip_next,
                          color: Colors.white,
                        )
                      ],
                    ),
                  ),
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}

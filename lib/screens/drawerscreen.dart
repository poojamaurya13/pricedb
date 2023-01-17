// ignore_for_file: camel_case_types, avoid_print, unused_field, non_constant_identifier_names, duplicate_ignore, unnecessary_brace_in_string_interps, unnecessary_string_interpolations, deprecated_member_use

import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:image_picker_android/image_picker_android.dart';
import 'package:image_picker_platform_interface/image_picker_platform_interface.dart';
import 'package:pricedb/login_pages/fire_auth.dart';
import 'package:pricedb/model_pages/exit.dart';
import 'package:pricedb/model_pages/model.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:sizer/sizer.dart';

class drawerpage extends StatefulWidget {
  const drawerpage({Key? key}) : super(key: key);

  @override
  State<drawerpage> createState() => _drawerpageState();
}

class _drawerpageState extends State<drawerpage> {
  Future<void> _logout() async {
    await FirebaseAuth.instance.signOut();
    // user = null;
  }

  String? uuid;
  @override
  void initState() {
    super.initState();
    LoadImage();
    WidgetsBinding.instance?.addPostFrameCallback((timeStamp) async {
      final FireAuth1 object = FireAuth1();
      uuid = await object.getUserId();
    });
  }

  String? _imagepath;
  File? _image;

  @override
  Widget build(BuildContext context) {
    return Drawer(
      child: ListView(
        padding: EdgeInsets.zero,
        children: <Widget>[
          Container(
            height: 35.h,
            width: 100.w,
            color: const Color.fromARGB(255, 222, 245, 253),
            child: Stack(
              children: <Widget>[
                ClipPath(
                    clipper: WaveShape(),
                    child: Container(
                        height: 20.h,
                        width: 100.w,
                        color: const Color.fromARGB(255, 65, 105, 119))),
                Positioned(
                  left: 6.w,
                  bottom: 3.h,
                  child: Container(
                      clipBehavior: Clip.antiAliasWithSaveLayer,
                      height: 30.h,
                      width: 30.w,
                      decoration: const BoxDecoration(
                        // borderRadius: BorderRadius.circular(74.0),
                        shape: BoxShape.circle,
                        color: Colors.white,
                      ),
                      child: _imagepath != null
                          ? Image.file(File(_imagepath!), fit: BoxFit.fill)
                          : _image != null
                              ? Image.file(File(_image!.path), fit: BoxFit.fill)
                              : Image.asset("assets/p1.jpg", fit: BoxFit.fill)),
                ),
                Positioned(
                  left: 22.w,
                  bottom: 8.h,
                  child: IconButton(
                      onPressed: () {
                        showSelectionDialog(
                          context: context,
                          gallery: () {
                            selectOrTakePhoto(ImageSource.gallery)
                                .then((value) {
                              if (_image != null) {
                                alert(
                                  context: context,
                                  text: "Do you want to change picture?",
                                  ontap: () {
                                    setState(() {
                                      saveimage(_image!.path).then(
                                          (value) => Navigator.pop(context));
                                    });
                                    LoadImage();
                                  },
                                );
                              }
                            });
                            Navigator.pop(context);
                          },
                          camera: () {
                            selectOrTakePhoto(ImageSource.camera).then((value) {
                              if (_image != null) {
                                alert(
                                  context: context,
                                  text: "Do you want to change picture?",
                                  ontap: () {
                                    setState(() {
                                      saveimage(_image!.path).then(
                                          (value) => Navigator.pop(context));
                                    });
                                    LoadImage();
                                  },
                                );
                              }
                            });
                            Navigator.pop(context);
                          },
                        );
                      },
                      icon: Icon(Icons.camera_alt,
                          size: 7.h,
                          color: const Color.fromARGB(255, 65, 105, 119))),
                ),
                Positioned(
                  bottom: 0.h,
                  left: 2.w,
                  child: SizedBox(
                    height: 5.h,
                    width: 100.w,
                    child: MediaQuery.removePadding(
                      context: context,
                      removeTop: true,
                      child: SafeArea(
                        child: StreamBuilder(
                          stream: FirebaseFirestore.instance
                              .collection("Users")
                              .doc(uuid)
                              .collection("Login details")
                              .doc("1")
                              .snapshots(),
                          builder:
                              (___, AsyncSnapshot<DocumentSnapshot> snapshot) {
                            if (snapshot.hasData && snapshot.data != null) {
                              if (snapshot.data!.exists) {
                                return ListView.builder(
                                  shrinkWrap: true,
                                  physics: const NeverScrollableScrollPhysics(),
                                  itemBuilder: (_______, int index) {
                                    // String Name = snapshot.data!.get("name");
                                    String Email = snapshot.data!.get("Email");

                                    return Text(
                                      Email,
                                      style: const TextStyle(
                                          color:
                                              Color.fromARGB(255, 65, 105, 119),
                                          fontSize: 15,
                                          fontWeight: FontWeight.w500),
                                    );
                                  },
                                  itemCount: 1,
                                );
                              }
                            }
                            return Container();
                          },
                        ),
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),

          listtile(
            icon: Icons.home,
            title: "Home",
            ontap: () {
              Navigator.pushNamed(context,'/HomePage');
            },
          ),
          listtile(
            icon: Icons.business,
            title: "Add company detail",
            ontap: () {
              Navigator.pushNamed(context,'/CompanyDetail');
            },
          ),
          listtile(
            icon: Icons.description,
            title: "Add product detail",
            ontap: () {
              Navigator.pushNamed(context,'/ProductDetail');
            },
          ),
          //1234
          listtile(
            icon: Icons.history,
            title: "History",
            ontap: () {
              Navigator.pushNamed(context, '/PdfList');
            },
          ),
          listtile(
            icon: Icons.settings,
            title: "Settings",
            ontap: () {
              Navigator.pushNamed(context, '/Setting_page');
            },
          ),
          listtile(
            icon: Icons.shield,
            title: "Policy",
            ontap: () {
              Navigator.pushNamed(context, '/Policy_privacy');
            },
          ),
          SizedBox(
            height: 6.0.h,
          ),
          const Divider(
            color: Colors.black,
            thickness: 0.4,
          ),
          ListTile(
            leading: const Icon(
              Icons.logout,
              color: Color.fromARGB(255, 65, 105, 119),
            ),
            title: const Text("Logout"),
            onTap: () {
              showExitPopup(
                context: context,
                text: "Logout",
                onpressed1: () {
                  Navigator.pop(context);
                },
                onpressed: () {
                  _logout().then((value) =>
                      Navigator.pushNamed(context,'/LoginPage'));
                  Fluttertoast.showToast(
                    msg: "Logout",
                    gravity: ToastGravity.BOTTOM,
                    toastLength: Toast.LENGTH_SHORT,
                    textColor: Colors.grey,
                  );
                },
              );
            },
          ),
        ],
      ),
    );
  }

  Future<void> selectOrTakePhoto(ImageSource imageSource) async {
    var pickedFile = await ImagePickerAndroid().pickImage(source: imageSource);
    setState(() {
      if (pickedFile != null) {
        _image = File(pickedFile.path);
      } else {
        print('No photo was selected or taken');
      }
    });
  }

  Future<void> saveimage(path) async {
    SharedPreferences saveimage = await SharedPreferences.getInstance();
    saveimage.setString("imagepath", path);
  }

  void LoadImage() async {
    SharedPreferences saveimage = await SharedPreferences.getInstance();
    setState(() {
      _imagepath = saveimage.getString("imagepath");
    });
  }

  Widget listtile({IconData? icon, String? title, Function()? ontap}) {
    return ListTile(
        leading: Icon(
          icon,
          color: const Color.fromARGB(255, 65, 105, 119),
        ),
        title: Text(title ?? ""),
        onTap: ontap);
  }
}

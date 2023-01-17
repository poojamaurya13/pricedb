// ignore_for_file: camel_case_types, deprecated_member_use, avoid_print, library_prefixes

import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:image_picker_android/image_picker_android.dart';
import 'package:image_picker_platform_interface/image_picker_platform_interface.dart';
import 'package:pricedb/model_pages/model.dart';
import 'package:pricedb/screens/drawerscreen.dart';
import 'package:sizer/sizer.dart';
import 'package:image/image.dart' as ImageLib;

import '../login_pages/fire_auth.dart';

class CompanyDetail extends StatefulWidget {
  const CompanyDetail({Key? key}) : super(key: key);

  @override
  State<CompanyDetail> createState() => _CompanyDetailState();
}

class _CompanyDetailState extends State<CompanyDetail> {
  final _formKey = GlobalKey<FormState>();

  final _nameTextController = TextEditingController();
  final _numberTextController = TextEditingController();

  final _focusname = FocusNode();
  final _focusnumber = FocusNode();

  bool isLoading = false;

  File? _image;

  @override
  void initState() {
    super.initState();
  }

  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () {
       Navigator.pushNamed(context,'/HomePage');
        return Future.value(true);
      },
      child: Scaffold(
        appBar: appbar(
          text: "Add Company Details",
        ),
        drawer: const drawerpage(),
        body: SingleChildScrollView(
          child: Center(
            child: Padding(
              padding: const EdgeInsets.all(15.0),
              child: isLoading
                  ? const CircularProgressIndicator()
                  : Column(
                      children: <Widget>[
                        SizedBox(height: 2.0.h),
                        imagecontainer(
                          child: _image != null
                              ? Image.file(File(_image!.path), fit: BoxFit.fill)
                              : IconButton(
                                  onPressed: () {
                                    showSelectionDialog(
                                      context: context,
                                      gallery: () {
                                        selectOrTakePhoto(ImageSource.gallery);

                                        Navigator.pop(context);
                                      },
                                      camera: () {
                                        selectOrTakePhoto(ImageSource.camera);
                                        Navigator.pop(context);
                                      },
                                    );
                                  },
                                  icon: const Icon(
                                    Icons.add,
                                    size: 35,
                                  ),
                                ),
                        ),
                        SizedBox(
                          height: 1.h,
                        ),
                        Text(
                          "Company Logo",
                          style: TextStyle(
                              fontSize: 12.sp, fontWeight: FontWeight.w500),
                        ),
                        SizedBox(height: 8.0.h),
                        Form(
                          key: _formKey,
                          child: textfield(
                            style: TextStyle(
                                fontSize: 13.sp, fontWeight: FontWeight.w500),
                            cursorHeight: 4.0.h,
                            controller: _nameTextController,
                            focusNode: _focusname,
                            validator: (name) {
                              if (name!.isEmpty) {
                                return "Please enter company name";
                              }
                              return null;
                            },
                            hinttext: "Company name",
                            contentPadding: const EdgeInsets.symmetric(
                                vertical: 15.0, horizontal: 8.0),
                          ),
                        ),
                        SizedBox(height: 2.0.h),
                        textfield(
                            style: TextStyle(
                                fontSize: 13.sp, fontWeight: FontWeight.w500),
                            cursorHeight: 4.0.h,
                            controller: _numberTextController,
                            focusNode: _focusnumber,
                            inputFormatters: <TextInputFormatter>[
                              FilteringTextInputFormatter.digitsOnly
                            ],
                            keyboardType: TextInputType.number,
                            contentPadding: const EdgeInsets.symmetric(
                                vertical: 15.0, horizontal: 8.0),
                            hinttext: "0000000000"),
                        SizedBox(
                          height: 10.0.h,
                        ),
                        button(
                          height: 7.h,
                          width: 50.w,
                          onpressed: () async {
                            print("ONTAP");
                            final FireAuth1 object = FireAuth1();
                            String uuid = await object.getUserId();
                            if (_formKey.currentState!.validate() &&
                                _image != null) {
                              setState(() {
                                isLoading = true;
                              });
                              var uniqueKey = FirebaseFirestore.instance
                                  .collection("Users")
                                  .doc(uuid)
                                  .collection("Company detail")
                                  .doc();
                              String uploadFileName = DateTime.now()
                                      .microsecondsSinceEpoch
                                      .toString() +
                                  ".jpg";
                              Reference reference = FirebaseStorage.instance
                                  .ref()
                                  .child(uploadFileName);
                              UploadTask uploadTask =
                                  reference.putFile(File(_image!.path));

                              uploadTask.snapshotEvents.listen((event) {
                                print(event.bytesTransferred.toString() +
                                    "\t" +
                                    event.totalBytes.toString());
                              });

                              await uploadTask.whenComplete(() async {
                                var uploadPath = await uploadTask.snapshot.ref
                                    .getDownloadURL();

                                if (uploadPath.isNotEmpty) {
                                  FirebaseFirestore.instance
                                      .collection("Users")
                                      .doc(uuid)
                                      .collection("Company detail")
                                      .doc(uniqueKey.id)
                                      .set({
                                    "Image": uploadPath,
                                    "Company Name": _nameTextController.text,
                                    "Number": _numberTextController.text,
                                    'createdAt': DateTime.now()
                                  }).then((value) => Navigator.pop(context));
                                } else {
                                  Fluttertoast.showToast(
                                    msg:
                                        "Somthing went wrong \nPlease try again.",
                                    gravity: ToastGravity.BOTTOM,
                                    toastLength: Toast.LENGTH_SHORT,
                                    textColor: Colors.grey,
                                  );
                                }
                                setState(() {
                                  isLoading = false;
                                });
                              });
                            } else if (_formKey.currentState!.validate() &&
                                _image == null) {
                              Map<String, dynamic> data = {
                                "Image":
                                    "https://firebasestorage.googleapis.com/v0/b/price-b66f7.appspot.com/o/companyimage.jpg?alt=media&token=1b9df9b9-0061-445e-81d2-8be34e429a52",
                                "Company Name": _nameTextController.text,
                                "Number": _numberTextController.text,
                                'createdAt': DateTime.now()
                              };
                              FirebaseFirestore.instance
                                  .collection("Users")
                                  .doc(uuid)
                                  .collection("Company detail")
                                  .add(data)
                                  .then((value) => Navigator.pop(context));
                            }
                          },
                          child: const Text(
                            "Save",
                            style: TextStyle(color: Colors.white),
                          ),
                        )
                      ],
                    ),
            ),
          ),
        ),
      ),
    );
  }

  Future<void> selectOrTakePhoto(ImageSource imageSource) async {
    var pickedFile = await ImagePickerAndroid().pickImage(source: imageSource);
    setState(() {
      if (pickedFile != null) {
        _image = File(pickedFile.path);
      } else {
        Fluttertoast.showToast(
          msg: 'No photo was selected or taken',
          gravity: ToastGravity.BOTTOM,
          toastLength: Toast.LENGTH_SHORT,
          textColor: Colors.grey,
        );
      }
    });
    if (pickedFile != null) {
      ImageLib.Image? image =
          ImageLib.decodeImage(await File(_image!.path).readAsBytes());

      if (image!.width >= 1800 || image.height >= 1275) {
        Fluttertoast.showToast(
          msg: 'Image size is upto 100kb',
          gravity: ToastGravity.BOTTOM,
          toastLength: Toast.LENGTH_SHORT,
          textColor: Colors.grey,
        ).then((value) {
          setState(() {
            _image = null;
          });
        });
      }
    }
  }
}

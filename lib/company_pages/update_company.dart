// ignore_for_file: must_be_immutable, avoid_print, deprecated_member_use

import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:image_picker_android/image_picker_android.dart';
import 'package:image_picker_platform_interface/image_picker_platform_interface.dart';
import 'package:pricedb/login_pages/fire_auth.dart';
import 'package:pricedb/model_pages/model.dart';
import 'package:sizer/sizer.dart';
// ignore: library_prefixes
import 'package:image/image.dart' as ImageLib;

class UpdateCompany extends StatefulWidget {
  String id;
  String img;
  String name;
  String number;
  UpdateCompany(
      {Key? key,
      required this.id,
      required this.img,
      required this.name,
      required this.number})
      : super(key: key);

  @override
  State<UpdateCompany> createState() => _UpdateCompanyState();
}

class _UpdateCompanyState extends State<UpdateCompany> {
  // ignore: todo
  // TODO: Implement _loadInterstitialAd()

  @override
  void initState() {
    _nameTextController.text = widget.name;
    _numberTextController.text = widget.number;

    super.initState();
  }

  @override
  void dispose() {
    super.dispose();
  }

  bool isLoading = false;

  File? _image;

  final _formKey = GlobalKey<FormState>();

  final _nameTextController = TextEditingController();
  final _numberTextController = TextEditingController();

  final _focusname = FocusNode();
  final _focusnumber = FocusNode();
  String image =
      "https://firebasestorage.googleapis.com/v0/b/price-b66f7.appspot.com/o/companyimage.jpg?alt=media&token=1b9df9b9-0061-445e-81d2-8be34e429a52";

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () {
        Navigator.pushNamed(context,'/HomePage');
        return Future.value(true);
      },
      child: Scaffold(
        backgroundColor: const Color.fromARGB(237, 244, 251, 253),
        appBar: appbar(
          text: "Update Company Details",
        ),
        body: SingleChildScrollView(
          child: Padding(
            padding: EdgeInsets.symmetric(horizontal: 8, vertical: 5.h),
            child: isLoading
                ? const Center(child: CircularProgressIndicator())
                : Stack(
                    children: <Widget>[
                      Padding(
                        padding: EdgeInsets.only(top: 6.h),
                        child: Card(
                          elevation: 5,
                          child: Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: Column(
                              // mainAxisSize: MainAxisSize.min,
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: <Widget>[
                                SizedBox(height: 15.0.h),
                                Text(
                                  "Company Name",
                                  style: TextStyle(
                                      fontSize: 11.5.sp,
                                      fontWeight: FontWeight.w500),
                                ),
                                SizedBox(height: 1.0.h),
                                Form(
                                  key: _formKey,
                                  child: textfield(
                                    style: TextStyle(
                                        fontSize: 13.sp,
                                        fontWeight: FontWeight.w500),
                                    cursorHeight: 4.0.h,
                                    controller: _nameTextController,
                                    focusNode: _focusname,
                                    validator: (name) {
                                      if (name!.isEmpty) {
                                        return "Please enter company name";
                                      }
                                      return null;
                                    },
                                    contentPadding: const EdgeInsets.symmetric(
                                        vertical: 15.0, horizontal: 8.0),
                                  ),
                                ),
                                SizedBox(height: 3.0.h),
                                Text(
                                  "Number",
                                  style: TextStyle(
                                      fontSize: 11.5.sp,
                                      fontWeight: FontWeight.w500),
                                ),
                                SizedBox(height: 1.0.h),
                                textfield(
                                  style: TextStyle(
                                      fontSize: 13.sp,
                                      fontWeight: FontWeight.w500),
                                  cursorHeight: 4.0.h,
                                  controller: _numberTextController,
                                  focusNode: _focusnumber,
                                  keyboardType: TextInputType.number,
                                  inputFormatters: <TextInputFormatter>[
                                    FilteringTextInputFormatter.digitsOnly
                                  ],
                                  contentPadding: const EdgeInsets.symmetric(
                                      vertical: 15.0, horizontal: 8.0),
                                ),
                                SizedBox(height: 10.0.h),
                                Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceAround,
                                  children: <Widget>[
                                    SizedBox(
                                      height: 7.h,
                                      width: 35.w,
                                      child: RaisedButton(
                                          shape: RoundedRectangleBorder(
                                              borderRadius:
                                                  BorderRadius.circular(10)),
                                          color: const Color.fromARGB(
                                              255, 236, 248, 252),
                                          onPressed: () {
                                            Navigator.pop(context);
                                          },
                                          child: Text(
                                            "Cancle",
                                            style: TextStyle(
                                                fontWeight: FontWeight.w500,
                                                fontSize: 13.sp,
                                                color: const Color.fromARGB(
                                                    255, 65, 105, 119)),
                                          )),
                                    ),
                                    button(
                                        height: 7.h,
                                        width: 35.w,
                                        onpressed: () async {
                                          final FireAuth1 object = FireAuth1();
                                          String uuid =
                                              await object.getUserId();

                                          {
                                            if (_formKey.currentState!
                                                    .validate() &&
                                                image == widget.img &&
                                                _image != null) {
                                              setState(() {
                                                isLoading = true;
                                              });
                                              var uniqueKey = FirebaseFirestore
                                                  .instance
                                                  .collection("Users")
                                                  .doc(uuid)
                                                  .collection("Company detail")
                                                  .doc(widget.id);
                                              String uploadFileName = DateTime
                                                          .now()
                                                      .microsecondsSinceEpoch
                                                      .toString() +
                                                  ".jpg";
                                              Reference reference =
                                                  FirebaseStorage.instance
                                                      .ref()
                                                      .child(uploadFileName);
                                              UploadTask uploadTask = reference
                                                  .putFile(File(_image!.path));

                                              uploadTask.snapshotEvents
                                                  .listen((event) {
                                                print(event.bytesTransferred
                                                        .toString() +
                                                    "\t" +
                                                    event.totalBytes
                                                        .toString());
                                              });

                                              await uploadTask
                                                  .whenComplete(() async {
                                                var uploadPath =
                                                    await uploadTask
                                                        .snapshot.ref
                                                        .getDownloadURL();

                                                if (uploadPath.isNotEmpty) {
                                                  FirebaseFirestore.instance
                                                      .collection("Users")
                                                      .doc(uuid)
                                                      .collection(
                                                          "Company detail")
                                                      .doc(uniqueKey.id)
                                                      .update({
                                                    "Image": uploadPath,
                                                    "Company Name":
                                                        _nameTextController
                                                            .text,
                                                    "Number":
                                                        _numberTextController
                                                            .text,
                                                    'createdAt': DateTime.now()
                                                  }).then((value) =>
                                                          Navigator.pop(
                                                              context));
                                                } else {
                                                  Fluttertoast.showToast(
                                                    msg:
                                                        "Somthing went wrong \nPlease try again.",
                                                    gravity:
                                                        ToastGravity.BOTTOM,
                                                    toastLength:
                                                        Toast.LENGTH_SHORT,
                                                    textColor: Colors.grey,
                                                  );
                                                }
                                                setState(() {
                                                  isLoading = false;
                                                });
                                              });
                                            } else if (_formKey.currentState!
                                                    .validate() &&
                                                _image != null) {
                                              Reference reference =
                                                  FirebaseStorage.instance
                                                      .refFromURL(widget.img
                                                          .toString());

                                              UploadTask uploadTask = reference
                                                  .putFile(File(_image!.path));

                                              uploadTask.snapshotEvents
                                                  .listen((event) {
                                                print(event.bytesTransferred
                                                        .toString() +
                                                    "\t" +
                                                    event.totalBytes
                                                        .toString());
                                              });

                                              await uploadTask
                                                  .whenComplete(() async {
                                                var uploadPath =
                                                    await uploadTask
                                                        .snapshot.ref
                                                        .getDownloadURL();

                                                if (uploadPath.isNotEmpty) {
                                                  FirebaseFirestore.instance
                                                      .collection("Users")
                                                      .doc(uuid)
                                                      .collection(
                                                          "Company detail")
                                                      .doc(widget.id)
                                                      .update({
                                                    "Image": uploadPath,
                                                    "Company Name":
                                                        _nameTextController
                                                            .text,
                                                    "Number":
                                                        _numberTextController
                                                            .text,
                                                    'createdAt': DateTime.now()
                                                  }).then((value) =>
                                                          Navigator.pop(
                                                              context));
                                                } else {
                                                  Fluttertoast.showToast(
                                                    msg:
                                                        "Somthing went wrong \nPlease try again.",
                                                    gravity:
                                                        ToastGravity.BOTTOM,
                                                    toastLength:
                                                        Toast.LENGTH_SHORT,
                                                    textColor: Colors.grey,
                                                  );
                                                }
                                              });
                                            } else if (_formKey.currentState!
                                                .validate()) {
                                              FirebaseFirestore.instance
                                                  .collection("Users")
                                                  .doc(uuid)
                                                  .collection("Company detail")
                                                  .doc(widget.id)
                                                  .update({
                                                "Image": widget.img,
                                                "Company Name":
                                                    _nameTextController.text,
                                                "Number":
                                                    _numberTextController.text,
                                                'createdAt': DateTime.now()
                                              }).then((value) =>
                                                      Navigator.pop(context));
                                            }
                                          }
                                        },
                                        child: const Text(
                                          "Update",
                                          style: TextStyle(color: Colors.white),
                                        ))
                                  ],
                                ),
                                SizedBox(
                                  height: 2.h,
                                )
                              ],
                            ),
                          ),
                        ),
                      ),
                      Center(
                        child: Stack(
                          children: <Widget>[
                            imagecontainer(
                                child: _image != null
                                    ? Image.file(File(_image!.path),
                                        fit: BoxFit.fill)
                                    : widget.img.isNotEmpty
                                        ? imewidget(img: widget.img)
                                        : null),
                            Positioned(
                              left: 21.w,
                              top: 9.5.h,
                              right: 0.w,
                              bottom: 0.h,
                              child: IconButton(
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
                                  icon: Icon(
                                    Icons.camera_alt,
                                    size: 7.h,
                                    color:
                                        const Color.fromARGB(255, 65, 105, 119)
                                            .withOpacity(0.7),
                                  )),
                            ),
                          ],
                        ),
                      ),
                    ],
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
    } else {
      ImageLib.decodeImage(await File(widget.img).readAsBytes());
    }
  }
}

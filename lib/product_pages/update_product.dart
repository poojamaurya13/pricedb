// ignore_for_file: must_be_immutable, non_constant_identifier_names, avoid_print, empty_catches, unnecessary_null_comparison, deprecated_member_use, duplicate_ignore, prefer_const_constructors

import 'dart:async';
import 'dart:io';
import 'dart:typed_data';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter/services.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:image_picker_android/image_picker_android.dart';
import 'package:image_picker_platform_interface/image_picker_platform_interface.dart';
import 'package:path_provider/path_provider.dart';
import 'package:pricedb/login_pages/fire_auth.dart';
import 'package:pricedb/model_pages/model.dart';
import 'package:pricedb/screens/drawerscreen.dart';
import 'package:share_plus/share_plus.dart';
import 'package:sizer/sizer.dart';
import 'dart:ui' as ui;
// ignore: library_prefixes
import 'package:image/image.dart' as ImageLib;

class UpdateProduct extends StatefulWidget {
  String Logo1;
  String CompanyName1;
  String Number1;
  String Img1;
  String Quantity1;
  String ProductName1;
  String Price1;
  String FinalPrice1;
  String id;
  UpdateProduct(
      {Key? key,
      required this.Logo1,
      required this.CompanyName1,
      required this.Number1,
      required this.Img1,
      required this.ProductName1,
      required this.Quantity1,
      required this.Price1,
      required this.FinalPrice1,
      required this.id})
      : super(key: key);

  @override
  State<UpdateProduct> createState() => _UpdateProductState();
}

class _UpdateProductState extends State<UpdateProduct> {
  // ignore: todo
  // TODO: Implement _loadInterstitialAd()

  GlobalKey previewContainer = GlobalKey();

  final _nameTextController = TextEditingController();
  final _priceTextController = TextEditingController();
  final _finalpriceTextController = TextEditingController();
  final _finalpriceTextController1 = TextEditingController();
  final _quantityTextController = TextEditingController();

  final _formKey = GlobalKey<FormState>();
  final _formKey1 = GlobalKey<FormState>();

  File? _image;

  bool isLoading = false;
  String productimage =
      "https://firebasestorage.googleapis.com/v0/b/price-b66f7.appspot.com/o/companyimage.jpg?alt=media&token=1b9df9b9-0061-445e-81d2-8be34e429a52";
  @override
  void initState() {
    _nameTextController.text = widget.ProductName1;
    _priceTextController.text = widget.Price1;
    _finalpriceTextController.text = widget.FinalPrice1;
    _quantityTextController.text = widget.Quantity1;

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
        appBar: appbar(text: "Update Product Details", actions: [
          IconButton(
            onPressed: () async {
              final FireAuth1 object = FireAuth1();
              String uuid = await object.getUserId();
              delete_alert(
                context: context,
                ontap: () {
                  FirebaseFirestore.instance
                      .collection("Users")
                      .doc(uuid)
                      .collection("Product detail")
                      .doc(widget.id)
                      .delete();

                 Navigator.pushNamed(context,'/HomePage');
                },
              );
            },
            icon: const Icon(
              Icons.delete,
            ),
          ),
        ]),
        drawer: drawerpage(),
        body: SingleChildScrollView(
          child: isLoading
              ? const Center(child: CircularProgressIndicator())
              : Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Container(
                        height: 23.h,
                        width: 100.w,
                        decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(10),
                            color: Color.fromARGB(255, 196, 229, 245)),
                        child: Padding(
                          padding: const EdgeInsets.only(
                              left: 10, right: 10, top: 5),
                          child: Column(
                            children: <Widget>[
                              Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: <Widget>[
                                  Text(
                                    "Company Details",
                                    style: TextStyle(
                                      fontSize: 14.sp,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                  CircleAvatar(
                                    backgroundColor:
                                        Colors.white.withOpacity(0.5),
                                    child: IconButton(
                                      onPressed: () {
                                        sharedata();
                                      },
                                      icon: const Icon(
                                        Icons.share,
                                        color:
                                            Color.fromARGB(255, 65, 105, 119),
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                              Padding(
                                padding: const EdgeInsets.all(10.0),
                                child: Row(
                                  crossAxisAlignment: CrossAxisAlignment.center,
                                  children: <Widget>[
                                    CircleAvatar(
                                      radius: 35,
                                      child: Container(
                                        clipBehavior:
                                            Clip.antiAliasWithSaveLayer,
                                        height: 30.h,
                                        width: 30.w,
                                        decoration: const BoxDecoration(
                                            shape: BoxShape.circle),
                                        child: widget.Logo1.isNotEmpty
                                            ? imewidget(img: widget.Logo1)
                                            : Container(),
                                      ),
                                    ),
                                    SizedBox(
                                      width: 5.w,
                                    ),
                                    Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: <Widget>[
                                        Text(
                                          widget.CompanyName1,
                                          style: TextStyle(
                                            fontSize: 16.0.sp,
                                            fontWeight: FontWeight.w500,
                                            // color: Color.fromARGB(255, 2, 89, 120),
                                          ),
                                        ),
                                        SizedBox(
                                          height: 1.0.h,
                                        ),
                                        Text(
                                          widget.Number1,
                                          style: TextStyle(
                                              // color: Color.fromARGB(255, 2, 89, 120),
                                              fontWeight: FontWeight.w600),
                                        ),
                                      ],
                                    ),
                                  ],
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),
                  
                    Container(
                      height: 65.h,
                      width: 100.w,
                      color: Color.fromARGB(255, 242, 242, 242),
                      child: Column(
                        children: <Widget>[
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceAround,
                            children: <Widget>[
                              Stack(
                                children: <Widget>[
                                  imagecontainer(
                                      child: _image != null
                                          ? Image.file(File(_image!.path),
                                              fit: BoxFit.fill)
                                          : widget.Img1.isNotEmpty
                                              ? imewidget(img: widget.Img1)
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
                                              selectOrTakePhoto(
                                                  ImageSource.gallery);

                                              Navigator.pop(context);
                                            },
                                            camera: () {
                                              selectOrTakePhoto(
                                                  ImageSource.camera);
                                              Navigator.pop(context);
                                            },
                                          );
                                        },
                                        icon: Icon(Icons.camera_alt,
                                            size: 7.h,
                                            color: Color.fromARGB(
                                                    255, 65, 105, 119)
                                                .withOpacity(0.6))),
                                  ),
                                ],
                              ),
                              Padding(
                                padding: const EdgeInsets.only(top: 8),
                                child: Card(
                                  child: SizedBox(
                                    height: 46.h,
                                    width: 55.w,
                                    child: Padding(
                                      padding: const EdgeInsets.symmetric(
                                          horizontal: 8, vertical: 8),
                                      child: Column(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        children: <Widget>[
                                          Text(
                                            "Product Details",
                                            style: TextStyle(
                                                fontSize: 14.sp,
                                                fontWeight: FontWeight.bold,
                                                color: Color.fromARGB(
                                                    255, 65, 105, 119)),
                                          ),
                                          SizedBox(
                                            height: 3.h,
                                          ),
                                          Text(
                                            "Product Name",
                                            style: TextStyle(
                                                fontSize: 11.sp,
                                                fontWeight: FontWeight.w700),
                                          ),
                                          SizedBox(
                                            height: 0.5.h,
                                          ),
                                          Form(
                                            key: _formKey,
                                            child: textfield(
                                              controller: _nameTextController,
                                              style: TextStyle(fontSize: 12.sp),
                                              validator: (name) {
                                                if (name!.isEmpty) {
                                                  return "Please enter product name";
                                                }
                                                return null;
                                              },
                                              contentPadding:
                                                  const EdgeInsets.fromLTRB(
                                                      5, 6, 5, 6),
                                            ),
                                          ),
                                          SizedBox(
                                            height: 1.5.h,
                                          ),
                                          Text(
                                            "Quantity",
                                            style: TextStyle(
                                                fontSize: 11.sp,
                                                fontWeight: FontWeight.w700),
                                          ),
                                          SizedBox(
                                            height: 0.5.h,
                                          ),
                                          textfield(
                                            controller: _quantityTextController,
                                            style: TextStyle(fontSize: 12.sp),
                                            keyboardType: TextInputType.number,
                                            inputFormatters: <
                                                TextInputFormatter>[
                                              FilteringTextInputFormatter
                                                  .digitsOnly
                                            ],
                                            contentPadding:
                                                const EdgeInsets.fromLTRB(
                                                    5, 6, 5, 6),
                                          ),
                                          SizedBox(
                                            height: 1.5.h,
                                          ),
                                          Text(
                                            "Price",
                                            style: TextStyle(
                                                fontSize: 11.sp,
                                                fontWeight: FontWeight.w700),
                                          ),
                                          SizedBox(
                                            height: 0.5.h,
                                          ),
                                          textfield(
                                            controller: _priceTextController,
                                            style: TextStyle(fontSize: 12.sp),
                                            inputFormatters: <
                                                TextInputFormatter>[
                                              FilteringTextInputFormatter.allow(
                                                  RegExp(r'^\d+\.?\d{0,2}')),
                                              TextInputFormatter.withFunction(
                                                  (oldValue, newValue) {
                                                try {
                                                  final text = newValue.text;
                                                  if (text.isNotEmpty) {
                                                    double.parse(text);
                                                  }
                                                  return newValue;
                                                } catch (e) {}
                                                return oldValue;
                                              }),
                                            ],
                                            keyboardType: const TextInputType
                                                    .numberWithOptions(
                                                decimal: true, signed: false),
                                            contentPadding:
                                                const EdgeInsets.fromLTRB(
                                                    5, 6, 5, 6),
                                          ),
                                          SizedBox(
                                            height: 1.5.h,
                                          ),
                                          Text(
                                            "Final Price",
                                            style: TextStyle(
                                                fontSize: 11.sp,
                                                fontWeight: FontWeight.w700),
                                          ),
                                          SizedBox(
                                            height: 0.5.h,
                                          ),
                                          textfield(
                                            controller:
                                                _finalpriceTextController,
                                            style: TextStyle(fontSize: 12.sp),
                                            inputFormatters: <
                                                TextInputFormatter>[
                                              FilteringTextInputFormatter.allow(
                                                  RegExp(r'^\d+\.?\d{0,2}')),
                                              TextInputFormatter.withFunction(
                                                  (oldValue, newValue) {
                                                try {
                                                  final text = newValue.text;
                                                  if (text.isNotEmpty) {
                                                    double.parse(text);
                                                  }
                                                  return newValue;
                                                } catch (e) {}
                                                return oldValue;
                                              }),
                                            ],
                                            keyboardType: const TextInputType
                                                    .numberWithOptions(
                                                decimal: true, signed: false),
                                            contentPadding:
                                                const EdgeInsets.fromLTRB(
                                                    5, 6, 5, 6),
                                          )
                                        ],
                                      ),
                                    ),
                                  ),
                                ),
                              )
                            ],
                          ),
                          SizedBox(
                            height: 6.h,
                          ),
                          Center(
                            child: button(
                              width: 50.w,
                              height: 7.h,
                              onpressed: () async {
                                final FireAuth1 object = FireAuth1();
                                String uuid = await object.getUserId();
                                if (_formKey.currentState!.validate() &&
                                    productimage == widget.Img1 &&
                                    _image != null) {
                                  setState(() {
                                    isLoading = true;
                                  });
                                  var uniqueKey = FirebaseFirestore.instance
                                      .collection("Users")
                                      .doc(uuid)
                                      .collection("Product detail")
                                      .doc(widget.id);
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
                                    var uploadPath = await uploadTask
                                        .snapshot.ref
                                        .getDownloadURL();

                                    if (uploadPath.isNotEmpty) {
                                      FirebaseFirestore.instance
                                          .collection("Users")
                                          .doc(uuid)
                                          .collection("Product detail")
                                          .doc(uniqueKey.id)
                                          .update({
                                        "Image": uploadPath,
                                        "Logo": widget.Logo1,
                                        "Company Name": widget.CompanyName1,
                                        "Number": widget.Number1,
                                        "Product Name":
                                            _nameTextController.text,
                                        "Quantity":
                                            _quantityTextController.text,
                                        "Price": _priceTextController.text,
                                        "Final_Price":
                                            _finalpriceTextController.text,
                                        "bool": "false",
                                        'createdAt': DateTime.now()
                                      }).then((value) {
                                        Navigator.pop(context);
                                      });
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
                                } else {
                                  if (_formKey.currentState!.validate() &&
                                      _image != null) {
                                    Reference reference = FirebaseStorage
                                        .instance
                                        .refFromURL(widget.Img1.toString());

                                    UploadTask uploadTask =
                                        reference.putFile(File(_image!.path));

                                    uploadTask.snapshotEvents.listen((event) {
                                      print(event.bytesTransferred.toString() +
                                          "\t" +
                                          event.totalBytes.toString());
                                    });

                                    await uploadTask.whenComplete(() async {
                                      var uploadPath = await uploadTask
                                          .snapshot.ref
                                          .getDownloadURL();

                                      if (uploadPath.isNotEmpty) {
                                        FirebaseFirestore.instance
                                            .collection("Users")
                                            .doc(uuid)
                                            .collection("Product detail")
                                            .doc(widget.id)
                                            .update({
                                          "Image": uploadPath,
                                          "Logo": widget.Logo1,
                                          "Company Name": widget.CompanyName1,
                                          "Number": widget.Number1,
                                          "Product Name":
                                              _nameTextController.text,
                                          "Quantity":
                                              _quantityTextController.text,
                                          "Price": _priceTextController.text,
                                          "Final_Price":
                                              _finalpriceTextController.text,
                                          "bool": false,
                                          'createdAt': DateTime.now()
                                        }).then((value) =>
                                                Navigator.pop(context));
                                      } else {
                                        Fluttertoast.showToast(
                                          msg:
                                              "Somthing went wrong \nPlease try again.",
                                          gravity: ToastGravity.BOTTOM,
                                          toastLength: Toast.LENGTH_SHORT,
                                          textColor: Colors.grey,
                                        );
                                      }
                                    });
                                  } else if (_formKey.currentState!
                                      .validate()) {
                                    FirebaseFirestore.instance
                                        .collection("Users")
                                        .doc(uuid)
                                        .collection("Product detail")
                                        .doc(widget.id)
                                        .update({
                                      "Image": widget.Img1,
                                      "Logo": widget.Logo1,
                                      "Company Name": widget.CompanyName1,
                                      "Number": widget.Number1,
                                      "Product Name": _nameTextController.text,
                                      "Quantity": _quantityTextController.text,
                                      "Price": _priceTextController.text,
                                      "Final_Price":
                                          _finalpriceTextController.text,
                                      "bool": false,
                                      'createdAt': DateTime.now()
                                    }).then((value) => Navigator.pop(context));
                                  }
                                }
                              },
                              child: const Text(
                                "Update",
                                style: TextStyle(color: Colors.white),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
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
      ImageLib.decodeImage(await File(widget.Img1).readAsBytes());
    }
  }

  takeScreenShot() async {
    RenderRepaintBoundary boundary = previewContainer.currentContext!
        .findRenderObject() as RenderRepaintBoundary;
    ui.Image image = await boundary.toImage();
    final directory = (await getApplicationDocumentsDirectory()).path;
    // ignore: unnecessary_cast
    ByteData? byteData = await (image.toByteData(format: ui.ImageByteFormat.png)
        as FutureOr<ByteData?>);
    Uint8List pngBytes = byteData!.buffer.asUint8List();
    var uploadimage = File('$directory/123.png');
    uploadimage.writeAsBytes(pngBytes);
    if (uploadimage != null) {
      Share.shareFiles(['$directory/123.png'],
          text:
              "I have generated using *PriceList* App!\n it's available on PlayStore, You can download it from here : \n https://play.google.com/store/apps/details?id=com.tryon.pricelist");
    }
  }

  Future<void> sharedata() async {
    return await showDialog(
      context: context,
      builder: (BuildContext context) {
        return Dialog(
          insetPadding: const EdgeInsets.all(10),
          child: SingleChildScrollView(
            child: Padding(
              padding: const EdgeInsets.all(8.0),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: <Widget>[
                  RepaintBoundary(
                    key: previewContainer,
                    child: Card(
                      child: Container(
                        height: 50.h,
                        width: double.infinity,
                        decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(10),
                            border: Border.all(color: Colors.black)),
                        child: Padding(
                          padding: const EdgeInsets.all(4.0),
                          child: Container(
                            decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(5),
                                border: Border.all(color: Colors.black)),
                            child: Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: SingleChildScrollView(
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.center,
                                  children: <Widget>[
                                    Center(
                                      child: Padding(
                                        padding: const EdgeInsets.all(0.0),
                                        child: Row(
                                          crossAxisAlignment:
                                              CrossAxisAlignment.center,
                                          mainAxisAlignment:
                                              MainAxisAlignment.center,
                                          children: <Widget>[
                                            CircleAvatar(
                                              radius: 40,
                                              child: Container(
                                                clipBehavior:
                                                    Clip.antiAliasWithSaveLayer,
                                                height: 30.h,
                                                width: 30.w,
                                                decoration: const BoxDecoration(
                                                    shape: BoxShape.circle),
                                                child: widget.Logo1.isNotEmpty
                                                    ? imewidget(
                                                        img: widget.Logo1)
                                                    : Container(),
                                              ),
                                            ),
                                            SizedBox(
                                              width: 5.w,
                                            ),
                                            Column(
                                              crossAxisAlignment:
                                                  CrossAxisAlignment.start,
                                              children: <Widget>[
                                                Text(
                                                  widget.CompanyName1,
                                                  style: TextStyle(
                                                      fontSize: 16.0.sp,
                                                      fontWeight:
                                                          FontWeight.w500),
                                                ),
                                                SizedBox(
                                                  height: 1.0.h,
                                                ),
                                                Text(widget.Number1),
                                              ],
                                            ),
                                          ],
                                        ),
                                      ),
                                    ),
                                    SizedBox(
                                      height: 3.h,
                                    ),
                                    Divider(
                                      thickness: 0.1.h,
                                      color: const Color.fromARGB(
                                          255, 161, 160, 160),
                                    ),
                                    Center(
                                      child: Text(
                                        widget.ProductName1,
                                        style: TextStyle(
                                          fontSize: 22.sp,
                                          fontFamily: "Alkalami",
                                        ),
                                      ),
                                    ),
                                    Divider(
                                      thickness: 0.1.h,
                                      color: const Color.fromARGB(
                                          255, 161, 160, 160),
                                    ),
                                    SizedBox(
                                      height: 1.h,
                                    ),
                                    Card(
                                      elevation: 2.0,
                                      child: ListTile(
                                        leading: Container(
                                            clipBehavior:
                                                Clip.antiAliasWithSaveLayer,
                                            height: 13.h,
                                            width: 13.w,
                                            decoration: BoxDecoration(
                                                borderRadius:
                                                    BorderRadius.circular(7)),
                                            child: imewidget(img: widget.Img1)),
                                        subtitle: Column(
                                          crossAxisAlignment:
                                              CrossAxisAlignment.start,
                                          children: <Widget>[
                                            Table(
                                              children: [
                                                TableRow(
                                                  children: <Widget>[
                                                    Text(
                                                      "Quantity :",
                                                      style: TextStyle(
                                                          fontFamily:
                                                              "Alkalami",
                                                          fontWeight:
                                                              FontWeight.bold,
                                                          fontSize: 14.sp),
                                                    ),
                                                    Text(
                                                      widget.Quantity1,
                                                      style: TextStyle(
                                                          fontFamily:
                                                              "Alkalami",
                                                          fontWeight:
                                                              FontWeight.bold,
                                                          fontSize: 14.sp),
                                                    ),
                                                  ],
                                                ),
                                                TableRow(
                                                  children: <Widget>[
                                                    Text(
                                                      "Price :",
                                                      style: TextStyle(
                                                          fontFamily:
                                                              "Alkalami",
                                                          fontWeight:
                                                              FontWeight.bold,
                                                          fontSize: 14.sp),
                                                    ),
                                                    Text(
                                                      widget.Price1,
                                                      style: TextStyle(
                                                          fontFamily:
                                                              "Alkalami",
                                                          fontWeight:
                                                              FontWeight.bold,
                                                          fontSize: 14.sp),
                                                    ),
                                                  ],
                                                ),
                                                TableRow(
                                                  children: <Widget>[
                                                    Text(
                                                      "Discounted:",
                                                      style: TextStyle(
                                                          fontFamily:
                                                              "Alkalami",
                                                          fontWeight:
                                                              FontWeight.bold,
                                                          fontSize: 14.sp),
                                                    ),
                                                    Form(
                                                      key: _formKey1,
                                                      child: TextFormField(
                                                        controller:
                                                            _finalpriceTextController1
                                                              ..text = widget
                                                                  .FinalPrice1,
                                                        style: TextStyle(
                                                            fontFamily:
                                                                "Alkalami",
                                                            fontWeight:
                                                                FontWeight.bold,
                                                            fontSize: 14.sp),
                                                        inputFormatters: [
                                                          FilteringTextInputFormatter
                                                              .allow(RegExp(
                                                                  r'^\d+\.?\d{0,2}')),
                                                          TextInputFormatter
                                                              .withFunction(
                                                                  (oldValue,
                                                                      newValue) {
                                                            try {
                                                              final text =
                                                                  newValue.text;
                                                              if (text
                                                                  .isNotEmpty) {
                                                                double.parse(
                                                                    text);
                                                              }
                                                              return newValue;
                                                            } catch (e) {}
                                                            return oldValue;
                                                          }),
                                                        ],
                                                        keyboardType:
                                                            const TextInputType
                                                                    .numberWithOptions(
                                                                decimal: true,
                                                                signed: false),
                                                        validator:
                                                            (finalprice) {
                                                          if (finalprice!
                                                              .isEmpty) {
                                                            return "Please enter final price";
                                                          }
                                                          return null;
                                                        },
                                                        decoration:
                                                            const InputDecoration(
                                                          isDense: true,
                                                          contentPadding:
                                                              EdgeInsets
                                                                  .fromLTRB(0,
                                                                      0, 0, 0),
                                                          errorBorder:
                                                              UnderlineInputBorder(
                                                            borderSide:
                                                                BorderSide(
                                                              color: Colors.red,
                                                            ),
                                                          ),
                                                          border:
                                                              InputBorder.none,
                                                        ),
                                                      ),
                                                    ),
                                                  ],
                                                ),
                                              ],
                                            ),
                                          ],
                                        ),
                                      ),
                                    ),
                                    SizedBox(
                                      height: 2.h,
                                    ),
                                    Row(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.center,
                                      children: <Widget>[
                                        Expanded(
                                            flex: 1,
                                            child: Image.asset(
                                                "assets/pricelist.png")),
                                        Padding(padding: EdgeInsets.all(5)),
                                        Expanded(
                                          flex: 2,
                                          child: Column(
                                            children: <Widget>[
                                              Text("Download Pricelist App",
                                                  style: TextStyle(
                                                      fontFamily: "Alkalami",
                                                      fontWeight:
                                                          FontWeight.bold,
                                                      fontSize: 12.sp)),
                                              SizedBox(
                                                height: 0.5.h,
                                              ),
                                              Text(
                                                "Grow Buissness With Pricelist",
                                                style: TextStyle(
                                                  fontFamily: "Alkalami",
                                                  fontWeight: FontWeight.bold,
                                                ),
                                              ),
                                              SizedBox(
                                                height: 0.5.h,
                                              ),
                                              Text(
                                                " Listout And Share Your Product And Catalogue For Your Buissness",
                                                style: TextStyle(
                                                  fontFamily: "Alkalami",
                                                ),
                                              )
                                            ],
                                          ),
                                        )
                                      ],
                                    )
                                  ],
                                ),
                              ),
                            ),
                          ),
                        ),
                      ),
                    ),
                  ),
                  SizedBox(
                    height: 2.h,
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: <Widget>[
                      button(
                        onpressed: () {
                          Navigator.pop(context);
                        },
                        child: const Text(
                          "Cancel",
                          style: TextStyle(color: Colors.white),
                        ),
                      ),
                      button(
                        onpressed: () async {
                          final FireAuth1 object = FireAuth1();
                          String uuid = await object.getUserId();
                          if (_formKey1.currentState!.validate()) {
                            FirebaseFirestore.instance
                                .collection("Users")
                                .doc(uuid)
                                .collection("Product detail")
                                .doc(widget.id)
                                .update({
                              "Final_Price": _finalpriceTextController1.text,
                            }).then((value) {
                              takeScreenShot();
                            });
                          }
                        },
                        child: const Text(
                          "Share",
                          style: TextStyle(color: Colors.white),
                        ),
                      )
                    ],
                  )
                ],
              ),
            ),
          ),
        );
      },
    );
  }
}

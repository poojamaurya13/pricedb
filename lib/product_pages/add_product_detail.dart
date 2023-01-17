// ignore_for_file: camel_case_types, prefer_typing_uninitialized_variables, avoid_print, deprecated_member_use, empty_catches

import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';
import 'package:image_picker_android/image_picker_android.dart';
import 'package:image_picker_platform_interface/image_picker_platform_interface.dart';
import 'package:pricedb/login_pages/fire_auth.dart';
import 'package:pricedb/model_pages/ad_provider.dart';
import 'package:pricedb/model_pages/model.dart';
import 'package:pricedb/screens/drawerscreen.dart';
import 'package:provider/provider.dart';
import 'package:sizer/sizer.dart';
// ignore: library_prefixes
import 'package:image/image.dart' as ImageLib;

class ProductDetail extends StatefulWidget {
  const ProductDetail({Key? key}) : super(key: key);

  @override
  State<ProductDetail> createState() => _ProductDetailState();
}

class _ProductDetailState extends State<ProductDetail> {
  final _formKey = GlobalKey<FormState>();

  final _productnameTextController = TextEditingController();
  final _priceTextController = TextEditingController();
  final _finalpriceTextController = TextEditingController();
  final _quantityTextController = TextEditingController();

  final _focusproductname = FocusNode();
  final _focusprice = FocusNode();
  final _focusfinalprice = FocusNode();
  final _focusquantity = FocusNode();

  var carMake;
  var setDefaultMake = true, setDefaultMakeModel = true;

  bool isLoading = false;

  File? _image;
  String? uuid;

  @override
  void initState() {
    WidgetsBinding.instance?.addPostFrameCallback((timeStamp) async {
      final FireAuth1 object = FireAuth1();
      uuid = await object.getUserId();
      setState(() {});
    });

    AdList = [
      "b",
    ];
    Load_Ads().loadads(context, AdList);
    todispose = xyz;
    super.initState();
  }

  @override
  void dispose() {
    xyz("a");
    super.dispose();
  }

  xyz([x]) {
    Load_Ads().disposeads(context, AdList);
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () {
      Navigator.pushNamed(context,'/HomePage');
        return Future.value(true);
      },
      child: Scaffold(
        bottomNavigationBar: SizedBox(
          height: bannerAd.size.height.toDouble(),
          width: bannerAd.size.width.toDouble(),
          child: context.watch<Ad_Provider>().isBannerAdReady
              ? AdWidget(ad: bannerAd)
              : const Center(
                  child: Text("loading ads...",
                      style: TextStyle(color: Colors.black)),
                ),
        ),
        appBar: appbar(
          text: "Add Product Details",
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
                          "Product photo",
                          style: TextStyle(
                              fontSize: 12.sp, fontWeight: FontWeight.w500),
                        ),
                        SizedBox(height: 3.0.h),
                        Container(
                          decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(8.0),
                              border: Border.all(
                                color: const Color.fromARGB(255, 65, 105, 119),
                              )),
                          child: Padding(
                            padding: const EdgeInsets.symmetric(horizontal: 8),
                            child: StreamBuilder(
                              stream: FirebaseFirestore.instance
                                  .collection("Users")
                                  .doc(uuid)
                                  .collection("Company detail")
                                  .snapshots(),
                              builder: (BuildContext context,
                                  AsyncSnapshot<QuerySnapshot> snapshot) {
                                return Padding(
                                  padding: const EdgeInsets.only(right: 10),
                                  child: DropdownButtonHideUnderline(
                                    child: DropdownButton<dynamic>(
                                      borderRadius: BorderRadius.circular(8),
                                      hint: Text(
                                        "Select company name",
                                        style: TextStyle(
                                            fontSize: 13.sp,
                                            fontWeight: FontWeight.w500),
                                      ),
                                      isExpanded: true,
                                      value: carMake,
                                      items: snapshot.data?.docs
                                          .map<DropdownMenuItem>((value) {
                                        return DropdownMenuItem(
                                          value: value.get("Company Name"),
                                          child: Text(
                                              '${value.get("Company Name")}',
                                              style: TextStyle(
                                                  fontSize: 13.sp,
                                                  fontWeight: FontWeight.w500,
                                                  color: const Color.fromARGB(
                                                      255, 74, 127, 147))),
                                        );
                                      }).toList(),
                                      onChanged: (value) {
                                        debugPrint('selected onchange: $value');
                                        if (value == null) {
                                          return print(
                                              "Please enter company name");
                                        }
                                        setState(
                                          () {
                                            debugPrint('make selected: $value');

                                            carMake = value;

                                            setDefaultMake = false;

                                            setDefaultMakeModel = true;
                                          },
                                        );
                                      },
                                    ),
                                  ),
                                );
                              },
                            ),
                          ),
                        ),
                        SizedBox(height: 2.0.h),
                        Form(
                          key: _formKey,
                          child: textfield(
                            style: TextStyle(
                                fontSize: 13.sp, fontWeight: FontWeight.w500),
                            cursorHeight: 4.0.h,
                            controller: _productnameTextController,
                            focusNode: _focusproductname,
                            contentPadding: const EdgeInsets.symmetric(
                                vertical: 15.0, horizontal: 8.0),
                            validator: (name) {
                              if (name!.isEmpty) {
                                return "Please enter product name";
                              }
                              return null;
                            },
                            hinttext: "Product name",
                          ),
                        ),
                        SizedBox(height: 2.0.h),
                        textfield(
                          style: TextStyle(
                              fontSize: 13.sp, fontWeight: FontWeight.w500),
                          cursorHeight: 4.0.h,
                          controller: _quantityTextController,
                          focusNode: _focusquantity,
                          keyboardType: TextInputType.number,
                          inputFormatters: <TextInputFormatter>[
                            FilteringTextInputFormatter.digitsOnly
                          ],
                          contentPadding: const EdgeInsets.symmetric(
                              vertical: 15.0, horizontal: 8.0),
                          hinttext: "Quantity",
                        ),
                        SizedBox(height: 2.0.h),
                        textfield(
                          style: TextStyle(
                              fontSize: 13.sp, fontWeight: FontWeight.w500),
                          cursorHeight: 4.0.h,
                          controller: _priceTextController,
                          focusNode: _focusprice,
                          inputFormatters: <TextInputFormatter>[
                            FilteringTextInputFormatter.allow(
                                RegExp(r'^\d+\.?\d{0,2}')),
                            TextInputFormatter.withFunction(
                                (oldValue, newValue) {
                              try {
                                final text = newValue.text;
                                if (text.isNotEmpty) double.parse(text);
                                return newValue;
                              } catch (e) {}
                              return oldValue;
                            }),
                          ],
                          keyboardType: const TextInputType.numberWithOptions(
                              decimal: true, signed: false),
                          contentPadding: const EdgeInsets.symmetric(
                              vertical: 15.0, horizontal: 8.0),
                          hinttext: "Price",
                        ),
                        SizedBox(height: 2.0.h),
                        textfield(
                          style: TextStyle(
                              fontSize: 13.sp, fontWeight: FontWeight.w500),
                          cursorHeight: 4.0.h,
                          controller: _finalpriceTextController,
                          focusNode: _focusfinalprice,
                          inputFormatters: <TextInputFormatter>[
                            FilteringTextInputFormatter.allow(
                                RegExp(r'^\d+\.?\d{0,2}')),
                            TextInputFormatter.withFunction(
                                (oldValue, newValue) {
                              try {
                                final text = newValue.text;
                                if (text.isNotEmpty) double.parse(text);
                                return newValue;
                              } catch (e) {}
                              return oldValue;
                            }),
                          ],
                          keyboardType: const TextInputType.numberWithOptions(
                              decimal: true, signed: false),
                          contentPadding: const EdgeInsets.symmetric(
                              vertical: 15.0, horizontal: 8.0),
                          hinttext: "Final price(with discount)",
                        ),
                        SizedBox(
                          height: 6.0.h,
                        ),
                        button(
                          height: 7.h,
                          width: 50.w,
                          onpressed: () async {
                            final result1 = await FirebaseFirestore.instance
                                .collection("Users")
                                .doc(uuid)
                                .collection("Company detail")
                                .where("Company Name", isEqualTo: carMake)
                                .get();
                            final value1 = result1.docs
                                .map((doc) => doc.get("Number"))
                                .join(', ');
                            final value2 = result1.docs
                                .map((doc) => doc.get("Image"))
                                .join(', ');

                            if (carMake == null) {
                              selectcompany();
                            } else if (_formKey.currentState!.validate() &&
                                _image != null) {
                              setState(() {
                                isLoading = true;
                              });
                              var uniqueKey = FirebaseFirestore.instance
                                  .collection("Users")
                                  .doc(uuid)
                                  .collection("Product detail")
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

                                if (uploadPath.isNotEmpty &&
                                    value2.isNotEmpty) {
                                  FirebaseFirestore.instance
                                      .collection("Users")
                                      .doc(uuid)
                                      .collection("Product detail")
                                      .doc(uniqueKey.id)
                                      .set({
                                    "Image": uploadPath,
                                    "Logo": value2.toString(),
                                    "Company Name": carMake.toString(),
                                    "Number": value1.toString(),
                                    "Product Name":
                                        _productnameTextController.text,
                                    "Quantity": _quantityTextController.text,
                                    "Price": _priceTextController.text,
                                    "Final_Price":
                                        _finalpriceTextController.text,
                                    "bool": false,
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
                                "Logo": value2.toString(),
                                "Company Name": carMake.toString(),
                                "Number": value1.toString(),
                                "Product Name": _productnameTextController.text,
                                "Quantity": _quantityTextController.text,
                                "Price": _priceTextController.text,
                                "Final_Price": _finalpriceTextController.text,
                                "bool": false,
                                'createdAt': DateTime.now()
                              };
                              FirebaseFirestore.instance
                                  .collection("Users")
                                  .doc(uuid)
                                  .collection("Product detail")
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

  Future<void> selectcompany() async {
    return await showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          content: SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.end,
              mainAxisSize: MainAxisSize.min,
              children: <Widget>[
                const Text("Please select company name."),
                SizedBox(height: 3.h),
                Padding(
                  padding: const EdgeInsets.only(top: 10.0),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: <Widget>[
                      InkWell(
                        onTap: () {
                          Navigator.of(context).pop();
                        },
                        child: const Text("Ok"),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}

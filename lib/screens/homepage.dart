// ignore_for_file: camel_case_types, avoid_print, non_constant_identifier_names, duplicate_ignore, deprecated_member_use, curly_braces_in_flow_control_structures, empty_catches, prefer_const_constructors, prefer_typing_uninitialized_variables

import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:downloads_path_provider_28/downloads_path_provider_28.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';
import 'package:path_provider/path_provider.dart';
import 'package:pdf/pdf.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:pricedb/login_pages/fire_auth.dart';
import 'package:pricedb/model_pages/ad_provider.dart';
import 'package:pricedb/model_pages/exit.dart';
import 'package:pricedb/model_pages/model.dart';
import 'package:pricedb/product_pages/update_product.dart';
import 'package:pricedb/screens/drawerscreen.dart';
import 'package:pricedb/screens/generating_imgpdf.dart';
import 'package:pricedb/screens/setting_page.dart';
import 'package:pricedb/screens/generating_pdf.dart';
import 'package:printing/printing.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:sizer/sizer.dart';
import 'package:pdf/widgets.dart' as pw;
import 'package:syncfusion_flutter_xlsio/xlsio.dart' as xlsio;

int length = 0;

class HomePage extends StatefulWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  // ignore: todo
  // TODO: Implement _loadInterstitialAd()

  bool _searchBoolean = false;

  int toggleValue = 0;
  final _nameTextController = TextEditingController();

  String name = "";

  List productinfoList_new = [];

  Future fetchDatabaseList_new() async {
    dynamic resultant = await DatabaseManager().getProductList();

    if (resultant == null) {
      print("Unable to upload");
    } else {
      setState(() {
        productinfoList_new = resultant;
        length = productinfoList_new.length;
      });
    }
  }

  String? uuid;

  @override
  void initState() {
    ischeckedvalue();
    ischeckedpdf();
    _nameTextController.clear();

    WidgetsBinding.instance?.addPostFrameCallback(
      (timeStamp) async {
        final FireAuth1 object = FireAuth1();
        uuid = await object.getUserId();
        final provider =
            Provider.of<LognpressedProvider>(context, listen: false);
        provider.islongpressfalse(uuid);
        await fetchDatabaseList_new();
      },
    );
    AdList = [
      "b",
      "i",
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
    x != null ? null : generate();
  }

  Future<void> ischeckedvalue() async {
    final prefs = await SharedPreferences.getInstance();
    isChecked = prefs.getBool('isCheckboxChecked') ?? true;
    isChecked1 = prefs.getBool('isCheckboxChecked1') ?? true;
    isChecked2 = prefs.getBool('isCheckboxChecked2') ?? true;
    isChecked3 = prefs.getBool('isCheckboxChecked3') ?? true;
  }

  final GlobalKey<ScaffoldState> _scaffoldState = GlobalKey<ScaffoldState>();
  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider<LognpressedProvider>(
      create: (context) => LognpressedProvider(),
      child: Consumer<LognpressedProvider>(
        builder: (context, provider, child) {
          return WillPopScope(
            onWillPop: () {
              if (islongpressed == false) {
                showExitPopup(
                  context: context,
                  text: "Exit",
                  onpressed1: () {
                    Navigator.pop(context);
                  },
                  onpressed: () {
                    exit(0);
                  },
                );
              } else {
                provider.islongpressfalse(uuid);
                return Future.value(false);
              }
              return Future.value(true);
            },
            child: Scaffold(
              key: _scaffoldState,
              backgroundColor: Colors.white,
              bottomNavigationBar: SizedBox(
                height: bannerAd.size.height.toDouble(),
                width: bannerAd.size.width.toDouble(),
                child: context.watch<Ad_Provider>().isBannerAdReady
                    ? AdWidget(ad: bannerAd)
                    : Center(
                        child: Text("loading ads...",
                            style: TextStyle(color: Colors.black)),
                      ),
              ),
              appBar: PreferredSize(
                child: Stack(
                  children: <Widget>[
                    Container(
                      child: Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 10),
                        child: Row(
                          children: <Widget>[
                            IconButton(
                              onPressed: () {
                                _scaffoldState.currentState?.openDrawer();
                              },
                              icon: Icon(
                                Icons.menu,
                                color: Colors.white,
                              ),
                            ),
                            SizedBox(
                              width: 5.w,
                            ),
                            Text(
                              "My Price list",
                              style: TextStyle(
                                  fontSize: 13.0.sp,
                                  fontWeight: FontWeight.w600,
                                  color: Colors.white),
                            ),
                            SizedBox(
                              width: 25.w,
                            ),
                            IconButton(
                                onPressed: () async {
                                  final result = await FirebaseFirestore
                                      .instance
                                      .collection("Users")
                                      .doc(uuid)
                                      .collection("Product detail")
                                      .where("bool", isEqualTo: true)
                                      .get();
                                  final value1 = result.docs
                                      .map((doc) => doc.get("bool"))
                                      .join(', ');
                                  if (value1 == "") {
                                    Fluttertoast.showToast(
                                      msg: "Please select products to delete",
                                      gravity: ToastGravity.BOTTOM,
                                      toastLength: Toast.LENGTH_SHORT,
                                      textColor: Colors.grey,
                                    );
                                  } else {
                                    delete_alert(
                                      context: context,
                                      ontap: () async {
                                        print(uuid);
                                        FirebaseFirestore.instance
                                            .collection("Users")
                                            .doc(uuid)
                                            .collection("Product detail")
                                            .where("bool", isEqualTo: true)
                                            .get()
                                            .then((snapshot) {
                                          for (DocumentSnapshot ds
                                              in snapshot.docs) {
                                            ds.reference.delete().then((value) {
                                              islongpressed = false;
                                              Navigator.of(context).pop();
                                            });
                                          }
                                        });
                                      },
                                    ).then((value) {
                                      provider.islongpressfalse(uuid);
                                    });
                                  }
                                },
                                icon: Icon(
                                  Icons.delete,
                                  color: Colors.white,
                                )),
                            IconButton(
                                onPressed: () {
                                  toggleValue = 0;

                                  formatebox();
                                },
                                icon: Icon(Icons.picture_as_pdf,
                                    color: Colors.white))
                          ],
                        ),
                      ),
                      color: Color.fromARGB(255, 65, 105, 119),
                      height: MediaQuery.of(context).size.height * 0.15,
                      width: MediaQuery.of(context).size.width,
                    ),
                    Container(),
                    Positioned(
                      top: 11.h,
                      left: 7.w,
                      right: 7.w,
                      bottom: 1.0.h,
                      child: AppBar(
                        automaticallyImplyLeading: false,
                        backgroundColor: Colors.white,
                        primary: false,
                        title: _searchBoolean
                            ? _searchTextField()
                            : Text(
                                "Tap to search",
                                style: TextStyle(
                                    color: Colors.grey, fontSize: 13.sp),
                              ),
                        actions: <Widget>[
                          !_searchBoolean
                              ? IconButton(
                                  icon: Icon(
                                    Icons.search,
                                    color: Color.fromARGB(255, 65, 105, 119),
                                  ),
                                  onPressed: () {
                                    setState(() {
                                      _searchBoolean = true;
                                    });
                                  },
                                )
                              : IconButton(
                                  icon: const Icon(
                                    Icons.clear,
                                    color: Color.fromARGB(255, 65, 105, 119),
                                  ),
                                  onPressed: () {
                                    setState(() {
                                      _searchBoolean = false;
                                      _nameTextController.clear();
                                    });
                                  },
                                ),
                        ],
                      ),
                    )
                  ],
                ),
                preferredSize: Size.fromHeight(
                  MediaQuery.of(context).size.height * 0.15,
                ),
              ),
              drawer: const drawerpage(),
              body: SingleChildScrollView(
                physics: const ScrollPhysics(),
                child: Column(
                  children: <Widget>[
                    SizedBox(
                      height: 73.h,
                      width: 200.0.w,
                      child: Stack(
                        children: <Widget>[
                          SizerUtil.deviceType == DeviceType.mobile
                              ? SizedBox(
                                  height: 66.0.h,
                                  width: 200.0.w,
                                  child: SafeArea(
                                    child: StreamBuilder(
                                      stream: FirebaseFirestore.instance
                                          .collection("Users")
                                          .doc(uuid)
                                          .collection("Product detail")
                                          .orderBy("createdAt",
                                              descending: true)
                                          .snapshots(),
                                      builder: (___,
                                          AsyncSnapshot<QuerySnapshot>
                                              snapshot) {
                                        if (snapshot.hasData &&
                                            snapshot.data != null) {
                                          print(
                                              "Total Documents : ${snapshot.data!.docs.length}");
                                          if (snapshot.connectionState ==
                                              ConnectionState.waiting) {
                                            return const Center(
                                                child: Text("Loading...."));
                                          }

                                          if (snapshot.data!.docs.isNotEmpty) {
                                            return ListView.builder(
                                              itemBuilder:
                                                  (_______, int index) {
                                                Map<String, dynamic> docData =
                                                    snapshot.data!.docs[index]
                                                        .data();
                                                if (docData.isEmpty) {
                                                  return const Text("Empty");
                                                }
                                                String pro_image =
                                                    docData["Image"];
                                                String pro_name =
                                                    docData["Product Name"];
                                                String pro_qua =
                                                    docData["Quantity"];
                                                String pro_price =
                                                    docData["Price"];
                                                String pro_final_price =
                                                    docData["Final_Price"];
                                                String id = snapshot.data!.docs
                                                    .elementAt(index)
                                                    .id;

                                                if (pro_name
                                                    .toString()
                                                    .toLowerCase()
                                                    .contains(
                                                      name.toLowerCase(),
                                                    )) {
                                                  return productlisttile(
                                                    onLongPress: () {
                                                      provider
                                                          .islongpresstrue();
                                                    },
                                                    img: pro_image,
                                                    title: pro_name,
                                                    qua: pro_qua.isNotEmpty
                                                        ? "Quantity : $pro_qua"
                                                        : null,
                                                    price: pro_price.isNotEmpty
                                                        ? "Price : $pro_price"
                                                        : null,
                                                    finalprice: pro_final_price
                                                            .isNotEmpty
                                                        ? "Final Price(Disc) : $pro_final_price"
                                                        : null,
                                                    trailing: islongpressed ==
                                                            true
                                                        ? Checkbox(
                                                            activeColor: const Color
                                                                    .fromARGB(
                                                                255,
                                                                65,
                                                                105,
                                                                119),
                                                            checkColor: const Color
                                                                    .fromARGB(
                                                                255,
                                                                243,
                                                                242,
                                                                234),
                                                            value:
                                                                docData["bool"],
                                                            onChanged: (bool?
                                                                value) async {
                                                              onlongpress_delete(
                                                                  docData[
                                                                      "bool"],
                                                                  id);
                                                            })
                                                        : const Icon(
                                                            Icons.edit,
                                                            color:
                                                                Color.fromARGB(
                                                                    255,
                                                                    65,
                                                                    105,
                                                                    119),
                                                          ),
                                                    ontap: () {
                                                      Navigator.push(
                                                          context,
                                                          MaterialPageRoute(
                                                              builder: ((context) => UpdateProduct(
                                                                  Logo1: docData[
                                                                      "Logo"],
                                                                  CompanyName1:
                                                                      docData[
                                                                          "Company Name"],
                                                                  Number1: docData[
                                                                      "Number"],
                                                                  Img1:
                                                                      pro_image,
                                                                  ProductName1:
                                                                      pro_name,
                                                                  Quantity1:
                                                                      pro_qua,
                                                                  Price1:
                                                                      pro_price,
                                                                  FinalPrice1:
                                                                      pro_final_price,
                                                                  id: id))));
                                                    },
                                                  );
                                                }

                                                String Logo = snapshot
                                                    .data!.docs
                                                    .elementAt(index)
                                                    .get("Logo");
                                                String CompanyName = snapshot
                                                    .data!.docs
                                                    .elementAt(index)
                                                    .get("Company Name");
                                                String Number = snapshot
                                                    .data!.docs
                                                    .elementAt(index)
                                                    .get("Number");
                                                String ProductName = snapshot
                                                    .data!.docs
                                                    .elementAt(index)
                                                    .get("Product Name");
                                                String Price = snapshot
                                                    .data!.docs
                                                    .elementAt(index)
                                                    .get("Price");
                                                String FinalPrice = snapshot
                                                    .data!.docs
                                                    .elementAt(index)
                                                    .get("Final_Price");
                                                String Quantity = snapshot
                                                    .data!.docs
                                                    .elementAt(index)
                                                    .get("Quantity");
                                                String Img = snapshot.data!.docs
                                                    .elementAt(index)
                                                    .get("Image");
                                                bool val = snapshot.data!.docs
                                                    .elementAt(index)
                                                    .get("bool");
                                                return _searchBoolean
                                                    ? Container()
                                                    : productlisttile(
                                                        onLongPress: () {
                                                          provider
                                                              .islongpresstrue();
                                                        },
                                                        img: Img,
                                                        title: ProductName,
                                                        qua: Quantity.isNotEmpty
                                                            ? "Quantity : $Quantity"
                                                            : null,
                                                        price: Price.isNotEmpty
                                                            ? "Price : $Price"
                                                            : null,
                                                        finalprice: FinalPrice
                                                                .isNotEmpty
                                                            ? "Final Price(Disc) : $FinalPrice"
                                                            : null,
                                                        trailing: islongpressed ==
                                                                true
                                                            ? Checkbox(
                                                                activeColor:
                                                                    const Color.fromARGB(
                                                                        255,
                                                                        65,
                                                                        105,
                                                                        119),
                                                                checkColor:
                                                                    const Color
                                                                            .fromARGB(
                                                                        255,
                                                                        243,
                                                                        242,
                                                                        234),
                                                                value: val,
                                                                onChanged: (bool?
                                                                    value) async {
                                                                  onlongpress_delete(
                                                                      val, id);
                                                                })
                                                            : const Icon(
                                                                Icons.edit,
                                                                color: Color
                                                                    .fromARGB(
                                                                        255,
                                                                        65,
                                                                        105,
                                                                        119),
                                                              ),
                                                        ontap: () {
                                                          Navigator.push(
                                                              context,
                                                              MaterialPageRoute(
                                                                  builder: ((context) => UpdateProduct(
                                                                      Logo1:
                                                                          Logo,
                                                                      CompanyName1:
                                                                          CompanyName,
                                                                      Number1:
                                                                          Number,
                                                                      Img1: Img,
                                                                      ProductName1:
                                                                          ProductName,
                                                                      Quantity1:
                                                                          Quantity,
                                                                      Price1:
                                                                          Price,
                                                                      FinalPrice1:
                                                                          FinalPrice,
                                                                      id: id))));
                                                        },
                                                      );
                                              },
                                              itemCount:
                                                  snapshot.data!.docs.length,
                                            );
                                          }
                                        }
                                        return Center(
                                          child: Text(
                                            "You have not added any products yet.",
                                            style: TextStyle(
                                                fontSize: 13.sp,
                                                fontWeight: FontWeight.w500),
                                          ),
                                        );
                                      },
                                    ),
                                  ),
                                )
                              : SizedBox(
                                  height: 66.0.h,
                                  width: 200.0.w,
                                ),
                          Positioned(
                            bottom: 1.0.h,
                            left: 1.0.w,
                            right: 1.0.w,
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceAround,
                              children: <Widget>[
                                button(
                                    height: 7.h,
                                    width: 45.w,
                                    onpressed: () async {
                                      Navigator.pushNamed(
                                          context, '/CompanyList');
                                    },
                                    child: buttonname(
                                        icon: Icons.business,
                                        text: "Company List")),
                                button(
                                    height: 7.h,
                                    width: 45.w,
                                    onpressed: () async {
                                      Navigator.pushNamed(
                                          context, '/ProductDetail');
                                    },
                                    child: buttonname(
                                        icon: Icons.description,
                                        text: "Add Product")),
                              ],
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
        },
      ),
    );
  }

  onlongpress_delete(bool value, String id) {
    if (value == false) {
      FirebaseFirestore.instance
          .collection("Users")
          .doc(uuid)
          .collection("Product detail")
          .doc(id)
          .update({"bool": true});
    } else if (value == true) {
      FirebaseFirestore.instance
          .collection("Users")
          .doc(uuid)
          .collection("Product detail")
          .doc(id)
          .update({"bool": false});
    }
  }

  Future<void> formatebox() async {
    return await showDialog(
      context: context,
      builder: (BuildContext context) {
        return ChangeNotifierProvider<popupProvider>(
          create: (context) => popupProvider(),
          child: Consumer<popupProvider>(
            builder: (context, provider, child) {
              return Dialog(
                clipBehavior: Clip.antiAlias,
                elevation: 5,
                insetPadding: const EdgeInsets.all(10),
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(20)),
                child: SingleChildScrollView(
                  child: SizedBox(
                    height: 70.h,
                    width: 100.w,
                    child: Column(
                      children: <Widget>[
                        ListTile(
                          tileColor: Color.fromARGB(255, 65, 105, 119),
                          title: Text(
                            "Choose",
                            style: TextStyle(
                              fontSize: 18.sp,
                              fontWeight: FontWeight.bold,
                              color: Color.fromARGB(255, 236, 248, 252),
                            ),
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.all(15.0),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: <Widget>[
                              Text(
                                "In which formate you want to save ?",
                                style: TextStyle(
                                    fontSize: 12.sp,
                                    fontWeight: FontWeight.w500),
                              ),
                              AnimatedToggle(
                                values: const ['ListPDF', 'GridPDF', 'Excel'],
                                onToggleCallback: (value) {
                                  setState(() {
                                    toggleValue = value;
                                  });
                                },
                                buttonColor: Color.fromARGB(255, 65, 105, 119),
                                backgroundColor:
                                    const Color.fromARGB(255, 236, 248, 252),
                                textColor: const Color(0xFFFFFFFF),
                              ),
                              checkboxwidget(
                                text: 'Company Name',
                                selected: cname,
                                onChanged: (bool? value) async {
                                  provider.checkbox(value);
                                },
                                text1: 'Number',
                                selected1: cnumber,
                                onChanged1: (bool? value) async {
                                  provider.checkbox1(value);
                                },
                              ),
                              checkboxwidget(
                                text: 'Product Name',
                                selected: pname,
                                onChanged: (bool? value) async {
                                  provider.checkbox2(value);
                                },
                                text1: 'Quantity',
                                selected1: qty,
                                onChanged1: (bool? value) async {
                                  provider.checkbox3(value);
                                },
                              ),
                              checkboxwidget(
                                text: 'Final Price',
                                selected: fprice,
                                onChanged: (bool? value) async {
                                  provider.checkbox4(value);
                                },
                                text1: 'Price',
                                selected1: price,
                                onChanged1: (bool? value) async {
                                  provider.checkbox5(value);
                                },
                              ),
                              SizedBox(
                                height: 2.h,
                              ),
                              Center(
                                child: SizedBox(
                                  height: 8.h,
                                  width: 40.w,
                                  child: RaisedButton(
                                    color: Color.fromARGB(255, 65, 105, 119),
                                    shape: RoundedRectangleBorder(
                                        borderRadius:
                                            BorderRadius.circular(25)),
                                    onPressed: () {
                                      // 1234
                                      if (interstitialAd != null) {
                                        interstitialAd!.show();
                                      } else {
                                        xyz();
                                      }
                                    },
                                    child: Text(
                                      "Generate",
                                      style: TextStyle(
                                          color: Colors.white, fontSize: 15.sp),
                                    ),
                                  ),
                                ),
                              )
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              );
            },
          ),
        );
      },
    );
  }

  generate() {
    if (toggleValue == 0) {
      pdflist = [];
      length = productinfoList_new.length;
      int min = 0;
      int max = 23;
      min2 = 0;
      max2 = 23;
      if (max > length) {
        ismax = true;
        max = length;
      }
      ismax = false;

      create(min: min, max: max).then((value) async {
        print("len = $length");
        Navigator.pushNamed(context, '/GeneratePDF')
            .then((value) => Navigator.pop(context));
      });
    } else if (toggleValue == 1) {
      pdflist = [];
      length = productinfoList_new.length;
      int min = 0;
      int max = 11;
      min_img2 = 0;
      max_img2 = 11;
      if (max > length) {
        ismax_img = true;
        max = length;
      }
      ismax_img = false;

      imagepdf(min: min, max: max).then((value) async {
        Navigator.pushNamed(context, '/GenerateImgPDF')
            .then((value) => Navigator.pop(context));
      });
    } else if (toggleValue == 2) {
      String date = "${DateTime.now()}";
      List dotremove = date.split("");
      for (var i = 0; i < dotremove.length; i++) {
        if (dotremove[i] == ":") {
          print("12356${dotremove[i]}");
          dotremove.removeAt(i);
          dotremove.insert(i, "_");
        }
        if (dotremove[i] == ".") {
          print("12356${dotremove[i]}");
          dotremove.removeAt(i);
          dotremove.insert(i, "_");
        }
      }
      date = dotremove.join("");
      pdfname(
        title: "Excel",
        text: "Save",
        context: context,
        controller: _nameTextController..text = "pricelist_data$date",
        onPressed: () {
          createExcel().then((value) {
            Navigator.pop(context);
            Fluttertoast.showToast(
              msg: 'Excel file downloaded',
              gravity: ToastGravity.BOTTOM,
              toastLength: Toast.LENGTH_SHORT,
              textColor: Colors.grey,
            );
          });
        },
      ).then((value) => Navigator.of(context).pop());
    }
  }

  Future<List<xlsio.ExcelDataRow>> _buildCustomersDataRowsIH() async {
    List<xlsio.ExcelDataRow> excelDataRows = <xlsio.ExcelDataRow>[];
    final List reports = await DatabaseManager().getProductList();

    List reports_1 = await Future.value(reports);

    excelDataRows = reports_1.map<xlsio.ExcelDataRow>((dataRow) {
      return xlsio.ExcelDataRow(cells: <xlsio.ExcelDataCell>[
        if (cname == true)
          xlsio.ExcelDataCell(
              columnHeader: 'Company Name', value: dataRow["Company Name"]),
        if (cnumber == true)
          xlsio.ExcelDataCell(columnHeader: 'Number', value: dataRow["Number"]),
        if (pname == true)
          xlsio.ExcelDataCell(
              columnHeader: 'Product Name', value: dataRow["Product Name"]),
        if (qty == true)
          xlsio.ExcelDataCell(
              columnHeader: 'Quantity', value: dataRow["Quantity"]),
        if (price == true)
          xlsio.ExcelDataCell(columnHeader: 'Price', value: dataRow["Price"]),
        if (fprice == true)
          xlsio.ExcelDataCell(
              columnHeader: 'Final Price', value: dataRow["Final_Price"]),
      ]);
    }).toList();

    return excelDataRows;
  }

  Future<void> createExcel() async {
    final xlsio.Workbook workbook = xlsio.Workbook();
    final xlsio.Worksheet sheet = workbook.worksheets[0];
    final Future<List<xlsio.ExcelDataRow>> dataRows =
        _buildCustomersDataRowsIH();
    List<xlsio.ExcelDataRow> dataRows_1 = await Future.value(dataRows);
    sheet.importData(dataRows_1, 1, 1);
    sheet.getRangeByName("A1").columnWidth = 10.w;
    sheet.getRangeByName("B1").columnWidth = 6.w;
    sheet.getRangeByName("C1").columnWidth = 10.w;
    sheet.getRangeByName("D1:F1").columnWidth = 4.w;
    final List<int> bytes = workbook.saveAsStream();
    workbook.dispose();
    var status = await Permission.storage.status;
    if (!status.isGranted) {
      await Permission.storage.request();
    }
    final String path = (await DownloadsPathProvider.downloadsDirectory)!.path;
    final String fileName = "$path/${_nameTextController.text}.xlsx";
    final File file = File(fileName);
    await file.writeAsBytes(bytes, flush: true);
  }

  Widget buttonname({IconData? icon, String? text}) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceAround,
      children: <Widget>[
        Icon(icon, color: Colors.white),
        Text(
          text ?? "",
          style: const TextStyle(color: Colors.white),
        ),
      ],
    );
  }

  Widget _searchTextField() {
    return TextField(
      autofocus: true,
      cursorColor: Color.fromARGB(255, 65, 105, 119),
      style: TextStyle(
        color: Color.fromARGB(255, 65, 105, 119),
        fontSize: 13.0.sp,
      ),
      onChanged: (val) {
        setState(() {
          name = val;
        });
      },
      textInputAction: TextInputAction.search,
      decoration: InputDecoration(
        enabledBorder: const UnderlineInputBorder(
          borderSide: BorderSide(color: Colors.white),
        ),
        focusedBorder: const UnderlineInputBorder(
          borderSide: BorderSide(color: Colors.white),
        ),
        hintText: 'Search',
        hintStyle: TextStyle(
          color: Colors.grey,
          // fontSize: 13.0.sp,
        ),
      ),
    );
  }

  Future imagepdf({required int min, required int max}) async {
    var netImage;
    final pdf = pw.Document();
    final font = await rootBundle.load("fonts/Aakar.ttf");
    final ttf = pw.Font.ttf(font);
    for (var i = 0; i < productinfoList_new.length; i++) {
      if (i >= min && i <= max) {
        netImage = await networkImage(productinfoList_new[i]["Image"]);
      }
    }
    var size = MediaQuery.of(context).size;
    final double itemHeight = (size.height - kToolbarHeight - 24) / 3.5;
    final double itemWidth = size.width / 2;
    pdf.addPage(
      pw.Page(
        pageTheme: const pw.PageTheme(
          pageFormat: PdfPageFormat.a3,
          orientation: pw.PageOrientation.portrait,
        ),
        build: (pw.Context context) => pw.GridView(
          crossAxisCount: 3,
          childAspectRatio: (itemWidth / itemHeight),
          children: <pw.Widget>[
            for (var i = 0; i < productinfoList_new.length; i++)
              if (i >= min && i <= max)
                pw.Container(
                  decoration: pw.BoxDecoration(border: pw.Border.all()),
                  child: pw.Padding(
                    padding: const pw.EdgeInsets.all(4),
                    child: pw.Column(
                      children: <pw.Widget>[
                        pw.Container(
                          height: 12.h,
                          width: 20.w,
                          child: pw.Image(netImage),
                        ),
                        pw.SizedBox(height: 2.h),
                        if (pname == true)
                          image_pdf_items(
                              ttf: ttf,
                              title: "Product : ",
                              text: productinfoList_new[i]["Product Name"]),
                        if (pname == true)
                          pw.Divider(
                            thickness: 2,
                          ),
                        if (qty == true)
                          image_pdf_items(
                              ttf: ttf,
                              title: "Qty : ",
                              text: productinfoList_new[i]["Quantity"]),
                        if (qty == true)
                          pw.Divider(
                            thickness: 2,
                          ),
                        if (price == true)
                          image_pdf_items(
                              ttf: ttf,
                              title: "Price : ",
                              text: productinfoList_new[i]["Price"]),
                        if (price == true && fprice == true)
                          pw.Divider(
                            thickness: 2,
                          ),
                        if (fprice == true)
                          image_pdf_items(
                              ttf: ttf,
                              title: "Final : ",
                              text: productinfoList_new[i]["Final_Price"]),
                      ],
                    ),
                  ),
                ),
          ],
        ),
      ),
    );
    Directory documentDirectory = await getApplicationDocumentsDirectory();

    String documentPath = documentDirectory.path;
    number++;

    File file = File("$documentPath/Document$number.pdf");
    pdflist.add("$documentPath/Document$number.pdf");
    file.writeAsBytesSync(await pdf.save());
  }

  Future create({required int min, required int max}) async {
    final pdf = pw.Document();
    final font = await rootBundle.load("fonts/Aakar.ttf");
    final ttf = pw.Font.ttf(font);

    pdf.addPage(
      pw.Page(
        pageTheme: const pw.PageTheme(
          pageFormat: PdfPageFormat.a3,
          orientation: pw.PageOrientation.portrait,
        ),
        build: (pw.Context context) => pw.Padding(
          padding: const pw.EdgeInsets.all(1),
          child: pw.ListView.builder(
            itemBuilder: (context, index1) {
              if (index1 >= min && index1 <= max) {
                pw.TextStyle textStyle1 = pw.TextStyle(
                    fontSize: 16.0.sp, fontWeight: pw.FontWeight.bold);
                pw.TextStyle textStyle2 =
                    pw.TextStyle(fontSize: 16.0.sp, font: ttf);
                return pw.Table(
                  border: pw.TableBorder.all(
                    style: pw.BorderStyle.solid,
                  ),
                  children: [
                    pw.TableRow(
                      children: <pw.Widget>[
                        if (cname == true)
                          pw.Expanded(
                              flex: 1,
                              child: pricelist_item(
                                  text: index1 == 0
                                      ? "Sir no."
                                      : index1.toString(),
                                  textStyle:
                                      index1 == 0 ? textStyle1 : textStyle2)),
                        pw.Expanded(
                            flex: 2,
                            child: pricelist_item(
                                text: index1 == 0
                                    ? "Company Name"
                                    : productinfoList_new[index1 - 1]
                                        ["Company Name"],
                                textStyle:
                                    index1 == 0 ? textStyle1 : textStyle2)),
                        if (cnumber == true)
                          pw.Expanded(
                              flex: 2,
                              child: pricelist_item(
                                  text: index1 == 0
                                      ? "Number"
                                      : productinfoList_new[index1 - 1]
                                          ["Number"],
                                  textStyle:
                                      index1 == 0 ? textStyle1 : textStyle2)),
                        if (pname == true)
                          pw.Expanded(
                              flex: 3,
                              child: pricelist_item(
                                  text: index1 == 0
                                      ? "Product Name"
                                      : productinfoList_new[index1 - 1]
                                          ["Product Name"],
                                  textStyle:
                                      index1 == 0 ? textStyle1 : textStyle2)),
                        if (qty == true)
                          pw.Expanded(
                              flex: 1,
                              child: pricelist_item(
                                  text: index1 == 0
                                      ? "Qty"
                                      : productinfoList_new[index1 - 1]
                                          ["Quantity"],
                                  textStyle:
                                      index1 == 0 ? textStyle1 : textStyle2)),
                        if (price == true)
                          pw.Expanded(
                              flex: 1,
                              child: pricelist_item(
                                  text: index1 == 0
                                      ? "Price"
                                      : productinfoList_new[index1 - 1]
                                          ["Price"],
                                  textStyle:
                                      index1 == 0 ? textStyle1 : textStyle2)),
                        if (fprice == true)
                          pw.Expanded(
                              flex: 1,
                              child: pricelist_item(
                                  text: index1 == 0
                                      ? "Final\nPrice"
                                      : productinfoList_new[index1 - 1]
                                          ["Final_Price"],
                                  textStyle:
                                      index1 == 0 ? textStyle1 : textStyle2)),
                      ],
                    ),
                  ],
                );
              } else {
                return pw.Container();
              }
            },
            itemCount: productinfoList_new.length + 1,
          ),
        ),
      ),
    );
    Directory documentDirectory = await getApplicationDocumentsDirectory();

    String documentPath = documentDirectory.path;
    number++;

    File file = File("$documentPath/Document$number.pdf");
    pdflist.add("$documentPath/Document$number.pdf");
    file.writeAsBytesSync(await pdf.save());
  }
}

pw.Column pricelist_item({String? text, pw.TextStyle? textStyle}) {
  return pw.Column(
    children: <pw.Widget>[
      pw.Padding(
        padding: const pw.EdgeInsets.symmetric(vertical: 10.0),
        child: pw.Text(
          text ?? "",
          style: textStyle,
        ),
      ),
    ],
  );
}

List<String> pdflist = [];
bool cname = true;
bool cnumber = true;
bool pname = true;
bool qty = true;
bool fprice = true;
bool price = true;
var islongpressed = false;

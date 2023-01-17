// ignore_for_file: prefer_typing_uninitialized_variables, avoid_print, deprecated_member_use

import 'dart:io';

import 'package:flutter/material.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';
import 'package:hive/hive.dart';
import 'package:pricedb/model_pages/ad_provider.dart';
import 'package:pricedb/model_pages/model.dart';
import 'package:pricedb/screens/pdf_view.dart';
import 'package:provider/provider.dart';
import 'package:share_plus/share_plus.dart';
import 'package:sizer/sizer.dart';

class PdfList extends StatefulWidget {
  const PdfList({Key? key}) : super(key: key);

  @override
  State<PdfList> createState() => _PdfListState();
}

class _PdfListState extends State<PdfList> {
  //for list pdf
  Box<String>? pdf;
  int b = 0;
  var a;
  file(String key) async {
    String? value = pdf!.get(key);
    filename = value!;
    doesFileExists = await File(filename).exists();

    if (doesFileExists == false) {
      doesFileExists ? null : deletewidget(key, filename);
    }
  }

  //for gridview

  Box<String>? imgpdf;
  int d = 0;
  var c;
  imgfile(String key) async {
    String? value = imgpdf!.get(key);
    filename = value!;
    doesFileExists = await File(filename).exists();

    if (doesFileExists == false) {
      doesFileExists ? null : deletewidget(key, value);
    }
  }

  @override
  void initState() {
    //for list pdf
    pdf = Hive.box<String>("PDF");
    for (var i = 0; i < pdf!.length; i++) {
      final key = pdf?.keys.toList()[i];

      file(key);
      if (i == pdf!.length) {
        setState(() {});
      }
    }

    //for gridview
    imgpdf = Hive.box<String>("ImagePDF");
    for (var i = 0; i < imgpdf!.length; i++) {
      final key = imgpdf?.keys.toList()[i];

      imgfile(key);
      if (i == imgpdf!.length) {
        setState(() {});
      }
    }

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
    x != null ? Load_Ads().disposeads(context, AdList) : null;
    if (x == null) {
      if (b == 1) {
        deletewidget(a, pdf!.get(a));
      }
      if (b == 2) {
        share(a);
      }
      if (d == 1) {
        deletewidget(c, imgpdf!.get(c));
      }
      if (d == 2) {
        share(c);
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () {
        Navigator.pushNamed(context,'/HomePage');
        return Future.value(true);
      },
      child: DefaultTabController(
        length: 2,
        child: Scaffold(
          bottomNavigationBar: SizedBox(
            height: bannerAd.size.height.toDouble(),
            width: bannerAd.size.width.toDouble(),
            child: context.watch<Ad_Provider>().isBannerAdReady
                ? AdWidget(ad: bannerAd)
                // ignore: prefer_const_constructors
                : Center(
                    child: const Text("loading ads...",
                        style: TextStyle(color: Colors.black)),
                  ),
          ),
          appBar: appbar(
            text: "PDF History",
            bottom: TabBar(
              unselectedLabelColor: Colors.white,
              indicatorPadding: const EdgeInsets.all(0.0),
              indicator: BoxDecoration(
                  color: Colors.white,
                  border: Border.all(
                      color: const Color.fromARGB(255, 65, 105, 119))),
              labelColor: const Color.fromARGB(255, 65, 105, 119),
              tabs: <Widget>[
                SizedBox(
                  height: 6.h,
                  child: const Tab(
                    text: "List PDF",
                  ),
                ),
                SizedBox(
                  height: 6.h,
                  child: const Tab(
                    text: "Grid PDF",
                  ),
                ),
              ],
            ),
          ),
          body: TabBarView(
            children: <Widget>[
              ListView.builder(
                itemCount: pdf!.length,
                itemBuilder: (BuildContext context, int index) {
                  index = pdf!.length - index - 1;
                  final key = pdf?.keys.toList()[index];

                  final value = pdf?.get(key);
                  List x = [];
                  x = value!.split("/");

                  return Padding(
                    padding:
                        const EdgeInsets.only(left: 8.0, right: 8.0, top: 8.0),
                    child: GestureDetector(
                      onTap: () async {
                        delete = key;
                        filename = value;
                        doesFileExists = await File(filename).exists();
                        doesFileExists ? null : deletewidget(key, value);
                        setState(() {});
                        Navigator.pushNamed(context, '/PdfView');
                      },
                      child: Card(
                        child: ListTile(
                          leading: const Icon(
                            Icons.picture_as_pdf_outlined,
                            size: 30,
                            color: Color.fromARGB(255, 220, 17, 3),
                          ),
                          title: Text(x[x.length - 1]),
                          trailing: FittedBox(
                            child: Row(
                              children: <Widget>[
                                IconButton(
                                    onPressed: () {
                                      //1234
                                      b = 1;
                                      a = key;
                                      if (interstitialAd != null) {
                                        interstitialAd!.show();
                                      } else {
                                        deletewidget(key, value);
                                      }
                                    },
                                    icon: const Icon(
                                      Icons.delete,
                                      color: Color.fromARGB(255, 65, 105, 119),
                                    )),
                                IconButton(
                                  onPressed: () {
                                    //1234
                                    b = 2;
                                    a = value;
                                    if (interstitialAd != null) {
                                      interstitialAd!.show();
                                    } else {
                                      share(value);
                                    }
                                  },
                                  icon: const Icon(
                                    Icons.share,
                                    color: Color.fromARGB(255, 65, 105, 119),
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                      ),
                    ),
                  );
                },
              ),
              ListView.builder(
                physics: const BouncingScrollPhysics(),
                itemCount: imgpdf!.length,
                itemBuilder: (BuildContext context, int index) {
                  index = imgpdf!.length - index - 1;
                  final key = imgpdf?.keys.toList()[index];

                  final value = imgpdf?.get(key);
                  List x = [];
                  x = value!.split("/");

                  return Padding(
                    padding:
                        const EdgeInsets.only(left: 8.0, right: 8.0, top: 8.0),
                    child: GestureDetector(
                      onTap: () async {
                        delete = key;
                        filename = value;
                        doesFileExists = await File(filename).exists();
                        doesFileExists ? null : deletewidget(key, value);
                        setState(() {});
                        Navigator.pushNamed(context, '/PdfView');
                      },
                      child: Card(
                        child: ListTile(
                          leading: const Icon(
                            Icons.picture_as_pdf_outlined,
                            size: 30,
                            color: Color.fromARGB(255, 220, 17, 3),
                          ),
                          title: Text(x[x.length - 1]),
                          trailing: FittedBox(
                            child: Row(
                              children: <Widget>[
                                IconButton(
                                    onPressed: () {
                                      //1234
                                      d = 1;
                                      c = key;
                                      if (interstitialAd != null) {
                                        interstitialAd!.show();
                                      } else {
                                        deletewidget(key, value);
                                      }
                                    },
                                    icon: const Icon(
                                      Icons.delete,
                                      color: Color.fromARGB(255, 65, 105, 119),
                                    )),
                                IconButton(
                                  onPressed: () {
                                    //1234
                                    d = 2;
                                    c = value;
                                    if (interstitialAd != null) {
                                      interstitialAd!.show();
                                    } else {
                                      share(value);
                                    }
                                  },
                                  icon: const Icon(
                                    Icons.share,
                                    color: Color.fromARGB(255, 65, 105, 119),
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                      ),
                    ),
                  );
                },
              ),
            ],
          ),
        ),
      ),
    );
  }

  deletewidget(String key, var val) {
    pdf?.delete(key).then((value) async {
      try {
        if (await File(val).exists()) {
          await File(val).delete();
        }
      } catch (e) {
        // Error in getting access to the file.
        print("error");
      }
    });
    imgpdf?.delete(key).then((value) async {
      try {
        if (await File(val).exists()) {
          await File(val).delete();
        }
      } catch (e) {
        // Error in getting access to the file.
        print("error");
      }
    });
    setState(() {});
  }

  share(String value) {
    Share.shareFiles([value]);
  }
}

String filename = "";
String delete = "";

// ignore_for_file: camel_case_types, avoid_print, non_constant_identifier_names, duplicate_ignore, prefer_const_constructors

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';
import 'package:pricedb/company_pages/update_company.dart';
import 'package:pricedb/model_pages/ad_provider.dart';
import 'package:pricedb/model_pages/model.dart';
import 'package:pricedb/screens/drawerscreen.dart';
import 'package:provider/provider.dart';
import 'package:sizer/sizer.dart';

class CompanyList extends StatefulWidget {
  const CompanyList({Key? key}) : super(key: key);

  @override
  State<CompanyList> createState() => _CompanyListState();
}

class _CompanyListState extends State<CompanyList> {
  User? user = FirebaseAuth.instance.currentUser;

  // ignore: todo
  // TODO: Implement _loadInterstitialAd()

  @override
  void initState() {
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
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () {
        Navigator.pushNamed(context, '/HomePage');
        return Future.value(false);
      },
      child: Scaffold(
        backgroundColor: Colors.white,
        appBar: AppBar(
          elevation: 0.0,
          backgroundColor: Colors.white,
          title: Text(
            "Company List",
            style: TextStyle(
              fontSize: 13.0.sp,
              color: Color.fromARGB(255, 65, 105, 119),
            ),
          ),
          iconTheme: IconThemeData(
            color: Color.fromARGB(255, 65, 105, 119),
          ),
        ),
        drawer: const drawerpage(),
        body: SingleChildScrollView(
          child: Column(
            children: <Widget>[
              SizerUtil.deviceType == DeviceType.mobile
                  ? SizedBox(
                      height: 64.0.h,
                      width: 200.0.w,
                      child: SafeArea(
                        child: StreamBuilder(
                          stream: FirebaseFirestore.instance
                              .collection("Users")
                              .doc(user?.uid)
                              .collection("Company detail")
                              .orderBy("createdAt", descending: true)
                              .snapshots(),
                          builder:
                              (___, AsyncSnapshot<QuerySnapshot> snapshot) {
                            if (snapshot.hasData && snapshot.data != null) {
                              print(
                                  "Total Documents : ${snapshot.data!.docs.length}");
                              if (snapshot.connectionState ==
                                  ConnectionState.waiting) {
                                return const Center(child: Text("Loading...."));
                              }

                              if (snapshot.data!.docs.isNotEmpty) {
                                return ListView.builder(
                                  itemBuilder: (_______, int index) {
                                    String Name = snapshot.data!.docs
                                        .elementAt(index)
                                        .get("Company Name");
                                    String Number = snapshot.data!.docs
                                        .elementAt(index)
                                        .get("Number");
                                    String Img = snapshot.data!.docs
                                        .elementAt(index)
                                        .get("Image");
                                    String id = snapshot.data!.docs[index].id;
                                    return Padding(
                                      padding: const EdgeInsets.only(
                                          left: 8, right: 8, top: 8),
                                      child: Card(
                                        color:
                                            Color.fromARGB(255, 239, 240, 239),
                                        shape: RoundedRectangleBorder(
                                            borderRadius:
                                                BorderRadius.circular(10)),
                                        child: ListTile(
                                          leading: Container(
                                              clipBehavior:
                                                  Clip.antiAliasWithSaveLayer,
                                              height: 13.h,
                                              width: 13.w,
                                              decoration: const BoxDecoration(
                                                  shape: BoxShape.circle),
                                              child: imewidget(img: Img)),
                                          title: Text(
                                            Name,
                                            style: TextStyle(
                                                color: Colors.black,
                                                fontSize: 14.sp,
                                                fontWeight: FontWeight.w500),
                                          ),
                                          subtitle: Text(
                                            Number,
                                            style: const TextStyle(
                                                color: Color.fromARGB(
                                                    255, 120, 120, 120),
                                                fontWeight: FontWeight.w400),
                                          ),
                                          trailing: FittedBox(
                                            child: Row(
                                              children: <Widget>[
                                                IconButton(
                                                  icon: const Icon(
                                                    Icons.edit,
                                                    color: Color.fromARGB(
                                                        255, 65, 105, 119),
                                                  ),
                                                  onPressed: () {
                                                    if (interstitialAd !=
                                                        null) {
                                                      interstitialAd!.show();
                                                    }

                                                    Navigator.push(
                                                        context,
                                                        MaterialPageRoute(
                                                            builder: ((context) =>
                                                                UpdateCompany(
                                                                    id: id,
                                                                    img: Img,
                                                                    name: Name,
                                                                    number:
                                                                        Number))));
                                                  },
                                                ),
                                                IconButton(
                                                  icon: const Icon(
                                                    Icons.delete,
                                                    color: Color.fromARGB(
                                                        255, 65, 105, 119),
                                                  ),
                                                  onPressed: () {
                                                    delete_alert(
                                                      context: context,
                                                      ontap: () {
                                                        //1234
                                                        if (interstitialAd !=
                                                            null) {
                                                          interstitialAd!
                                                              .show();
                                                        }
                                                        delete(id);
                                                      },
                                                    );
                                                  },
                                                ),
                                              ],
                                            ),
                                          ),
                                        ),
                                      ),
                                    );
                                  },
                                  itemCount: snapshot.data!.docs.length,
                                );
                              }
                            }
                            return Center(
                              child: Text(
                                "Companies list not available",
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
                      height: 68.0.h,
                      width: 200.0.w,
                    ),
            ],
          ),
        ),
        floatingActionButton: FloatingActionButton(
          backgroundColor: Color.fromARGB(255, 65, 105, 119),
          onPressed: () {
            if (interstitialAd != null) {
              interstitialAd!.show();
            }
            Navigator.pushNamed(context, '/CompanyDetail');
          },
          child: const Icon(Icons.add),
        ),
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
      ),
    );
  }

  delete(String id) {
    FirebaseFirestore.instance
        .collection("Users")
        .doc(user?.uid)
        .collection("Company detail")
        .doc(id)
        .delete();
    Navigator.of(context).pop();
  }
}

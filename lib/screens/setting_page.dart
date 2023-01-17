// ignore_for_file: camel_case_types

import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:pricedb/model_pages/model.dart';
import 'package:pricedb/screens/drawerscreen.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:sizer/sizer.dart';

class Setting_page extends StatefulWidget {
  const Setting_page({Key? key}) : super(key: key);

  @override
  State<Setting_page> createState() => _Setting_pageState();
}

class _Setting_pageState extends State<Setting_page> {
  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () {
        Navigator.pushNamed(context,'/HomePage');
        return Future.value(true);
      },
      child: Scaffold(
        appBar: appbar(text: "Settings"),
        drawer: const drawerpage(),
        body: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.all(8.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                const SizedBox(
                  height: 10,
                ),
                const Center(
                    child: Text(
                  "Product Display Setting",
                  style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                )),
                const Padding(
                  padding: EdgeInsets.all(8.0),
                  child: Divider(
                    color: Colors.black54,
                    thickness: 2,
                  ),
                ),
                const SizedBox(
                  height: 10,
                ),
                Card(
                  elevation: 1.0,
                  child: ListTile(
                    title: const Text("Product name"),
                    leading: Container(
                      clipBehavior: Clip.antiAliasWithSaveLayer,
                      height: 13.h,
                      width: 13.w,
                      decoration:
                          BoxDecoration(borderRadius: BorderRadius.circular(7)),
                      child: isChecked
                          ? Image.asset(
                              "assets/p2.png",
                              fit: BoxFit.cover,
                            )
                          : ClipRRect(
                              child: ImageFiltered(
                                imageFilter:
                                    ImageFilter.blur(sigmaX: 3, sigmaY: 3),
                                child: Image.asset("assets/p2.png",
                                    fit: BoxFit.cover),
                              ),
                            ),
                    ),
                    subtitle: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: <Widget>[
                        Row(
                          children: <Widget>[
                            isChecked1
                                ? const Text(
                                    "Quantity ",
                                  )
                                : ClipRRect(
                                    child: ImageFiltered(
                                      imageFilter: ImageFilter.blur(
                                          sigmaX: 3, sigmaY: 3),
                                      child: const Text(
                                        "Quantity ",
                                      ),
                                    ),
                                  ),
                            SizedBox(
                              width: 3.w,
                            ),
                            isChecked2
                                ? const Text(
                                    "Price ",
                                  )
                                : ClipRRect(
                                    child: ImageFiltered(
                                      imageFilter: ImageFilter.blur(
                                          sigmaX: 3, sigmaY: 3),
                                      child: const Text(
                                        "Price ",
                                      ),
                                    ),
                                  ),
                          ],
                        ),
                        SizedBox(
                          height: 0.5.h,
                        ),
                        isChecked3
                            ? const Text(
                                "Final Price(Disc) ",
                              )
                            : ClipRRect(
                                child: ImageFiltered(
                                imageFilter:
                                    ImageFilter.blur(sigmaX: 3, sigmaY: 3),
                                child: const Text(
                                  "Final Price(Disc) ",
                                ),
                              )),
                      ],
                    ),
                  ),
                ),
                settingchecked(
                  text: 'Image',
                  selected: isChecked,
                  onChanged: (bool? value) async {
                    setState(() {
                      isChecked = value!;
                    });
                    final prefs = await SharedPreferences.getInstance();
                    await prefs.setBool('isCheckboxChecked', value!);
                  },
                ),
                settingchecked(
                  text: 'Quantity',
                  selected: isChecked1,
                  onChanged: (bool? value) async {
                    setState(() {
                      isChecked1 = value!;
                    });
                    final prefs = await SharedPreferences.getInstance();
                    await prefs.setBool('isCheckboxChecked1', value!);
                  },
                ),
                settingchecked(
                  text: 'Price',
                  selected: isChecked2,
                  onChanged: (bool? value) async {
                    setState(() {
                      isChecked2 = value!;
                    });
                    final prefs = await SharedPreferences.getInstance();
                    await prefs.setBool('isCheckboxChecked2', value!);
                  },
                ),
                settingchecked(
                  text: 'Final Price',
                  selected: isChecked3,
                  onChanged: (bool? value) async {
                    setState(() {
                      isChecked3 = value!;
                    });
                    final prefs = await SharedPreferences.getInstance();
                    await prefs.setBool('isCheckboxChecked3', value!);
                  },
                ),
                SizedBox(
                  height: 3.h,
                ),
                Divider(
                  height: 1.0.h,
                  thickness: 0.3.h,
                  color: const Color.fromARGB(255, 161, 160, 160),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

bool isChecked = true;
bool isChecked1 = true;
bool isChecked2 = true;
bool isChecked3 = true;

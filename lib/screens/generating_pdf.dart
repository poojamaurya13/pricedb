// ignore_for_file: camel_case_types, must_be_immutable, avoid_print, unnecessary_string_interpolations, non_constant_identifier_names, unnecessary_null_comparison, unused_local_variable, deprecated_member_use

import 'dart:async';
import 'dart:io';

import 'package:downloads_path_provider_28/downloads_path_provider_28.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
 import 'package:hive_flutter/adapters.dart';
import 'package:path_provider/path_provider.dart';
import 'package:pdf/pdf.dart';
import 'package:pdf/widgets.dart' as pw;
import 'package:pdf_merger/pdf_merger.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:pricedb/model_pages/model.dart';
import 'package:pricedb/screens/homepage.dart';
import 'package:pricedb/screens/pdf_list.dart';
import 'package:share_plus/share_plus.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:sizer/sizer.dart';

import 'package:syncfusion_flutter_pdfviewer/pdfviewer.dart';

class GeneratePDF extends StatefulWidget {
  const GeneratePDF({
    Key? key,
  }) : super(key: key);

  @override
  State<GeneratePDF> createState() => _GeneratePDFState();
}

class _GeneratePDFState extends State<GeneratePDF> {
  final _nameTextController = TextEditingController();
  List productinfoList_new = [];
  Box<String>? pdf;

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

  

  @override
  void initState() {
     
    _nameTextController.clear();
    pdf = Hive.box<String>("PDF");
    ischeckedpdf().then((value) {
      fetchDatabaseList_new().then((value) {
        length = productinfoList_new.length;
        if (ismax == false) {
          image();
        }
      });
    });

    super.initState();
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
                        pw.Expanded(
                            flex: 1,
                            child: pricelist_item(
                                text: index1 == min
                                    ? "Sir no."
                                    : index1.toString(),
                                textStyle:
                                    index1 == min ? textStyle1 : textStyle2)),
                        if (cname == true)
                          pw.Expanded(
                              flex: 2,
                              child: pricelist_item(
                                  text: index1 == min
                                      ? "Company Name"
                                      : productinfoList_new[index1 - 1]
                                          ["Company Name"],
                                  textStyle:
                                      index1 == min ? textStyle1 : textStyle2)),
                        if (cnumber == true)
                          pw.Expanded(
                              flex: 2,
                              child: pricelist_item(
                                  text: index1 == min
                                      ? "Number"
                                      : productinfoList_new[index1 - 1]
                                          ["Number"],
                                  textStyle:
                                      index1 == min ? textStyle1 : textStyle2)),
                        if (pname == true)
                          pw.Expanded(
                              flex: 3,
                              child: pricelist_item(
                                  text: index1 == min
                                      ? "Product Name"
                                      : productinfoList_new[index1 - 1]
                                          ["Product Name"],
                                  textStyle:
                                      index1 == min ? textStyle1 : textStyle2)),
                        if (qty == true)
                          pw.Expanded(
                              flex: 1,
                              child: pricelist_item(
                                  text: index1 == min
                                      ? "Qty"
                                      : productinfoList_new[index1 - 1]
                                          ["Quantity"],
                                  textStyle:
                                      index1 == min ? textStyle1 : textStyle2)),
                        if (price == true)
                          pw.Expanded(
                              flex: 1,
                              child: pricelist_item(
                                  text: index1 == min
                                      ? "Price"
                                      : productinfoList_new[index1 - 1]
                                          ["Price"],
                                  textStyle:
                                      index1 == min ? textStyle1 : textStyle2)),
                        if (fprice == true)
                          pw.Expanded(
                              flex: 1,
                              child: pricelist_item(
                                  text: index1 == min
                                      ? "Final\nPrice"
                                      : productinfoList_new[index1 - 1]
                                          ["Final_Price"],
                                  textStyle:
                                      index1 == min ? textStyle1 : textStyle2)),
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

  Future<void> ischeckedpdf() async {
    final prefs1 = await SharedPreferences.getInstance();
    cname = prefs1.getBool('cname') ?? true;
    cnumber = prefs1.getBool('cnumber') ?? true;
    pname = prefs1.getBool('pname') ?? true;
    qty = prefs1.getBool('qty') ?? true;
    fprice = prefs1.getBool('fprice') ?? true;
    price = prefs1.getBool('price') ?? true;
  }

  image() {
    max2 = max2 + 23;
    min2 = min2 + 23;

    if (max2 > length) {
      ismax = true;
      max2 = length;
    }
    create(min: min2, max: max2).then((value) async {
      Navigator.pushNamed(context, '/GeneratePDF')
          .then((value) => Navigator.pop(context));
    });
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
          text: "Download PDF",
          actions: <Widget>[
            Row(
              children: <Widget>[
                IconButton(
                  onPressed: () async {
                    String date = "${DateTime.now()}";
                    List dotremove = date.split("");
                    for (var i = 0; i < dotremove.length; i++) {
                      if (dotremove[i] == ":" ||dotremove[i] == "."||dotremove[i] == " " ) {
                         dotremove.removeAt(i);
                        dotremove.insert(i, "_");
                      }
                      
                    
                    }
                    date = dotremove.join("");
                    pdfname(
                      title: "PDF",
                      text: "Save",
                      controller: _nameTextController
                        ..text = "pricelist_data$date",
                      context: context,
                      onPressed: () async {
                        String dirPath = await getFilePath();
                        mergeMultiplePDF(dirPath)
                            .then((value) => Navigator.pushNamed(context, '/PdfList'))
                            .then((value) => Navigator.of(context).pop());

                      },
                    );
                  },
                  icon: const Icon(Icons.download),
                ),
                IconButton(
                  onPressed: () async {
                    pdfname(
                      title: "PDF",
                      text: "Share",
                      controller: _nameTextController
                        ..text = "pricelist_data${DateTime.now()}",
                      context: context,
                      onPressed: () async {
                        Directory documentDirectory =
                            await getApplicationDocumentsDirectory();
                        String documentPath = documentDirectory.path;
                        MergeMultiplePDFResponse response =
                            await PdfMerger.mergeMultiplePDF(
                                paths: pdflist,
                                outputDirPath:
                                    "$documentPath/${_nameTextController.text}.pdf");
                        Share.shareFiles([
                          "$documentPath/${_nameTextController.text}.pdf"
                        ]).then((value) => Navigator.of(context).pop());
                      },
                    );
                  },
                  icon: const Icon(Icons.share),
                ),
              ],
            ),
          ],
        ),
         
        body: ListView.builder(
          itemCount: pdflist.length,
          itemBuilder: (BuildContext context, int index) {
            return SizedBox(
              height: 80.h,
              width: 100.w,
              child: SfPdfViewer.file(
                File(pdflist[index]),
              ),
            );
          },
        ),
      ),
    );
  }

  Future<void> mergeMultiplePDF(outputDirPath) async {
    try {
      MergeMultiplePDFResponse response = await PdfMerger.mergeMultiplePDF(
          paths: pdflist, outputDirPath: outputDirPath);
      if (response.status == "success") {
        pdf = Hive.box<String>("PDF");
        var key = outputDirPath;
        pdf?.put(key, outputDirPath);

        filename = outputDirPath;
      }
      print(response.status);
    } on PlatformException {
      print('Failed to get platform version.');
    }
  }

  Future<String> getFilePath() async {
    var status = await Permission.storage.status;
    if (!status.isGranted) {
      await Permission.storage.request();
    }
    String path;
    Directory? documentDirectory =
        await DownloadsPathProvider.downloadsDirectory;
    String documentPath = documentDirectory!.path;
    path = "$documentPath/${_nameTextController.text}.pdf";
    print("xyz $path");
    return path;
  }
}

int min2 = 0;
int max2 = 23;
bool ismax = false;
int number = 0;

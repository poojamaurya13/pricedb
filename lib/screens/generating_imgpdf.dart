// ignore_for_file: camel_case_types, must_be_immutable, avoid_print, unnecessary_string_interpolations, non_constant_identifier_names, unnecessary_null_comparison, unused_local_variable, prefer_typing_uninitialized_variables, deprecated_member_use

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
import 'package:pricedb/screens/generating_pdf.dart';
import 'package:pricedb/screens/homepage.dart';
import 'package:pricedb/screens/pdf_list.dart';
import 'package:printing/printing.dart';
import 'package:share_plus/share_plus.dart';
import 'package:sizer/sizer.dart';
import 'package:syncfusion_flutter_pdfviewer/pdfviewer.dart';

class GenerateImgPDF extends StatefulWidget {
  const GenerateImgPDF({
    Key? key,
  }) : super(key: key);

  @override
  State<GenerateImgPDF> createState() => _GenerateImgPDFState();
}

class _GenerateImgPDFState extends State<GenerateImgPDF> {
  final _nameTextController = TextEditingController();
  Box<String>? imgpdf;

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

  @override
  void initState() {
    _nameTextController.clear();
    imgpdf = Hive.box<String>("ImagePDF");
    ischeckedpdf().then((value) {
      fetchDatabaseList_new().then((value) {
        length = productinfoList_new.length;
        if (ismax_img == false) {
          image();
        }
      });
    });

    super.initState();
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
              if (i > min && i <= max)
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

  image() {
    max_img2 = max_img2 + 11;
    min_img2 = min_img2 + 11;

    if (max_img2 > length) {
      ismax_img = true;
      max_img2 = length;
    }
    imagepdf(min: min_img2, max: max_img2).then((value) async {
      Navigator
          .pushNamed(context,'/GenerateImgPDF')
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
          text: "Download GridPDF",
          actions: <Widget>[
            Row(
              children: <Widget>[
                IconButton(
                  onPressed: () async {
                    String date = "${DateTime.now()}";
                    List dotremove = date.split("");
                    for (var i = 0; i < dotremove.length; i++) {
                      if (dotremove[i] == ":" ||
                          dotremove[i] == "." ||
                          dotremove[i] == " ") {
                        dotremove.removeAt(i);
                        dotremove.insert(i, "_");
                      }
                    }
                    date = dotremove.join("");
                    pdfname(
                      title: "GridPDF",
                      text: "Save",
                      controller: _nameTextController
                        ..text = "pricelist_data$date",
                      context: context,
                      onPressed: () async {
                        String dirPath = await getFilePath();
                        mergeMultiplePDF(dirPath)
                            .then((value) => Navigator.pushNamed(context, '/PdfList')
                                .then((value) => Navigator.of(context).pop()));
                      },
                    );
                  },
                  icon: const Icon(Icons.download),
                ),
                IconButton(
                  onPressed: () async {
                    pdfname(
                      title: "GridPDF",
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
        imgpdf = Hive.box<String>("ImagePDF");
        var key = outputDirPath;
        imgpdf?.put(key, outputDirPath);

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

pw.Row image_pdf_items({pw.Font? ttf, String? title, String? text}) {
  return pw.Row(
    children: <pw.Widget>[
      pw.Text(title ?? "",
          style: pw.TextStyle(
              fontSize: 16.0.sp, font: ttf, fontWeight: pw.FontWeight.bold)),
      pw.Text(text ?? "", style: pw.TextStyle(fontSize: 16.0.sp, font: ttf)),
    ],
  );
}

int min_img2 = 0;
int max_img2 = 3;
bool ismax_img = false;

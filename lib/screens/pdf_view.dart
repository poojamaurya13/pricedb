// ignore_for_file: deprecated_member_use, avoid_print

import 'dart:io';

import 'package:flutter/material.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';
import 'package:hive/hive.dart';
import 'package:pricedb/model_pages/ad_provider.dart';
import 'package:pricedb/model_pages/model.dart';
import 'package:pricedb/screens/pdf_list.dart';
import 'package:provider/provider.dart';
import 'package:share_plus/share_plus.dart';
import 'package:syncfusion_flutter_pdfviewer/pdfviewer.dart';

class PdfView extends StatefulWidget {
  const PdfView({Key? key}) : super(key: key);

  @override
  State<PdfView> createState() => _PdfViewState();
}

class _PdfViewState extends State<PdfView> {
  Box<String>? pdf;
  Box<String>? imgpdf;
  @override
  void initState() {
    pdf = Hive.box<String>("PDF");
    imgpdf = Hive.box<String>("ImagePDF");
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

  share() {
    Share.shareFiles([filename]);
  }

  deletewidget() {
    pdf?.delete(delete).then((value) async {
      try {
        if (await File(filename).exists()) {
          await File(filename).delete();
        }
      } catch (e) {
        print("error");
      }
      Navigator.pushNamed(context, '/PdfList');
    });
    imgpdf?.delete(delete).then((value) async {
      try {
        if (await File(filename).exists()) {
          await File(filename).delete();
        }
      } catch (e) {
        print("error");
      }
     Navigator.pushNamed(context, '/PdfList');
    });
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () {
       Navigator.pushNamed(context, '/PdfList');
        return Future.value(true);
      },
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
          text: "PDF",
          actions: <Widget>[
            Row(
              children: <Widget>[
                IconButton(
                    onPressed: () {
                      //1234
                      deletewidget();
                    },
                    icon: const Icon(
                      Icons.delete,
                    )),
                IconButton(
                  onPressed: () {
                    //1234
                    share();
                  },
                  icon: const Icon(
                    Icons.share,
                  ),
                ),
              ],
            )
          ],
        ),
        body: doesFileExists
            ? filename != ""
                ? SfPdfViewer.file(
                    File(filename),
                  )
                : const Center(
                    child: Text("File  not available."),
                  )
            : const Center(
                child: Text("File not available."),
              ),
      ),
    );
  }
}

bool doesFileExists = true;

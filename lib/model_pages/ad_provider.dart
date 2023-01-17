// ignore_for_file: camel_case_types, prefer_const_constructors, avoid_print, unused_element, non_constant_identifier_names, unnecessary_null_comparison

import 'dart:async';
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';
 import 'package:provider/provider.dart';

late BannerAd bannerAd;
InterstitialAd? interstitialAd;
String RouteName = "/";
Function? todispose;
List AdList = [];

class AdHelper {
//BannerAd_id
  String Android_BannerAd_id = "ca-app-pub-9436218497627588/9176495055";
  String IOS_BannerAd_id = "ca-app-pub-9436218497627588/9176495055";

//InterstitialAd_id
  String Android_InterstitialAd_id = "ca-app-pub-9436218497627588/1468089481";
  String IOS_InterstitialAd_id = "ca-app-pub-9436218497627588/1468089481";


  static String get bannerAdUnitId {
    if (Platform.isAndroid) {
      return AdHelper().Android_BannerAd_id;
    } else if (Platform.isIOS) {
      return AdHelper().IOS_BannerAd_id;
    } else {
      throw UnsupportedError('Unsupported platform');
    }
  }

  static String get interstitialAdUnitId {

    if (Platform.isAndroid) {
      print("object");

      return AdHelper().Android_InterstitialAd_id;
    } else if (Platform.isIOS) {
      return AdHelper().IOS_InterstitialAd_id;
    } else {
      throw UnsupportedError("Unsupported platform");
    }
  }

 
}

class Load_Ads {
  loadads(BuildContext context, List Ad_List) {
    print("load123");
    if (Ad_List.contains("b")) {
      loadbanner(context);
    }
    if (Ad_List.contains("i")) {
      loadInterstitialAd(context);
    }
  }

  disposeads(BuildContext context, List Ad_List) {
    print("object123");

    if (Ad_List.contains("b") && bannerAd != null) {
      bannerAd.dispose();
    }
    if (Ad_List.contains("i") && interstitialAd != null) {
      interstitialAd!.dispose();
    }
  }

  loadbanner(BuildContext context) {
    bannerAd = BannerAd(
      adUnitId: AdHelper.bannerAdUnitId,
      request: const AdRequest(),
      size: AdSize.banner,
      listener: BannerAdListener(
        onAdLoaded: (_) {
          Timer(Duration(seconds: 1), () {
            print("object;lk;bhj");
            context.read<Ad_Provider>().isBannerAdLoaded(true);
          });
        },
        onAdFailedToLoad: (ad, err) {
          print('Failed to load a banner ad: ${err.message}');
          ad.dispose();
        },
      ),
    );
    bannerAd.load();
  }

  void loadInterstitialAd(BuildContext context) {
    InterstitialAd.load(
      adUnitId: AdHelper.interstitialAdUnitId,
      request: AdRequest(),
      adLoadCallback: InterstitialAdLoadCallback(
        onAdLoaded: (ad) {
          ad.fullScreenContentCallback = FullScreenContentCallback(
            onAdShowedFullScreenContent: (ad) {},
            onAdDismissedFullScreenContent: (ad) {
              interstitialAd = null;
              todispose!();
            },
          );

          context.read<Ad_Provider>().isInterstitialLoaded(ad);
        },
        onAdFailedToLoad: (err) {
          print('Failed to load an interstitial ad: ${err.message}');
        },
      ),
    );
  }

}

// ChangeNotifier

class Ad_Provider extends ChangeNotifier {
  bool isBannerAdReady = false;
 

  isBannerAdLoaded(bool x) {
    isBannerAdReady = x;
    notifyListeners();
  }

  isInterstitialLoaded(InterstitialAd ad) {
    interstitialAd = ad;
    notifyListeners();
  }
  
}

 
  // ignore: prefer_function_declarations_over_variables
  Function after = (){};

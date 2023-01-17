// ignore_for_file: avoid_print

import 'dart:async';
import 'dart:io';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:path_provider/path_provider.dart';
import 'package:pricedb/company_pages/add_company_detail.dart';
import 'package:pricedb/company_pages/company_list.dart';
import 'package:pricedb/login_pages/forget_password_page.dart';
import 'package:pricedb/login_pages/login_page.dart';
import 'package:pricedb/login_pages/register_page.dart';
import 'package:pricedb/login_pages/verify_email_page.dart';
import 'package:pricedb/model_pages/ad_provider.dart';
import 'package:pricedb/model_pages/model.dart';
import 'package:pricedb/product_pages/add_product_detail.dart';
import 'package:pricedb/screens/generating_imgpdf.dart';
import 'package:pricedb/screens/generating_pdf.dart';
import 'package:pricedb/screens/homepage.dart';
import 'package:pricedb/screens/pdf_list.dart';
import 'package:pricedb/screens/pdf_view.dart';
import 'package:pricedb/screens/policy_privacy_page.dart';
import 'package:pricedb/screens/setting_page.dart';
import 'package:pricedb/wrapper.dart';
import 'package:provider/provider.dart';
import 'package:sizer/sizer.dart';

//9054862822
AppOpenAd? openAd;

Future<void> loadAd() async {
  await AppOpenAd.load(
      adUnitId: "ca-app-pub-9436218497627588/5157140133",
      request: const AdRequest(),
      adLoadCallback: AppOpenAdLoadCallback(onAdLoaded: (ad) {
        print('ad is loaded');
        openAd = ad;
        openAd!.show();
      }, onAdFailedToLoad: (error) {
        print('ad failed to load $error');
      }),
      orientation: AppOpenAd.orientationPortrait);
}

void showAd() {
  if (openAd == null) {
    print('trying to show before loading');
    loadAd();
    return;
  }
}

Future<void> main() async {
  SystemChrome.setSystemUIOverlayStyle(const SystemUiOverlayStyle(
    statusBarColor: Colors.transparent,
  ));
  WidgetsFlutterBinding.ensureInitialized();
  await MobileAds.instance.initialize();
  await loadAd();
  SystemChrome.setPreferredOrientations([DeviceOrientation.portraitUp])
      .then((_) async {
    await Firebase.initializeApp();
    Directory documentDirectory = await getApplicationDocumentsDirectory();
    Hive.init(documentDirectory.path);
    Hive.openBox<String>("PDF");
    Hive.openBox<String>("ImagePDF");
    runApp(const MyApp());
  });
}

class MyApp extends StatefulWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  Timer? _timer;

  @override
  void initState() {
    super.initState();
    _initializeTimer();
  }

  void _initializeTimer() {
    _timer = Timer(const Duration(minutes: 60), () => _handleInactivity());
  }

  User? user = FirebaseAuth.instance.currentUser;
  Future<void> _handleInactivity() async {
    _timer?.cancel();
    _timer = null;
    await FirebaseAuth.instance.signOut().then((value) => exit(0));
  }

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => LognpressedProvider()),
        ChangeNotifierProvider(create: (_) => Ad_Provider()),
      ],
      child: Sizer(
        builder: (context, orientation, deviceType) {
          return GestureDetector(
            onTap: () {
              _initializeTimer();
            },
            onPanDown: (__) => _initializeTimer(),
            onPanUpdate: (_) => _initializeTimer(),
            child: MaterialApp(
              debugShowCheckedModeBanner: false,
              theme: ThemeData(
                  primaryColor: const Color.fromARGB(255, 65, 105, 119),
                  appBarTheme: const AppBarTheme(
                    color: Color.fromARGB(255, 65, 105, 119),
                  )),
              initialRoute: "/Wrapper",
              routes: {
                '/Wrapper': (context) => Wrapper(),

                //company pages
                '/CompanyDetail': (context) => const CompanyDetail(),
                '/CompanyList': (context) => const CompanyList(),

                // login pages
                '/ForgetPassword': (context) => const ForgetPassword(),
                '/LoginPage': (context) => const LoginPage(),
                '/RegisterPage': (context) => const RegisterPage(),
                'VerifyEmail': (context) => const VerifyEmail(),

                //product page
                '/ProductDetail': (context) => const ProductDetail(),
                //screens
                '/HomePage': (context) => const HomePage(),
                '/GenerateImgPDF': (context) => const GenerateImgPDF(),
                '/GeneratePDF': (context) => const GeneratePDF(),
                '/PdfList': (context) => const PdfList(),
                '/PdfView': (context) => const PdfView(),
                '/Policy_privacy': (context) => const Policy_privacy(),
                '/Setting_page': (context) => const Setting_page()
              },
            ),
          );
        },
      ),
    );
  }
}

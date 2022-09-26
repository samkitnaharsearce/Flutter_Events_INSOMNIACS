import 'dart:async';
import 'dart:io';
import 'package:matrix/QRPage.dart';
import 'package:matrix/fetchDetails.dart';
import 'package:matrix/login.dart';
import 'package:matrix/scanner.dart';
import 'package:flutter/material.dart';
import 'package:flutter_inappwebview/flutter_inappwebview.dart';
// import 'package:url_launcher/url_launcher.dart';

Future main() async {
  WidgetsFlutterBinding.ensureInitialized();

  if (Platform.isAndroid) {
    await AndroidInAppWebViewController.setWebContentsDebuggingEnabled(true);
  }

  runApp(MaterialApp(
    routes: {
      "/QR" : (context) => QRPage(),
      // "/login" : (context) => Login(),
      "/fetchDetails" : (context) => FetchDetails(),
      "/scanner" : (context) => ScannerPage(),
    },
      home: new QRPage()
  ));
}
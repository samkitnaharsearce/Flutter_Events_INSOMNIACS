import 'dart:async';
import 'dart:io';
import 'package:matrix/QRPage.dart';
import 'package:matrix/fetchDetails.dart';
import 'package:matrix/scanner.dart';
import 'package:flutter/material.dart';
import 'package:flutter_inappwebview/flutter_inappwebview.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();

  // if (Platform.isAndroid) {
  //   await AndroidInAppWebViewController.setWebContentsDebuggingEnabled(true);
  // }

  setDebuggingEnabled(true);

  runApp(MaterialApp(
    routes: {
      "/QR" : (context) => QRPage(),
      "/fetchDetails" : (context) => FetchDetails(),
      "/scanner" : (context) => ScannerPage(),
    },
      home: new QRPage()
  ));
}

Future<void> setDebuggingEnabled(bool value) async {
  if (Platform.isAndroid) {
    await AndroidInAppWebViewController.setWebContentsDebuggingEnabled(value);
  }
}
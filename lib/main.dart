import 'package:flutter/material.dart';
import './modules/splashScreen/splashScreen.dart';
import './modules/ScanQR/screen/scanQRScreen.dart';
import './components/molecules/tempMolecules.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: const ScanQRScreen(),
    );
  }
}
import 'dart:convert';
import 'dart:io';
import 'package:matrix/allUtilities.dart';
import 'package:matrix/bloc/login/login_bloc.dart';
import 'package:matrix/login.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:qr_code_scanner/qr_code_scanner.dart';

class ScannerPage extends StatefulWidget {
  @override
  State<ScannerPage> createState() => _ScannerPageState();
}

class _ScannerPageState extends State<ScannerPage> {
  final qrKey = GlobalKey(debugLabel: 'QR');
  QRViewController? qrController;
  Barcode? qrData;

  @override
  void dispose() {
    qrController?.dispose();
    super.dispose();
  }

  @override
  void reassemble() async {
    super.reassemble();
    if (Platform.isAndroid) {
      await qrController!.pauseCamera();
    }
  }

  void onQRViewCreated(controller) {
    setState(() {
      qrController = controller;
    });

    qrController?.scannedDataStream.listen((data) async{
      setState(() {
        qrData = data;
      });

      dynamic decodeData = json.decode(data.code.toString());
      String receiverEmail = decodeData["email"];
      String receiverLinkedInurl = decodeData["linked_url"];
      qrController!.pauseCamera();

      Future.delayed(Duration(seconds: 0),(){
        Navigator.of(context).pushReplacement(MaterialPageRoute(builder: (context){
          return Login(sourceLink: receiverLinkedInurl);
        }));
      });

      var senderEmail = await storage.read(key:"login_email");
      var senderLinkedInUrl = await storage.read(key: "login_urn");
      await SendEmail(senderEmail, senderLinkedInUrl, receiverEmail,receiverLinkedInurl);
    });
  }

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => LoginBloc(),
      child: QRView(
        key: qrKey,
        onQRViewCreated: onQRViewCreated,
        overlay: QrScannerOverlayShape(
            borderRadius: 10,
            cutOutSize: MediaQuery
                .of(context)
                .size
                .width * 0.8,
            borderColor: Colors.deepPurple,
        ),
      ),
    );
  }
}

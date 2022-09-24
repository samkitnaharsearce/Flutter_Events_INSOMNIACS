import 'dart:convert';
import "package:flutter/material.dart";
import 'package:qr_flutter/qr_flutter.dart';
import '../../constants/tempConstants.dart';
import '../../modules/scanQRScreen/screen/scanQRScreen.dart';

class TopBar extends StatelessWidget{
  const TopBar({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: MediaQuery.of(context).size.width,
      height: MediaQuery.of(context).size.height * 0.1,
      color: const Color(0xFFE6E6E6),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: const [
          Padding(
            padding: EdgeInsets.all(10.0),
            child: Icon(Icons.person, color: Color(0xFF7D7D7D), size: 30),
          ),
          Expanded(flex: 4,
            child: Center(
              child: Text(
                "Smart Visiting Card",
                style: TextStyle(
                  color: Colors.black,
                  fontSize: 25,
                  fontWeight: FontWeight.w600
                ),
              ),
            ),
          ),
          Padding(
            padding: EdgeInsets.all(10.0),
            child: Icon(Icons.menu, color: Color(0xFF7D7D7D), size: 30,),
          ),
        ],
      ),
    );
  }
}

class BottomBar extends StatelessWidget{

  bool qrGenerated = false;

  BottomBar({required this.qrGenerated, super.key});

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: MediaQuery.of(context).size.width,
      height: MediaQuery.of(context).size.height * 0.15,
      child: Stack(
        clipBehavior: Clip.hardEdge,
        alignment: const FractionalOffset(.5, 1.0),
        children: [
          Container(
            height: MediaQuery.of(context).size.height * 0.15 * (1/2),
            color: const Color(0xFFE6E6E6),
          ),
          Container(
              alignment: Alignment.center,
              width: 295,
              child: OutlinedButton(
                style: OutlinedButton.styleFrom(
                  elevation: 5,
                  backgroundColor: const Color(0xFF7D7D7D),
                  shape: const RoundedRectangleBorder(
                    borderRadius: BorderRadius.all(Radius.circular(20)),
                  ),
                ),
                onPressed: (QRJsonDataMap.qrGenerated == false) ? null : () {
                  debugPrint("Pressed Camera");
                  Navigator.of(context).push(MaterialPageRoute(builder: (builder) {
                    return const ScanQRScreen();
                  }));
                },
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: const [
                    Padding(
                      padding: EdgeInsets.all(8.0),
                      child: Icon(
                        Icons.camera_alt,
                        color: Color(0xFFE6E6E6),
                        size: 30,
                      ),
                    ),
                    Text(
                      "Expand your network",
                      style: TextStyle(
                        fontSize: 18,
                        color: Colors.white,
                      ),
                    ),
                  ],
                ),
              )
          ),
        ],
      ),
    );
  }
}

class QRArea extends StatelessWidget{

  bool qrGenerated = false;
  final Function? onQRGeneratePressed;

  QRArea({required this.qrGenerated, required this.onQRGeneratePressed, super.key});

  @override
  Widget build(BuildContext context) {
    debugPrint(qrGenerated.toString());
    if(QRJsonDataMap.qrGenerated){
      QRJsonDataMap.dict = {'url':'www.google.com','email':'mail.google@gmail.com'};
    }
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        const Text(
          "Scan the QR to connect",
          style: TextStyle(
            fontSize: 25,
            fontWeight: FontWeight.w600,
            fontFamily: 'lato',
          ),
        ),
        SizedBox(height: MediaQuery.of(context).size.height * 0.03,),
        SizedBox(
          height: MediaQuery.of(context).size.width * 0.85,
          width: MediaQuery.of(context).size.width * 0.85,
          child: Stack(
            children: [
              Center(
                child: InkWell(
                  child: QrImage(
                    data: jsonEncode(QRJsonDataMap.dict),
                    size: MediaQuery.of(context).size.width * 0.75,
                    gapless: false,
                    errorStateBuilder: (cxt, err) {
                      return const Center(
                        child: Text(
                          "Uh oh! Something went wrong...",
                          textAlign: TextAlign.center,
                        ),
                      );
                    },
                    version: QrVersions.auto,
                    embeddedImage: const AssetImage('assets/images/olympicPattern.png'),
                    embeddedImageStyle: QrEmbeddedImageStyle(
                      size: const Size(70, 70),
                    ),
                  ),
                  onTap: () {debugPrint("Pressed Download QR");},
                ),
              ),
              (QRJsonDataMap.qrGenerated == false) ? Container(
                color: const Color(0x80000000),
                child: Center(
                  child: TextButton(
                    onPressed: () {
                      debugPrint("Pressed QR Generated");
                      onQRGeneratePressed!();
                    },
                    style: TextButton.styleFrom(
                      backgroundColor: Colors.blueAccent,
                      foregroundColor: Colors.white,
                      elevation: 10,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(25),
                      )
                    ),
                    child: const Text("Generate QR",
                      style: TextStyle(
                        fontSize: 25,
                      ),
                    ),
                  ),
                ),
              ) : Container(),
            ],
          ),
        ),
      ],
    );
  }
}

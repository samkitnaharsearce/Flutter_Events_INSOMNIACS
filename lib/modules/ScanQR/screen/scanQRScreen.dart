import 'dart:io';

import 'package:flutter/material.dart';
import 'package:qr_code_scanner/qr_code_scanner.dart';

class ScanQRScreen extends StatefulWidget {
  const ScanQRScreen({Key? key}) : super(key: key);

  @override
  State<ScanQRScreen> createState() => _QRViewState();
}

class _QRViewState extends State<ScanQRScreen> {
  final GlobalKey qrKey = GlobalKey(debugLabel: 'QR');

  Barcode? result;
  dynamic flashState = false;
  QRViewController? controller;

  // In order to get hot reload to work we need to pause the camera if the platform
  // is android, or resume the camera if the platform is iOS.
  @override
  void reassemble() {
    super.reassemble();
    if (Platform.isAndroid) {
      controller!.pauseCamera();
    } else if (Platform.isIOS) {
      controller!.resumeCamera();
    }
  }

  @override
  Widget build(BuildContext context){
    return MaterialApp(
      home: Scaffold(
        body: Stack(
          children: [
            Column(
              children: <Widget>[
                Expanded(
                  flex: 5,
                  child: Stack(
                    children: [
                      QRView(
                        key: qrKey,
                        onQRViewCreated: _onQRViewCreated,
                      ),
                    ],
                  ),
                ),
              ],
            ),
            Container(
              child: null,
              decoration: const BoxDecoration(
                image: DecorationImage(
                  image: AssetImage("assets/images/cutoutOverlaySmall.png"),
                  fit: BoxFit.cover,
                ),
              ),
            ),
            Column(
              children: <Widget>[
                SizedBox(
                  height: 100,
                  child: InkWell(
                    onTap: _toggleFlashLight,
                    child: (flashState == false)
                            ? const Icon(Icons.flash_off_sharp, color: Color(0xFFE6E6E6),)
                            : const Icon(Icons.flash_on_sharp, color: Color(0xFFE6E6E6),),
                  ),
                ),
                Expanded(flex: 5, child: Container(child:  null,),),
                const BottomBar(),
              ],
            ),
          ],
        ),
      ),
    );
  }

  void _onQRViewCreated(QRViewController controller) {
    this.controller = controller;
    controller.scannedDataStream.listen((scanData) {
      setState(() {
        result = scanData;
        this.controller!.pauseCamera();
        _displayDialog(context, result!.code);
      });
    });
  }

  Future<void> _displayDialog(BuildContext context, String? code) async {
    return showDialog(
      context: context,
      builder: (context) {
        return QRDialogueBox(code: code, controller: controller);
      },
    );
  }

  Future<void> _toggleFlashLight() async {
    final controller = this.controller;
    if(controller != null){
      controller.toggleFlash();
      bool? flashStatus = await controller.getFlashStatus();
      setState(() => {
        flashState = flashStatus
      });
      // debugPrint(flashState.toString());
    }else{
      flashState = false;
    }
  }

  @override
  void dispose() {
    controller?.dispose();
    super.dispose();
  }
}

class QRDialogueBox extends StatelessWidget{
  final String? code;
  final QRViewController? controller;
  const QRDialogueBox({this.code, required this.controller, super.key});

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: SizedBox(
        height: MediaQuery.of(context).size.height * 0.051,
        child: Container(
          color: const Color(0xFFE6E6E6),
          child: const Center(
            child: Text(
              "Connect With Me?",
              style: TextStyle(
                fontSize: 20,
              ),
            ),
          ),
        ),
      ),
      content: SizedBox(
        height: MediaQuery.of(context).size.height,
        width: MediaQuery.of(context).size.width,
        child: Center(
          child: Text("The code is: $code"),
        ),
      ),
      actions: <Widget>[
        TextButton(
          style: TextButton.styleFrom(
            backgroundColor: Colors.blueAccent,
            foregroundColor: Colors.white,
          ),
          child: const Text('OK'),
          onPressed: () {
            // setState(() {
            controller!.resumeCamera();
            Navigator.pop(context);
          },
        ),
      ],
    );
  }

}

class BottomBar extends StatelessWidget{
  const BottomBar({super.key});

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
              // width: MediaQuery.of(context).size.width * 0.7
              width: 295,
              child: OutlinedButton(
                // style: const ButtonStyle(
                //   backgroundColor: MaterialStatePropertyAll(Color(0xFF7D7D7D)),
                //   elevation: MaterialStatePropertyAll(5),
                // ),
                style: OutlinedButton.styleFrom(
                  elevation: 5,
                  backgroundColor: const Color(0xFF7D7D7D),
                  shape: const RoundedRectangleBorder(
                    borderRadius: BorderRadius.all(Radius.circular(20)),
                  ),
                ),
                onPressed: () { debugPrint("Pressed Camera"); },
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: const [
                    Padding(
                      padding: EdgeInsets.all(8.0),
                      child: Icon(
                        Icons.qr_code_outlined,
                        color: Color(0xFFE6E6E6),
                        size: 30,
                      ),
                    ),
                    Text(
                      "Back to the QR",
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

import 'package:flutter/material.dart';
import 'package:svc_insomniacs/constants/tempConstants.dart';
import '../../../components/molecules/tempMolecules.dart';

class QRHomeScreen extends StatefulWidget{
  const QRHomeScreen({super.key});

  @override
  State<QRHomeScreen> createState() => _QRHomeScreenState();
}

class _QRHomeScreenState extends State<QRHomeScreen> {

  // bool qrGenerated = false;

  void onGenerateQRPressed(){
    setState(() {
      QRJsonDataMap.qrGenerated = true;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        decoration: const BoxDecoration(
          image: DecorationImage(
            image: AssetImage("assets/images/bgImage.jpg"),
            fit: BoxFit.fill,
          ),
        ),
        child: Column(
          children: [
            const TopBar(),
            Expanded(
              flex: 3,
              child: QRArea(
                onQRGeneratePressed: onGenerateQRPressed,
                qrGenerated: QRJsonDataMap.qrGenerated,
              ),
            ),
            BottomBar(qrGenerated: QRJsonDataMap.qrGenerated),
          ],
        ),
      ),
    );
  }
}

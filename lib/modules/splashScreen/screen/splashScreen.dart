import 'dart:async';

import "package:flutter/material.dart";
import "../../homeQRScreen/screen/homeQRScreen.dart";

class SplashScreen extends StatefulWidget{
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {

  @override
  void initState() {
    super.initState();
    Timer(
      const Duration(seconds: 2),
      () => Navigator.pushReplacement(
        context,
        MaterialPageRoute(
          builder: (context) => (const QRHomeScreen()),
        )
      )
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        // For Background Image.
        decoration: const BoxDecoration(
          image: DecorationImage(
            image: AssetImage("assets/images/bgImage.png"),
            fit: BoxFit.cover,
          ),
        ),

        // For logo and tagline.
        child: Column(
          children: [
            Expanded(
              flex:3,
              child: Center(
                child: Image.asset("assets/images/LOGO.png"),
              ),
            ),
            Padding(
              padding: EdgeInsets.only(bottom: MediaQuery.of(context).size.height * 0.05),
              child: Image.asset("assets/images/teamName.png"),
            ),
          ],
        ),
      ),
    );
  }
}
import "package:flutter/material.dart";

class SplashScreen extends StatelessWidget{
  const SplashScreen({super.key});

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
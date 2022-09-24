import 'dart:convert';
import "package:flutter/material.dart";
import 'package:qr_flutter/qr_flutter.dart';

class QRHomePage extends StatelessWidget{
  const QRHomePage({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: const BoxDecoration(
        image: DecorationImage(
          image: AssetImage("assets/images/bgImage.png"),
          fit: BoxFit.fill,
        ),
      ),
      child: Column(
        children: [
          const TopBar(),
          Expanded(
            flex: 3,
            child: Container(
              // decoration: BoxDecoration(
              //   border: Border.all(
              //     color: Colors.red,
              //   )
              // ),
              child: const QRArea(),
            ),
          ),
          const BottomBar(),
        ],
      ),
    );
  }
}

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
  const QRArea({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      child: Column(
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
          QrImage(
            data: jsonEncode({'title':'This is a random data', 'message':'there is nothing to have in this message', 'url':'www.google.com'}),
            // data: jsonEncode({'url':'https://www.google.com'}),
            size: 300,
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
        ],
      ),
    );
  }
}

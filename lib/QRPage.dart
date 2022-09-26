import 'dart:typed_data';
import 'package:matrix/allUtilities.dart';
import 'package:matrix/bloc/login/login_bloc.dart';
import 'package:matrix/login.dart';
import 'package:matrix/scanner.dart';
import 'package:blur/blur.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:qr_flutter/qr_flutter.dart';
import 'package:screenshot/screenshot.dart';

class QRPage extends StatelessWidget {
  ScreenshotController screenshotController = ScreenshotController();
  late Uint8List _imageFile;

  void cameraAccess() async {
    while (Permission.camera.status != true) {
      await Permission.camera.request();
    }
  }

  @override
  Widget build(BuildContext context) {
    cameraAccess();
    return Scaffold(
      body: BlocProvider(
        create: (context) => LoginBloc()..add(IsLoggedInEvent()),
        child: Container(
          decoration: const BoxDecoration(
              gradient: LinearGradient(
                  begin: Alignment.topCenter,
                  end: Alignment.bottomCenter,
                  colors: [
                Color.fromRGBO(0, 0, 31, 10),
                Color.fromRGBO(65, 1, 590, 10)
              ])),
          child: Stack(
            children: [
              Center(
                child: BlocBuilder<LoginBloc, LoginState>(
                  builder: (context, state) {
                    if (state is LoggedInState) {
                      return Card(
                        elevation: 20,
                        shadowColor: Colors.white,
                        child: Screenshot(
                          controller: screenshotController,
                          child: QrImage(
                            data: state.qrData,
                            version: QrVersions.auto,
                            size: MediaQuery.of(context).size.width * 0.7,
                            gapless: true,
                            embeddedImageStyle: QrEmbeddedImageStyle(
                              size: const Size(80, 80),
                            ),
                          ),
                        ),
                      );
                    }
                    return Blur(
                      blur: 5,
                      blurColor: Colors.black26,
                      child: Card(
                        elevation: 20,
                        shadowColor: Colors.white,
                        child: QrImage(
                          data: 'This QR code has an embedded image as well',
                          version: QrVersions.auto,
                          size: MediaQuery.of(context).size.width * 0.7,
                          gapless: true,
                          embeddedImageStyle: QrEmbeddedImageStyle(
                            size: const Size(80, 80),
                          ),
                        ),
                      ),
                    );
                  },
                ),
              ),
              BlocBuilder<LoginBloc, LoginState>(
                builder: (context, state) {
                  if (state is NewLogInState) {
                    return Center(
                        child: ElevatedButton(
                      style: ButtonStyle(
                        backgroundColor: MaterialStateProperty.all(
                            Color.fromRGBO(65, 1, 590, 10)),
                      ),
                      onPressed: () {
                        Navigator.pushAndRemoveUntil(context,
                            MaterialPageRoute(builder: (context) {
                          return Login(
                              sourceLink: "https://linkedin.com/login");
                        }),
                            (Route<dynamic> route) =>
                                false); //Todo: use pushNamed.
                      },
                      child: const Text("Login to Continue",
                          style: TextStyle(
                              fontWeight: FontWeight.w300, fontSize: 15)),
                    ));
                  }
                  // else if (state is LoggedInState) {
                  //   return Center(
                  //     child: Container(
                  //       decoration: const BoxDecoration(
                  //           borderRadius: BorderRadius.all(Radius.circular(80)),
                  //           color: Colors.white),
                  //       child: const Icon(
                  //         Icons.add_circle,
                  //         color: Colors.purple,
                  //         size: 70,
                  //       ),
                  //     ),
                  //   );
                  // }
                  else {
                    return const Center(
                      child: const Text(""),
                    );
                  }
                },
              ),
              Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    SizedBox(
                      height: MediaQuery.of(context).size.width * 1.2,
                    ),
                    BlocBuilder<LoginBloc, LoginState>(
                      builder: (context, state) {
                        if (state is LoggedInState) {
                          return Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              ElevatedButton(
                                style: ButtonStyle(
                                  backgroundColor: MaterialStateProperty.all(
                                      Color.fromRGBO(0, 0, 31, 10)),
                                ),
                                onPressed: () {
                                  Navigator.push(context,
                                      MaterialPageRoute(builder: (context) {
                                    return ScannerPage();
                                  })); //Todo: use pushNamed.
                                },
                                child: const Text("Scan to Expand",
                                    style: TextStyle(
                                        fontWeight: FontWeight.w300,
                                        fontSize: 18)),
                              ),
                              Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Container(
                                    decoration: const BoxDecoration(
                                        borderRadius: BorderRadius.all(
                                            Radius.circular(50)),
                                        color: Color.fromRGBO(0, 0, 31, 10)),
                                    child: IconButton(
                                        iconSize: 30,
                                        color: Colors.white,
                                        onPressed: () {
                                          ShareQR();
                                        },
                                        icon: Icon(Icons.share)),
                                  ),
                                  SizedBox(
                                    width:
                                        MediaQuery.of(context).size.width * 0.1,
                                  ),
                                  Container(
                                    decoration: const BoxDecoration(
                                        borderRadius: BorderRadius.all(
                                            Radius.circular(50)),
                                        color: Color.fromRGBO(0, 0, 31, 10)),
                                    child: IconButton(
                                        iconSize: 30,
                                        color: Colors.white,
                                        onPressed: () async{

                                          var imgData = await screenshotController.capture();
                                          SaveQR(imgData);




                                        },
                                        icon: Icon(Icons.save)),
                                  )
                                ],
                              ),
                            ],
                          );
                        } else {
                          return SizedBox(
                            width: 0,
                            height: 0,
                          );
                        }
                      },
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

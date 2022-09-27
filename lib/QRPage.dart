import 'dart:convert';
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

@immutable
class QRPage extends StatelessWidget {
  late Uint8List _imageFile;

  QRPage({Key? key}) : super(key: key);

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
                        child:QrImage(
                          data: state.qrData,
                          version: QrVersions.auto,
                          size: MediaQuery.of(context).size.width * 0.7,
                          gapless: true,
                          embeddedImageStyle: QrEmbeddedImageStyle(
                            size: const Size(80, 80),
                          ),
                        ),
                      );
                    } else if (state is ShowAppLinkQrState) {
                      return Card(
                        elevation: 20,
                        shadowColor: Colors.white,
                        child: QrImage(
                          data: state.appLink,
                          version: QrVersions.auto,
                          size: MediaQuery.of(context).size.width * 0.7,
                          gapless: true,
                          embeddedImageStyle: QrEmbeddedImageStyle(
                            size: const Size(80, 80),
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
                            const Color.fromRGBO(65, 1, 590, 10)),
                      ),
                      onPressed: () {
                        Navigator.pushAndRemoveUntil(context,
                            MaterialPageRoute(builder: (context) {
                          return const Login(
                              sourceLink: "https://linkedin.com/login");
                        }), (Route<dynamic> route) => false);
                      },
                      child: const Text("Login to Continue",
                          style: TextStyle(
                              fontWeight: FontWeight.w300, fontSize: 15)),
                    ));
                  } else {
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
                        if (state is LoggedInState ||
                            state is ShowAppLinkQrState) {
                          return Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              ElevatedButton(
                                style: ButtonStyle(
                                  backgroundColor: MaterialStateProperty.all(
                                      const Color.fromRGBO(0, 0, 31, 10)),
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
                              BlocBuilder<LoginBloc, LoginState>(
                                builder: (context, state) {
                                  if (state is ShowAppLinkQrState){
                                    return ElevatedButton(
                                      style: ButtonStyle(
                                        backgroundColor:
                                        MaterialStateProperty.all(
                                            const Color.fromRGBO(
                                                0, 0, 31, 10)),
                                      ),
                                      onPressed: () async {
                                        if (state is ShowAppLinkQrState) {
                                          String? loginUrn = await storage.read(
                                              key: "login_urn");
                                          String? loginEmail = await storage.read(
                                              key: "login_urn");
                                          BlocProvider.of<LoginBloc>(context)
                                              .emit(LoggedInState(
                                              qrData: json.encode({
                                                "email":loginEmail,
                                                "linked_url":loginUrn
                                              })));
                                        } else {
                                          BlocProvider.of<LoginBloc>(context).add(
                                              const ShowAppLinkQrEvent(
                                                  appLink:
                                                  "https://storage.googleapis.com/qrscanner/app-debug.apk"));
                                        }
                                      },
                                      child: const Text("Show QR",
                                          style: TextStyle(
                                              fontWeight: FontWeight.w300,
                                              fontSize: 18)),
                                    );
                                  }
                                  else if (state is LoggedInState){
                                    return ElevatedButton(
                                      style: ButtonStyle(
                                        backgroundColor:
                                        MaterialStateProperty.all(
                                            const Color.fromRGBO(
                                                0, 0, 31, 10)),
                                      ),
                                      onPressed: () async {
                                        if (state is ShowAppLinkQrState) {
                                          String? temp = await storage.read(
                                              key: "login_urn");
                                          BlocProvider.of<LoginBloc>(context)
                                              .emit(LoggedInState(
                                              qrData: temp.toString()));
                                        } else {
                                          BlocProvider.of<LoginBloc>(context).add(
                                              const ShowAppLinkQrEvent(
                                                  appLink:
                                                  "https://storage.googleapis.com/qrscanner/app-debug.apk"));
                                        }
                                      },
                                      child: const Text("Share App",
                                          style: TextStyle(
                                              fontWeight: FontWeight.w300,
                                              fontSize: 18)),
                                    );
                                  }
                                  else{
                                    return const SizedBox(width: 0,height: 0,);
                                  }
                                },
                              ),
                            ],
                          );
                        } else {
                          return const SizedBox(
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

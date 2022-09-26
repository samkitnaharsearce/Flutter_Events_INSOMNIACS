import 'dart:async';
import 'dart:io';
import 'package:matrix/allUtilities.dart';
import 'package:flutter/material.dart';
import 'package:flutter_inappwebview/flutter_inappwebview.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
// import 'package:url_launcher/url_launcher.dart';

class FetchDetails extends StatefulWidget {
  const FetchDetails({Key? key}) : super(key: key);

  @override
  _FetchDetailsState createState() => _FetchDetailsState();
}

class _FetchDetailsState extends State<FetchDetails> {
  HeadlessInAppWebView? headlessWebView;
  String url1 = "";
  String url2 = "";
  double progress = 0;
  InAppWebViewController? webViewController;
  InAppWebViewGroupOptions options = InAppWebViewGroupOptions(
      crossPlatform: InAppWebViewOptions(
        // clearCache: true,
        javaScriptCanOpenWindowsAutomatically: true,
        // userAgent: "Mozilla/5.0 (Macintosh; Intel Mac OS X 10_15_7) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/105.0.0.0 Safari/537.36",
        userAgent: "random",
        useShouldOverrideUrlLoading: true,
        mediaPlaybackRequiresUserGesture: false,
      ),
      android: AndroidInAppWebViewOptions(
        supportMultipleWindows: true,
        useHybridComposition: true,
      ),
      ios: IOSInAppWebViewOptions(
        allowsInlineMediaPlayback: true,
      ));
  bool finishingValue = false;

  late PullToRefreshController pullToRefreshController;
  final urlController = TextEditingController();

  @override
  void initState() {
    super.initState();
    pullToRefreshController = PullToRefreshController(
      options: PullToRefreshOptions(
        color: Colors.blue,
      ),
      onRefresh: () async {
        if (Platform.isAndroid) {
          webViewController?.reload();
        } else if (Platform.isIOS) {
          webViewController?.loadUrl(
              urlRequest: URLRequest(url: await webViewController?.getUrl()));
        }
      },
    );

    headlessWebView = HeadlessInAppWebView(
      initialUrlRequest: URLRequest(
          url: Uri.parse(
              "https://www.linkedin.com/psettings/email?li_theme=dark&openInMobileMode=false")),
      initialOptions: options,
      pullToRefreshController: pullToRefreshController,
      onWebViewCreated: (controller) {
        webViewController = controller;
      },
      onCreateWindow: (controller, createWindowAction) async {
        print("onCreateWindow");

        showDialog(
          context: context,
          builder: (context) {
            return Align(
              alignment: Alignment.bottomCenter,
              child: AlertDialog(
                content: SizedBox(
                  width: MediaQuery.of(context).size.width,
                  height: MediaQuery.of(context).size.height * 0.5,
                  child: InAppWebView(
                    // Setting the windowId property is important here!
                    windowId: createWindowAction.windowId,
                    initialOptions: InAppWebViewGroupOptions(
                      crossPlatform: InAppWebViewOptions(
                        javaScriptCanOpenWindowsAutomatically: true,
                        javaScriptEnabled: true,
                        userAgent: "random",
                      ),
                    ),
                    onWebViewCreated: (InAppWebViewController controller) {},
                    onLoadStart: (InAppWebViewController controller, url) {
                      print("onLoadStart popup $url");
                    },
                    onLoadStop: (InAppWebViewController controller, url) {
                      print("onLoadStop popup $url");
                    },
                  ),
                ),
              ),
            );
          },
        );
        headlessWebView?.dispose();
        headlessWebView?.run();
        return true;
      },
      onLoadStart: (controller, url) {
        setState(() {
          url1 = url.toString();
          urlController.text = url1;
        });
      },
      androidOnPermissionRequest: (controller, origin, resources) async {
        return PermissionRequestResponse(
            resources: resources,
            action: PermissionRequestResponseAction.GRANT);
      },
      shouldOverrideUrlLoading: (controller, navigationAction) async {
        var uri = navigationAction.request.url!;

        if (!["http", "https", "file", "chrome", "data", "javascript", "about"]
            .contains(uri.scheme)) {
          // if (await canLaunchUrl(uri)) {
          //   // Launch the App
          //   await launchUrl(
          //     uri,
          //   );
          //   // and cancel the request
          //   return NavigationActionPolicy.CANCEL;
          // }
        }

        return NavigationActionPolicy.ALLOW;
      },
      onLoadStop: (controller, url) async {
        pullToRefreshController.endRefreshing();
        setState(() {
          url1 = url.toString();
          urlController.text = url1;
          // webViewController!.loadUrl(urlRequest: URLRequest(url: Uri.parse("https://www.linkedin.com/mypreferences/d/categories/sign-in-and-security")));
        });
      },
      onLoadError: (controller, url, code, message) {
        pullToRefreshController.endRefreshing();
      },
      onProgressChanged: (controller, progress) async {
        if (progress == 100) {
          pullToRefreshController.endRefreshing();
        }

        setState(() {
          this.progress = progress / 100;
          urlController.text = url1;
        });

        // if (urlController.text  == "https://www.linkedin.com/feed/") {
        //   webViewController!.loadUrl(urlRequest: URLRequest(url: Uri.parse("https://www.linkedin.com/psettings/email?li_theme=dark&openInMobileMode=true")));
        //   Navigator.push(context,MaterialPageRoute(builder: (context){
        //     return hiddenLogin();
        //   }));
        // }

        if (urlController.text ==
                "https://www.linkedin.com/psettings/email?li_theme=dark&openInMobileMode=false" &&
            progress == 100) {
          dynamic htmlResponse = "";

          Future.delayed(const Duration(microseconds: 1), () async {
            htmlResponse = await webViewController!.getHtml();
            RegExp regExp = RegExp(
              r'[^\s@<>]+@[^\s@<>]+\.[^\s@<>]+',
              multiLine: true,
            );
            List matches = regExp.allMatches(htmlResponse.toString()).toList();
            print(matches.length);
            for (var i = 0; i < matches.length; i++) {
              print(matches[i].group(0));
              storage.write(
                  key: "login_email", value: "${matches[i].group(0)}");
              setState(() {
                url1 = "$i  ${matches[i].group(0)}";
              });
            }
          });

          webViewController!.loadUrl(
              urlRequest: URLRequest(
                  url: Uri.parse(
                      "https://www.linkedin.com/public-profile/settings?trk=d_flagship3_profile_self_view_public_profile")));
          Future.delayed(const Duration(seconds: 3), () async {
            var urn = await webViewController!.evaluateJavascript(
                source:
                    '''document.querySelectorAll("span[data-js-module-id=vanity-name__display-name]")[0].innerHTML;''');
            print(urn);
            storage.write(
                key: "login_urn", value: "https://www.linkedin.com/in/$urn");

            if (storage.read(key: "login_urn") != null &&
                storage.read(key: "login_email") != null) {
              storage.write(key: "login_status",value: "true");
              Navigator.pushNamedAndRemoveUntil(context, "/", (route) => false);
            }
            setState(() {
              url2 = urn;
            });
          });
        }
      },
      onUpdateVisitedHistory: (controller, url, androidIsReload) {
        setState(() {
          url1 = url.toString();
          urlController.text = url1;
        });
      },
      onConsoleMessage: (controller, consoleMessage) {
        debugPrint(consoleMessage.toString());
      },
    );
  }

  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
          body: Container(
                    height: MediaQuery.of(context).size.height,
                    width: MediaQuery.of(context).size.width,
                    decoration: const BoxDecoration(
                        gradient: LinearGradient(
                      begin: Alignment.topCenter,
                      end: Alignment.bottomCenter,
                      colors: [
                        Color.fromRGBO(0, 0, 31, 10),
                        Color.fromRGBO(65, 1, 590, 10)
                      ],
                    )),
                    child: Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: <Widget>[
                            finishingValue?const SizedBox(
                              height: 200,
                              child: const SpinKitRipple(
                                size: 100,
                                color: Colors.white,
                              ),
                            ):const SizedBox(width: 0,height: 0,),
                            finishingValue?const Text(
                                "Just Some More Time",
                              style: TextStyle(
                                color: Colors.white,
                                fontSize: 19,
                                fontWeight: FontWeight.w200
                              ),
                            ):ElevatedButton(
                              style: ButtonStyle(
                                backgroundColor: MaterialStateProperty.all(
                                  const Color.fromRGBO(0, 0, 31, 10),
                                ),
                              ),
                              onPressed: () async {
                                print("Pressed Finish Login");

                                await headlessWebView?.dispose();
                                await headlessWebView?.run();

                                setState(() {
                                  finishingValue = true;
                                });

                                Future.delayed(Duration(seconds: 2),() async{
                                  await headlessWebView?.dispose();

                                  // Navigator.pushNamedAndRemoveUntil(context, "/QR",
                                  //         (Route<dynamic> route) => false); //Todo: use pushNamed.
                                });
                              },
                              child: const Text("Finish Login",
                                  style:
                                  TextStyle(fontWeight: FontWeight.w300, fontSize: 15)),
                            ),
                          ]),
                  ));
  }
}

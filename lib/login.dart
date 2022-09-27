import 'dart:io';
import 'package:matrix/fetchDetails.dart';
import 'package:flutter/material.dart';
import 'package:flutter_inappwebview/flutter_inappwebview.dart';

class Login extends StatefulWidget {
  final String sourceLink;

  const Login({required this.sourceLink});

  @override
  _LoginState createState() => new _LoginState(sourceLink: sourceLink);
}

class _LoginState extends State<Login> {
  final String sourceLink;
  _LoginState({required this.sourceLink});

  final GlobalKey webViewKey = GlobalKey();

  InAppWebViewController? webViewController;
  InAppWebViewGroupOptions options = InAppWebViewGroupOptions(
      crossPlatform: InAppWebViewOptions(
        javaScriptCanOpenWindowsAutomatically: true,
        userAgent: "random",
        useShouldOverrideUrlLoading: true,
        mediaPlaybackRequiresUserGesture: false,
      ),
      android: AndroidInAppWebViewOptions(
        appCachePath: "/",
        supportMultipleWindows: true,
        useHybridComposition: true,
      ),
      ios: IOSInAppWebViewOptions(
        allowsInlineMediaPlayback: true,
      ));

  late PullToRefreshController pullToRefreshController;
  String url = "";
  double progress = 0;
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
  }

  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        body: SafeArea(
            child: Column(children: <Widget>[
              TextField(
                decoration: const InputDecoration(
                    prefixIcon: Icon(Icons.search)
                ),
                controller: urlController,
                keyboardType: TextInputType.url,
                onSubmitted: (value) async{
                  var url = Uri.parse(value);
                  if (url.scheme.isEmpty) {
                    url = Uri.parse("https://www.google.com/search?q=$value");
                  }
                  webViewController?.loadUrl(
                      urlRequest: URLRequest(url: url));
                  dynamic x = await webViewController?.getUrl();
                },
              ),
              Expanded(
                child: Stack(
                  children: [
                    InAppWebView(
                      key: webViewKey,
                      initialUrlRequest:
                      URLRequest(url: Uri.parse(sourceLink)),
                      initialOptions: options,
                      pullToRefreshController: pullToRefreshController,
                      onWebViewCreated: (controller) {
                        webViewController = controller;
                      },

                      onCreateWindow: (controller, createWindowAction) async {
                        showDialog(
                          context: context,
                          builder: (context) {
                            return Align(
                              alignment: Alignment.bottomCenter,
                              child: AlertDialog(
                                content: Container(
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
                                    onWebViewCreated: (InAppWebViewController controller) {
                                      dynamic _webViewPopupController = controller;
                                    },
                                    onLoadStart: (InAppWebViewController controller, url) {
                                    },
                                    onLoadStop: (InAppWebViewController controller, url) {
                                    },
                                  ),
                                ),
                              ),
                            );
                          },
                        );

                        return true;
                      },

                      onLoadStart: (controller, url) {
                        setState(() {
                          this.url = url.toString();
                          urlController.text = this.url;
                        });
                      },
                      androidOnPermissionRequest: (controller, origin, resources) async {
                        return PermissionRequestResponse(
                            resources: resources,
                            action: PermissionRequestResponseAction.GRANT);
                      },
                      shouldOverrideUrlLoading: (controller, navigationAction) async {
                        var uri = navigationAction.request.url!;

                        if (![ "http", "https", "file", "chrome",
                          "data", "javascript", "about"].contains(uri.scheme)) {

                        }

                        return NavigationActionPolicy.ALLOW;
                      },
                      onLoadStop: (controller, url) async {
                        pullToRefreshController.endRefreshing();
                        setState(() {
                          this.url = url.toString();
                          urlController.text = this.url;
                        });

                      },
                      onLoadError: (controller, url, code, message) {
                        pullToRefreshController.endRefreshing();
                      },
                      onProgressChanged: (controller, progress) async{
                        if (progress == 100) {
                          pullToRefreshController.endRefreshing();
                        }

                        setState(() {
                          this.progress = progress / 100;
                          urlController.text = this.url;
                        });

                        if (urlController.text  == "https://www.linkedin.com/feed/") {
                          webViewController!.loadUrl(urlRequest: URLRequest(url: Uri.parse("https://www.linkedin.com/psettings/email?li_theme=dark&openInMobileMode=true")));
                        Navigator.push(context,MaterialPageRoute(builder: (context){
                            return FetchDetails();
                          }));
                        }
                      },


                      onUpdateVisitedHistory: (controller, url, androidIsReload) {
                        setState(() {
                          this.url = url.toString();
                          urlController.text = this.url;
                        });
                      },
                      onConsoleMessage: (controller, consoleMessage) {
                      },
                    ),
                    progress < 1.0
                        ? LinearProgressIndicator(value: progress)
                        : Container(),
                  ],
                ),
              ),
            ])),
      ),
    );
  }
}

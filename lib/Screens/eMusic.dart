// ignore_for_file: camel_case_types

import 'package:connectivity/connectivity.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:scancode/GeneralNav.dart';
import 'package:flutter_barcode_scanner/flutter_barcode_scanner.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:webview_flutter/webview_flutter.dart';
class eMarketing extends StatefulWidget{
  const eMarketing({super.key});

  @override
  State<eMarketing> createState() => _eMarketingState();
}

class _eMarketingState extends State<eMarketing> {



  var scannedData;
  late final WebViewController controller=WebViewController.fromPlatformCreationParams(params, onPermissionRequest: (request) {request.grant();},
  )

    ..setJavaScriptMode(JavaScriptMode.unrestricted)
    ..setBackgroundColor(const Color(0x00000000))
    ..setNavigationDelegate(

      NavigationDelegate(
        onProgress: (int progress) {
          print("Progress: $progress");
          setState(() {
            isLoading = progress < 100;
          });
        },
        onPageStarted: ( String url) {},
        onPageFinished: ( String url) {},
        onWebResourceError: (WebResourceError error) {},

        onNavigationRequest: (NavigationRequest request) {
          print(request.url);
          if (request.url.contains('pdf')) {
            launch(request.url);
            return NavigationDecision.prevent;
          }
          else if (request.url.contains('file')) {
            launch(request.url);
            return NavigationDecision.prevent;
          }

          return NavigationDecision.navigate;
        },
      ),
    )
    ..loadRequest(Uri.parse(urlEmarketing));
  late final PlatformWebViewControllerCreationParams params=const PlatformWebViewControllerCreationParams();



  String urlEmarketing='https://emarket.scancode.co.tz/';
bool isLoading=false;
  @override
  void initState() {

    super.initState();

    Future.delayed(const Duration(seconds: 2), () {
      setState(() {
        isLoading = false;
      });
    });
    // Call the barcode scanner when the page is loaded

  }



@override
  Widget build(BuildContext context) {



  return Scaffold(
    appBar: AppBar(
      title:Row(
        children: [
          Image.asset('assets/icons/Screenshot_20230815-234221_ScanCode.jpg',width: 25,
            height: 25,),
          const SizedBox(width: 8,),
          const Text('ScanCode'),
        ],
      ),
      backgroundColor: Colors.black,
      foregroundColor: Colors.white,

    ),
    endDrawer: const MyAnimatedDrawer(),

    body:  isLoading
        ? Center(
      child: Container(
        width: 70,
        height: 70,
        child: Column(
          children: [
            CircularProgressIndicator(
                backgroundColor: Colors.green[700],
                color: Colors.white),
            SizedBox(height: 10,),
            Text('Loading',style: TextStyle(fontWeight: FontWeight.bold),),
          ],
        ),
      ),
    )
        :Column(
      children: [
        Expanded(
          child: WebViewWidget(
            controller: controller,

  ),
        ),
        // Place your controller buttons here
        // You can use another Row or any other widget layout
        Container(
          color: Colors.black,
          height: 50,
          padding: EdgeInsets.all(5.0),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              IconButton(
                icon: Icon(Icons.arrow_back,color: Colors.green[700]),
                onPressed: () {
                  if (controller != null) {
                    controller.goBack();
                  }
                },
              ),
              IconButton(
                icon: Icon(Icons.arrow_forward,color: Colors.green[700]),
                onPressed: () {
                  if (controller != null) {
                    controller.goForward();
                  }
                },
              ),
              IconButton(
                icon: Icon(Icons.refresh,color: Colors.green[700]),
                onPressed: () {
                  if (controller != null) {
                    controller.reload();
                  }
                },
              ),
            ],
          ),
        ),
      ],
    ),


  );

}
}

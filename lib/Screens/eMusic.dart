// ignore_for_file: camel_case_types

import 'package:connectivity/connectivity.dart';
import 'package:flutter/material.dart';
import 'package:scancode/GeneralNav.dart';
import 'package:flutter_barcode_scanner/flutter_barcode_scanner.dart';
import 'package:webview_flutter/webview_flutter.dart';
class eMusic extends StatefulWidget{
  const eMusic({super.key});

  @override
  State<eMusic> createState() => _eMusicState();
}

class _eMusicState extends State<eMusic> {
  @override


  @override
var scannedData;
final Connectivity _connectivity = Connectivity();
bool _isConnected = true;
late final WebViewController controller;
bool isLoading=false;
  void initState() {
    super.initState();

    // Call the barcode scanner when the page is loaded
    launchBarcodeScanner();
  }
  void launchBarcodeScanner() async {
    String barcodeScanResult = await FlutterBarcodeScanner.scanBarcode(
      '#ff6666', // Color for the scanner UI
      'Cancel', // Cancel button text
      true, // Show flash icon
      ScanMode.DEFAULT, // Scan mode (you can also use ScanMode.QR for QR codes only)
    );

    // Handle the scan result
    if (barcodeScanResult != '-1') {
      setState(() {
        scannedData = barcodeScanResult;
      });

      if (scannedData is String) {
        // Initialize the WebViewController
        controller = WebViewController()
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
              onPageStarted: (String url) {},
              onPageFinished: (String url) {},
              onWebResourceError: (WebResourceError error) {},
              onNavigationRequest: (NavigationRequest request) {
                if (request.url.startsWith('')) {
                  return NavigationDecision.navigate;
                }
                return NavigationDecision.navigate;
              },
            ),
          )
          ..loadRequest(Uri.parse(scannedData));

        setState(() {
          isLoading = false;
        });

        // Navigate to the WebView page
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) {
              return Scaffold(
                appBar: AppBar(
                  title: Row(
                    children: [
                      Image.asset(
                        'assets/icons/Screenshot_20230815-234221_ScanCode.jpg',
                        width: 25,
                        height: 25,
                      ),
                      const SizedBox(
                        width: 8,
                      ),
                      const Text('e-Viwango'),
                    ],
                  ),
                  backgroundColor: Colors.black,
                  foregroundColor: Colors.white,
                ),
                body: WebViewWidget(
                  controller: controller,
                ),
              );
            },
          ),
        );
      }
    }
  }
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
      actions: [
        Builder(
          builder: (BuildContext context) {
            return IconButton(
              icon:  Icon(Icons.menu,color: Colors.green[700]),
              onPressed: () {
                Scaffold.of(context).openEndDrawer();
              },
            );
          },
        ),
      ],
    ),
    endDrawer: const MyAnimatedDrawer(),

  );

}
}

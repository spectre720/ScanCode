
// ignore_for_file: camel_case_types, use_build_context_synchronously

import 'dart:convert';

import 'package:connectivity/connectivity.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:go_router/go_router.dart';
import 'package:scancode/GeneralNav.dart';
import 'package:flutter_barcode_scanner/flutter_barcode_scanner.dart';
import 'package:webview_flutter/webview_flutter.dart';
import 'package:http/http.dart' as http;


final _formKey = GlobalKey<FormState>();




class eKurasa extends StatefulWidget {
  const eKurasa({super.key});

  @override


  State<eKurasa> createState() => _eKurasaState();
}


class _eKurasaState extends State<eKurasa> {
  final Connectivity _connectivity = Connectivity();
  bool _isConnected = true;
  late final WebViewController controller;
  bool isLoading=false;


  @override
  void initState() {
    super.initState();
    // Simulate an asynchronous task
    _checkConnection();
    Future.delayed(const Duration(seconds: 3), () {
      setState(() {
        isLoading = false;
      });
    });
  }
  void _checkConnection() async {
    var connectivityResult = await _connectivity.checkConnectivity();
    setState(() {
      _isConnected = connectivityResult != ConnectivityResult.none;
    });
  }



  final TextEditingController barcodeController = TextEditingController();
   searchProduct(String Data) async {
    final barcode =Data;

    setState(() {
      isLoading = true;
    });
    try
    {
      final response = await http.get(
        Uri.parse(
            'http://192.168.1.101/API/search_by_barcode.php?barcode=$barcode'),
      );



      print('Hello juan');
      if (response.statusCode == 200) {
        print('${response.statusCode} hello');
        final productData = json.decode(response.body);
        var image = productData['Picture'];
        setState(() {
          isLoading = false;
        });

        return Navigator.push(
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
                body: isLoading
                    ? Center(
                        child: Container(
                          width: 50,
                          height: 50,
                          child: CircularProgressIndicator(
                              backgroundColor: Colors.green[700],
                              color: Colors.white),
                        ),
                      )
                    : Center(
                        child: Column(
                        children: [
                          const SizedBox(
                            height: 12,
                          ),
                          Center(
                            child: Image.network(
                              'http://192.168.1.101/$image',
                              width: 200,
                              height: 200,
                              fit: BoxFit.cover,
                            ),
                          ),
                          DataTable(columns: const [
                            DataColumn(
                              label: Text('DETAIL',
                                  style: TextStyle(
                                      fontWeight: FontWeight.bold,
                                      fontSize: 15)),
                            ),
                            DataColumn(
                              label: Text('DESCRIPTION',
                                  style: TextStyle(
                                      fontWeight: FontWeight.bold,
                                      fontSize: 15)),
                            ),
                          ], rows: [
                            DataRow(cells: [
                              const DataCell(Text(
                                'Product Name:',
                                style: TextStyle(
                                    fontWeight: FontWeight.bold, fontSize: 15),
                              )),
                              DataCell(Text(
                                productData['PName'],
                                style: const TextStyle(fontSize: 15),
                              )),
                            ]),
                            DataRow(cells: [
                              const DataCell(Text(
                                'Manufacturer:',
                                style: TextStyle(
                                    fontWeight: FontWeight.bold, fontSize: 15),
                              )),
                              DataCell(Text(
                                productData['Manufacturer'],
                                style: const TextStyle(fontSize: 15),
                              )),
                            ]),
                            DataRow(cells: [
                              const DataCell(Text(
                                'Status:',
                                style: TextStyle(
                                    fontWeight: FontWeight.bold, fontSize: 15),
                              )),
                              DataCell(
                                Row(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: <Widget>[
                                    Icon(Icons.check, color: Colors.green[700]),
                                  ],
                                ),
                              ),
                            ]),
                          ])
                        ],
                      )),
              );
            },
          ),
        );
      } else if (response.statusCode == 404) {
        print('${response.statusCode} hello');
        setState(() {
          isLoading = false;
        });


        return showDialog(
            context: context,
            builder: (BuildContext context) {
              return AlertDialog(
                title: const Text('Alert'),
                content: const Text('sorry we couldnt find the product'),
                actions: [
                  TextButton(
                    onPressed: () {
                      Navigator.of(context).pop(); // Close the AlertDialog
                    },
                    child: const Text('Close'),
                  ),
                ],
              );
            });
      } else if (response.statusCode == 500) {
        print('${response.statusCode} hello');

        return showDialog(
            context: context,
            builder: (BuildContext context) {
              return AlertDialog(
                title: const Text('Alert'),
                content:
                    const Text('Internal server error please try again later'),
                actions: [
                  TextButton(
                    onPressed: () {
                      Navigator.of(context).pop(); // Close the AlertDialog
                    },
                    child: const Text('Close'),
                  ),
                ],
              );
            });
      } else {
        print('${response.statusCode} hello');

        return showDialog(
            context: context,
            builder: (BuildContext context) {
              return AlertDialog(
                title: const Text('Alert'),
                content: const Text(
                    'Sorry there is a failure to lookup the product'),
                actions: [
                  TextButton(
                    onPressed: () {
                      Navigator.of(context).pop(); // Close the AlertDialog
                    },
                    child: const Text('Close'),
                  ),
                ],
              );
            });
      }
    }
    catch(e){

      return showDialog(
          context: context,
          builder: (BuildContext context) {
            return AlertDialog(
              title: const Text('Alert'),
              content: const Text(
                  "please try again letter the server is unreachable"),
              actions: [
                TextButton(
                  onPressed: () {
                    Navigator.of(context).pop(); // Close the AlertDialog
                  },
                  child: const Text('Close'),
                ),
              ],
            );
          });

    }
  }





  @override
  Widget build(BuildContext context) {
    var scannedData;
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

        // backgroundColor: Colors.black,
        // foregroundColor: Colors.white,



      body: Column(
          children: [

            const SizedBox(height: 12,),
            const SizedBox(height: 12,),
            Image.asset('assets/icons/20230818_155426.jpg',width: 150,
              height: 150,),

            Form(
              key: _formKey,

              child: Padding(
                padding: const EdgeInsets.all(1),
                child: Column(

                  mainAxisAlignment: MainAxisAlignment.center,
                  children:[




                    const SizedBox(height: 12,),
                    Center(
                      child: Container(
                        width: 380,
                        child: TextFormField(
                          validator: (value) {
                            if (value!.isEmpty) {
                              return 'Please enter barcode number';
                            }
                            return null;
                          },
                          controller: barcodeController,
                          keyboardType: TextInputType.number,
                          decoration: const InputDecoration(
                            border: OutlineInputBorder(),



                            labelText: 'BarCode Number ',



                          ),

                        ),
                      ),
                    ),
                    const SizedBox(height: 12,),



                    ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        foregroundColor: Colors.white,
                        backgroundColor: Colors.green[700],
                      ),
                      onPressed: () async {
                        setState(() {
                          isLoading = true;
                        });
                        if (_formKey.currentState != null &&
                            _formKey.currentState!.validate()) {
                          var number = barcodeController.text;
                          if (_isConnected) {
                            searchProduct(number);
                          } else {
                            setState(() {
                              isLoading = false;
                            });
                            showDialog(
                              context: context,
                              builder: (BuildContext context) {
                                return AlertDialog(
                                  title: const Text('Alert'),
                                  content: const Text(
                                      'Please check your internet connection'),
                                  actions: [
                                    TextButton(
                                      onPressed: () {
                                        Navigator.of(context).pop(); // Close the AlertDialog
                                      },
                                      child: const Text('Close'),
                                    ),
                                  ],
                                );
                              },
                            );
                          }
                        } else {
                          // Show an AlertDialog if the form is not valid.
                          setState(() {
                            isLoading = false;
                          });
                          showDialog(
                            context: context,
                            builder: (BuildContext context) {
                              return AlertDialog(
                                title: const Text('Alert'),
                                content: const Text(
                                    'Please enter the barcode number'),
                                actions: [
                                  TextButton(
                                    onPressed: () {
                                      Navigator.of(context).pop(); // Close the AlertDialog
                                    },
                                    child: const Text('Close'),
                                  ),
                                ],
                              );
                            },
                          );
                        }
                      },
                      child:  const Text('Extract', style: TextStyle(fontSize: 18)),
                    ),

                  ],

                ),
              ),

            ),

          ],

        ),
          floatingActionButton: FloatingActionButton(
            backgroundColor: Colors.green[700],
          onPressed:() async{


            String barcodeScanResult = await FlutterBarcodeScanner.scanBarcode(
              '#ff6666', // Color for the scanner UI
              'Cancel', // Cancel button text
              true, // Show flash icon
              ScanMode
                  .DEFAULT, // Scan mode (you can also use ScanMode.QR for QR codes only)
            );
            // Fluttertoast.showToast(msg: scannedData);

            // Handle the scan result
                if(_isConnected){
            if (barcodeScanResult != '-1') {
              // Process the scanned data, e.g., display it on the same page
              setState(() {
                scannedData = barcodeScanResult;
              });

              if (scannedData is String) {
                // Fluttertoast.showToast(msg: scannedData);
                // Fluttertoast.showToast(msg: scannedData);
                print(scannedData);

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
                        onPageFinished: (String url) {

                        },
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
                    isLoading=false;
                  });


// JavaScript function to be called when the data is received.
                  void receiveData(String data) {
                    // Do something with the data received from the URL.
                  }

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
                          body:  WebViewWidget(
                                  controller: controller,
                                ),
                        );
                      },
                    ),
                  );

              } else if (scannedData is int) {
                searchProduct(scannedData);

                print("${scannedData}kazi");
              }
            } else {
              showDialog(
                  context: context,
                  builder: (BuildContext context) {
                    return AlertDialog(
                      title: const Text('Alert'),
                      content: const Text(
                          'unfortunately our application couldnt recognize the the barrcode or qrcode'),
                      actions: [
                        TextButton(
                          onPressed: () {
                            Navigator.of(context)
                                .pop(); // Close the AlertDialog
                          },
                          child: const Text('Close'),
                        ),
                      ],
                    );
                  });
            }
          }
         else{
                  setState(() {
                    isLoading = false;
                  });
                  showDialog(
                      context: context,
                      builder: (BuildContext context) {
                        return AlertDialog(
                          title: const Text('Alert'),
                          content: const Text(
                              'Please check your internet connection'),
                          actions: [
                            TextButton(
                              onPressed: () {
                                Navigator.of(context)
                                    .pop(); // Close the AlertDialog
                              },
                              child: const Text('Close'),
                            ),
                          ],
                        );
                      });
                }
        },
          tooltip: 'Scan now',
          child: const Icon(Icons.qr_code),
          ),






      // This trailing comma makes auto-formatting nicer for build methods.
    );
  }
}
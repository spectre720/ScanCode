
// ignore_for_file: camel_case_types, use_build_context_synchronously, prefer_typing_uninitialized_variables

import 'dart:convert';


import 'package:connectivity/connectivity.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_phone_direct_caller/flutter_phone_direct_caller.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:scancode/GeneralNav.dart';
import 'package:flutter_barcode_scanner/flutter_barcode_scanner.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:webview_flutter/webview_flutter.dart';
import 'package:http/http.dart' as http;

import '../userScanDetails.dart';


final _formKey = GlobalKey<FormState>();




class eKurasa extends StatefulWidget {
  const eKurasa({super.key});

  @override


  State<eKurasa> createState() => _eKurasaState();
}


class _eKurasaState extends State<eKurasa> {
  final Connectivity _connectivity = Connectivity();
  bool _isConnected = true;

  bool isLoading=false;
  var title;


  @override
  void initState() {
    super.initState();
    _checkConnection();
    Future.delayed(const Duration(seconds: 2), () {
      setState(() {
        isLoading = false;
      });
    });
  }
  @override


  void _checkConnection() async {
    var connectivityResult = await _connectivity.checkConnectivity();
    setState(() {
      _isConnected = connectivityResult != ConnectivityResult.none;
    });
  }



  final TextEditingController barcodeController = TextEditingController();
  searchProduct(int Data) async {
    final barcode =Data;


    try
    {
      setState(() {
        isLoading = true;
      });

      final response = await http.get(
        Uri.parse(
            'https://emarket.scancode.co.tz/api/search-by-qrcode?barcode=$barcode'),
      );





      print('Hello juan');
      if (response.statusCode == 200) {

        print('${response.statusCode} hello');
        final productData = json.decode(response.body);
        setState(() {

        });
        var productData2=productData[0];
        print(productData2);

        // print('$image hello');
        setState(() {
          isLoading = false;
        });

        if(productData2==null)
        {
          setState(() {
            isLoading = false;
          });
          showDialog(
              context: context,
              builder: (BuildContext context) {
                return AlertDialog(
                  title: Row(
                    children: [
                      const Icon(Icons.warning,size: 15,),
                      SizedBox(width: 5,),
                      Text('Alert'),

                    ],
                  ),
                  content: const Text('sorry our application could not recognize the product'),
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
        else{
          var productData2=productData[0];
          var image = productData2['product_image'];
          var identity=productData2['identity'];

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
                  body:  SingleChildScrollView(
                    child: Center(
                        child: Column(
                          children: [
                            const SizedBox(
                              height: 12,
                            ),
                            Center(
                              child: Image.network(
                                'https://emarket.scancode.co.tz/bronchures/$image',
                                width: 300,
                                height: 300,
                                fit: BoxFit.cover,
                              ),
                            ),
                            DataTable(columns: const [
                              DataColumn(
                                label: Text('',
                                    style: TextStyle(
                                        fontWeight: FontWeight.bold, fontSize: 10)),
                              ),
                              DataColumn(
                                label: Text('',
                                    style: TextStyle(
                                        fontWeight: FontWeight.bold, fontSize: 10)),
                              ),
                            ], rows: [
                              DataRow(cells: [
                                const DataCell(Text(
                                  'Product Name:',
                                  style: TextStyle(
                                      fontWeight: FontWeight.bold, fontSize: 20),
                                )),
                                DataCell(Text(
                                  productData2['product_name'],
                                  style: const TextStyle(fontSize: 20),
                                )),
                              ]),
                              DataRow(cells: [
                                const DataCell(Text(
                                  'category:',
                                  style: TextStyle(
                                      fontWeight: FontWeight.bold, fontSize: 20),
                                )),
                                DataCell(Text(
                                  productData2['category'],
                                  style: const TextStyle(fontSize: 20),
                                )),
                              ]),
                              DataRow(cells: [
                                const DataCell(Text(
                                  'Manufacturer:',
                                  style: TextStyle(
                                      fontWeight: FontWeight.bold, fontSize: 20),
                                )),
                                DataCell(Text(
                                  productData2['manufacturer'],
                                  style: const TextStyle(fontSize: 20),
                                )),
                              ]),
                              DataRow(cells: [
                                const DataCell(Text(
                                  'Country:',
                                  style: TextStyle(
                                      fontWeight: FontWeight.bold, fontSize: 20),
                                )),
                                DataCell(Text(
                                  productData2['country'],
                                  style: const TextStyle(fontSize: 20),
                                )),
                              ]),
                              DataRow(cells: [
                                const DataCell(Text(
                                  'Region:',
                                  style: TextStyle(
                                      fontWeight: FontWeight.bold, fontSize: 20),
                                )),
                                DataCell(Text(
                                  productData2['region'],
                                  style: const TextStyle(fontSize: 20),
                                )),
                              ]),
                              DataRow(cells: [
                                const DataCell(Text(
                                  'Status:',
                                  style: TextStyle(
                                      fontWeight: FontWeight.bold, fontSize: 20),
                                )),
                                DataCell(
                                  Row(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: <Widget>[
                                      Icon(Icons.check_circle_outline,
                                          color: Colors.green[700]),
                                    ],
                                  ),
                                ),
                              ]),
                            ]),
                            ElevatedButton(
                              style: ElevatedButton.styleFrom(
                                foregroundColor: Colors.white,
                                backgroundColor: Colors.green[700],
                              ),
                              onPressed:() async{


                                print(identity);
                                WebViewController controller1=WebViewController()
                                  ..setJavaScriptMode(JavaScriptMode.unrestricted)
                                  ..setBackgroundColor(const Color(0x00000000))
                                  ..setNavigationDelegate(
                                    NavigationDelegate(
                                      onProgress: (int progress) {
                                        print("Progress: $progress");
                                        print("Progress: $progress");


                                      },
                                      onPageStarted: (String url) {

                                      },
                                      onPageFinished: (String url) {

                                      },
                                      onWebResourceError: (WebResourceError error) {},
                                      onNavigationRequest: (NavigationRequest request) {
                                        if (request.url.contains('whatsapp')) {
                                          launch(request.url);
                                          return NavigationDecision.prevent;

                                        }
                                        else if(request.url.contains('tel')){
                                          FlutterPhoneDirectCaller.callNumber(request.url);
                                          return NavigationDecision.prevent;
                                        }
                                        return NavigationDecision.navigate;
                                      },
                                    ),
                                  )

                                  ..loadRequest(Uri.parse('https://emarket.scancode.co.tz/m/$identity'));

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
                                              Text('e-Viwango'),
                                            ],
                                          ),

                                          backgroundColor: Colors.black,
                                          foregroundColor: Colors.white,
                                        ),
                                        body:Column(
                                          children: [
                                            Expanded(
                                              child: WebViewWidget(
                                                controller: controller1,
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
                                                      if (controller1 != null) {
                                                        controller1.goBack();
                                                      }
                                                    },
                                                  ),
                                                  IconButton(
                                                    icon: Icon(Icons.arrow_forward,color: Colors.green[700]),
                                                    onPressed: () {
                                                      if (controller1 != null) {
                                                        controller1.goForward();
                                                      }
                                                    },
                                                  ),
                                                  IconButton(
                                                    icon: Icon(Icons.refresh,color: Colors.green[700]),
                                                    onPressed: () {
                                                      if (controller1 != null) {
                                                        controller1.reload();
                                                      }
                                                    },
                                                  ),
                                                ],
                                              ),
                                            ),
                                          ],
                                        ),
                                      );
                                    },
                                  ),
                                );
                              },
                              child: Text(
                                'Discover More',
                                style: TextStyle(color: Colors.white,fontWeight: FontWeight.bold,fontSize: 20),)
                              ,)
                          ],
                        )
                    ),
                  ),
                );
              }

            ),
          );
        }
      } else if (response.statusCode == 500) {
        print('${response.statusCode} hello');
        setState(() {
          isLoading = false;
        });


        return showDialog(
            context: context,
            builder: (BuildContext context) {
              return AlertDialog(
                title: Row(
                  children: [
                    const Icon(Icons.warning,size: 15,),
                    SizedBox(width: 5,),
                    Text('Alert'),

                  ],
                ),
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

        setState(() {
          isLoading = false;
        });
        return showDialog(
            context: context,
            builder: (BuildContext context) {
              return AlertDialog(
                title: Row(
                  children: [
                    const Icon(Icons.warning,size: 15,),
                    SizedBox(width: 5,),
                    Text('Alert'),

                  ],
                ),
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
      print(e);
      setState(() {
        isLoading = false;
      });
      showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            title: Row(
              children: [
                const Icon(Icons.warning,size: 15,),
                SizedBox(width: 5,),
                Text('Alert'),

              ],
            ),
            content: const Text(
                "please try again later, the server is unreachable"),
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
                      _checkConnection();

                      if (_formKey.currentState != null &&
                          _formKey.currentState!.validate()) {
                        var number = barcodeController.text;
                        if (_isConnected) {
                          searchProduct(int.parse(number));

                        } else {

                          showDialog(
                            context: context,
                            builder: (BuildContext context) {
                              return AlertDialog(
                                title: Row(
                                  children: [
                                    const Icon(Icons.warning,size: 15,),
                                    SizedBox(width: 5,),
                                    Text('Alert'),

                                  ],
                                ),
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

                        showDialog(
                          context: context,
                          builder: (BuildContext context) {
                            return AlertDialog(
                              title: Row(
                                children: [
                                  const Icon(Icons.warning,size: 15,),
                                  SizedBox(width: 5,),
                                  Text('Alert'),

                                ],
                              ),
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
                    child:

                    isLoading
                        ?
                    Container(
                      height: 15,
                      width: 15,
                      child: CircularProgressIndicator(
                        backgroundColor: Colors.green[700],
                        color: Colors.white,),
                    )
                        :const Text('Extract', style: TextStyle(fontSize: 18)),
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
          _checkConnection();




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

              scannedData = barcodeScanResult;
              deviceInfo().printDeviceDetails();



              if (scannedData.toString().contains('http')) {
                if(scannedData.toString().contains('music')){
                  title='e-Music';
                }
                else{
                  title='e-Viwango';
                }
                // Fluttertoast.showToast(msg: scannedData);
                // Fluttertoast.showToast(msg: scannedData);
                print(scannedData);
                _checkConnection();

                WebViewController controller=WebViewController()
                  ..setJavaScriptMode(JavaScriptMode.unrestricted)
                  ..setBackgroundColor(const Color(0x00000000))
                  ..setNavigationDelegate(
                    NavigationDelegate(
                      onProgress: (int progress) {
                        print("Progress: $progress");
                        print("Progress: $progress");


                      },
                      onPageStarted: (String url) {

                      },
                      onPageFinished: (String url) {

                      },
                      onWebResourceError: (WebResourceError error) {},
                      onNavigationRequest: (NavigationRequest request) {

                        if (request.url.contains('whatsapp')) {
                            launch(request.url);
                          return NavigationDecision.prevent;

                        }
                        else if(request.url.contains('tel')){
                          FlutterPhoneDirectCaller.callNumber(request.url);
                          return NavigationDecision.prevent;
                        }
                        return NavigationDecision.navigate;
                      },
                    ),
                  )

                  ..loadRequest(Uri.parse(scannedData));


// JavaScript function to be called when the data is received.
                _checkConnection();




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
                              Text(title),
                            ],
                          ),

                          backgroundColor: Colors.black,
                          foregroundColor: Colors.white,
                        ),
                        body:Column(
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
                    },
                  ),
                );

              } else {

                _checkConnection();
                Fluttertoast.showToast(msg: scannedData);
                searchProduct(int.parse(scannedData));
                _checkConnection();
                print("${scannedData}kazi");

              }
            } else {
              showDialog(
                  context: context,
                  builder: (BuildContext context) {
                    return AlertDialog(
                      title: Row(
                        children: [
                          const Icon(Icons.warning,size: 15,),
                          SizedBox(width: 5,),
                          Text('Alert'),

                        ],
                      ),
                      content: const Text(
                          'unfortunately our application could not recognize the the barcode or qrcode'),
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

            showDialog(
                context: context,
                builder: (BuildContext context) {
                  return AlertDialog(
                    title: Row(
                      children: [
                        const Icon(Icons.warning,size: 15,),
                        SizedBox(width: 5,),
                        Text('Alert'),

                      ],
                    ),
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
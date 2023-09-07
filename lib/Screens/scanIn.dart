// ignore_for_file: camel_case_types, file_names, use_build_context_synchronously

import 'dart:convert';
import 'package:chaleno/chaleno.dart';
import 'package:flutter/widgets.dart';
import 'package:connectivity/connectivity.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:image_picker/image_picker.dart';
//import 'package:fluttertoast/fluttertoast.dart';
//import 'package:go_router/go_router.dart';
import 'package:scancode/GeneralNav.dart';
import 'package:file/file.dart';
import 'package:path/path.dart';
import 'package:uri_to_file/uri_to_file.dart';
import 'package:scan/scan.dart';
import 'dart:io';
import 'dart:async';
import 'package:http/http.dart' as http;
import 'package:html/parser.dart' as htmlParser;
import 'package:html/dom.dart' as htmlDom;

import 'package:webview_flutter/webview_flutter.dart';


class scanIn extends StatefulWidget{
  const scanIn({super.key});

  @override
  State<scanIn> createState() => _scanInState();
}



class _scanInState extends State<scanIn> {
  var dataRec;

  late final WebViewController  controller;
  Connectivity _connectivity = Connectivity();
  bool _isConnected = true;
  String _platformVersion = 'Unknown';
  var qrcode ;
  bool isLoading=true;
  var file;
  var details;
  var scanResult;
  @override

  void initState() {
    super.initState();
    _checkConnection();
    Future.delayed(const Duration(seconds: 3), () {
      setState(() {
        isLoading = false;
      });
    });

  }
  void receiveData(data) {
    // Print the data received from the URL to the console.
    print(data);
  }

  Future<void> initPlatformState() async {
    String platformVersion;
    try {
      platformVersion = await Scan.platformVersion;
    } on PlatformException {
      platformVersion = 'Failed to get platform version.';
    }
    if (!mounted) return;

    setState(() {
      _platformVersion = platformVersion;
    });
  }
  void _checkConnection() async {
    var connectivityResult = await _connectivity.checkConnectivity();
    setState(() {
      _isConnected = connectivityResult != ConnectivityResult.none;
    });
  }
  String? selectedImagePath;
  TextEditingController _textEditingController = TextEditingController();






  @override
  Widget build(BuildContext context) {

    searchProduct(String Data) async {
      setState(() {
        isLoading = true ;
      });
      final barcode =Data;


      try
      {

        final response = await http.get(
          Uri.parse(
              'http://192.168.43.29/API/search_by_barcode.php?barcode=$barcode'),
        );



        print('Hello juan');
        if (response.statusCode == 200) {
          print('${response.statusCode} hello');
          final productData = json.decode(response.body);
          var image = productData['Picture'];

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
                              'http://192.168.43.29/$image',
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
          showDialog(
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
          setState(() {
            isLoading = false;
          });
          showDialog(
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
          setState(() {
            isLoading = false;
          });
          showDialog(
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
        setState(() {
          isLoading = false;
        });
        showDialog(
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
    Future<File?> getImage() async {
      setState(() {
        isLoading = true;
      });
      final picker = ImagePicker();
      final pickedFile = await picker.pickImage(source: ImageSource.gallery);
      if (pickedFile != null) {
        setState(() async {
          selectedImagePath = pickedFile.path;
          print("${selectedImagePath}");
          print("hello");

          String fileName = basename(selectedImagePath!);
          file = await toFile(selectedImagePath!);
          _textEditingController.text = fileName;



        }
        );
      }
      return null;
    }
    scanImport(String pathFromGallery) async {
      var str = await Scan.parse(selectedImagePath!);
      if (str != null) {
        setState(() {
          qrcode = str;
        });
        print(qrcode);

        if (qrcode is String) {
          // Fluttertoast.showToast(msg: scannedData);
          // Fluttertoast.showToast(msg: scannedData);
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
                onPageStarted: (String url) {
                  dataRec = "";
                },
                onPageFinished: (String url) async {
                  // Call the JavaScript function with the data received from the URL.
                  String extractedContent = 'Content will be displayed here';
                  Future<void> fetchData() async {
                    try {
                      final response = await http.get(Uri.parse(url));

                      if (response.statusCode == 200) {

                        final document = htmlParser.parse(response.body);

                        // Replace '.content' with the actual CSS selector for the content you want to extract
                        final contentElement = document.querySelector('body > div');

                        if (contentElement != null) {
                          setState(() {
                            extractedContent = contentElement.text;
                          });
                          print(extractedContent);
                        } else {
                          setState(() {
                            extractedContent = 'Content not found';
                          });
                        }
                      } else {
                        throw Exception('Failed to load HTML content');
                      }
                    } catch (error) {
                      setState(() {
                        extractedContent = 'Error: $error';
                      });
                    }
                  }
                  fetchData();




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
            ..loadRequest(Uri.parse(qrcode));




// JavaScript function to be called when the data is received.

// JavaScript function to be called when the data is received.

// JavaScript function to be called when the data is received.



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

        } else if(qrcode is int){
          searchProduct(qrcode);
        }
        else{
          showDialog(
              context: context,
              builder: (BuildContext context) {
                return AlertDialog(
                  title: const Text('Alert'),
                  content: const Text('unfortunately our app couldnt recognize the app'),
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
      else{
        showDialog(
            context: context,
            builder: (BuildContext context) {
              return AlertDialog(
                title: const Text('Alert'),
                content: const Text('sorry unfortunately our app couldnt recognize the image uploaded'),
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
      body:Column(
        children: [

          SizedBox(height: 20,),
          Image.asset('assets/icons/20230818_155426.jpg',width: 150,
            height: 150,),
          SizedBox(height: 20,),
          Center(
            child: TextField(
              controller: _textEditingController,
              enabled: false,
              decoration: InputDecoration(
                labelText: 'Image Name',
              ),
            ),
          ),

          Center(
            child: ElevatedButton(
              style: ElevatedButton.styleFrom(
                foregroundColor: Colors.white,
                backgroundColor: Colors.green[700],
              ),
              onPressed: (){

                getImage();

              },
              child: const Text('Upload QR|Barcode',style: TextStyle(fontSize: 18),),

            ),


          ),
          Center(
            child: ElevatedButton(
                style: ElevatedButton.styleFrom(
                  foregroundColor: Colors.white,
                  backgroundColor: Colors.green[700],
                ),
                onPressed: (){

              if(selectedImagePath != null){
                scanImport(selectedImagePath!);
              }
              else{
                showDialog(
                    context: context,
                    builder: (BuildContext context) {
                      return AlertDialog(
                        title: const Text('Alert'),
                        content: const Text('Please upload the image of the QR or BARCODE'),
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

              };
            }, child: Text('Scan Now',style: TextStyle(fontSize: 18),)),
          )
        ],
      ),


    ) ;
  }
}
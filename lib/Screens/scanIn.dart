// ignore_for_file: camel_case_types, file_names, use_build_context_synchronously

import 'dart:convert';
import 'package:flutter/widgets.dart';
import 'package:connectivity/connectivity.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_phone_direct_caller/flutter_phone_direct_caller.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:image_picker/image_picker.dart';
//import 'package:go_router/go_router.dart';
import 'package:scancode/GeneralNav.dart';
import 'package:file/file.dart';
import 'package:path/path.dart';
import 'package:uri_to_file/uri_to_file.dart';
import 'package:scan/scan.dart';
import 'dart:async';
import 'package:http/http.dart' as http;
import 'package:html/parser.dart' as htmlParser;
import 'package:url_launcher/url_launcher.dart';

import 'package:webview_flutter/webview_flutter.dart';


class scanIn extends StatefulWidget{
  const scanIn({super.key});

  @override
  State<scanIn> createState() => _scanInState();
}



class _scanInState extends State<scanIn> {
  var dataRec;


  Connectivity _connectivity = Connectivity();
  bool _isConnected = true;
  String _platformVersion = 'Unknown';
  var qrcode ;
  bool isLoading=true;
  var file;
  var details;
  var scanResult;
  String title='e-Viwango';
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
            var image = productData2['product_image'];

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
                                onPressed:(){
                                  var identity=productData2['identity'];
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
                                          print(request.url);
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
                },
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


        if(qrcode != '-1'){
          if (qrcode.toString().contains('http')) {
          if(qrcode.toString().contains('music')){
            title='e-Music';
          }
          else{
            title='e-Viwango';
          }


           WebViewController controller = WebViewController()

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



                },
                onWebResourceError: (WebResourceError error) {},
                onNavigationRequest: (NavigationRequest request) {
                  if (request.url.contains('whatsapp')) {
                    launch(request.url);
                    return NavigationDecision.navigate;
                  }
                  else if(request.url.contains('tel')){
                    FlutterPhoneDirectCaller.callNumber(request.url);
                    return NavigationDecision.prevent;
                  }
                  return NavigationDecision.navigate;
                },
              ),
            )
            ..loadRequest(Uri.parse(qrcode));






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
                  body:  Column(
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

        } else{

          searchProduct(qrcode);
        }}
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
                title: Row(
                  children: [
                    const Icon(Icons.warning,size: 15,),
                    SizedBox(width: 5,),
                    Text('Alert'),

                  ],
                ),
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
          Container(
            width: 350,
            child:
              Center(
                child: TextField(
                  controller: _textEditingController,
                  enabled: false,
                  decoration: InputDecoration(
                    labelText: 'Image Name',
                  ),
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
                        title: Row(
                          children: [
                            const Icon(Icons.warning,size: 15,),
                            SizedBox(width: 5,),
                            Text('Alert'),

                          ],
                        ),
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
              setState(() {

              });
            }, child: Text('Scan Now',style: TextStyle(fontSize: 18),)),
          )
        ],
      ),


    ) ;
  }
}
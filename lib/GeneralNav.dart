// ignore_for_file: library_private_types_in_public_api

import 'package:connectivity/connectivity.dart';
import 'package:flutter/material.dart';
import 'package:flutter_barcode_scanner/flutter_barcode_scanner.dart';
import 'package:go_router/go_router.dart';
import 'package:share/share.dart';
import 'package:webview_flutter/webview_flutter.dart';
import 'package:url_launcher/url_launcher.dart';
class GeneralNav extends StatefulWidget {
   const GeneralNav({
    required this.child,
    super.key


  });

  /// The widget to display in the body of the Scaffold.
  /// In this sample, it is a Navigator.
  final Widget child;


  @override
  State<GeneralNav> createState() => _GeneralNavState();


  static int _calculateSelectedIndex(BuildContext context) {
    final String location = GoRouterState.of(context).uri.toString();
    if (location.startsWith('/e-Kurasa')) {
      return 0;
    }
    if (location.startsWith('/eMusic')) {
      return 1;
    }

    if (location.startsWith('/scanIn')) {
      return 2;
    }

    return 0;
  }
}

class _GeneralNavState extends State<GeneralNav> {

  late final WebViewController controller;

  Widget build(BuildContext context) {

    return Scaffold(

      body: widget.child,

      bottomNavigationBar :BottomNavigationBar(
        selectedItemColor: Colors.green[700],
        unselectedItemColor: Colors.white,
        showSelectedLabels: true,
        showUnselectedLabels: true,
        type: BottomNavigationBarType.fixed,
        backgroundColor: Colors.black,
        elevation: 2,
        iconSize: 30.0,
        selectedFontSize: 15.0,
        unselectedFontSize: 10.0,
        selectedLabelStyle: const TextStyle(fontWeight: FontWeight.w600),
        unselectedLabelStyle: const TextStyle(fontWeight: FontWeight.w400),

        items:
        const [
          BottomNavigationBarItem(
            icon: ImageIcon(AssetImage("assets/icons/qr-code.png"),),
            label: "e-Viwango",
            //onTap:() => context.go('/HomePage'),
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.shopping_cart),
            label: 'eMarket',
            //onTap:() => context.go('/TeamsPage'),
          ),

          BottomNavigationBarItem(

            icon: ImageIcon(AssetImage("assets/icons/upload.png"),),
            label: 'ScanIn',
          ),

        ],
        currentIndex: GeneralNav._calculateSelectedIndex(context),
        onTap: (int idx) => _onItemTapped(idx, context),

      ),
    );
  }

  void _onItemTapped(int index, BuildContext context) {
    switch (index) {
      case 0:
        GoRouter.of(context).go('/e-Kurasa');
        break;
      case 1:
        GoRouter.of(context).go('/eMusic');
        break;

      case 2:
        GoRouter.of(context).go('/scanIn');
        break;

    }


  }
}
class MyAnimatedDrawer extends StatefulWidget {
  const MyAnimatedDrawer({super.key});

  @override
  _MyAnimatedDrawerState createState() => _MyAnimatedDrawerState();
}

class _MyAnimatedDrawerState extends State<MyAnimatedDrawer> {
  @override

  Widget build(BuildContext context) {
    return Drawer(
      backgroundColor: Colors.black,

      child: ListView(
        children: [
          Container(
            height: 300,
            child: DrawerHeader(

              decoration: BoxDecoration(
                color: Colors.green[700],

                image:const DecorationImage(image: AssetImage('assets/icons/20230818_155426.jpg'),fit: BoxFit.fill,)

    ),
              child: const Text(
                '',
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 24,
                ),
              ),

            ),
          ),
          ListTile(
            title: const Text('Share', style: TextStyle(color: Colors.white,fontSize: 18),),
            leading: Icon(Icons.share_outlined,color: Colors.green[700]),
            onTap: () {
              // Handle link 1 tap
              _shareText('https://play.google.com/store/apps/details?id=com.scancodetz.scancode');
            },
          ),
          ListTile(
            title: const Text('About Us', style: TextStyle(color: Colors.white,fontSize: 18),),
            leading: Icon(Icons.bookmarks_outlined,color: Colors.green[700]),
            onTap: () {
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
                            Text('ScanCode'),
                          ],
                        ),

                        backgroundColor: Colors.black,
                        foregroundColor: Colors.white,
                      ),
                      body:SingleChildScrollView(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            SizedBox(height: 10,),
                            Container(
                                padding: EdgeInsets.only(left: 10),
                                child: Text('About ScanCode Tanzania',style: TextStyle(fontWeight: FontWeight.bold,fontSize: 25,color: Colors.green[700]),)),
                            Container(
                              padding: EdgeInsets.all( 10),
                              child: Text('We are an ICT company embarking on consumer products verification and authentic data accessibility through mobile devices '
                                  '. Scancode (T) Limited established in 2014 owned by young innovative Tanzanian vetted by commission of Science and Technology (COSTECH)',style: TextStyle(fontSize: 15,),textAlign: TextAlign.justify),
                            ),
                            Container(
                              padding: EdgeInsets.all( 10),
                              child: Text('We have developed a mobile platform that empowers consumers to verify product authenticity through scanning barcodes and Qrcodes using '
                                  'their smartphones. the mobile platform enables the consumer to scan both the QRcodes and Barcodes and go beyond the label to discover '
                                  'more informations about where the product comes from. How it was processed, ingredients , storage, quality and availability. And we have embeded the mobile app with emarket system where '
                                  'the entrepreneurs register their businesses and products.',style: TextStyle(fontSize: 15),textAlign: TextAlign.justify),
                            ),Container(
                              padding: EdgeInsets.all( 10),
                              child: Text('Data quality is particularly important when it comes to health, nutrition and  product safety issues. In this view ,COSTECH has carefully assessed'
                                  'and vetted the platform and confirmed that it meets international standards while fitting perfectly dynamics of our local environment. The platforms set to'
                                  'address a pertinent challenge of counterfeit products in our Tanzanian market.',style: TextStyle(fontSize: 15),textAlign: TextAlign.justify),
                            ),
                            Container(
                              padding: EdgeInsets.all( 10),
                              child: Text('The platform improves the government capability of protecting consumers from using counterfeit \'fake\' products especially for medicine or drugs , cosmetics'
                                  'and food stuffs meanwhile reduces products fraud in the market. Hence maintains consumers confidence and healthy living.',style: TextStyle(fontSize: 15),textAlign: TextAlign.justify),
                            ),
                            Container(
                              padding: EdgeInsets.all( 10),
                              child: Text('We are calling on all manufacturers and stakeholders to get involved in using the platform to create '
                                  'deeper brand relationships, grow product market share with brands strengths and visibility.',style: TextStyle(fontSize: 15),textAlign: TextAlign.justify),
                            ),
                            Container(
                              padding: EdgeInsets.all( 10),
                              child: Text('Our Vision',style: TextStyle(fontSize: 20,fontWeight: FontWeight.bold,color: Colors.green[700]),),
                            ), Container(
                              padding: EdgeInsets.all( 10),
                              child: Text('To become a trusted source of data by providing accurate information about products as a critical part of building trust with consumers and enterprises'
                                  'while combating counterfeit and product fraud in the market.',style: TextStyle(fontSize: 15,),textAlign: TextAlign.justify),
                            ), Container(
                              padding: EdgeInsets.all( 10),
                              child: Text('Our Mission',style: TextStyle(fontSize: 20,fontWeight: FontWeight.bold,color: Colors.green[700]),),
                            ),
                              Container(
                                padding: EdgeInsets.all( 10),
                                child: Text('To innovate friendly, provide industry with a significant opportunity to influence consumer behaviour, deliver desirable brand positioning in the marhet place '
                                    'and demonstrate good corporate responsibility',style: TextStyle(fontSize: 15,),textAlign: TextAlign.justify),
                              ),
                            Container(
                              padding: EdgeInsets.all( 10),
                              child: Text('Contact Us',style: TextStyle(fontSize: 20,fontWeight: FontWeight.bold,color: Colors.green[700]),),
                            ),
                            Container(
                              padding: EdgeInsets.all( 10),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text('We are at COSTECH (Tume ya Taifa ya Sayansi na Technolojia) 3rd Floor',style: TextStyle(fontSize: 15,),),
                                  SizedBox(height: 5,),
                                  Text('Kijitonyama Ali Hassan Mwinyi Road,Dar Es Salaam Tanzania',style: TextStyle(fontSize: 15,),),
                                  SizedBox(height: 5,),
                                  Text('Mobile:+255718173700',style: TextStyle(fontSize: 15,),),
                                  SizedBox(height: 5,),
                                  Text('Email:mgimbamr@gmail.com , info@scancodetz.com, ceo@scancodetz.com',style: TextStyle(fontSize: 15,),),

                                ],
                              ),
                            ),
                            Container(
                                padding: EdgeInsets.only(left: 10),
                                child: GestureDetector(onTap:(){ launch('https://scancode.co.tz/');},
                                  child: Text('Visit Our Website.',style: TextStyle(fontWeight: FontWeight.bold,fontSize: 25,color: Colors.green[700]),),

                                )
                            ),

                          ],

                        ),
                      ),
                    );
                  },
                ),
              );

              // Handle link 1 tap
            },
          ),
          ListTile(
            title: const Text('Terms of use', style: TextStyle(color: Colors.white,fontSize: 18),),
            leading: Icon(Icons.rule_sharp,color: Colors.green[700]),
            onTap: () {
              // Handle link 2 tap
            },
          ),
          ListTile(
            title: const Text('App Version', style: TextStyle(color: Colors.white,fontSize: 18),),
            leading: Icon(Icons.app_settings_alt,color: Colors.green[700]),
            onTap: () {
              showDialog(
                  context: context,
                  builder: (BuildContext context) {
                    return AlertDialog(
                      title: Row(
                        children: [
                          Icon(Icons.sim_card_alert,color: Colors.green[700]),
                          const Text('App Info'),
                        ],
                      ),
                      content: const Text(
                          '''ScanCode Viwango
                          
Version 2.6

Offered By : ScanCode Tanzania.
                             '''),
                      actions: [
                        TextButton(
                          onPressed: () {
                            Navigator.of(context)
                                .pop(); // Close the AlertDialog
                          },
                          child: const Text('Close',style: TextStyle(color: Colors.green),),
                        ),
                      ],
                    );
                  });
              // Handle link 1 tap
            },
          ),
          // Add more ListTile widgets for additional links
        ],
      ),
    );
  }
}
void _shareText(String textToShare) {
  try {
    Share.share(textToShare, subject: 'ScanCode Viwango');
  } catch (e) {
    print('Error sharing: $e');

  }
}



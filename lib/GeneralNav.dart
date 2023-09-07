// ignore_for_file: library_private_types_in_public_api

import 'package:connectivity/connectivity.dart';
import 'package:flutter/material.dart';
import 'package:flutter_barcode_scanner/flutter_barcode_scanner.dart';
import 'package:go_router/go_router.dart';
import 'package:share/share.dart';
import 'package:webview_flutter/webview_flutter.dart';
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
            icon: Icon(Icons.library_music),
            label: 'e-Music',
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
              // Handle link 1 tap
            },
          ),
          // ListTile(
          //   title: const Text('Settings', style: TextStyle(color: Colors.white,fontSize: 18),),
          //   leading: Icon(Icons.settings,color: Colors.green[700]),
          //   onTap: () {
          //     // Handle link 1 tap
          //   },
          // ),
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
    Share.share(textToShare, subject: 'Sharing Example');
  } catch (e) {
    print('Error sharing: $e');

  }
}


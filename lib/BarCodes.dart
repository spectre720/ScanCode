// import 'dart:convert';
//
// import 'package:flutter/cupertino.dart';
// import 'package:flutter/material.dart';
// import 'package:fluttertoast/fluttertoast.dart';
// import 'package:http/http.dart' as http;
// class BarcodeSearchScreen extends StatelessWidget {
//   final TextEditingController barcodeController = TextEditingController();
//
//   BarcodeSearchScreen({super.key});
//
//  Future<String?> searchProduct(String Data) async {
//     final barcode =Data;
//
//
//
//     final response = await http.get(
//       Uri.parse('http://192.168.43.29/API/search_by_barcode.php?barcode=$barcode'),
//     );
//
//
//
//     print('Hello juan');
//     if (response.statusCode == 200) {
//       print('${response.statusCode} hello');
//       final productData = json.decode(response.body);
//       var image=productData['Picture'];
//
//       return Navigator.push(
//         context as BuildContext,
//         MaterialPageRoute(
//           builder: (context) {
//             return Scaffold(
//               appBar: AppBar(
//                 title: Row(
//                   children: [
//                     Image.asset(
//                       'assets/icons/Screenshot_20230815-234221_ScanCode.jpg',
//                       width: 25,
//                       height: 25,
//                     ),
//                     const SizedBox(width: 8,),
//                     const Text('e-Kurasa'),
//                   ],
//                 ),
//                 backgroundColor: Colors.black,
//                 foregroundColor: Colors.white,
//
//               ),
//
//               body: Center(child: Column(
//                 children: [
//                   const SizedBox(height: 12,),
//                   Center(
//
//                     child: Image.network(
//                       'http://192.168.43.29/$image',
//                       width: 200,
//                       height: 200,
//                       fit: BoxFit.cover,
//                     ),
//                   ),
//
//                   DataTable(
//                       columns: const [
//                         DataColumn(
//                           label: Text('DETAIL',style: TextStyle(fontWeight: FontWeight.bold,fontSize: 15)),
//                         ),
//                         DataColumn(
//                           label: Text('DESCRIPTION',style: TextStyle(fontWeight: FontWeight.bold,fontSize: 15)),
//                         ),
//
//                       ],
//                       rows: [
//
//                         DataRow(cells: [
//                           const DataCell(Text('Product Name:',style: TextStyle(fontWeight: FontWeight.bold,fontSize: 15),)),
//                           DataCell(Text(productData['PName'],style: TextStyle(fontSize: 15),)),
//
//                         ]),
//                         DataRow(cells: [
//                           const DataCell(Text('Manufacturer:',style: TextStyle(fontWeight: FontWeight.bold,fontSize: 15),)),
//                           DataCell(Text(productData['Manufacturer'],style: TextStyle(fontSize: 15),)),
//
//                         ]),
//                         DataRow(cells: [
//                           const DataCell(Text('Status:',style: TextStyle(fontWeight: FontWeight.bold,fontSize: 15),)),
//                           DataCell( Row(
//                             mainAxisAlignment: MainAxisAlignment.center,
//                             children: <Widget>[
//                               Icon(Icons.check, color: Colors.green[700]),
//
//                             ],
//                           ),
//                           ),
//
//                         ]),
//
//                       ])
//                 ],
//               )),
//
//             );
//           },
//         ),
//       );
//     } else if(response.statusCode == 404) {
//
//       Fluttertoast.showToast(msg: 'sorry we couldnt find the product');
//     }
//     else if(response.statusCode == 500) {
//
//       Fluttertoast.showToast(msg: 'Internal server error please try again letter');
//     }
//     else {
//
//       Fluttertoast.showToast(msg: 'Please check your internet connection');
//     }
//     return null;
//   }
//
//
//   @override
//   Widget build(BuildContext context) {
//     // TODO: implement build
//     throw UnimplementedError();
//   }
// }
// class ProductDetailsScreen extends StatelessWidget {
//   final Map<String, dynamic> productData;
//
//   const ProductDetailsScreen(this.productData, {super.key});
//
//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(title: Text('Product Details')),
//       body: Padding(
//         padding: EdgeInsets.all(16.0),
//         child: Column(
//           crossAxisAlignment: CrossAxisAlignment.start,
//           children: [
//             Text('Name: ${productData['name']}'),
//             Text('Price: \$${productData['price']}'),
//             // Display other product details
//           ],
//         ),
//       ),
//     );
//   }
// }
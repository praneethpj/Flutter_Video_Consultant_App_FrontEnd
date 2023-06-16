// import 'dart:math';

// import 'package:flutter/material.dart';
// import 'package:flutter/scheduler.dart';
// import 'package:get/get.dart';
// import 'package:google_fonts/google_fonts.dart';
// import 'package:flutter/rendering.dart';

// class BillThanksScreen extends StatefulWidget {
//   const BillThanksScreen({super.key});

//   @override
//   State<BillThanksScreen> createState() => _BillThanksScreenState();
// }

// final paymentcontroller = Get.put(PaymentController());

// Widget skusWidget(int id, List<dynamic> sku) {
//   print("SKU ID ${id}");

//   List<dynamic> skuList = sku;

//   if (skuList.isNotEmpty) {
//     return skuList != null
//         ? Column(
//             crossAxisAlignment: CrossAxisAlignment.start,
//             mainAxisAlignment: MainAxisAlignment.start,
//             children: [
//               for (int i = 0; i < skuList.length; i++)
//                 Column(
//                   crossAxisAlignment: CrossAxisAlignment.start,
//                   mainAxisAlignment: MainAxisAlignment.start,
//                   children: [
//                     Text(
//                       "${skuList[i]['skuName']}",
//                       style:
//                           TextStyle(fontSize: 10, fontWeight: FontWeight.bold),
//                     ),
//                     Text(
//                       " - ${skuList[i]['cartItemSkuValue']['Values'].keys.first}",
//                       style: TextStyle(
//                         fontSize: 10,
//                       ),
//                     )
//                   ],
//                 )
//             ],
//           )
//         : Text("");
//   } else {
//     return Text("");
//   }
// }

// class _BillThanksScreenState extends State<BillThanksScreen> {
//   final GlobalKey<State<StatefulWidget>> _printKey = GlobalKey();
//   final cartcontroller = Get.put(CartController());

//   late GestureDetector gestureDetector;

//   List<Order> orders = [];
//   Order? orderdetails;

//   Future<Order>? getData() async {
//     // await Future.delayed(Duration(seconds: 2));
//     orders.clear();
//     //if (orderdetails != null) {
//     orderdetails = null;
// //  }
//     orders = (await RemoteServices.fetchOrders(1))!;
//     // print("element.orderId ${orders}");
//     orderdetails = orders.single;
//     for (var element in orders) {
//       //orderdetails = element;
//       // orderdetails!.orderId = element.orderId;
//       // orderdetails!.subTotal = element.subTotal;
//       // orderdetails!.orderDate = element.orderDate;
//       print("orderdetails ${element.grandOrderTotal}");
//     }

//     return orderdetails!;
//     // print("element.orderId ${orderdetails.orderId}");
//   }

//   clickButton() {
//     print("going to click refresh");
//     setState(() {});
//     getData();
//     setState(() {});
//   }

//   @override
//   Widget build(BuildContext context) {
//     gestureDetector = GestureDetector(
//       onTap: () {
//         getData();
//         setState(() {});
//       },
//       child: Container(
//         color: Colors.yellow.shade600,
//         padding: const EdgeInsets.all(8),
//         child: const Text('REFRESH'),
//       ),
//     );
//     // gestureDetector.onTap!();
//     //clickButton();
//     // Future.delayed(Duration(seconds: 1), () {

//     //   //clickButton();
//     // });
//     //WidgetsBinding.instance.addPostFrameCallback((_) => clickButton());
//     return WillPopScope(
//       onWillPop: () async => false,
//       child: Scaffold(
//         appBar: AppBar(
//           // automaticallyImplyLeading: false,
//           title: new Text("Order Details"),
//           leading: new IconButton(
//             icon: new Icon(Icons.arrow_back),
//             // onPressed: () => Navigator.of(context)
//             //     .push(MaterialPageRoute(builder: (context) => MyApp())),
//             onPressed: () {
//               cartcontroller.cart.clear();
//               orders.clear();
//               Get.offAll(MyApp());
//             },
//           ),
//         ),
//         body: SafeArea(
//           child: SingleChildScrollView(
//             child: FutureBuilder<Order>(
//                 future: getData(),
//                 builder: (context, snapshot) {
//                   if (snapshot.hasData &&
//                       snapshot.connectionState == ConnectionState.done) {
//                     return RepaintBoundary(
//                       key: _printKey,
//                       child: Container(
//                         color: Colors.white,
//                         child: Center(
//                           child: Column(
//                             crossAxisAlignment: CrossAxisAlignment.center,
//                             mainAxisAlignment: MainAxisAlignment.center,
//                             children: [
//                               //    gestureDetector,
//                               SizedBox(
//                                   width: 120,
//                                   height: 120,
//                                   child: Image.asset("assets/images/logo.png")),
//                               Text(
//                                 "Brazen Brownies",
//                                 style: TextStyle(fontWeight: FontWeight.bold),
//                               ),
//                               Text(
//                                 "141A Station St,Fairfield VIC 3078",
//                                 style: TextStyle(fontWeight: FontWeight.w400),
//                               ),
//                               Text(
//                                 "Email: yummy@brazenbrownies.com.au",
//                                 style: TextStyle(fontWeight: FontWeight.w400),
//                               ),
//                               Text(
//                                 "Phone: +41 2 662 233",
//                                 style: TextStyle(fontWeight: FontWeight.w400),
//                               ),
//                               SizedBox(
//                                 height: 20,
//                               ),
//                               Text(
//                                 "Order Received",
//                                 style: TextStyle(fontSize: 25),
//                               ),
//                               SizedBox(
//                                 height: 20,
//                               ),
//                               Text(
//                                 "Thank you. Your order has been received.",
//                                 style: TextStyle(fontSize: 15),
//                               ),
//                               SizedBox(
//                                 height: 20,
//                               ),
//                               Container(
//                                 color: Colors.white,
//                                 padding: EdgeInsets.all(8.0),
//                                 child: Table(
//                                   columnWidths: {
//                                     0: FlexColumnWidth(1),
//                                     1: FlexColumnWidth(2),
//                                     2: FlexColumnWidth(1),
//                                     3: FlexColumnWidth(2),
//                                   },
//                                   children: [
//                                     TableRow(children: [
//                                       Text(
//                                         'Order Number',
//                                         style: GoogleFonts.lato(
//                                             fontSize: 12,
//                                             fontWeight: FontWeight.bold),
//                                       ),
//                                       Text('Date',
//                                           style: GoogleFonts.lato(
//                                               fontSize: 12,
//                                               fontWeight: FontWeight.bold)),
//                                       Text('Total',
//                                           style: GoogleFonts.lato(
//                                               fontSize: 12,
//                                               fontWeight: FontWeight.bold)),
//                                       Text('Payment Method',
//                                           style: GoogleFonts.lato(
//                                               fontSize: 12,
//                                               fontWeight: FontWeight.bold)),
//                                     ]),
//                                     TableRow(children: [
//                                       Text('${snapshot.data!.orderId} ',
//                                           style:
//                                               GoogleFonts.lato(fontSize: 15)),
//                                       Text('${snapshot.data!.orderDate}'),
//                                       Text(
//                                           '\$${snapshot.data!.grandOrderTotal}'),
//                                       Text('Paypal'),
//                                     ]),
//                                   ],
//                                 ),
//                               ),
//                               SizedBox(
//                                 height: 20,
//                               ),
//                               Padding(
//                                 padding: const EdgeInsets.all(8.0),
//                                 child: Align(
//                                   alignment: Alignment.bottomLeft,
//                                   child: Text('Order Details',
//                                       style: GoogleFonts.lato(
//                                           fontSize: 18,
//                                           fontWeight: FontWeight.bold)),
//                                 ),
//                               ),
//                               Container(
//                                 color: Colors.white,
//                                 padding: EdgeInsets.all(10.0),
//                                 child: Table(
//                                   children: [
//                                     TableRow(children: [
//                                       Text(
//                                         "Order Status",
//                                         style: TextStyle(
//                                             fontSize: 15.0,
//                                             fontWeight: FontWeight.w500),
//                                       ),
//                                       Text(
//                                         "${snapshot.data!.status == 1 ? "Paid" : "Not Paid"}",
//                                         style: TextStyle(fontSize: 15.0),
//                                       ),
//                                     ]),
//                                     snapshot.data!.deliveryType == 1
//                                         ? TableRow(children: [
//                                             Text(
//                                               "Click & Collect Date",
//                                               style: TextStyle(
//                                                   fontSize: 15.0,
//                                                   fontWeight: FontWeight.w500),
//                                             ),
//                                             Text(
//                                               "${snapshot.data!.orderDate}",
//                                               style: TextStyle(fontSize: 15.0),
//                                             ),
//                                           ])
//                                         : TableRow(
//                                             children: [Text(""), Text("")]),
//                                     TableRow(children: [
//                                       Padding(
//                                         padding: const EdgeInsets.only(
//                                             top: 10, bottom: 10),
//                                         child: Text(
//                                           snapshot.data!.deliveryType == 1
//                                               ? "Click & Collect Address"
//                                               : "Delivery Location",
//                                           style: TextStyle(
//                                               fontSize: 15.0,
//                                               fontWeight: FontWeight.w500),
//                                         ),
//                                       ),
//                                       Padding(
//                                         padding: const EdgeInsets.only(
//                                             top: 10, bottom: 10),
//                                         child: Text(
//                                           snapshot.data!.deliveryType == 1
//                                               ? "${snapshot.data!.shippingAddress.address1 + ", " + snapshot.data!.shippingAddress.suburb + ", " + snapshot.data!.shippingAddress.state}"
//                                               : "${snapshot.data!.billingAddress.address1 + ", " + snapshot.data!.billingAddress.suburb + ", " + snapshot.data!.billingAddress.state}",
//                                           style: TextStyle(fontSize: 15.0),
//                                         ),
//                                       ),
//                                     ]),
//                                     TableRow(children: [
//                                       Text(
//                                         "Earned Loyalty Points",
//                                         style: TextStyle(
//                                             fontSize: 15.0,
//                                             fontWeight: FontWeight.w500),
//                                       ),
//                                       Text(
//                                         "${snapshot.data!.loyaltyPoints}",
//                                         style: TextStyle(fontSize: 15.0),
//                                       ),
//                                     ]),
//                                   ],
//                                 ),
//                               ),
//                               SizedBox(
//                                 height: 20,
//                               ),
//                               Padding(
//                                 padding: const EdgeInsets.all(8.0),
//                                 child: Align(
//                                   alignment: Alignment.bottomLeft,
//                                   child: Text('Item Details',
//                                       style: GoogleFonts.lato(
//                                           fontSize: 18,
//                                           fontWeight: FontWeight.bold)),
//                                 ),
//                               ),
//                               Container(
//                                 color: Color.fromARGB(255, 237, 236, 236),
//                                 padding: EdgeInsets.all(8.0),
//                                 child: Table(
//                                   columnWidths: {
//                                     0: FlexColumnWidth(4),
//                                     1: FlexColumnWidth(2),
//                                     2: FlexColumnWidth(2),
//                                   },
//                                   children: [
//                                     TableRow(children: [
//                                       Text(
//                                         'Product',
//                                         style: GoogleFonts.lato(
//                                             fontSize: 15,
//                                             fontWeight: FontWeight.bold),
//                                       ),
//                                       Text('Unit Price',
//                                           style: GoogleFonts.lato(
//                                               fontSize: 15,
//                                               fontWeight: FontWeight.bold)),
//                                       Text('Total',
//                                           style: GoogleFonts.lato(
//                                               fontSize: 15,
//                                               fontWeight: FontWeight.bold)),
//                                     ]),
//                                     for (var item
//                                         in snapshot.data!.orderItemList)
//                                       TableRow(children: [
//                                         Column(
//                                           crossAxisAlignment:
//                                               CrossAxisAlignment.start,
//                                           mainAxisAlignment:
//                                               MainAxisAlignment.start,
//                                           children: [
//                                             Text(
//                                                 '${item.itemName}  (\$${getValue(item.itemPrice!.toDouble())})',
//                                                 style: GoogleFonts.lato(
//                                                     fontSize: 15)),
//                                             skusWidget(item.itemId, item.sku),
//                                           ],
//                                         ),
//                                         Text(
//                                             '\$${getValue(item.itemPrice!.toDouble())}x${getValue(item.quantity!.toDouble())}'),
//                                         Text(
//                                             '\$${(getValue(item.itemPrice!.toDouble() * item.quantity))}'),
//                                       ]),
//                                   ],
//                                 ),
//                               ),
//                               SizedBox(
//                                 height: 20,
//                               ),
//                               Padding(
//                                 padding: const EdgeInsets.all(8.0),
//                                 child: Align(
//                                   alignment: Alignment.bottomLeft,
//                                   child: Text('Total Amount',
//                                       style: GoogleFonts.lato(
//                                           fontSize: 18,
//                                           fontWeight: FontWeight.bold)),
//                                 ),
//                               ),
//                               Container(
//                                 color: Colors.white,
//                                 padding: EdgeInsets.all(10.0),
//                                 child: Table(
//                                   children: [
//                                     TableRow(children: [
//                                       Text(
//                                         "Subtotal",
//                                         style: TextStyle(
//                                             fontSize: 15.0,
//                                             fontWeight: FontWeight.w500),
//                                       ),
//                                       Text(
//                                         "\$${getValue(snapshot.data!.subTotal)}",
//                                         style: TextStyle(fontSize: 15.0),
//                                       ),
//                                     ]),
//                                     TableRow(children: [
//                                       Text(
//                                         "Total without GST",
//                                         style: TextStyle(
//                                             fontSize: 15.0,
//                                             fontWeight: FontWeight.w500),
//                                       ),
//                                       Text(
//                                         "\$${getValue(snapshot.data!.subTotal / 1.1)}",
//                                         style: TextStyle(fontSize: 15.0),
//                                       ),
//                                     ]),
//                                     TableRow(children: [
//                                       Text(
//                                         "GST",
//                                         style: TextStyle(
//                                             fontSize: 15.0,
//                                             fontWeight: FontWeight.w500),
//                                       ),
//                                       Text(
//                                         "\$${getValue(snapshot.data!.subTotal / 1.1 * 0.1)}",
//                                         style: TextStyle(fontSize: 15.0),
//                                       ),
//                                     ]),
//                                     TableRow(children: [
//                                       Text(
//                                         "Total",
//                                         style: TextStyle(
//                                             fontSize: 15.0,
//                                             fontWeight: FontWeight.w500),
//                                       ),
//                                       Text(
//                                         "\$${getValue(snapshot.data!.subTotal)}",
//                                         style: TextStyle(fontSize: 15.0),
//                                       ),
//                                     ]),
//                                     TableRow(children: [
//                                       Row(
//                                         children: [
//                                           Text(
//                                             "Delivery Fee",
//                                             style: TextStyle(
//                                                 fontSize: 15.0,
//                                                 fontWeight: FontWeight.w500),
//                                           ),
//                                           SizedBox(
//                                             width: 7,
//                                           ),
//                                           Container(
//                                             child: Text(
//                                               getDeliveryTitle(
//                                                   snapshot.data!.deliveryType),
//                                               style: TextStyle(
//                                                   color: Colors.white,
//                                                   fontSize: 9),
//                                             ),
//                                             decoration: BoxDecoration(
//                                                 color: Color.fromARGB(
//                                                     255, 99, 94, 94),
//                                                 borderRadius:
//                                                     BorderRadius.circular(10)),
//                                           ),
//                                         ],
//                                       ),
//                                       Text(
//                                         "\$${getValue(snapshot.data!.deliveryCost)}",
//                                         style: TextStyle(fontSize: 15.0),
//                                       ),
//                                     ]),
//                                     TableRow(children: [
//                                       Text(
//                                         "Total with Delivery Fee",
//                                         style: TextStyle(
//                                             fontSize: 15.0,
//                                             fontWeight: FontWeight.w500),
//                                       ),
//                                       Text(
//                                         "\$${getValue(snapshot.data!.grandOrderTotal)}",
//                                         style: TextStyle(fontSize: 15.0),
//                                       ),
//                                     ]),
//                                   ],
//                                 ),
//                               ),
//                               SizedBox(
//                                 height: 50,
//                               ),
//                               SizedBox(
//                                 width: 300,
//                                 child: ElevatedButton(
//                                   onPressed: () {
//                                     _printScreen();
//                                   },
//                                   child: Text(
//                                     'Save to PDF',
//                                     style: TextStyle(color: Colors.white),
//                                   ),
//                                   style: ElevatedButton.styleFrom(
//                                       backgroundColor:
//                                           Color.fromARGB(255, 62, 62, 62)),
//                                 ),
//                               ),
//                               SizedBox(
//                                 width: 300,
//                                 child: ElevatedButton(
//                                   onPressed: () {
//                                     cartcontroller.cart.clear();
//                                     orders.clear();
//                                     Get.offAll(MyApp());
//                                   },
//                                   child: Text('Back'),
//                                   style: ElevatedButton.styleFrom(
//                                       backgroundColor: Colors.orange),
//                                 ),
//                               ),
//                             ],
//                           ),
//                         ),
//                       ),
//                     );
//                   }
//                   return SizedBox(
//                       height: MediaQuery.of(context).size.height / 1.3,
//                       child: Center(child: CircularProgressIndicator()));
//                 }),
//           ),
//         ),
//       ),
//     );
//   }

//   String getDeliveryTitle(int deliveryType) {
//     switch (deliveryType) {
//       case 1:
//         return "Click & Collect";
//         break;
//       case 2:
//         return "Door to Door";
//         break;
//       case 3:
//         return "Standard Post (3 - 5 Days)";
//         break;
//       case 3:
//         return "Express Post (2 - 3 Days)";
//         break;
//       case 4:
//         return "Priority Post (Next Day)";
//         break;
//       default:
//         return "N/A";
//     }
//   }

//   String getValue(double value) {
//     return value.toStringAsFixed(2);
//   }

//   void _printScreen() {
//     Printing.layoutPdf(onLayout: (PdfPageFormat format) async {
//       final doc = pw.Document();

//       final image = await WidgetWraper.fromKey(
//         key: _printKey,
//         pixelRatio: 2.0,
//       );

//       doc.addPage(pw.Page(
//           pageFormat: format,
//           build: (pw.Context context) {
//             return pw.Center(
//               child: pw.Expanded(
//                 child: pw.Image(image),
//               ),
//             );
//           }));

//       return doc.save();
//     });
//   }

//   // Future<void> load() async {
//   //   await getData();
//   // }

//   @override
//   void initState() {
//     // TODO: implement initState
//     super.initState();

//     paymentcontroller.skus.forEach((element) {
//       //print("element ${element.charge}");
//       print("element ${element.productId}");
//       print("element ${element.name}");
//       print("element ${element.charge}");
//     });
//     WidgetsBinding.instance.addPostFrameCallback((_) => clickButton());
//   }
// }

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:timetalk/helpers/ConvertHelper.dart';
import 'package:timetalk/middleware/user_payment_object.dart';
import 'package:timetalk/screens/common_widget/gradient_button.dart';
import 'package:timetalk/screens/parent_home_screen.dart';

class BillThanksScreen extends StatefulWidget {
  const BillThanksScreen({super.key});

  @override
  State<BillThanksScreen> createState() => _BillThanksScreenState();
}

class _BillThanksScreenState extends State<BillThanksScreen> {
  UserPaymentObject userPaymentObject = UserPaymentObject();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: SafeArea(
      child: Column(
        children: [
          Text(
            "Thank you",
            style: GoogleFonts.lato(fontSize: 20),
            textAlign: TextAlign.center,
          ),
          Text(
            "Your Appoiment Details ",
            style: GoogleFonts.lato(fontSize: 25),
          ),
          Table(
            children: [
              TableRow(
                children: [
                  Text('Time AND Date'),
                  Text('${userPaymentObject.dateval}'),
                ],
              ),
              TableRow(
                children: [
                  Text('Consultant Name'),
                  Text(
                      '${userPaymentObject.title} ${userPaymentObject.profilename}'),
                ],
              ),
              TableRow(
                children: [
                  Text('Consultant Type'),
                  Text('${userPaymentObject.profileType} '),
                ],
              ),
            ],
          ),
          Text(
            "Payment Details ",
            style: GoogleFonts.lato(fontSize: 25),
          ),
          Table(
            children: [
              TableRow(
                children: [
                  Text('Consultant Fee'),
                  Text(
                      '${ConvertHelper.toCurrencyFormat(userPaymentObject.userfee)}'),
                ],
              ),
              TableRow(
                children: [
                  Text('Goverment Tax'),
                  Text(
                      '${ConvertHelper.toCurrencyFormat(userPaymentObject.taxfee)}'),
                ],
              ),
              TableRow(
                children: [
                  Text('Platform fee'),
                  Text(
                      '${ConvertHelper.toCurrencyFormat(userPaymentObject.platformfee)} '),
                ],
              ),
              TableRow(
                children: [
                  Text('Total fees'),
                  Text(
                      '${ConvertHelper.toCurrencyFormat(userPaymentObject.userfee + userPaymentObject.taxfee + userPaymentObject.platformfee)} '),
                ],
              ),
            ],
          ),
          SizedBox(
            height: 20,
          ),
          Text("Paypal token ${userPaymentObject.paypaltoken}"),
          SizedBox(
            height: 20,
          ),
          GradientButton(
              title: "Done",
              type: GradientButtonType.PAYMENTBUTTON,
              function: () => {close()}),
        ],
      ),
    ));
  }

  close() {
    userPaymentObject.clear();
    Get.offAll(HomePage());
  }
}

import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:timetalk/screens/authentication_screen.dart';
import 'package:timetalk/screens/common_widget/gradient_button.dart';
import 'package:timetalk/screens/payment_type.dart';
import '../helpers/ConvertHelper.dart';
import '../middleware/user_payment_object.dart';
import 'PaypalPayment.dart';

class MakePaymentScreen extends StatefulWidget {
  final double costperhour;
  final String name;
  final String bookeddate;
  final int profileId;
  final String profileType;
  final String title;

  const MakePaymentScreen(
      {required this.name,
      required this.costperhour,
      required this.bookeddate,
      required this.profileId,
      required this.profileType,
      required this.title});
  @override
  _MakePaymentState createState() => _MakePaymentState();
}

class _MakePaymentState extends State<MakePaymentScreen> {
  TextStyle style = TextStyle(fontFamily: 'Open Sans', fontSize: 15.0);
  final GlobalKey<ScaffoldState> _scaffoldKey = new GlobalKey<ScaffoldState>();
  final box = GetStorage();

  UserPaymentObject userPaymentObject = UserPaymentObject();

  @override
  void initState() {
    super.initState();
    userPaymentObject.taxfee = 0.5;
    userPaymentObject.platformfee = 0.2;
  }

  @override
  Widget build(BuildContext context) {
    var _width = MediaQuery.of(context).size.width;
    String? auth = box.read('jwt');
    return MaterialApp(
        debugShowCheckedModeBanner: false,
        home: Scaffold(
          backgroundColor: Colors.white,
          key: _scaffoldKey,
          appBar: PreferredSize(
            preferredSize: Size.fromHeight(45.0),
            child: new AppBar(
              backgroundColor: Colors.purple,
              leading: BackButton(
                color: Colors.white,
                onPressed: () {
                  Get.back();
                },
              ),
              title: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [Text("Order checkout")],
              ),
            ),
          ),
          body: Container(
              width: MediaQuery.of(context).size.width,
              child: Container(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: <Widget>[
                    Image.asset('assets/images/3.png'),
                    Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Row(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        mainAxisAlignment: MainAxisAlignment.spaceAround,
                        children: [
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                "Profession Type",
                                style: TextStyle(fontWeight: FontWeight.bold),
                              ),
                              SizedBox(
                                height: 10,
                              ),
                              Text(
                                "${userPaymentObject.profileType}",
                                style: TextStyle(fontWeight: FontWeight.normal),
                              ),
                            ],
                          ),
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                "Consultant Name",
                                style: TextStyle(fontWeight: FontWeight.bold),
                              ),
                              SizedBox(
                                height: 10,
                              ),
                              Text(
                                "${userPaymentObject.title}. ${userPaymentObject.profilename}",
                                style: TextStyle(fontWeight: FontWeight.normal),
                              ),
                            ],
                          ),
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                "Total Fees",
                                style: TextStyle(fontWeight: FontWeight.bold),
                              ),
                              SizedBox(
                                height: 10,
                              ),
                              Text(
                                "\$${ConvertHelper.toCurrencyFormat(userPaymentObject.userfee + userPaymentObject.taxfee + userPaymentObject.platformfee)}",
                                style: TextStyle(fontWeight: FontWeight.normal),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                    SizedBox(
                      height: 20,
                    ),
                    SizedBox(
                      width: _width - 50,
                      child: Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text("Platform fee"),
                            Text("\$${userPaymentObject.platformfee}")
                          ],
                        ),
                      ),
                    ),
                    SizedBox(
                      width: _width - 50,
                      child: Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text("Goverment Tax"),
                            Text("\$${userPaymentObject.taxfee}")
                          ],
                        ),
                      ),
                    ),
                    SizedBox(
                      width: _width - 50,
                      child: Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text("Consultant Fee"),
                            Text("\$${userPaymentObject.userfee}")
                          ],
                        ),
                      ),
                    ),
                    Row(
                      children: [
                        Container(
                          height: 50,
                          margin: const EdgeInsets.all(10),
                          child: GradientButton(
                              title: "Back",
                              type: GradientButtonType.PAYMENTBUTTON,
                              function: () => {Navigator.of(context).pop()}),
                        ),
                        Container(
                          height: 50,
                          margin: const EdgeInsets.all(10),
                          child: GradientButton(
                              title: "Checkout",
                              type: GradientButtonType.PAYMENTBUTTON,
                              function: () => {
                                    auth == null
                                        ? Get.to(
                                            AuthenticationScreen(
                                                isPaymentProcess: true),
                                            transition: Transition.topLevel)
                                        : Navigator.of(context).push(
                                            MaterialPageRoute(
                                                builder: (context) =>
                                                    PaymentType(
                                                      productText: widget.name,
                                                      totalCost:
                                                          widget.costperhour,
                                                    )))
                                  }),
                        ),
                      ],
                    ),
                  ],
                ),
              )),
        ));
  }
}

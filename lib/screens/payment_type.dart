import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter_paypal/flutter_paypal.dart';
import 'package:get/get.dart';
import 'package:timetalk/constants/AlertType.dart';
import 'package:timetalk/helpers/ConvertHelper.dart';
import 'package:timetalk/middleware/user_payment_object.dart';
import 'package:timetalk/models/alert_model.dart';
import 'package:timetalk/models/book_professional_model.dart';
import 'package:timetalk/screens/bill_thanks_screen.dart';
import 'package:timetalk/screens/common_widget/gradient_button.dart';
import 'package:timetalk/services/payment_service.dart';
import 'package:url_launcher/url_launcher.dart';
import '../constants/ApiConstants.dart';
import '../middleware/HomePageController.dart';
import 'PaypalPayment.dart';

class PaymentType extends StatefulWidget {
  final dynamic totalCost;
  final String productText;

  PaymentType({required this.productText, required this.totalCost});
  @override
  _MakePaymentState createState() => _MakePaymentState();
}

class _MakePaymentState extends State<PaymentType> {
  TextStyle style = TextStyle(fontFamily: 'Open Sans', fontSize: 15.0);
  UserPaymentObject userPaymentObject = UserPaymentObject();
  HomePageController controller = Get.find<HomePageController>();
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();
  bool isReadAgreement = false;
  String totalcost = "";
  @override
  Widget build(BuildContext context) {
    var _width = MediaQuery.of(context).size.width;
    var _height = MediaQuery.of(context).size.height;

    totalcost = ConvertHelper.toCurrencyFormat(userPaymentObject.platformfee +
        userPaymentObject.taxfee +
        userPaymentObject.userfee);
    return MaterialApp(
        debugShowCheckedModeBanner: false,
        home: Scaffold(
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
                children: [Text("Select Payment Method")],
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
                    Image.asset('assets/images/4.png'),
                    RichText(
                        text: TextSpan(children: [
                      TextSpan(
                        text:
                            "Your personal data will be used to process your order, support your experience throughout this website, and for other purposes described in our",
                        style: TextStyle(color: Colors.black),
                      ),
                      TextSpan(
                          text: " privacy policy",
                          style: TextStyle(color: Colors.orange),
                          recognizer: TapGestureRecognizer()
                            ..onTap = () async {
                              final url = 'https://pp/privacy-policy';
                              if (await canLaunch(url)) {
                                await launch(
                                  url,
                                  forceSafariVC: false,
                                );
                              }
                            }),
                    ])),
                    SizedBox(
                      height: 100,
                      child: Row(
                        children: [
                          Checkbox(
                            value: isReadAgreement,
                            onChanged: (value) {
                              setState(() {
                                isReadAgreement = !isReadAgreement;
                              });
                            },
                          ),
                          Text(
                              "I have read and agreed to the website \n Terms & Conditions")
                        ],
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.only(
                          left: 20, right: 20, bottom: 20),
                      child: SizedBox(
                        width: double.infinity,
                        height: _height / 20,
                        child: ElevatedButton(
                          style:
                              ElevatedButton.styleFrom(primary: Colors.purple),
                          onPressed: isReadAgreement
                              ? () {
                                  // make PayPal payment
                                  Navigator.of(context).push(MaterialPageRoute(
                                      builder: (BuildContext context) =>
                                          UsePaypal(
                                              sandboxMode: true,
                                              clientId:
                                                  ApiConstants.paypalClientId,
                                              secretKey:
                                                  "EOiNu_AV-yKoTTW57N-xm_f-fyumrLRogfwJAB6EGprx0d4fUoENFkBASKBN7EOtgHMnlyoA7YJkBfqA",
                                              returnURL:
                                                  "https://samplesite.com/return",
                                              cancelURL:
                                                  "https://samplesite.com/cancel",
                                              transactions: [
                                                {
                                                  "amount": {
                                                    "total": totalcost,
                                                    "currency": "USD",
                                                    "details": {
                                                      "subtotal": totalcost,
                                                      "shipping": 0,
                                                      "shipping_discount": 0
                                                    }
                                                  },
                                                  "description":
                                                      "The payment transaction description.",
                                                  // "payment_options": {
                                                  //   "allowed_payment_method":
                                                  //       "INSTANT_FUNDING_SOURCE"
                                                  // },
                                                  "item_list": {
                                                    "items": [
                                                      {
                                                        "name": userPaymentObject
                                                                .profileType +
                                                            " " +
                                                            userPaymentObject
                                                                .profilename,
                                                        "quantity": 1,
                                                        "price": totalcost,
                                                        "currency": "USD"
                                                      }
                                                    ],

                                                    // shipping address is not required though
                                                    // "shipping_address": {
                                                    //   "line1":
                                                    //       "No 03, Banglow rd, Metiyagane",
                                                    //   "line2": "",
                                                    //   "city": "Metiyagane",
                                                    //   "country_code": "LK",
                                                    //   "postal_code": "60121",
                                                    //   "phone": "+000000000",
                                                    //   "state": "Metiyagane"
                                                    // },
                                                  }
                                                }
                                              ],
                                              note:
                                                  "Contact us for any questions on your order.",
                                              onSuccess: (Map params) async {
                                                print("onSuccess: $params");
                                                var token =
                                                    params['data']['cart'];
                                                print("token ${token}");
                                                addPayment(token);
                                                // cartcontroller.cart.clear();
                                                // Navigator.of(context).push(
                                                //     MaterialPageRoute(
                                                //         builder: (context) =>
                                                //             BillThanksScreen()));
                                                print("BILL THANKS");
                                                // Get.to(() => BillThanksScreen());
                                                // Get.to(() => BillThanksScreen());
                                                // Get.to(() => BillThanksScreen());

                                                // Navigator.of(context).push(
                                                //     MaterialPageRoute(
                                                //         builder: (context) =>
                                                //             BillThanksScreen()));
                                              },
                                              onError: (error) {
                                                print("onError: $error");
                                              },
                                              onCancel: (params) {
                                                print('cancelled: $params');
                                              })));
                                  // Navigator.of(context).push(
                                  //   MaterialPageRoute(
                                  //     builder: (BuildContext context) =>
                                  //         PaypalPayment(
                                  //       onFinish: (number) async {
                                  //         // payment done
                                  //         print('order id: ' + number);
                                  //       },
                                  //     ),
                                  //   ),
                                  // );
                                }
                              : null,
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Icon(
                                Icons.paypal,
                              ),
                              SizedBox(
                                width: 10,
                              ),
                              Text(
                                'Pay with Paypal',
                                textAlign: TextAlign.center,
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.only(left: 20, right: 20),
                      child: SizedBox(
                        width: double.infinity,
                        height: _height / 20,
                        child: ElevatedButton(
                          style: ElevatedButton.styleFrom(
                              primary: Color.fromARGB(255, 52, 51, 51)),
                          onPressed: isReadAgreement
                              ? () {
                                  // make PayPal payment

                                  // Navigator.of(context).push(
                                  //   MaterialPageRoute(
                                  //     builder: (BuildContext context) =>
                                  //         PaypalPayment(
                                  //       onFinish: (number) async {
                                  //         // payment done
                                  //         print('order id: ' + number);
                                  //       },
                                  //     ),
                                  //   ),
                                  // );
                                }
                              : null,
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Icon(
                                Icons.payment,
                              ),
                              SizedBox(
                                width: 10,
                              ),
                              Text(
                                'Pay with Card',
                                textAlign: TextAlign.center,
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              )),
        ));
  }

  Future<void> addPayment(token) async {
    PaymentService paymentService = PaymentService();

    BookProfessionalModel bookProfessionalModel =
        await paymentService.bookaprofessional(
            userPaymentObject.profileId,
            userPaymentObject.scheduleId,
            userPaymentObject.dateval,
            userPaymentObject.time,
            userPaymentObject.realdate,
            token,
            userPaymentObject.platformfee,
            userPaymentObject.userfee,
            userPaymentObject.taxfee,
            totalcost);

    Get.to(BillThanksScreen());
    Get.snackbar('Updated', 'You have been Successfully book a appoinment',
        titleText: Text("Messages"),
        duration: Duration(seconds: 5),
        backgroundColor: Colors.black38,
        colorText: Colors.white);

    controller.addNewNotficiation(AlertModel(
        id: 0,
        alertType: AlertType.newappoinment,
        title: "Updated",
        message: "You have been Successfully book a appoinment",
        datetime: DateTime.now().toString()));
  }
}

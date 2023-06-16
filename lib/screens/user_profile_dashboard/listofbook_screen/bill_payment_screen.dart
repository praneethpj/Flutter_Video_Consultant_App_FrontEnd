import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:timetalk/helpers/ConvertHelper.dart';
import 'package:timetalk/middleware/user_payment_object.dart';
import 'package:timetalk/models/payment.dart';
import 'package:timetalk/screens/common_widget/gradient_button.dart';
import 'package:timetalk/screens/parent_home_screen.dart';

import '../../../services/payment_service.dart';

class BillPaymentScreen extends StatefulWidget {
  final String paymentId;
  BillPaymentScreen({super.key, required this.paymentId});

  @override
  State<BillPaymentScreen> createState() => _BillPaymentScreenState();
}

class _BillPaymentScreenState extends State<BillPaymentScreen> {
  PaymentService paymentservice = PaymentService();
  @override
  void initState() {
    super.initState();
    paymentservice.getPaymentsById(widget.paymentId);
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: FutureBuilder<Payment>(
        future: paymentservice.getPaymentsById(widget.paymentId),
        builder: (context, snapshot) {
          if (snapshot.hasData &&
              ConnectionState.done == snapshot.connectionState) {
            return Column(
              children: [
                Text(
                  "Payment Details ",
                  style: GoogleFonts.lato(fontSize: 18),
                ),
                SizedBox(
                  height: 10,
                ),
                Table(
                  children: [
                    TableRow(
                      children: [
                        Text('Appoinment Schedule'),
                        Text(
                          '${snapshot.data!.dateval.toString().split(" ")[0]}  @ ${snapshot.data!.time}',
                          style: GoogleFonts.lato(
                              backgroundColor: Colors.black26, fontSize: 15),
                        ),
                      ],
                    ),
                    TableRow(
                      children: [
                        Text('Payment made '),
                        Text(
                          '${snapshot.data!.createdAt}',
                          style: GoogleFonts.lato(),
                        ),
                      ],
                    ),
                    TableRow(
                      children: [
                        Text('Consultant Fee'),
                        Text(
                          '${ConvertHelper.formatPrice(double.parse(snapshot.data!.userfee.toString()))}',
                          style: GoogleFonts.lato(),
                        ),
                      ],
                    ),
                    TableRow(
                      children: [
                        Text('Goverment Tax'),
                        Text(
                          '${ConvertHelper.formatPrice(snapshot.data!.taxfee)}',
                          style: GoogleFonts.lato(),
                        ),
                      ],
                    ),
                    TableRow(
                      children: [
                        Text('Platform fee'),
                        Text(
                          '${ConvertHelper.formatPrice(snapshot.data!.totalfee)}',
                          style: GoogleFonts.lato(),
                        ),
                      ],
                    ),
                    TableRow(
                      children: [
                        Text('Total fees'),
                        Text(
                          '${ConvertHelper.formatPrice(snapshot.data!.totalfee)}',
                          style: GoogleFonts.lato(fontWeight: FontWeight.bold),
                        ),
                      ],
                    ),
                    TableRow(
                      children: [
                        Text('Payment Status'),
                        Text(
                          '${snapshot.data!.paymentstatus == 0 ? "Done" : "Pending"}',
                          style: GoogleFonts.lato(fontWeight: FontWeight.bold),
                        ),
                      ],
                    ),
                  ],
                ),
              ],
            );
          } else {
            return CircularProgressIndicator();
          }
        },
      ),
    );
  }

  close() {
    // userPaymentObject.clear();
    Get.back();
  }
}

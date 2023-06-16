import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:timetalk/models/appointed_call_model.dart';
import 'package:timetalk/screens/user_profile_dashboard/listofbook_screen/bill_payment_screen.dart';
import 'package:timetalk/services/call_services.dart';

class ListOfBookScreen extends StatefulWidget {
  const ListOfBookScreen({super.key});

  @override
  State<ListOfBookScreen> createState() => _ListOfBookScreenState();
}

class _ListOfBookScreenState extends State<ListOfBookScreen>
    with SingleTickerProviderStateMixin {
  late TabController _tabController;
  CallService callService = CallService();
  var selectedColor;
  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 2, vsync: this);
    callService.getUpcomingCalls();
  }

  void _showBottomSheet(BuildContext context, String paymentid) {
    showModalBottomSheet(
      context: context,
      builder: (BuildContext context) {
        return Container(
          height: 200.0,
          child: Center(
            child: BillPaymentScreen(paymentId: paymentid),
          ),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        bottom: TabBar(
          controller: _tabController,
          tabs: [
            Tab(text: 'Upcomig Calls'),
            Tab(text: 'Call History'),
          ],
        ),
      ),
      body: TabBarView(
        controller: _tabController,
        children: [
          FutureBuilder<List<AppointedCallModel>>(
            future: callService.getUpcomingCalls(),
            builder: (BuildContext context,
                AsyncSnapshot<List<AppointedCallModel>> snapshot) {
              if (snapshot.connectionState == ConnectionState.waiting) {
                return Center(child: CircularProgressIndicator());
              }
              if (snapshot.hasError) {
                return Text('Error: ${snapshot.error}');
              }

              List<Widget> callWidgets = snapshot.data!
                  .map((call) => GestureDetector(
                        onTap: () {
                          _showBottomSheet(context, call.paymentId);
                        },
                        child: ListTile(
                          leading: Icon(
                              CupertinoIcons.arrowtriangle_right_square_fill),
                          title:
                              Text("New Call with ${call.title.split(",")[2]}"),
                          subtitle: Text(call.calldate.toString()),
                          selectedColor: Colors.blue,
                        ),
                      ))
                  .toList();
              return ListView(children: callWidgets);
            },
          ),
          FutureBuilder<List<AppointedCallModel>>(
            future: callService.getHistoryCalls(),
            builder: (BuildContext context,
                AsyncSnapshot<List<AppointedCallModel>> snapshot) {
              if (snapshot.connectionState == ConnectionState.waiting) {
                return CircularProgressIndicator();
              } else if (snapshot.connectionState == ConnectionState.done) {
                List<Widget> callWidgets = snapshot.data!
                    .map((call) => GestureDetector(
                          onTap: () {
                            Get.to(
                                BillPaymentScreen(paymentId: call.paymentId));
                            selectedColor = Colors.blue;
                          },
                          child: ListTile(
                            leading: Icon(CupertinoIcons.clock),
                            title:
                                Text("Call with ${call.title.split(",")[2]}"),
                            subtitle: Text(call.calldate.toString()),
                            selectedColor: Color.fromARGB(255, 11, 70, 118),
                          ),
                        ))
                    .toList();
                return ListView(children: callWidgets);
              } else {
                return Text('Error fetching data');
              }
            },
          )
        ],
      ),
    );
  }
}

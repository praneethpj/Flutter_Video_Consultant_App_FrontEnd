import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:timetalk/screens/authentication/phone_verify.dart';
import 'package:timetalk/screens/authentication_screen.dart';

class PhoneAuthenticationWidget extends StatefulWidget {
  const PhoneAuthenticationWidget({Key? key}) : super(key: key);

  @override
  State<PhoneAuthenticationWidget> createState() =>
      _PhoneAuthenticationWidgetState();
}

class _PhoneAuthenticationWidgetState extends State<PhoneAuthenticationWidget> {
  TextEditingController countryController = TextEditingController();
  var phone = "";
  int textLength = 0;
  bool sendingSMS = false;
  bool isvalidnumber = false;

  checkJwt() async {
    final box = GetStorage();
    var jwt = await box.read("jwt");
    bool IsjwtValid =
        (["", null, false, 0, "null", 'null', Null].contains(jwt));

    // if (IsjwtValid == false) {
    //   Navigator.pushNamed(context, "/");
    // } else {
    //   Get.to(AuthenticationScreen(
    //     isPaymentProcess: false,
    //   ));
    // }
  }

  @override
  void initState() {
    countryController.text = "+94";
    super.initState();
    checkJwt();
    countryController.addListener(() {
      setState(() {
        if (textLength == 9) {
          int textLength = countryController.text.length;
          print("textLength ${textLength}");
          isvalidnumber = true;
        }
      });
    });
  }

  Future<void> smsauth() async {
    setState(() {
      sendingSMS = true;
    });
    await FirebaseAuth.instance.verifyPhoneNumber(
      phoneNumber: '${countryController.text + phone}',
      verificationCompleted: (PhoneAuthCredential credential) {
        print("PhoneAuthCredential ${credential}");
      },
      verificationFailed: (FirebaseAuthException e) {
        //print("FirebaseAuthException ${e}");
        Get.snackbar('Error', 'Invalid Phone number',
            duration: Duration(seconds: 5),
            backgroundColor: Colors.black38,
            colorText: Colors.white);
      },
      codeSent: (String verificationId, int? resendToken) {
        setState(() {
          sendingSMS = false;
        });
        PhoneVerifyWidget.verificationId = verificationId;
        PhoneVerifyWidget.phonenumber = '${countryController.text + phone}';
        print("verificationId ${verificationId}");
        Get.to(PhoneVerifyWidget(), transition: Transition.zoom);
      },
      codeAutoRetrievalTimeout: (String verificationId) {},
      timeout: const Duration(seconds: 20),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        margin: EdgeInsets.only(left: 25, right: 25),
        alignment: Alignment.center,
        child: SingleChildScrollView(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Image.asset(
                'assets/images/auth.png',
                width: 150,
                height: 150,
              ),
              SizedBox(
                height: 25,
              ),
              Text(
                "Phone Verification",
                style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
              ),
              SizedBox(
                height: 10,
              ),
              Text(
                "We need to register your phone without getting started!",
                style: TextStyle(
                  fontSize: 16,
                ),
                textAlign: TextAlign.center,
              ),
              SizedBox(
                height: 30,
              ),
              Container(
                height: 55,
                decoration: BoxDecoration(
                    border: Border.all(width: 1, color: Colors.grey),
                    borderRadius: BorderRadius.circular(10)),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    SizedBox(
                      width: 10,
                    ),
                    SizedBox(
                      width: 40,
                      child: TextFormField(
                        controller: countryController,
                        keyboardType: TextInputType.number,
                        decoration: InputDecoration(
                          border: InputBorder.none,
                        ),
                      ),
                    ),
                    Text(
                      "|",
                      style: TextStyle(fontSize: 33, color: Colors.grey),
                    ),
                    SizedBox(
                      width: 10,
                    ),
                    Expanded(
                        child: TextField(
                      onChanged: (value) {
                        phone = value;
                        if (value.length == 9) {
                          setState(() {
                            isvalidnumber = true;
                          });
                        } else {
                          setState(() {
                            isvalidnumber = false;
                          });
                        }
                      },
                      keyboardType: TextInputType.number,
                      decoration: InputDecoration(
                        border: InputBorder.none,
                        hintText: "(713608978)",
                      ),
                    ))
                  ],
                ),
              ),
              SizedBox(
                height: 20,
              ),
              sendingSMS
                  ? CircularProgressIndicator()
                  : SizedBox(
                      width: double.infinity,
                      height: 45,
                      child: isvalidnumber
                          ? ElevatedButton(
                              style: ElevatedButton.styleFrom(
                                  primary: Colors.blue.shade600,
                                  shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(10))),
                              onPressed: () async {
                                smsauth();
                              },
                              child: Text("Send the code"))
                          : ElevatedButton(
                              style: ElevatedButton.styleFrom(
                                  primary: Color.fromARGB(255, 0, 1, 0),
                                  shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(10))),
                              onPressed: null,
                              child: Text("Send the code")),
                    )
            ],
          ),
        ),
      ),
    );
  }
}

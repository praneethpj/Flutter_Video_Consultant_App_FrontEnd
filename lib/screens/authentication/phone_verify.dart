import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:pinput/pinput.dart';
import 'package:timetalk/screens/signup_screen.dart';

class PhoneVerifyWidget extends StatefulWidget {
  static String verificationId = "";
  static String phonenumber = "";
  const PhoneVerifyWidget({Key? key}) : super(key: key);

  @override
  State<PhoneVerifyWidget> createState() => _PhoneVerifyWidgetState();
}

class _PhoneVerifyWidgetState extends State<PhoneVerifyWidget> {
  final FirebaseAuth auth = FirebaseAuth.instance;
  var smsCode;
  bool sendingSMS = false;
  bool isValid = false;
  Future<void> verifycode() async {
    setState(() {
      sendingSMS = true;
    });
    try {
      PhoneAuthCredential credential = PhoneAuthProvider.credential(
          verificationId: PhoneVerifyWidget.verificationId, smsCode: smsCode);

      await auth.signInWithCredential(credential);
      setState(() {
        sendingSMS = false;
      });
      Get.to(SignupScreen(phonenumber: PhoneVerifyWidget.phonenumber),
          transition: Transition.zoom);
    } catch (e) {
      setState(() {
        sendingSMS = false;
      });

      Get.snackbar('Error', 'Invalid verification code please try again.',
          duration: Duration(seconds: 5),
          backgroundColor: Colors.black38,
          colorText: Colors.white);
    }
  }

  @override
  Widget build(BuildContext context) {
    final defaultPinTheme = PinTheme(
      width: 56,
      height: 56,
      textStyle: TextStyle(
          fontSize: 20,
          color: Color.fromRGBO(30, 60, 87, 1),
          fontWeight: FontWeight.w600),
      decoration: BoxDecoration(
        border: Border.all(color: Color.fromRGBO(234, 239, 243, 1)),
        borderRadius: BorderRadius.circular(20),
      ),
    );

    final focusedPinTheme = defaultPinTheme.copyDecorationWith(
      border: Border.all(color: Color.fromRGBO(114, 178, 238, 1)),
      borderRadius: BorderRadius.circular(8),
    );

    final submittedPinTheme = defaultPinTheme.copyWith(
      decoration: defaultPinTheme.decoration?.copyWith(
        color: Color.fromRGBO(234, 239, 243, 1),
      ),
    );

    return Scaffold(
      extendBodyBehindAppBar: true,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        leading: IconButton(
          onPressed: () {
            Navigator.pop(context);
          },
          icon: Icon(
            Icons.arrow_back_ios_rounded,
            color: Colors.black,
          ),
        ),
        elevation: 0,
      ),
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
              Pinput(
                length: 6,
                // defaultPinTheme: defaultPinTheme,
                // focusedPinTheme: focusedPinTheme,
                // submittedPinTheme: submittedPinTheme,

                showCursor: true,
                onCompleted: (pin) {
                  setState(() {
                    smsCode = pin;
                    print(pin);
                    isValid = true;
                  });
                },
                onChanged: (value) {},
              ),
              SizedBox(
                height: 20,
              ),
              sendingSMS
                  ? CircularProgressIndicator()
                  : SizedBox(
                      width: double.infinity,
                      height: 45,
                      child: isValid
                          ? ElevatedButton(
                              style: ElevatedButton.styleFrom(
                                  primary: Colors.blue.shade600,
                                  shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(10))),
                              onPressed: () async {
                                verifycode();
                              },
                              child: Text("Verify Phone Number"))
                          : ElevatedButton(
                              style: ElevatedButton.styleFrom(
                                  primary: Colors.blue.shade600,
                                  shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(10))),
                              onPressed: null,
                              child: Text("Verify Phone Number")),
                    ),
              Row(
                children: [
                  TextButton(
                      onPressed: () {
                        Navigator.pop(context);
                      },
                      child: Text(
                        "Edit Phone Number ?",
                        style: TextStyle(color: Colors.black),
                      ))
                ],
              )
            ],
          ),
        ),
      ),
    );
  }
}

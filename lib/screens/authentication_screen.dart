import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:timetalk/models/auth_model.dart';
import 'package:timetalk/screens/authentication/phone_authentication.dart';
import 'package:timetalk/screens/common_widget/gradient_button.dart';
import 'package:timetalk/screens/home_screen.dart';
import 'package:timetalk/screens/make_payment_screen.dart';
import 'package:timetalk/screens/parent_home_screen.dart';
import 'package:timetalk/screens/signup_screen.dart';
import 'package:timetalk/services/api_service.dart';
import 'package:typewritertext/typewritertext.dart';

class AuthenticationScreen extends StatefulWidget {
  final bool isPaymentProcess;
  AuthenticationScreen({required this.isPaymentProcess});
  @override
  State<AuthenticationScreen> createState() => _AuthenticationScreenState();
}

class _AuthenticationScreenState extends State<AuthenticationScreen> {
  final box = GetStorage();
  FToast fToast = FToast();

  TextEditingController usernameController = TextEditingController();
  TextEditingController passwordController = TextEditingController();

  Future<AuthModel> authentication(String username, String password) async {
    AuthModel? authModel;
    if (username.isEmpty & password.isEmpty) {
      showToast("Please Enter Username and Password");
    } else {
      ApiService apiService = ApiService();
      authModel = await apiService.signIn(username, password);
      if (authModel.accessToken != "") {
        box.write("id", authModel.id);
        box.write("email", authModel.email);
        box.write("username", authModel.username);
        box.write("roles", authModel.roles);
        box.write("jwt", authModel.accessToken);

        //setState(() {});

        if (widget.isPaymentProcess) {
          Get.to(MakePaymentScreen(
            bookeddate: "",
            costperhour: 0,
            name: "",
            profileId: -1,
            profileType: "",
            title: "",
          ));
        } else {
          Get.reloadAll();
          Navigator.of(context).pop();
          Navigator.pushNamed(context, "/");
          //   Get.back();
        }
      } else {
        showToast("Wrong Username or Password");
      }
    }
    return authModel!;
  }

  showToast(String msg) {
    fToast.showToast(
        child: Text("Wrong Username or Password"),
        toastDuration: Duration(seconds: 2),
        positionedToastBuilder: (context, child) {
          return Positioned(
            child: Container(
              padding: EdgeInsets.all(10),
              decoration: BoxDecoration(
                  color: Color.fromARGB(255, 255, 234, 170),
                  borderRadius: BorderRadius.circular(30)),
              child: Text(
                msg,
                style: GoogleFonts.lato(
                    decoration: TextDecoration.none,
                    color: Colors.black,
                    fontWeight: FontWeight.bold,
                    fontSize: 15),
              ),
            ),
            top: 410,
            left: 80.0,
          );
        });
  }

  load() async {
    final box = GetStorage();
    var jwt = await box.read("jwt");
    bool IsjwtValid =
        (["", null, false, 0, "null", 'null', Null].contains(jwt));

    // if (IsjwtValid == false) {
    //   Navigator.pushNamed(context, "/");
    // } else {
    //   Get.to(PhoneAuthenticationWidget());
    // }
    if (IsjwtValid == false) {
      Navigator.pushNamed(context, "/");
    } else {
      Get.to(PhoneAuthenticationWidget());
    }
  }

  @override
  void initState() {
    super.initState();
    fToast!.init(context);

    WidgetsBinding.instance.addPostFrameCallback((_) => load());
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: AnimatedContainer(
          duration: Duration(seconds: 2),
          curve: Curves.easeInOut,
          width: MediaQuery.of(context).size.width,
          height: MediaQuery.of(context).size.height,
          child: Icon(CupertinoIcons.phone),
        ),
      ),
    );
  }
}

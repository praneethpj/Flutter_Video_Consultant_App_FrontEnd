import 'package:firebase_phone_auth_handler/firebase_phone_auth_handler.dart';
import 'package:flutter/material.dart';

import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:form_validator/form_validator.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:timetalk/helpers/ConvertHelper.dart';
import 'package:typewritertext/typewritertext.dart';

import '../models/auth_model.dart';
import '../services/api_service.dart';
import 'common_widget/gradient_button.dart';
import 'package:form_validator/form_validator.dart';

class SignupScreen extends StatefulWidget {
  final String phonenumber;

  const SignupScreen({super.key, required this.phonenumber});
  @override
  _SignupScreenState createState() => _SignupScreenState();
}

class _SignupScreenState extends State<SignupScreen> {
  final box = GetStorage();
  FToast fToast = FToast();
  bool isLoading = false;
  // TextEditingController emailController = TextEditingController();
  TextEditingController usernameController = TextEditingController();
  // TextEditingController passwordController = TextEditingController();

  Future<AuthModel> signup() async {
    setState(() {
      isLoading = true;
    });
    AuthModel? authModel;
    String password = ConvertHelper.generateRandomPassword(8);
    ApiService apiService = ApiService();
    authModel = await apiService.signUp(
        widget.phonenumber, usernameController.text, password);

    print("authModel.accessToken ${authModel.accessToken}");
    if (authModel.accessToken != "") {
      Get.reloadAll();

      ApiService apiService = ApiService();
      authModel = await apiService.signIn(usernameController.text, password);
      if (authModel.accessToken != "") {
        box.write("id", authModel.id);
        box.write("email", authModel.email);
        box.write("username", authModel.username);
        box.write("roles", authModel.roles);
        box.write("jwt", authModel.accessToken);

        setState(() {
          isLoading = false;
        });

        Get.reloadAll();
        Navigator.of(context).pop();
        Navigator.pushNamed(context, "/");
        //   Get.back();
      } else {
        showToast("Wrong Username or Password");
      }
    } else {
      showToast("${authModel.username}");
    }
    setState(() {
      isLoading = false;
    });
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

  @override
  void initState() {
    super.initState();
    fToast!.init(context);
  }

  GlobalKey<FormState> _form = GlobalKey<FormState>();

  void _validate() {
    _form.currentState!.validate();
  }

  FirebaseAuth auth = FirebaseAuth.instance;

  @override
  Widget build(BuildContext context) {
    double width = MediaQuery.of(context).size.width;
    double height = MediaQuery.of(context).size.height;
    return Scaffold(
        body: Form(
      key: _form,
      autovalidateMode: AutovalidateMode.onUserInteraction,
      child: SingleChildScrollView(
        child: Container(
            child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
              Image.asset(
                'assets/images/auth.png',
                width: width / 3,
                height: height / 3,
              ),
              Text(
                'Lets Make Talk ',
                textAlign: TextAlign.center,
                style: TextStyle(
                  color: Color.fromARGB(255, 69, 69, 69),
                  fontSize: 28,
                  fontWeight: FontWeight.bold,
                ),
              ),
              TypeWriterText(
                  repeat: false,
                  text: Text(""),
                  duration: Duration(milliseconds: 100)),
              SizedBox(height: 50),
              SizedBox(height: 20),
              Padding(
                padding: EdgeInsets.symmetric(horizontal: 50),
                child: TextFormField(
                  controller: usernameController,
                  keyboardType: TextInputType.name,
                  validator:
                      ValidationBuilder().minLength(3).maxLength(10).build(),
                  decoration: InputDecoration(
                    hintText: 'Your Preferred Name',
                    filled: true,
                    fillColor:
                        Color.fromARGB(255, 165, 163, 163).withOpacity(0.1),
                    enabledBorder: OutlineInputBorder(
                      borderSide: BorderSide(
                          color:
                              Color.fromARGB(255, 75, 74, 74).withOpacity(0.3)),
                      borderRadius: BorderRadius.circular(30),
                    ),
                    focusedBorder: OutlineInputBorder(
                      borderSide: BorderSide(
                          color: Color.fromARGB(255, 105, 24, 90)
                              .withOpacity(0.5)),
                    ),
                  ),
                  style: TextStyle(color: Color.fromARGB(255, 69, 69, 69)),
                ),
              ),
              SizedBox(height: 50),
              Padding(
                  padding: EdgeInsets.symmetric(horizontal: 50),
                  child: SizedBox(
                    width: double.infinity,
                    height: 45,
                    child: isLoading
                        ? Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            mainAxisSize: MainAxisSize.max,
                            children: [CircularProgressIndicator()],
                          )
                        : ElevatedButton(
                            style: ElevatedButton.styleFrom(
                                primary: Colors.blue.shade600,
                                shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(10))),
                            onPressed: () async {
                              signup();
                            },
                            child: Text("Let's begin")),
                  )),
              SizedBox(height: 20),
            ])),
      ),
    ));
  }
}

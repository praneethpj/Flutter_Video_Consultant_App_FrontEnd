// import 'package:cool_stepper/cool_stepper.dart';
// import 'package:flutter/material.dart';
// import 'package:timetalk/screens/authentication/phone_authentication.dart';

// class AuthenticationSteps extends StatefulWidget {
//   const AuthenticationSteps({super.key});

//   @override
//   State<AuthenticationSteps> createState() => _AuthenticationStepsState();
// }

// class _AuthenticationStepsState extends State<AuthenticationSteps> {
//   @override
//   Widget build(BuildContext context) {
//     final _formKey = GlobalKey<FormState>();
//     String? selectedRole = 'Writer';
//     final TextEditingController _nameCtrl = TextEditingController();
//     final TextEditingController _emailCtrl = TextEditingController();

//     final steps = [
//       CoolStep(
//           title: "Your phone no",
//           subtitle: "Lets register your phone",
//           content: PhoneAuthenticationWidget(),
//           validation: () {}),
//             CoolStep(
//           title: "Verify pin code",
//           subtitle: "Verify your phone",
//           content: PhoneAuthenticationWidget(),
//           validation: () {}),
//             CoolStep(
//           title: "Your phone no",
//           subtitle: "Lets register your phone",
//           content: PhoneAuthenticationWidget(),
//           validation: () {}),
//     ];
//     return Container();
//   }
// }

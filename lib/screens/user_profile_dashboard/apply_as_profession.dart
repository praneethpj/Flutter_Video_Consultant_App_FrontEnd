import 'dart:io';

import 'package:camera/camera.dart';
import 'package:cool_stepper/cool_stepper.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:get/get.dart';
import 'package:get/utils.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:timetalk/constants/ApiConstants.dart';
import 'package:timetalk/models/apply_as_profession.model.dart';
import 'package:timetalk/models/feature_model.dart';
import 'package:timetalk/models/professonal_type_model.dart';
import 'package:timetalk/screens/user_profile_dashboard.dart';
import 'package:timetalk/services/feature_service.dart';
import 'package:timetalk/services/professional_service.dart';
import 'package:image_picker/image_picker.dart';

class ApplyAsProfession extends StatefulWidget {
  const ApplyAsProfession({super.key});

  @override
  State<ApplyAsProfession> createState() => _ApplyAsProfessionState();
}

class _ApplyAsProfessionState extends State<ApplyAsProfession> {
  final _formKey = GlobalKey<FormState>();
  FToast fToast = FToast();
  ProfessionalService professionalService = ProfessionalService();

  final TextEditingController _commonnameCtrl = TextEditingController();
  final TextEditingController _firstnameCtrl = TextEditingController();
  final TextEditingController _lastnameCtrl = TextEditingController();
  final TextEditingController _mobileCtrl = TextEditingController();

  final TextEditingController _currentworkingPlaceCtrl =
      TextEditingController();

  List<ProfessionalType>? _typeList = [];

  List<FeatureModel>? _genderList = [];

  ProfessionalType? _selectedTypeObj;
  bool _typeselect = false;
  List<ProfessionalType> tmpTypeList = [];
  File? livePhotoPath;
  File? govermentDocumentImagePath;
  File? highestQualificationFile;
  File? appoinmentLetterFile;
  File? professionalPhotoFile;

  int? title;
  int? gender;
  int? mainlanguage;
  int? country;
  int? professiontype;
  String? profilepic = "";
  int? experience;
  int? costperhour;
  String? comment = "";
  int? typeId = 0;
  CameraController? _cameraController;
  List<CameraDescription>? cameras;
  bool _isRearCameraSelected = true;

  bool isloading = false;

  FeaturelService featurelService = FeaturelService();
  Future takeGovementDocument() async {
    final ImagePicker _picker = ImagePicker();
    final XFile? photo = await _picker.pickImage(source: ImageSource.gallery);

    final path = photo!.path;

    await professionalService.uploadgovemenrId(path);
    setState(() {
      govermentDocumentImagePath = File(photo!.path);
    });
  }

  Future takeHighestQualificationDocument() async {
    final ImagePicker _picker = ImagePicker();
    final XFile? photo = await _picker.pickImage(source: ImageSource.gallery);

    final path = photo!.path;

    await professionalService.uploadHighestQualification(path);
    setState(() {
      highestQualificationFile = File(photo!.path);
    });
  }

  Future takeLivePhoto() async {
    final ImagePicker _picker = ImagePicker();
    final XFile? photo = await _picker.pickImage(source: ImageSource.camera);

    final path = photo!.path;

    await professionalService.uploadLivePhoto(path);
    setState(() {
      livePhotoPath = File(photo!.path);
    });
  }

  Future takeAppoinmentLetter() async {
    final ImagePicker _picker = ImagePicker();
    final XFile? photo = await _picker.pickImage(source: ImageSource.gallery);

    final path = photo!.path;

    await professionalService.uploadAppoinmentLetter(path);
    setState(() {
      appoinmentLetterFile = File(photo!.path);
    });
  }

  Future takeProfessionalPhoto() async {
    final ImagePicker _picker = ImagePicker();
    final XFile? photo = await _picker.pickImage(source: ImageSource.gallery);

    final path = photo!.path;

    String profilepicid =
        await professionalService.uploadProfessionalPhoto(path);
    setState(() {
      professionalPhotoFile = File(photo!.path);
      profilepic = profilepicid;
    });
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    fToast!.init(context);
  }

  @override
  Widget build(BuildContext context) {
    double _width = MediaQuery.of(context).size.width;
    double _height = MediaQuery.of(context).size.height;
    final steps = [
      CoolStep(
        title: 'Basic Information',
        subtitle: 'Please fill some of the basic information to get started',
        content: Form(
          key: _formKey,
          child: Column(
            children: [
              _buildTextField(
                labelText: 'Enter Your Display Name',
                validator: (value) {
                  if (value!.isEmpty) {
                    return 'Display Name is required';
                  }
                  return null;
                },
                controller: _commonnameCtrl,
              ),
              _buildTextField(
                labelText: 'Enter Your Legal First Name',
                validator: (value) {
                  if (value!.isEmpty) {
                    return 'Legal Name is required';
                  }
                  return null;
                },
                controller: _firstnameCtrl,
              ),
              _buildTextField(
                labelText: 'Enter Your Legal Last Name',
                validator: (value) {
                  if (value!.isEmpty) {
                    return 'Legal Last Name is required';
                  }
                  return null;
                },
                controller: _lastnameCtrl,
              ),
              _buildTextField(
                labelText: 'Mobile No',
                validator: (value) {
                  if (value!.isEmpty) {
                    return 'Mobile No is required';
                  }
                  return null;
                },
                controller: _mobileCtrl,
              ),
              FutureBuilder(
                future: featurelService.getAllTitleList(),
                builder: (context, snapshot) {
                  if (snapshot.hasData) {
                    return DropdownButtonFormField<FeatureModel>(
                      decoration: InputDecoration(
                        prefixIcon: Icon(FontAwesomeIcons.ticketSimple),
                      ),
                      hint: Text(
                        "Enter your Title",
                        style: GoogleFonts.lato(fontSize: 15),
                      ),
                      items: isloading == false
                          ? snapshot.data!.map((country) {
                              return DropdownMenuItem(
                                child: new Text(
                                  " ${country.name}",
                                  style: GoogleFonts.lato(fontSize: 20),
                                ),
                                value: country,
                              );
                            }).toList()
                          : null,
                      onChanged: (_) {
                        title = _!.id;
                      },
                    );
                  } else {
                    return CircularProgressIndicator();
                  }
                },
              ),
              SizedBox(
                height: 50,
              ),
              FutureBuilder(
                future: featurelService.getAllgender(),
                builder: (context, snapshot) {
                  if (snapshot.hasData) {
                    return DropdownButtonFormField<FeatureModel>(
                      decoration: InputDecoration(
                        prefixIcon: Icon(FontAwesomeIcons.genderless),
                      ),
                      hint: Text(
                        "Enter your Gender",
                        style: GoogleFonts.lato(fontSize: 15),
                      ),
                      items: snapshot.data!.map((gender) {
                        return DropdownMenuItem(
                          child: new Text(
                            " ${gender.name}",
                            style: GoogleFonts.lato(fontSize: 20),
                          ),
                          value: gender,
                        );
                      }).toList(),
                      onChanged: (_) {
                        gender = _!.id;
                      },
                    );
                  } else {
                    return CircularProgressIndicator();
                  }
                },
              ),
              SizedBox(
                height: 50,
              ),
              FutureBuilder(
                future: featurelService.getAllcountries(),
                builder: (context, snapshot) {
                  if (snapshot.hasData) {
                    return DropdownButtonFormField<FeatureModel>(
                      decoration: InputDecoration(
                        prefixIcon: Icon(FontAwesomeIcons.flagCheckered),
                      ),
                      hint: Text(
                        "Enter your Citizenship",
                        style: GoogleFonts.lato(fontSize: 15),
                      ),
                      items: isloading == false
                          ? snapshot.data!.map((country) {
                              return DropdownMenuItem(
                                child: new Text(
                                  " ${country.name}",
                                  style: GoogleFonts.lato(fontSize: 20),
                                ),
                                value: country,
                              );
                            }).toList()
                          : null,
                      onChanged: (_) {
                        country = _!.id;
                      },
                    );
                  } else {
                    return CircularProgressIndicator();
                  }
                },
              ),
              SizedBox(
                height: 50,
              ),
              FutureBuilder(
                future: featurelService.getAllLanguageList(),
                builder: (context, snapshot) {
                  if (snapshot.hasData && snapshot.hasError == false) {
                    return DropdownButtonFormField<FeatureModel>(
                      decoration: InputDecoration(
                        prefixIcon: Icon(FontAwesomeIcons.language),
                      ),
                      hint: Text(
                        "Main Language",
                        style: GoogleFonts.lato(fontSize: 15),
                      ),
                      items: snapshot.data!.toSet().map((country) {
                        return DropdownMenuItem(
                          child: new Text(
                            " ${country.name}",
                            style: GoogleFonts.lato(fontSize: 20),
                          ),
                          value: country,
                        );
                      }).toList(),
                      onChanged: (_) {
                        mainlanguage = _!.id;
                      },
                    );
                  } else {
                    return CircularProgressIndicator();
                  }
                },
              ),
              SizedBox(
                height: 50,
              ),
              GestureDetector(
                onTap: () {
                  takeProfessionalPhoto();
                },
                child: Container(
                  width: _width,
                  height: _height / 2,
                  decoration:
                      BoxDecoration(border: Border.all(color: Colors.black26)),
                  child: Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: professionalPhotoFile != null
                        ? Image.file(
                            professionalPhotoFile!,
                            height: _height / 2,
                          )
                        : Column(
                            children: [
                              Text(
                                "Please upload your Professional Profile Photo",
                                style: GoogleFonts.lato(fontSize: 18),
                              ),
                              Image.asset(
                                'assets/button_icons/avatorprofessional.png',
                                width: _width / 3,
                                height: _height / 3,
                              ),
                            ],
                          ),
                  ),
                ),
              ),
            ],
          ),
        ),
        validation: () {
          if (!_formKey.currentState!.validate()) {
            return 'Fill form correctly';
          }
          return null;
        },
      ),
      CoolStep(
        title: 'Professional Information',
        subtitle: 'What you\'re doing',
        content: Form(
          key: _formKey,
          child: Column(
            children: [
              FutureBuilder(
                future: featurelService.getAllProfessionalType(),
                builder: (context, snapshot) {
                  if (snapshot.hasData) {
                    return DropdownButtonFormField<ProfessionalType>(
                      decoration: InputDecoration(
                        prefixIcon: Icon(FontAwesomeIcons.bridge),
                      ),
                      hint: Text(
                        "What is your Profession",
                        style: GoogleFonts.lato(fontSize: 15),
                      ),
                      items: snapshot.data!.map((gender) {
                        return DropdownMenuItem(
                          child: new Text(
                            " ${gender.name}",
                            style: GoogleFonts.lato(fontSize: 20),
                          ),
                          value: gender,
                        );
                      }).toList(),
                      onChanged: (_) {
                        professiontype = _!.id;
                        typeId = _!.id;
                      },
                    );
                  } else {
                    return CircularProgressIndicator();
                  }
                },
              ),
              SizedBox(
                height: 50,
              ),
              FutureBuilder(
                future: featurelService.getAllexperience(),
                builder: (context, snapshot) {
                  if (snapshot.hasData) {
                    return DropdownButtonFormField<FeatureModel>(
                      decoration: InputDecoration(
                        prefixIcon: Icon(FontAwesomeIcons.timeline),
                      ),
                      hint: Text(
                        "How long do you have experiences",
                        style: GoogleFonts.lato(fontSize: 15),
                      ),
                      items: snapshot.data!.map((gender) {
                        return DropdownMenuItem(
                          child: new Text(
                            " ${gender.name}",
                            style: GoogleFonts.lato(fontSize: 20),
                          ),
                          value: gender,
                        );
                      }).toList(),
                      onChanged: (_) {
                        experience = _!.id;
                      },
                    );
                  } else {
                    return CircularProgressIndicator();
                  }
                },
              ),
              SizedBox(
                height: 50,
              ),
              FutureBuilder(
                future: featurelService.getAllPerhourList(),
                builder: (context, snapshot) {
                  if (snapshot.hasData) {
                    return DropdownButtonFormField<FeatureModel>(
                      decoration: InputDecoration(
                        prefixIcon: Icon(FontAwesomeIcons.dollarSign),
                      ),
                      hint: Text(
                        "How much do you expect per hour",
                        style: GoogleFonts.lato(fontSize: 15),
                      ),
                      items: snapshot.data!.map((gender) {
                        return DropdownMenuItem(
                          child: new Text(
                            " ${gender.name}",
                            style: GoogleFonts.lato(fontSize: 20),
                          ),
                          value: gender,
                        );
                      }).toList(),
                      onChanged: (_) {
                        costperhour = _!.id;
                      },
                    );
                  } else {
                    return CircularProgressIndicator();
                  }
                },
              ),
              SizedBox(
                height: 50,
              ),
              _buildTextField(
                labelText: 'Address of current working place',
                validator: (value) {
                  if (value!.isEmpty) {
                    return 'Address of current working place is required';
                  }
                  return null;
                },
                controller: _currentworkingPlaceCtrl,
              ),
              GestureDetector(
                onTap: () {
                  takeAppoinmentLetter();
                },
                child: Container(
                  width: _width,
                  height: _height / 2,
                  decoration:
                      BoxDecoration(border: Border.all(color: Colors.black26)),
                  child: Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: appoinmentLetterFile != null
                        ? Image.file(
                            appoinmentLetterFile!,
                            height: _height / 2,
                          )
                        : Column(
                            children: [
                              Text(
                                "Please upload your appoinment letter of current working place",
                                style: GoogleFonts.lato(fontSize: 18),
                              ),
                              Image.asset(
                                'assets/button_icons/appoinment.png',
                                width: _width / 3,
                                height: _height / 3,
                              ),
                            ],
                          ),
                  ),
                ),
              ),
            ],
          ),
        ),
        validation: () {
          if (!_formKey.currentState!.validate()) {
            return 'Fill form correctly';
          }
          return null;
        },
      ),
      CoolStep(
        title: 'Verification your identity',
        subtitle: 'Lets check your profession match to qualifation',
        content: Form(
          key: _formKey,
          child: Column(children: [
            GestureDetector(
              onTap: () {
                takeLivePhoto();
              },
              child: Container(
                width: _width,
                height: _height / 2,
                decoration:
                    BoxDecoration(border: Border.all(color: Colors.black26)),
                child: Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: livePhotoPath != null
                      ? Image.file(
                          livePhotoPath!,
                          height: _height / 2,
                        )
                      : Column(
                          children: [
                            Text(
                              "We need your live photo. (Beware it should be same the below goverment document)",
                              style: GoogleFonts.lato(fontSize: 18),
                            ),
                            Image.asset(
                              'assets/button_icons/livephoto.png',
                              width: _width / 3,
                              height: _height / 3,
                            ),
                          ],
                        ),
                ),
              ),
            ),
            SizedBox(
              height: 50,
            ),
            GestureDetector(
              onTap: () {
                takeGovementDocument();
              },
              child: Container(
                width: _width,
                height: _height / 2,
                decoration:
                    BoxDecoration(border: Border.all(color: Colors.black26)),
                child: Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: govermentDocumentImagePath != null
                      ? Image.file(
                          govermentDocumentImagePath!,
                          height: _height / 2,
                        )
                      : Column(
                          children: [
                            Text(
                              "Upload Goverment Verification Documnet (Passport)",
                              style: GoogleFonts.lato(fontSize: 18),
                            ),
                            Image.asset(
                              'assets/button_icons/verification.png',
                              width: _width / 3,
                              height: _height / 3,
                            ),
                          ],
                        ),
                ),
              ),
            ),
            SizedBox(
              height: 50,
            ),
            GestureDetector(
              onTap: () {
                takeHighestQualificationDocument();
              },
              child: Container(
                width: _width,
                height: _height / 2,
                decoration:
                    BoxDecoration(border: Border.all(color: Colors.black26)),
                child: Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: highestQualificationFile != null
                      ? Image.file(
                          highestQualificationFile!,
                          height: _height / 2,
                        )
                      : Column(
                          children: [
                            Text(
                              "Upload Your highest qualification (Bachelor, Master, Phd)",
                              style: GoogleFonts.lato(fontSize: 18),
                            ),
                            Image.asset(
                              'assets/button_icons/qualification.png',
                              width: _width / 3,
                              height: _height / 3,
                            ),
                          ],
                        ),
                ),
              ),
            ),
            SizedBox(
              height: 50,
            ),
            Card(
              borderOnForeground: true,
              child: Padding(
                padding: const EdgeInsets.all(8.0),
                child: TextField(
                  maxLines: 8, //or null
                  decoration:
                      InputDecoration.collapsed(hintText: "Any Comments "),
                ),
              ),
            ),
          ]),
        ),
        validation: () {
          return null;
        },
      ),
    ];

    final stepper = CoolStepper(
      showErrorSnackbar: true,
      onCompleted: () async {
        print('Steps completed!');
        // print("Gnder ${gender}");
        ApplyAsProfessionModel applyAsProfession = ApplyAsProfessionModel(
            name: _commonnameCtrl.text,
            legalfirstname: _firstnameCtrl.text,
            legallastname: _lastnameCtrl.text,
            mobileno: int.parse(_mobileCtrl.text),
            gender: gender!,
            profilepic: profilepic!,
            title: title!,
            country: country!,
            mainlanguage: mainlanguage!,
            professionname: professiontype!,
            experience: experience!,
            typeId: typeId!,
            costperhour: costperhour!,
            currentworkingaddress: _currentworkingPlaceCtrl.text,
            comment: comment!);
        bool action =
            await professionalService.applyAsProfession(applyAsProfession);
        if (action) {
          showToast(
              "You have been applied to Profession. We will contact you soon");
        } else {
          showToast("Something went to wrong. Please try again");
        }
        Get.to(UserProfileDashboard());
      },
      steps: steps,
      config: CoolStepperConfig(
        backText: 'PREV',
      ),
    );

    return Scaffold(
      appBar: AppBar(
        title: Text("Apply as a Profession"),
      ),
      body: Container(
        child: stepper,
      ),
    );
  }

  Widget _buildTextField({
    String? labelText,
    FormFieldValidator<String>? validator,
    TextEditingController? controller,
  }) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 20.0),
      child: TextFormField(
        decoration: InputDecoration(
          labelText: labelText,
        ),
        validator: validator,
        controller: controller,
      ),
    );
  }

  Widget _buildSelector({
    BuildContext? context,
    required String name,
  }) {
    //  final isActive = name == selectedRole;

    return DropdownButtonFormField<ProfessionalType>(
      decoration: InputDecoration(
        prefixIcon: Icon(FontAwesomeIcons.locationArrow),
      ),
      isExpanded: true,
      hint: Text(
        'Select the profession type',
        style: GoogleFonts.lato(fontSize: 15),
      ), // Not necessary for Option 1
      value: _selectedTypeObj == null ? _selectedTypeObj : null,
      onChanged: (newValue) {
        setState(() {
          _selectedTypeObj = newValue;
          //   controller.selectedDeliveryAddress(tmpTypeList);
          _typeselect = true;
        });
      },
      items: _typeList != null
          ? _typeList!.map((location) {
              return DropdownMenuItem(
                child: new Text(
                  " ${location.name}",
                  style: GoogleFonts.lato(fontSize: 20),
                ),
                value: location,
              );
            }).toList()
          : null,
    );
  }

  showToast(String msg) {
    fToast.showToast(
        child: Text(msg),
        toastDuration: Duration(seconds: 10),
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
}

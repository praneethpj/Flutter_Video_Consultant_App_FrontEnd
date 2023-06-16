import 'dart:io';

import 'package:camera/camera.dart';
import 'package:cool_stepper/cool_stepper.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:get/get.dart';
import 'package:get/utils.dart';
import 'package:get_storage/get_storage.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:timetalk/constants/AlertType.dart';
import 'package:timetalk/helpers/ToastHelper.dart';
import 'package:timetalk/middleware/HomePageController.dart';
import 'package:timetalk/models/alert_model.dart';
import 'package:timetalk/models/apply_as_profession.model.dart';
import 'package:timetalk/models/feature_model.dart';
import 'package:timetalk/models/professional_model.dart';
import 'package:timetalk/models/professonal_type_model.dart';
import 'package:timetalk/screens/parent_home_screen.dart';
import 'package:timetalk/screens/user_profile_dashboard.dart';
import 'package:timetalk/services/feature_service.dart';
import 'package:timetalk/services/professional_service.dart';
import 'package:image_picker/image_picker.dart';

import '../../constants/ApiConstants.dart';

class ViewProfessionInfo extends StatefulWidget {
  ProfessionalModel? professionalModel;
  ViewProfessionInfo({super.key, required this.professionalModel});

  @override
  State<ViewProfessionInfo> createState() => _ViewProfessionInfoState();
}

class _ViewProfessionInfoState extends State<ViewProfessionInfo> {
  final _formKey = GlobalKey<FormState>();
  final GlobalKey<ScaffoldMessengerState> snackbarKey =
      GlobalKey<ScaffoldMessengerState>();
  FToast fToast = FToast();
  ProfessionalService professionalService = ProfessionalService();
  HomePageController controller = Get.find<HomePageController>();

  final TextEditingController _commonnameCtrl = TextEditingController();
  final TextEditingController _firstnameCtrl = TextEditingController();
  final TextEditingController _lastnameCtrl = TextEditingController();
  final TextEditingController _mobileCtrl = TextEditingController();
  final TextEditingController _commentCtrl = TextEditingController();

  final TextEditingController _currentworkingPlaceCtrl =
      TextEditingController();

  List<ProfessionalType>? _typeList = [];

  List<FeatureModel>? _genderList = [];

  ProfessionalType? _selectedTypeObj;
  bool _typeselect = false;
  List<ProfessionalType> tmpTypeList = [];
  String? livePhotoPath;
  String? govermentDocumentImagePath;
  String? highestQualificationFile;
  String? appoinmentLetterFile;
  String? professionalPhotoFile;

  int? title;
  int? gender;
  int? mainlanguage;
  int? country;
  int? professiontype;
  String? profilepic = "";
  int? experience;
  int? costperhour;
  String? comments = "";
  int? typeId = 0;
  CameraController? _cameraController;
  List<CameraDescription>? cameras;
  bool _isRearCameraSelected = true;

  bool isloading = false;
  final box = GetStorage();
  int id = 0;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    id = box.read("id");
    _commonnameCtrl.text = widget.professionalModel!.name;
    _currentworkingPlaceCtrl.text =
        widget.professionalModel!.currentWorkingAddress;
    _firstnameCtrl.text = widget.professionalModel!.legalfirstname;
    _lastnameCtrl.text = widget.professionalModel!.legallastname;
    _mobileCtrl.text = widget.professionalModel!.mobileno.toString();
    _commentCtrl.text = widget.professionalModel!.comments;

    title = widget.professionalModel!.titleid;
    typeId = widget.professionalModel!.typeId;
    gender = widget.professionalModel!.gender;
    mainlanguage = widget.professionalModel!.mainlanguage;
    country = widget.professionalModel!.country;
    professiontype = widget.professionalModel!.professionname;
    profilepic = widget.professionalModel!.profileImage;
    experience = widget.professionalModel!.experience;
    costperhour = widget.professionalModel!.costperhour;

    professionalPhotoFile = ApiConstants.clouddomain +
        "/image/" +
        widget.professionalModel!.profileImage;
    appoinmentLetterFile =
        ApiConstants.clouddomain + "/image/${id}/${id}_appoinmentLetter.jpg";
    livePhotoPath =
        ApiConstants.clouddomain + "/image/${id}/${id}_livePhoto.jpg";
    govermentDocumentImagePath =
        ApiConstants.clouddomain + "/image/${id}/${id}_govermentId.jpg";
    highestQualificationFile = ApiConstants.clouddomain +
        "/image/${id}/${id}_highestqualification.jpg";
    comments = widget.professionalModel!.comments;

    // ScaffoldMessenger.of(context)
    //     .showSnackBar(SnackBar(content: Text("My amazing message! O.o")));
    print(
        "profileimg path ${ApiConstants.clouddomain + "/image/" + widget.professionalModel!.profileImage}");
  }

  FeaturelService featurelService = FeaturelService();
  Future takeGovementDocument() async {
    final ImagePicker _picker = ImagePicker();
    final XFile? photo = await _picker.pickImage(source: ImageSource.gallery);

    final path = photo!.path;

    await professionalService.uploadgovemenrId(path);
    setState(() {
      govermentDocumentImagePath =
          "${ApiConstants.clouddomain}" + "image/${id}/${id}_govermentId.jpg";
    });
  }

  Future takeHighestQualificationDocument() async {
    final ImagePicker _picker = ImagePicker();
    final XFile? photo = await _picker.pickImage(source: ImageSource.gallery);

    final path = photo!.path;

    await professionalService.uploadHighestQualification(path);
    setState(() {
      highestQualificationFile = "${ApiConstants.clouddomain}" +
          "image/${id}_highestqualification.jpg";
    });
  }

  Future takeLivePhoto() async {
    final ImagePicker _picker = ImagePicker();
    final XFile? photo = await _picker.pickImage(source: ImageSource.camera);

    final path = photo!.path;

    await professionalService.uploadLivePhoto(path);
    setState(() {
      livePhotoPath =
          "${ApiConstants.clouddomain}" + "image/${id}/${id}_livePhoto.jpg";
    });
  }

  Future takeAppoinmentLetter() async {
    final ImagePicker _picker = ImagePicker();
    final XFile? photo = await _picker.pickImage(source: ImageSource.gallery);

    final path = photo!.path;

    await professionalService.uploadAppoinmentLetter(path);
    setState(() {
      appoinmentLetterFile = "${ApiConstants.clouddomain}" +
          "image/${id}/${id}_appoinmentLetter.jpg";
    });
  }

  Future takeProfessionalPhoto() async {
    final ImagePicker _picker = ImagePicker();
    final XFile? photo = await _picker.pickImage(source: ImageSource.gallery);

    final path = photo!.path;

    String profilepicid =
        await professionalService.uploadProfessionalPhoto(path);
  }

  @override
  Widget build(BuildContext context) {
    double _width = MediaQuery.of(context).size.width;
    double _height = MediaQuery.of(context).size.height;
    final key = new GlobalKey<ScaffoldState>();

    final steps = [
      CoolStep(
        title: 'Basic Information',
        subtitle: 'Please fill some of the basic information to get started',
        content: Form(
          key: _formKey,
          child: Column(
            children: [
              _buildTextField(
                  labelText: 'Your Display Name',
                  validator: (value) {
                    if (value!.isEmpty) {
                      return 'Display Name is required';
                    }
                    return null;
                  },
                  controller: _commonnameCtrl,
                  enabletoedit: true),
              _buildTextField(
                  labelText: 'Your Legal First Name',
                  validator: (value) {
                    if (value!.isEmpty) {
                      return 'Legal Name is required';
                    }
                    return null;
                  },
                  controller: _firstnameCtrl,
                  enabletoedit: false),
              _buildTextField(
                  labelText: 'Your Legal Last Name',
                  validator: (value) {
                    if (value!.isEmpty) {
                      return 'Legal Last Name is required';
                    }
                    return null;
                  },
                  controller: _lastnameCtrl,
                  enabletoedit: false),
              _buildTextField(
                  labelText: 'Mobile No',
                  validator: (value) {
                    if (value!.isEmpty) {
                      return 'Mobile No is required';
                    }
                    return null;
                  },
                  controller: _mobileCtrl,
                  enabletoedit: true),
              FutureBuilder(
                future: featurelService.getAllTitleList(),
                builder: (context, snapshot) {
                  if (snapshot.hasData) {
                    FeatureModel selectedFeature =
                        snapshot.data![widget.professionalModel!.titleid - 1];
                    return DropdownButtonFormField<FeatureModel>(
                      value: selectedFeature,
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
                      onChanged: null,
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
                    FeatureModel selectedFeature =
                        snapshot.data![widget.professionalModel!.gender - 1];
                    return DropdownButtonFormField<FeatureModel>(
                      value: selectedFeature,
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
                      onChanged: null,
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
                    FeatureModel selectedFeature =
                        snapshot.data![widget.professionalModel!.country - 1];
                    return DropdownButtonFormField<FeatureModel>(
                      value: selectedFeature,
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
                      onChanged: null,
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
                    FeatureModel selectedFeature = snapshot
                        .data![widget.professionalModel!.mainlanguage - 1];
                    return DropdownButtonFormField<FeatureModel>(
                      value: selectedFeature,
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
                      onChanged: null,
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
                        ? Image.network(
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
                    ProfessionalType selectedValue = snapshot
                        .data![widget.professionalModel!.professionname - 1];
                    return DropdownButtonFormField<ProfessionalType>(
                      value: selectedValue,
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
                      onChanged: null,
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
                    FeatureModel selectedValue = snapshot
                        .data![widget.professionalModel!.experience - 1];
                    return DropdownButtonFormField<FeatureModel>(
                      value: selectedValue,
                      decoration: InputDecoration(
                        prefixIcon: Icon(FontAwesomeIcons.timeline),
                      ),
                      hint: Text(
                        "How long do you have experiences",
                        style: GoogleFonts.lato(fontSize: 15),
                      ),
                      items: snapshot.data!.map((experience) {
                        return DropdownMenuItem(
                            child: new Text(
                              " ${experience.name}",
                              style: GoogleFonts.lato(fontSize: 20),
                            ),
                            value: experience);
                      }).toList(),
                      onChanged: null,
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
                    FeatureModel selectedFeature = snapshot
                        .data![widget.professionalModel!.costperhour - 1];
                    return DropdownButtonFormField<FeatureModel>(
                      value: selectedFeature,
                      decoration: InputDecoration(
                        prefixIcon: Icon(FontAwesomeIcons.dollarSign),
                      ),
                      hint: Text(
                        "How much do you expect per hour",
                        style: GoogleFonts.lato(fontSize: 15),
                      ),
                      items: snapshot.data!.map((pay) {
                        return DropdownMenuItem(
                          value: pay,
                          child: new Text(
                            " ${pay.name}",
                            style: GoogleFonts.lato(fontSize: 20),
                          ),
                        );
                      }).toList(),
                      onChanged: (value) {
                        costperhour = value?.id;
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
                  enabletoedit: true),
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
                        ? Image.network(
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
                      ? Image.network(
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
                      ? Image.network(
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
                      ? Image.network(
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
                  controller: _commentCtrl,
                  maxLines: 8, //or null
                  decoration: InputDecoration.collapsed(
                      hintText: "Add your message to the Profile "),
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
            comment: _commentCtrl.text);
        bool action =
            await professionalService.updatesProfession(applyAsProfession);
        if (action) {
          // Fluttertoast.showToast(
          //     msg: "You have been updated the information",
          //     toastLength: Toast.LENGTH_LONG,
          //     gravity: ToastGravity.CENTER,
          //     timeInSecForIosWeb: 1,
          //     textColor: Colors.white,
          //     fontSize: 16.0);

          Get.snackbar('Updated', 'You have been updated the information',
              titleText: Text("Messages"),
              duration: Duration(seconds: 5),
              backgroundColor: Colors.black38,
              colorText: Colors.white);

          controller.addNewNotficiation(AlertModel(
              id: 0,
              alertType: AlertType.profile,
              title: "Updated",
              message: "You have been updated the information",
              datetime: DateTime.now().toString()));
        } else {
          // Fluttertoast.showToast(
          //     msg:
          //         "Something is wrong. Update is failed. Please try again later",
          //     toastLength: Toast.LENGTH_LONG,
          //     gravity: ToastGravity.CENTER,
          //     timeInSecForIosWeb: 1,
          //     textColor: Colors.white,
          //     fontSize: 16.0);

          Get.snackbar('Error',
              'Something is wrong. Update is failed. Please try again later');
        }
        Get.to(HomePage());
      },
      steps: steps,
      config: CoolStepperConfig(
        backText: 'PREV',
      ),
    );
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

    return Scaffold(
      appBar: AppBar(
        title: Text("View my Professional info"),
      ),
      body: Container(
        child: stepper,
      ),
    );
  }

  Widget _buildTextField(
      {String? labelText,
      FormFieldValidator<String>? validator,
      TextEditingController? controller,
      required bool enabletoedit}) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 20.0),
      child: TextFormField(
        decoration: InputDecoration(
          enabled: enabletoedit!,
          labelText: labelText,
        ),
        validator: validator,
        controller: controller,
        style: TextStyle(color: enabletoedit ? Colors.black : Colors.black45),
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
}

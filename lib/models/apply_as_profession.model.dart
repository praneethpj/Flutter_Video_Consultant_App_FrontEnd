class ApplyAsProfessionModel {
  String name;
  String legalfirstname;
  String legallastname;
  int mobileno;
  int gender;
  String profilepic;
  int title;
  int country;
  int mainlanguage;
  int professionname;
  int experience;
  int typeId;
  int costperhour;
  String currentworkingaddress;
  String comment;

  ApplyAsProfessionModel({
    required this.name,
    required this.legalfirstname,
    required this.legallastname,
    required this.mobileno,
    required this.gender,
    required this.profilepic,
    required this.title,
    required this.country,
    required this.mainlanguage,
    required this.professionname,
    required this.experience,
    required this.typeId,
    required this.costperhour,
    required this.currentworkingaddress,
    required this.comment,
  });

  // Getters
  String get getName => name;
  String get getLegalFirstName => legalfirstname;
  String get getLegalLastName => legallastname;
  int get getMobileNo => mobileno;
  int get getGender => gender;
  String get getProfilePic => profilepic;
  int get getTitle => title;
  int get getCountry => country;
  int get getProfessionName => professionname;
  int get getExperience => experience;
  int get getTypeId => typeId;

  // Setters
  set setName(String name) => this.name = name;
  set setLegalFirstName(String legalFirstName) =>
      this.legalfirstname = legalFirstName;
  set setLegalLastName(String legalLastName) =>
      this.legallastname = legalLastName;
  set setMobileNo(int mobileNo) => this.mobileno = mobileNo;
  set setGender(int gender) => this.gender = gender;
  set setProfilePic(String profilePic) => this.profilepic = profilePic;
  set setTitle(int title) => this.title = title;
  set setCountry(int country) => this.country = country;
  set setProfessionName(int professionName) =>
      this.professionname = professionName;
  set setExperience(int experience) => this.experience = experience;
  set setTypeId(int typeId) => this.typeId = typeId;
}

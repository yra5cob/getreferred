import 'package:flutter/cupertino.dart';
import 'package:getreferred/constants/ProfileConstants.dart';

class ProfileModel extends ChangeNotifier {
  Map<String, dynamic> model = {
    ProfileConstants.NAME: {
      ProfileConstants.FIRST_NAME: '',
      ProfileConstants.LAST_NAME: ''
    },
    ProfileConstants.USERNAME: '',
    ProfileConstants.EMAIL: '',
    ProfileConstants.PROFILE_PIC_URL: '',
    ProfileConstants.COUNTRY_CODE: '',
    ProfileConstants.PHONE: '',
    ProfileConstants.DOB: '',
    ProfileConstants.RESUME: '',
    ProfileConstants.GENDER: '',
    ProfileConstants.RESUME_URL: '',
    ProfileConstants.CURRENT_LOCATION: '',
    ProfileConstants.PREFERRED_LOCATION: '',
    ProfileConstants.INDUSTRY: '',
    ProfileConstants.FUNCTIONAL_AREA: '',
    ProfileConstants.HEADLINE: '',
    ProfileConstants.ACADEMICS: [],
    ProfileConstants.CAREER: [],
    ProfileConstants.LANGUAGE: [],
    ProfileConstants.ADDITIONAL_INFO: {
      ProfileConstants.HANDLED_TEAM: '',
      ProfileConstants.SIX_DAYS_WEEK: '',
      ProfileConstants.RELOCATE: '',
      ProfileConstants.EARLY_STAGE_STARTUP: '',
      ProfileConstants.TRAVEL_WILLINGNESS: '',
      ProfileConstants.USA_PREMIT: '',
    },
  };

  Map get getModel => this.model;

  set setModel(Map map) => this.model = model;

  void setValue(String key, dynamic value) {
    this.model[key] = value;
    notifyListeners();
  }

  void setAll(Map<String, dynamic> map) {
    this.model.addAll(map);
    notifyListeners();
  }
}

enum Yes_No_type { Yes, No }
enum Emp_type { FullTime, PartTime, Internship }
enum Gender { Male, Female, Others, NotDisclosed }
enum Course_type { FullTime, PartTime, Distance, Executive, Certification }
enum Travel_type { No, Occasional, Extensive }

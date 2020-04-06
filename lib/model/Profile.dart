import 'package:flutter/cupertino.dart';
import 'package:flutter_country_picker/flutter_country_picker.dart';

class Profile with ChangeNotifier {
  static const years = [
    '1990',
    '1991',
    '1992',
    '1993',
    '1994',
    '1995',
    '1996',
    '1997',
    '1998',
    '1999',
    '2000',
    '2001',
    '2002',
    '2003',
    '2004',
    '2005',
    '2006',
    '2007',
    '2008',
    '2009',
    '2010',
    '2011',
    '2012',
    '2013',
    '2014',
    '2015',
    '2016',
    '2018',
    '2019',
    '2020',
    '2021',
    '2022'
  ];

  Yes_No_type six_days_week;
  Yes_No_type get sixdays_week => six_days_week;

  set sixdays_week(Yes_No_type value) => six_days_week = value;
  Yes_No_type handled_team;
  Yes_No_type get handledteam => handled_team;

  set handledteam(Yes_No_type value) => handled_team = value;
  Yes_No_type usa_premit;
  Yes_No_type get usapremit => usa_premit;

  set usapremit(Yes_No_type value) => usa_premit = value;
  Yes_No_type relocate;
  Yes_No_type get getRelocate => relocate;

  set setRelocate(Yes_No_type relocate) => this.relocate = relocate;
  Yes_No_type earlyStartup;
  Yes_No_type get getEarlyStartup => earlyStartup;

  set setEarlyStartup(Yes_No_type earlyStartup) =>
      this.earlyStartup = earlyStartup;
  Travel_type willingnessTravel;
  Travel_type get getWillingnessTravel => willingnessTravel;

  set setWillingnessTravel(Travel_type willingnessTravel) =>
      this.willingnessTravel = willingnessTravel;

  String _email;
  String get email => _email;

  set email(String value) {
    _email = value;
    notifyListeners();
  }

  Country countryCode;
  Country get getCountryCode => countryCode;

  set setCountryCode(Country countryCode) => this.countryCode = countryCode;
  String _firstname;
  String get firstname => _firstname;

  set firstname(String value) {
    _firstname = value;
    notifyListeners();
  }

  String _lastname;
  String get lastname => _lastname;

  set lastname(String value) {
    _lastname = value;
    notifyListeners();
  }

  int _country_code;
  int get country_code => _country_code;

  set country_code(int value) {
    _country_code = value;
    notifyListeners();
  }

  int _phonenumber;
  int get phonenumber => _phonenumber;

  set phonenumber(int value) {
    _phonenumber = value;
    notifyListeners();
  }

  Gender _gender;
  set setGender(Gender gender) {
    _gender = gender;
    notifyListeners();
  }

  get getGender => _gender;

  String _prederredLocation;
  String get getPreferredLocation => _prederredLocation;

  set setPreferredLocation(String loc) {
    this._prederredLocation = loc;
    notifyListeners();
  }

  String _current_location;
  set currentlocation(String current_location) {
    this._current_location = current_location;
    notifyListeners();
  }

  String get getCurrentLocation => _current_location;

  String _industry = '';
  String get getIndustry => _industry;

  set setIndustry(String industry) {
    this._industry = industry;
    notifyListeners();
  }

  String _functionalArea = '';

  String get getFunctionalArea => _functionalArea;
  set setFunctionalArea(String functionalArea) {
    this._functionalArea = functionalArea;
    notifyListeners();
  }

  DateTime _dob;
  DateTime get getDob => this._dob;

  set setDob(DateTime dob) {
    this._dob = dob;
    notifyListeners();
  }

  List<College> _college_list = [new College("", "", null, null)];

  void _add_college(
      String _college_name, String _field_of_study, String _from, String _to) {
    _college_list.add(new College(_college_name, _field_of_study, _from, _to));
    notifyListeners();
  }

  void _remove_college(int index) {
    _college_list.removeAt(index);
    notifyListeners();
  }

  List<Language> languages = [];

  List<College> getCollegeList() {
    return _college_list;
  }

  List<Company> _company_list = [
    new Company("", "", null, "", null, null, false)
  ];

  void addCompany(String _company_name, String _position, Emp_type _emp_type,
      String _from, String _to, String location, bool _current_company) {
    _company_list.add(new Company(_company_name, _position, _emp_type, location,
        _from, _to, _current_company));
    notifyListeners();
  }

  void removeCompany(int index) {
    _company_list.removeAt(index);
    notifyListeners();
  }

  List<Company> getCompanies() => _company_list;

  final Gender_values = {
    Gender.Male: "Male",
    Gender.Female: "Female",
    Gender.Others: "Others",
    Gender.Not_disclosed: "Prefer not to disclose"
  };

  static const Emp_type_values = {
    Emp_type.Full_time: "Full time",
    Emp_type.Part_time: "Part-time",
    Emp_type.Internship: "Internship"
  };

  static const Course_type_values = {
    Course_type.Full_Time: "Full time",
    Course_type.Part_Time: "Part time",
    Course_type.Distance: "Distant learning program",
    Course_type.Executive: "Executive program",
    Course_type.Certification: "Certification"
  };

  static const Yes_no_values = {
    Yes_No_type.No: "No",
    Yes_No_type.Yes: "Yes",
  };

  static get getEmptypeValues => Emp_type_values;
  get getGenderValues => Gender_values;
}

enum Gender { Male, Female, Others, Not_disclosed }
enum Course_type { Full_Time, Part_Time, Distance, Executive, Certification }
enum Travel_type { No, Occasional, Extensive }

class College {
  String _from = null;
  String get from => _from;

  Course_type course_type;
  Course_type get coursetype => course_type;

  set coursetype(Course_type value) => course_type = value;

  set from(String value) => _from = value;

  String degree;
  String get getDegree => degree;

  set setDegree(String degree) => this.degree = degree;

  String _to = null;
  String get to => _to;

  set to(String value) => _to = value;
  String _college_name;
  String get college_name => _college_name;

  set college_name(String value) => _college_name = value;
  String _field_of_study;
  String get field_of_study => _field_of_study;

  set field_of_study(String value) => _field_of_study = value;

  College(
      String _college_name, String _field_of_study, String _from, String _to) {
    this._college_name = _college_name;
    this._field_of_study = _field_of_study;
    this._from = _from;
    this._to = _to;
  }
}

class Company {
  String _from = null;
  String get from => _from;

  set from(String value) => _from = value;
  String _to = null;
  String get to => _to;

  set to(String value) => _to = value;
  String _company_name;
  String get company_name => _company_name;

  set company_name(String value) => _company_name = value;
  String _position;
  String get position => _position;

  set position(String value) => _position = value;
  Emp_type _emp_type;

  Emp_type get getEmp_type => _emp_type;

  set setEmptype(Emp_type e) => _emp_type = e;

  bool _current_company;
  bool get current_company => _current_company;

  set current_company(bool value) => _current_company = value;

  String location;
  String get getLocation => location;

  set setLocation(String location) => this.location = location;

  Company(String _company_name, String _position, Emp_type _emp_type,
      String _location, String _from, String _to, bool _current_company) {
    this._company_name = _company_name;
    this.location = _location;
    this._position = _position;
    this._emp_type = _emp_type;
    this._from = _from;
    this._to = _to;
    this._current_company = _current_company;
  }
}

class Language {
  String name;
  String get getName => name;

  set setName(String name) => this.name = name;
  bool read;
  bool get getRead => read;

  set setRead(bool read) => this.read = read;
  bool write;
  bool get getWrite => write;

  set setWrite(bool write) => this.write = write;
  bool speak;
  bool get getSpeak => speak;

  set setSpeak(bool speak) => this.speak = speak;
}

enum Yes_No_type { Yes, No }
enum Emp_type { Full_time, Part_time, Internship }

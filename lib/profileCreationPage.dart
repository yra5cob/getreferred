import 'package:cached_network_image/cached_network_image.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:enum_to_string/enum_to_string.dart';
import 'package:file_picker/file_picker.dart';
import 'package:getreferred/Home.dart';
import 'package:getreferred/constants/ProfileConstants.dart';
import 'package:getreferred/helper/UiUtilt.dart';
import 'package:getreferred/helper/Util.dart';
import 'package:getreferred/model/ProfileModel.dart';
import 'package:progress_hud/progress_hud.dart';
import 'package:getreferred/widget/CustomButton.dart';
import 'package:getreferred/widget/CustomDropDown.dart';
import 'package:getreferred/widget/CustomPhoneWidget.dart';
import 'package:getreferred/widget/CustomTextField.dart';
import 'package:getreferred/widget/CustomTouchSearch.dart';
import 'package:intl/intl.dart';
import 'package:flutter/material.dart';
import 'package:line_awesome_icons/line_awesome_icons.dart';
import 'package:provider/provider.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'autocompeletescreen.dart';
import 'package:autocomplete_textfield/autocomplete_textfield.dart';
import 'package:flutter_country_picker/flutter_country_picker.dart';
import 'package:flutter/services.dart';
import 'dart:ui';
import 'package:image_picker/image_picker.dart';
import 'package:flutter_tags/flutter_tags.dart';
import 'package:image_cropper/image_cropper.dart';
import 'dart:io';
import 'package:path/path.dart' as path;

final globalKey = GlobalKey<ScaffoldState>();
final GlobalKey<AnimatedListState> _educational_listKey = GlobalKey();
final GlobalKey<AnimatedListState> _professional_listKey = GlobalKey();
GlobalKey<AutoCompleteTextFieldState<String>> _current_location_key =
    new GlobalKey();

class ProfileCreationPage extends StatefulWidget {
  final bool isedit;

  const ProfileCreationPage({Key key, this.isedit = false}) : super(key: key);
  @override
  _ProfileCreationPageState createState() => _ProfileCreationPageState(isedit);
}

class _ProfileCreationPageState extends State<ProfileCreationPage> {
  ProgressHUD _progressHUD;

  bool _loading = false;
  final bool isedit;
  Gender genderState;
  Country countryCode;
  List<Map> languages = [];
  List<Map> colleges = [];
  List<Map> companies = [];
  Yes_No_type sixDaysState;
  Yes_No_type handledTeamState;
  Yes_No_type usaPermitState;
  Yes_No_type relocateState;
  Yes_No_type earlyStartupState;
  Travel_type willingnessTravelState;
  String resume;
  String resumeURL;
  final TextEditingController _firstNameCtrl = new TextEditingController();
  final TextEditingController _lastNameCtrl = new TextEditingController();
  TextEditingController _searchCurrentLocation = new TextEditingController();
  TextEditingController _phoneNumberController = new TextEditingController();
  TextEditingController _headlineController = new TextEditingController();
  final TextEditingController _searchpreferredLocation =
      new TextEditingController();

  final TextEditingController _searchindustry = new TextEditingController();

  final TextEditingController _searchfunctionalarea =
      new TextEditingController();
  var formatter = new DateFormat('dd-MM-yyyy');
  var monthYearFormatter = new DateFormat('MMM-yyyy');
  TextEditingController _dob_ctrl = new TextEditingController();

  TextEditingController companyNameControllerTemp;
  TextEditingController companyPositionControllerTemp;
  TextEditingController companyLocationControllerTemp;
  TextEditingController _companyTo_TempCtrl;
  TextEditingController _companyFrom_TempCtrl;

  Emp_type companyEmpTypeTemp;
  DateTime companyFromtemp;
  DateTime companytoTemp;
  bool companyCurrentTemp;
  DateTime dobState;

  TextEditingController collegeNameControllerTemp;
  TextEditingController collegeDegreeControllerTemp;
  TextEditingController collegeFieldOfStudyControllerTemp;
  TextEditingController _collegeTo_TempCtrl;
  TextEditingController _collegeFrom_TempCtrl;
  Course_type collegeCourseTypeTemp;
  DateTime collegeFromTemp;
  DateTime collegeToTemp;

  TextEditingController languageNameTemp;
  bool speakTemp;
  bool readTemp;
  bool writeTemp;
  String imageUrl;

  _ProfileCreationPageState(this.isedit);

  Future<Null> _selectDate(
      BuildContext context, DateTime getDate, Function setDate) async {
    final DateTime picked = await showDatePicker(
        context: context,
        initialDate: getDate == null ? DateTime.now() : getDate,
        firstDate: DateTime(1970, 1),
        lastDate: DateTime(2101));
    if (picked != null && picked != getDate) {
      setDate(picked);
    }
  }

  @override
  void initState() {
    super.initState();
    _progressHUD = new ProgressHUD(
      backgroundColor: Colors.black12,
      color: Colors.cyan,
      containerColor: Colors.white,
      borderRadius: 5.0,
      loading: false,
      text: "Saving...",
    );
    final _profile = Provider.of<ProfileModel>(context, listen: false);
    _profile.getModel[ProfileConstants.CAREER].forEach((c) {
      Map _company = {};
      _company[ProfileConstants.COMPANY_NAME] =
          c[ProfileConstants.COMPANY_NAME];
      _company[ProfileConstants.COMPANY_POSITION] =
          c[ProfileConstants.COMPANY_POSITION];
      _company[ProfileConstants.COMPANY_LOCATION] =
          c[ProfileConstants.COMPANY_LOCATION];
      _company[ProfileConstants.COMPANY_IS_CURRENT] =
          c[ProfileConstants.COMPANY_IS_CURRENT];
      _company[ProfileConstants.COMPANY_EMPLOYE_TYPE] =
          c[ProfileConstants.COMPANY_EMPLOYE_TYPE];
      _company[ProfileConstants.COMPANY_FROM] =
          c[ProfileConstants.COMPANY_FROM];
      _company[ProfileConstants.COMPANY_TO] = c[ProfileConstants.COMPANY_TO];
      companies.add(_company);
    });
    _profile.getModel[ProfileConstants.ACADEMICS].forEach((c) {
      Map _college = {};
      _college[ProfileConstants.COLLEGE_NAME] =
          c[ProfileConstants.COLLEGE_NAME];
      _college[ProfileConstants.COLLEGE_DEGREE] =
          c[ProfileConstants.COLLEGE_DEGREE];
      _college[ProfileConstants.COLLEGE_FIELD_OF_STUDY] =
          c[ProfileConstants.COLLEGE_FIELD_OF_STUDY];
      _college[ProfileConstants.COLLEGE_COURSE_TYPE] =
          c[ProfileConstants.COLLEGE_COURSE_TYPE];
      _college[ProfileConstants.COLLEGE_FROM] =
          c[ProfileConstants.COLLEGE_FROM];
      _college[ProfileConstants.COLLEGE_TO] = c[ProfileConstants.COLLEGE_TO];
      colleges.add(_college);
    });

    _profile.getModel[ProfileConstants.LANGUAGE].forEach((l) {
      Map language = {};
      language[ProfileConstants.LANGUAGE_NAME] =
          l[ProfileConstants.LANGUAGE_NAME];
      language[ProfileConstants.LANGUAGE_READ] =
          l[ProfileConstants.LANGUAGE_READ];
      language[ProfileConstants.LANGUAGE_WRITE] =
          l[ProfileConstants.LANGUAGE_WRITE];
      language[ProfileConstants.LANGUAGE_SPEAK] =
          l[ProfileConstants.LANGUAGE_SPEAK];
      languages.add(language);
    });
    genderState = EnumToString.fromString(
        Gender.values, _profile.model[ProfileConstants.GENDER]);
    countryCode = _profile.model[ProfileConstants.COUNTRY_CODE] == null ||
            _profile.model[ProfileConstants.COUNTRY_CODE] == ''
        ? null
        : Country.findByIsoCode(_profile.model[ProfileConstants.COUNTRY_CODE]);
    resume = _profile.model[ProfileConstants.RESUME];
    resumeURL = _profile.model[ProfileConstants.RESUME_URL];
    _firstNameCtrl.text =
        _profile.model[ProfileConstants.NAME][ProfileConstants.FIRST_NAME];
    _phoneNumberController.text = _profile.model[ProfileConstants.PHONE] == null
        ? ""
        : _profile.model[ProfileConstants.PHONE].toString();
    _lastNameCtrl.text =
        _profile.model[ProfileConstants.NAME][ProfileConstants.LAST_NAME];
    _searchCurrentLocation.text =
        _profile.model[ProfileConstants.CURRENT_LOCATION];
    _searchpreferredLocation.text =
        _profile.model[ProfileConstants.PREFERRED_LOCATION];
    _searchindustry.text = _profile.model[ProfileConstants.INDUSTRY];
    _headlineController.text = _profile.model[ProfileConstants.HEADLINE];
    _searchfunctionalarea.text =
        _profile.model[ProfileConstants.FUNCTIONAL_AREA];
    dobState = _profile.model[ProfileConstants.DOB] == ''
        ? DateTime.now()
        : formatter.parse(_profile.model[ProfileConstants.DOB]);
    _dob_ctrl.text = _profile.model[ProfileConstants.DOB] == ''
        ? ""
        : _profile.model[ProfileConstants.DOB];

    sixDaysState = EnumToString.fromString(
        Yes_No_type.values,
        _profile.model[ProfileConstants.ADDITIONAL_INFO]
            [ProfileConstants.SIX_DAYS_WEEK]);
    handledTeamState = EnumToString.fromString(
        Yes_No_type.values,
        _profile.model[ProfileConstants.ADDITIONAL_INFO]
            [ProfileConstants.HANDLED_TEAM]);
    usaPermitState = EnumToString.fromString(
        Yes_No_type.values,
        _profile.model[ProfileConstants.ADDITIONAL_INFO]
            [ProfileConstants.USA_PREMIT]);
    relocateState = EnumToString.fromString(
        Yes_No_type.values,
        _profile.model[ProfileConstants.ADDITIONAL_INFO]
            [ProfileConstants.RELOCATE]);
    earlyStartupState = EnumToString.fromString(
        Yes_No_type.values,
        _profile.model[ProfileConstants.ADDITIONAL_INFO]
            [ProfileConstants.EARLY_STAGE_STARTUP]);
    willingnessTravelState = EnumToString.fromString(
        Travel_type.values,
        _profile.model[ProfileConstants.ADDITIONAL_INFO]
            [ProfileConstants.TRAVEL_WILLINGNESS]);
    companyNameControllerTemp = new TextEditingController();
    companyPositionControllerTemp = new TextEditingController();
    companyLocationControllerTemp = new TextEditingController();
    _companyFrom_TempCtrl = new TextEditingController();
    _companyTo_TempCtrl = new TextEditingController();
    companyEmpTypeTemp = null;
    companyEmpTypeTemp = null;
    companyFromtemp = null;
    companytoTemp = null;
    companyCurrentTemp = false;

    collegeNameControllerTemp = new TextEditingController();
    collegeDegreeControllerTemp = new TextEditingController();
    collegeFieldOfStudyControllerTemp = new TextEditingController();
    _collegeFrom_TempCtrl = new TextEditingController();
    _collegeTo_TempCtrl = new TextEditingController();
    collegeCourseTypeTemp = null;
    collegeFromTemp = null;
    collegeToTemp = null;

    languageNameTemp = new TextEditingController();
    speakTemp = false;
    readTemp = false;
    writeTemp = false;
    imageUrl = _profile.model[ProfileConstants.PROFILE_PIC_URL];
  }

  Future getImage() async {
    ImagePicker.pickImage(source: ImageSource.gallery).then((image) {
      if (image != null)
        _cropImage(image).then((img) {
          if (img != null) {
            uploadPic(context, img);
            print('Image Path $img');
          }
        });
    });
  }

  void dismissProgressHUD() {
    setState(() {
      if (_loading) {
        _progressHUD.state.dismiss();
      } else {
        _progressHUD.state.show();
      }

      _loading = !_loading;
    });
  }

  Future<File> _cropImage(File img) async {
    File croppedFile = await ImageCropper.cropImage(
        sourcePath: img.path,
        aspectRatioPresets: Platform.isAndroid
            ? [
                CropAspectRatioPreset.square,
                CropAspectRatioPreset.ratio3x2,
                CropAspectRatioPreset.original,
                CropAspectRatioPreset.ratio4x3,
                CropAspectRatioPreset.ratio16x9
              ]
            : [
                CropAspectRatioPreset.original,
                CropAspectRatioPreset.square,
                CropAspectRatioPreset.ratio3x2,
                CropAspectRatioPreset.ratio4x3,
                CropAspectRatioPreset.ratio5x3,
                CropAspectRatioPreset.ratio5x4,
                CropAspectRatioPreset.ratio7x5,
                CropAspectRatioPreset.ratio16x9
              ],
        androidUiSettings: AndroidUiSettings(
            toolbarTitle: 'Crop Image',
            toolbarColor: Colors.green[800],
            toolbarWidgetColor: Colors.white,
            initAspectRatio: CropAspectRatioPreset.original,
            lockAspectRatio: false),
        iosUiSettings: IOSUiSettings(
          title: 'Crop image',
        ));
    if (croppedFile != null) {
      return croppedFile;
    } else {
      return null;
    }
  }

  Future uploadPic(BuildContext context, File img) async {
    StorageReference storageReference = FirebaseStorage.instance.ref().child(
        "profilePictures/" +
            Provider.of<ProfileModel>(context, listen: false)
                .model[ProfileConstants.USERNAME]);
    final StorageUploadTask uploadTask = storageReference.putFile(img);
    final StorageTaskSnapshot downloadUrl = (await uploadTask.onComplete);
    final String url = (await downloadUrl.ref.getDownloadURL());
    Provider.of<ProfileModel>(context, listen: false)
        .setValue(ProfileConstants.PROFILE_PIC_URL, url);
    setState(() {
      imageUrl = url;
    });
    print("URL is $url");
  }

  String getSafeValue(item) {
    return item == null ? '' : item;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        key: globalKey,
        appBar: AppBar(
          leading: IconButton(
            icon: UIUtil.getMasked(Icons.arrow_back_ios),
            onPressed: () => Navigator.of(context).pop(),
          ),
          centerTitle: true,
          elevation: 0,
          title: Text(
            "Create your profile",
            style: TextStyle(foreground: UIUtil.getTextGradient()),
          ),
          backgroundColor: Colors.white,
          actions: <Widget>[
            IconButton(
                icon: UIUtil.getMasked(Icons.help),
                color: Colors.black,
                onPressed: () {}),
          ],
        ),
        bottomNavigationBar: BottomAppBar(
          elevation: 4,
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: <Widget>[
              isedit
                  ? Container(
                      height: 3,
                    )
                  : Material(
                      child: InkWell(
                      onTap: () {},
                      child: Padding(
                        padding: const EdgeInsets.symmetric(
                            vertical: 10, horizontal: 20),
                        child: Row(
                          children: <Widget>[
                            Text(
                              "Skip ",
                              style:
                                  TextStyle(fontSize: 20, color: Colors.cyan),
                            ),
                            UIUtil.getMasked(Icons.arrow_forward_ios)
                          ],
                        ),
                      ),
                    )),
              CustomButton(
                label: isedit ? "Save" : "Save and continue",
                margin: EdgeInsets.all(20),
                icon: Icons.arrow_forward_ios,
                onTap: () {
                  dismissProgressHUD();
                  final _profile =
                      Provider.of<ProfileModel>(context, listen: false);
                  Map<String, dynamic> model = {
                    ProfileConstants.NAME: {
                      ProfileConstants.FIRST_NAME: _firstNameCtrl.text,
                      ProfileConstants.LAST_NAME: _lastNameCtrl.text,
                    },
                    ProfileConstants.PROFILE_PIC_URL: imageUrl,
                    ProfileConstants.COUNTRY_CODE:
                        countryCode == null ? null : countryCode.isoCode,
                    ProfileConstants.PHONE: _phoneNumberController.text,
                    ProfileConstants.DOB: _dob_ctrl.text,
                    ProfileConstants.GENDER:
                        getSafeValue(EnumToString.parseCamelCase(genderState)),
                    ProfileConstants.CURRENT_LOCATION:
                        _searchCurrentLocation.text,
                    ProfileConstants.PREFERRED_LOCATION:
                        _searchpreferredLocation.text,
                    ProfileConstants.INDUSTRY: _searchindustry.text,
                    ProfileConstants.FUNCTIONAL_AREA:
                        _searchfunctionalarea.text,
                    ProfileConstants.HEADLINE: _headlineController.text,
                    ProfileConstants.ACADEMICS: colleges,
                    ProfileConstants.CAREER: companies,
                    ProfileConstants.LANGUAGE: languages,
                    ProfileConstants.ADDITIONAL_INFO: {
                      ProfileConstants.HANDLED_TEAM: getSafeValue(
                          EnumToString.parseCamelCase(handledTeamState)),
                      ProfileConstants.SIX_DAYS_WEEK: getSafeValue(
                          EnumToString.parseCamelCase(sixDaysState)),
                      ProfileConstants.RELOCATE: getSafeValue(
                          EnumToString.parseCamelCase(relocateState)),
                      ProfileConstants.EARLY_STAGE_STARTUP: getSafeValue(
                          EnumToString.parseCamelCase(earlyStartupState)),
                      ProfileConstants.TRAVEL_WILLINGNESS: getSafeValue(
                          EnumToString.parseCamelCase(willingnessTravelState)),
                      ProfileConstants.USA_PREMIT: usaPermitState == null
                          ? ''
                          : EnumToString.parseCamelCase(usaPermitState),
                    },
                  };

                  Firestore.instance
                      .collection('users')
                      .document(_profile.model[ProfileConstants.USERNAME])
                      .setData(model, merge: true)
                      .then((onValue) {
                    _profile.setAll(model);
                    dismissProgressHUD();
                    isedit
                        ? Navigator.pop(context)
                        : Navigator.pushAndRemoveUntil(
                            context,
                            MaterialPageRoute(
                              builder: (context) => Home(),
                            ),
                            ModalRoute.withName("/Home"));
                  });
                },
              )
            ],
          ),
        ),
        body: Stack(
          children: <Widget>[
            Container(
                padding: EdgeInsets.only(left: 20, right: 20),
                child: ListView(
                  shrinkWrap: true,
                  children: <Widget>[
                    ListView(
                      physics: ClampingScrollPhysics(),
                      shrinkWrap: true,
                      children: <Widget>[
                        SizedBox(height: 20),
                        Text("Personal",
                            style: Theme.of(context).textTheme.headline.merge(
                                  TextStyle(
                                      fontWeight: FontWeight.bold,
                                      foreground: UIUtil.getTextGradient()),
                                )),
                        _personalForm(),
                        Divider(
                          color: Colors.cyan,
                        ),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: <Widget>[
                            Text("Education",
                                style: Theme.of(context)
                                    .textTheme
                                    .headline
                                    .merge(
                                      TextStyle(
                                          fontWeight: FontWeight.bold,
                                          foreground: UIUtil.getTextGradient()),
                                    )),
                            RawMaterialButton(
                              onPressed: () {
                                _addCollegemodalBottomSheetMenu();
                              },
                              child: new Icon(
                                Icons.add,
                                color: Colors.white,
                                size: 18.0,
                              ),
                              shape: new CircleBorder(),
                              elevation: 2.0,
                              fillColor: Util.getColor2(),
                              padding: const EdgeInsets.all(0.0),
                            ),
                          ],
                        ),
                        _educational(),
                        Divider(
                          color: Colors.cyan,
                        ),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: <Widget>[
                            Text("Career",
                                style: Theme.of(context)
                                    .textTheme
                                    .headline
                                    .merge(
                                      TextStyle(
                                          fontWeight: FontWeight.bold,
                                          foreground: UIUtil.getTextGradient()),
                                    )),
                            RawMaterialButton(
                              onPressed: () {
                                _addJobmodalBottomSheetMenu();
                              },
                              child: new Icon(
                                Icons.add,
                                color: Colors.white,
                                size: 18.0,
                              ),
                              shape: new CircleBorder(),
                              elevation: 2.0,
                              fillColor: Util.getColor2(),
                              padding: const EdgeInsets.all(0.0),
                            ),
                          ],
                        ),
                        _profession(),
                        Divider(
                          color: Colors.cyan,
                        ),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: <Widget>[
                            Text("Language",
                                style: Theme.of(context)
                                    .textTheme
                                    .headline
                                    .merge(
                                      TextStyle(
                                          fontWeight: FontWeight.bold,
                                          foreground: UIUtil.getTextGradient()),
                                    )),
                            RawMaterialButton(
                              onPressed: () {
                                _addLanguagemodalBottomSheetMenu();
                              },
                              child: new Icon(
                                Icons.add,
                                color: Colors.white,
                                size: 18.0,
                              ),
                              shape: new CircleBorder(),
                              elevation: 2.0,
                              fillColor: Util.getColor2(),
                              padding: const EdgeInsets.all(0.0),
                            ),
                          ],
                        ),
                        _languageWidget(context),
                        Divider(
                          color: Colors.cyan,
                        ),
                        Row(
                          children: <Widget>[
                            Text("Additional information",
                                style: Theme.of(context)
                                    .textTheme
                                    .headline
                                    .merge(
                                      TextStyle(
                                          fontWeight: FontWeight.bold,
                                          foreground: UIUtil.getTextGradient()),
                                    )),
                          ],
                        ),
                        _additionalInfo(context),
                        Divider(
                          color: Colors.cyan,
                        ),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: <Widget>[
                            Text("Resume",
                                style: Theme.of(context)
                                    .textTheme
                                    .headline
                                    .merge(
                                      TextStyle(
                                          fontWeight: FontWeight.bold,
                                          foreground: UIUtil.getTextGradient()),
                                    )),
                          ],
                        ),
                        _resume(context),
                        SizedBox(
                          height: 40,
                        ),
                        Divider(
                          color: Colors.cyan,
                        ),
                      ],
                    )
                  ],
                )),
            _progressHUD,
          ],
        ));
  }

  Widget _resume(BuildContext context) {
    return Container(
      margin: EdgeInsets.symmetric(vertical: 10),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: <Widget>[
          resume == ''
              ? Container(
                  child: Center(
                      child: Text(
                    "No resume attached!",
                    style: TextStyle(color: Colors.grey, fontSize: 16),
                  )),
                )
              : Container(
                  child: Material(
                    child: InkWell(
                      onTap: () {},
                      child: Card(
                        child: Padding(
                          padding: const EdgeInsets.symmetric(
                              vertical: 10, horizontal: 10),
                          child: Text(
                            resume,
                            style: TextStyle(
                                color: Colors.cyan,
                                fontStyle: FontStyle.italic,
                                fontSize: 16),
                          ),
                        ),
                      ),
                    ),
                  ),
                ),
          SizedBox(
            height: 10,
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.end,
            children: <Widget>[
              Container(
                child: Material(
                  color: Util.getColor2(),
                  borderRadius: BorderRadius.circular(15),
                  child: InkWell(
                    onTap: () {
                      FilePicker.getFile(
                        type: FileType.custom,
                        allowedExtensions: ['pdf', 'doc'],
                      ).then((onValue) {
                        uploadFile(context, onValue);
                      });
                    },
                    child: Padding(
                      padding: const EdgeInsets.symmetric(
                          vertical: 10, horizontal: 20),
                      child: Text(
                        resume == '' ? "Upload Resume" : "Update Resume",
                        style: TextStyle(color: Colors.white),
                      ),
                    ),
                  ),
                ),
              )
            ],
          )
        ],
      ),
    );
  }

  Future uploadFile(BuildContext context, File file) async {
    dismissProgressHUD();
    final _profile = Provider.of<ProfileModel>(context, listen: false);
    StorageReference storageReference = FirebaseStorage.instance
        .ref()
        .child("resume/" + _profile.getModel[ProfileConstants.USERNAME]);
    final StorageUploadTask uploadTask = storageReference.putFile(file);
    final StorageTaskSnapshot downloadUrl = (await uploadTask.onComplete);
    final String url = (await downloadUrl.ref.getDownloadURL());
    var data = {
      ProfileConstants.RESUME: _profile.getModel[ProfileConstants.NAME]
              [ProfileConstants.FIRST_NAME] +
          "_resume",
      ProfileConstants.RESUME_URL: url
    };
    var docref = Firestore.instance
        .collection('users')
        .document(_profile.model[ProfileConstants.USERNAME]);
    await docref.setData(data, merge: true).then((onValue) {});
    _profile.setAll(data);
    print("URL is $url");
    dismissProgressHUD();
  }

  Widget _personalForm() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        Row(
          children: <Widget>[
            Expanded(
              child: Divider(
                color: Colors.cyan,
              ),
            ),
            Stack(
              children: <Widget>[
                CircleAvatar(
                  backgroundColor: Colors.grey,
                  radius: 50,
                  child: ClipOval(
                      child: imageUrl == ""
                          ? Image.asset("assets/images/profile.png")
                          : CachedNetworkImage(
                              imageUrl: imageUrl,
                              placeholder: (context, url) =>
                                  CircularProgressIndicator(),
                              errorWidget: (context, url, error) =>
                                  Icon(Icons.error),
                              fit: BoxFit.cover,
                              width: 100.0,
                              height: 100.0,
                            )),
                ),
                Positioned(
                    bottom: -5,
                    right: -25,
                    child: RawMaterialButton(
                      onPressed: () {
                        getImage();
                      },
                      child: new Icon(
                        Icons.edit,
                        color: Colors.black,
                        size: 18.0,
                      ),
                      shape: new CircleBorder(),
                      elevation: 2.0,
                      fillColor: Colors.white,
                      padding: const EdgeInsets.all(0.0),
                    ))
              ],
            ),
            Expanded(
                child: Divider(
              color: Colors.cyan,
            ))
          ],
        ),
        SizedBox(
          height: 20,
        ),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 10),
          child: Text(
            "First Name",
            style: TextStyle(fontSize: 14, color: Util.getColor2()),
          ),
        ),
        CustomTextField(
          hint: "First name",
          controller: _firstNameCtrl,
        ),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 10),
          child: Text(
            "Last Name",
            style: TextStyle(fontSize: 14, color: Util.getColor2()),
          ),
        ),
        CustomTextField(
          hint: "Last name",
          controller: _lastNameCtrl,
        ),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 10),
          child: Text(
            "Phone",
            style: TextStyle(fontSize: 14, color: Util.getColor2()),
          ),
        ),
        CustomPhoneWidget(
          controller: _phoneNumberController,
          countryCodeValue: countryCode,
          hint: "Phone",
          onCountryCodeChange: (Country country) {
            setState(() {
              countryCode = country;
            });
          },
        ),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 10),
          child: Text(
            "Date of birth",
            style: TextStyle(fontSize: 14, color: Util.getColor2()),
          ),
        ),
        CustomTextField(
          hint: "Date of birth",
          readonly: true,
          onTap: () {
            _selectDate(context, dobState, (DateTime d) {
              setState(() {
                dobState = d;
                _dob_ctrl.text = d == null ? "" : formatter.format(d);
              });
            });
          },
          controller: _dob_ctrl,
        ),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 10),
          child: Text(
            "Gender",
            style: TextStyle(fontSize: 14, color: Util.getColor2()),
          ),
        ),
        CustomDropDown(
          hint: 'Gender',
          value: genderState,
          list: Gender.values,
          onChanged: (value) {
            setState(() {
              genderState = value;
            });
          },
          isEnum: true,
        ),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 10),
          child: Text(
            "Current Location",
            style: TextStyle(fontSize: 14, color: Util.getColor2()),
          ),
        ),
        CustomTouchSearch(
          hint: "Current location",
          list: ["Chennai", "Bangalore", "Mumbai"],
          controller: _searchCurrentLocation,
          readonly: true,
          onResult: (value) {
            setState(() {
              _searchCurrentLocation.text = value;
            });
          },
        ),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 10),
          child: Text(
            "Preferred Location",
            style: TextStyle(fontSize: 14, color: Util.getColor2()),
          ),
        ),
        CustomTouchSearch(
          hint: "Preferred location",
          list: ["Chennai", "Bangalore", "Mumbai"],
          controller: _searchpreferredLocation,
          readonly: true,
          onResult: (value) {
            setState(() {
              _searchpreferredLocation.text = value;
            });
          },
        ),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 10),
          child: Text(
            "Preferred Industry",
            style: TextStyle(fontSize: 14, color: Util.getColor2()),
          ),
        ),
        CustomTouchSearch(
          hint: "Industry",
          list: ["FMCG", "Ecommerce", "Oil & Gas"],
          controller: _searchindustry,
          readonly: true,
          onResult: (value) {
            setState(() {
              _searchindustry.text = value;
            });
          },
        ),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 10),
          child: Text(
            "Preferred Functional Area",
            style: TextStyle(fontSize: 14, color: Util.getColor2()),
          ),
        ),
        CustomTouchSearch(
          hint: "Functional area",
          list: ["Sales", "Marketing", "Operations"],
          controller: _searchfunctionalarea,
          readonly: true,
          onResult: (value) {
            setState(() {
              _searchfunctionalarea.text = value;
            });
          },
        ),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 10),
          child: Text(
            "Profile Headline",
            style: TextStyle(fontSize: 14, color: Util.getColor2()),
          ),
        ),
        CustomTextField(
          hint: "Headlines",
          lines: 3,
          controller: _headlineController,
        ),
      ],
    );
  }

  Widget _profession() {
    return Column(
      children: <Widget>[
        AnimatedList(
            physics: NeverScrollableScrollPhysics(),
            shrinkWrap: true,
            key: _professional_listKey,
            initialItemCount: companies.length,
            itemBuilder:
                (BuildContext context, int index, Animation animation) {
              return _company(index);
            })
      ],
    );
  }

  Widget _language(int index) {
    return Container(
      child: Card(
        child: ListTile(
          leading: UIUtil.getMasked(LineAwesomeIcons.language, size: 40),
          title: Text(
            languages[index][ProfileConstants.LANGUAGE_NAME],
            style: TextStyle(
                fontSize: 16, height: 1.38, fontWeight: FontWeight.w500),
          ),
          subtitle: Row(
            mainAxisAlignment: MainAxisAlignment.start,
            children: <Widget>[
              if (languages[index][ProfileConstants.LANGUAGE_SPEAK])
                Text("Speak ",
                    style: TextStyle(
                        fontSize: 14,
                        height: 1.38,
                        color: Colors.grey,
                        fontWeight: FontWeight.w500)),
              if (languages[index][ProfileConstants.LANGUAGE_READ])
                Text("Read ",
                    style: TextStyle(
                        fontSize: 14,
                        height: 1.38,
                        color: Colors.grey,
                        fontWeight: FontWeight.w500)),
              if (languages[index][ProfileConstants.LANGUAGE_WRITE])
                Text("Write ",
                    style: TextStyle(
                        fontSize: 14,
                        height: 1.38,
                        color: Colors.grey,
                        fontWeight: FontWeight.w500)),
            ],
          ),
          trailing: PopupMenuButton<int>(
            itemBuilder: (context) => [
              PopupMenuItem(
                value: 1,
                child: Text("Edit"),
              ),
              PopupMenuItem(
                value: 2,
                child: Text("Delete"),
              ),
            ],
            onCanceled: () {
              print("You have canceled the menu.");
            },
            onSelected: (value) {
              if (value == 2) {
                AnimatedListRemovedItemBuilder builder = (context, animation) {
                  // A method to build the Card widget.
                  return new Container();
                };
                _educational_listKey.currentState.removeItem(index, builder);
                colleges.removeAt(index);
              }
            },
            icon: Icon(Icons.more_vert),
          ),
        ),
      ),
    );
  }

  Widget _addLanguage(int index) {
    return Container(
        constraints: BoxConstraints(maxWidth: double.infinity),
        child: Stack(children: [
          Card(
              margin: EdgeInsets.only(
                top: 10,
                left: 0,
                right: 0,
              ),
              child: Material(
                  elevation: 3,
                  borderRadius: BorderRadius.circular(10),
                  child: Padding(
                      padding: EdgeInsets.all(10),
                      child: Column(
                          crossAxisAlignment: CrossAxisAlignment.stretch,
                          children: <Widget>[
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: <Widget>[
                                Text(
                                  languages[index]
                                      [ProfileConstants.LANGUAGE_NAME],
                                  style: Theme.of(context)
                                      .textTheme
                                      .title
                                      .merge(TextStyle(
                                          fontWeight: FontWeight.bold)),
                                ),
                              ],
                            ),
                            SizedBox(
                              height: 20,
                            ),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.start,
                              children: <Widget>[
                                if (languages[index]
                                    [ProfileConstants.LANGUAGE_SPEAK])
                                  Text("Speak "),
                                if (languages[index]
                                    [ProfileConstants.LANGUAGE_READ])
                                  Text("Read "),
                                if (languages[index]
                                    [ProfileConstants.LANGUAGE_WRITE])
                                  Text("Write "),
                              ],
                            )
                          ])))),
          Align(
            alignment: Alignment.topRight,
            child: PopupMenuButton<int>(
              itemBuilder: (context) => [
                PopupMenuItem(
                  value: 1,
                  child: Text("Edit"),
                ),
                PopupMenuItem(
                  value: 2,
                  child: Text("Delete"),
                ),
              ],
              onCanceled: () {
                print("You have canceled the menu.");
              },
              onSelected: (value) {
                if (value == 2) {
                  setState(() {
                    languages.removeAt(index);
                  });
                }
              },
              icon: Icon(Icons.more_vert),
            ),
          )
        ]));
  }

  Widget _educational() {
    return Column(
      children: <Widget>[
        AnimatedList(
            physics: NeverScrollableScrollPhysics(),
            shrinkWrap: true,
            key: _educational_listKey,
            initialItemCount: colleges.length,
            itemBuilder:
                (BuildContext context, int index, Animation animation) {
              return _college(index);
            }),
      ],
    );
  }

  Widget _college(int index) {
    return Container(
      child: Card(
        child: ListTile(
          leading: UIUtil.getMasked(LineAwesomeIcons.graduation_cap, size: 40),
          title: Text(
            colleges[index][ProfileConstants.COLLEGE_NAME],
            style: TextStyle(
                fontSize: 16, height: 1.38, fontWeight: FontWeight.w500),
          ),
          subtitle: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              Text(
                colleges[index][ProfileConstants.COLLEGE_DEGREE] +
                    " " +
                    colleges[index][ProfileConstants.COLLEGE_FIELD_OF_STUDY] +
                    " [" +
                    colleges[index][ProfileConstants.COLLEGE_COURSE_TYPE] +
                    "]",
                style: TextStyle(
                    fontSize: 14,
                    color: Colors.grey,
                    height: 1.38,
                    fontWeight: FontWeight.w500),
              ),
              Text(
                  colleges[index][ProfileConstants.COLLEGE_FROM] +
                      " - " +
                      colleges[index][ProfileConstants.COLLEGE_TO],
                  style: TextStyle(
                      fontSize: 14,
                      height: 1.38,
                      color: Colors.grey,
                      fontWeight: FontWeight.w500))
            ],
          ),
          trailing: PopupMenuButton<int>(
            itemBuilder: (context) => [
              PopupMenuItem(
                value: 1,
                child: Text("Edit"),
              ),
              PopupMenuItem(
                value: 2,
                child: Text("Delete"),
              ),
            ],
            onCanceled: () {
              print("You have canceled the menu.");
            },
            onSelected: (value) {
              if (value == 2) {
                AnimatedListRemovedItemBuilder builder = (context, animation) {
                  // A method to build the Card widget.
                  return new Container();
                };
                _educational_listKey.currentState.removeItem(index, builder);
                colleges.removeAt(index);
              }
            },
            icon: Icon(Icons.more_vert),
          ),
        ),
      ),
    );
  }

  Widget _company(int index) {
    return Container(
      child: Card(
        child: ListTile(
          leading: UIUtil.getMasked(LineAwesomeIcons.briefcase, size: 40),
          title: Text(
            companies[index][ProfileConstants.COMPANY_NAME],
            style: TextStyle(
                fontSize: 16, height: 1.38, fontWeight: FontWeight.w500),
          ),
          subtitle: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: <Widget>[
              Text(
                companies[index][ProfileConstants.COMPANY_POSITION] +
                    " • `" +
                    companies[index][ProfileConstants.COMPANY_EMPLOYE_TYPE],
                style: TextStyle(
                    fontSize: 14,
                    color: Colors.grey,
                    height: 1.38,
                    fontWeight: FontWeight.w500),
              ),
              Row(
                children: <Widget>[
                  Text(
                      companies[index][ProfileConstants.COMPANY_FROM] +
                          " - " +
                          companies[index][ProfileConstants.COMPANY_TO],
                      style: TextStyle(
                          fontSize: 14,
                          height: 1.38,
                          color: Colors.grey,
                          fontWeight: FontWeight.w500))
                ],
              ),
              SizedBox(
                height: 10,
              ),
              Row(
                children: <Widget>[
                  UIUtil.getMasked(LineAwesomeIcons.map_marker, size: 14),
                  Text(
                      companies[index][ProfileConstants.COMPANY_LOCATION]
                          .toString(),
                      style: TextStyle(
                          fontSize: 12,
                          height: 1.38,
                          color: Colors.grey,
                          fontWeight: FontWeight.w500))
                ],
              )
            ],
          ),
          trailing: PopupMenuButton<int>(
            itemBuilder: (context) => [
              PopupMenuItem(
                value: 1,
                child: Text("Edit"),
              ),
              PopupMenuItem(
                value: 2,
                child: Text("Delete"),
              ),
            ],
            onCanceled: () {
              print("You have canceled the menu.");
            },
            onSelected: (value) {
              if (value == 2) {
                AnimatedListRemovedItemBuilder builder = (context, animation) {
                  // A method to build the Card widget.
                  return new Container();
                };
                _educational_listKey.currentState.removeItem(index, builder);
                colleges.removeAt(index);
              }
            },
            icon: Icon(Icons.more_vert),
          ),
        ),
      ),
    );
  }

  Widget _additionalInfo(BuildContext context) {
    return ListView(
        physics: NeverScrollableScrollPhysics(),
        shrinkWrap: true,
        children: <Widget>[
          Card(
              child: Container(
                  padding:
                      EdgeInsets.only(left: 20, right: 20, top: 5, bottom: 5),
                  child: Column(
                      crossAxisAlignment: CrossAxisAlignment.stretch,
                      children: [
                        Text("Have you handled a team?"),
                        Row(children: [
                          Text("Yes"),
                          RadioGroup(
                            value: Yes_No_type.Yes,
                            groupValue: handledTeamState,
                            onChange: (Yes_No_type value) {
                              setState(() {
                                handledTeamState = value;
                              });
                            },
                          ),
                          Text("No"),
                          RadioGroup(
                            value: Yes_No_type.No,
                            groupValue: handledTeamState,
                            onChange: (Yes_No_type value) {
                              setState(() {
                                handledTeamState = value;
                              });
                            },
                          )
                        ])
                      ]))),
          Card(
              child: Container(
                  padding:
                      EdgeInsets.only(left: 20, right: 20, top: 5, bottom: 5),
                  child: Column(
                      crossAxisAlignment: CrossAxisAlignment.stretch,
                      children: [
                        Text("Are you willing to work 6 days a week?"),
                        Row(children: [
                          Text("Yes"),
                          RadioGroup(
                            value: Yes_No_type.Yes,
                            groupValue: sixDaysState,
                            onChange: (Yes_No_type value) {
                              setState(() {
                                sixDaysState = value;
                              });
                            },
                          ),
                          Text("No"),
                          RadioGroup(
                            value: Yes_No_type.No,
                            groupValue: sixDaysState,
                            onChange: (Yes_No_type value) {
                              setState(() {
                                sixDaysState = value;
                              });
                            },
                          )
                        ])
                      ]))),
          Card(
              child: Container(
                  padding:
                      EdgeInsets.only(left: 20, right: 20, top: 5, bottom: 5),
                  child: Column(
                      crossAxisAlignment: CrossAxisAlignment.stretch,
                      children: [
                        Text("Are you willing to relocate?"),
                        Row(children: [
                          Text("Yes"),
                          RadioGroup(
                            value: Yes_No_type.Yes,
                            groupValue: relocateState,
                            onChange: (Yes_No_type value) {
                              setState(() {
                                relocateState = value;
                              });
                            },
                          ),
                          Text("No"),
                          RadioGroup(
                            value: Yes_No_type.No,
                            groupValue: relocateState,
                            onChange: (Yes_No_type value) {
                              setState(() {
                                relocateState = value;
                              });
                            },
                          )
                        ])
                      ]))),
          Card(
              child: Container(
                  padding:
                      EdgeInsets.only(left: 20, right: 20, top: 5, bottom: 5),
                  child: Column(
                      crossAxisAlignment: CrossAxisAlignment.stretch,
                      children: [
                        Text(
                            "Are you open to joining an early stage start-up?"),
                        Row(children: [
                          Text("Yes"),
                          RadioGroup(
                            value: Yes_No_type.Yes,
                            groupValue: earlyStartupState,
                            onChange: (Yes_No_type value) {
                              setState(() {
                                earlyStartupState = value;
                              });
                            },
                          ),
                          Text("No"),
                          RadioGroup(
                            value: Yes_No_type.No,
                            groupValue: earlyStartupState,
                            onChange: (Yes_No_type value) {
                              setState(() {
                                earlyStartupState = value;
                              });
                            },
                          )
                        ])
                      ]))),
          Card(
              child: Container(
                  padding:
                      EdgeInsets.only(left: 20, right: 20, top: 5, bottom: 5),
                  child: Column(
                      crossAxisAlignment: CrossAxisAlignment.stretch,
                      children: [
                        Text("Willingness to Travel?"),
                        Row(children: [
                          Text("No"),
                          RadioGroup(
                            value: Travel_type.No,
                            groupValue: willingnessTravelState,
                            onChange: (Travel_type value) {
                              setState(() {
                                willingnessTravelState = value;
                              });
                            },
                          ),
                          Text("Occasional"),
                          RadioGroup(
                            value: Travel_type.Occasional,
                            groupValue: willingnessTravelState,
                            onChange: (Travel_type value) {
                              setState(() {
                                willingnessTravelState = value;
                              });
                            },
                          ),
                          Text("Extensive"),
                          RadioGroup(
                            value: Travel_type.Extensive,
                            groupValue: willingnessTravelState,
                            onChange: (Travel_type value) {
                              setState(() {
                                willingnessTravelState = value;
                              });
                            },
                          )
                        ])
                      ]))),
          Card(
              child: Container(
                  padding:
                      EdgeInsets.only(left: 20, right: 20, top: 5, bottom: 5),
                  child: Column(
                      crossAxisAlignment: CrossAxisAlignment.stretch,
                      children: [
                        Text("Work Permit for USA"),
                        Row(children: [
                          Text("Yes"),
                          RadioGroup(
                            value: Yes_No_type.Yes,
                            groupValue: usaPermitState,
                            onChange: (Yes_No_type value) {
                              setState(() {
                                usaPermitState = value;
                              });
                            },
                          ),
                          Text("No"),
                          RadioGroup(
                            value: Yes_No_type.No,
                            groupValue: usaPermitState,
                            onChange: (Yes_No_type value) {
                              setState(() {
                                usaPermitState = value;
                              });
                            },
                          )
                        ])
                      ]))),
        ]);
  }

  Widget _languageWidget(BuildContext context) {
    return Container(
      child: Container(
        child:
            Column(crossAxisAlignment: CrossAxisAlignment.stretch, children: [
          ListView.builder(
              shrinkWrap: true,
              itemCount: languages.length,
              physics: NeverScrollableScrollPhysics(),
              itemBuilder: (BuildContext ctxt, int index) {
                return _language(index);
              }),
        ]),
      ),
    );
  }

  void _addJobmodalBottomSheetMenu() {
    setState(() {
      companyNameControllerTemp = new TextEditingController();
      companyPositionControllerTemp = new TextEditingController();
      companyLocationControllerTemp = new TextEditingController();
      _companyFrom_TempCtrl = new TextEditingController();
      _companyTo_TempCtrl == new TextEditingController();
      companyEmpTypeTemp = null;
      companyEmpTypeTemp = null;
      companyFromtemp = null;
      companyCurrentTemp = false;
    });
    showDialog(
        context: context,
        builder: (context) {
          return StatefulBuilder(builder: (BuildContext context,
              StateSetter setState /*You can rename this!*/) {
            return Container(
              height: MediaQuery.of(context).size.height,
              width: MediaQuery.of(context).size.width,
              child: BackdropFilter(
                  filter: ImageFilter.blur(sigmaX: 10, sigmaY: 10),
                  child: Container(
                    alignment: Alignment.bottomCenter,
                    child: SingleChildScrollView(
                      child: Column(
                        children: <Widget>[
                          new Container(
                            padding: EdgeInsets.all(10),
                            decoration: new BoxDecoration(
                                color: Colors.white,
                                borderRadius: new BorderRadius.only(
                                    topLeft: const Radius.circular(40.0),
                                    topRight: const Radius.circular(40.0))),
                            child: new Container(
                                child: Column(
                              children: <Widget>[
                                Row(
                                  mainAxisAlignment: MainAxisAlignment.end,
                                  children: <Widget>[
                                    Expanded(
                                        child: Divider(color: Colors.white)),
                                    RawMaterialButton(
                                      onPressed: () {
                                        Navigator.pop(context);
                                      },
                                      child: new Icon(
                                        Icons.close,
                                        color: Colors.white,
                                        size: 20.0,
                                      ),
                                      shape: new CircleBorder(),
                                      elevation: 2.0,
                                      fillColor: Colors.grey,
                                      padding: const EdgeInsets.all(0.0),
                                    )
                                  ],
                                ),
                                CustomTouchSearch(
                                  hint: "Organization name",
                                  list: ["Amazon", "Tia tech", "Sterlite Tech"],
                                  onResult: (s) {
                                    setState(() {
                                      companyNameControllerTemp.text = s;
                                    });
                                  },
                                  readonly: true,
                                  controller: companyNameControllerTemp,
                                ),
                                CustomTouchSearch(
                                  hint: "Designation",
                                  list: [
                                    "Product Manager",
                                    "Brand Manager",
                                    "Operation Manager"
                                  ],
                                  onResult: (s) {
                                    setState(() {
                                      companyPositionControllerTemp.text = s;
                                    });
                                  },
                                  readonly: true,
                                  controller: companyPositionControllerTemp,
                                ),
                                CustomDropDown(
                                  hint: "Employement Type",
                                  value: companyEmpTypeTemp,
                                  isEnum: true,
                                  list: Emp_type.values,
                                  onChanged: (s) {
                                    setState(() {
                                      companyEmpTypeTemp = s;
                                    });
                                  },
                                ),
                                CustomTouchSearch(
                                  hint: "Location",
                                  list: ["Amazon", "Tia tech", "Sterlite Tech"],
                                  onResult: (s) {
                                    setState(() {
                                      companyLocationControllerTemp.text = s;
                                    });
                                  },
                                  readonly: true,
                                  controller: companyLocationControllerTemp,
                                ),
                                Material(
                                  child: CheckboxListTile(
                                    title: Text("Current organization"),
                                    value: companyCurrentTemp,
                                    onChanged: (newValue) {
                                      setState(() {
                                        companyCurrentTemp = newValue;
                                      });
                                    },
                                    controlAffinity: ListTileControlAffinity
                                        .leading, //  <-- leading Checkbox
                                  ),
                                ),
                                Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: <Widget>[
                                    Container(
                                        padding: EdgeInsets.only(
                                            top: 10,
                                            bottom: 10,
                                            left: 5.0,
                                            right: 5.0),
                                        width: 150,
                                        child: CustomTextField(
                                          hint: "From",
                                          readonly: true,
                                          onTap: () {
                                            _selectDate(
                                                context, companyFromtemp,
                                                (DateTime d) {
                                              setState(() {
                                                companyFromtemp = d;
                                                _companyFrom_TempCtrl.text =
                                                    d == null
                                                        ? ""
                                                        : monthYearFormatter
                                                            .format(d);
                                              });
                                            });
                                          },
                                          controller: _companyFrom_TempCtrl,
                                        )),
                                    Container(
                                      padding: EdgeInsets.only(
                                          top: 10,
                                          bottom: 10,
                                          left: 5.0,
                                          right: 5.0),
                                      width: 150,
                                      child: CustomTextField(
                                        hint: "To",
                                        readonly: true,
                                        onTap: () {
                                          _selectDate(context, companytoTemp,
                                              (DateTime d) {
                                            setState(() {
                                              companytoTemp = d;
                                              _companyTo_TempCtrl.text =
                                                  d == null
                                                      ? ""
                                                      : monthYearFormatter
                                                          .format(d);
                                            });
                                          });
                                        },
                                        controller: _companyTo_TempCtrl,
                                      ),
                                    ),
                                  ],
                                ),
                                CustomButton(
                                  label: "Add",
                                  icon: Icons.add,
                                  onTap: () {
                                    setState(() {
                                      Map _company = {};
                                      _company[ProfileConstants.COMPANY_NAME] =
                                          companyNameControllerTemp.text;
                                      _company[ProfileConstants
                                              .COMPANY_POSITION] =
                                          companyPositionControllerTemp.text;
                                      _company[ProfileConstants
                                              .COMPANY_LOCATION] =
                                          companyLocationControllerTemp.text;
                                      _company[ProfileConstants
                                              .COMPANY_IS_CURRENT] =
                                          companyCurrentTemp;
                                      _company[ProfileConstants
                                              .COMPANY_EMPLOYE_TYPE] =
                                          EnumToString.parseCamelCase(
                                              companyEmpTypeTemp);
                                      _company[ProfileConstants.COMPANY_FROM] =
                                          _companyFrom_TempCtrl.text;
                                      _company[ProfileConstants.COMPANY_TO] =
                                          _companyTo_TempCtrl.text;
                                      var _index = companies.length;
                                      companies.add(_company);
                                      _professional_listKey.currentState
                                          .insertItem(
                                              _index,
                                              duration:
                                                  Duration(milliseconds: 500));
                                    });
                                    Navigator.pop(context);
                                  },
                                )
                              ],
                            )),
                          ),
                        ],
                      ),
                    ),
                  )),
            );
          });
        });
  }

  void showDialoga() {
    showGeneralDialog(
        barrierColor: Colors.black.withOpacity(0.5),
        transitionBuilder: (context, a1, a2, widget) {
          final curvedValue = Curves.easeInOutBack.transform(a1.value) - 1.0;
          return Transform(
            transform: Matrix4.translationValues(0.0, curvedValue * 200, 0.0),
            child: Opacity(
              opacity: a1.value,
              child: AlertDialog(
                shape: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(16.0)),
                title: Text('Hello!!'),
                content: Text('How are you?'),
              ),
            ),
          );
        },
        transitionDuration: Duration(milliseconds: 200),
        barrierDismissible: true,
        barrierLabel: '',
        context: context,
        pageBuilder: (context, animation1, animation2) {});
  }

  void _addLanguagemodalBottomSheetMenu() {
    setState(() {
      languageNameTemp = new TextEditingController();
      speakTemp = false;
      readTemp = false;
      writeTemp = false;
    });
    showDialog(
        context: context,
        builder: (context) {
          return StatefulBuilder(builder: (BuildContext context,
              StateSetter setState /*You can rename this!*/) {
            return Container(
              height: MediaQuery.of(context).size.height,
              width: MediaQuery.of(context).size.width,
              child: BackdropFilter(
                  filter: ImageFilter.blur(sigmaX: 5, sigmaY: 5),
                  child: Container(
                    alignment: Alignment.bottomCenter,
                    child: SingleChildScrollView(
                      child: Column(
                        children: <Widget>[
                          new Container(
                            padding: EdgeInsets.all(10),
                            decoration: new BoxDecoration(
                                color: Colors.white,
                                borderRadius: new BorderRadius.only(
                                    topLeft: const Radius.circular(40.0),
                                    topRight: const Radius.circular(40.0))),
                            child: new Container(
                                child: Column(
                              children: <Widget>[
                                Row(
                                  mainAxisAlignment: MainAxisAlignment.end,
                                  children: <Widget>[
                                    Expanded(
                                        child: Divider(color: Colors.white)),
                                    RawMaterialButton(
                                      onPressed: () {
                                        Navigator.pop(context);
                                      },
                                      child: new Icon(
                                        Icons.close,
                                        color: Colors.white,
                                        size: 20.0,
                                      ),
                                      shape: new CircleBorder(),
                                      elevation: 2.0,
                                      fillColor: Colors.grey,
                                      padding: const EdgeInsets.all(0.0),
                                    )
                                  ],
                                ),
                                Material(
                                  child: CustomTouchSearch(
                                    hint: "Language",
                                    list: [
                                      "Amazon",
                                      "Tia tech",
                                      "Sterlite Tech"
                                    ],
                                    onResult: (s) {
                                      setState(() {
                                        languageNameTemp.text = s;
                                      });
                                    },
                                    readonly: true,
                                    controller: languageNameTemp,
                                  ),
                                ),
                                Material(
                                  child: CheckboxListTile(
                                    title: Text("Speak"),
                                    value: speakTemp,
                                    onChanged: (newValue) {
                                      setState(() {
                                        speakTemp = newValue;
                                      });
                                    },
                                    controlAffinity: ListTileControlAffinity
                                        .leading, //  <-- leading Checkbox
                                  ),
                                ),
                                Material(
                                  child: CheckboxListTile(
                                    title: Text("Read"),
                                    value: readTemp,
                                    onChanged: (newValue) {
                                      setState(() {
                                        readTemp = newValue;
                                      });
                                    },
                                    controlAffinity: ListTileControlAffinity
                                        .leading, //  <-- leading Checkbox
                                  ),
                                ),
                                Material(
                                  child: CheckboxListTile(
                                    title: Text("Write"),
                                    value: writeTemp,
                                    onChanged: (newValue) {
                                      setState(() {
                                        writeTemp = newValue;
                                      });
                                    },
                                    controlAffinity: ListTileControlAffinity
                                        .leading, //  <-- leading Checkbox
                                  ),
                                ),
                                CustomButton(
                                  label: "Add",
                                  icon: Icons.add,
                                  onTap: () {
                                    this.setState(() {
                                      Map language = {};
                                      language[ProfileConstants.LANGUAGE_NAME] =
                                          languageNameTemp.text;
                                      language[ProfileConstants.LANGUAGE_READ] =
                                          readTemp;
                                      language[ProfileConstants
                                          .LANGUAGE_WRITE] = writeTemp;
                                      language[ProfileConstants
                                          .LANGUAGE_SPEAK] = speakTemp;
                                      languages.add(language);
                                    });

                                    Navigator.pop(context);
                                  },
                                )
                              ],
                            )),
                          ),
                        ],
                      ),
                    ),
                  )),
            );
          });
        });
  }

  void _addCollegemodalBottomSheetMenu() {
    setState(() {
      collegeNameControllerTemp = new TextEditingController();
      collegeDegreeControllerTemp = new TextEditingController();
      collegeFieldOfStudyControllerTemp = new TextEditingController();
      _collegeFrom_TempCtrl = new TextEditingController();
      _collegeTo_TempCtrl = new TextEditingController();
      collegeCourseTypeTemp = null;
      collegeFromTemp = null;
      collegeToTemp = null;
    });
    showDialog(
        context: context,
        builder: (context) {
          return StatefulBuilder(
              builder: (BuildContext context, StateSetter setState) {
            return Container(
              height: MediaQuery.of(context).size.height,
              width: MediaQuery.of(context).size.width,
              child: BackdropFilter(
                  filter: ImageFilter.blur(sigmaX: 10, sigmaY: 10),
                  child: Container(
                    alignment: Alignment.bottomCenter,
                    child: SingleChildScrollView(
                      child: Column(
                        children: <Widget>[
                          new Container(
                            padding: EdgeInsets.all(10),
                            decoration: new BoxDecoration(
                                color: Colors.white,
                                borderRadius: new BorderRadius.only(
                                    topLeft: const Radius.circular(40.0),
                                    topRight: const Radius.circular(40.0))),
                            child: new Container(
                                child: Column(
                              children: <Widget>[
                                Row(
                                  mainAxisAlignment: MainAxisAlignment.end,
                                  children: <Widget>[
                                    Expanded(
                                        child: Divider(color: Colors.white)),
                                    RawMaterialButton(
                                      onPressed: () {
                                        Navigator.pop(context);
                                      },
                                      child: new Icon(
                                        Icons.close,
                                        color: Colors.white,
                                        size: 20.0,
                                      ),
                                      shape: new CircleBorder(),
                                      elevation: 2.0,
                                      fillColor: Colors.grey,
                                      padding: const EdgeInsets.all(0.0),
                                    )
                                  ],
                                ),
                                CustomTouchSearch(
                                  hint: "College name",
                                  list: ["Amazon", "Tia tech", "Sterlite Tech"],
                                  onResult: (s) {
                                    setState(() {
                                      collegeNameControllerTemp.text = s;
                                    });
                                  },
                                  readonly: true,
                                  controller: collegeNameControllerTemp,
                                ),
                                CustomTouchSearch(
                                  hint: "Degree",
                                  list: [
                                    "Product Manager",
                                    "Brand Manager",
                                    "Operation Manager"
                                  ],
                                  onResult: (s) {
                                    setState(() {
                                      collegeDegreeControllerTemp.text = s;
                                    });
                                  },
                                  readonly: true,
                                  controller: collegeDegreeControllerTemp,
                                ),
                                CustomTouchSearch(
                                  hint: "Field of study",
                                  list: [
                                    "Product Manager",
                                    "Brand Manager",
                                    "Operation Manager"
                                  ],
                                  onResult: (s) {
                                    setState(() {
                                      collegeFieldOfStudyControllerTemp.text =
                                          s;
                                    });
                                  },
                                  readonly: true,
                                  controller: collegeFieldOfStudyControllerTemp,
                                ),
                                CustomDropDown(
                                  hint: "Course Type",
                                  value: collegeCourseTypeTemp,
                                  isEnum: true,
                                  list: Course_type.values,
                                  onChanged: (s) {
                                    setState(() {
                                      collegeCourseTypeTemp = s;
                                    });
                                  },
                                ),
                                Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: <Widget>[
                                    Container(
                                        padding: EdgeInsets.only(
                                            top: 10,
                                            bottom: 10,
                                            left: 5.0,
                                            right: 5.0),
                                        width: 150,
                                        child: CustomTextField(
                                          hint: "From",
                                          readonly: true,
                                          onTap: () {
                                            _selectDate(
                                                context, collegeFromTemp,
                                                (DateTime d) {
                                              setState(() {
                                                collegeFromTemp = d;
                                                _collegeFrom_TempCtrl.text =
                                                    d == null
                                                        ? ""
                                                        : monthYearFormatter
                                                            .format(d);
                                              });
                                            });
                                          },
                                          controller: _collegeFrom_TempCtrl,
                                        )),
                                    Container(
                                      padding: EdgeInsets.only(
                                          top: 10,
                                          bottom: 10,
                                          left: 5.0,
                                          right: 5.0),
                                      width: 150,
                                      child: CustomTextField(
                                        hint: "To",
                                        readonly: true,
                                        onTap: () {
                                          _selectDate(context, collegeToTemp,
                                              (DateTime d) {
                                            setState(() {
                                              collegeToTemp = d;
                                              _collegeTo_TempCtrl.text =
                                                  d == null
                                                      ? ""
                                                      : monthYearFormatter
                                                          .format(d);
                                            });
                                          });
                                        },
                                        controller: _collegeTo_TempCtrl,
                                      ),
                                    ),
                                  ],
                                ),
                                CustomButton(
                                  label: "Add",
                                  icon: Icons.add,
                                  onTap: () {
                                    setState(() {
                                      Map _college = {};
                                      _college[ProfileConstants.COLLEGE_NAME] =
                                          collegeNameControllerTemp.text;
                                      _college[
                                              ProfileConstants.COLLEGE_DEGREE] =
                                          collegeDegreeControllerTemp.text;
                                      _college[ProfileConstants
                                              .COLLEGE_FIELD_OF_STUDY] =
                                          collegeFieldOfStudyControllerTemp
                                              .text;
                                      _college[ProfileConstants
                                              .COLLEGE_COURSE_TYPE] =
                                          EnumToString.parseCamelCase(
                                              collegeCourseTypeTemp);
                                      _college[ProfileConstants.COLLEGE_FROM] =
                                          _collegeFrom_TempCtrl.text;
                                      _college[ProfileConstants.COLLEGE_TO] =
                                          _collegeTo_TempCtrl.text;
                                      var _index = colleges.length;
                                      colleges.add(_college);
                                      _educational_listKey.currentState
                                          .insertItem(_index,
                                              duration:
                                                  Duration(milliseconds: 500));
                                    });
                                    Navigator.pop(context);
                                  },
                                )
                              ],
                            )),
                          ),
                        ],
                      ),
                    ),
                  )),
            );
          });
        });
  }
}

class RadioGroup extends StatelessWidget {
  final groupValue;
  final value;
  final onChange;

  const RadioGroup({this.groupValue, this.value, this.onChange});

  @override
  Widget build(BuildContext context) {
    return Radio(
      value: value,
      groupValue: groupValue,
      onChanged: (value) {
        onChange(value);
      },
    );
  }
}

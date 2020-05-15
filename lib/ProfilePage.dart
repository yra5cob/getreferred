import 'package:flutter/material.dart';
import 'package:ReferAll/BLoc/ProfileProvider.dart';
import 'package:ReferAll/constants/ProfileConstants.dart';
import 'package:ReferAll/helper/UiUtilt.dart';
import 'package:ReferAll/model/ProfileModel.dart';
import 'package:ReferAll/profileCreationPage.dart';
import 'package:line_awesome_icons/line_awesome_icons.dart';
import 'package:provider/provider.dart';

class ProfilePage extends StatefulWidget {
  @override
  _ProfilePageState createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {
  static double avatarMaximumRadius = 40.0;
  static double avatarMinimumRadius = 15.0;
  double avatarRadius = avatarMaximumRadius;
  double expandedHeader = 130.0;
  double translate = -avatarMaximumRadius;
  bool isExpanded = true;
  double offset = 0.0;

  Widget _getPersonal(ProfileModel _profile) {
    return Container(
      margin: EdgeInsets.symmetric(horizontal: 10, vertical: 10),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          Text(
            _profile.getModel[ProfileConstants.NAME]
                    [ProfileConstants.FIRST_NAME] +
                " " +
                _profile.getModel[ProfileConstants.NAME]
                    [ProfileConstants.LAST_NAME],
            style: TextStyle(
                fontSize: 20, height: 1.38, fontWeight: FontWeight.w500),
          ),
          Text(
            _profile.getModel[ProfileConstants.HEADLINE],
            style: TextStyle(
              fontSize: 16,
              height: 1.38,
              color: Colors.grey,
            ),
          ),
          Row(
            children: <Widget>[
              UIUtil.getMasked(LineAwesomeIcons.map_marker, size: 12),
              SizedBox(
                width: 5,
              ),
              Text(
                _profile.getModel[ProfileConstants.CURRENT_LOCATION],
                style: TextStyle(
                  fontSize: 12,
                  height: 1.38,
                  color: Colors.grey,
                ),
              )
            ],
          ),
          SizedBox(
            height: 10,
          ),
          Divider(
            color: Colors.grey,
          ),
          SizedBox(
            height: 10,
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: <Widget>[
              Text("Personal",
                  style: Theme.of(context).textTheme.title.merge(
                        TextStyle(
                            fontWeight: FontWeight.bold,
                            foreground: UIUtil.getTextGradient()),
                      )),
              IconButton(
                  icon: Icon(
                    Icons.edit,
                    color: Colors.cyan,
                  ),
                  onPressed: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) => ProfileCreationPage(
                                isedit: true,
                              )),
                    );
                  })
            ],
          ),
          SizedBox(
            height: 10,
          ),
          _getPersonalInfoItem(LineAwesomeIcons.envelope,
              _profile.getModel[ProfileConstants.EMAIL], "Email"),
          SizedBox(
            height: 10,
          ),
          _getPersonalInfoItem(LineAwesomeIcons.phone,
              _profile.getModel[ProfileConstants.PHONE], "Phone"),
          SizedBox(
            height: 10,
          ),
          _getPersonalInfoItem(LineAwesomeIcons.user,
              _profile.getModel[ProfileConstants.GENDER], "Gender"),
          SizedBox(
            height: 10,
          ),
          _getPersonalInfoItem(
              LineAwesomeIcons.map_signs,
              _profile.getModel[ProfileConstants.PREFERRED_LOCATION],
              "Location Preferrence"),
          SizedBox(
            height: 10,
          ),
          _getPersonalInfoItem(LineAwesomeIcons.industry,
              _profile.getModel[ProfileConstants.INDUSTRY], "Industry"),
          SizedBox(
            height: 10,
          ),
          _getPersonalInfoItem(
              LineAwesomeIcons.gears,
              _profile.getModel[ProfileConstants.FUNCTIONAL_AREA],
              "Functional Area"),
        ],
      ),
    );
  }

  Widget _getCareer(ProfileModel _profile) {
    return Container(
      margin: EdgeInsets.symmetric(horizontal: 10, vertical: 10),
      child: Container(
        child:
            Column(crossAxisAlignment: CrossAxisAlignment.stretch, children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: <Widget>[
              Text("Experience",
                  style: Theme.of(context).textTheme.title.merge(
                        TextStyle(
                            fontWeight: FontWeight.bold,
                            foreground: UIUtil.getTextGradient()),
                      )),
              IconButton(
                  icon: Icon(
                    Icons.edit,
                    color: Colors.cyan,
                  ),
                  onPressed: () {})
            ],
          ),
          SizedBox(
            height: 10,
          ),
          ListView.builder(
              shrinkWrap: true,
              itemCount: _profile.getModel[ProfileConstants.CAREER].length,
              physics: NeverScrollableScrollPhysics(),
              itemBuilder: (BuildContext ctxt, int index) {
                return _company(
                    index, _profile.getModel[ProfileConstants.CAREER]);
              }),
        ]),
      ),
    );
  }

  Widget _company(int index, List companies) {
    return Container(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: <Widget>[
          ListTile(
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
          ),
          Divider(
            color: Colors.grey,
          )
        ],
      ),
    );
  }

  Widget _getLanguage(ProfileModel _profile) {
    return Container(
      margin: EdgeInsets.symmetric(horizontal: 10, vertical: 10),
      child: Container(
        child:
            Column(crossAxisAlignment: CrossAxisAlignment.stretch, children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: <Widget>[
              Text("Language",
                  style: Theme.of(context).textTheme.title.merge(
                        TextStyle(
                            fontWeight: FontWeight.bold,
                            foreground: UIUtil.getTextGradient()),
                      )),
              IconButton(
                  icon: Icon(
                    Icons.edit,
                    color: Colors.cyan,
                  ),
                  onPressed: () {})
            ],
          ),
          SizedBox(
            height: 10,
          ),
          ListView.builder(
              shrinkWrap: true,
              itemCount: _profile.getModel[ProfileConstants.LANGUAGE].length,
              physics: NeverScrollableScrollPhysics(),
              itemBuilder: (BuildContext ctxt, int index) {
                return _language(
                    index, _profile.getModel[ProfileConstants.LANGUAGE]);
              }),
        ]),
      ),
    );
  }

  Widget _language(int index, List languages) {
    return Container(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: <Widget>[
          ListTile(
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
          ),
          Divider(
            color: Colors.grey,
          )
        ],
      ),
    );
  }

  Widget _getAdditionalInfo(ProfileModel _profile) {
    return Container(
      margin: EdgeInsets.symmetric(horizontal: 10, vertical: 10),
      child: Column(
        children: <Widget>[
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: <Widget>[
              Text("Additional Information",
                  style: Theme.of(context).textTheme.title.merge(
                        TextStyle(
                            fontWeight: FontWeight.bold,
                            foreground: UIUtil.getTextGradient()),
                      )),
              IconButton(
                  icon: Icon(
                    Icons.edit,
                    color: Colors.cyan,
                  ),
                  onPressed: () {})
            ],
          ),
          ListView(
              physics: NeverScrollableScrollPhysics(),
              shrinkWrap: true,
              children: <Widget>[
                Container(
                    padding:
                        EdgeInsets.only(left: 20, right: 20, top: 5, bottom: 5),
                    child: Column(
                        crossAxisAlignment: CrossAxisAlignment.stretch,
                        children: [
                          Text("Have you handled a team?",
                              style:
                                  TextStyle(height: 1.38, color: Colors.grey)),
                          Text(
                            _profile.getModel[ProfileConstants.ADDITIONAL_INFO]
                                [ProfileConstants.HANDLED_TEAM],
                            style: TextStyle(
                                height: 1.38,
                                fontSize: 16,
                                fontWeight: FontWeight.w500),
                          ),
                        ])),
                Container(
                    padding:
                        EdgeInsets.only(left: 20, right: 20, top: 5, bottom: 5),
                    child: Column(
                        crossAxisAlignment: CrossAxisAlignment.stretch,
                        children: [
                          Text("Are you willing to work 6 days a week?",
                              style:
                                  TextStyle(height: 1.38, color: Colors.grey)),
                          Text(
                              _profile.getModel[
                                      ProfileConstants.ADDITIONAL_INFO]
                                  [ProfileConstants.SIX_DAYS_WEEK],
                              style: TextStyle(
                                  height: 1.38,
                                  fontSize: 16,
                                  fontWeight: FontWeight.w500)),
                        ])),
                Container(
                    padding:
                        EdgeInsets.only(left: 20, right: 20, top: 5, bottom: 5),
                    child: Column(
                        crossAxisAlignment: CrossAxisAlignment.stretch,
                        children: [
                          Text("Are you willing to relocate?",
                              style:
                                  TextStyle(height: 1.38, color: Colors.grey)),
                          Text(
                              _profile.getModel[ProfileConstants
                                  .ADDITIONAL_INFO][ProfileConstants.RELOCATE],
                              style: TextStyle(
                                  height: 1.38,
                                  fontSize: 16,
                                  fontWeight: FontWeight.w500)),
                        ])),
                Container(
                    padding:
                        EdgeInsets.only(left: 20, right: 20, top: 5, bottom: 5),
                    child: Column(
                        crossAxisAlignment: CrossAxisAlignment.stretch,
                        children: [
                          Text(
                              "Are you open to joining an early stage start-up?",
                              style:
                                  TextStyle(height: 1.38, color: Colors.grey)),
                          Text(
                              _profile.getModel[
                                      ProfileConstants.ADDITIONAL_INFO]
                                  [ProfileConstants.EARLY_STAGE_STARTUP],
                              style: TextStyle(
                                  height: 1.38,
                                  fontSize: 16,
                                  fontWeight: FontWeight.w500)),
                        ])),
                Container(
                    padding:
                        EdgeInsets.only(left: 20, right: 20, top: 5, bottom: 5),
                    child: Column(
                        crossAxisAlignment: CrossAxisAlignment.stretch,
                        children: [
                          Text("Willingness to Travel?",
                              style:
                                  TextStyle(height: 1.38, color: Colors.grey)),
                          Text(
                              _profile.getModel[
                                      ProfileConstants.ADDITIONAL_INFO]
                                  [ProfileConstants.TRAVEL_WILLINGNESS],
                              style: TextStyle(
                                  height: 1.38,
                                  fontSize: 16,
                                  fontWeight: FontWeight.w500)),
                        ])),
                Container(
                    padding:
                        EdgeInsets.only(left: 20, right: 20, top: 5, bottom: 5),
                    child: Column(
                        crossAxisAlignment: CrossAxisAlignment.stretch,
                        children: [
                          Text("Work Permit for USA",
                              style:
                                  TextStyle(height: 1.38, color: Colors.grey)),
                          Text(
                              _profile.getModel[
                                      ProfileConstants.ADDITIONAL_INFO]
                                  [ProfileConstants.USA_PREMIT],
                              style: TextStyle(
                                  height: 1.38,
                                  fontSize: 16,
                                  fontWeight: FontWeight.w500)),
                        ])),
              ]),
        ],
      ),
    );
  }

  Widget _resume(ProfileModel _profile) {
    return Container(
      margin: EdgeInsets.all(10),
      child: Column(
        children: <Widget>[
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: <Widget>[
              Text("Resume",
                  style: Theme.of(context).textTheme.title.merge(
                        TextStyle(
                            fontWeight: FontWeight.bold,
                            foreground: UIUtil.getTextGradient()),
                      )),
              IconButton(
                  icon: Icon(
                    Icons.edit,
                    color: Colors.cyan,
                  ),
                  onPressed: () {})
            ],
          ),
          Container(
            margin: EdgeInsets.symmetric(vertical: 10),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: <Widget>[
                _profile.getModel[ProfileConstants.RESUME] == ''
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
                            child: Padding(
                              padding: const EdgeInsets.symmetric(
                                  vertical: 10, horizontal: 10),
                              child: Text(
                                _profile.getModel[ProfileConstants.RESUME],
                                style: TextStyle(
                                    color: Colors.cyan,
                                    fontStyle: FontStyle.italic,
                                    fontSize: 16),
                              ),
                            ),
                          ),
                        ),
                      ),
                SizedBox(
                  height: 10,
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _getEducation(ProfileModel _profile) {
    return Container(
      margin: EdgeInsets.symmetric(horizontal: 10, vertical: 10),
      child: Container(
        child:
            Column(crossAxisAlignment: CrossAxisAlignment.stretch, children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: <Widget>[
              Text("Education",
                  style: Theme.of(context).textTheme.title.merge(
                        TextStyle(
                            fontWeight: FontWeight.bold,
                            foreground: UIUtil.getTextGradient()),
                      )),
              IconButton(
                  icon: Icon(
                    Icons.edit,
                    color: Colors.cyan,
                  ),
                  onPressed: () {})
            ],
          ),
          SizedBox(
            height: 10,
          ),
          ListView.builder(
              shrinkWrap: true,
              itemCount: _profile.getModel[ProfileConstants.ACADEMICS].length,
              physics: NeverScrollableScrollPhysics(),
              itemBuilder: (BuildContext ctxt, int index) {
                return _college(
                    index, _profile.getModel[ProfileConstants.ACADEMICS]);
              }),
        ]),
      ),
    );
  }

  Widget _college(int index, List colleges) {
    return Container(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: <Widget>[
          ListTile(
            leading:
                UIUtil.getMasked(LineAwesomeIcons.graduation_cap, size: 40),
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
          ),
          Divider(
            color: Colors.grey,
          )
        ],
      ),
    );
  }

  _getPersonalInfoItem(IconData icon, String data, String label) {
    return Row(
      children: <Widget>[
        UIUtil.getMasked(icon),
        SizedBox(
          width: 10,
        ),
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            Text(
              data,
              style: TextStyle(
                fontSize: 16,
                height: 1.38,
                fontWeight: FontWeight.w500,
                color: Colors.black,
              ),
            ),
            Text(
              label,
              style: TextStyle(
                fontSize: 12,
                height: 1.38,
                color: Colors.grey,
              ),
            )
          ],
        ),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    final _profile = Provider.of<ProfileProvider>(context).getProfile();
    return SafeArea(
      child: Scaffold(
        backgroundColor: Colors.white,
        body: NotificationListener<ScrollUpdateNotification>(
          onNotification: (scrollNotification) {
            final pixels = scrollNotification.metrics.pixels;

            // check if scroll is vertical ( left to right OR right to left)
            final scrollTabs = (scrollNotification.metrics.axisDirection ==
                    AxisDirection.right ||
                scrollNotification.metrics.axisDirection == AxisDirection.left);

            if (!scrollTabs) {
              // and here prevents animation of avatar when you scroll tabs
              if (expandedHeader - pixels <= kToolbarHeight) {
                if (isExpanded) {
                  translate = 0.0;
                  setState(() {
                    isExpanded = false;
                  });
                }
              } else {
                translate = -avatarMaximumRadius + pixels;
                if (translate > 0) {
                  translate = 0.0;
                }
                if (!isExpanded) {
                  setState(() {
                    isExpanded = true;
                  });
                }
              }

              offset = pixels * 0.4;

              final newSize = (avatarMaximumRadius - offset);

              setState(() {
                if (newSize < avatarMinimumRadius) {
                  avatarRadius = avatarMinimumRadius;
                } else if (newSize > avatarMaximumRadius) {
                  avatarRadius = avatarMaximumRadius;
                } else {
                  avatarRadius = newSize;
                }
              });
            }
            return false;
          },
          child: CustomScrollView(
            physics: ClampingScrollPhysics(),
            slivers: <Widget>[
              SliverAppBar(
                title: isExpanded
                    ? Container()
                    : Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: <Widget>[
                          Text(
                            _profile.getModel[ProfileConstants.NAME]
                                    [ProfileConstants.FIRST_NAME] +
                                " " +
                                _profile.getModel[ProfileConstants.NAME]
                                    [ProfileConstants.LAST_NAME],
                            style: TextStyle(
                                fontSize: 16,
                                height: 1.38,
                                fontWeight: FontWeight.w500),
                          ),
                          Text(
                            _profile.getModel[ProfileConstants.HEADLINE],
                            style: TextStyle(
                              fontSize: 14,
                              height: 1.38,
                              color: Colors.grey,
                            ),
                          ),
                        ],
                      ),
                expandedHeight: expandedHeader,
                backgroundColor: Colors.grey,
                leading: Container(
                  margin: EdgeInsets.all(4),
                  child: BackButton(
                    color: isExpanded ? Colors.white : Colors.cyan,
                  ),
                ),
                pinned: true,
                elevation: 5.0,
                forceElevated: true,
                flexibleSpace: Container(
                  decoration: BoxDecoration(
                      color: isExpanded ? Colors.transparent : Colors.white,
                      image: isExpanded
                          ? DecorationImage(
                              fit: BoxFit.cover,
                              alignment: Alignment.bottomCenter,
                              image: AssetImage("assets/images/banner.jpg"))
                          : null),
                  child: Align(
                    alignment: Alignment.bottomLeft,
                    child: isExpanded
                        ? Transform(
                            transform: Matrix4.identity()
                              ..translate(0.0, avatarMaximumRadius),
                            child: MyAvatar(
                              size: avatarRadius,
                            ),
                          )
                        : SizedBox.shrink(),
                  ),
                ),
              ),
              SliverToBoxAdapter(
                child: Padding(
                  padding: const EdgeInsets.only(top: 10.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisAlignment: MainAxisAlignment.center,
                    mainAxisSize: MainAxisSize.min,
                    children: <Widget>[
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: <Widget>[
                          isExpanded
                              ? SizedBox(
                                  height: avatarMinimumRadius * 2,
                                )
                              : MyAvatar(
                                  size: avatarMinimumRadius,
                                ),
                          Padding(
                            padding: const EdgeInsets.only(right: 10.0),
                            child: Container(
                              padding: EdgeInsets.symmetric(
                                  vertical: 5.0, horizontal: 10.0),
                              decoration: BoxDecoration(
                                color: Colors.lightBlue,
                                borderRadius: BorderRadius.circular(10.0),
                              ),
                              child: Text(
                                "Following",
                                style: TextStyle(
                                    fontSize: 17.0, color: Colors.white),
                              ),
                            ),
                          )
                        ],
                      ),
                      Container(),
                    ],
                  ),
                ),
              ),
              // SliverPersistentHeader(
              //   pinned: true,
              //   delegate: TwitterTabs(50.0),
              // ),
              new SliverList(
                  delegate: new SliverChildListDelegate([
                _getPersonal(_profile),
                _getEducation(_profile),
                _getCareer(_profile),
                _getLanguage(_profile),
                _getAdditionalInfo(_profile),
                _resume(_profile)
              ]))
            ],
          ),
        ),
      ),
    );
  }
}

class MyAvatar extends StatelessWidget {
  final double size;

  const MyAvatar({Key key, this.size}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(left: 8.0),
      child: DecoratedBox(
        decoration: BoxDecoration(
            border: Border.all(
              color: Colors.white,
              width: 2.0,
            ),
            shape: BoxShape.circle),
        child: Padding(
          padding: const EdgeInsets.all(2.0),
          child: CircleAvatar(
            radius: size,
            backgroundImage: AssetImage("assets/images/profile.png"),
          ),
        ),
      ),
    );
  }
}

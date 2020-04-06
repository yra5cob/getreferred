import 'package:flutter/material.dart';
import 'package:flutter_signin_button/flutter_signin_button.dart';
import 'package:getreferred/registerPage.dart';

final globalKey = GlobalKey<ScaffoldState>();

class LoginPage extends StatefulWidget {
  @override
  _LoginPageState createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        key: globalKey,
        body: Container(
            child: ListView(children: <Widget>[
          SizedBox(height: 0.0),
          Container(
            width: 250,
            height: 250,
            child: Image.asset('assets/images/logo.jpg'),
          ),
          SizedBox(height: 60.0),
          Padding(
            padding: EdgeInsets.only(top: 15.0, left: 20.0),
            child: Text(
              "Welcome!",
              style: TextStyle(
                fontFamily: 'Montserrat',
                fontSize: 40,
                fontWeight: FontWeight.bold,
                color: Color(0xff000000),
              ), //textstyle
            ),
          ), //padding
          Padding(
            padding: EdgeInsets.only(top: 5.0, left: 20.0),
            child: Text(
              "Please sign in to your account",
              style: TextStyle(
                fontFamily: 'Montserrat',
                fontSize: 22,
                fontWeight: FontWeight.w200,
                color: Color(0xff000000),
              ), //textstyle
            ),
          ), //padding
          Padding(
              padding: EdgeInsets.only(top: 40.0, left: 20.0, right: 20.0),
              child: Material(
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(50.0)),
                elevation: 2.0,
                shadowColor: Color(0xff000000),
                child: TextField(
                    obscureText: false,
                    decoration: InputDecoration(
                      contentPadding: EdgeInsets.only(
                          left: 15, bottom: 11, top: 11, right: 15),
                      border: InputBorder.none,
                      labelText: 'Email',
                    )), //Textfiled
              ) //Material
              ), //Padding
          Padding(
              padding: EdgeInsets.only(top: 40.0, left: 20.0, right: 20.0),
              child: Material(
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(50.0)),
                elevation: 2.0,
                shadowColor: Color(0xff000000),
                child: TextField(
                    obscureText: true,
                    decoration: InputDecoration(
                      contentPadding: EdgeInsets.only(
                          left: 15, bottom: 11, top: 11, right: 15),
                      border: InputBorder.none,
                      labelText: 'Password',
                    )), //Textfiled
              ) //Material
              ), //Padding
          Container(
              margin: EdgeInsets.only(
                  top: 40.0,
                  left: MediaQuery.of(context).size.width * 0.60,
                  right: 20.0),
              width: 164,
              height: 48,
              decoration: BoxDecoration(
                color: Colors.blue,
                borderRadius: BorderRadius.circular(23),
                boxShadow: [
                  BoxShadow(
                    offset: const Offset(0, 3),
                    blurRadius: 6,
                    color: const Color(0xff000000).withOpacity(0.16),
                  )
                ],
              ),
              child: InkWell(
                  onTap: () {
                    final snackBar = SnackBar(content: Text('Login pressed'));
                    globalKey.currentState.showSnackBar(snackBar);
                  },
                  child: Container(
                      color: Colors.blue,
                      margin: EdgeInsets.only(right: 30.0, left: 30),
                      child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text(
                              "Login",
                              style: TextStyle(color: Colors.white),
                            ),
                            Icon(
                              Icons.arrow_forward,
                              color: Colors.white,
                              size: 30.0,
                            )
                          ])))), //container
          Container(
            margin: EdgeInsets.all(30),
            width: MediaQuery.of(context).size.width,
            height: 50,
            child: Row(children: [
              Expanded(
                child: Divider(
                  color: Colors.black,
                ),
              ),
              Container(
                margin: EdgeInsets.only(left: 10, right: 10),
                child: Text("OR"),
              ),
              Expanded(
                child: Divider(
                  color: Colors.black,
                ),
              )
            ]),
          ),
          Container(
            padding: EdgeInsets.only(right: 30, left: 30),
            child: SignInButton(
              Buttons.Google,
              onPressed: () {
                final snackBar = SnackBar(content: Text('Google login'));
                globalKey.currentState.showSnackBar(snackBar);
              },
            ),
          ),
          Container(
            padding: EdgeInsets.only(right: 30, left: 30),
            child: SignInButton(
              Buttons.LinkedIn,
              onPressed: () {
                final snackBar = SnackBar(content: Text('Google login'));
                globalKey.currentState.showSnackBar(snackBar);
              },
            ),
          )
        ]) //listview

            ), //Column
        bottomNavigationBar: BottomAppBar(
            elevation: 0,
            child: Container(
                height: 30,
                child: Padding(
                    padding: EdgeInsets.only(bottom: 0.0),
                    child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Text("Not a member yet?",
                              style: TextStyle(
                                fontFamily: 'Montserrat',
                                fontSize: 18,
                                fontWeight: FontWeight.w300,
                                color: Color(0xff000000),
                              )),
                          InkWell(
                            child: Text(" Register",
                                style: TextStyle(
                                  fontFamily: 'Montserrat',
                                  fontSize: 18,
                                  fontWeight: FontWeight.bold,
                                  color: Color(0xff000000),
                                )),
                            onTap: () {
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                    builder: (context) => RegisterPage()),
                              );
                            },
                          )
                        ]))))); //scaffold
  }
}

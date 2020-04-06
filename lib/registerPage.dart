import 'package:flutter/material.dart';
import 'AnimatedListSample.dart';
import 'package:getreferred/profileCreationPage.dart';

final globalKey = GlobalKey<ScaffoldState>();
final GlobalKey<FormState> _form = GlobalKey<FormState>();
final TextEditingController _pass = TextEditingController();
final TextEditingController _confirmPass = TextEditingController();

class RegisterPage extends StatefulWidget {
  @override
  _RegisterPageState createState() => _RegisterPageState();
}

class _RegisterPageState extends State<RegisterPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        key: globalKey,
        body: ListView(
          children: <Widget>[
            Padding(
                padding: EdgeInsets.all(10),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: <Widget>[
                    IconButton(
                      icon: Icon(Icons.arrow_back_ios),
                      color: Colors.black,
                      onPressed: () {
                        Navigator.pop(context);
                      },
                    ),
                    Text(
                      'Register',
                      style:
                          TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                    ),
                    IconButton(
                      icon: Icon(Icons.help),
                      color: Colors.black,
                      onPressed: () {},
                    ),
                  ],
                )),
            Container(
              width: 250,
              height: MediaQuery.of(context).size.height * 0.20,
              child: Image.asset('assets/images/image_01.png'),
            ),
            Container(
              padding: EdgeInsets.only(left: 10, right: 10),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  Container(
                    height: MediaQuery.of(context).size.height * 0.60,
                    padding: EdgeInsets.only(left: 30, right: 30),
                    decoration: BoxDecoration(
                      color: Colors.transparent,
                      borderRadius: BorderRadius.circular(15),
                    ),
                    child: Form(
                        key: _form,
                        child: ListView(
                          shrinkWrap: true,
                          children: <Widget>[
                            Column(
                              mainAxisSize: MainAxisSize.min,
                              children: <Widget>[
                                _buildEmailField(),
                                _buildPasswordField(),
                                _buildConfirmPasswordField(),
                                _buildSubmitButton(context)
                              ],
                            )
                          ],
                        )),
                  )
                ],
              ),
            )
          ],
        ));
  }
}

Widget _buildEmailField() {
  return Padding(
      padding: EdgeInsets.only(top: 30, left: 10.0, right: 10.0),
      child: Material(
        shape:
            RoundedRectangleBorder(borderRadius: BorderRadius.circular(50.0)),
        elevation: 2.0,
        shadowColor: Color(0xff000000),
        child: TextField(
            obscureText: false,
            decoration: InputDecoration(
              contentPadding:
                  EdgeInsets.only(left: 35, bottom: 5, top: 5, right: 15),
              border: InputBorder.none,
              labelText: 'Email',
            )), //Textfiled
      ) //Material
      );
}

Widget _buildPasswordField() {
  return Padding(
      padding: EdgeInsets.only(top: 30, left: 10.0, right: 10.0),
      child: Material(
        shape:
            RoundedRectangleBorder(borderRadius: BorderRadius.circular(50.0)),
        elevation: 2.0,
        shadowColor: Color(0xff000000),
        child: TextFormField(
            controller: _pass,
            obscureText: true,
            validator: (val) {
              if (val.isEmpty) return 'Password is empty';
              return null;
            },
            decoration: InputDecoration(
              contentPadding:
                  EdgeInsets.only(left: 35, bottom: 5, top: 5, right: 15),
              border: InputBorder.none,
              labelText: 'Password',
            )), //Textfiled
      ) //Material
      );
}

Widget _buildSubmitButton(BuildContext _context) {
  return Padding(
      padding: EdgeInsets.only(top: 50),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.end,
        children: <Widget>[
          InkWell(
              onTap: () {
                _form.currentState.validate();
                Navigator.push(
                  _context,
                  MaterialPageRoute(
                      builder: (context) => ProfileCreationPage()),
                );
              },
              child: Container(
                  decoration: BoxDecoration(
                      color: Colors.blue,
                      borderRadius: BorderRadius.circular(50),
                      boxShadow: [
                        BoxShadow(
                          offset: const Offset(0, 3),
                          blurRadius: 6,
                          color: const Color(0xff000000).withOpacity(0.16),
                        )
                      ]),
                  padding:
                      EdgeInsets.only(left: 30, bottom: 10, top: 10, right: 30),
                  child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          "Sign up",
                          style: TextStyle(color: Colors.white, fontSize: 15),
                        ),
                        Icon(
                          Icons.arrow_forward,
                          color: Colors.white,
                          size: 30.0,
                        )
                      ])))
        ],
      ));
}

Widget _buildConfirmPasswordField() {
  return Padding(
      padding: EdgeInsets.only(top: 30, left: 10.0, right: 10.0),
      child: Material(
        shape:
            RoundedRectangleBorder(borderRadius: BorderRadius.circular(50.0)),
        elevation: 2.0,
        shadowColor: Color(0xff000000),
        child: TextFormField(
            controller: _confirmPass,
            obscureText: true,
            validator: (val) {
              if (val.isEmpty) return 'Empty';
              if (val != _pass.text) return 'Password does not match!';
              return null;
            },
            decoration: InputDecoration(
              contentPadding:
                  EdgeInsets.only(left: 35, bottom: 5, top: 5, right: 15),
              border: InputBorder.none,
              labelText: 'Confirm password',
            )), //Textfiled
      ) //Material
      );
}

import 'dart:convert';
import 'package:smart_municipality/constants.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';
import 'package:smart_municipality/screens/authentification/sign_up.dart';
import 'package:smart_municipality/screens/home/home_screen.dart';

import '../form/form_screen.dart';



class SignIn extends StatefulWidget {
  SignIn({Key key, this.title}) : super(key: key);

  final String title;

  @override
  _SignInState createState() => _SignInState();
}


class _SignInState extends State<SignIn> {

  final user_email = TextEditingController();
  final user_password = TextEditingController();

  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  String email;
  String password;
  String errorLogin;
  AutovalidateMode _autoValidate = AutovalidateMode.disabled;





  void _validateInputs() {
    final form = _formKey.currentState;
    if (form.validate()) {
      // Text forms was validated.
      form.save();
    } else {
      setState(() =>   _autoValidate = AutovalidateMode.always);
    }
  }

  String _validateEmail(String value) {
    if (value.isEmpty) {
      // The form is empty
      return "Enter email address";
    }
    // This is just a regular expression for email addresses
    String p = "[a-zA-Z0-9\+\.\_\%\-\+]{1,256}" +
        "\\@" +
        "[a-zA-Z0-9][a-zA-Z0-9\\-]{0,64}" +
        "(" +
        "\\." +
        "[a-zA-Z0-9][a-zA-Z0-9\\-]{0,25}" +
        ")+";
    RegExp regExp = new RegExp(p);

    if (regExp.hasMatch(value)) {
      // So, the email is valid
      return null;
    }

    // The pattern of the email didn't match the regex above.
    return 'Email est non valide';
  }


  Widget _backButton() {
    return InkWell(
      onTap: () {
        Navigator.pop(context);
      },

      child: Container(
        padding: EdgeInsets.symmetric(horizontal: 10),
        child: Row(
          children: <Widget>[
            Container(
              padding: EdgeInsets.only(left: 0, top: 10, bottom: 10),
              child: Icon(Icons.keyboard_arrow_left, color: Colors.black),
            ),
            Text('Retourner',
                style: TextStyle(fontSize: 12, fontWeight: FontWeight.w500))
          ],
        ),
      ),
    );
  }



  onSync() async {
    try {
      var url = Uri.parse('http://10.128.1.62:3000/signin');
      var response = await http.post(url, headers: {
        "Content-Type": "application/json"
      }, body: jsonEncode({
        "email": user_email.text,
        "password": user_password.text,
      }));
      print('Response status: ${response.statusCode}');
      print('Response <body: ${response.body}');
      var jsonObj = json.decode(response.body);
      switch(response.statusCode) {
        case 200: {
          var access_key =  jsonObj['token'];
          var userType =  jsonObj['userType'];
          //print(userType);
          SharedPreferences prefs = await SharedPreferences.getInstance();
          prefs.setString(KEY_ACCESS_TOKEN, access_key);
          switch(userType) {
            case "citizen": {
              Navigator.push(context, MaterialPageRoute(builder: (context) => SignUpPage()));
            }
            break;
            case "admin": {
              Navigator.push(context, MaterialPageRoute(builder: (context) => HomeScreen()));
            }
          }
        }
        break;

        case 422: {
          showDialog(context: context, builder: (BuildContext context){
            return AlertDialog(
              title: Text("Error", textAlign: TextAlign.center,),
              titleTextStyle: TextStyle(fontWeight: FontWeight.bold,color: Colors.black,fontSize: 20,),
              backgroundColor: Colors.white,
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.all(Radius.circular(20))
              ),
              content: Text(jsonObj['error'], textAlign: TextAlign.center,),
            );
          });
        }
        break;

        default: {
          //statements;
        }
        break;
      }

    } catch (e) {
      showDialog(context: context, builder: (BuildContext context){
        return AlertDialog(
          title: Text("Error"),
          titleTextStyle: TextStyle(fontWeight: FontWeight.bold,color: Colors.black,fontSize: 20),
          backgroundColor: Colors.grey,
          shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.all(Radius.circular(20))
          ),
          content: Text(e),
        );
      });
    }
  }


  Widget _entryField() {
    return Container(
      padding: EdgeInsets.all(0),
      margin: EdgeInsets.all(0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          Form(
            key: _formKey,
            child: Column(
              children: <Widget>[

                //email
                TextFormField(
                  autovalidateMode: _autoValidate,
                  controller: user_email,
                  decoration: InputDecoration(
                      border: InputBorder.none,
                      fillColor: Color(0xfff3f3f4),
                      labelText: "Email",
                      hintText: "Enter votre nom",
                      hintStyle: TextStyle(fontSize: 13),
                      helperText: 'must be ..',
                      filled: true),
                  onSaved: (String value) {
                    value = user_email.text;
                  },
                  validator: _validateEmail,
                  keyboardType: TextInputType.emailAddress,
                ),
                //password

                TextFormField(
                  autovalidateMode: _autoValidate,
                  controller: user_password,
                  obscureText: true,
                  decoration: InputDecoration(
                      border: InputBorder.none,
                      fillColor: Color(0xfff3f3f4),
                      labelText: 'Mot de passe',
                      hintText: "Enter votre mot de passe",
                      hintStyle: TextStyle(fontSize: 13),
                      helperText: '6 characteres minimum',
                      filled: true),
                  validator: (password) {

                    if (password.length < 6)
                      return 'trés court';
                    else
                      return null;

                  },
                ),


              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _submitButton() {
    return InkWell(
      onTap: () {
        //_validateInputs();
        onSync();
      },
      child: Container(
        width: MediaQuery.of(context).size.width,
        padding: EdgeInsets.symmetric(vertical: 15),
        alignment: Alignment.center,
        decoration: BoxDecoration(
            borderRadius: BorderRadius.all(Radius.circular(5)),
            boxShadow: <BoxShadow>[
              BoxShadow(
                  color: Colors.grey.shade200,
                  offset: Offset(2, 4),
                  blurRadius: 5,
                  spreadRadius: 2)
            ],
            gradient: LinearGradient(
                begin: Alignment.centerLeft,
                end: Alignment.centerRight,
                colors: [Color(0xfffbb448), Color(0xfff7892b)])),
        child: Text(
          'Continuez',
          style: TextStyle(fontSize: 15, color: Colors.white),
        ),
      ),
    );
  }

  Widget _loginAccountLabel() {
    return Container(
      margin: EdgeInsets.symmetric(vertical: 20),
      alignment: Alignment.bottomCenter,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: <Widget>[
          Text(
            'Vous n\'avez pas de compte ?',
            style: TextStyle(fontSize: 13, fontWeight: FontWeight.w600),
          ),
          SizedBox(
            width: 10,
          ),
          InkWell(
            onTap: () {
              Navigator.push(context, MaterialPageRoute(builder: (context) => SignUp()));
            },
            child: Text(
              'Inscivez-vous',
              style: TextStyle(
                  color: Color(0xfff79c4f),
                  fontSize: 13,
                  fontWeight: FontWeight.w600),
            ),
          )
        ],
      ),
    );
  }

  Widget _title() {
    return RichText(
      textAlign: TextAlign.center,
      text: TextSpan(
        text: 'Connectez-vous',
        style: TextStyle(color: Color(0xffe46b10), fontSize: 30),
      ),
    );
  }

  Widget _emailPasswordWidget() {
    return Container(
      alignment: Alignment.center,
      padding: EdgeInsets.all(10),
      height: MediaQuery.of(context).size.width/1.3,
      decoration: BoxDecoration(
          borderRadius: BorderRadius.all(Radius.circular(5)),
          boxShadow: <BoxShadow>[
            BoxShadow(
                color: Colors.grey.shade200,
                offset: Offset(2, 4),
                blurRadius: 5,
                spreadRadius: 2)
          ],
          gradient: LinearGradient(
              begin: Alignment.centerLeft,
              end: Alignment.centerRight,
              colors: [Color(0xffffffff), Color(0xffffffff)])),
      child: ListView(
        //padding: EdgeInsets.all(10),
        children: <Widget>[
          _entryField(),

        ],
      ),

    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: SingleChildScrollView(
            child: Container(
              height: MediaQuery.of(context).size.height,
              child: Stack(
                children: <Widget>[
                  Container(
                    padding: EdgeInsets.symmetric(horizontal: 15),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: <Widget>[
                        Expanded(
                          flex: 1,
                          child: SizedBox(),
                        ),
                        _title(),
                        SizedBox(height: 50),
                        _emailPasswordWidget(),
                        SizedBox(
                          height: 60,
                        ),
                        _submitButton(),
                        Expanded(
                          flex: 1,
                          child: SizedBox(),
                        )
                      ],
                    ),
                  ),
                  Align(
                    alignment: Alignment.bottomCenter,
                    child: _loginAccountLabel(),
                  ),
                  Positioned(top: 40, left: 0, child: _backButton()),
                  /*Positioned(
                      top: -MediaQuery.of(context).size.height * .15,
                      right: -MediaQuery.of(context).size.width * .4,
                      child: BezierContainer())*/
                ],
              ),
            )));
  }
}

@override
Widget build(BuildContext context) {

  return null;
}

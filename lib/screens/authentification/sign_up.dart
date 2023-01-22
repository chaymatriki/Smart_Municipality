import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';
import 'package:smart_municipality/screens/home/home_screen.dart';

import '../../constants.dart';



class SignUp extends StatefulWidget {
  SignUp({Key key, this.title}) : super(key: key);

  final String title;

  @override
  _SignUpState createState() => _SignUpState();
}

enum UserType { admin , citizen }

class _SignUpState extends State<SignUp> {
  final user_lastName = TextEditingController();
  final user_firstName = TextEditingController();
  final user_email = TextEditingController();
  final user_password = TextEditingController();
  final user_cin = TextEditingController();
  final user_phone = TextEditingController();
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  String email;
  String password;
  UserType _userType = UserType.citizen;
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
    /*var url = Uri.parse('http://192.168.1.52:3000/signup');
    //var authToken = 'eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJfaWQiOiI2M2ExODdlNWQzOTdjZWFkNTMwNGJkZjAiLCJpYXQiOjE2NzE5MDIzMDV9.0oPFZAJy9e7BfuR9QCjQowI6JkejOpzHUtOfFcV_OXI';
    var request = http.MultipartRequest('POST', url);
    request.fields['lastName'] = user_lastName.text;
    request.fields['firstName'] = user_firstName.text;
    request.fields['email'] = user_email.text;
    request.fields['password'] = user_password.text;
    request.fields['cin'] = user_cin.text;
    request.fields['phone'] = user_phone.text;
    var res = await request.send();
    print(res.reasonPhrase);*/
    try {
    var url = Uri.parse('http://192.168.4.95:3000/signup');
    var response = await http.post(url, headers: {
      "Content-Type": "application/json"
    }, body: jsonEncode({
      "lastName": user_lastName.text,
      "firstName": user_firstName.text,
      "email": user_email.text,
      "password": user_password.text,
      "cin": user_cin.text,
      "phone": user_phone.text,
      "type": "citizen",

    }));
    print('Response status: ${response.statusCode}');
    print('Response <body: ${response.body}');

    var jsonObj = json.decode(response.body);
    switch(response.statusCode) {
      case 200: {
        var access_key =  jsonObj['token'];
        var userType =  jsonObj['userType'];
        print("USER TYPE : " + userType);
        SharedPreferences prefs = await SharedPreferences.getInstance();
        prefs.setString(KEY_ACCESS_TOKEN, access_key);
        Navigator.push(context, MaterialPageRoute(builder: (context) => HomeScreen()));
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
  print(e);
  }
  }


  Widget _entryField() {
    return Container(
      //padding: EdgeInsets.all(4),
      margin: EdgeInsets.all(7),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          Form(
            key: _formKey,
            child: Column(
              children: <Widget>[
                // nom
                TextFormField(
                  autovalidateMode: _autoValidate,
                  controller: user_lastName,
                  decoration: InputDecoration(
                      border: InputBorder.none,
                      fillColor: Color(0xfff3f3f4),
                      labelText: 'Nom',
                      hintText: "Enter votre nom",
                      hintStyle: TextStyle(fontSize: 13),
                      helperText: 'characters seulement',
                      filled: true),
                  validator: (name) {
                    Pattern pattern = r'^[A-Za-z]+(?:[ _-][A-Za-z]+)*$';
                    RegExp regex = new RegExp(pattern);
                    if (name.isEmpty) {
                      // The form is empty
                      return "Enter votre nom";
                    }
                    if (!regex.hasMatch(name))
                      return 'nom invalide';
                    else
                      return null;
                  },
                ),

                // prenom

                TextFormField(
                  autovalidateMode: _autoValidate,
                  controller: user_firstName,
                  decoration: InputDecoration(
                      border: InputBorder.none,
                      fillColor: Color(0xfff3f3f4),
                      labelText: 'Prenom',
                      hintText: "Enter votre prenom",
                      hintStyle: TextStyle(fontSize: 13),
                      helperText: 'characters seulement',
                      filled: true),
                  validator: (prenom) {
                    Pattern pattern = r'^[A-Za-z]+(?:[ _-][A-Za-z]+)*$';
                    RegExp regex = new RegExp(pattern);
                    if (prenom.isEmpty) {
                      // The form is empty
                      return "Enter votre Prenom";
                    }
                    if (!regex.hasMatch(prenom))
                      return ' Prenom Invalid ';
                    else
                      return null;
                  },
                ),
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
                // CIN

                TextFormField(
                  autovalidateMode: _autoValidate,
                  controller: user_cin,
                  decoration: InputDecoration(
                      border: InputBorder.none,
                      fillColor: Color(0xfff3f3f4),
                      labelText: 'CIN',
                      hintText: "Enter votre CIN",
                      hintStyle: TextStyle(fontSize: 13),
                      helperText: 'chiffres seulement',
                      filled: true),
                  validator: (num) {
                    Pattern pattern = r'^[0-9]{8}$';
                    RegExp regex = new RegExp(pattern);
                    if (num.isEmpty) {
                      // The form is empty
                      return "Enter votre numero de tel";
                    }
                    if (!regex.hasMatch(num))
                      return 'numero Invalid ';
                    else
                      return null;
                  },
                ),
                //numtel
                TextFormField(
                  autovalidateMode: _autoValidate,
                  controller: user_phone,
                  decoration: InputDecoration(
                      border: InputBorder.none,
                      fillColor: Color(0xfff3f3f4),
                      labelText: 'Num Tel',
                      hintText: "Enter votre num de tel",
                      hintStyle: TextStyle(fontSize: 13),
                      helperText: 'chiffres seulement',
                      filled: true),
                  validator: (num) {
                    Pattern pattern = r'^[0-9]{8}$';
                    RegExp regex = new RegExp(pattern);
                    if (num.isEmpty) {
                      // The form is empty
                      return "Enter votre numero de tel";
                    }
                    if (!regex.hasMatch(num))
                      return 'numero Invalid ';
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
        onSync();
        //_validateInputs();
        //Navigator.push(context, MaterialPageRoute(builder: (context) => HomeScreen()));
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
            'Vous avez déja un compte ?',
            style: TextStyle(fontSize: 13, fontWeight: FontWeight.w600),
          ),
          SizedBox(
            width: 10,
          ),
          InkWell(
            onTap: () {
              Navigator.push(context, MaterialPageRoute(builder: (context) => HomeScreen()));
            },
            child: Text(
              'Connecter',
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
              text: 'Créer un compte',
              style: TextStyle(color: Color(0xffe46b10), fontSize: 30),
            ),
    );
  }

  Widget _emailPasswordWidget() {
    return Container(
      alignment: Alignment.center,
      padding: EdgeInsets.all(0),
      height: MediaQuery.of(context).size.width*1.2,
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
        padding: EdgeInsets.all(5),
        children: <Widget>[
          _entryField(),
          /*Text(
            ' User Type',
            textAlign: TextAlign.left,
            overflow: TextOverflow.ellipsis,
            style: const TextStyle(fontSize: 19),
          ),
          ListTile(
            title: const Text('citoyen'),
            leading: Radio(
              value: UserType.citizen,
              groupValue: _userType,
              onChanged: (UserType value) {
                setState(() {
                  _userType = value;
                  print(_userType.name);
                });
              },
            ),
          ),
          ListTile(
            title: const Text('admin'),
            leading: Radio(
              value: UserType.admin,
              groupValue: _userType,
              onChanged: (UserType value) {
                setState(() {
                  _userType = value;
                  print(_userType.name);
                });
              },
            ),
          ),*/
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
                        SizedBox(height: 30),
                        _emailPasswordWidget(),
                        SizedBox(
                          height: 30,
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

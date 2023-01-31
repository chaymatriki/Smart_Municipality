import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:smart_municipality/screens/authentification/sign_in.dart';
import 'package:smart_municipality/screens/home/home_screen.dart';
import '../../services/signUp_service.dart';

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
                //last name
                TextFormField(
                  autovalidateMode: _autoValidate,
                  controller: user_lastName,
                  decoration: const InputDecoration(
                      border: InputBorder.none,
                      fillColor: Color(0xfff3f3f4),
                      labelText: 'Last Name',
                      hintText: "Enter your last name",
                      hintStyle: TextStyle(fontSize: 13),
                      helperText: 'characters only',
                      filled: true),
                  validator: (name) {
                    Pattern pattern = r'^[A-Za-z]+(?:[ _-][A-Za-z]+)*$';
                    RegExp regex = new RegExp(pattern);
                    if (name.isEmpty) {
                      // The form is empty
                      return "Enter your last name";
                    }
                    if (!regex.hasMatch(name))
                      return 'characters only';
                    else
                      return null;
                  },
                ),

                // first name

                TextFormField(
                  autovalidateMode: _autoValidate,
                  controller: user_firstName,
                  decoration: const InputDecoration(
                      border: InputBorder.none,
                      fillColor: Color(0xfff3f3f4),
                      labelText: 'First Name',
                      hintText: "Enter your first name",
                      hintStyle: TextStyle(fontSize: 13),
                      helperText: 'characters only',
                      filled: true),
                  validator: (prenom) {
                    Pattern pattern = r'^[A-Za-z]+(?:[ _-][A-Za-z]+)*$';
                    RegExp regex = new RegExp(pattern);
                    if (prenom.isEmpty) {
                      // The form is empty
                      return "Enter your first name";
                    }
                    if (!regex.hasMatch(prenom))
                      return 'characters only';
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
                      hintText: "Enter your email",
                      hintStyle: TextStyle(fontSize: 13),
                      helperText: 'must be a valid email',
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
                  decoration: const InputDecoration(
                      border: InputBorder.none,
                      fillColor: Color(0xfff3f3f4),
                      labelText: 'Password',
                      hintText: "Enter your password",
                      hintStyle: TextStyle(fontSize: 13),
                      helperText: '8 characters at least',
                      filled: true),
                  validator: (password) {

                    if (password.length < 6)
                      return 'too short';
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
                      hintText: "Enter your ID Number",
                      hintStyle: TextStyle(fontSize: 13),
                      helperText: 'digits only',
                      filled: true),
                  validator: (num) {
                    Pattern pattern = r'^[0-9]{8}$';
                    RegExp regex = new RegExp(pattern);
                    if (num.isEmpty) {
                      // The form is empty
                      return "Enter your ID Number";
                    }
                    if (!regex.hasMatch(num))
                      return ' digits only';
                    else
                      return null;
                  },
                ),
                //phone
                TextFormField(
                  autovalidateMode: _autoValidate,
                  controller: user_phone,
                  decoration: const InputDecoration(
                      border: InputBorder.none,
                      fillColor: Color(0xfff3f3f4),
                      labelText: 'Phone Number',
                      hintText: "Enter your phone number",
                      hintStyle: TextStyle(fontSize: 13),
                      helperText: 'digits only',
                      filled: true),
                  validator: (num) {
                    Pattern pattern = r'^[0-9]{8}$';
                    RegExp regex = new RegExp(pattern);
                    if (num.isEmpty) {
                      // The form is empty
                      return "Enter your phone number";
                    }
                    if (!regex.hasMatch(num))
                      return 'digits only';
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
        _validateInputs();
        SignUpService().Sign_up(context, user_lastName.text, user_firstName.text,
          user_email.text, user_password.text, user_cin.text, user_phone.text);
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
            gradient: const LinearGradient(
                begin: Alignment.centerLeft,
                end: Alignment.centerRight,
                colors: [Color(0xfffbb448), Color(0xfff7892b)])),
        child: Text(
          'Continue',
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
            'Already have an account ?',
            style: TextStyle(fontSize: 13, fontWeight: FontWeight.w600),
          ),
          SizedBox(
            width: 10,
          ),
          InkWell(
            onTap: () {
              Navigator.push(context, MaterialPageRoute(builder: (context) => SignIn()));
            },
            child: const Text(
              'Sign In',
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
              text: 'Create an account',
              style: TextStyle(color: Color(0xffe46b10), fontSize: 35, fontWeight: FontWeight.bold),
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
                ],
              ),
            )));
  }
}

@override
Widget build(BuildContext context) {

  return null;
}

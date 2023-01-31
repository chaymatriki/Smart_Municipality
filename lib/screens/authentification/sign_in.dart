import 'dart:convert';
import 'package:smart_municipality/components/BackButton.dart';
import 'package:smart_municipality/constants.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';
import 'package:smart_municipality/screens/authentification/components/SignUpLabel.dart';
import 'package:smart_municipality/screens/authentification/components/submitBody.dart';
import 'package:smart_municipality/screens/authentification/sign_up.dart';
import 'package:smart_municipality/screens/home/home_screen.dart';
import 'package:smart_municipality/services/signIn_service.dart';
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

  void validateInputs() {
    final form = _formKey.currentState;
    if (form.validate()) {
      form.save();
    } else {
      setState(() =>   _autoValidate = AutovalidateMode.always);
    }
  }
  String _validateEmail(String value) {
    if (value.isEmpty)
    { return "Enter email address"; }
    String p = "[a-zA-Z0-9\+\.\_\%\-\+]{1,256}" + "\\@" +"[a-zA-Z0-9][a-zA-Z0-9\\-]{0,64}" + "(" +"\\." +"[a-zA-Z0-9][a-zA-Z0-9\\-]{0,25}" +")+";
    RegExp regExp = RegExp(p);
    if (regExp.hasMatch(value)) { return null; }
    return 'Email is non valid';
  }

  Widget EmailPassword() {
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
                TextFormField(
                  autovalidateMode: _autoValidate,
                  controller: user_email,
                  decoration: const InputDecoration(border: InputBorder.none,fillColor: Color(0xfff3f3f4),labelText: "Email",
                      hintText: "Enter votre nom",hintStyle: TextStyle(fontSize: 13),helperText: 'must be a valid email',
                      filled: true),
                  onSaved: (String value) {
                    value = user_email.text;
                  },
                  validator: _validateEmail,
                  keyboardType: TextInputType.emailAddress,
                ),
                TextFormField(
                  autovalidateMode: _autoValidate,
                  controller: user_password,
                  obscureText: true,
                  decoration: const InputDecoration(
                      border: InputBorder.none,fillColor: Color(0xfff3f3f4),labelText: 'Password',hintText: "Enter votre mot de passe",
                      hintStyle: TextStyle(fontSize: 13),helperText: '8 characteres at least',filled: true),
                  validator: (password) {
                    if (password.length < 8)
                    { return 'too short'; }
                    else
                    { return null; }
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
        validateInputs();
        SignInService().Sign_in(context, user_email.text, user_password.text);
      },
      child: SubmitBody(),
    );
  }

  Widget _title() {
    return RichText(
      textAlign: TextAlign.center,
      text: const TextSpan(text: 'Sign In', style: TextStyle(color: Color(0xffe46b10), fontSize: 50, fontWeight: FontWeight.bold),
      ),
    );
  }

  Widget _emailPasswordWidget() {
    return Container(
      alignment: Alignment.center,
      padding: const EdgeInsets.all(10),
      height: MediaQuery.of(context).size.width/1.3,
      decoration: BoxDecoration(
          borderRadius: const BorderRadius.all(Radius.circular(5)),
          boxShadow: <BoxShadow>[
            BoxShadow(
                color: Colors.grey.shade200,
                offset: const Offset(2, 4),
                blurRadius: 5,
                spreadRadius: 2)
          ],
          gradient: const LinearGradient(
              begin: Alignment.centerLeft,
              end: Alignment.centerRight,
              colors: [Color(0xffffffff), Color(0xffffffff)])),
      child: ListView(
        children: <Widget>[
          EmailPassword(),
        ],
      ),

    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: SingleChildScrollView(
            child: SizedBox(
              height: MediaQuery.of(context).size.height,
              child: Stack(
                children: <Widget>[
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 15),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: <Widget>[
                        const Expanded(
                          flex: 1,
                          child: SizedBox(),
                        ),
                        _title(),
                        const SizedBox(height: 50),
                        _emailPasswordWidget(),
                        const SizedBox(
                          height: 60,
                        ),
                        _submitButton(),
                        const Expanded(
                          flex: 1,
                          child: SizedBox(),
                        )
                      ],
                    ),
                  ),
                  const Align(
                    alignment: Alignment.bottomCenter,
                    child: SignUpLabel(),
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

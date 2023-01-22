import 'dart:convert';
import 'dart:io';
import 'dart:async';
import 'package:flutter/material.dart';
import 'package:smart_municipality/screens/home/home_screen.dart';
import 'package:http/http.dart' as http;
import 'package:image_picker/image_picker.dart';
import 'package:smart_municipality/screens/home/home_screen.dart';


class SignUpDriver2Page extends StatefulWidget {
  final String value;
  SignUpDriver2Page({Key key, this.title, this.value}) : super(key: key);

  final String title;

  @override
  _SignUpPageDriver2State createState() => _SignUpPageDriver2State();
}

class _SignUpPageDriver2State extends State<SignUpDriver2Page> {
  final controller = TextEditingController();
  final controller1 = TextEditingController();
  final controller2 = TextEditingController();
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  XFile _image;
  bool _autoValidate = false;
  var client = http.Client();
  final ImagePicker picker = ImagePicker();

//take picture
  Future getImage(ImageSource media) async {
    var img = await picker.pickImage(source: media);

    setState(() {
      _image = img;
    });
  }

//upload picture
  /*void _upload() async {
    try {
      if (_image == null) return;
      String base64Image = base64Encode(_image.readAsBytes());
      String fileName = _image.path.split("/").last;
      var url = Uri.parse('http://192.168.1.52:3000/registerDriver2');
      var response = await client.post(url, body: {
        "image": base64Image,
        "name": fileName,
      });
      print('Response status: ${response.statusCode}');
      print('Response body: ${response.body}');
    } catch (e) {}
  }*/

  //submit data to base
  onSync() async {
    try {
      var url = Uri.parse('http://192.168.1.52:3000/registerDriver2');
      var response = await client.post(url, body: {
        'reference': controller.text,
        'typeVoiture': controller1.text,
        'numSerie': controller2.text,
      });
      print('Response status: ${response.statusCode}');
      print('Response body: ${response.body}');
    } catch (e) {}
  }

  //inputs
  Widget _entryField() {
    return Container(
      padding: EdgeInsets.all(4),
      margin: EdgeInsets.all(7),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          SizedBox(
            height: 5,
          ),
          Form(
            key: _formKey,
            child: Column(
              children: <Widget>[
                //reference
                TextFormField(
                  //autovalidate: _autoValidate,
                  controller: controller,
                  decoration: InputDecoration(
                      border: InputBorder.none,
                      fillColor: Color(0xfff3f3f4),
                      labelText: 'Référence',
                      hintText: "Enter votre référence",
                      hintStyle: TextStyle(fontSize: 13),
                      helperText: 'Enter des chiffres seulement',
                      filled: true),
                  validator: (name) {
                    Pattern pattern = r'^[0-9]{4}$';
                    RegExp regex = new RegExp(pattern);
                    if (name.isEmpty) {
                      // The form is empty
                      return "Enter votre référence";
                    }
                    if (!regex.hasMatch(name))
                      return 'Nom invalide';
                    else
                      return null;
                  },
                ),
                SizedBox(
                  height: 10,
                ),

                // typevoiture
                TextFormField(
                  //autovalidate: _autoValidate,
                  controller: controller1,
                  decoration: InputDecoration(
                      border: InputBorder.none,
                      fillColor: Color(0xfff3f3f4),
                      labelText: 'Type de voiture',
                      hintText: "Enter le type de votre voiture",
                      hintStyle: TextStyle(fontSize: 13),
                      helperText: 'Enter des caractèrs seulement',
                      filled: true),
                  validator: (prenom) {
                    Pattern pattern = r'^[A-Za-z]+(?:[ _-][A-Za-z]+)*$';
                    RegExp regex = new RegExp(pattern);
                    if (prenom.isEmpty) {
                      // The form is empty
                      return "Enter le type de votre voiture";
                    }
                    if (!regex.hasMatch(prenom))
                      return ' Type invalide ';
                    else
                      return null;
                  },
                ),
                SizedBox(
                  height: 10,
                ),

                _entryPictureField("Votre permie :"),
                SizedBox(
                  height: 15,
                ),
                _entryPictureField("Votre carte grise :"),

                //numSérie
                TextFormField(
                  //autovalidate: _autoValidate,
                  controller: controller2,
                  decoration: InputDecoration(
                      border: InputBorder.none,
                      fillColor: Color(0xfff3f3f4),
                      labelText: "Numéro du série",
                      hintText: "Enter le numéro du série",
                      hintStyle: TextStyle(fontSize: 13),
                      helperText: 'Enter des chiffres seulement',
                      filled: true),
                  validator: (prenom) {
                    Pattern pattern = r'^[0-9]{8}$';
                    RegExp regex = new RegExp(pattern);
                    if (prenom.isEmpty) {
                      // The form is empty
                      return "Enter un numéro du série";
                    }
                    if (!regex.hasMatch(prenom))
                      return ' Numéro invalide ';
                    else
                      return null;
                  },
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

  //picture input
  Widget _entryPictureField(String title) {
    return InkWell(
      onTap: () {
        getImage(ImageSource.gallery);
      },
      child: Container(
        padding: EdgeInsets.all(4),
        margin: EdgeInsets.all(7),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            Text(
              title,
              style: TextStyle(fontWeight: FontWeight.bold, fontSize: 12),
            ),
            SizedBox(
              height: 5,
            ),
            Container(
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
                      colors: [Color(0xfff3f3f4), Color(0xfff3f3f4)])),
              child: Text(
                'Prendre un photo',
                style: TextStyle(fontSize: 15, color: Colors.black),
              ),
            ),
          ],
        ),
      ),
    );
  }

  //return button
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

//submitbutton
  Widget _submitButton() {
    final form = _formKey.currentState;
    return InkWell(
      onTap: () {
        if (form.validate()) {
          // Text forms was validated.
          form.save();
          onSync();
          Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => HomeScreen()),
          );
        }
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
          'Connecter',
          style: TextStyle(fontSize: 15, color: Colors.white),
        ),
      ),
    );
  }

//you have an account
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
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => HomeScreen()),
              );
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

//title
  Widget _title() {
    return RichText(
      textAlign: TextAlign.center,
      text: TextSpan(
          text: 'C',
          /*style: GoogleFonts.portLligatSans(
            textStyle: Theme.of(context).textTheme.display1,
            fontSize: 30,
            fontWeight: FontWeight.w700,
            color: Color(0xffe46b10),
          ),*/
          children: [
            TextSpan(
              text: 'Créer ',
              style: TextStyle(color: Color(0xffe46b10), fontSize: 30),
            ),
            TextSpan(
              text: 'un compte',
              style: TextStyle(color: Colors.black, fontSize: 30),
            ),
          ]),
    );
  }

//formdisplay widget
  Widget formWidget() {
    return Container(
      alignment: Alignment.center,
      padding: EdgeInsets.all(5),
      //height: MediaQuery.of(context).size.width,
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
        /*children: <Widget>[
          _entryField(),
        ],*/
      ),
    );
  }

  //build
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: SingleChildScrollView(
            child: Container(
              //height: MediaQuery.of(context).size.height,
              child: Stack(
                children: <Widget>[
                  Container(
                    padding: EdgeInsets.symmetric(horizontal: 15),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: <Widget>[
                        Expanded(
                          flex: 3,
                          child: SizedBox(),
                        ),
                        _title(),
                        Expanded(
                          flex: 1,
                          child: Padding(
                            padding: EdgeInsets.all(16),
                          ),
                        ),
                        formWidget(),
                        SizedBox(
                          height: 30,
                        ),
                        //_submitButton(),
                        Expanded(
                          flex: 1,
                          child: SizedBox(),
                        ),
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
  }}


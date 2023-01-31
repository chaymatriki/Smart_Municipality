import 'dart:convert';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:http/http.dart' as http;
import 'package:intl/intl.dart';
import 'package:smart_municipality/constants.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:smart_municipality/models/Location.dart';
import 'package:smart_municipality/screens/map/map_screen.dart';
import 'components/bezierContainer.dart';
import 'dart:io';
import 'package:image_picker/image_picker.dart';

class SignUpPage extends StatefulWidget {
  SignUpPage({Key key, this.title}) : super(key: key);

  final String title;

  @override
  _SignUpPageState createState() => _SignUpPageState();
}

class _SignUpPageState extends State<SignUpPage> {
  final titleController = TextEditingController();
  final descriptionController = TextEditingController();
  final format = DateFormat("dd-mm-yyyy");
  XFile image;
  Location position;
  final ImagePicker picker = ImagePicker();
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  AutovalidateMode _autoValidate = AutovalidateMode.disabled;

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
            Text('Back',
                style: TextStyle(fontSize: 12, fontWeight: FontWeight.w500))
          ],
        ),
      ),
    );
  }

  onSync() async {
    var url = Uri.parse(API_URL + '/fillinform');
    SharedPreferences prefs = await SharedPreferences.getInstance();
    var authToken = prefs.getString(KEY_ACCESS_TOKEN);
    var request = http.MultipartRequest('POST', url);
    request.fields['title'] = titleController.text;
    request.fields['body'] = descriptionController.text;
    request.fields['location[type]'] = "Point";
    request.fields['location[address]'] = position.address;
    request.fields['location[latitude]'] = position.latitude.toString();
    request.fields['location[longitude]'] = position.longitude.toString();
    request.headers['Authorization'] = "Bearer " + authToken;
    request.files.add(await http.MultipartFile.fromPath('picture', image.path));
    var res = await request.send();
    print(res.reasonPhrase);
  }

  Widget _entryField() {
    return Container(
      padding: EdgeInsets.all(4),
      margin: EdgeInsets.all(7),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          SizedBox(height: 5),
          Form(
            key: _formKey,
            child: Column(
              children: <Widget>[
                // nom

                TextFormField(
                  autovalidateMode: _autoValidate,
                  controller: titleController,
                  decoration: const InputDecoration(
                      border: InputBorder.none,
                      fillColor: Color(0xfff3f3f4),
                      labelText: 'Title',
                      hintText: "Enter fraud title",
                      hintStyle: TextStyle(fontSize: 13),
                      helperText: 'characters only',
                      filled: true),
                  validator: (name) {
                    Pattern pattern = r'^[A-Za-z]+(?:[ _-][A-Za-z]+)*$';
                    RegExp regex = new RegExp(pattern);
                    if (name.isEmpty) {
                      // The form is empty
                      return "Enter fraud title";
                    }
                    if (!regex.hasMatch(name))
                      return 'invalid input';
                    else
                      return null;
                  },
                ),

                // prenom

                TextFormField(
                  autovalidateMode: _autoValidate,
                  controller: descriptionController,
                  decoration: InputDecoration(
                      border: InputBorder.none,
                      fillColor: Color(0xfff3f3f4),
                      labelText: 'Description',
                      hintText: "Enter fraud description",
                      hintStyle: TextStyle(fontSize: 13),
                      helperText: 'characters only',
                      filled: true),
                  validator: (prenom) {
                    Pattern pattern = r'^[A-Za-z]+(?:[ _-][A-Za-z]+)*$';
                    RegExp regex = new RegExp(pattern);
                    if (prenom.isEmpty) {
                      // The form is empty
                      return "Enter fraud description";
                    }
                    if (!regex.hasMatch(prenom))
                      return 'Invalid input';
                    else
                      return null;
                  },
                ),
                //Image Input Field
                Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    ElevatedButton(
                      style : ButtonStyle(
                        backgroundColor: MaterialStatePropertyAll<Color>(Color(0xfffbb448)),
                      ),
                      onPressed: () {
                        imageAlert();
                      },
                      child: Text('Upload Photo'),
                    ),
                    SizedBox(
                      height: 10,
                    ),
                    //if image not null show the image
                    //if image null show text
                    image != null
                        ? Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 20),
                      child: ClipRRect(
                        borderRadius: BorderRadius.circular(8),
                        child: Image.file(
                          //to show image, you type like this.
                          File(image.path),
                          fit: BoxFit.cover,
                          width: MediaQuery.of(context).size.width,
                          height: 300,
                        ),
                      ),
                    )
                        : Text(
                      "No Image",
                      style: TextStyle(fontSize: 20),
                    )
                  ],
                ),
                //Localization Input Field
                Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    ElevatedButton(
                      style : const ButtonStyle(
                        backgroundColor: MaterialStatePropertyAll<Color>(Color(0xfffbb448)),
                      ),
                      onPressed: () {
                        _goToMaps(context);
                      },
                      child: Text('Location'),
                    ),
                    SizedBox(
                      height: 10,
                    ),
                    position != null
                        ? Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 20),
                      child: ClipRRect(
                        borderRadius: BorderRadius.circular(8),
                        child: Text(
                          //if localization is set
                          position.address
                        ),
                      ),
                    )
                        : Text(
                      "No Location",
                      style: TextStyle(fontSize: 20),
                    )
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _submitButton() {
    return Container(
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
      child: InkWell(
        onTap: () {
          onSync();
          //_validateInputs();
        },
        child: const Text(
          'Submit',
          style: TextStyle(
            fontSize: 30
          ),
        ),
      ),
    );
  }



  Widget _title() {
    return RichText(
      textAlign: TextAlign.center,
      text: TextSpan(
              text: 'Report a violation',
              style: TextStyle(color: Color(0xffe46b10), fontSize: 28, fontWeight: FontWeight.bold),
            ),

    );
  }

  void imageAlert() {
    showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            shape:
            RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
            title: Text('Please choose media to select'),
            content: Container(
              height: MediaQuery.of(context).size.height / 6,
              child: Column(
                children: [
                  ElevatedButton(
                    style : ButtonStyle(
                      backgroundColor: MaterialStatePropertyAll<Color>(Color(0xfffbb448)),
                    ),
                    //if user click this button, user can upload image from gallery
                    onPressed: () {
                      Navigator.pop(context);
                      getImage(ImageSource.gallery);
                    },
                    child: Row(
                      children: [
                        Icon(Icons.image),
                        Text('From Gallery'),
                      ],
                    ),
                  ),
                  ElevatedButton(
                    style : ButtonStyle(
                      backgroundColor: MaterialStatePropertyAll<Color>(Color(0xfffbb448)),
                    ),
                    //if user click this button. user can upload image from camera
                    onPressed: () {
                      Navigator.pop(context);
                      getImage(ImageSource.camera);
                    },
                    child: Row(
                      children: [
                        Icon(Icons.camera),
                        Text('From Camera'),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          );
        });
  }

  Future getImage(ImageSource media) async {
    var img = await picker.pickImage(source: media);

    setState(() {
      image = img;
    });
  }


  void localizationAlert() async{
    showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            shape:
            RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
            title: Text('Please choose position to select'),
            content: Container(
              height: MediaQuery.of(context).size.height / 6,
              child: Column(
                children: [
                  ElevatedButton(
                    style : ButtonStyle(
                      backgroundColor: MaterialStatePropertyAll<Color>(Color(0xfffbb448)),
                    ),
                    onPressed: () {
                      Navigator.pop(context);
                      _goToMaps(context);
                    },
                    child: Row(
                      children: [
                        Icon(Icons.image),
                        Text('Search on Map'),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          );
        });
  }

  void _goToMaps(BuildContext context) async {

    final result = await Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => MapScreen(),
        ));

    // after the SecondScreen result comes back update the Text widget with it
    setState(() {
      position = result;
    });
  }


  Widget _formWidget() {
    return Container(
      alignment: Alignment.center,
      padding: EdgeInsets.all(5),
      height: MediaQuery.of(context).size.width,
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
                        _formWidget(),
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

                  Positioned(top: 40, left: 0, child: _backButton()),
                  Positioned(
                      top: -MediaQuery.of(context).size.height * .15,
                      right: -MediaQuery.of(context).size.width * .4,
                      child: BezierContainer())
                ],
              ),
            )));
  }
}

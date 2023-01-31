import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';
import 'dart:convert';
import 'package:smart_municipality/constants.dart';

import '../screens/form/form_screen.dart';
import '../screens/home/home_screen.dart';


class SignUpService {
  Sign_up(BuildContext context, String lastName, String firstName, String email,
      String password, String cin, String phone) async {
    try {
      var url = Uri.parse('http://192.168.4.95:3000/signup');
      var response = await http.post(url, headers: {
        "Content-Type": "application/json"
      }, body: jsonEncode({
        "lastName": lastName,
        "firstName": firstName,
        "email": email,
        "password": password,
        "cin": cin,
        "phone": phone,
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
}
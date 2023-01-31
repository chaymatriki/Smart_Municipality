import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';
import 'dart:convert';
import 'package:smart_municipality/constants.dart';

import '../screens/form/form_screen.dart';
import '../screens/home/home_screen.dart';


class SignInService {
  Sign_in(BuildContext context, String user_email, String user_password) async {
    try {
      var url = Uri.parse(API_URL+'/signin');
      var response = await http.post(url, headers: {
        "Content-Type": "application/json"
      }, body: jsonEncode({
        "email": user_email,
        "password": user_password,
      }));
      var jsonObj = json.decode(response.body);
      switch (response.statusCode) {
        case 200:
          {
            var accessKey = jsonObj['token'];
            var userType = jsonObj['userType'];
            //print(userType);
            SharedPreferences prefs = await SharedPreferences.getInstance();
            prefs.setString(KEY_ACCESS_TOKEN, accessKey);
            switch (userType) {
              case "citizen":
                {
                  Navigator.push(context,
                      MaterialPageRoute(builder: (context) => SignUpPage()));
                }
                break;
              case "admin":
                {
                  Navigator.push(context,
                      MaterialPageRoute(builder: (context) => HomeScreen()));
                }
            }
          }
          break;

        case 422:
          {
            showDialog(context: context, builder: (BuildContext context) {
              return AlertDialog(
                title: const Text("Error", textAlign: TextAlign.center,),
                titleTextStyle: const TextStyle(fontWeight: FontWeight.bold,
                  color: Colors.black,
                  fontSize: 20,),
                backgroundColor: Colors.white,
                shape: const RoundedRectangleBorder(
                    borderRadius: BorderRadius.all(Radius.circular(20))
                ),
                content: Text(jsonObj['error'], textAlign: TextAlign.center,),
              );
            });
          }
          break;

        default:
          {
            //statements;
          }
          break;
      }
    } catch (e) {
      showDialog(context: context, builder: (BuildContext context) {
        return AlertDialog(
          title: const Text("Error"),
          titleTextStyle: TextStyle(
              fontWeight: FontWeight.bold, color: Colors.black, fontSize: 20),
          backgroundColor: Colors.grey,
          shape: const RoundedRectangleBorder(
              borderRadius: BorderRadius.all(Radius.circular(20))
          ),
          content: Text(e),
        );
      });
    }
  }
}
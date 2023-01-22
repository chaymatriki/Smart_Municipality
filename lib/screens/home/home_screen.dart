
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:smart_municipality/constants.dart';
import 'package:smart_municipality/screens/authentification/sign_in.dart';
import 'package:smart_municipality/screens/home/components/body.dart';
import 'package:smart_municipality/constants.dart';

class HomeScreen extends StatefulWidget {
  static String routeName = "/home";

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: buildAppBar(),
      body: FraudList(),
    );
  }

  AppBar buildAppBar() {
    return AppBar(
      backgroundColor: Colors.white,
      elevation: 0,
      leading: IconButton(
        icon: SvgPicture.asset("assets/icons/back.svg"),
        onPressed: () {},
      ),
      actions: <Widget>[
        IconButton(
          icon: SvgPicture.asset(
            "assets/icons/search.svg",
            // By default our  icon color is white
            color: kTextColor,
          ),
          onPressed: () {},
        ),
        IconButton(
          icon: Image.asset(
            "assets/icons/logout.png",
            color: kTextColor,
          ),
          onPressed: () async {
            SharedPreferences prefs = await SharedPreferences.getInstance();
            prefs.setString(KEY_ACCESS_TOKEN, "");
            Navigator.push(context, MaterialPageRoute(builder: (context) => SignIn()));
          },
        ),
        SizedBox(width: kDefaultPaddin / 2)
      ],
    );
  }
}

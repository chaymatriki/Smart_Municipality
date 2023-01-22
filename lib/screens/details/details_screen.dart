import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:smart_municipality/constants.dart';
import 'package:smart_municipality/models/fraud.dart';
import 'package:smart_municipality/screens/details/components/body.dart';

class DetailsScreen extends StatelessWidget {
  static String routeName = "/details";
  final FraudModel fraud;

  const DetailsScreen({Key key, this.fraud}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color(0xFFFFE0B2),
      appBar: buildAppBar(context),
      body: Body(fraud: fraud),
    );
  }

  AppBar buildAppBar(BuildContext context) {
    return AppBar(
      elevation: 0,
      leading: IconButton(
        icon: SvgPicture.asset(
          'assets/icons/back.svg',
          color: Colors.white,
        ),
        onPressed: () => Navigator.pop(context),
      ),
      actions: <Widget>[
        IconButton(
          icon: SvgPicture.asset("assets/icons/search.svg"),
          onPressed: () {},
        ),
        IconButton(
          icon: SvgPicture.asset("assets/icons/cart.svg"),
          onPressed: () {},
        ),
        SizedBox(width: kDefaultPaddin / 2)
      ],
    );
  }
}

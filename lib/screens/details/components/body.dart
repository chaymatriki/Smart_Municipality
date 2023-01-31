import 'package:flutter/material.dart';
import 'package:smart_municipality/constants.dart';
import 'package:smart_municipality/models/fraud.dart';
import 'add_to_cart.dart';
import 'description.dart';
import 'product_title_with_image.dart';

class Body extends StatelessWidget {
  final FraudModel fraud;

  const Body({Key key, this.fraud}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    // It provide us total height and width
    Size size = MediaQuery.of(context).size;
    return SingleChildScrollView(
      child: Column(
        children: <Widget>[
          SizedBox(
            height: size.height,
            child: Stack(
              children: <Widget>[
                Container(
                  margin: EdgeInsets.only(top: size.height * 0.3),
                  padding: const EdgeInsets.only(
                    //top: size.height * 0.12,
                    left: kDefaultPaddin,
                    right: kDefaultPaddin,
                  ),
                  // height: 500,
                  decoration: const BoxDecoration(
                    color: Color(0xfff7892b),
                    borderRadius: BorderRadius.only(
                      topLeft: Radius.circular(24),
                      topRight: Radius.circular(24),
                    ),
                  ),
                  child:
                      Description(fraud: fraud),
                ),
                ProductTitleWithImage(fraud: fraud)
              ],
            ),
          )
        ],
      ),
    );
  }
}

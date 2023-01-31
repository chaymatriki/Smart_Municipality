import 'package:flutter/material.dart';
import 'package:smart_municipality/models/fraud.dart';
import '../../../constants.dart';

class ProductTitleWithImage extends StatelessWidget {
  const ProductTitleWithImage({
    Key key,
    @required this.fraud,
  }) : super(key: key);

  final FraudModel fraud;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: kDefaultPaddin),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          RichText(text: TextSpan(
            children: [
              TextSpan(
                text: "Fraud title : \n",
                style: Theme.of(context).textTheme.headline6.copyWith(
                    color: Color(0xfff7892b), fontWeight: FontWeight.bold),
              ),
              TextSpan(text: fraud.title, style: TextStyle(color: Colors.black, fontSize: 20)),
            ],
          ),
          ),
          RichText(text: TextSpan(
            children: [
              TextSpan(
                text: "Fraud location : \n",
                style: Theme.of(context).textTheme.headline6.copyWith(
                    color: Color(0xfff7892b), fontWeight: FontWeight.bold),
              ),
              TextSpan(text: fraud.location.address, style: TextStyle(color: Colors.black, fontSize: 15)),
            ],
          ),
          ),
          RichText(text: TextSpan(
            children: [
              TextSpan(
                text: "Descrition : \n",
                style: Theme.of(context).textTheme.headline6.copyWith(
                    color: Color(0xfff7892b), fontWeight: FontWeight.bold),
              ),
              TextSpan(text: fraud.body, style: TextStyle(color: Colors.black, fontSize: 17)),
            ],
          ),
          ),
        ],
      ),
    );
  }
}

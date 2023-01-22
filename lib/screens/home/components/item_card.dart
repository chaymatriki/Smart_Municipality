import 'package:flutter/material.dart';
import 'package:smart_municipality/models/Product.dart';
import 'package:smart_municipality/models/fraud.dart';
import '../../../constants.dart';

class ItemCard extends StatelessWidget {
  final FraudModel fraud;
  final Function press;
  const ItemCard({
    Key key,
    this.fraud,
    this.press,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: press,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          Expanded(
            child: Container(
              padding: EdgeInsets.all(kDefaultPaddin),
              decoration: BoxDecoration(
                color: Color(0xFFFFE0B2),
                borderRadius: BorderRadius.circular(16),
              ),
              child: Hero(
                tag: "${fraud.id}",
                child: Image.network("http://192.168.4.95:3000/uploads/"+fraud.photo,
                    fit: BoxFit.fill),
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.symmetric(vertical: kDefaultPaddin / 4),
            child: Text("fraud : "+
              // products is out demo list
              fraud.title,
              style: TextStyle(color: kTextLightColor),
            ),
          ),
          Text(
            "Posted By: ${fraud.postedBy.firstName} ${fraud.postedBy.lastName}",
            style: TextStyle(fontWeight: FontWeight.bold),
          )
        ],
      ),
    );
  }
}

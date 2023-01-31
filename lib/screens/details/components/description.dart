import 'package:flutter/material.dart';
import 'package:smart_municipality/models/fraud.dart';
import 'package:http/http.dart' as http;
import '../../../constants.dart';

class Description extends StatefulWidget {
  const Description({
    Key key,
    @required this.fraud,
  }) : super(key: key);

  final FraudModel fraud;

  @override
  State<Description> createState() => _DescriptionState();
}

class _DescriptionState extends State<Description> {
  @override
  void initState() {
    super.initState();
  }
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: kDefaultPaddin),
      child: Hero(
        tag: "${widget.fraud.id}",
        child: Image.network(API_URL + "/uploads/"+"${widget.fraud.photo}",
            fit: BoxFit.fill),
      ),
    );
  }
}

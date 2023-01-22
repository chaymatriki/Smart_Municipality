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
  /*_getImage(String filename) async {
    try {
      var url = 'http://192.168.4.95:3000/uploads/'+filename;
      var res  = await http.get(Uri.parse(url));
      if (res.statusCode == 200) {
        return res.body;
      }
    } catch (e) {
      print(e);
      return null;
    }
  }*/
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
        /*child: Image.asset(
          (fraud.photo),
          fit: BoxFit.fill,
        ),*/
        child: Image.network("http://192.168.4.95:3000/uploads/"+"${widget.fraud.photo}",
            fit: BoxFit.fill),
      ),
    );
  }
}

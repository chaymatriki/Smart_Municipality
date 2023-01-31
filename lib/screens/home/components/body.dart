import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:smart_municipality/constants.dart';
import 'package:smart_municipality/models/fraud.dart';
import 'package:smart_municipality/screens/details/details_screen.dart';
import 'package:http/http.dart' as http;
import 'item_card.dart';
class FraudList extends StatefulWidget {

  @override
  _FraudListState createState() => _FraudListState();

}

class _FraudListState extends State<FraudList> {
  List<FraudModel> frauds = [];
  @override
  void initState() {
    super.initState();
  }

  _getFrauds() async {
    List itemsList = [];
    var ret;
    try {
      var url = API_URL + '/allforms';
      var res  = await http.get(Uri.parse(url));
      if (res.statusCode == 200) {
        ret = res.body;
        frauds = fraudModelFromJson(res.body);
      }
      return ret;
    } catch (e) {
      print(e.toString());
      return null;
    }
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
      future: _getFrauds(),
      builder: (context, snapshot) {
        if (snapshot.hasData) {
          return Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              const Padding(
                padding: EdgeInsets.fromLTRB(90, 10, 0, 30),
                child: Text(
                  "Frauds",
                  style: TextStyle(
                    color: Color(0xfff7892b),
                    fontSize: 50,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
              Expanded(
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: kDefaultPaddin),
                  child: GridView.builder(
                      itemCount: frauds.length,
                      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                        crossAxisCount: 2,
                        mainAxisSpacing: kDefaultPaddin,
                        crossAxisSpacing: kDefaultPaddin,
                        childAspectRatio: 0.75,
                      ),
                      itemBuilder: (context, index) => ItemCard(
                        fraud: frauds[index],
                        press: () => Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => DetailsScreen(
                                fraud: frauds[index],
                              ),
                            )),
                      )),
                ),
              ),
            ],
          );
        } else {
          return Center(
            child: CircularProgressIndicator(),
          );
        }
      },
    );

  }
}

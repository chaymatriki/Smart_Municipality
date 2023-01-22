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
    //_getFrauds();
  }


  //IMPORTANT : Mobile and computer must be connected to same LAN + Private LAN for computer + IP from ipconfig wireless wifi
  _getFrauds() async {
    List itemsList = [];
    var ret;
    try {
      var url = 'http://10.128.1.62:3000/allforms';
      var res  = await http.get(Uri.parse(url));
      if (res.statusCode == 200) {

        /*frauds = fraudModelFromJson(res.body);
        /*print(itemsList);
        itemsList.forEach((element) {
          print(element.photo);

        });*/

        frauds.forEach((element) {
          print(element);
           itemsList.add(FraudModel(
              id: element.id,
              photo: element.photo,
              title: element.title,
              body: element.body,
              postedBy: element.postedBy,
              date: element.date));
        });*/
        //var jsonObj = json.decode(res.body);
        //ret = jsonObj['posts'];
        ret = res.body;
        frauds = fraudModelFromJson(res.body);
      }
      return ret;
    } catch (e) {
      print(e.toString());
      return null;
    }
  }

  /*_getFrauds() async {
    var res  = await http.get(Uri.parse('http://192.168.1.177:3000/allforms'));
    if (res.statusCode == 200) {
      var jsonObj = json.decode(res.body);
    return jsonObj['posts']; }
  }*/

  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
      future: _getFrauds(),
      builder: (context, snapshot) {
        if (snapshot.hasData) {
          return Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: kDefaultPaddin),
                child: Text(
                  "Frauds",
                  style: Theme.of(context)
                      .textTheme
                      .headline5
                      .copyWith(fontWeight: FontWeight.bold),
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

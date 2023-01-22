import 'package:flutter/material.dart';
import 'package:open_street_map_search_and_pick/open_street_map_search_and_pick.dart';
import 'package:geolocator/geolocator.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class FraudScreen extends StatefulWidget {

  @override
  _FraudScreenState createState() => _FraudScreenState();
}

class _FraudScreenState extends State<FraudScreen> {
  Future<Position> _position;

  @override
  void initState() {
    super.initState();
    _position = _setCurrentPos();
    //getFrauds();
  }

  getFrauds() async {
    var res  = http.get(Uri.parse('localhost:3000/frauds'));
    print(res);
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<Position>(
      future: _position,
      builder: (BuildContext context, AsyncSnapshot<Position> snapshot) {
        if (snapshot.hasData) {
          return Scaffold(
              appBar: AppBar(
                title: Text("Map"),
              ),
              body: OpenStreetMapSearchAndPick(
                  center: LatLong(snapshot.data.latitude, snapshot.data.longitude),
                  buttonColor: Colors.blue,
                  buttonText: 'Set Current Location',
                  onPicked: (pickedData) {
                    _sendPositionBack(context,pickedData.latLong.longitude,pickedData.latLong.latitude);
                  }));
        } else {
          return Center(
            child: CircularProgressIndicator(),
          );
        }
      },
    );
  }
}

void _sendPositionBack(BuildContext context,double long,double lat) {
  //String textToSendBack = textFieldController.text;
  Navigator.pop(context, Position(longitude: long, latitude: lat));
}

Future<Position> _setCurrentPos () async {
  Position pos = await _determinePosition();
  return pos;
}

Future<Position> _determinePosition() async {
  bool serviceEnabled;
  LocationPermission permission;

  // Test if location services are enabled.
  serviceEnabled = await Geolocator.isLocationServiceEnabled();
  if (!serviceEnabled) {
    // Location services are not enabled don't continue
    // accessing the position and request users of the
    // App to enable the location services.
    return Future.error('Location services are disabled.');
  }

  permission = await Geolocator.checkPermission();
  if (permission == LocationPermission.denied) {
    permission = await Geolocator.requestPermission();
    if (permission == LocationPermission.denied) {
      // Permissions are denied, next time you could try
      // requesting permissions again (this is also where
      // Android's shouldShowRequestPermissionRationale
      // returned true. According to Android guidelines
      // your App should show an explanatory UI now.
      return Future.error('Location permissions are denied');
    }
  }

  if (permission == LocationPermission.deniedForever) {
    // Permissions are denied forever, handle appropriately.
    return Future.error(
        'Location permissions are permanently denied, we cannot request permissions.');
  }

  // When we reach here, permissions are granted and we can
  // continue accessing the position of the device.
  //print("YOUR CURRENT POSITION");
  //print(Geolocator.getCurrentPosition());
  return await Geolocator.getCurrentPosition();
}


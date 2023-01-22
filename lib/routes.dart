import 'package:flutter/widgets.dart';
import 'package:smart_municipality/screens/details/details_screen.dart';
import 'package:smart_municipality/screens/home/home_screen.dart';
import 'package:smart_municipality/screens/form/form_screen.dart';
import 'package:smart_municipality/screens/map/map_screen.dart';


final Map<String, WidgetBuilder> routes = {

  HomeScreen.routeName: (context) => HomeScreen(),
  DetailsScreen.routeName: (context) => DetailsScreen(),
  //FraudForm.routeName: (context) => FraudForm(),
  //MapScreen.routeName: (context) => MapScreen(),

};

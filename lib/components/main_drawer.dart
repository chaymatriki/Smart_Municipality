import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:smart_municipality/screens/home/home_screen.dart';

class MainDrawer extends StatelessWidget {
  const MainDrawer({Key key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(children: [
      Container(
        child: Padding(
          padding: EdgeInsets.only(top: 50.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              SizedBox(
                height: 25.0,
              ),
              Text(
                "Catégories",
                style: TextStyle(
                  color: Colors.green[300],
                  fontWeight: FontWeight.bold,
                  fontSize: 40,
                ),
              ),
              SizedBox(
                height: 45.0,
              ),
            ],
          ),
        ),
      ),
      SizedBox(
        height: 20.0,
      ),
      ListTile(
        onTap: () {
          Navigator.popAndPushNamed(context, HomeScreen.routeName,
              arguments: {'categorie': "Santé et Beauté"});
        },
        leading: SvgPicture.asset(
          "assets/icons/cream.svg",
          height: 30,
          width: 30,
        ),
        title: Text(
          "Santé et Beauté",
          style: Theme.of(context).textTheme.headline6,
        ),
      ),
      ListTile(
        onTap: () {
          Navigator.popAndPushNamed(context, HomeScreen.routeName,
              arguments: {'categorie': "Produits animaliers"});
        },
        leading: SvgPicture.asset(
          "assets/icons/cow.svg",
          height: 30,
          width: 30,
        ),
        title: Text(
          "Produits animaliers",
          style: Theme.of(context).textTheme.headline6,
        ),
      ),
      ListTile(
        onTap: () {
          Navigator.popAndPushNamed(context, HomeScreen.routeName,
              arguments: {'categorie': "Plantes aromatiques et médicinales"});
        },
        leading: SvgPicture.asset(
          "assets/icons/herbs.svg",
          height: 30,
          width: 30,
        ),
        title: Text(
          "Plantes aromatiques et médicinales",
          style: Theme.of(context).textTheme.headline6,
        ),
      ),
      ListTile(
        onTap: () {
          Navigator.popAndPushNamed(context, HomeScreen.routeName,
              arguments: {'categorie': "Produits artisanaux"});
        },
        leading: SvgPicture.asset(
          "assets/icons/shopping-bag.svg",
          height: 30,
          width: 30,
        ),
        title: Text(
          "Produits artisanaux",
          style: Theme.of(context).textTheme.headline6,
        ),
      ),
      ListTile(
        onTap: () {
          Navigator.popAndPushNamed(context, HomeScreen.routeName,
              arguments: {'categorie': "Plats traditionnels"});
        },
        leading: SvgPicture.asset(
          "assets/icons/egg.svg",
          height: 30,
          width: 30,
        ),
        title: Text(
          "Plats traditionnels",
          style: Theme.of(context).textTheme.headline6,
        ),
      ),
    ]);
  }
}

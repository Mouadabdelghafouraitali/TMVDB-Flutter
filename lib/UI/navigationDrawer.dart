import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:themoviesdb/UI/Home.dart';
import 'package:themoviesdb/UI/TVShow/TVShowMain.dart';
import 'package:themoviesdb/Utils/Guider.dart';
import 'package:themoviesdb/Utils/Helper.dart';

import 'Movie/MovieMain.dart';

Widget navigationDrawer(BuildContext context) {
  List<Guider> guiderList = [];
  guiderList.add(Guider('HOME', () => Home()));
  guiderList.add(Guider('MOVIES', () => MovieMain()));
  guiderList.add(Guider('TV SHOWS', () => TVShowMain()));
  return Drawer(
    child: Align(
      alignment: Alignment.center,
      child: Stack(
        children: <Widget>[
          Container(
            color: MaterialColor(0xFF080E10, Helper.color),
            child: Padding(
              padding: const EdgeInsets.all(4.0),
              child: Align(
                alignment: Alignment.bottomCenter,
                child: Opacity(
                  opacity: 0.3,
                  child: Image(
                    alignment: Alignment.bottomCenter,
                    image: ExactAssetImage(
                      'assets/images/lines_vertical.png',
                    ),
                    fit: BoxFit.cover,
                  ),
                ),
              ),
            ),
          ),
          Container(
            width: double.infinity,
            height: double.infinity,
            child: Padding(
              padding: const EdgeInsets.all(16.0),
              child: Transform.translate(
                offset: Offset(0, 150),
                child: ListView.builder(
                  itemBuilder: (context, index) {
                    return _navigationDrawerItem(guiderList[index].title, guiderList[index].destination, context);
                  },
                  itemCount: guiderList.length,
                ),
              ),
            ),
          )
        ],
      ),
    ),
  );
}

_navigationDrawerItem(String title, Function destination, BuildContext context) {
  return ListTile(
    title: Text(
      title,
      style: TextStyle(
        fontSize: 28,
        fontWeight: FontWeight.bold,
        color: Colors.white,
      ),
    ),
    trailing: Icon(
      Icons.arrow_forward_ios,
      size: 16,
      color: Colors.white,
    ),
    onTap: () {
      _goTo(context, destination);
    },
  );
}

void _goTo(BuildContext context, Function destination) {
  Navigator.pop(context);
  Navigator.push(context, MaterialPageRoute(builder: (BuildContext context) {
    return destination();
  }));
}

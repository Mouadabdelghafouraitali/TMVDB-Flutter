import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:themoviesdb/Utils/Helper.dart';

import 'UI/Home.dart';
import 'UI/SplashScreen.dart';

void main() async {
  Widget _currentScreen;
  WidgetsFlutterBinding.ensureInitialized();
  SharedPreferences prefs = await SharedPreferences.getInstance();
  bool isWelcomeScreenPassed = prefs.getBool("onBoarding");
  if (prefs != null && isWelcomeScreenPassed != null) {
    if (isWelcomeScreenPassed)
      _currentScreen = Home();
    else
      _currentScreen = SplashScreen();
  } else {
    _currentScreen = SplashScreen();
  }
  runApp(MyApp(_currentScreen));
}

class MyApp extends StatelessWidget {
  Widget _currentScreen;

  MyApp(Widget _currentScreen) {
    this._currentScreen = _currentScreen;
  }
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'THE MOVIE DB',
      theme: ThemeData(
        fontFamily: 'PoppinsMedium',
        primarySwatch: MaterialColor(0xFF080E10, Helper.color),
      ),
      home: _currentScreen,
    );
  }
}

import 'package:booklines/screens/home.dart';
import 'package:booklines/theme.dart';
import 'package:flutter/material.dart';
import 'package:splashscreen/splashscreen.dart';

class SplashPage extends StatefulWidget {
  @override
  _SplashPageState createState() => new _SplashPageState();
}

class _SplashPageState extends State<SplashPage> {
  @override
  Widget build(BuildContext context) {
    return new SplashScreen(
      seconds: 2,
      navigateAfterSeconds: new HomePage(title: "Home"),
      title: new Text('Booklines',
      style: new TextStyle(
        fontWeight: FontWeight.bold,
        fontSize: 36.0
      ),),
      backgroundColor: Colors.white,
      styleTextUnderTheLoader: new TextStyle(),
      photoSize: 64.0,
      loaderColor: ThemeColors.primaryColor
    );
  }
}

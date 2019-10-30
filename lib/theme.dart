import 'package:flutter/material.dart';

class ThemeColors {
  static const primaryColor = Color.fromRGBO(65, 155, 249, 1.0);
  static const textColor = Color.fromRGBO(85, 77, 86, 1.0);
  static const secondaryColor = Color.fromRGBO(237, 236, 237, 1.0);
  static const snowmanColor = Color.fromRGBO(251, 251, 251, 1.0);
  static const backgroundColor = Color.fromRGBO(251, 251, 251, 1.0);
}

final theme = new ThemeData(
    scaffoldBackgroundColor: ThemeColors.secondaryColor,
    primaryTextTheme:
        TextTheme(title: TextStyle(color: ThemeColors.textColor)),
    primaryColor: ThemeColors.primaryColor,
    buttonTheme: ButtonThemeData(
        textTheme: ButtonTextTheme.primary,
        shape: RoundedRectangleBorder(
          borderRadius: new BorderRadius.circular(2.0),
        ),
        padding: EdgeInsets.symmetric(vertical: 4, horizontal: 12)),
    cardTheme: CardTheme(
      color: Colors.white,
      elevation: 1,
      margin: new EdgeInsets.only(bottom: 12),
      shape: RoundedRectangleBorder(
          side: BorderSide(width: 1, color: ThemeColors.secondaryColor),
          borderRadius: new BorderRadius.circular(4.0)),
      clipBehavior: Clip.antiAlias,
    ),
    appBarTheme: AppBarTheme(
        iconTheme: IconThemeData(color: ThemeColors.primaryColor),
        actionsIconTheme:
            IconThemeData(color: ThemeColors.primaryColor),
        color: ThemeColors.backgroundColor,
        textTheme: TextTheme(),
        elevation: 1));

import 'package:flutter/material.dart';
import 'package:booklines/screens/home.dart';
import 'package:booklines/screens/book.dart';

void main() => runApp(new MyApp());

class MyApp extends StatelessWidget {
    final theme = new ThemeData(
        primaryColor: Color.fromRGBO(85, 77, 86, 1.0),
        buttonTheme: ButtonThemeData(
            buttonColor: Color.fromRGBO(65, 155, 249, 1.0),
            textTheme: ButtonTextTheme.primary,
            shape: RoundedRectangleBorder(borderRadius: new BorderRadius.circular(2.0),),
            padding: EdgeInsets.symmetric(vertical: 4, horizontal: 12)
        ),
        cardTheme: CardTheme(
            color: Colors.white,
            elevation: 0,
            margin: new EdgeInsets.only(bottom: 12),
            shape: RoundedRectangleBorder(borderRadius: new BorderRadius.circular(2.0)),
            clipBehavior: Clip.antiAlias,

        )
    );

    // This widget is the root of your application.
    @override
    Widget build(BuildContext context) {
        return new MaterialApp(
        title: 'Flutter Demo',
        theme: theme,
        initialRoute: '/',
        routes: {
            // When navigating to the "/" route, build the FirstScreen widget.
            '/': (context) => HomePage(title: "Home"),
            // When navigating to the "/second" route, build the SecondScreen widget.
            '/book': (context) => BookPage(),
        },
        );
    }
}

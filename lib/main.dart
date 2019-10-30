import 'package:booklines/screens/line_detail.dart';
import 'package:booklines/screens/line_edit.dart';
import 'package:booklines/theme.dart' as MainTheme;
import 'package:flutter/material.dart';
import 'package:booklines/screens/home.dart';
import 'package:booklines/screens/book_edit.dart';
import 'package:booklines/screens/book_detail.dart';

void main() => runApp(new MyApp());

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return new MaterialApp(
      title: 'Flutter Demo',
      theme: MainTheme.theme,
      initialRoute: '/',
      routes: {
        // When navigating to the "/" route, build the FirstScreen widget.
        '/': (context) => HomePage(title: "Home"),
        // When navigating to the "/second" route, build the SecondScreen widget.
        '/book': (context) => BookDetail(),
        '/book/edit': (context) => BookEditPage(),
        '/line': (context) => LineDetail(),
        '/line/edit': (context) => LineEditPage(),
      },
    );
  }
}

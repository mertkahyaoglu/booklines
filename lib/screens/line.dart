import 'package:booklines/models/line.dart';
import 'package:booklines/screens/widgets/line_form.dart';
import 'package:flutter/material.dart';

class LinePage extends StatefulWidget {
  LinePage({Key key, this.line, this.isCreate}) : super(key: key);

  final Line line;
  final bool isCreate;

  @override
  _LinePageState createState() => _LinePageState(line, isCreate);
}

class _LinePageState extends State<LinePage> {
  final Line line;
  final bool isCreate;

  _LinePageState(this.line, this.isCreate);

  void onSubmit(line) {
    Navigator.pop(context, line);
  }

  @override
  Widget build(BuildContext context) {
    final topAppBar = AppBar(
      title: Text("Booklines"),
    );

    final makeBody = Container(
      child: Container(
        padding: const EdgeInsets.all(8),
        child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [LineForm(line, isCreate, onSubmit)]),
      ),
    );

    return Scaffold(
        backgroundColor: Colors.white, appBar: topAppBar, body: makeBody);
  }
}

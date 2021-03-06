import 'package:booklines/models/line.dart';
import 'package:booklines/screens/widgets/line_form.dart';
import 'package:flutter/material.dart';

class LineEditPage extends StatefulWidget {
  LineEditPage({Key key, this.line, this.isCreate}) : super(key: key);

  final Line line;
  final bool isCreate;

  @override
  _LineEditPageState createState() => _LineEditPageState(line, isCreate);
}

class _LineEditPageState extends State<LineEditPage> {
  final Line line;
  final bool isCreate;

  _LineEditPageState(this.line, this.isCreate);

  void onSubmit(line) {
    Navigator.pop(context, line);
  }

  @override
  Widget build(BuildContext context) {
    final topAppBar = AppBar(
      title: Text("Booklines"),
    );

    final makeBody =
        Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
        Expanded(
            child: SingleChildScrollView(
                padding: const EdgeInsets.all(12),
                child: LineForm(line, isCreate, onSubmit)),
        )
    ]);

    return Scaffold(appBar: topAppBar, body: makeBody);
  }
}

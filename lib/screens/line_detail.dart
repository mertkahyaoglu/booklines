import 'package:booklines/models/book.dart';
import 'package:booklines/models/line.dart';
import 'package:booklines/screens/book_edit.dart';
import 'package:booklines/theme.dart';
import 'package:expandable/expandable.dart';
import 'package:flutter/material.dart';

class LineDetail extends StatefulWidget {
  final Line line;

  LineDetail({Key key, this.line}) : super(key: key);

  @override
  _LineDetailState createState() => _LineDetailState(line);
}

class _LineDetailState extends State<LineDetail> {
  Line line;

  _LineDetailState(this.line);

  @override
  Widget build(BuildContext context) {
    final topAppBar = AppBar(title: Text("Line"), actions: <Widget>[
      IconButton(
        icon: Icon(Icons.delete),
        onPressed: () {
          showDialog(
            barrierDismissible: false,
            context: context,
            builder: (BuildContext context) {
              // return object of type Dialog
              return AlertDialog(
                content: Text("Delete this line?"),
                actions: <Widget>[
                  new FlatButton(
                    child: new Text("CANCEL"),
                    onPressed: () {
                      Navigator.pop(context);
                    },
                  ),
                  new FlatButton(
                    child: Text(
                      "DELETE",
                      style: TextStyle(color: Colors.red[400]),
                    ),
                    onPressed: () {
                      // deleteBook(book);
                      Navigator.pop(context);
                      Navigator.pop(context);
                    },
                  ),
                ],
              );
            },
          );
        },
      )
    ]);

    final makeBody = Container(
      padding: const EdgeInsets.all(12),
      child: Card(
        child: Container(
            padding: const EdgeInsets.all(24),
            child: Row(children: [
              Flexible( child: Text(
                line.line,
                style: TextStyle(fontSize: 20),
              ))
            ])),
      ),
    );

    return Scaffold(
      appBar: topAppBar,
      body: makeBody,
    );
  }
}

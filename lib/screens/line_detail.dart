import 'package:booklines/models/line.dart';
import 'package:flutter/material.dart';
import 'package:share/share.dart';

class LineDetail extends StatefulWidget {
  final Line line;
  final Function onDelete;
  final String title;

  LineDetail({Key key, this.line, this.title, this.onDelete}) : super(key: key);

  @override
  _LineDetailState createState() => _LineDetailState();
}

class _LineDetailState extends State<LineDetail> {
  @override
  Widget build(BuildContext context) {
    Line line = widget.line;
    String title = widget.title;
    Function onDelete = widget.onDelete;

    final topAppBar = AppBar(title: Text(title), actions: <Widget>[
      PopupMenuButton(
        icon: Icon(Icons.more_vert),
        onSelected: (result) async {
          switch (result) {
            case 'delete':
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
                          onDelete(line);

                          Navigator.pop(context);
                          Navigator.pop(context);
                        },
                      ),
                    ],
                  );
                },
              );
              break;
            case 'share':
              Share.share(line.line);
              break;
            default:
          }
          setState(() {});
        },
        itemBuilder: (BuildContext context) => <PopupMenuEntry>[
          const PopupMenuItem(
            value: "share",
            child: Text('Share'),
          ),
          const PopupMenuItem(
            value: "delete",
            child: Text(
              'Delete',
              style: TextStyle(color: Colors.red),
            ),
          ),
        ],
      ),
    ]);

    final makeBody = Container(
      padding: const EdgeInsets.all(12),
      child: Card(
        child: SingleChildScrollView(
            padding: const EdgeInsets.all(24),
            child: Row(children: [
              Flexible(
                  child: Text(
                line.line,
                style: TextStyle(fontSize: 18, fontStyle: FontStyle.italic),
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

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
        icon: Icon(Icons.delete, color: Colors.red[400]),
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

    void onSubmit(book) {
      updateBook(book);
    }

    final makeListTile = (Book book) => Column(
          children: <Widget>[
            Container(
              height: 90,
              decoration: new BoxDecoration(
                color: ThemeColors.snowmanColor,
              ),
            ),
            ListTile(
              contentPadding:
                  EdgeInsets.symmetric(horizontal: 20.0, vertical: 10.0),
              title: Text(
                book.title,
                style: TextStyle(fontWeight: FontWeight.bold),
              ),
              subtitle:
                  (book.description != null) ? Text(book.description) : null,
              onTap: () => {},
              trailing: IconButton(
                icon: Icon(
                  Icons.edit,
                  color: ThemeColors.textColor,
                ),
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) {
                        return BookEditPage(book: book, isCreate: false);
                      },
                    ),
                  );
                },
              ),
            )
          ],
        );

    final makeBody = Container(
      child: Container(
        padding: const EdgeInsets.all(8),
        child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
          ExpandablePanel(
            collapsed: Text(
              line.line,
              softWrap: true,
              maxLines: 2,
              overflow: TextOverflow.ellipsis,
            ),
            expanded: Text(
              line.line,
              softWrap: true,
            ),
            tapHeaderToExpand: true,
            hasIcon: true,
          )
        ]),
      ),
    );

    return Scaffold(
      appBar: topAppBar,
      body: makeBody,
    );
  }
}

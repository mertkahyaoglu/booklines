import 'package:booklines/models/book.dart';
import 'package:flutter/material.dart';

class BookPage extends StatefulWidget {
  final Book book;

  BookPage({Key key, this.book}) : super(key: key);

  @override
  _BookPageState createState() => _BookPageState(book);
}

class _BookPageState extends State<BookPage> {
  Book book;

  _BookPageState(this.book);

  @override
  Widget build(BuildContext context) {
    final topAppBar = AppBar(
      title: Text(book.title.isEmpty ? "Create a book" : book.title),
      actions: <Widget>[
        IconButton(
          icon: Icon(Icons.list),
          onPressed: () {},
        )
      ],
    );

    final makeBody = Container(
      child: Container(
        padding: const EdgeInsets.all(8),
        child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
          Text(
            book.title,
            style: TextStyle(
              fontWeight: FontWeight.bold,
            ),
          ),
          Text(book.description,
              style: TextStyle(
                color: Colors.grey[500],
              )),
          SizedBox(
            width: double.maxFinite, // set width to maxFinite
            child: RaisedButton(
              //Button Color is as define in theme
              onPressed: () {},
              child: Text("Save"), //Text Color as define in theme
            ),
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

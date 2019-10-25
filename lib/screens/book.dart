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
      elevation: 0.1,
      backgroundColor: Color.fromRGBO(58, 66, 86, 1.0),
      title: Text(book.title),
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
            Text(
                book.description,
                style: TextStyle(
                    color: Colors.grey[500],
                )
            ),
            RaisedButton( //Button Color is as define in theme
                onPressed: () {},
                child: Text("Send"), //Text Color as define in theme
            ),
        ]),
      ),
    );

    return Scaffold(
      backgroundColor: Color.fromRGBO(58, 66, 86, 1.0),
      appBar: topAppBar,
      body: makeBody,
    );
  }
}

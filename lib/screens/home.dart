import 'package:booklines/models/book.dart';
import 'package:booklines/screens/book.dart';
import 'package:flutter/material.dart';

class HomePage extends StatefulWidget {
  HomePage({Key key, this.title}) : super(key: key);

  final String title;

  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  final books = List.generate(
    20,
    (i) => Book(
      'Book $i',
      'A description of what needs to be done for Book $i',
    ),
  );

  @override
  Widget build(BuildContext context) {
    final topAppBar = AppBar(
      elevation: 0.1,
      backgroundColor: Color.fromRGBO(58, 66, 86, 1.0),
      title: Text(widget.title),
      actions: <Widget>[
        IconButton(
          icon: Icon(Icons.list),
          onPressed: () {},
        )
      ],
    );

    final makeListTile = (Book book) => ListTile(
          contentPadding:
              EdgeInsets.symmetric(horizontal: 20.0, vertical: 10.0),
          title: Text(
            book.title,
            style: TextStyle(fontWeight: FontWeight.bold),
          ),
          subtitle: Row(
            children: <Widget>[Text('${book.lines.length} lines added')],
          ),
          onTap: () => {
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => BookPage(book: book),
              ),
            )
          },
        );

    final makeCard = (index) => Card(
          child: Container(
            decoration: BoxDecoration(
                border: Border.all(
                    color: Color.fromRGBO(237, 236, 237, 1.0), width: 0.5)),
            child: makeListTile(books[index]),
          ),
        );

    final makeBody = Container(
      margin: EdgeInsets.symmetric(vertical: 12),
      child: ListView.builder(
        scrollDirection: Axis.vertical,
        shrinkWrap: true,
        itemCount: 10,
        itemBuilder: (BuildContext context, int index) {
          return makeCard(index);
        },
      ),
    );

    return Scaffold(
      backgroundColor: Colors.white,
      appBar: topAppBar,
      body: makeBody,
    );
  }
}
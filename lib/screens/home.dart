import 'package:booklines/models/book.dart';
import 'package:booklines/screens/book_detail.dart';
import 'package:booklines/screens/book_edit.dart';
import 'package:flutter/material.dart';

class HomePage extends StatefulWidget {
  HomePage({Key key, this.title}) : super(key: key);

  final String title;

  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  @override
  Widget build(BuildContext context) {
    final topAppBar = AppBar(
      title: Text("Booklines", style: TextStyle(fontWeight: FontWeight.bold)),
    );

    final makeListTile = (Book book) => ListTile(
          contentPadding:
              EdgeInsets.symmetric(horizontal: 20.0, vertical: 10.0),
          title: Text(
            book.title,
            style: TextStyle(fontWeight: FontWeight.bold),
          ),
          subtitle: Row(
            children: <Widget>[Text('${book.lines.length} ${(book.lines.length > 1 ? "lines" : "line")} added')],
          ),
          onTap: () => {
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => BookDetail(book: book),
              ),
            )
          },
        );

    final makeCard = (Book book) => Card(
          child: Container(
            decoration: BoxDecoration(
                border: Border.all(
                    color: Color.fromRGBO(237, 236, 237, 1.0), width: 0.5)),
            child: makeListTile(book),
          ),
        );

    Widget renderEmpty() {
      return Center(
            child: Text("Press + button to create your first book.", style: TextStyle(fontSize: 20), textAlign: TextAlign.center,)
          );
    }

    final makeBody = Container(
      margin: EdgeInsets.all(12),
      child: FutureBuilder<List<Book>>(
        future: getBooks(),
        builder: (context, snapshot) {
          if (!snapshot.hasData)
            return Center(child: CircularProgressIndicator());

          if (snapshot.data.length == 0) return renderEmpty();

          return ListView(
            children: snapshot.data.map((book) => makeCard(book)).toList(),
          );
        },
      ),
    );

    return Scaffold(
      appBar: topAppBar,
      body: makeBody,
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) {
                Book book = Book("", "");
                return BookEditPage(book: book, isCreate: true);
              },
            ),
          );
        },
        child: Icon(
          Icons.add,
        ),
      ),
    );
  }
}

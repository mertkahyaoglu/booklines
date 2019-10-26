import 'package:booklines/models/book.dart';
import 'package:booklines/screens/book.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

class HomePage extends StatefulWidget {
  HomePage({Key key, this.title}) : super(key: key);

  final String title;

  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  Stream<QuerySnapshot> getBookSnapshots() {
    return Firestore.instance.collection('books').snapshots();
  }

  @override
  Widget build(BuildContext context) {
    final topAppBar = AppBar(
      title: Text("Booklines"),
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

    final makeCard = (Book book) => Card(
          child: Container(
            decoration: BoxDecoration(
                border: Border.all(
                    color: Color.fromRGBO(237, 236, 237, 1.0), width: 0.5)),
            child: makeListTile(book),
          ),
        );

    final makeBody = Container(
        margin: EdgeInsets.all(12),
        child: StreamBuilder(
            stream: getBookSnapshots(),
            builder: (context, snapshot) {
              if (!snapshot.hasData) {
                return Container(child: Center(child: Text("No data")));
              }

              return ListView.builder(
                  scrollDirection: Axis.vertical,
                  shrinkWrap: true,
                  itemCount: snapshot.data.documents.length,
                  itemBuilder: (_, int index) {
                    return makeCard(Book.fromSnapshot(snapshot.data.documents[
                        index]));
                  });
            }));

    return Scaffold(
      backgroundColor: Colors.white,
      appBar: topAppBar,
      body: makeBody,
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => BookPage(book: new Book("", "")),
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

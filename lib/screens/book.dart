import 'package:booklines/models/book.dart';
import 'package:booklines/screens/widgets/book_form.dart';
import 'package:flutter/material.dart';

class BookPage extends StatefulWidget {
  final Book book;
  final bool isCreate;

  BookPage({Key key, this.book, this.isCreate = false}) : super(key: key);

  @override
  _BookPageState createState() => _BookPageState(book, isCreate);
}

class _BookPageState extends State<BookPage> {
  Book book;
  bool isCreate;

  _BookPageState(this.book, this.isCreate);

  @override
  Widget build(BuildContext context) {
    final topAppBar = AppBar(
      title: Text(isCreate ? "Create a book" : book.title),
      actions: !isCreate
          ? <Widget>[
              IconButton(
                icon: Icon(Icons.delete, color: Colors.red[400]),
                onPressed: () {
                  showDialog(
                      barrierDismissible: false,
                    context: context,
                    builder: (BuildContext context) {
                      // return object of type Dialog
                      return AlertDialog(
                        content: Text.rich(
                          TextSpan(
                            text: 'Delete ', // default text style
                            children: <TextSpan>[
                              TextSpan(
                                  text: book.title,
                                  style:
                                      TextStyle(fontWeight: FontWeight.bold)),
                              TextSpan(text: "?"),
                            ],
                          ),
                        ),
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
                              deleteBook(book);
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
            ]
          : null,
    );

    void onSubmit (book) {
        if (isCreate) {
            insertBook(book);
            setState(() {
                isCreate = false;
            });
        } else {
            updateBook(book);
        }
    }

    final makeBody = Container(
      child: Container(
        padding: const EdgeInsets.all(8),
        child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
          BookForm(book, isCreate, onSubmit),
        ]),
      ),
    );

    return Scaffold(
      appBar: topAppBar,
      body: makeBody,
    );
  }
}

import 'package:booklines/models/book.dart';
import 'package:booklines/screens/widgets/book_form.dart';
import 'package:flutter/material.dart';

class BookEditPage extends StatefulWidget {
  final Book book;
  final bool isCreate;

  BookEditPage({Key key, this.book, this.isCreate = false}) : super(key: key);

  @override
  _BookEditPageState createState() => _BookEditPageState(book, isCreate);
}

class _BookEditPageState extends State<BookEditPage> {
  Book book;
  bool isCreate;

  _BookEditPageState(this.book, this.isCreate);

  @override
  Widget build(BuildContext context) {
    final topAppBar = AppBar(
      title: Text(isCreate ? "Create a book" : book.title),
      actions: !isCreate
          ? <Widget>[
              IconButton(
                icon: Icon(Icons.delete),
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
                              Navigator.pushNamedAndRemoveUntil(context, "/home", (Route<dynamic> route) => false);
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

        Navigator.pop(context);
    }

    final makeBody = Container(
      child: Container(
        padding: const EdgeInsets.all(12),
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

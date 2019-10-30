import 'package:booklines/models/book.dart';
import 'package:booklines/models/line.dart';
import 'package:booklines/screens/book_edit.dart';
import 'package:booklines/screens/line_detail.dart';
import 'package:booklines/screens/line_edit.dart';
import 'package:booklines/theme.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:mlkit/mlkit.dart';

class BookDetail extends StatefulWidget {
  final Book book;

  BookDetail({Key key, this.book}) : super(key: key);

  @override
  _BookDetailState createState() => _BookDetailState(book);
}

class _BookDetailState extends State<BookDetail> {
  Book book;

  _BookDetailState(this.book);

  @override
  Widget build(BuildContext context) {
    final topAppBar = AppBar(title: Text(book.title), actions: <Widget>[
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
                          style: TextStyle(fontWeight: FontWeight.bold)),
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

    void passTextToLineScreen({text = ""}) async {
      Navigator.pop(context);
      final Line line = await Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) {
            Line createLine = Line(text, 0);
            return LineEditPage(line: createLine, isCreate: true);
          },
        ),
      );
      print(line.line);
    }

    final FirebaseVisionTextDetector detector =
        FirebaseVisionTextDetector.instance;
    void pickImageFromGallery() async {
      try {
        var file = await ImagePicker.pickImage(source: ImageSource.gallery);
        if (file != null) {
          List<VisionText> visionTextList =
              await detector.detectFromPath(file?.path);
          String wholeText = visionTextList.map((vt) => vt.text).join('\n');
          passTextToLineScreen(text: wholeText);
        }
      } catch (e) {
        print(e.toString());
      }
    }

    void addWithKeyboard() {
      try {
        passTextToLineScreen();
      } catch (e) {
        print(e.toString());
      }
    }

    void showAddLineDialog(context) {
      showModalBottomSheet(
          context: context,
          builder: (BuildContext bc) {
            return Container(
              child: new Wrap(
                children: <Widget>[
                  new ListTile(
                      leading: new Icon(Icons.camera),
                      title: new Text('Add with camera'),
                      onTap: () => {}),
                  new ListTile(
                      leading: new Icon(Icons.image),
                      title: new Text('Choose from gallery'),
                      onTap: () {
                        pickImageFromGallery();
                      }),
                  new ListTile(
                    leading: new Icon(Icons.keyboard),
                    title: new Text('Add with keyboard'),
                    onTap: () {
                      addWithKeyboard();
                    },
                  ),
                ],
              ),
            );
          });
    }

    final makeLineListTile = (Line line) => ListTile(
          contentPadding:
              EdgeInsets.symmetric(horizontal: 20.0, vertical: 10.0),
          title: Text(
            line.line,
            style: TextStyle(fontWeight: FontWeight.bold),
          ),
          onTap: () => {
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => LineDetail(line: line),
              ),
            )
          },
        );

    final makeLineCard = (Line line) => Card(
          child: Container(
            decoration: BoxDecoration(
                border: Border.all(
                    color: Color.fromRGBO(237, 236, 237, 1.0), width: 0.5)),
            child: makeLineListTile(line),
          ),
        );

    final makeBody = Container(
      child: Container(
        padding: const EdgeInsets.all(8),
        child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
          Card(
            semanticContainer: true,
            child: Container(
              decoration: BoxDecoration(
                  border: Border.all(
                      color: Color.fromRGBO(237, 236, 237, 1.0), width: 0.5)),
              child: makeListTile(book),
            ),
          ),
          if (book.lines.length > 0)
            ListView(
                children:
                    book.lines.map((line) => makeLineCard(line)).toList()),
          FlatButton.icon(
            padding: EdgeInsets.symmetric(vertical: 12),
            icon: Icon(Icons.add),
            label: Text(
              'Add a line',
              style: TextStyle(fontSize: 16),
            ),
            onPressed: () {
              showAddLineDialog(context);
            },
          ),
        ]),
      ),
    );

    return Scaffold(
      appBar: topAppBar,
      body: makeBody,
    );
  }
}

import 'dart:io';

import 'package:booklines/models/book.dart';
import 'package:booklines/models/line.dart';
import 'package:booklines/screens/book_edit.dart';
import 'package:booklines/screens/line_detail.dart';
import 'package:booklines/screens/line_edit.dart';
import 'package:booklines/screens/take_picture.dart';
import 'package:booklines/theme.dart';
import 'package:camera/camera.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:mlkit/mlkit.dart';
import 'package:share/share.dart';

class BookDetail extends StatefulWidget {
  final Book book;

  BookDetail({Key key, this.book}) : super(key: key);

  @override
  _BookDetailState createState() => _BookDetailState(book);
}

class _BookDetailState extends State<BookDetail> {
  Book book;

  _BookDetailState(this.book);

  final FirebaseVisionTextDetector detector =
      FirebaseVisionTextDetector.instance;

  Line addedLine;

  @override
  Widget build(BuildContext context) {
    final topAppBar = AppBar(title: Text(book.title), actions: <Widget>[
      IconButton(
        icon: Icon(Icons.delete),
        onPressed: () {
          showDialog(
            barrierDismissible: false,
            context: context,
            builder: (BuildContext context) {
              return AlertDialog(
                content: Text.rich(
                  TextSpan(
                    text: 'Delete ',
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
              onTap: () => {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) {
                      return BookEditPage(book: book, isCreate: false);
                    },
                  ),
                )
              },
              trailing: Icon(
                Icons.edit,
                color: ThemeColors.textColor,
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
      print(line);
      line.bookId = book.id;
      int id = await insertLine(line);
      line.id = id;

      book.addLine(line);

      setState(() {
        addedLine = line;
      });
    }

    void takePicture() async {
      Navigator.pop(context);

      List<CameraDescription> cameras = await availableCameras();

      final File imageFile = await Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) {
            return TakePicturePage(camera: cameras.first);
          },
        ),
      );
      if (imageFile != null) {
        try {
          List<VisionText> visionTextList =
              await detector.detectFromPath(imageFile?.path);
          String wholeText = visionTextList.map((vt) => vt.text).join('\n');
          passTextToLineScreen(text: wholeText);
        } catch (e) {
          print(e.toString());
        }
      }
    }

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
                      onTap: () => {takePicture()}),
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
          contentPadding: EdgeInsets.fromLTRB(20, 10, 0, 10),
          title: Text(
            line.line,
            overflow: TextOverflow.ellipsis,
            maxLines: 1,
            style: new TextStyle(
              fontSize: 13.0,
              fontWeight: FontWeight.bold,
            ),
          ),
            subtitle: line.pageNumber > 0 ? Text(line.pageNumber.toString()) : null,
          onTap: () => {
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => LineDetail(line: line),
              ),
            )
          },
          trailing: PopupMenuButton(
            icon: Icon(Icons.more_vert),
            onSelected: (result) async {
              switch (result) {
                case 'delete':
                  await deleteLine(line);
                  book.deleteLine(line.id);
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
      padding: const EdgeInsets.all(12),
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
        if (book.lines.length > 0)
          Expanded(
            child: ListView(
                shrinkWrap: true,
                children:
                    book.lines.map((line) => makeLineCard(line)).toList()),
          )
      ]),
    );

    return Scaffold(
      appBar: topAppBar,
      body: makeBody,
    );
  }
}

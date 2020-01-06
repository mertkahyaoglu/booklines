import 'dart:io';

import 'package:booklines/models/book.dart';
import 'package:booklines/models/line.dart';
import 'package:booklines/screens/book_edit.dart';
import 'package:booklines/screens/crop_picture.dart';
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
    book.lines.sort((a, b) => b.id.compareTo(a.id));
    final topAppBar = AppBar(title: Text(book.title), actions: <Widget>[
      IconButton(
          icon: Icon(Icons.edit),
          onPressed: () {
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) {
                  return BookEditPage(book: book, isCreate: false);
                },
              ),
            );
          })
    ]);

    final makeListTile = (Book book) => Column(
          children: <Widget>[
            ListTile(
              contentPadding:
                  EdgeInsets.symmetric(horizontal: 20.0, vertical: 10.0),
              title: Text(
                book.title,
                style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18),
              ),
              subtitle:
                  (book.description != null) ? Text(book.description) : null,
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

      if (line != null) {
        line.bookId = book.id;
        int id = await insertLine(line);
        line.id = id;

        book.addLine(line);

        setState(() {
          addedLine = line;
        });
      }
    }

    void takePicture() async {
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
        File imageFile =
            await ImagePicker.pickImage(source: ImageSource.gallery);

        if (imageFile != null) {
          File croppedFile = await Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) {
                return CropPicturePage(imageFile: imageFile);
              },
            ),
          );

          File targetFile = croppedFile != null ? croppedFile : imageFile;

          List<VisionText> visionTextList =
              await detector.detectFromPath(targetFile?.path);
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

    void onLineDelete(line) async {
      await deleteLine(line);
      book.deleteLine(line.id);
      setState(() {});
    }

    final makeLineListTile = (Line line) => ListTile(
          contentPadding: EdgeInsets.fromLTRB(20, 0, 0, 0),
          title: Text(
            line.line,
            overflow: TextOverflow.ellipsis,
            maxLines: 1,
            style: new TextStyle(
                fontSize: 13.0,
                fontWeight: FontWeight.bold,
                fontStyle: FontStyle.italic),
          ),
          onTap: () => {
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => LineDetail(
                    line: line,
                    title: '${book.title} - Line',
                    onDelete: onLineDelete),
              ),
            )
          },
          trailing: PopupMenuButton(
            icon: Icon(Icons.more_vert),
            onSelected: (result) {
              switch (result) {
                case 'delete':
                  onLineDelete(line);
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
          child: Container(
            child: makeListTile(book),
          ),
        ),
        if (book.lines.length == 0)
          Container(
            padding: const EdgeInsets.symmetric(vertical: 12),
            child: Center(
                child: Text(
              "Press + button to create your first line.",
              style: TextStyle(fontSize: 18),
            )),
          ),
        if (book.lines.length > 0)
          Container(
            padding: const EdgeInsets.symmetric(vertical: 12),
            child: Text(
              'Lines',
              style: TextStyle(
                  fontSize: 18,
                  color: ThemeColors.textColor,
                  fontWeight: FontWeight.bold),
            ),
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
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          showAddLineDialog(context);
        },
        child: Icon(
          Icons.add,
        ),
      ),
    );
  }
}

import 'package:booklines/models/book.dart';
import 'package:booklines/models/line.dart';
import 'package:booklines/screens/line.dart';
import 'package:booklines/theme.dart';
import 'package:expandable/expandable.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:mlkit/mlkit.dart';

class BookForm extends StatefulWidget {
  final Book book;
  final Function onSubmit;
  final bool isCreate;

  BookForm(this.book, this.isCreate, this.onSubmit);

  @override
  _BookFormState createState() => _BookFormState(book, isCreate, onSubmit);
}

class _BookFormState extends State<BookForm> {
  final FirebaseVisionTextDetector detector =
      FirebaseVisionTextDetector.instance;
  final Book book;
  final Function onSubmit;
  final _formKey = GlobalKey<FormState>();
  bool isCreate;

  _BookFormState(this.book, this.isCreate, this.onSubmit);

  String title;
  String description;
  Line lastAddedLine;

  submit() {
    if (_formKey.currentState.validate()) {
      _formKey.currentState.save();

      final snackBar = SnackBar(content: Text('Updated!'));

      Scaffold.of(context).showSnackBar(snackBar);

      book.title = title;
      book.description = description;
      book.addLine(lastAddedLine);

      onSubmit(book);
    }
  }

  bool isFormChanged() {
    if (title != book.title) {
      return true;
    }
    if (lastAddedLine != null) {
      return true;
    }
    return false;
  }

  @override
  Widget build(BuildContext context) {
    return new Form(
        key: _formKey,
        child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              TextFormField(
                initialValue: book.title,
                decoration: InputDecoration(labelText: 'Book Title'),
                keyboardType: TextInputType.text,
                validator: (value) {
                  if (value.isEmpty) {
                    return 'Please enter book title';
                  }
                  return null;
                },
                onChanged: (String val) {
                  setState(() {
                    title = val;
                  });
                },
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
                Column(children: [
                  Row(children: <Widget>[
                    Text("Lines", style: TextStyle(fontSize: 16))
                  ]),
                  Row(
                      children: book.lines
                          .map((line) => ExpandablePanel(
                                collapsed: Text(
                                  line.line,
                                  softWrap: true,
                                  maxLines: 2,
                                  overflow: TextOverflow.ellipsis,
                                ),
                                expanded: Text(
                                  line.line,
                                  softWrap: true,
                                ),
                                tapHeaderToExpand: true,
                                hasIcon: true,
                              ))
                          .toList()),
                ]),
              SizedBox(
                width: double.maxFinite,
                child: RaisedButton(
                  onPressed: isFormChanged() ? submit : null,
                  color: isFormChanged()
                      ? ThemeColors.primaryColor
                      : ThemeColors.secondaryColor,
                  child: Text("Save"),
                ),
              )
            ]));
  }

  void passTextToLineScreen({text = ""}) async {
    Navigator.pop(context);
    final Line line = await Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) {
          Line createLine = Line(text, 0);
          return LinePage(line: createLine, isCreate: true);
        },
      ),
    );
    print(line.line);
    if (line != null) {
      book.addLine(line);
      setState(() {
        lastAddedLine = line;
      });
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
}

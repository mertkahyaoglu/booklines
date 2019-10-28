import 'package:booklines/models/book.dart';
import 'package:flutter/material.dart';

class BookForm extends StatefulWidget {
  final Book book;
  final Function onSubmit;
  bool isCreate;

  BookForm(this.book, this.isCreate, this.onSubmit);

  @override
  _BookFormState createState() => _BookFormState(book, isCreate, onSubmit);
}

class _BookFormState extends State<BookForm> {
  final _formKey = GlobalKey<FormState>();
  final Book book;
  final Function onSubmit;
  bool isCreate;

  _BookFormState(this.book, this.isCreate, this.onSubmit);

  String title;
  String description;

  submit() {
    if (_formKey.currentState.validate()) {
      _formKey.currentState.save();

      final snackBar = SnackBar(content: Text('Updated!'));

      Scaffold.of(context).showSnackBar(snackBar);

      book.title = title;
      book.description = description;

      onSubmit(book);
    }
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
              onSaved: (String val) {
                title = val;
              },
            ),
            TextFormField(
              initialValue: book.description,
              decoration: InputDecoration(labelText: 'Book Description'),
              keyboardType: TextInputType.text,
              validator: (value) {
                if (value.isEmpty) {
                  return 'Please enter book description';
                }
                return null;
              },
              onSaved: (String val) {
                description = val;
              },
            ),
            FlatButton.icon(
              padding: EdgeInsets.symmetric(vertical: 12),
              icon: Icon(Icons.add),
              label: Text('Add a line',style: TextStyle(fontSize: 16),),
              onPressed: () {
                showAddLineDialog(context);
              },
            ),
            SizedBox(
              width: double.maxFinite,
              child: RaisedButton(
                onPressed: submit,
                child: Text("Save"),
              ),
            )
          ],
        ));
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
                    onTap: () => {}),
                new ListTile(
                  leading: new Icon(Icons.keyboard),
                  title: new Text('Add with keyboard'),
                  onTap: () => {},
                ),
              ],
            ),
          );
        });
  }
}

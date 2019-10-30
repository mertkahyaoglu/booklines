import 'package:booklines/models/book.dart';
import 'package:booklines/theme.dart';
import 'package:expandable/expandable.dart';
import 'package:flutter/material.dart';

class BookForm extends StatefulWidget {
  final Book book;
  final Function onSubmit;
  final bool isCreate;

  BookForm(this.book, this.isCreate, this.onSubmit);

  @override
  _BookFormState createState() => _BookFormState(book, isCreate, onSubmit);
}

class _BookFormState extends State<BookForm> {
  final Book book;
  final Function onSubmit;
  final _formKey = GlobalKey<FormState>();
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

  bool isFormChanged() {
    if (title != book.title) {
      return true;
    }
    if (description != book.description) {
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
                maxLines: null,
                onChanged: (String val) {
                  setState(() {
                    description = val;
                  });
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
}

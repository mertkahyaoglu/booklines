import 'package:booklines/models/line.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class LineForm extends StatefulWidget {
  final Line line;
  final Function onSubmit;
  final bool isCreate;

  LineForm(this.line, this.isCreate, this.onSubmit);

  @override
  _LineFormState createState() => _LineFormState(line, isCreate, onSubmit);
}

class _LineFormState extends State<LineForm> {
  final _formKey = GlobalKey<FormState>();
  final Line line;
  final Function onSubmit;
  bool isCreate;
  String imageText;

  _LineFormState(this.line, this.isCreate, this.onSubmit);

  String lineText;

  submit() {
    if (_formKey.currentState.validate()) {
      _formKey.currentState.save();

      final snackBar = SnackBar(content: Text('Updated!'));

      Scaffold.of(context).showSnackBar(snackBar);

      line.line = lineText;
      line.pageNumber = 0;

      onSubmit(line);
    }
  }

  void addLineToBook() {}

  @override
  Widget build(BuildContext context) {
    return Card(
        child: Container(
            padding: EdgeInsets.all(12),
            child: Form(
                key: _formKey,
                child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: <Widget>[
                      TextFormField(
                        initialValue: line.line,
                        autofocus: line.line.isEmpty,
                        textCapitalization: TextCapitalization.sentences,
                        decoration: InputDecoration(labelText: 'Line'),
                        keyboardType: TextInputType.text,
                        maxLines: null,
                        validator: (value) {
                          if (value.isEmpty) {
                            return 'Please enter a line';
                          }
                          return null;
                        },
                        onSaved: (String val) {
                          lineText = val;
                        },
                      ),
                      Container(
                          child: SizedBox(
                            width: double.maxFinite,
                            child: RaisedButton(
                              onPressed: submit,
                              child: Text("Save"),
                            ),
                          ),
                          margin: new EdgeInsets.only(top: 12))
                    ]))));
  }
}

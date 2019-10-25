import 'package:uuid/uuid.dart';

var uuid = new Uuid();

class Line {
  String id;
  String line;
  int pageNumber;

  Line(String line, int pageNumber) {
    this.line = line;
    this.pageNumber = pageNumber;
    this.id = uuid.v1();
  }
}

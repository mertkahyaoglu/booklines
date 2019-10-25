import 'package:booklines/models/line.dart';
import 'package:uuid/uuid.dart';

var uuid = new Uuid();

class Book {
  String id;
  String title;
  String description;

  List<Line> lines = [];

  Book(String title, String description) {
    this.title = title;
    this.description = description;
    this.id = uuid.v1();
  }

  void addLine(Line line) {
    this.lines.add(line);
  }

  void deleteLine(String id) {
    this.lines.removeWhere((line) => line.id == id);
  }
}
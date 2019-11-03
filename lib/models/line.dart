import 'package:booklines/db.dart';
import 'package:sqflite/sqlite_api.dart';
import 'package:uuid/uuid.dart';

var uuid = new Uuid();

class Line {
  int id;
  String line;
  int pageNumber;
  int bookId;

  Line(this.line, this.pageNumber);

  Line.withId(int id, String line, int pageNumber, int bookId)
      : this.id = id,
        this.line = line,
        this.pageNumber = pageNumber,
        this.bookId = bookId;

  Line.fromMap(Map<dynamic, dynamic> data)
      : id = data["id"],
        line = data["line"],
        pageNumber = data['pageNumber'],
        bookId = data['bookId'];

  Map<String, dynamic> toMap() {
      print(line + pageNumber.toString() + bookId.toString());
    return {
      'line': line,
      'pageNumber': pageNumber,
      'bookId': bookId,
    };
  }
}

Future<int> insertLine(Line line) async {
  final Database db = await getDatabase();

  var id = await db.insert(
    'lines',
    line.toMap(),
    conflictAlgorithm: ConflictAlgorithm.replace,
  );
  return id;
}

Future<void> updateLine(Line line) async {
  final Database db = await getDatabase();

  await db.update("lines", line.toMap(), where: 'id = ?', whereArgs: [line.id]);
}

Future<void> deleteLine(Line line) async {
  final Database db = await getDatabase();

  await db.delete("lines", where: 'id = ?', whereArgs: [line.id]);
}

Future<List<Line>> getLines() async {
  final Database db = await getDatabase();
  final List<Map<String, dynamic>> maps = await db.query('lines');
  return maps.map((lineMap) => Line.withId(lineMap['id'], lineMap['linke'], lineMap['pageNumber'], lineMap['bookId']));
}

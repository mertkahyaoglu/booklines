import 'package:booklines/db.dart';
import 'package:booklines/models/line.dart';
import 'package:sqflite/sqlite_api.dart';

class Book {
  int id;
  String title;
  String description;

  List<Line> lines = [];

  Book(this.id, this.title, this.description);

  void addLine(Line line) {
    this.lines.add(line);
  }

  void deleteLine(String id) {
    this.lines.removeWhere((line) => line.id == id);
  }

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'title': title,
      'description': description,
    };
  }
}

Future<void> insertBook(Book book) async {
  final Database db = await getDatabase();
  await db.insert(
    'books',
    book.toMap(),
    conflictAlgorithm: ConflictAlgorithm.replace,
  );
}

Future<void> updateBook(Book book) async {
  final Database db = await getDatabase();

  await db.update("books", book.toMap(), where: 'id = ?', whereArgs: [book.id]);
}

Future<void> deleteBook(Book book) async {
  final Database db = await getDatabase();

  await db.delete("books", where: 'id = ?', whereArgs: [book.id]);
}

Future<void> deleteAll() async {
  final Database db = await getDatabase();
  await db.delete('books', whereArgs: ["1"]);
}

Future<List<Book>> getBooks() async {
  final Database db = await getDatabase();
  final List<Map<String, dynamic>> maps = await db.query('books');
  return List.generate(maps.length,
      (i) => Book(maps[i]['id'], maps[i]['title'], maps[i]['description']));
}

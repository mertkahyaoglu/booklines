import 'package:booklines/db.dart';
import 'package:booklines/models/line.dart';
import 'package:sqflite/sqlite_api.dart';

class Book {
  int id;
  String title;
  String description;

  List<Line> lines = [];

  Book(this.title, this.description);

  Book.withId(int id, String title, String description) :
    this.id = id,
    this.title = title,
    this.description = description;

  void addLine(Line line) {
    this.lines.add(line);
  }

  void deleteLine(int id) {
    this.lines.removeWhere((line) => line.id == id);
  }

  Map<String, dynamic> toMap() {
    return {
      'title': title,
      'description': description,
    };
  }
}

Future<int> insertBook(Book book) async {
  final Database db = await getDatabase();
  int id = await db.insert(
    'books',
    book.toMap(),
    conflictAlgorithm: ConflictAlgorithm.replace,
  );
  return id;
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
  final List<Map<String, dynamic>> bookMaps = await db.query('books');
  final List<Map<String, dynamic>> lineMaps = await db.query('lines');

  return bookMaps.map((bookMap) {
    Book book = Book.withId(bookMap['id'], bookMap['title'], bookMap['description']);

    book.lines = lineMaps.where((lineMap) => lineMap['bookId'] == bookMap['id']).map((lineMap) {
        return Line.withId(lineMap['id'], lineMap['line'], lineMap['pageNumber'], lineMap['bookId']);
    }).toList();

    return book;
  }).toList();
}

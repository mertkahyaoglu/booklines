import 'dart:async';

import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';

Future onConfigure(Database db) async {
  await db.execute('PRAGMA foreign_keys = ON');
}

void createBooksTable(Batch batch) {
  batch.execute('DROP TABLE IF EXISTS books');
  batch.execute('''CREATE TABLE books (
    id INTEGER PRIMARY KEY autoincrement,
    title TEXT,
    description TEXT
  )''');
}

void createLinesTable(Batch batch) {
  batch.execute('DROP TABLE IF EXISTS lines');
  batch.execute('''CREATE TABLE lines (
    id INTEGER PRIMARY KEY AUTOINCREMENT,
    line TEXT,
    pageNumber INTEGER,
    bookId INTEGER,
    FOREIGN KEY (bookId) REFERENCES books(id) ON DELETE CASCADE
  )''');
}

Database database;
Future<Database> getDatabase() async {
  if (database != null) {
    return database;
  }

  database = await openDatabase(
    // Set the path to the database.
    join(await getDatabasesPath(), 'books.db'),
    onConfigure: onConfigure,
    onCreate: (db, version) async {
      var batch = db.batch();
      createBooksTable(batch);
      createLinesTable(batch);
      await batch.commit();
    },
    onUpgrade: (db, oldVersion, newVersion) async {
      var batch = db.batch();
      createBooksTable(batch);
      createLinesTable(batch);
      await batch.commit();
    },
    version: 1,
  );

  return database;
}

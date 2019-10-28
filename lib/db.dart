import 'dart:async';

import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';

Database database;
Future<Database> getDatabase() async {
  if (database != null) {
    return database;
  }
  database = await openDatabase(
    // Set the path to the database.
    join(await getDatabasesPath(), 'books.db'),
    // When the database is first created, create a table to store dogs.
    onCreate: (db, version) {
      // Run the CREATE TABLE statement on the database.
      return db.execute(
        "CREATE TABLE books(id INTEGER PRIMARY KEY, title TEXT, description TEXT);" +
            "CREATE TABLE lines(id INTEGER PRIMARY KEY, line TEXT, pageNumber INTEGER);",
      );
    },
    // Set the version. This executes the onCreate function and provides a
    // path to perform database upgrades and downgrades.
    version: 1,
  );

  return database;
}

import 'package:booklines/models/book.dart';
import 'package:booklines/models/line.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  group("Book class", () {
    test("adds a line", () {
      final Book book = new Book("1984", "Awesome book");
      final Line line = new Line("What an sad day it was", 9);
      book.addLine(line);

      expect(book.lines.length, 1);
    });

    test("deletes a line", () {
      final Book book = new Book("1984", "Awesome book");
      final Line line = new Line("What an sad day it was", 9);
      final Line line2 = new Line("Second line", 100);

      book.addLine(line);
      book.addLine(line2);
      expect(book.lines.length, 2);

      book.deleteLine(book.lines.first.id);
      expect(book.lines.length, 1);
    });
  });
}

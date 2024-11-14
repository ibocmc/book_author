import '../model/books.dart';
import '../model/parts.dart';

abstract class DatabaseBase {
  Future<List<Books>> readAllBooks(int categoryId, dynamic lastBookId);
  Future<dynamic> createBook(Books book);
  Future<int> updateBook(Books book);
  Future<int> deleteBook(Books book);
  Future<int> deleteBooks(List<dynamic> bookIds);
  Future<dynamic> createPart(Parts part);
  Future<List<Parts>> readAllParts(dynamic bookId);
  Future<int> updatePart(Parts part);
  Future<int> deletePart(Parts part);
}
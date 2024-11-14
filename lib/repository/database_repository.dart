import 'package:yazar/base/database_base.dart';
import 'package:yazar/model/books.dart';
import 'package:yazar/model/parts.dart';
import 'package:yazar/service/api/api_database_service.dart';
import 'package:yazar/service/base/database_service.dart';
import 'package:yazar/service/sqflite/sqflite_database_service.dart';
import 'package:yazar/tools/locator.dart';

class DatabaseRepository implements DatabaseBase{

  final DatabaseService _SqfLiteService = locator<SqfliteDatabaseService>();

  //final DatabaseService _ApiService = locator<ApiDatabaseService>();

  @override
  Future<List<Books>> readAllBooks(int categoryId, lastBookId) async{

   return await _SqfLiteService.readAllBooks(categoryId, lastBookId);
  }

  @override
  Future createBook(Books book) async{
    return await _SqfLiteService.createBook(book);
  }

  @override
  Future<int> updateBook(Books book) async{
    return await _SqfLiteService.updateBook(book);
  }

  @override
  Future<int> deleteBook(Books book) async{
    return await _SqfLiteService.deleteBook(book);
  }

  @override
  Future<int> deleteBooks(List bookIds) async{
    return await _SqfLiteService.deleteBooks(bookIds);
  }

  @override
  Future<List<Parts>> readAllParts(bookId) async{
    return await _SqfLiteService.readAllParts(bookId);
  }

  @override
  Future createPart(Parts part) async{

    return await _SqfLiteService.createPart(part);

  }

  @override
  Future<int> updatePart(Parts part) async{
    return await _SqfLiteService.updatePart(part);
  }

  @override
  Future<int> deletePart(Parts part) async{
    return await _SqfLiteService.deletePart(part);
  }


}
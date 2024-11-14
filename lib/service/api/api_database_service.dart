import 'package:yazar/model/books.dart';
import 'package:yazar/model/parts.dart';
import 'package:yazar/service/base/database_service.dart';

class ApiDatabaseService implements DatabaseService{
  @override
  Future createBook(Books book) async{

    return 1;

  }

  @override
  Future createPart(Parts part) async{

    return 1;

  }

  @override
  Future<int> deleteBook(Books book) async{

    return 1;

  }

  @override
  Future<int> deleteBooks(List bookIds) async{

    return 1;

  }

  @override
  Future<int> deletePart(Parts part) async{

    return 1;

  }

  @override
  Future<int> updateBook(Books book) async{

    return 1;

  }

  @override
  Future<int> updatePart(Parts part) async{

    return 1;

  }

  @override
  Future<List<Books>> readAllBooks(int categoryId, lastBookId) async{

    List<Books> books = [];

    for(int i=1; 1<=10; i++){

      Books book = Books("Kitap$i", DateTime.now(), 0);

      book.id = i;

      books.add(book);

    }

    return books;

  }

  @override
  Future<List<Parts>> readAllParts(bookId) async{

    List<Parts> parts = [];

    for(int i=1; 1<=10; i++){

      Parts part = Parts(1, "Başlık $i");

      part.id = i;

      parts.add(part);

    }

    return parts;

  }

}
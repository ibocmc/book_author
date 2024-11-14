import 'package:sqflite/sqflite.dart';
import 'package:yazar/model/books.dart';
import 'package:yazar/model/parts.dart';
import 'package:path/path.dart';
import 'package:yazar/service/base/database_service.dart';

class SqfliteDatabaseService implements DatabaseService {

  Database? _database;

  String _booksTableName = "Books";
  String _bookId = "id";
  String _bookName = "name";
  String _bookCrtDate = "crtDate";
  String _bookCategoryName = "category";

  String _partsTableName = "Parts";
  String _partId = "id";
  String _partBookId = "bookId";
  String _partHead = "head";
  String _partContent = "content";
  String _partCrtDate = "certDate";


  Map<String, dynamic> _bookToMap(Books book) {

    Map<String,dynamic> bookMap = book.toMap();
    DateTime? crtDate = bookMap["crtDate"];

    if(crtDate != null){
      bookMap["crtDate"] = crtDate.millisecondsSinceEpoch;
    }
    return bookMap;
  }

  Books _mapToBook(Map<String, dynamic> m) {

    Map<String,dynamic> bookMap = Map.from(m);

    int? crtDate = bookMap["crtDate"];

    if(crtDate!=null){
      bookMap["crtDate"] = DateTime.fromMillisecondsSinceEpoch(crtDate);
    }
    return Books.fromMap(bookMap);
  }

  Future<Database?> _getDatabase() async {
    if(_database == null)
    {
      String filePath = await getDatabasesPath();
      String dbPath = join(filePath,"yazar.db");
      _database = await openDatabase(dbPath,
          version: 1,
          onCreate: _createTable,
          onUpgrade: _updateTable
      );
    }
    return _database;
  }

  Future<void> _createTable(Database db, int version) async {
    await db.execute(
        """
      CREATE TABLE $_booksTableName(  
      $_bookId INTEGER NOT NULL UNIQUE PRIMARY KEY AUTOINCREMENT,
      $_bookName TEXT NOT NULL,
      $_bookCrtDate INTEGER,
      $_bookCategoryName INTEGER DEFAULT 0
      );
      """
    );

    await db.execute(
        """
      CREATE TABLE $_partsTableName(  
      $_partId INTEGER NOT NULL UNIQUE PRIMARY KEY AUTOINCREMENT,
      $_partBookId INTEGER NOT NULL,
      $_partHead TEXT NOT NULL, 
      $_partContent TEXT, 
      $_partCrtDate TEXT DEFAULT CURRENT_TIMESTAMP,
      FOREIGN KEY("$_partBookId") REFERENCES "$_booksTableName"("$_bookId") ON UPDATE CASCADE ON DELETE CASCADE
      );
      """
    );
  }

  Future<void> _updateTable(Database db,
      int oldVersion,
      int newVersion) async {

    List<String> updateCommands = [

      "ALTER TABLE $_booksTableName ADD COLUMN $_bookCategoryName INTEGER DEFAULT 0",

    ];

    for(int i = oldVersion-1; i < newVersion-1;i++ ){
      await db.execute(updateCommands[i]);
    }
  }



  @override
  Future<List<Books>> readAllBooks(int categoryId, lastBookId) async{

    Database? db = await _getDatabase();
    List<Books> allBooks = [];
    if(db!=null)
    {
      String? filter = "$_bookId > ?";
      List<dynamic> filterArgs = [lastBookId];

      if(categoryId >=0){
        filter += "and  $_bookCategoryName = ?";
        filterArgs.add(categoryId);
      }
      List<Map<String,dynamic>> addBooksMap = await db.query(_booksTableName,

        where: filter,
        whereArgs: filterArgs,
        //orderBy: "$_bookCategoryName , $_bookName",
        orderBy: "$_bookName collate localized",
        limit: 15,
        //offset: 5,
        /*where: "$_bookCategoryName = ?",
        whereArgs: [categoryId],*/
      );

      for(Map<String ,dynamic> m in addBooksMap ){
        Books b = _mapToBook(m);
        allBooks.add(b);
      }
    }
    return allBooks;

  }

  @override
  Future createBook(Books book) async{

    Database? db = await _getDatabase();

    if(db!=null){

      return db.insert(_booksTableName, _bookToMap(book));
    }
    else
    {
      return -1;
    }

  }

  @override
  Future<int> updateBook(Books book) async{

    Database? db = await _getDatabase();
    if(db!=null){
      return db.update(
        _booksTableName,
        _bookToMap(book),
        where: "$_bookId = ?",
        whereArgs: [book.id],
      );
    } else {
      return 0;
    }

  }

  @override
  Future<int> deleteBook(Books book) async{

    Database? db = await _getDatabase();
    if(db!=null){
      return db.delete(
        _booksTableName,
        where: "$_bookId = ?",
        whereArgs: [book.id],
      );
    } else {
      return 0;
    }

  }

  @override
  Future<int> deleteBooks(List bookIds) async{

    Database? db = await _getDatabase();
    if(db!=null && bookIds.isNotEmpty){

      String filter = "$_bookId in (";

      for(int i = 0; i<bookIds.length; i++){
        if(i != bookIds.length - 1){

          filter += "?,";

        }else{
          filter += "?)";
        }

      }
      return db.delete(
        _booksTableName,
        where: filter, // (?,?,?,?)
        whereArgs: bookIds,
      );
    } else {
      return 0;
    }

  }

  @override
  Future<List<Parts>> readAllParts(bookId) async{
    Database? db = await _getDatabase();
    List<Parts> allParts = [];
    if(db!=null)
    {
      List<Map<String,dynamic>> addPartsMap = await db.query(_partsTableName,

        where: "$_partBookId = ?",
        whereArgs: [bookId],

      );
      for(Map<String ,dynamic> m in addPartsMap ){
        Parts p = Parts.fromMap(m);
        allParts.add(p);
      }
    }
    return allParts;
  }

  @override
  Future createPart(Parts part) async{

    Database? db = await _getDatabase();
    if(db!=null){
      return db.insert(_partsTableName, part.toMap());
    } else {
      return -1;
    }

  }

  @override
  Future<int> updatePart(Parts part) async{

    Database? db = await _getDatabase();
    if(db!=null){
      return db.update(
        _partsTableName,
        part.toMap(),
        where: "$_partId = ?",
        whereArgs: [part.id],
      );
    } else {
      return 0;
    }

  }

  @override
  Future<int> deletePart(Parts part) async{

    Database? db = await _getDatabase();
    if(db!=null){
      return db.delete(
        _partsTableName,
        where: "$_partId = ?",
        whereArgs: [part.id],
      );
    } else {
      return 0;
    }

  }
}
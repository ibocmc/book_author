import 'dart:async';
import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';
import 'package:yazar/model/books.dart';
import 'package:yazar/model/parts.dart';

class LocalDatabase {
  LocalDatabase._privateConstructor();
  static final LocalDatabase _object = LocalDatabase._privateConstructor();
  factory LocalDatabase(){
    return _object;
  }

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

  // BOOKS


  Future<List<Books>> readAllBooks(int categoryId, int lastBookId) async {
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

  Future<int> createBook(Books book) async {

    Database? db = await _getDatabase();

    if(db!=null){

      return db.insert(_booksTableName, _bookToMap(book));
    }
    else
    {
      return -1;
    }
  }

  Map<String, dynamic> _bookToMap(Books book) {

    Map<String,dynamic> bookMap = book.toMap();
    DateTime? crtDate = bookMap["crtDate"];

    if(crtDate != null){

      bookMap["crtDate"] = crtDate.millisecondsSinceEpoch;

    }

    return bookMap;

  }

  Books _mapToBook(Map<String, dynamic> m) {
    int? crtDate = m["crtDate"];
    if(crtDate!=null){
      m["crtDate"] = DateTime.fromMillisecondsSinceEpoch(crtDate);
    }
    return Books.fromMap(m);
  }



  Future<int> updateBook(Books book) async {
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


  Future<int> deleteBook(Books book) async {
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

  Future<int> deleteBooks(List<int> bookIds) async {
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

//PARTS

  Future<int> createPart(Parts part) async {
    Database? db = await _getDatabase();
    if(db!=null){
      return db.insert(_partsTableName, part.toMap());
    } else {
      return -1;
    }
  }

  Future<List<Parts>> readAllParts(int bookId) async {
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

  Future<int> updatePart(Parts part) async {
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


  Future<int> deletePart(Parts part) async {
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
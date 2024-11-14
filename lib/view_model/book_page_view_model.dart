import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:yazar/repository/database_repository.dart';
import 'package:yazar/tools/locator.dart';
import 'package:yazar/view_model/part_page_view_model.dart';
import '../tools/constants.dart';
import '../model/books.dart';
import '../view/part_page.dart';

class BookPageViewModel with ChangeNotifier{

  DatabaseRepository _databaseRepository = locator<DatabaseRepository>();


  List<Books> _AllBooks = [];
  List<Books> get AllBooks => _AllBooks;


  List<int>  _allCategories = [-1];
  List<int> get allCategories => _allCategories;


  int _choosenCategory = -1;
  int get choosenCategory => _choosenCategory;

  set choosenCategory(int value) {
    _choosenCategory = value;
    notifyListeners();
  }

  List<int> _choosenBooksId = [];
  List<int> get choosenBooksId => _choosenBooksId;


  set choosenBooksId(List<int> value) {
    _choosenBooksId = value;
    notifyListeners();
  }

  bool _is_Chosen = false;
  bool get is_Chosen => _is_Chosen;

  set is_Chosen(bool value) {
    _is_Chosen = value;
    notifyListeners();
  }

  ScrollController _scrollController = ScrollController();
  ScrollController get scrollController => _scrollController;


  BookPageViewModel(){
    _allCategories.addAll(Constants.categories.keys);
    _scrollController.addListener(_scrollControl);

    WidgetsBinding.instance.addPostFrameCallback((_){
      _getFirstViewBooks();
      notifyListeners();
    });


}



  void createBook(BuildContext context) async{

    /*for(int i = 1; i <= 10; i++){
      Books newBook = Books(i.toString(), DateTime.now(),0);
      _databaseRepository.createBook(newBook);
      notifyListeners();
    }*/


    // adding as list, book name and category
    List<dynamic>? result = await _openWindow(context);

    if(result != null && result.length > 1){

      String bookName = result[0];
      int category = result[1];

      Books newBook = Books(bookName, DateTime.now(),category);
      int bookId = await _databaseRepository.createBook(newBook);

      newBook.id = bookId;

      _AllBooks.add(newBook);

      notifyListeners();

    }

    // only adding book
    /*String? bookNameFromTb = await _openWindow(context);
    if(bookNameFromTb!=null){
      Books newBook = Books(bookNameFromTb, DateTime.now());
      _localDatabase.createBook(newBook);
      setState(() {});
    }*/
  }

  void updateBook(BuildContext context , int index) async {
    // update book name and category
    Books book = _AllBooks[index];
    List<dynamic>? result = await _openWindow(context,
        currentName: book.name,
        currentCategory: book.category);

    if(result != null && result.length > 1){

      String newName = result[0];
      int newCategory = result[1];

      if(book.name != newName || book.category != newCategory){

        int updatedRowCount = await _databaseRepository.updateBook(book);

        if(updatedRowCount > 0){

          book.updateBook(newName, newCategory);

        }
      }
    }

    //only update book name
    /*String? bookNameFromTb = await _openWindow(context);
    if(bookNameFromTb!=null){
      Books newBook = _AllBooks[index];
      newBook.name = bookNameFromTb;
      int updatedRowCount = await _localDatabase.updateBook(newBook);
      if(updatedRowCount > 0){
        setState(() {});
      }
    }*/
  }

  void _deleteBook(int index) async{
    Books newBook = _AllBooks[index];
    int deletedRowCount = await _databaseRepository.deleteBook(newBook);
    if(deletedRowCount > 0){
      _AllBooks.removeAt(index);
    
    }
  }

  void _deleteBooks() async{
    int deletedRowCount = await _databaseRepository.deleteBooks(_choosenBooksId);
    if(deletedRowCount > 0){
      _AllBooks.removeWhere((Books) => _choosenBooksId.contains(Books.id));
      is_Chosen = false;
      notifyListeners();

    }
  }



  /*Future<void> _getAllBook() async{

    _AllBooks = await _localDatabase.readAllBooks(_choosenCategory);

  }*/

  Future<void> _getFirstViewBooks() async{

    if(_AllBooks.isEmpty){
      _AllBooks = await _databaseRepository.readAllBooks(_choosenCategory,0);

      notifyListeners();

       for(Books b in _AllBooks){

        if (kDebugMode) {
          print("İlk kitaplar: ${b.name}");
        }

      }

    }
  }

  Future<void> _getLastViewBooks() async{

    int? lastBookId = _AllBooks.last.id;
    if(lastBookId!=null){
      List<Books> lastBooks = await _databaseRepository.readAllBooks(_choosenCategory, lastBookId);
      _AllBooks.addAll(lastBooks);

      for(Books b in _AllBooks){

        if (kDebugMode) {
          print("Son kitaplar: ${b.name}");
        }
      }

      notifyListeners();
    }
  }

  Future<List<dynamic>?> _openWindow(
      BuildContext context, {
        String currentName = "",
        int currentCategory = 0,
      }){

    TextEditingController nameController = TextEditingController(text: currentName);

    return showDialog<List<dynamic>>(
        context: context,
        builder: (context){
          //String? result;
          int category = currentCategory;

          return AlertDialog(

            title: const Text("Kitap Adını Giriniz"),
            content: StatefulBuilder(builder: (BuildContext context,
                void Function(void Function()) setState) {
              return

                Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    TextField(
                      controller: nameController,
                      /*onChanged: (newValue){
                      result = newValue;
                    },*/
                    ),

                    const SizedBox(height: 24),

                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        const Text("Kategori:"),
                        DropdownButton<int>(
                            value: category,
                            items: Constants.categories.keys.map((categoryId){

                              return DropdownMenuItem<int>(
                                value: categoryId,
                                child:Text(Constants.categories[categoryId] ?? "") ,

                              );

                            }).toList(),


                            onChanged: (int? newValue){

                              if(newValue!=null){
                                setState((){
                                  category = newValue;
                                });
                              }
                            }),
                      ],
                    )
                  ],
                );

            },

            ),
            actions: [
              TextButton(
                onPressed: (){
                  Navigator.pop(context);
                },
                child: const Text("İptal"),
              ),
              TextButton(
                onPressed: (){
                  Navigator.pop(context,[nameController.text.trim(),category]);
                },
                child: const Text("Onayla"),
              )
            ],
          );
        }
    );
  }

  Future<void> openDeleteWindow(BuildContext context){
    return showDialog<String>(
        context: context,
        builder: (context){
          return AlertDialog(
            title: const Text("Emin Misiniz?"),
            icon: const Icon(Icons.warning_amber_rounded),
            actions: [
              TextButton(
                child: const Text("Evet"),
                onPressed: (){
                  _deleteBooks();
                  //_deleteBook(index);
                  Navigator.pop(context);

                  ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(
                        backgroundColor: Colors.deepPurpleAccent,
                        content: Text("sildiniz"),
                        //content: Text("${_AllBooks[index].name} adlı kitabı balşarı ile sildiniz"),
                        duration: Duration(seconds: 2),
                      )
                  );
                },
              ),
              TextButton(
                child: const Text("İptal"),
                onPressed: (){
                  Navigator.pop(context);
                },
              )
            ],
          );
        }
    );
  }

  void openPartsPage(BuildContext context , int index){

    MaterialPageRoute pageRoute = MaterialPageRoute(builder: (context){

      return ChangeNotifierProvider(
          create: (context) => PartPageViewModel(AllBooks[index]),
      child: PartPage(),
      );

    });

    Navigator.push(context, pageRoute);

  }

  void _scrollControl() {
    if(_scrollController.offset == _scrollController.position.maxScrollExtent){

      _getLastViewBooks();

    }
  }

}
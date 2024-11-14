import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:yazar/view_model/part_detail_page_view_model.dart';
import '../model/books.dart';
import '../model/parts.dart';
import '../repository/database_repository.dart';
import '../tools/locator.dart';
import '../view/part_detail_page.dart';

class PartPageViewModel with ChangeNotifier{

  DatabaseRepository _databaseRepository = locator<DatabaseRepository>();

  List<Parts> _allParts = [];
  List<Parts> get allParts => _allParts;

  PartPageViewModel(this._book){
    WidgetsBinding.instance.addPostFrameCallback((_){
      _getAllParts();
      notifyListeners();
    });
  }


  final Books _book;
  Books get book => _book;



  void createPart(BuildContext context) async{
    String? partNameFromTb = await _openWindow(context);
    int? bookId = _book.id;

    if(partNameFromTb!=null && bookId!=null){
      Parts newPart = Parts(bookId, partNameFromTb);
      int partId = await _databaseRepository.createPart(newPart);

      newPart.id = partId;

      _allParts.add(newPart);
      notifyListeners();
    }
  }

  void updatePart(BuildContext context , int index) async {
    String? partNameFromTb = await _openWindow(context);
    if(partNameFromTb!=null){
      Parts newPart = _allParts[index];
      int updatedRowCount = await _databaseRepository.updatePart(newPart);
      if(updatedRowCount > 0){
        newPart.update(partNameFromTb);
      }

    }
  }

  void _deletePart(int index) async{
    Parts newPart = _allParts[index];
    int deletedRowCount = await _databaseRepository.deletePart(newPart);
    if(deletedRowCount > 0){
     _allParts.removeAt(index);
     notifyListeners();
    }
  }


  Future<void> _getAllParts() async{

    int? bookId = _book.id;

    if(bookId != null){
      _allParts = await _databaseRepository.readAllParts(bookId);

    }



  }

  Future<String?> _openWindow(BuildContext context){
    return showDialog<String>(
        context: context,
        builder: (context){
          String? result;
          return AlertDialog(
            title: const Text("Bölüm Adını Giriniz"),
            content: TextField(
              onChanged: (newValue){
                result = newValue;
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
                  Navigator.pop(context,result);
                },
                child: const Text("Onayla"),
              )
            ],
          );
        }
    );
  }

  Future<void> openDeleteWindow(BuildContext context, int index){
    return showDialog<String>(
        context: context,
        builder: (context){
          return AlertDialog(
            title: const Text("Seçilen Bölümü Silmek İstediğize Emin Misiniz?"),
            icon: const Icon(Icons.warning_amber_rounded),
            actions: [
              TextButton(
                  onPressed: (){
                    _deletePart(index);
                    Navigator.pop(context);

                    ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(
                          backgroundColor: Colors.deepPurpleAccent,

                          content: Text("${_allParts[index].head} adlı bölümü balşarı ile sildiniz"),
                          duration: const Duration(seconds: 2),

                        )
                    );
                  },
                  child: const Text("Evet")),
              TextButton(
                  onPressed: (){
                    Navigator.pop(context);
                  },
                  child: const Text("İptal"))
            ],
          );
        }
    );
  }

  void openPartDetailPage(BuildContext context , int index){

    MaterialPageRoute pageRoute = MaterialPageRoute(builder: (context){

      return ChangeNotifierProvider(
          create: (context) => PartDetailPageViewModel(_allParts[index]),
          child: PartDetailPage(),
      );

    });

    Navigator.push(context, pageRoute);

  }

}
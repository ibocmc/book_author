import 'package:flutter/cupertino.dart';

class Books with ChangeNotifier{

  dynamic id;
  String name;
  DateTime crtDate;
  int category;

  bool isChosen = false;

  Books(this.name,this.crtDate,this.category);

  Books.fromMap(Map<String,dynamic> map):
      id = map["id"],
      name = map["name"],
      crtDate = map["crtDate"],
        category = map["category"] ?? 0;


  Map<String,dynamic> toMap(){

    return {
      "id":id,
      "name":name,
      "crtDate":crtDate,
      "category":category,
    };

  }

  void updateBook(String newName, int newCategory){

    name = newName;
    category = newCategory;

    notifyListeners();

  }

  void choose(bool newValue){

    isChosen = newValue;
    notifyListeners();

  }

}
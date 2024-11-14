import 'package:flutter/cupertino.dart';

class Parts with ChangeNotifier{

  dynamic id;
  int bookId;
  String head;
  String content;

  Parts(this.bookId,this.head):content = "";

  Parts.fromMap(Map<String,dynamic> map):
      id = map["id"],
      bookId = map["bookId"],
      head = map["head"],
      content = map["content"];


  Map<String,dynamic> toMap(){
    return {
      "id" : id,
      "bookId" : bookId,
      "head" : head,
      "content" : content,
    };
  }

  void update(String newHead){

    head = newHead;

  }
}
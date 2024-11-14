import 'package:flutter/material.dart';
import '../model/parts.dart';
import '../repository/database_repository.dart';
import '../tools/locator.dart';


class PartDetailPageViewModel with ChangeNotifier{


  final Parts _part;
  Parts get part => _part;


  DatabaseRepository _databaseRepository = locator<DatabaseRepository>();

  PartDetailPageViewModel(this._part);


  void saveContent(String content_) async{

    _part.content = content_;
    await _databaseRepository.updatePart(_part);

    ScaffoldMessenger.of(content_ as BuildContext).showSnackBar(
        SnackBar(
          backgroundColor: Colors.deepPurpleAccent,

          content: Text("${_part.head} adlı içerik kaydedildi!"),
          duration: const Duration(seconds: 2),

        )
    );
  }

}

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class NoteProvider extends ChangeNotifier{

  List<String> _titleList = [];
  List<String> _contentList = [];

  List <String> get titleList => _titleList;
  List<String> get contentList => _contentList;

  void addTitle(String titleStr){
    _titleList.add(titleStr);
    notifyListeners();
  }

  void addContent(String contentStr){
    _contentList.add(contentStr);
    notifyListeners();
  }
}
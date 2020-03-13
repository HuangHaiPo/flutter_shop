import 'package:flutter/material.dart';

class CurrentIndexProvide with ChangeNotifier{
  //当前选中页面
  int currentIndex = 0;
  changeIndex(int  newIndex){
    currentIndex = newIndex;
    notifyListeners();
  }
}
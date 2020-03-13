import 'package:flutter/material.dart';


class Counter with ChangeNotifier{//混入
  int value = 0;
  increment(){
    value++;
    //状态有改变通知听众 局部刷新
    notifyListeners();
  }
}
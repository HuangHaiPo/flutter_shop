import 'package:flutter/material.dart';
import '../models/categoryRightModel.dart';

class CategoryGoodsListProvide with ChangeNotifier{//混入

    List<CategoryListData> goodsList = [];
//点击大类时更换商品列表
    getGoodList(List<CategoryListData> list){
      goodsList = list;
      notifyListeners();//发生变化监听
    }
//上拉加载刷新调这个方法
    getMoreList(List<CategoryListData> list){
      goodsList.addAll(list);
      notifyListeners();//发生变化监听
    }

}
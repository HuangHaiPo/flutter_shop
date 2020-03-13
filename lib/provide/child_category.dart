import 'package:flutter/material.dart';
import '../models/category.dart';

class ChildCategory with ChangeNotifier{//混入

    List<BxMallSubDto> childCategoryList = [];
    int childIndex = 0;//子类高亮显示索引
    String categoryId = '4';//大类id 默认4
    String subId = '0';//小类id
    int page = 1;//列表页数
    String noMareText = '';//显示没有数据的文
  //  大类切换逻辑
    getChildCategory(List<BxMallSubDto> list , String id){
      childIndex = 0;//每次点击大类清零
      categoryId = id;
      page = 1;
      noMareText = '';
      BxMallSubDto all = BxMallSubDto();
      all.mallSubId = '';
      all.mallCategoryId = '';
      all.comments = '';
      all.mallSubName = '全部';
      childCategoryList = [all];
      childCategoryList.addAll(list);
      notifyListeners();
    }
//  改变子类索引
    changeChildIndex(index,String id){
      childIndex = index;
      subId = id;
      page = 1;
      noMareText = '';
      notifyListeners();
    }
  //  增加page的方法
    addPage(){
      //这个只是值发生了改变不需要通知
      page++;
    }
    changeNoMare(String str){
      noMareText = str;
  //    页面需要变化的时候记得通知
      notifyListeners();
    }



}
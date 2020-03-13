import 'package:flutter/material.dart';
import 'package:flutter_shop/models/details_model.dart';
import 'package:flutter_shop/service/service_method.dart';
import 'dart:convert';

class DetailsInfoProvide with ChangeNotifier{
  DetailsModel goodsInfo = null;
  bool isLeft = true;
  bool isRight = false;
//  商品详情也 tabBar的切换方法
  changeLeftAndRigt(String changeState){
    if(changeState == 'left'){
        isLeft = true;
        isRight = false;
    }else{
        isLeft = false;
        isRight = true;
    }
    notifyListeners();
  }
//  从后台获取商品数据
    getGoodsInfo(String id) async{
      print(id);
      var arguments = {'goodId': id};
      await request('getGoodDetailById' , formData: arguments).then((onValue){
          var responseData = json.decode(onValue.toString());
          goodsInfo = DetailsModel.fromJson(responseData);
          notifyListeners();
      });
    }
  
  
  
}

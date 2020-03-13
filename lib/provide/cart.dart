import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'dart:convert';
import 'package:flutter_shop/models/cartInfo_model.dart';


//添加购物车
class CartProvide with ChangeNotifier {

  String cartString = '[]';

  List<CartInfoModel> cartInfoList = [];

  double allPrice= 0.0;//商品总价
  int allGoodsCount = 0;//商品名总数量
  bool isAllCheck = true;//购物车商品是否全部选中 默认选中
  //将商品保存到本地
  save(goodsId, goodsName, count, price, images) async {

    SharedPreferences preferences = await SharedPreferences.getInstance();
    cartString = preferences.getString('cartInfo');
    var temp = cartString == null ? [] : json.decode(cartString.toString());
    ///添加的商品 如果添加的商品存在 数量加一 没商品就添加进去
    List<Map> tempList = (temp as List).cast();
    bool isHave = false;
    int ival = 0;
    allPrice = 0;
    allGoodsCount = 0;

    tempList.forEach((item) {
      if (item['goodsId'] == goodsId) {
        tempList[ival]['count'] = item['count'] + 1;
        cartInfoList[ival].count++;
        isHave = true;
      }
      if(item['isCheck']){
        allPrice += (cartInfoList[ival].price*cartInfoList[ival].count);
        allGoodsCount += cartInfoList[ival].count;
      }
      ival++;
    });
    if (!isHave) {

      Map<String , dynamic> newGoods = {
        'goodsId': goodsId,
        'goodsName': goodsName,
        'count': count,
        'images': images,
        'price': price,
        'isCheck':true,
      };

      tempList.add(newGoods);
      cartInfoList.add(CartInfoModel.fromJson(newGoods));
      allPrice += (count*price);
      allGoodsCount += count;
    }
    ///将商品写入本地 将数组编码成string保存到本地
    cartString = json.encode(tempList).toString();
    preferences.setString('cartInfo', cartString);
    notifyListeners();
  }

  ///清空购物车
  remove() async{
    SharedPreferences pre = await SharedPreferences.getInstance();
    pre.remove('cartInfo');
    cartInfoList = [];
    print('清空完成.............');
    notifyListeners();
  }
  ///获取购物车的数据
  getCartInfo()async{
    SharedPreferences pre = await SharedPreferences.getInstance();
    cartString = pre.getString('cartInfo');
    cartInfoList = [];
    if(cartString == null){
      cartInfoList = [];
    }else{
      List<Map> tempList = (json.decode(cartString.toString()) as List).cast();
      allPrice = 0.0;
      allGoodsCount = 0;
      isAllCheck = true;
      tempList.forEach((item){
        if(item['isCheck']){
          allPrice += (item['count']*item['price']);
          allGoodsCount += item['count'];
        }else{
          isAllCheck = false;
        }
        cartInfoList.add(CartInfoModel.fromJson(item));
      });
    }
    notifyListeners();
  }
  //删除单个购物车商品
  deleteOneGoods(String goodsId)async{
    SharedPreferences preferences = await SharedPreferences.getInstance();
    cartString = preferences.getString('cartInfo');
    List<Map> tempList = (json.decode(cartString.toString()) as List).cast();
    int tempIndex = 0;
    int deleIndex = 0;
    tempList.forEach((item){
      if(item['goodsId'] == goodsId){
        deleIndex = tempIndex;
      }
      tempIndex++;
    });
    tempList.removeAt(deleIndex);
    cartString = json.encode(tempList).toString();
    preferences.setString('cartInfo', cartString);
    await getCartInfo();
  }
  //购物车商品是否选择
  changeCheckState(CartInfoModel cartInfoModel) async{
    SharedPreferences preferences = await SharedPreferences.getInstance();
    cartString = preferences.getString('cartInfo');
    List<Map> tempList = (json.decode(cartString.toString()) as List).cast();
    int tempIndex = 0;
    int changeIndex = 0;
    tempList.forEach((item){
      if(item['goodsId'] == cartInfoModel.goodsId){
        changeIndex = tempIndex;
      }
      tempIndex++;
    });
    tempList[changeIndex] = cartInfoModel.toJson();
    cartString = json.encode(tempList).toString();
    preferences.setString('cartInfo', cartString);
    await getCartInfo();
  }
  //购物车 全选按钮事件
  changeAllCheckBtnState(bool isCheck) async{
    SharedPreferences preferences = await SharedPreferences.getInstance();
    cartString = preferences.getString('cartInfo');
    List<Map> tempList = (json.decode(cartString.toString()) as List).cast();
    List<Map> newList = [];

    for(var item in tempList){
      var newItem = item;
      newItem['isCheck'] = isCheck;
      newList.add(newItem);
    }
    cartString = json.encode(newList).toString();
    preferences.setString('cartInfo', cartString);

   await getCartInfo();
  }

  //购物车 商品数量加减事件
  addOrReduceEvent(var cartIem , String todo) async{
    SharedPreferences preferences = await SharedPreferences.getInstance();
    cartString = preferences.getString('cartInfo');
    List<Map> tempList = (json.decode(cartString.toString()) as List).cast();
    int tempIndex = 0;
    int changeIndex = 0;
    tempList.forEach((item){
      if(item['goodsId'] == cartIem.goodsId){
        changeIndex = tempIndex;
      }
      tempIndex ++;
    });
    if(todo == 'add'){
      cartIem.count ++;
    }else if(cartIem.count > 1){
      cartIem.count --;
    }
    tempList[changeIndex] = cartIem.toJson();
    cartString = json.encode(tempList).toString();
    preferences.setString('cartInfo', cartString);
    await getCartInfo();
  }


}
import 'package:dio/dio.dart';//请求组件 国人开发的
import 'dart:async';//异步请求
import 'dart:io';//对象包
import 'package:flutter_shop/config/service_url.dart';
// 把所有和后台有通信的都写到这里面 专门的请求类

// 获取首页主体内容
Future request(url , {formData}) async{
  try{
    print('开始获取数据............');
    Response response;
    Dio dio = new Dio();
    // 设置请求头contentType
    dio.options.contentType = ContentType.parse('application/x-www-form-urlencoded');
    if(formData == null){
      response = await dio.post(servicePath[url]);
    }else{
      response = await dio.post(servicePath[url],data: formData);
    }
    if(response.statusCode == 200){
      return response.data;
    }else{
      throw Exception('后端接口出现异常。');
    }
  }catch(e){
    return print('错误===========${e}');
  }
}


// 获取首页主体内容
Future getHomePageContent()async{
  print('开始获取首页数据............');
  try{
    Response response;
    Dio dio = Dio();
    // 设置请求头contentType
    dio.options.contentType = ContentType.parse('application/x-www-form-urlencoded');
    var formData = {'lon':'120.07965850830078','lat':'30.283863067626953'};
    response = await dio.post(servicePath['homePageContent'],data: formData);
    if(response.statusCode == 200){
      // print(response.data);
      return response.data;
    }else{
      throw Exception('后端接口出现异常。');
    }
  }catch(e){
    return print('错误===========${e}');
  }
}

//获得火爆专区的商品方法
Future getHomePageBelowConten()async{
  try{
    print('开始获取火爆专区数据............');
    Response response;
    Dio dio = Dio();
    // 设置请求头contentType
    dio.options.contentType = ContentType.parse('application/x-www-form-urlencoded');
    int page = 1;
    response = await dio.post(servicePath['homePageBelowConten'],data: page);
    if(response.statusCode == 200){
      print(response.data);
      return response.data;
    }else{
      throw Exception('后端接口出现异常。');
    }
  }catch(e){
    return print('错误===========${e}');
  }
  

}
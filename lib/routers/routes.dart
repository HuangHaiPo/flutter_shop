import 'package:flutter/material.dart';
import 'package:fluro/fluro.dart';
import 'package:flutter_shop/routers/router_handler.dart';

class Routes{
  //路由路径
  static String root = '/';//根目录
  static String detailsPage = '/detail';
  //静态方法
  static void configureRoutes(Router router){
    router.notFoundHandler = new Handler(//当前路由不存在 找不到路由
      handlerFunc: (BuildContext context,Map<String,List<String>> params){
        print('ERROR===>没有找到这个组件！！！！');
      }
    );
//配置路由
    router.define(detailsPage, handler: detailsHandler);

  }

}
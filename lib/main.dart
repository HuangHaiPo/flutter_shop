//flutter UI样式
import 'package:flutter/material.dart';
import './pages/index_page.dart';
import 'package:provide/provide.dart';
import './provide/connter.dart';
import './provide/child_category.dart';
import './provide/category_goods_list.dart';
import 'package:fluro/fluro.dart';
import 'package:flutter_shop/routers/application.dart';
import 'package:flutter_shop/provide/details_info.dart';
import 'package:flutter_shop/routers/routes.dart';
import 'package:flutter_shop/provide/cart.dart';
import 'package:flutter_shop/provide/currentIndex.dart';

void main(){
//  顶层依赖 将状态放入顶层 全局注入
  var counter = Counter();
  var childCategory = ChildCategory();
  var categoryGoodsListProvide = CategoryGoodsListProvide();
  var detailsInfoProvide = DetailsInfoProvide();
  var providers = Providers();
  var cartProvide = CartProvide();
  var currentIndexProvide = CurrentIndexProvide();

  ///Java中叫链式调用 dart 叫级联符号 允许在同一个对象上进行一系列操作。 除了函数调用之外，还可以访问同一对象上的字段
  providers
    ..provide(Provider<Counter>.value(counter))
    ..provide(Provider<ChildCategory>.value(childCategory))
    ..provide(Provider<CategoryGoodsListProvide>.value(categoryGoodsListProvide))
    ..provide(Provider<DetailsInfoProvide>.value(detailsInfoProvide))
    ..provide(Provider<CartProvide>.value(cartProvide))
    ..provide(Provider<CurrentIndexProvide>.value(currentIndexProvide));
  runApp(ProviderNode(child: MyApp(), providers: providers) );
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    // 初始化 fluro  Router是fluro中的
    final router = Router();
//    注入
    Routes.configureRoutes(router);
    Application.router = router;
    return Container(
      child: MaterialApp(
        title: '百姓生活+',
        debugShowCheckedModeBanner: false,
        theme: ThemeData(
          primaryColor: Colors.pink
        ),
        onGenerateRoute: Application.router.generator,
        home: IndexPage(),
      ),
    );
  }
}

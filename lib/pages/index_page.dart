import 'package:flutter/material.dart';//谷歌推出的
import 'package:flutter/cupertino.dart';//iOS风格
import 'home_page.dart';
import 'cart_page.dart';
import 'category_page.dart';
import 'member_page.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_shop/provide/currentIndex.dart';
import 'package:provide/provide.dart';


class IndexPage extends StatelessWidget {

    final List<BottomNavigationBarItem> bottomTabs = [
    BottomNavigationBarItem(
      icon: Icon(CupertinoIcons.home),
      title: Text('首页')
    ),
    BottomNavigationBarItem(
        icon: Icon(CupertinoIcons.search),
        title: Text('分类')
    ),
    BottomNavigationBarItem(
        icon: Icon(CupertinoIcons.shopping_cart),
        title: Text('购物车')
    ),
    BottomNavigationBarItem(
        icon: Icon(CupertinoIcons.profile_circled),
        title: Text('会员中心')
    )
  ];
  final List<Widget> tabBodies = [
    HomePage(),
    CategoryPage(),
    CartPage(),
    MemberPage()
  ];

  @override
  Widget build(BuildContext context) {
    ScreenUtil.instance = ScreenUtil(width: 750, height: 1334)
      ..init(context);
    return Provide<CurrentIndexProvide>(
      builder: (context, child, val) {
        int currentIndex = Provide
            .value<CurrentIndexProvide>(context)
            .currentIndex;
        return Scaffold(
          backgroundColor: Color.fromRGBO(244, 245, 245, 1.0),
          bottomNavigationBar: BottomNavigationBar(
            type: BottomNavigationBarType.fixed,
            currentIndex: currentIndex,
            items: bottomTabs,
            onTap: (index) {
              Provide.value<CurrentIndexProvide>(context).changeIndex(index);
            },
          ),
          body: IndexedStack( //_currentPage
            index: currentIndex,
            children: tabBodies, //接收页面上显示的主页面 比如有四个tab 点击四个tab显示的那四个组件 必须要是个Widget类型的List
          ),
        );
      },
    );
  }
}



//class IndexPage extends StatefulWidget {
//  @override
//  IndexPageState createState() => new IndexPageState();
//}
//
//class IndexPageState extends State<IndexPage> {
//  final List<BottomNavigationBarItem> bottomTabs = [
//    BottomNavigationBarItem(
//      icon: Icon(CupertinoIcons.home),
//      title: Text('首页')
//    ),
//    BottomNavigationBarItem(
//        icon: Icon(CupertinoIcons.search),
//        title: Text('分类')
//    ),
//    BottomNavigationBarItem(
//        icon: Icon(CupertinoIcons.shopping_cart),
//        title: Text('购物车')
//    ),
//    BottomNavigationBarItem(
//        icon: Icon(CupertinoIcons.profile_circled),
//        title: Text('会员中心')
//    )
//  ];
//  final List<Widget> tabBodies = [
//    HomePage(),
//    CategoryPage(),
//    CartPage(),
//    MemberPage()
//  ];
//  int _currentIndex = 0;
//  var _currentPage;
//
//  @override
//  void initState() {
//    _currentPage = tabBodies[_currentIndex];
//    // TODO: implement initState
//    super.initState();
//  }
//
//  @override
//  Widget build(BuildContext context) {
//    ScreenUtil.instance = ScreenUtil(width: 750,height: 1334)..init(context);
//    return Scaffold(
//      backgroundColor: Color.fromRGBO(244, 245, 245, 1.0),
//      bottomNavigationBar: BottomNavigationBar(
//         type: BottomNavigationBarType.fixed,
//         currentIndex: _currentIndex,
//         items: bottomTabs,
//         onTap: (index){
//             setState(() {
//               _currentIndex = index;
//               _currentPage = tabBodies[_currentIndex];
//             });
//         },
//     ),
//      body: IndexedStack(//_currentPage
//        index: _currentIndex,
//        children: tabBodies,//接收页面上显示的主页面 比如有四个tab 点击四个tab显示的那四个组件 必须要是个Widget类型的List
//      ),
//    );
//  }
//}
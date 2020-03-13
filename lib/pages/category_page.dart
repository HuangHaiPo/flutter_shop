import 'package:flutter/material.dart';
import '../service/service_method.dart';
import 'dart:convert';
import '../models/category.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import '../provide/child_category.dart';
import 'package:provide/provide.dart';
import '../models/categoryRightModel.dart';
import '../provide/category_goods_list.dart';
import 'package:flutter_easyrefresh/easy_refresh.dart';
import 'package:fluttertoast/fluttertoast.dart';



class CategoryPage extends StatefulWidget {
  @override
  _CategoryPageState createState() => _CategoryPageState();
}

class _CategoryPageState extends State<CategoryPage> {
  @override
  Widget build(BuildContext context) {
    return Container(
      child: Scaffold(
        appBar: AppBar(
          title: Text('分类'),
        ),
        body: Container(
          child: Row(
            children: <Widget>[
              LeftCategoryNav(),
              Column(
                children: <Widget>[
                  RightCategoryNav(),
                  CategoryGoodsList()
                ],
              )
            ],
          ),
        ),
      ),
    );
  }

}

//分类 左侧大类导航
class LeftCategoryNav extends StatefulWidget {
  @override
  _LeftCategoryNavState createState() => _LeftCategoryNavState();
}

class _LeftCategoryNavState extends State<LeftCategoryNav> {
  List listData = [];
  var listIndex = 0;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    _getCategory();
    _getGoodsList();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      width: ScreenUtil().setWidth(180),
      decoration: BoxDecoration(
        border: Border(
          right: BorderSide(width: 1,color: Colors.black12),
        )
      ),
      child: ListView.builder(
        itemCount: listData.length,
          itemBuilder:(context ,index){
          return _leftInkWell(index);
          },
      ),
    );
  }

  Widget _leftInkWell(int index){
    bool isClick = false;
    isClick = (index == listIndex) ? true : false;

    return InkWell(
      onTap: (){
        setState(() {
          listIndex = index;
        });
        var childList = listData[index].bxMallSubDto;
        var categoryId = listData[index].mallCategoryId;
//        List<BxMallSubDto> tempArray = childList;
//        tempArray.forEach((item) => print(item.mallSubName));
        Provide.value<ChildCategory>(context).getChildCategory(childList,categoryId);
        _getGoodsList(categoryId:categoryId);
      },
      child: Container(
        height: ScreenUtil().setHeight(100),
        padding: EdgeInsets.only(left: 10, top: 20),
        decoration: BoxDecoration(
          color: isClick?Colors.black12 : Colors.white,
          border: Border(
            bottom: BorderSide(width: 1,color: Colors.black12),
          ),
        ),
        child: Text(listData[index].mallCategoryName,style: TextStyle(fontSize: ScreenUtil().setSp(26))),
      ),
    );
  }
  void _getCategory() async{
    await request('getCategory').then((val){
      var data = json.decode(val.toString());
      CategoryModel category = CategoryModel.fromJson(data);
      setState(() {
        listData = category.data;
      });
      Provide.value<ChildCategory>(context).getChildCategory(listData[0].bxMallSubDto,listData[0].mallCategoryId);
//      category.data.forEach((item) => print(item.mallCategoryName));
    });
  }
//如果用then方法 写不写 async 和 await 都行 因为。then是个回调
  void _getGoodsList ({String categoryId}) async{
    var arguments = {
      'categoryId':categoryId == null ? '4' : categoryId,
      'categorySubId':'',
      'page':1};
    await request('getMallGoods',formData: arguments).then((val){
      var rightData = json.decode(val.toString());
      CategoryRightModel rightModel = CategoryRightModel.fromJson(rightData);
      Provide.value<CategoryGoodsListProvide>(context).getGoodList(rightModel.data);
//      rightModel.data.forEach((item) => print('${item.goodsName}'));
    });
  }

}

//右侧导航
class RightCategoryNav extends StatefulWidget {
  @override
  RightCategoryNavState createState() => new RightCategoryNavState();
}

class RightCategoryNavState extends State<RightCategoryNav> {
//  List list = ['名酒','好酒','红酒','背景二锅头','五粮液','茅台','江小白'];
  @override
  Widget build(BuildContext context) {

    return Provide<ChildCategory>(
      builder: (context, child,childCategory){
        return Container(
            height: ScreenUtil().setHeight(80),
            width: ScreenUtil().setWidth(570),
            decoration: BoxDecoration(
                color: Colors.white,
                border: Border(
                    bottom: BorderSide(width: 1,color: Colors.black12)
                )
            ),
            child: ListView.builder(
                scrollDirection: Axis.horizontal,
                itemCount: childCategory.childCategoryList.length,
                itemBuilder: (context,index){
                  return _rightInkWell(index,childCategory.childCategoryList[index]);
                }),
          );
      }
    );
  }
  Widget _rightInkWell( int index, BxMallSubDto item){

    bool isClick = false;

    isClick = (index == Provide.value<ChildCategory>(context).childIndex) ? true : false;


    return InkWell(
      onTap: (){
        Provide.value<ChildCategory>(context).changeChildIndex(index,item.mallSubId);
        _getGoodsList(item.mallSubId);
      },
      child: Container(
//        color: Colors.green,
//        width: 50,
        padding: EdgeInsets.fromLTRB(5.0, 10.0, 5.0, 10.0),
        child: Text(
          item.mallSubName,
          style: TextStyle(
              fontSize: ScreenUtil().setSp(26),
              color:  isClick ? Colors.pink : Colors.black,
          ),
        ),
      ),
    );
  }
  //如果用then方法 写不写 async 和 await 都行 因为。then是个回调
  void _getGoodsList (String categorySubId) async{
    var arguments = {
      'categoryId':Provide.value<ChildCategory>(context).categoryId,
      'categorySubId': categorySubId,
      'page':1};
    await request('getMallGoods',formData: arguments).then((val){
      var rightData = json.decode(val.toString());
      CategoryRightModel rightModel = CategoryRightModel.fromJson(rightData);
      if(rightModel.data == null){
        Provide.value<CategoryGoodsListProvide>(context).getGoodList([]);
      }else{
        Provide.value<CategoryGoodsListProvide>(context).getGoodList(rightModel.data);
      }
//      rightModel.data.forEach((item) => print('${item.goodsName}'));
    });
  }

}

//右边商品列表 可以上啦加载
class CategoryGoodsList extends StatefulWidget {
  @override
  CategoryGoodsListState createState() => new CategoryGoodsListState();
}

class CategoryGoodsListState extends State<CategoryGoodsList> {

  var scorllController = ScrollController();
  @override
  Widget build(BuildContext context) {
    return Provide<CategoryGoodsListProvide>(
      builder: (context,child,data){
        try{
          if(Provide.value<ChildCategory>(context).page == 1){//page=1的时候切换大类了页面回到顶部
//            列表位置，放到最上面
                scorllController.jumpTo(0.0);
          }
        }catch(e){
          print('今日页面第一次初始化${e}');//
        }
        
        
        if(data.goodsList.length > 0){
            return Expanded(
              child:Container(
                width: ScreenUtil( ).setWidth(570),
//                child:  ListView.builder(
//                    itemCount: data.goodsList.length,
//                    itemBuilder: (context, index){
//                      return _listWidget(data.goodsList,index);
//                    }
//                ),
                child: EasyRefresh(
                  footer: ClassicalFooter(
                    bgColor: Colors.white,
                    textColor: Colors.pink,
                    noMoreText:Provide.value<ChildCategory>(context).noMareText,
                    loadingText: '加载中..',
                    loadReadyText: '上拉加载',
                    loadedText:'加载完成',
                    showInfo: false,
                    loadFailedText: '加载失败',
                    infoText: '详细说明',
                  ),
                  child:  ListView.builder(
                    controller: scorllController,
                      itemCount: data.goodsList.length,
                      itemBuilder: (context, index){
                        return _listWidget(data.goodsList,index);
                      }
                  ),
//                  onRefresh: () async{
//                    print('下拉刷新');
//                  },
                  onLoad: () async{
                    _getMoreList();
                  },
                ),
              ),
            );
        }else{
          return Text('暂时没有数据!');
        }
//        Expanded伸缩组件继承与Flexible

      },
    );
  }
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
  }

//如果用then方法 写不写 async 和 await 都行 因为。then是个回调
  void _getMoreList () async{
    Provide.value<ChildCategory>(context).addPage();
    var arguments = {
      'categoryId':Provide.value<ChildCategory>(context).categoryId,
      'categorySubId': Provide.value<ChildCategory>(context).subId,
      'page':Provide.value<ChildCategory>(context).page};
    await request('getMallGoods',formData: arguments).then((val){
      var rightData = json.decode(val.toString());
      CategoryRightModel rightModel = CategoryRightModel.fromJson(rightData);
      if(rightModel.data == null){
        Fluttertoast.showToast(msg: '已经到底了',toastLength: Toast.LENGTH_SHORT,gravity: ToastGravity.CENTER,backgroundColor: Colors.pink,textColor: Colors.white,fontSize: 16.0);
        Provide.value<ChildCategory>(context).changeNoMare('没有更多了!');
      }else{
        Provide.value<CategoryGoodsListProvide>(context).getMoreList(rightModel.data);
      }
//      rightModel.data.forEach((item) => print('${item.goodsName}'));
    });
  }

  Widget _goodsImage(List newList ,index){
    return Container(
      width: ScreenUtil().setWidth(200),
      child: Image.network(newList[index].image),
    );
  }

  Widget _goodsName(List newList ,index){
    return Container(
      width: ScreenUtil().setWidth(370),
//      padding: EdgeInsets.all(50),
      child: Text(
          newList[index].goodsName,
        maxLines: 2,
        overflow: TextOverflow.ellipsis,
        style: TextStyle(fontSize: ScreenUtil().setSp(28))
      ),
    );
  }


  Widget _goodsPrice(List newList ,index){
    return Container(
      margin: EdgeInsets.only(top: 20.0),
      width: ScreenUtil().setWidth(370),
      child: Row(
        children: <Widget>[
            Text(
              '价格:￥${newList[index].presentPrice}',
              style: TextStyle(color: Colors.pink,fontSize: ScreenUtil().setSp(30)),
            ),
          SizedBox(width: 5.0),
          Text(
            '￥${newList[index].oriPrice}',
            style: TextStyle(color: Colors.black26,decoration: TextDecoration.lineThrough),
          ),
        ],
      ),
    );
  }
  Widget _listWidget(List newList , index){

    return InkWell(
      onTap: (){},
      child: Container(
        padding: EdgeInsets.only(top: 5.0,bottom: 5.0),
        decoration: BoxDecoration(
          color: Colors.white,
          border: Border(
            bottom: BorderSide(width: 1.0,color: Colors.black12)
          )
        ),
        child: Row(
          children: <Widget>[
            _goodsImage(newList,index),
            Column(
              children: <Widget>[
                _goodsName(newList, index),
                _goodsPrice(newList, index),
              ],
            ),
          ],
        ),
      ),
    );

  }
}
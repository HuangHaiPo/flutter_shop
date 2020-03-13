import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';


class MemberPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('会员中心'),
      ),
      body:ListView(
        children: <Widget>[
          _topHeader(),
          _orderTitle(),
          _orderType(),
          _actionList(),
        ],
      ),
    );
  }
  Widget _topHeader(){
    return Container(
      width: ScreenUtil().setWidth(750),
      height: ScreenUtil().setHeight(400.0),
      padding: EdgeInsets.all(20.0),
      color: Colors.pinkAccent,
      child: Column(
        children: <Widget>[
          Container(
            margin: EdgeInsets.only(top : 20.0),
            child: ClipOval(
              child: Image.network('http://b-ssl.duitang.com/uploads/item/201810/18/20181018162951_kgwzm.thumb.700_0.jpeg',
              height: ScreenUtil().setHeight(200),),
            ),

          ),
          Container(
            margin: EdgeInsets.only(top: 10.0),
            child: Text(
                '黄海泼',
              style: TextStyle(
                fontSize: ScreenUtil().setSp(36),
                color: Colors.black54,
              ),
                ),
          )
        ],
      ),
    );
  }
//  我的订单标题
  Widget _orderTitle(){
    return Container(
      margin: EdgeInsets.only(top: 10.0),
      decoration: BoxDecoration(
        color: Colors.white,
        border: Border(
          bottom: BorderSide(width: 1,color: Colors.black12),
        ),
      ),
      child: ListTile(
        leading: Icon(Icons.list),
        title: Text('我的订单'),
        trailing: Icon(Icons.arrow_forward_ios),
      ),
    );
  }
  //待评价等
  Widget _orderType(){
    return Container(
      margin: EdgeInsets.only(top: 5.0),
      width: ScreenUtil().setWidth(750),
      height: ScreenUtil().setHeight(150.0),
      padding: EdgeInsets.only(top: 10.0),
      color: Colors.white,
      child: Row(
        children: <Widget>[
          Container(
            width: ScreenUtil().setWidth(187),
            child: Column(
              children: <Widget>[
                Icon(Icons.party_mode
                  ,size: 30,),
                Text('待付款')
              ],
            ),
          ),
          Container(
            width: ScreenUtil().setWidth(187),
            child: Column(
              children: <Widget>[
                Icon(Icons.query_builder,size: 30,),
                Text('待发布')
              ],
            ),
          ),
          Container(
            width: ScreenUtil().setWidth(187),
            child: Column(
              children: <Widget>[
                Icon(Icons.shopping_cart,size: 30,),
                Text('待收货')
              ],
            ),
          ),
          Container(
            width: ScreenUtil().setWidth(187),
            child: Column(
              children: <Widget>[
                Icon(Icons.content_paste,size: 30,),
                Text('待评价')
              ],
            ),
          ),
        ],
      ),
    );
  }
  //
  Widget _ListTile(String title){
    return  Container(
      decoration: BoxDecoration(
        color: Colors.white,
        border: Border(
          bottom: BorderSide(color:Colors.black12,width: 1.0),
        )
      ),
      child: ListTile(
        leading: Icon(Icons.blur_circular),
        title: Text(title),
        trailing: Icon(Icons.arrow_forward_ios),
      ),
    );

  }
  Widget _actionList(){
    return Container(
      margin: EdgeInsets.only(top: 10.0),
      child: Column(
        children: <Widget>[
          _ListTile('领取优惠券'),
          _ListTile('已领取优惠券'),
          _ListTile('地址管理'),
          _ListTile('客服电话'),
          _ListTile('关于我们'),

        ],
      ),
    );
  }

}


import 'package:flutter/material.dart';
import 'package:provide/provide.dart';
import 'package:flutter_shop/provide/details_info.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class DetailTopArea extends StatelessWidget {

  const DetailTopArea({Key key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Provide<DetailsInfoProvide>(
      builder: (context,child,val){
        var goodsInfo = Provide.value<DetailsInfoProvide>(context).goodsInfo.data.goodInfo;
        if(goodsInfo != null){
            return Container(
              color: Colors.white,
              child: Column(
                children: <Widget>[
                  _goodsImage(goodsInfo.image1),
                  _goodsName(goodsInfo.goodsName),
                  _goodsNum(goodsInfo.goodsSerialNumber),
                  Row(
                    children: <Widget>[
                      _getGoodsPrice(goodsInfo.presentPrice),
                      _getGoodMarketPrice(goodsInfo.oriPrice)
                    ],
                  ),
                  SizedBox(height: 10),
                ],
              ),
            );
        }else{
          return Text('正在加载中.....');
        }
      },

    );
  }
//  详情顶部商品图标
  Widget _goodsImage(url){
    return Image.network(
      url,
      width: ScreenUtil().setWidth(740),
    );
  }
//  商品名称
  Widget _goodsName(name){
    return Container(
      width: ScreenUtil().setWidth(740),
      padding: EdgeInsets.only(left: 15.0),
      child: Text(
          name,
        style: TextStyle(
          fontSize: ScreenUtil().setSp(30),
        ),
      ),
    );
  }
//  商品编号
  Widget _goodsNum(num){
    return Container(
      width: ScreenUtil().setWidth(730),
      padding: EdgeInsets.only(left: 15.0),
      margin: EdgeInsets.only(top: 8.0),
      child: Text(
        '编号：${num}',
        style: TextStyle(
          color: Colors.black12,
        ),
      ),
    );
  }
// 商品价格
  Widget _getGoodsPrice(price){
    return Container(
      width: ScreenUtil().setWidth(200.0),
      margin: EdgeInsets.only(top: 8.0),
      padding: EdgeInsets.only(left: 15.0),
      color: Colors.white,
      child: Text(
        '￥${price}',
        style: TextStyle(
          color: Colors.pink,
          fontSize: ScreenUtil().setSp(35),
        ),
      ),
    );
  }
  Widget _getGoodMarketPrice(marketPrice){
    return Container(
      width: ScreenUtil().setWidth(300.0),
      color: Colors.white,
      padding: EdgeInsets.only(left: 15.0),
      margin: EdgeInsets.only(top: 10.0),
      child: Text(
        '市场价: ${marketPrice}',
      ),
    );
  }
}
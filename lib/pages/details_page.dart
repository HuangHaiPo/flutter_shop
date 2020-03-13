/*
 * @Author: huanghaipo 
 * @Date: 2019-08-29 10:48:53 
 * @Last Modified by: huanghaipo
 * @Last Modified time: 2019-08-29 11:06:13
 */


import 'package:flutter/material.dart';
import 'package:provide/provide.dart';
import 'package:flutter_shop/provide/details_info.dart';
import 'package:flutter_shop/pages/details_page/details_top_area.dart';
import 'package:flutter_shop/pages/details_page/details_explain.dart';
import 'package:flutter_shop/pages/details_page/details+tabbar.dart';
import 'details_page/details_goods_web.dart';
import 'details_page/details_bottom.dart';

class DetailsPage extends StatelessWidget {
 
  final String goodsId;
  
  DetailsPage(this.goodsId);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(icon: Icon(Icons.arrow_back_ios), onPressed:() => Navigator.pop(context)),
        title: Text('商品详情页面'),
      ),
      body: FutureBuilder(//可以异步加载
        future:  _getBackInfo(context),
        builder: (context , snapshot){
          if(snapshot.hasData){
            return Stack(//Stack 层叠组件
              children: <Widget>[
                Container(
                  child: ListView(
                    children: <Widget>[
                      DetailTopArea(),
                      DetailsExplain(),
                      DetailsTabbar(),
                      DetailGoodsWeb(),

                    ],
                  ),
                ),

                Positioned(
                  bottom: 0,
                  left: 0,
                  child:  DetailsBottom(),
                ),
              ],
            );



          }else{
            return Text('加载中....');
          }
        },
      ),

    );
  }
  Future _getBackInfo(BuildContext context) async{
    await Provide.value<DetailsInfoProvide>(context).getGoodsInfo(goodsId);
    return '完成加载';
  }
}


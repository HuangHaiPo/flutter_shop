import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_shop/models/cartInfo_model.dart';
import 'cart_goods_count.dart';
import 'package:provide/provide.dart';
import 'package:flutter_shop/provide/cart.dart';


class CartItem extends StatelessWidget {

  final CartInfoModel item;

  CartItem(this.item);

  @override
  Widget build(BuildContext context) {
    return Container(
      ///margin外边距
      margin: EdgeInsets.fromLTRB(5.0, 2.0, 5.0, 2.0),
      ///内边距
      padding: EdgeInsets.fromLTRB(5.0, 10.0, 5.0 , 10.0),
      decoration: BoxDecoration(
        color: Colors.white,
        border: Border(
          bottom: BorderSide(width: 1,color: Colors.black12),
        )
      ),
      child: Row(
        children: <Widget>[
          _cartCheckBtn(context,item),
          _cartGoodsImage(),
          _cartGoodsName(),
          _cartGoodsPrice(context,item),
        ],
      ),
    );
  }
///购物车多选按钮
  Widget _cartCheckBtn(context,item){
    return Container(
      child: Checkbox(
          value: item.isCheck,
          onChanged: (bool val){
            item.isCheck = val;
            Provide.value<CartProvide>(context).changeCheckState(item);
          },
          activeColor: Colors.pink,
      ),
    );
  }

  ////商品图片
  Widget _cartGoodsImage(){
    return Container(
      width: ScreenUtil().setWidth(150),
      padding: EdgeInsets.all(3.0),
//      decoration: BoxDecoration(
//        border: Border.all(color: Colors.black12),
//      ),
      child: Image.network(item.images),
    );
  }

  ////商品名称
  Widget _cartGoodsName(){

    return  Container(
      width: ScreenUtil().setWidth(300),
      padding: EdgeInsets.all(10.0),
      alignment: Alignment.topLeft,
      child: Column(
        children: <Widget>[
          Text(item.goodsName),
          CartGoodsCount(item)
        ],
      ),
    );

  }

  ////商品价格
  Widget _cartGoodsPrice(context,item){

    return  Container(
      width: ScreenUtil().setWidth(150),
      alignment: Alignment.centerRight,
      child: Column(
        children: <Widget>[
          Text('￥${item.price}'),
          Container(
            child: InkWell(
              onTap: (){
                Provide.value<CartProvide>(context).deleteOneGoods(item.goodsId);
              },
              child: Icon(Icons.delete_forever,color: Colors.black26,size: 30),
            ),
          ),
        ],
      ),
    );

  }



}

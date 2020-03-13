import 'package:flutter/material.dart';
import '../provide/connter.dart';
import 'package:provide/provide.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_shop/provide/cart.dart';
import 'package:flutter_shop/pages/cart_page/cart_item.dart';
import 'package:flutter_shop/models/cartInfo_model.dart';
import 'cart_page/cart_bottom.dart';

class CartPage extends StatelessWidget {
  const CartPage({Key key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('购物车'),
      ),
      body: FutureBuilder(
          future: _getCartInfo(context),
          builder: (context, snashot) {
            if (snashot.hasData) {
              List cartList = Provide.value<CartProvide>(context).cartInfoList;
              return Stack(
                children: <Widget>[
                  Provide<CartProvide>(
                    builder: (context, child, childCategory) {
                      cartList =
                          Provide.value<CartProvide>(context).cartInfoList;
                      return ListView.builder(
                          itemCount: cartList.length,
                          itemBuilder: (context, index) {
                            print(cartList[index]);
                            CartInfoModel itemModel = cartList[index];
                            print(itemModel.goodsName);
                            return CartItem(itemModel);
                          });
                    },
                  ),
                  Positioned(
                    bottom: 0,
                    left: 0,
                    child: CartBottom(),
                  ),
                ],
              );
            } else {
              return Text('加载中....');
            }
          }),
    );
  }

  Future<String> _getCartInfo(BuildContext context) async {
    await Provide.value<CartProvide>(context).getCartInfo();
    return 'end';
  }
}

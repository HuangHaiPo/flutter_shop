import 'package:flutter/material.dart';
import 'package:provide/provide.dart';
import 'package:flutter_shop/provide/details_info.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_html/flutter_html.dart';


class DetailGoodsWeb extends StatelessWidget {
  const DetailGoodsWeb({Key key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    var goodsDetails = Provide.value<DetailsInfoProvide>(context).goodsInfo.data.goodInfo.goodsDetail;
    return  Provide<DetailsInfoProvide>(
      builder: (context,child,val){
        var isLeft = Provide.value<DetailsInfoProvide>(context).isLeft;
        if(isLeft){
          return   Container(
            child: Html(
              data: goodsDetails,
              padding: EdgeInsets.all(8.0),
              backgroundColor: Colors.white70,
              defaultTextStyle: TextStyle(fontFamily: 'serif'),
              linkStyle: const TextStyle(
                color: Colors.redAccent,
              ),
              onLinkTap: (url) {
                // open url in a webview
                print('你点击了图片');
              },
            ),
          );
        }else{
          return Container(
              width: ScreenUtil().setWidth(750),
            padding: EdgeInsets.all(10.0),
            alignment: Alignment.center,
            child: Text('没有数据....')
          );
        }
      },
    );
  }
}
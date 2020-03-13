import 'package:flutter/material.dart';
import 'package:provide/provide.dart';
import 'package:flutter_shop/provide/details_info.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class DetailsTabbar extends StatelessWidget {

  const DetailsTabbar({Key key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Provide<DetailsInfoProvide>(
      builder: (context, child , val){
        var left =   Provide.value<DetailsInfoProvide>(context).isLeft;
        var right =   Provide.value<DetailsInfoProvide>(context).isRight;
        return Container(
          margin: EdgeInsets.only(top: 15.0),
          child: Row(
              children: <Widget>[
                _myTabBarLeft(context,left),
                _myTabBarRight(context, right),
              ],
          ),
        );

      },
    );
  }
//左侧的按钮
  Widget _myTabBarLeft(BuildContext context , bool isLeft){
    return InkWell(
      onTap: (){
        Provide.value<DetailsInfoProvide>(context).changeLeftAndRigt('left');
      },
      child: Container(
        padding: EdgeInsets.all(10.0),
        alignment: Alignment.center,
        width: ScreenUtil().setWidth(375),
        decoration: BoxDecoration(
          color: Colors.white,
          border: Border(
            bottom: BorderSide(width: 1.0,color: isLeft ? Colors.pink : Colors.black45),
          )
        ),
        child: Text(
          '详情',
          style:TextStyle(
            color: isLeft ? Colors.pink : Colors.black45,
          ),
        ),
      ),
    );
  }
// 右侧的按钮
  Widget _myTabBarRight(BuildContext context , bool isRight){
    return InkWell(
      onTap: (){
        Provide.value<DetailsInfoProvide>(context).changeLeftAndRigt('right');
      },
      child: Container(
        padding: EdgeInsets.all(10.0),
        alignment: Alignment.center,
        width: ScreenUtil().setWidth(375),
        decoration: BoxDecoration(
            color: Colors.white,
            border: Border(
              bottom: BorderSide(width: 1.0,color: isRight ? Colors.pink : Colors.black12),
            )
        ),
        child: Text(
          '评论',
          style:TextStyle(
            color: isRight ? Colors.pink : Colors.black45,
          ),
        ),
      ),
    );
  }
}
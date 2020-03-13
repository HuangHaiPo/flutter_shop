import 'package:flutter/material.dart';
import 'package:flutter_swiper/flutter_swiper.dart';
import 'dart:convert';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:url_launcher/url_launcher.dart';
import '../service/service_method.dart';
import 'package:flutter_easyrefresh/easy_refresh.dart';
import 'package:flutter_shop/routers/application.dart';
import 'package:fluro/fluro.dart';


class HomePage extends StatefulWidget {

  HomePage({Key key}) : super(key: key);

  _HomePageState createState() => _HomePageState();
}
//保持页面状态 必须混入 AutomaticKeepAliveClientMixin这个组件 混入之后必须保持三点 1. 重写wantKeepAlive方法 2. 组件必须的是StatefulWidget组件 3. 在tabbar上启用了pageView 或者 IndexedStack
class _HomePageState extends State<HomePage>  with AutomaticKeepAliveClientMixin{
  int page = 1;
  List<Map> hotGoodsList = [];

  @override
  bool get wantKeepAlive => true;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    print('有没有重新加载');
  }
  @override
  Widget build(BuildContext context) {
    var position = {'lon':'120.07965850830078','lat':'30.283863067626953'};
    return Container(
      child: Scaffold(
        appBar: AppBar(
          title: Text('百姓生活+'),
        ),
        body: FutureBuilder(
          //解决异步请求在渲染 不用setState 就可以很好的渲染
          future: request('homePageContent',formData: position),
          builder: (context, snapshot) {
            if (snapshot.hasData) {
              var data = json.decode(snapshot.data.toString());
              List<Map> swiper = (data['data']['slides'] as List).cast();
              List<Map> navigatorList =
                  (data['data']['category'] as List).cast();
              String adPicture =
                  data['data']['advertesPicture']['PICTURE_ADDRESS'];
              String leaderImage = data['data']['shopInfo']['leaderImage'];
              String leaderPhone = data['data']['shopInfo']['leaderPhone'];

              String integralMallPic = data['data']['integralMallPic']['PICTURE_ADDRESS'];
              String saoma = data['data']['saoma']['PICTURE_ADDRESS'];
              String newUser = data['data']['newUser']['PICTURE_ADDRESS'];
              List<String> activityList = [
                integralMallPic,
                saoma,
                newUser
              ];

              List<Map> recommendList = (data['data']['recommend'] as List).cast();

              String floor1Title = data['data']['floor1Pic']['PICTURE_ADDRESS'];
              String floor2Title = data['data']['floor2Pic']['PICTURE_ADDRESS'];
              String floor3Title = data['data']['floor3Pic']['PICTURE_ADDRESS'];

              List<Map> floor1 = (data['data']['floor1'] as List).cast();
              List<Map> floor2 = (data['data']['floor2'] as List).cast();
              List<Map> floor3 = (data['data']['floor3'] as List).cast();

              return EasyRefresh(
                  footer: ClassicalFooter(
                    bgColor: Colors.white,
                    textColor: Colors.pink,
                    noMoreText: '',
                    loadingText: '加载中..',
                    loadReadyText: '上拉加载',
                    infoText: '',
                  ),
                  child:ListView(
                      children: <Widget>[
                        SwiperDiy(swiperDateList: swiper),
                        TopNavigator(navigatorList: navigatorList),
                        AdBanner(adPicture: adPicture),
                        LeaderPhone(leaderImage: leaderImage, learderPhone: leaderPhone),
                        Activity(activityList: activityList),
                        Recommend(recommendList: recommendList),
                        FloorTitle(picture_address: floor1Title),
                        FloorContent(floorGoodList: floor1),
                        FloorTitle(picture_address: floor2Title),
                        FloorContent(floorGoodList: floor2),
                        FloorTitle(picture_address: floor3Title),
                        FloorContent(floorGoodList: floor3),
                        _hotGoods(),
                      ],
                  ),
                onLoad: () async{
//                    print('加载更多.......');
                    var formPage = {'page' : page};
                    //异步请求可以直接接 .then
                     await request('homePageBelowConten',formData: formPage).then((onValue){
                      var data = json.decode(onValue.toString());
                      List<Map> newGoodsList = (data['data'] as List).cast();
                      setState(() {
                        hotGoodsList.addAll(newGoodsList);
                        page++;
                      });
                    });
                },
              );

            } else {
              return Padding(
                padding: const EdgeInsets.all(8.0),
                child: Center(
                  child: Text('加载中...'),
                ),
              );
            }
          },
        ),
      ),
    );
  }
  // 获取热销商品的数据
   void _getHotGoods(){
       var formPage = {'page' : page};
       //异步请求可以直接接 .then
        request('homePageBelowConten',formData: formPage).then((onValue){
          var data = json.decode(onValue.toString());
          List<Map> newGoodsList = (data['data'] as List).cast();
          setState(() {
            hotGoodsList.addAll(newGoodsList);
            page++;
          });
       });
   }
  Widget hotTitle = Container(
    height: 30.0,
    margin: EdgeInsets.only(top: 10.0),
    alignment: Alignment.center,
    padding: EdgeInsets.all(5.0),
    color: Colors.transparent,
    child: Text(
      '火爆专区',
      style: TextStyle(color: Colors.red),),
  );
  Widget _wrapList(){
    if(hotGoodsList.length != 0){
      List<Widget> listWidget = hotGoodsList.map((val){
        return InkWell(
          onTap: (){
            TransitionType transitionType = TransitionType.native;
            var name = val['name'];
            var goodsId = val['goodsId'];
            Application.router.navigateTo(context, "/detail?id=${goodsId}",transition:transitionType);
          },
          child: Container(
            width: ScreenUtil().setWidth(372),
            color: Colors.white,
            padding: EdgeInsets.all(5.0),
            margin: EdgeInsets.only(bottom: 3.0),
            child: Column(
              children: <Widget>[
                Image.network(val['image'],width: ScreenUtil().setWidth(370),),
                Text(
                  val['name'],
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: TextStyle(color: Colors.pink , fontSize: ScreenUtil().setSp(26)),
                ),
                Row(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: <Widget>[
                    Text('￥${val['mallPrice']}'),
                    Text('￥${val['price']}' , style: TextStyle(color: Colors.black26 , decoration: TextDecoration.lineThrough)),
                  ],
                ),
              ],
            ),
          ),
        );
      }).toList();
      return Wrap(
        spacing: 2,//每行显示多少列
        children: listWidget,
      );
    }else{
      return Text('数据为空');
    }
  }

  Widget _hotGoods(){
    return Container(
      child: Column(
        children: <Widget>[
          hotTitle,
          _wrapList()
        ],
      ),
    );
  }


}
//首页轮播组件
class SwiperDiy extends StatelessWidget {
  final List swiperDateList;

  const SwiperDiy({Key key, this.swiperDateList}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    // print('设备像素密度:${ScreenUtil.pixelRatio}');
    // print('设备高:${ScreenUtil.screenHeight}');
    // print('设备宽:${ScreenUtil.screenWidth}');
    ScreenUtil.instance = ScreenUtil(width: 750, height: 1334)..init(context);
    return Container(
      height: ScreenUtil().setHeight(333),
      width: ScreenUtil().setWidth(750),
      child: Swiper(
        itemBuilder: (BuildContext context, int index) {
          return InkWell(
            onTap: (){
              TransitionType transitionType = TransitionType.native;
              Map bannerDic = this.swiperDateList[index];
              var goodsId = bannerDic['image'];
              Application.router.navigateTo(context, "/detail?id=cf304b822ddd4f6aa275c5e54f36abba",transition:transitionType);
            },

            child: Image.network('${swiperDateList[index]['image']}',
                fit: BoxFit.fill),
          );
        },
        itemCount: swiperDateList.length,
        pagination: SwiperPagination(), //点 指示器
        autoplay: true,
      ),
    );
  }
}

// 轮播图下的分类组件
class TopNavigator extends StatelessWidget {
  final List navigatorList;

  TopNavigator({Key key, this.navigatorList}) : super(key: key);

  Widget _gridViewItemUI(BuildContext context, item) {
    return InkWell(
      onTap: () {
        print('点击了导航');
      },
      child: Column(
        children: <Widget>[
          Image.network(item['image'], width: ScreenUtil().setWidth(95)),
          Text(item['mallCategoryName']),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    if (this.navigatorList.length > 10) {
      this.navigatorList.removeRange(10, navigatorList.length);
    }
    return Container(
      height: ScreenUtil().setHeight(320),
      padding: EdgeInsets.all(5.0),
      child: GridView.count(
        physics: NeverScrollableScrollPhysics(),//屏蔽GridView内部滚动
        crossAxisCount: 5,
        padding: EdgeInsets.all(10.0),
        children: navigatorList.map((item) {
          return _gridViewItemUI(context, item);
        }).toList(),
      ),
    );
  }
}


// 广告区域
class AdBanner extends StatelessWidget {
  final String adPicture;

  const AdBanner({Key key, this.adPicture}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      child: Image.network(adPicture),
    );
  }
}

// 店长电话模块
class LeaderPhone extends StatelessWidget {
  final String leaderImage; //店长图片
  final String learderPhone; //店长电话
  const LeaderPhone({Key key, this.leaderImage, this.learderPhone})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      child: InkWell(
        onTap: this._launchURL,
        child: Image.network(leaderImage),
      ),
    );
  }

  void _launchURL() async {
    String url = 'tel:' + learderPhone; //苹果模拟器不能访问电话
    print(url);
    if (await canLaunch(url)) {
      //打电话是需要等待的 等待看看这个电话能不能打 如果能打执行下面的方法 打电话
      await launch(url);
    } else {
      throw 'URL不能进行访问，异常。无法启动${url}，或者使用的是苹果的模拟器，苹果模拟器不能直接打电话，只能通过真机';
    }
  }
}

//店长电话下面的活动模块
class Activity extends StatelessWidget {
  final List<String> activityList;
  const Activity({Key key , this.activityList}) : super(key : key);
  @override
  Widget build(BuildContext context) {
    return Container(
//       color: Colors.red,
      height: ScreenUtil().setHeight(355),
      width: ScreenUtil().setWidth(ScreenUtil.screenWidth),
      child: GridView.count(
          padding: EdgeInsets.only(top: 10.0),
          crossAxisCount: 3,
          childAspectRatio: 0.79,
          physics: NeverScrollableScrollPhysics(),
          children: this.activityList.map((item){
            return _activityGridViewUI(context , item);
          }).toList(),

      ),
    );
  }
  Widget _activityGridViewUI(BuildContext context , item){
    return InkWell(
      onTap: (){},
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: <Widget>[
          Image.network(
            item, 
            ),
        ],
      ),
    );
  }
}
//商品推荐模块
class Recommend extends StatelessWidget {
  final List recommendList;
  const Recommend({Key key , this.recommendList}) : super(key : key);
//  标题
  Widget _titleWidget(){
    return Container(
      alignment: Alignment.centerLeft,//对其方式 横向居中左对齐
      padding: EdgeInsets.fromLTRB(10.0, 2.0, 0, 5.0), 
      decoration: BoxDecoration(
        color: Colors.white,
        border: Border(bottom: BorderSide(width: 0.5 , color: Colors.black12)),
      ),
      child: Text('商品推荐',style: TextStyle(color: Colors.pink)),
    );
  }
  // 商品单独项方法 
  Widget _item(context , index){
    return InkWell(
      onTap: (){
        TransitionType transitionType = TransitionType.native;
        Map bannerDic = this.recommendList[index];
        var goodsId = bannerDic['goodsId'];
        Application.router.navigateTo(context, "/detail?id=${goodsId}",transition:transitionType);
      },
      child: Container(
        height: ScreenUtil().setHeight(330),
        width: ScreenUtil().setWidth(250),
        padding: EdgeInsets.all(8.0),
        decoration: BoxDecoration(color: Colors.white ,border: Border(left: BorderSide(width: 0.5 , color: Colors.black12) )),
        child: Column(
          children: <Widget>[
            Image.network(this.recommendList[index]['image']),
            Text('￥${recommendList[index]['mallPrice']}'),
            Text('￥${recommendList[index]['price']}',style: TextStyle(decoration: TextDecoration.lineThrough , color: Colors.grey)),
          ],
        ),
      ),
    );
  }
  // 横向列表
  Widget _recommendList(){
    return Container(
      height: ScreenUtil().setHeight(330),
      child: ListView.builder(
        scrollDirection: Axis.horizontal,
        itemCount: recommendList.length,
        itemBuilder: (context , index){
          return _item(context , index);
        },
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      height: ScreenUtil().setHeight(390),
      margin: EdgeInsets.only(top: 10.0),
      child: Column(
        children: <Widget>[
          _titleWidget(),
          _recommendList()
        ],
      ),
    );
  }
}

// 楼层标题组件
class FloorTitle extends StatelessWidget {
  final String picture_address;
  FloorTitle({Key key , this.picture_address}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.all(0.0),
      child: Image.network(this.picture_address),
    );
  }
}


// 楼层商品列表
class FloorContent extends StatelessWidget {
  final List floorGoodList;
  FloorContent({Key key, this.floorGoodList}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      
      child: Column(
        children: <Widget>[
          _firstRow(context),
          _otherGoods(context)
          ],
      ),
    );
  }

  Widget _goodsItem(BuildContext context , Map goods){
    return Container(
      width: ScreenUtil().setWidth(375),
      child: InkWell(
        onTap: (){
          TransitionType transitionType = TransitionType.native;
          var goodsId = goods['goodsId'];
          Application.router.navigateTo(context , "/detail?id=${goodsId}",transition:transitionType);
        },
        child: Image.network(goods['image']),
      ),
    );
  }

  Widget _firstRow(context){
    return Row(
      children: <Widget>[
        _goodsItem(context , floorGoodList[0]),
        Column(
          children: <Widget>[
            _goodsItem(context , floorGoodList[1]),
            _goodsItem(context , floorGoodList[2]),
          ],
        ),
      ],
    );
  }

  Widget _otherGoods(context){
    return Row(
      children: <Widget>[
        _goodsItem(context , floorGoodList[3]),
        _goodsItem(context , floorGoodList[4]),
      ],

    );
  }

}
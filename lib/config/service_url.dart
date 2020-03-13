

// 这个文件主要是定义接口的 服务器接口
//商场首页上面的数据接口
// https://wxmini.baixingliangfan.cn/baixing/wxmini/homePageContent  
// 商城首页 下面的可以下拉加载的接口
// https://wxmini.baixingliangfan.cn/baixing/wxmini/homePageBelowConten 

//可以定义多个 用到那个解注释那个 比如有测试的 正式的 测试用测试 正式用正式
//正式环境
const serviceUrl = 'https://wxmini.baixingliangfan.cn/baixing';
// const serviceUrl = 'http://test.baixingliangfan.cn/baixing';

const servicePath={//map类型 通过key找到URL
  'homePageContent':serviceUrl+'/wxmini/homePageContent',//商店首页信息
  'homePageBelowConten':serviceUrl + '/wxmini/homePageBelowConten',//商场首页火爆专区 接口
  'getCategory':serviceUrl + '/wxmini/getCategory',// 商品类别信息 接口
  'getMallGoods':serviceUrl + '/wxmini/getMallGoods',// 商品分类 右边商品列表接口
  'getGoodDetailById':serviceUrl + '/wxmini/getGoodDetailById',// 商品详细信息页面接口

};
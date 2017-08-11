//
//  Header.h
//  Universialshare
//
//  Created by 四川三君科技有限公司 on 2017/3/23.
//  Copyright © 2017年 四川三君科技有限公司. All rights reserved.
//

#ifndef Header_h
#define Header_h

#define SCREEN_WIDTH  [UIScreen mainScreen].bounds.size.width
#define SCREEN_HEIGHT  [UIScreen mainScreen].bounds.size.height

#define timea 0.3f

#define YYSRGBColor(r, g, b, a) [UIColor colorWithRed:(r)/255.0 green:(g)/255.0 blue:(b)/255.0 alpha:(a)]

#define TABBARTITLE_COLOR YYSRGBColor(40, 150, 58 , 1.0) //导航栏颜色
#define autoSizeScaleX (SCREEN_WIDTH/320.f)
#define autoSizeScaleY (SCREEN_HEIGHT/568.f)

#define ADAPT(x) SCREEN_WIDTH / 375 *(x)

//#define URL_Base @"https://www.51dztg.com/index.php/app/"
#define URL_Base @"http://dzgx.joshuaweb.cn/index.php/app/"
//下载地址
#define DOWNLOAD_URL @"https://itunes.apple.com/cn/app/id1228047806?mt=8"
//获取appStore上的最新版本号地址
#define GET_VERSION  @"https://itunes.apple.com/lookup?id=1228047806"
//关于我们网址
#define ABOUTUS_URL @"https://www.51dztg.com/hyjm/hyjm.html"
//公告
#define NOTICE_URL @"https://www.51dztg.com/index.php/Home/Newsdemo/newestnotice.html"
//注册协议
#define REGISTER_URL @"http://www.51dztg.com/index.php/Home/Regist/protocol.html"
//推荐扫码注册
#define RECOMMEND_REGISTER_URL @"http://www.51dztg.com/index.php/Home/Regist/index.html?username="
//常见问题
#define COMMONPROBLE @"https://www.51dztg.com/index.php/Home/Index/question.html"

//米家
#define OrdinaryUser @"10"
//米商
#define Retailer @"9"
//副总
#define ONESALER @"13"
//高级推广员
#define TWOSALER @"7"
//推广员
#define THREESALER @"8"

#define PlaceHolderImage @"planceholder"
#define LUNBO_PlaceHolder @"轮播暂位图"
#define MERCHAT_PlaceHolder @"商户暂位图"

//http://dzgx.joshuaweb.cn/index.php/Home/Regist/index.html
//分享
#define SHARE_URL @"https://www.51dztg.com/index.php/Home/Regist/index.html"
#define UMSHARE_APPKEY @"58cf31dcf29d982906001f63"
//微信分享
#define WEIXI_APPKEY @"wx3719a66cd8983420"
#define WEIXI_SECRET @"4fae7202764cda777d88c9515b5ca24e"
//微博分享
#define WEIBO_APPKEY @"2203958313"
#define WEIBO_SECRET @"9a911777f4b18555cd2b42a9bc186389"
//#define WEIBO_APPKEY @"688497271"
//#define WEIBO_SECRET @"5d4df0f912e9af331adaf718a357176f"
//虚拟货币名称
#define NormalMoney @"米子"
#define SpecialMoney @"推荐米子"
//公钥RSA
#define public_RSA @"MIGfMA0GCSqGSIb3DQEBAQUAA4GNADCBiQKBgQDDF4IeiOMGVERr/4oTZWuthQx+eesKBx70SH5xPavN8s07rFbPf3VQ8yhqsX2TuBhsVz5PDjFyn3NgfJPXr5uVCSu3nONGttK3pnYsIlkHLOQAq3uDl3UwvuDnz6j7Urjxkkonh011o8FZ5pGMSSmGkMVyJ8RVTUIKgcQhNk4VXwIDAQAB"

#define NMUBERS @"0123456789./*-+~!@#$%^&()_+-=,./;'[]{}:<>?`"


#define KCURRENTCITYINFODEFAULTS [NSUserDefaults standardUserDefaults]

/**
 * 物流地址
 */

#define logisticsUrl @"http://jisukdcx.market.alicloudapi.com/express/query"

//3%返利的宏
#define KThreePersent @"4"

//支付宝appid
#define AlipayAPPID @"2017060207408516"

#endif /* Header_h */

//
//  GLNearby_NearShopModel.h
//  Universialshare
//
//  Created by 龚磊 on 2017/5/18.
//  Copyright © 2017年 四川三君科技有限公司. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface GLNearby_NearShopModel : NSObject
//"uid": "430",
//"shop_name": "wqwq",
//"store_pic": "https://www.51dztg.com/index.php/Uploads/Store/images/2017/05/09/1494313915a49fe8914df0eada4d4b7d530d7fa5ba.jpg",
//"shop_id": "403",
//"shop_address": "bfdhfghfghf",
//"total_money": "0.00",
//"lng": "104.104523",
//"lat": "30.653295",
//"limit": 1991,
//"phone": "15823261652"

@property (nonatomic, copy)NSString *uid;

@property (nonatomic, copy)NSString *shop_name;

@property (nonatomic, copy)NSString *store_pic;

@property (nonatomic, copy)NSString *shop_id;

@property (nonatomic, copy)NSString *shop_address;

@property (nonatomic, copy)NSString *total_money;

@property (nonatomic, copy)NSString *lng;

@property (nonatomic, copy)NSString *lat;

@property (nonatomic, copy)NSString *limit;

@property (nonatomic, copy)NSString *phone;
@end

//
//  WhealthCardNetWork.h
//  BloodSugar
//
//  Created by TomatoPeter on 15/6/18.
//  Copyright (c) 2015年 uyiuyao. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface WhealthCardNetWork : NSObject
+ (WhealthCardNetWork *)shareWheatherCard;
- (void)getCurrentAddress;
- (void)insertWeatherDetails;
- (void)getCityWhealth;
@property(nonatomic, copy)NSString * cityName;
@end

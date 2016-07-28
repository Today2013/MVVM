//
//  WhealthCardNetWork.m
//  BloodSugar
//
//  Created by TomatoPeter on 15/6/18.
//  Copyright (c) 2015年 uyiuyao. All rights reserved.
//

#import "WhealthCardNetWork.h"
#import <CoreLocation/CoreLocation.h>
#import "AFNetworking.h"
#import "ApiClientManager.h"
@interface WhealthCardNetWork ()<CLLocationManagerDelegate>
{
}
@property(nonatomic, strong)CLLocationManager * locationManger;
@property(nonatomic, strong)AFURLSessionManager * manger;
@end
@implementation WhealthCardNetWork
+ (WhealthCardNetWork *)shareWheatherCard
{
    static dispatch_once_t onceToken;
    static WhealthCardNetWork * netWork;
    dispatch_once(&onceToken, ^{
        netWork = [[WhealthCardNetWork alloc] init];
    });
    return netWork;
}
- (instancetype)init
{
    self = [super init];
    if (self) {
        self.manger = [AFHTTPSessionManager manager];
        self.cityName = @"北京";
    }
    return self;
}
- (void)getCurrentAddress
{
    if ([CLLocationManager locationServicesEnabled]) {
        self.locationManger = [[CLLocationManager alloc] init];
        self.locationManger.delegate = self;
        self.locationManger.desiredAccuracy=kCLLocationAccuracyBest;
        self.locationManger.distanceFilter=1000.0f;
        if([self.locationManger respondsToSelector:@selector(requestAlwaysAuthorization)])
        {
//            [self.locationManger requestAlwaysAuthorization]; // 永久授权
         [self.locationManger requestWhenInUseAuthorization]; //使用中授权
        }
    }else{
//        [CommonHint showToastOnCenterWithMessage:@"定位不成功 ,请确认开启定位"];
    }
     [self.locationManger startUpdatingLocation];
}
//5.实现定位协议回调方法
#pragma mark - CoreLocation Delegate

-(void)locationManager:(CLLocationManager *)manager didUpdateLocations:(NSArray *)locations
{
    //此处locations存储了持续更新的位置坐标值，取最后一个值为最新位置，如果不想让其持续更新位置，则在此方法中获取到一个值之后让locationManager stopUpdatingLocation
    CLLocation *currentLocation = [locations lastObject];
    // 获取当前所在的城市名
    CLGeocoder *geocoder = [[CLGeocoder alloc] init];
    //根据经纬度反向地理编译出地址信息
    [geocoder reverseGeocodeLocation:currentLocation completionHandler:^(NSArray *array, NSError *error)
     {
         if (array.count > 0)
         {
             CLPlacemark *placemark = [array objectAtIndex:0];
             //将获得的所有信息显示到label上
             NSLog(@"%@",placemark.name);
             //获取城市
             NSString *city = placemark.locality;
             NSString * lastCityName = nil;
             if (!city) {
                 //四大直辖市的城市信息无法通过locality获得，只能通过获取省份的方法来获得（如果city为空，则可知为直辖市）
                 city = placemark.administrativeArea;
                 
                 
             }
             NSRange range = [city rangeOfString:@"市辖区"];
             if (range.length > 0) {
                 NSRange range1 = [city rangeOfString:@"市辖区"];
                 lastCityName = [city substringToIndex:range1.location];
             }else{
                 lastCityName = city;
             }
             self.cityName = lastCityName;
             int a = 2;
             if (a == 2) {
                 a = 3;
                 [self getCityWhealth];
             }
             
         }
         else if (error == nil && [array count] == 0)
         {
             NSLog(@"No results were returned.");
         }
         else if (error != nil)
         {
             NSLog(@"An error occurred = %@", error);
         }
     }];
    //系统会一直更新数据，直到选择停止更新，因为我们只需要获得一次经纬度即可，所以获取之后就停止更新
    [manager stopUpdatingLocation];
    
}

- (void)locationManager:(CLLocationManager *)manager
       didFailWithError:(NSError *)error {
    if (error.code == kCLErrorDenied) {
        // 提示用户出错原因，可按住Option键点击 KCLErrorDenied的查看更多出错信息，可打印error.code值查找原因所在
    }
}
- (void)getCityWhealth
{
    if (self.cityName) {
        NSString * baseUrl = @"http://api.map.baidu.com/telematics/v3/weather";
        NSDictionary * dic = @{@"location":self.cityName, @"output":@"json", @"ak":@"caetnHUWNY3qiv5I1GGsNAf8"};
        //NSString * url = [NSString stringWithFormat:baseUrl, self.cityName];
        
        
        
         [[ApiClientManager shareClientManager] requestWithMethod:RequestMethodGet requestUrl:baseUrl argument:dic successCallback:^(id responseObject) {
             NSLog(@"%@", responseObject);
         } failCallback:^(NSError * _Nonnull error, id cachedata) {
             NSLog(@"%@", error);
         } UseCacheData:YES];
        
        
        
        
//        NSMutableURLRequest *request = [[AFHTTPRequestSerializer serializer] requestWithMethod:@"GET" URLString:baseUrl parameters:dic error:nil];
//        NSURLSessionDataTask *dataTask = [self.manger dataTaskWithRequest:request completionHandler:^(NSURLResponse * _Nonnull response, id  _Nullable responseObject, NSError * _Nullable error) {
//            if (!error) {
//                if ([responseObject[@"status"] isEqualToString:@"success"]) {
//                    NSDictionary * dic = responseObject;
//                    NSLog(@"天气：%@", dic);
//                    
//                    
//                }
//            }
//            
//        }];
//        
//        [dataTask resume];
        

    }
    
}
@end


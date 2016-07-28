//
//  ViewController.m
//  MVVM
//
//  Created by TomatoPeter on 16/7/22.
//  Copyright © 2016年 ChenJianglin. All rights reserved.
//

#import "ViewController.h"
#import "NetRequestClass.h"
#import "ApiClientManager.h"
#import "WhealthCardNetWork.h"
#import "ReactiveCocoa.h"
#import "ChangeVC.h"
#import "RecursiveLock.h"
#import "ConditionLock.h"
#import "CacheDBManager.h"
@interface ViewController ()
{
    NSString *_inputStr;
    IBOutlet UILabel *label;
    IBOutlet UITextField *textField;
}
@end

@implementation ViewController
- (IBAction)changeButtonClicked:(id)sender
{
//    ConditionLock *conditionLock = [[ConditionLock alloc] init];
//    [conditionLock useConditionLock];
    [[CacheDBManager shareCacheDBManager] createGroupPersonInfoTable];
    
    [[CacheDBManager shareCacheDBManager] insertData:10 useTransaction:YES];
    [[CacheDBManager shareCacheDBManager] versionUpdate];
   NSMutableArray *array = [[CacheDBManager shareCacheDBManager] query:@"GroupPersonInfo" where:nil];
    NSLog(@"%@", array);
    
    
//    RecursiveLock *recursiveLock = [[RecursiveLock alloc] init];
//    
//    [recursiveLock useRecursiveLock];
//    NSLog(@"是否要等待");
//    
//    NSRecursiveLock *lock = [[NSRecursiveLock alloc] init];
    
//    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
//        
//        static void (^RecursiveMethod)(int);
//        
//        RecursiveMethod = ^(int value) {
//            
//            [lock lock];
//            if (value > 0) {
//                
//                NSLog(@"value = %d", value);
//                sleep(2);
//                RecursiveMethod(value - 1);
//            }
//            [lock unlock];
//        };
//        
//        RecursiveMethod(5);
//    });
    
}
//RACSubject代替代理
- (IBAction)RACSubjectDelegate:(id)sender
{
    ChangeVC *changeVC = [[ChangeVC alloc] initWithNibName:@"ChangeVC" bundle:nil];
    changeVC.delegateSignal = [RACSubject subject];
    [changeVC.delegateSignal subscribeNext:^(id x) {
        NSLog(@"%@", x);
    }];
    [self.navigationController pushViewController:changeVC animated:YES];
    
}
- (void)viewDidLoad {
    [super viewDidLoad];
    
    
    
    
    
    
    
    
    
    
//    return;
    
    
    // Do any additional setup after loading the view, typically from a nib.
//    [NetRequestClass netWorkReachabilityWithURLString:REQUESTPUBLICURL block:^(BOOL isReachily) {
//        
//        NSLog(@"%d", isReachily);
//        
//    }];
//    
//    [[WhealthCardNetWork shareWheatherCard] getCityWhealth];
    RACSignal *siganl = [RACSignal createSignal:^RACDisposable *(id<RACSubscriber> subscriber) {
        // block调用时刻：每当有订阅者订阅信号，就会调用block。
        
        // 2.发送信号
        [subscriber sendNext:@1];
        
        // 如果不在发送数据，最好发送信号完成，内部会自动调用[RACDisposable disposable]取消订阅信号。
        [subscriber sendCompleted];
        
        return [RACDisposable disposableWithBlock:^{
            
            // block调用时刻：当信号发送完成或者发送错误，就会自动执行这个block,取消订阅信号。
            
            // 执行完Block后，当前信号就不在被订阅了。
            
            NSLog(@"信号被销毁");
            
        }];
    }];
    
    // 3.订阅信号,才会激活信号.
    [siganl subscribeNext:^(id x) {
        // block调用时刻：每当有信号发出数据，就会调用block.
        NSLog(@"接收到数据:%@",x);
    }];

    
    
    // 1.创建信号
    RACSubject *subject = [RACSubject subject];
    
    // 2.订阅信号
    [subject subscribeNext:^(id x) {
        // block调用时刻：当信号发出新值，就会调用.
        NSLog(@"第一个订阅者%@",x);
    }];
    [subject subscribeNext:^(id x) {
        // block调用时刻：当信号发出新值，就会调用.
        NSLog(@"第二个订阅者%@",x);
    }];
    
    // 3.发送信号
    [subject sendNext:@"1"];
    
    
    NSArray *numbers = @[@1, @2, @3, @4];
    //数组遍历
    [numbers.rac_sequence.signal subscribeNext:^(id x) {
        NSLog(@"%@", x);
    }];
    
    // 2.遍历字典,遍历出来的键值对会包装成RACTuple(元组对象)
    NSDictionary *dict = @{@"name":@"xmg",@"age":@18};
    [dict.rac_sequence.signal subscribeNext:^(RACTuple *x) {
        
        // 解包元组，会把元组的值，按顺序给参数里面的变量赋值
        RACTupleUnpack(NSString *key,NSString *value) = x;
        
        // 相当于以下写法
        // NSString *key = x[0];
        // NSString *value = x[1];
        
        NSLog(@"%@ %@",key,value);
        
    }];
//    // 3.3 RAC高级写法:
//    NSString *filePath = [[NSBundle mainBundle] pathForResource:@"flags.plist" ofType:nil];
//    
//    NSArray *dictArr = [NSArray arrayWithContentsOfFile:filePath];
//    // map:映射的意思，目的：把原始值value映射成一个新值
//    // array: 把集合转换成数组
//    // 底层实现：当信号被订阅，会遍历集合中的原始值，映射成新值，并且保存到新的数组里。
//    NSArray *flags = [[dictArr.rac_sequence map:^id(id value) {
//        
//        return [FlagItem flagWithDict:value];
//        
//    }] array];
    
    
    
    //监听某个对象的某个属性
    [RACObserve(self.view, center) subscribeNext:^(id x) {
        
    }];
    
    // 只要文本框文字改变，就会修改label的文字
//    RAC(label,text) = textField.rac_textSignal;
//    [textField.rac_textSignal subscribeNext:^(id x) {
//        NSLog(@"%@", x);
//    }];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end

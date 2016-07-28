//
//  RecursiveLock.m
//  MVVM
//
//  Created by TomatoPeter on 16/7/27.
//  Copyright © 2016年 ChenJianglin. All rights reserved.
//

#import "RecursiveLock.h"
@interface RecursiveLock ()
@property(nonatomic, strong)NSRecursiveLock *recursiveLock;
@end
@implementation RecursiveLock
- (instancetype)init
{
    self = [super init];
    if (self) {
//        使用NSRecursiveLock。它可以允许同一线程多次加锁，而不会造成死锁。递归锁会跟踪它被lock的次数。每次成功的lock都必须平衡调用unlock操作。只有所有达到这种平衡，锁最后才能被释放，以供其它线程使用。
        //递归锁
        self.recursiveLock = [[NSRecursiveLock alloc] init];
    }
    return self;
}
//递归锁的使用
- (void)useRecursiveLock
{
    [self myFunctionWithValue:10];
}
- (void)myFunctionWithValue:(int)value
{
    
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        
        [self.recursiveLock lock];
        if(value != 0) {
            NSLog(@"%d", value);
            [self myFunctionWithValue:value - 1];
            sleep(1);
        }
        [self.recursiveLock unlock];
    });
}
@end

//
//  ConditionLock.m
//  MVVM
//
//  Created by TomatoPeter on 16/7/27.
//  Copyright © 2016年 ChenJianglin. All rights reserved.
//

#import "ConditionLock.h"
@interface ConditionLock ()
@property(nonatomic, strong)NSConditionLock *conditionLock;
@property(nonatomic, assign)BOOL isEmpty;
@end
@implementation ConditionLock
- (instancetype)init
{
    self = [super init];
    if (self) {
//        1.1  NSConditionLock 是锁，一旦一个线程获得锁，其他线程一定等待
//        1.2  [xxxx lock]; 表示 xxx 期待获得锁，如果没有其他线程获得锁（不需要判断内部的condition) 那它能执行此行以下代码，如果已经有其他线程获得锁（可能是条件锁，或者无条件锁），则等待，直至其他线程解锁
//        
//        1.3  [xxx lockWhenCondition:A条件]; 表示如果没有其他线程获得该锁，但是该锁内部的condition不等于A条件，它依然不能获得锁，仍然等待。如果内部的condition等于A条件，并且没有其他线程获得该锁，则进入代码区，同时设置它获得该锁，其他任何线程都将等待它代码的完成，直至它解锁。
//        
//        1.4  [xxx unlockWithCondition:A条件]; 表示释放锁，同时把内部的condition设置为A条件
//        
//        1.5  return = [xxx lockWhenCondition:A条件 beforeDate:A时间]; 表示如果被锁定（没获得锁），并超过该时间则不再阻塞线程。但是注意：返回的值是NO,它没有改变锁的状态，这个函数的目的在于可以实现两种状态下的处理
        self.conditionLock = [[NSConditionLock alloc] initWithCondition:0];
        
    }
    return self;
}
- (void)useConditionLock
{

    
    NSMutableArray *array = [NSMutableArray arrayWithCapacity:1];
    
    // producer
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        
            [self.conditionLock lock];
            /* Add data to the queue. */
            for (int i = 0; i < 100; i++) {
                NSLog(@"i = %d", i);
                [array addObject:@(i)];
            }
            self.isEmpty = YES;
            [self.conditionLock unlockWithCondition:1];
        
        
        
    });
    
    
    // consumer
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        
            [self.conditionLock lockWhenCondition:1];
            /* Remove data from the queue. */
            [array removeAllObjects];
            self.isEmpty = NO;
            NSLog(@"666空了");
            [self.conditionLock unlockWithCondition:(self.isEmpty ? 0 : 1)];
            
            // Process the data locally.
        
    });
    
    
}
@end

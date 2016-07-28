//
//  ChangeVC.h
//  MVVM
//
//  Created by TomatoPeter on 16/7/25.
//  Copyright © 2016年 ChenJianglin. All rights reserved.
//

#import <UIKit/UIKit.h>
@class ReactiveCocoa;
@interface ChangeVC : UIViewController
@property (nonatomic, strong) RACSubject *delegateSignal;
@end

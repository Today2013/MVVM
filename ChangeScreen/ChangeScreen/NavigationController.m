//
//  NavigationController.m
//  ChangeScreen
//
//  Created by TomatoPeter on 16/7/28.
//  Copyright © 2016年 ChenJianglin. All rights reserved.
//

#import "NavigationController.h"

@interface NavigationController ()

@end

@implementation NavigationController
- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
//    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, 1), dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
//        [self changeOrientationMask];
//    });
    self.view.transform = CGAffineTransformIdentity;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
- (BOOL)shouldAutorotate
{
    return [[self.viewControllers lastObject] shouldAutorotate];
}


- (UIInterfaceOrientationMask)supportedInterfaceOrientations
{
    return [[self.viewControllers lastObject] supportedInterfaceOrientations];
}


- (UIInterfaceOrientation)preferredInterfaceOrientationForPresentation {
    return [[self.viewControllers lastObject] preferredInterfaceOrientationForPresentation];
}
//- (void)changeOrientationMask
//{
//    [[UIApplication sharedApplication] setStatusBarOrientation:UIInterfaceOrientationLandscapeLeft animated:YES];
//    
//    CGFloat duration = [UIApplication sharedApplication].statusBarOrientationAnimationDuration;//（获取当前电池条动画改变的时间）
//    [UIView beginAnimations:nil context:nil];
//    [UIView setAnimationDuration:duration];
//    
//    //在这里设置view.transform需要匹配的旋转角度的大小就可以了。
//    
//    [UIView commitAnimations];
//}
/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end

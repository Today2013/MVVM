//
//  ViewController.m
//  ChangeScreen
//
//  Created by TomatoPeter on 16/7/28.
//  Copyright © 2016年 ChenJianglin. All rights reserved.
//

#import "ViewController.h"
#import "NavigationController.h"
@interface ViewController ()

@end

@implementation ViewController
- (BOOL)shouldAutorotate
{
    return NO;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
//-(void)willAnimateRotationToInterfaceOrientation:(UIInterfaceOrientation)toInterfaceOrientation duration:(NSTimeInterval)duration
//{
//    if (UIInterfaceOrientationIsPortrait(toInterfaceOrientation)) {
////        [landscape removeFromSuperview];
////        [self.view addSubview:portrait];
//    }
//    if (UIInterfaceOrientationIsLandscape(toInterfaceOrientation)) {
////        [portrait removeFromSuperview];
////        [self.view addSubview:landscape];
//    }
//}


// Implement loadView to create a view hierarchy programmatically, without using a nib.
//- (void)loadView {
//    
//    UIControl *back = [[UIControl alloc] initWithFrame:[[UIScreen mainScreen]bounds]];
//    back.backgroundColor = [UIColor grayColor];
//    self.view = back;
//    
//}
- (void)viewDidDisappear:(BOOL)animated
{
    [super viewDidDisappear:animated];
    
    
}

- (void)changeOrientationMask
{
    [[UIApplication sharedApplication] setStatusBarOrientation:UIInterfaceOrientationLandscapeRight animated:NO];
    
    CGFloat duration = [UIApplication sharedApplication].statusBarOrientationAnimationDuration;//（获取当前电池条动画改变的时间）
    [UIView beginAnimations:nil context:nil];
    [UIView setAnimationDuration:duration];
    
    //在这里设置view.transform需要匹配的旋转角度的大小就可以了。
    
    [UIView commitAnimations];
    
    self.navigationController.view.transform =CGAffineTransformMakeRotation(M_PI/2.0);
    [self orientationChange:YES];
}
- (void)orientationChange:(BOOL)landscapeRight
{
    CGFloat width = [UIScreen mainScreen].bounds.size.width;
    CGFloat height = [UIScreen mainScreen].bounds.size.height;
    if (landscapeRight) {
        [UIView animateWithDuration:0.2f animations:^{
            self.navigationController.view.transform = CGAffineTransformMakeRotation(M_PI_2);
            self.navigationController.view.bounds = CGRectMake(0, 0, width, height);
        }];
    } else {
        [UIView animateWithDuration:0.2f animations:^{
            self.navigationController.view.transform = CGAffineTransformMakeRotation(0);
            self.navigationController.view.bounds = CGRectMake(0, 0, width, height);
        }];
    }
}



// Implement viewDidLoad to do additional setup after loading the view, typically from a nib.
- (void)viewDidLoad {
    [super viewDidLoad];
    
//    portrait = [[PortraitView alloc] initWithFrame:CGRectMake(10, 10, 300, 440)];
//    portrait.backgroundColor = [UIColor yellowColor];
//    [portrait addButton];
//    
//    
//    landscape = [[LandscapeView alloc] initWithFrame:CGRectMake(10, 10, 460, 280)];
//    landscape.backgroundColor = [UIColor greenColor];
//    
//    [self.view addSubview:portrait];
//    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, 0.5), dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
//        
//    });
    
}
- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    [self changeOrientationMask];
}


- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(nullable id)sender
{
    
}

@end

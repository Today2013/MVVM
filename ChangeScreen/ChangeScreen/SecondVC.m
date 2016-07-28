//
//  SecondVC.m
//  ChangeScreen
//
//  Created by TomatoPeter on 16/7/28.
//  Copyright © 2016年 ChenJianglin. All rights reserved.
//

#import "SecondVC.h"
#import "NavigationController.h"
@interface SecondVC ()

@end

@implementation SecondVC
- (BOOL)shouldAutorotate
{
    return NO;
}
// Override to allow orientations other than the default portrait orientation.
//- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation {
//    // Return YES for supported orientations.
//    
//    return YES;
//    
//}
////此方法用于检测当前的屏幕的变化
//-(void)willAnimateRotationToInterfaceOrientation:(UIInterfaceOrientation)toInterfaceOrientation duration:(NSTimeInterval)duration
//{
//    if (UIInterfaceOrientationIsPortrait(toInterfaceOrientation)) {
//        //        [landscape removeFromSuperview];
//        //        [self.view addSubview:portrait];
//    }
//    if (UIInterfaceOrientationIsLandscape(toInterfaceOrientation)) {
//        //        [portrait removeFromSuperview];
//        //        [self.view addSubview:landscape];
//    }
//}
//- (void)viewWillTransitionToSize:(CGSize)size withTransitionCoordinator:(id<UIViewControllerTransitionCoordinator>)coordinator
//{
//    [super viewWillTransitionToSize:size withTransitionCoordinator:coordinator];
//    NSLog(@"%@", self.navigationController.visibleViewController);
//    [coordinator animateAlongsideTransition:^(id<UIViewControllerTransitionCoordinatorContext>  _Nonnull context) {
//        UIInterfaceOrientation orientation = [UIApplication sharedApplication].statusBarOrientation;
//        if (orientation == UIInterfaceOrientationPortrait) {
//            
//        }else{
//            
//        }
//        
//    } completion:^(id<UIViewControllerTransitionCoordinatorContext>  _Nonnull context) {
//        
//    }];
//    
//    
//}
//- (void)viewWillAppear:(BOOL)animated {
//    if ([UIDevice currentDevice].systemVersion.floatValue > 7.0) {
//        //orientation
//        [[UIApplication sharedApplication]
//         setStatusBarOrientation:UIInterfaceOrientationPortrait
//         animated:NO];
//        
//        [[UIDevice currentDevice]
//         setValue:[NSNumber
//                   numberWithInteger:UIInterfaceOrientationPortrait]
//         forKey:@"orientation"];
//    }
//}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    // Do any additional setup after loading the view.
//    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, 1), dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
////        NavigationController *navigationController = self.navigationController;
////        navigationController.orietation = UIInterfaceOrientationMaskPortrait;
//        
//    });
}
- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    [self changeOrientationMask];
}
- (void)changeOrientationMask
{
    [[UIApplication sharedApplication] setStatusBarOrientation:UIInterfaceOrientationPortrait animated:YES];
    
    CGFloat duration = [UIApplication sharedApplication].statusBarOrientationAnimationDuration;//（获取当前电池条动画改变的时间）
    [UIView beginAnimations:nil context:nil];
    [UIView setAnimationDuration:duration];
    
    //在这里设置view.transform需要匹配的旋转角度的大小就可以了。
    
    [UIView commitAnimations];
    
    self.navigationController.view.transform =CGAffineTransformMakeRotation(M_PI/2.0);
    [self orientationChange:NO];
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
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end

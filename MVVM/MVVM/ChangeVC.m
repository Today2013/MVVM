//
//  ChangeVC.m
//  MVVM
//
//  Created by TomatoPeter on 16/7/25.
//  Copyright © 2016年 ChenJianglin. All rights reserved.
//

#import "ChangeVC.h"
#import "ReactiveCocoa.h"
@interface ChangeVC ()

@end

@implementation ChangeVC
- (IBAction)passValue:(id)sender {
    if (self.delegateSignal) {
        [self.delegateSignal sendNext:@3];
    }
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
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

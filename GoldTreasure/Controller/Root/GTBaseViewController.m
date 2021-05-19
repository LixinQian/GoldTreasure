//
//  GTBaseViewController.m
//  GoldTreasure
//
//  Created by 王超 on 2017/6/28.
//  Copyright © 2017年 zhaofanjinrong.com. All rights reserved.
//

#import "GTBaseViewController.h"
#import "NSObject+GT.h"

@interface GTBaseViewController ()

@end

@implementation GTBaseViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.navBarAlpha = 1;
    self.view.backgroundColor = [UIColor whiteColor];
    // Do any additional setup after loading the view.
}

-(void)viewWillDisappear:(BOOL)animated
{
    [GTHUD dismiss];
}
-(void)returnBackAction
{
    [self.navigationController popViewControllerAnimated:YES];
}

// 设置navbar 是否时透明
- (void) transNav:(BOOL)isTrue {
    
    if (isTrue) {
        [self.navigationController.navigationBar setBackgroundImage:[UIImage new] forBarMetrics:UIBarMetricsDefault];
        [self hiddenNavBarShadow];
    } else {
        
        [self.navigationController.navigationBar setBackgroundImage:[UIImage initWithColor:[UIColor whiteColor]] forBarMetrics:UIBarMetricsDefault];
        [self showNavNarShadow];
    }
    
}



- (void) hiddenNavBarShadow {
    
//
    UIImageView *lineView = [self findHairlineImageViewUnder:self.navigationController.navigationBar];
    lineView.hidden = true;
}
- (void) showNavNarShadow {
//    [self.navigationController.navigationBar setBackgroundImage:[UIImage new] forBarMetrics:UIBarMetricsDefault];
    UIImageView *lineView = [self findHairlineImageViewUnder:self.navigationController.navigationBar];
    lineView.hidden = false;
}

@end

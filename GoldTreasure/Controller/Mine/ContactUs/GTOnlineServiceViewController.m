//
//  GTOnlineServiceViewController.m
//  GoldTreasure
//
//  Created by wangyaxu on 30/06/2017.
//  Copyright © 2017 zhaofanjinrong.com. All rights reserved.
//

#import "GTOnlineServiceViewController.h"
#import <IQKeyboardManager/IQKeyboardManager.h>
#import <Masonry/Masonry.h>

@interface GTOnlineServiceViewController ()

@end

@implementation GTOnlineServiceViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    // 屏蔽IQ键盘
//    [[IQKeyboardManager sharedManager] setEnable:false];
    self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc]initWithCustomView:[ReturnBack buttonWithType:UIButtonTypeCustom ReturnBackStyle:ReturnBackStyleBlack Target:self Action:@selector(returnBackAction)]];
    self.navigationItem.title = @"在线客服";
    self.view.backgroundColor = [GTColor gtColorC3];
    
    [self setupInterface];

}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark    -   set up interface    -

- (void)setupInterface
{

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

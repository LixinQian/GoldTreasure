//
//  GTRootUINavigationController.m
//  GoldTreasure
//
//  Created by ZZN on 2017/7/1.
//  Copyright © 2017年 zhaofanjinrong.com. All rights reserved.
//

#import "GTRootUINavigationController.h"

@interface GTRootUINavigationController()

@end

@implementation GTRootUINavigationController


- (void)viewDidLoad {
    
    [super viewDidLoad];
//    self.useSystemBackBarButtonItem = true;
//    self.transferNavigationBarAttributes = true;

}

// 设置 统一样式
-(UIBarButtonItem *)barLeft {
//    if (!_barLeft) {
        _barLeft = [[UIBarButtonItem alloc] initWithImage:[UIImage imageNamed:@"back"] style:UIBarButtonItemStyleDone target:self action:@selector(pop)];
//    }
    return _barLeft;
}

// pop 控制器
- (void) pop {
    
    [self popViewControllerAnimated:true];
}
// 添加bar 样式
-(void)pushViewController:(UIViewController *)viewController animated:(BOOL)animated {
    
    if (self.childViewControllers.count > 0) {
        
        viewController.navigationItem.leftBarButtonItem = self.barLeft;
    }
    [super pushViewController:viewController animated:true];
}

@end

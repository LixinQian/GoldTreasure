////
////  BaseTabBarViewController.m
////  GoldTreasure
////
////  Created by 王超 on 2017/6/23.
////  Copyright © 2017年 王超. All rights reserved.
////
//
//#import "BaseTabBarViewController.h"
//#import "GTHomePageController.h"
//#import "GTMineViewController.h"
//#import "GTRootUINavigationController.h"
//
//@interface BaseTabBarViewController ()
//
//@end
//static BaseTabBarViewController *instance = nil;
//@implementation BaseTabBarViewController
//
//+ (BaseTabBarViewController *)shareInstance
//{
//    static dispatch_once_t onceToken;
//    dispatch_once(&onceToken, ^{
//        instance = [[BaseTabBarViewController alloc] init];
//        
////        [[UITabBar appearance] setTranslucent:NO];
//        [[UITabBar appearance]setTintColor:[GTColor gtColorC4]];
//        [instance setController];
//        
//    });
//    return instance;
//}
//
//- (void)viewDidLoad {
//    [super viewDidLoad];
//    // Do any additional setup after loading the view.
//}
//
//-(BaseTabBarViewController *)setController
//{
//    
//    NSArray *listTitle = @[@"首页"@"我的"];
//    NSArray *listSelImgName = @[@"hone_n"@"my_n"];
//    NSArray *listNorImgName = @[@"home_s"@"my_s"];
//    
//    for (int i = 0; i < listTitle.count; i++) {
//        
//    }
//    
//    UIImage * normalImage1 = [[UIImage imageNamed:@"hone_n"] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
//    UIImage * selectImage1 = [[UIImage imageNamed:@"home_s"] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
//    GTHomePageController *home = [[GTHomePageController alloc] init];
//    
//    GTRootUINavigationController *nav1 = [[GTRootUINavigationController alloc]initWithRootViewController:home];
//    nav1.tabBarItem = [[UITabBarItem alloc]initWithTitle:@"首页" image:normalImage1 selectedImage:selectImage1];
//
////    [nav4.tabBarItem setImageInsets:UIEdgeInsetsMake(5, 0, -5, 0)];
//    
//    UIImage * normalImage2 = [[UIImage imageNamed:@"my_n"] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
//    UIImage * selectImage2 = [[UIImage imageNamed:@"my_s"] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
//    GTMineViewController *mine = [[GTMineViewController alloc] init];
//    
//    GTRootUINavigationController *nav2 = [[GTRootUINavigationController alloc]initWithRootViewController:mine];
//    nav2.tabBarItem = [[UITabBarItem alloc]initWithTitle:@"我的" image:normalImage2 selectedImage:selectImage2];
////    [nav5.tabBarItem setImageInsets:UIEdgeInsetsMake(5, 0, -5, 0)];
//    
//    self.viewControllers = @[nav1,nav2];
//    
//    return self;
//}
//
//@end

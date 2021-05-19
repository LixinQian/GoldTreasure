//
//  GTHomePageController1.m
//  GoldTreasure
//
//  Created by ZZN on 2017/7/5.
//  Copyright © 2017年 zhaofanjinrong.com. All rights reserved.
//
#import "GTBaseViewController.h"
#import "GTHomePageController.h"
#import "RightButton.h"
#import "HomePageHeadView.h"
#import "OrderModel.h"
#import "GTFlexSliderCell.h"
#import "GTNormalCell.h"
#import "GTLoanOrderViewController.h"
#import "PaybackViewController.h"
#import "GTNotificationController.h"
#import "GTLoginController.h"
#import <MJRefresh/MJRefresh.h>
#import "GTContactsController.h"
#import <Masonry/Masonry.h>
#import "GTAuthCenterViewController.h"
#import "GTAmountController.h"
#import "UIBarButtonItem+GT.h"
#import "GTVerification.h"


#import "GeTuiSdk.h"

@class HomePageHeadView;

@interface GTHomePageController ()<UITableViewDelegate,UITableViewDataSource>

@property (nonatomic, strong) UITableView *tableView;
@property (nonatomic, strong) HomePageHeadView *headView;
@property (nonatomic, strong) NSArray *bannerUrlList; //banner图 数组
@property (nonatomic, strong) NSArray *defaultParamsList;
@property (nonatomic, assign) CGFloat barAlpha;



//@property (nonatomic, strong) NSArray *defaultImgList;
@end

@implementation GTHomePageController

-(UITableView *)tableView {
    
    if (!_tableView) {
        
        _tableView = [[UITableView alloc]initWithFrame:self.view.frame style:UITableViewStylePlain];
        _tableView.translatesAutoresizingMaskIntoConstraints = false;
        _tableView.delegate = self;
        _tableView.contentInset = UIEdgeInsetsMake(0, 0, 49, 0);
        _tableView.dataSource = self;
        _tableView.showsVerticalScrollIndicator = false;
        _tableView.backgroundColor = [GTColor gtColorC3];
        _tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    }
    
    return _tableView;
}

- (void)viewDidLoad {
    
    [super viewDidLoad];
    [self initData];
    [self initUI];
    [self initHandle];
}


- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    [UIApplication sharedApplication].statusBarStyle = UIStatusBarStyleLightContent;
    _headView.model = [GTUser.manger userInfoModel];
    self.navBarAlpha = _barAlpha;
    [self initNet];
}

- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
    [UIApplication sharedApplication].statusBarStyle = UIStatusBarStyleLightContent;
}

- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
    [UIApplication sharedApplication].statusBarStyle = UIStatusBarStyleDefault;
    self.navBarAlpha = 1;
    self.navigationController.navigationBar.alpha = 1;
//    self.navBarTintColor = [UIColor whiteColor];
}

- (void) initData {
    
    _barAlpha = 0;
}
// 初始化 UI
- (void) initUI {
    
    [self setNav];
    
    _bannerUrlList = [NSMutableArray array];//arrayWithObjects:@"tu",@"tu2",@"tu3", nil];
    _defaultParamsList = @[@{@"img":@"icon-apply",@"mTitle":@"APP申请，大数据授信",@"desc":@"无需繁琐流程，动动手指就能借款",
                             @"img1":@"icon-review",@"mTitle1":@"极速审核，当天到账",@"desc1":@"10分钟审核，3小时内到账"
                          }];
    self.view.backgroundColor = [GTColor gtColorC3];
    
    self.automaticallyAdjustsScrollViewInsets = false;
    _tableView.translatesAutoresizingMaskIntoConstraints = false;
    _headView = [[HomePageHeadView alloc]initWithFrame:CGRectMake(0, 0, ScreenWidth, 430)];
    self.tableView.tableHeaderView = _headView;
    
    
    [_tableView registerClass:[GTFlexSliderCell class] forCellReuseIdentifier:GTFlexSliderCell.description];
    [_tableView registerClass:[GTNormalCell class] forCellReuseIdentifier:GTNormalCell.description];
    //[MJRefreshNormalHeader headerWithRefreshingTarget:self refreshingAction:@selector(loadNewData)];
    
    [self.view addSubview:_tableView];
}

// 导航栏设置
- (void) setNav {
    self.automaticallyAdjustsScrollViewInsets = NO;
    self.navigationController.navigationBar.translucent = YES;

    //
    UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
    [button setImage:[UIImage imageNamed:@"message"] forState:UIControlStateNormal];
    button.frame = CGRectMake(0,100,button.currentImage.size.width, button.currentImage.size.height);
    [button addTarget:self action:@selector(actionRightBar) forControlEvents:UIControlEventTouchDown];
    // 添加角标
    UIBarButtonItem *navLeftButton = [[UIBarButtonItem alloc] initWithCustomView:button];
    self.navigationItem.rightBarButtonItem = navLeftButton;
    self.navigationItem.rightBarButtonItem.badgeBGColor = [UIColor redColor];
    self.navigationItem.titleView = [[UIImageView alloc]initWithImage:[UIImage imageNamed:@"logoword"]];
    
    [self.navigationController.navigationBar setValue:@(0) forKeyPath:@"backgroundView.alpha"];
}

// 刷新tableview
- (void) reloadTable {
    WEAKSELF
    [[NSOperationQueue mainQueue] addOperationWithBlock:^{
        
        [weakSelf.tableView reloadData];
    }];
}
// 网络请求
- (void)initNet {
    
    WEAKSELF
    [GTUser.manger reloadUserInfoWithSucc:^(GTResModelUserInfo * _Nonnull model) {
        weakSelf.headView.model = model;
        
        [weakSelf.tableView.mj_header endRefreshing];
    } fail:^(GTNetError * _Nullable error) {
        
        [weakSelf.tableView.mj_header endRefreshing];
    }];
    
    // 请求banner 图
    [[GTCommonService manger] requestBannerImgList:^(NSArray<GTDBCommonModel *> * _Nonnull listModel) {
        
        
        NSMutableArray *urList = [NSMutableArray array];
        for (GTDBCommonModel *model in listModel) {
            NSString *url = model.coverImg;
            [urList addObject:url];
        }
        weakSelf.bannerUrlList = urList;
        [weakSelf reloadTable];
        GTLog(@"banner 图 \n%@",listModel);
    }];
    
    
    
    // 设置角标
    self.navigationItem.rightBarButtonItem.badgeValue =  ([GTUser getAppHasNoReadNoti] == true) ? @" ":@"";
}



// 执行处理操作
- (void) initHandle {
    
    WEAKSELF
    // 借款订单
    _headView.orderBlock = ^{
        
        if (!GTUser.isLogin) {
            [GTUser.manger loginInSucc:nil fail:nil];
            return;
        }
        
        GTLoanOrderViewController *loanVC = [[GTLoanOrderViewController alloc] init];
        loanVC.hidesBottomBarWhenPushed = YES;
//        [weakSelf.navigationController pushViewController:loanVC animated:YES];
        [weakSelf pushController:loanVC];
    };
    
    // 借款
    _headView.borrowBlock = ^{
        
        if (!GTUser.isLogin) {
            [GTUser.manger loginInSucc:nil fail:nil];
            return;
        }
        if ([[GTUser.manger.userInfoModel isBlack] intValue] == 1) {
            [GTHUD showToastWithInfo:@"抱歉，您当前已限制从本平台中贷款！"];
            return;
        }
        if ([GTUser.manger.userInfoModel.status integerValue] != 2) {
            
            [GTHUD showAlertWithContent:@"全部认证通过后才可以借款"  trueTitle:@"去认证" cancelTitle:@"取消"  trueCol:^{
                GTAuthCenterViewController *authCenterVC = [GTAuthCenterViewController new];
                authCenterVC.hidesBottomBarWhenPushed = YES;
                [weakSelf.navigationController pushViewController:authCenterVC animated:YES];
                
            } cancelCol:nil];
            return;
        }
        
        if ([[GTUser.manger.userInfoModel authedCredit] integerValue] - [[GTUser.manger.userInfoModel usedCredit] integerValue] <= 0) {
            
            
            [GTHUD showAlertWithContent:@"您当前额度已用完，请先还款恢复额度之后再借款"  trueTitle:@"去还款" cancelTitle:@"取消"  trueCol:^{
                PaybackViewController *payback = [[PaybackViewController alloc] init];
                payback.hidesBottomBarWhenPushed = YES;
                [weakSelf.navigationController pushViewController:payback animated:YES];
                
            } cancelCol:nil];
            
            return;
        }
        
        // 紧急联系人，0未上传，1已上传
        if ([GTUser.manger.userInfoModel.hasElinkman integerValue] == 0) {
            
            GTContactsController *contcat = [[GTContactsController alloc]init];
            contcat.hidesBottomBarWhenPushed = YES;
//            [weakSelf.navigationController pushViewController:contcat animated:YES];
            [weakSelf pushController:contcat];
            return;
        }
        else if ([GTUser.manger.userInfoModel.hasElinkman integerValue] == 1)
        {
            GTAmountController *amount = [[GTAmountController alloc]init];
            amount.hidesBottomBarWhenPushed = YES;
            
            [weakSelf pushController:amount];
//            [weakSelf.navigationController pushViewController:amount animated:YES];
            return;
        }
        
    };
    
//    // 还款
//    _headView.repaymentBlock = ^{
//        
//        if (!GTUser.isLogin) {
//            [GTUser.manger loginInSucc:nil fail:nil];
//            return;
//        }
//        
//        PaybackViewController *payback = [[PaybackViewController alloc] init];
//        payback.hidesBottomBarWhenPushed = YES;
////        [weakSelf.navigationController pushViewController:payback animated:YES];
//        [weakSelf pushController:payback];
//    };
    // 监听通知
    [GTNoti listenNotiChangeWithBlock:^{
        weakSelf.navigationItem.rightBarButtonItem.badgeValue = ([GTUser getAppHasNoReadNoti] == true) ? @" ":@"";
    }];
    // 监听个人信息改变
    [GTUser.manger listenUserInfoChangedWithChanged:^(GTResModelUserInfo * _Nonnull userInfo) {
        weakSelf.headView.model = userInfo;
    }];
    
    //    // 刷新操作
    //    _tableView.mj_header = [[GTRefreshView sharedInstance] headerWithClosure:^{
    //
    //        [_tableView.mj_header endRefreshing];
    ////        [[GTUser manger] reloadUserInfoWithSucc:^(GTResModelUserInfo * _Nonnull model) {
    ////
    ////            weakSelf.headView.model = model;
    ////            [weakSelf.tableView.mj_header endRefreshing];
    ////        } fail:^(GTNetError * _Nullable error) {
    ////            [weakSelf.tableView.mj_header endRefreshing];
    ////        }];
    //
    //
    //        //net
    //        [weakSelf initNet];
    //
    //    }];
    
}

// 点击通知按钮 通知
-(void) actionRightBar {
    
    if (!GTUser.isLogin) {
        [GTUser.manger loginInSucc:nil fail:nil];
        return;
    }
    
    [self.navigationItem.rightBarButtonItem setBadgeValue:@""];
    [GeTuiSdk resetBadge];
    
    // 暂时只显示 有无新通知
    [GTUser setAppHasNoReadNotiWithIsFrist:false];
    
    GTNotificationController *noti = [[GTNotificationController alloc]init];
    noti.hidesBottomBarWhenPushed = YES;
//    [self.navigationController pushViewController:noti animated:YES];
    [self pushController:noti];
    
}

#pragma UITableView代理方法

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return 2;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.row == 0) {
        return 120;
    }
    return 236;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    
    if (indexPath.row == 0) {
        
        GTFlexSliderCell *cell = [tableView dequeueReusableCellWithIdentifier:[GTFlexSliderCell description]];
        cell.bannerDataArr = _bannerUrlList;
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        cell.myBlock = ^(NSInteger index) {
            GTLog(@"轮播图%ld",index);
        };
        
        return cell;
    }
    else {
        
        GTNormalCell *cell = [tableView dequeueReusableCellWithIdentifier:[GTNormalCell description]];
        cell.params = _defaultParamsList[indexPath.row - 1];
//        cell.line.hidden = _defaultParamsList.count == indexPath.row ? true:false;
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        return cell;
    }
}

// tableView scroll
-(void)scrollViewDidScroll:(UIScrollView *)scrollView {
    
////    //  设置navbar颜色
//    CGFloat insetY = fabs(scrollView.contentOffset.y);
////    _barAlpha = insetY > 64 ? 1 : insetY/64;
////    self.navBarAlpha = _barAlpha;
//    
//    if (insetY >64) {
//        [UIView animateWithDuration:0.2 animations:^{
//            self.navBarAlpha = 0;
//        }];
//    }else {
//        [UIView animateWithDuration:0.2 animations:^{
//           self.navBarAlpha = 1;
//        }];
//    }
//
    
    CGFloat alpha = 1.0 - ABS(scrollView.contentOffset.y / 64);
    if (alpha < 0.8) {
        [[[self navigationController] navigationBar] setTitleTextAttributes:@{
                                                                              NSForegroundColorAttributeName : [[UIColor whiteColor] colorWithAlphaComponent:alpha]
                                                                              }];
        self.navigationItem.titleView.hidden = YES;
        
    }else {
        [[[self navigationController] navigationBar] setTitleTextAttributes:@{
                                                                              NSForegroundColorAttributeName : [[UIColor blackColor] colorWithAlphaComponent:1]
                                                                              }];
        self.navigationItem.titleView.hidden = NO;
    }
    
}

//- (UIStatusBarStyle)preferredStatusBarStyle {
//    if (self.navigationController.navigationBar.alpha == 0) {
//
//        return UIStatusBarStyleLightContent;
//    } else {
//        return UIStatusBarStyleDefault;
//    }
//}

//    NSLog(@"%f,%f",insetY/64,alpha);

//    for (UINavigationItem *item in self.navigationController.navigationBar.items ) {
//
//        item.titleView.alpha = 0;
//    }
//    self.navigationController.interactivePopGestureRecognizer

//    unsigned int count = 0;
//    //获取类的一个包含所有变量的列表，IVar是runtime声明的一个宏，是实例变量的意思.
//    UINavigationBar *bar = self.navigationController.navigationBar;
//    objc_property_t *pro = class_copyPropertyList([bar class], &count);
//
//    for (int i = 0; i<count; i++) {
//        property_getName(pro[i]);
//    }
//
//    Ivar *allVariables = class_copyIvarList([bar class], &count);
//    for(int i = 0;i<count;i++)
//    {
//        //遍历每一个变量，包括名称和类型（此处没有星号"*"）
//        Ivar ivar = allVariables[i];
//
////        id obj = object_getIvar(bar, ivar);
//
////        NSLog(@"%@",obj);
//        const char *Variablename = ivar_getName(ivar); //获取成员变量名称
//        const char *VariableType = ivar_getTypeEncoding(ivar); //获取成员变量类型
////        NSLog(@"(Name: %s) ----- (Type:%s)",Variablename,VariableType);
//    }


//    [self.navigationController.navigationBar setValue:0.11 forKey:@"_titleView"];
//    if (insetY > 44) {
//        [UIView animateWithDuration:1 animations:^{
//
//            self.navigationController.navigationBar.hidden = true;
//        }];
//    } else if (insetY < -44) {
//
//        [UIView animateWithDuration:1 animations:^{
//
//            self.navigationController.navigationBar.hidden = true;
//        }];
//    } else {
//
//        self.navigationController.navigationBar.hidden = false;
//    }
//}
//-(void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView {
//
//    GTLog(@"%f,%f",scrollView.contentOffset.x,scrollView.contentOffset.y)
//}


/**
 *  自定义Nav
 *
 *  @return UIView
 */
//-(UIImageView *)NavigationBa
//{
//    view_bar =[[UIImageView alloc]init];
//    view_bar.userInteractionEnabled = YES;
//    if ([[[UIDevice currentDevice]systemVersion]floatValue]>6.1)
//    {
//        view_bar .frame=CGRectMake(0, 0, self.view.frame.size.width, 44+20);
//
//    }else{
//        view_bar .frame=CGRectMake(0, 0, self.view.frame.size.width, 44);
//    }
//    view_bar.backgroundColor=[GTColor gtColorC1];
////    view_bar.alpha = 1;
//    [self.view addSubview: view_bar];
//
//    UILabel *title_label=[[UILabel alloc]initWithFrame:CGRectMake(65, view_bar.frame.size.height-44, self.view.frame.size.width-130, 44)];
//    title_label.text=@"贷款";
//    title_label.font=[UIFont systemFontOfSize:20];
////    title_label.backgroundColor=[UIColor clearColor];
////    title_label.textColor =NavigationTitleTextColor;
//    title_label.textAlignment=1;
//    [view_bar addSubview:title_label];
//
//    UIButton * messageBtn=[[UIButton alloc] initWithFrame:CGRectMake(ScreenWidth-40, view_bar.frame.size.height-40, 30, 30)];
//    [messageBtn setImage:[UIImage imageNamed:@"message"] forState:UIControlStateNormal];
//    [view_bar addSubview:messageBtn];
//    [messageBtn addTarget:self action:@selector(notiAction) forControlEvents:UIControlEventTouchUpInside];
//
//    return view_bar;
//}

//-(void)scrollViewDidScroll:(UIScrollView *)scrollView{

//    if (self.tableView.contentOffset.y<-20) {
//        [view_bar setHidden:YES];
//    }else
//    {
//        if (self.tableView.mj_header.state == MJRefreshStateRefreshing) {
//            [view_bar setHidden:YES];
//        }else
//        {
//            dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.5 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
//
//                [view_bar setHidden:NO];
//            });
////            [view_bar setHidden:NO];
//        }
//    }
/*
 if(self.tableView.contentOffset.y<-30) {
 [view_bar setHidden:YES];
 
 }else if(self.tableView.contentOffset.y<44){
 [view_bar setHidden:NO];
 //view_bar.backgroundColor=[UIColor colorWithRed:0.9 green:0 blue:0 alpha:self.cv.contentOffset.y / 1000];
 //        view_bar.alpha = self.tableView.contentOffset.y / 44;
 //        view_bar.image = [UIImage imageNamed:@"topback"];
 view_bar.backgroundColor = [GTColor gtColorC1];
 
 }else
 {
 [view_bar setHidden:NO];
 //        view_bar.image = [UIImage imageNamed:@"topback"];
 //        view_bar.alpha = 1;
 
 view_bar.backgroundColor=[GTColor gtColorC1];
 }
 */
//}
//- (void)didReceiveMemoryWarning {
//    [super didReceiveMemoryWarning];
//    // Dispose of any resources that can be recreated.
//}

/*
 #pragma mark - Navigation
 
 // In a storyboard-based application, you will often want to do a little preparation before navigation
 - (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
 // Get the new view controller using [segue destinationViewController].
 // Pass the selected object to the new view controller.
 }
 */

// tableviewcell
//    if (indexPath.row == 0) {
//
//        static NSString *indentifier = @"cell1";
//        GTFlexSliderCell *cell = [tableView dequeueReusableCellWithIdentifier:indentifier];
//        if (cell == nil) {
//            cell = [[GTFlexSliderCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:indentifier];
//            cell.selectionStyle = UITableViewCellSelectionStyleNone;
//        }
//        cell.bannerDataArr = self.bannerUrlList;
//        [cell reSetArr];
//        cell.myBlock = ^(NSInteger index) {
//            NSLog(@"%ld",index);
//        };
//        return cell;
//    }
//    static NSString *indentifier = @"cell2";
//    GTNormalCell *cell = [tableView dequeueReusableCellWithIdentifier:indentifier];
//
//    if (cell == nil) {
//        cell = [[GTNormalCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:indentifier];
//        cell.selectionStyle = UITableViewCellSelectionStyleNone;
//    }

//        cell.icon.image = [UIImage imageNamed:@"review"];
//        cell.mTitle.text = @"极速审核，当天到账";
//        cell.details.text = @"10分钟审核，3小时内到账。";
//        cell.icon.image = [UIImage imageNamed:@"apply"];
//        cell.mTitle.text = @"APP申请，大数据授信";
//        cell.details.text = @"无需繁琐流程，动动手指就能借款";
@end

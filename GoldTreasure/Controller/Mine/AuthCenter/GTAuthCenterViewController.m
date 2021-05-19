//
//  GTAuthCenterViewController.m
//  GoldTreasure
//
//  Created by wangyaxu on 28/06/2017.
//  Copyright © 2017 zhaofanjinrong.com. All rights reserved.
//

#import "GTAuthCenterViewController.h"
#import "GTAuthInfoModel.h"
#import "GTAuthenticateService.h"
#import "GTAuthCenterHeaderView.h"
#import "GTAuthCenterCollectionViewCell.h"
#import "GTIDCardAuthViewController.h"
#import "GTBankCardAuthViewController.h"
#import "GTUploadAddressBookViewController.h"
#import "GTPhoneAuthViewController.h"
#import "GTAlipayAuthViewController.h"
#import "GTSystemAuth.h"

#import <Masonry/Masonry.h>

@interface GTAuthCenterViewController ()<UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout, CLLocationManagerDelegate, AuthStatusRefreshProtocol>

@property (nonatomic, strong) GTAuthCenterHeaderView *headerView;
@property (nonatomic, strong) UICollectionView *functionsCollectionView;
@property (nonatomic, strong) GTAuthInfoModel *authInfoModel;
@property (nonatomic, assign) BOOL contactsUploaded;
@property (nonatomic, assign) BOOL isPhoneAuthing;
@property (nonatomic, copy) NSString *orderId;

@property (nonatomic, strong) CLLocation *location;
@property (nonatomic, strong) CLLocationManager *locationManager;
@property (nonatomic, assign) CLAuthorizationStatus locationStatus;

@end

@implementation GTAuthCenterViewController

- (instancetype)init
{
    self = [super init];
    if (self) {
        self.hidesBottomBarWhenPushed = YES;
    }
    return self;
}

//取消导航栏分割线
//-(void)setNavigationBarShadowImage
//{
//    [self.navigationController.navigationBar setBackgroundImage:[UIImage new] forBarMetrics:UIBarMetricsDefault];
//    [self.navigationController.navigationBar setShadowImage:[UIImage new]];
//}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    self.navigationController.navigationBar.translucent = YES;
//    [self setNavigationBarShadowImage];
    UILabel *lab = [[UILabel alloc]init];
    lab.text = @"认证中心";
    [lab sizeToFit];
    lab.textColor = [GTColor gtColorC2];
    lab.backgroundColor = [UIColor clearColor];
    self.navigationItem.titleView = lab;
    self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc]initWithCustomView:[ReturnBack buttonWithType:UIButtonTypeCustom ReturnBackStyle:ReturnBackStyleArrowWhite Target:self Action:@selector(returnBackAction)]];
    self.view.backgroundColor = [GTColor gtColorC3];
    self.navBarTintColor = [GTColor gtColorC2];
    [self setupInterface];
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    [UIApplication sharedApplication].statusBarStyle = UIStatusBarStyleLightContent;
    self.navBarAlpha = 0;
}

- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    [UIApplication sharedApplication].statusBarStyle = UIStatusBarStyleLightContent;
    [self interactivePopGesture:false];
    
    if (self.childViewControllers.count > 0) {
        for (int i = 0; i < self.childViewControllers.count; i ++) {
            if ([self.childViewControllers[i] isKindOfClass:[GTPhoneAuthViewController class]]) {
                [self.childViewControllers[i].view removeFromSuperview];
                [self.childViewControllers[i] removeFromParentViewController];
            }
        }
    } else {
        [self requestNetwork];
    }
}

-(void)viewWillDisappear:(BOOL)animated {
    // 屏蔽 父类 操作
    self.navBarAlpha = 1;
    [self interactivePopGesture:true];
    [UIApplication sharedApplication].statusBarStyle = UIStatusBarStyleDefault;
}

#pragma mark    -   set up interface    -

- (void)setupInterface
{
    GTAuthCenterHeaderView *headerView = [GTAuthCenterHeaderView new];
    [self.view addSubview:headerView];
    self.headerView = headerView;
    
    {
        [self.headerView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.right.top.equalTo(self.view);
            make.height.equalTo(@185);
        }];
    }
    
    UICollectionViewFlowLayout *flowLayout = [UICollectionViewFlowLayout new];
    flowLayout.minimumLineSpacing = 0;
    flowLayout.minimumInteritemSpacing = 0;
    flowLayout.itemSize = CGSizeMake(CGRectGetWidth(self.view.bounds) / 2, 132);
    
    UICollectionView *functionsCollectionView = [[UICollectionView alloc] initWithFrame:CGRectZero collectionViewLayout:flowLayout];
    [self.view addSubview:functionsCollectionView];
    functionsCollectionView.scrollEnabled = NO;
    functionsCollectionView.backgroundColor = [UIColor whiteColor];
    functionsCollectionView.contentInset = UIEdgeInsetsMake(40, 0, 0, 0);
    functionsCollectionView.delegate = self;
    functionsCollectionView.dataSource = self;
    self.functionsCollectionView = functionsCollectionView;
    {
        [self.functionsCollectionView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.height.equalTo(@304);
            make.left.right.equalTo(self.view);
            make.top.equalTo(self.headerView.mas_bottom).with.offset(15);
        }];
    }
    
    [self.functionsCollectionView registerClass:[GTAuthCenterCollectionViewCell class] forCellWithReuseIdentifier:@"GTAuthCenterCollectionViewCell"];
}

#pragma mark    -   network request -

- (void)requestNetwork
{
    //若存在子视图控制器（idcard，addressbook，phone），则说明未完成授权过程，不再请求授权状态
    NSMutableDictionary *dict = [NSMutableDictionary dictionary];
    if (GTAuthenticateService.sharedInstance.bizNo) {
        //@"bizNo" : GTAuthenticateService.sharedInstance.bizNo
        dict[@"bizNo"] = GTAuthenticateService.sharedInstance.bizNo;
        if (GTAuthenticateService.sharedInstance.taskId) {
            //运营商认证成功，update
            dict[@"taskId"] = GTAuthenticateService.sharedInstance.taskId;
            dict[@"operate"] = @"update";
        } else {
            //取消认证操作，取消订单
            //其他，drop
            dict[@"operate"] = @"drop";
        }
    } else {
        dict[@"operate"] = @"select";
    }
    WEAKSELF
    [GTAuthenticateService.sharedInstance cancelAuthOrderWithDict:dict succ:^(id resModel) {
        GTAuthenticateService.sharedInstance.bizNo = nil;
        GTAuthenticateService.sharedInstance.taskId = nil;
        GTLog(@"认证订单已取消！！！")
        dispatch_async(dispatch_get_main_queue(), ^{
            weakSelf.authInfoModel = resModel;
            [weakSelf.functionsCollectionView reloadData];
            [weakSelf.headerView setAuthedCount:weakSelf.authInfoModel.authSuccessCount];
            if ([weakSelf.authInfoModel authSuccessCount] == 1 || [weakSelf.authInfoModel authSuccessCount] == 4) {
                //授权状态更新的同时刷新个人数据信息(仅在实名认证和支付宝认证后更新)
                [GTUser.manger reloadUserInfoWithSucc:nil fail:nil];
            }
        });
    } fail:^(GTNetError *error) {
        [GTHUD showToastWithText:error.msg];
    }];
    
}

#pragma mark    -   collectionView methods  -

- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView
{
    return 1;
}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
    NSArray *configArray = [self authFunctionsConfigArray];
    return configArray.count;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    GTAuthCenterCollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"GTAuthCenterCollectionViewCell" forIndexPath:indexPath];
    NSArray *configArray = [self authFunctionsConfigArray];
    [self config:cell atIndexPath:indexPath withContent:configArray];
    return cell;
}

- (void)config:(GTAuthCenterCollectionViewCell *)cell atIndexPath:(NSIndexPath *)indexPath withContent:(NSArray *)content
{
    NSDictionary *item = content[indexPath.row];
    [cell setIconWithImageName:item[@"icon"]];
    [cell setTitle:item[@"mTitle"]];
    
    switch (indexPath.row) {
        case 0:
            [cell setAuthState:self.authInfoModel.certStatus];
            break;
        case 1:
            [cell setAuthState:self.authInfoModel.cardStatus];
            break;
        case 2:
            [cell setAuthState:self.authInfoModel.carrierStatus];
            break;
        case 3:
            [cell setAuthState:self.authInfoModel.zfbStatus];
            break;
            
        default:
            break;
    }
}

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath
{
    if (!self.authInfoModel) {
        return;
    }
    switch (indexPath.row) {
        case 0:
            [self gotoIDAuthorization];
            break;
        case 1:
            [self gotoBankcardAuthorization];
            break;
        case 2:
            [self gotoPhoneAuthorization];
            break;
        case 3:
            [self gotoAlipayAuthorization];
            break;
            
        default:
            break;
    }
}

#pragma mark    -   location delegate   -

- (void)locationManager:(CLLocationManager *)manager didUpdateLocations:(NSArray<CLLocation *> *)locations
{
    if (!self.location) {
        self.location = locations.firstObject;
        GTLog(@"%@", self.location);
        // 上传用户位置信息
        [self.locationManager stopUpdatingLocation];
        [self postUserLocation];
    }
}

- (void)locationManager:(CLLocationManager *)manager didChangeAuthorizationStatus:(CLAuthorizationStatus)status
{
    if (status == kCLAuthorizationStatusAuthorizedWhenInUse && self.locationStatus != status) {
        //已获取位置授权，且授权信息有所改变
        [self gotoIDAuthorization];
    } else if (status == kCLAuthorizationStatusDenied) {
        //未获得位置授权
    }
}

#pragma mark    -   other methods   -

//实名认证
- (void)gotoIDAuthorization
{
    __block GTIDCardAuthViewController *idCardAuth = [[GTIDCardAuthViewController alloc] initWithUserAuth:self.authInfoModel.certStatus userSelf:NO];
    idCardAuth.delegate = self;
    WEAKSELF
    if (self.authInfoModel.certStatus == GTAuthStatusLack) {
        //需要个人认证，此处需要先定位！！
        self.locationStatus = [CLLocationManager authorizationStatus];
        [GTSystemAuth showAlertWithAuthType:GTSystemAuthTypeLocation completionHandler:^(GTSystemAuthStatus status) {
            if (status == GTSystemAuthStatusNotDetermined) {
                
                [weakSelf.locationManager requestWhenInUseAuthorization];
            } else if (status == GTSystemAuthStatusAuthorized) {
                
                [GTSystemAuth showAlertWithAuthType:GTSystemAuthTypeCamera completionHandler:^(GTSystemAuthStatus status) {
                    if (status == GTSystemAuthStatusAuthorized) {
                        
                        if ([CLLocationManager locationServicesEnabled] && !self.location) {
                            [weakSelf.locationManager startUpdatingLocation];
                            [GTHUD showStatusWithTitle:nil];
                        }
                        
                        if (weakSelf.orderId) {
                            dispatch_async(dispatch_get_main_queue(), ^{
                                //只有上传位置后才可以进行个人认证
                                //订单号
                                [idCardAuth setOrderId:weakSelf.orderId];
                                [weakSelf addChildViewController:idCardAuth];
                                idCardAuth.view.backgroundColor = [UIColor clearColor];
                                [weakSelf.view addSubview:idCardAuth.view];
                                [idCardAuth didMoveToParentViewController:self];
                                weakSelf.orderId = nil;
                            });
                        }
                    }
                }];
            }
        }];
    } else {
        [self.navigationController pushViewController:idCardAuth animated:YES];
    }
}

//银行卡认证
- (void)gotoBankcardAuthorization
{
    [self userInfoAuthDetect];
    GTBankCardAuthViewController *bankCardAuth = [[GTBankCardAuthViewController alloc] initWithBankCardAuth:self.authInfoModel.cardStatus];
    [self.navigationController pushViewController:bankCardAuth animated:YES];
}

//运营商认证
- (void)gotoPhoneAuthorization
{
    if (![self userInfoAuthDetect]) {
        return;
    }

    __block GTPhoneAuthViewController *phoneAuth = [[GTPhoneAuthViewController alloc] initWithCarrierAuth:self.authInfoModel.carrierStatus];
    phoneAuth.delegate = self;
    if (self.authInfoModel.carrierStatus == GTAuthStatusLack) {
        if (self.contactsUploaded == NO) {
            WEAKSELF
            [GTSystemAuth showAlertWithAuthType:GTSystemAuthTypeContacts completionHandler:^(GTSystemAuthStatus status) {
                if (status == GTSystemAuthStatusAuthorized) {
                    //未上传通讯录
                    dispatch_async(dispatch_get_main_queue(), ^{
                        GTUploadAddressBookViewController *uploadAddressBookVC = [GTUploadAddressBookViewController new];
                        [weakSelf addChildViewController:uploadAddressBookVC];
                        [weakSelf.view addSubview:uploadAddressBookVC.view];
                        [uploadAddressBookVC didMoveToParentViewController:weakSelf];
                        
                        typeof(GTUploadAddressBookViewController *) __weak weakAddressBookVC = uploadAddressBookVC;
                        uploadAddressBookVC.uploadResultBlock = ^(BOOL isSuccess) {
                            if (isSuccess) {
                                //通讯录上传成功
                                
                                weakSelf.contactsUploaded = YES;
                                [weakAddressBookVC dismiss];
                                [weakSelf gotoPhoneAuthorization];
                            }
                        };
                    });
                }
            }];
        } else {
            //需要运营商认证，先创建认证订单流水
            [GTHUD showStatusWithTitle:nil];
            if (self.isPhoneAuthing) {
                return ;
            } else {
                self.isPhoneAuthing = YES;
            }
            NSDictionary *dict = @{
                                   @"productCode" : @"carrier"
                                   };
            
            WEAKSELF
            [GTAuthenticateService.sharedInstance createAuthOrderWithDict:dict succ:^(GTResModelAuth *resModel) {
                NSString *orderId = resModel.bizNo;
                
                if (orderId) {
                    dispatch_async(dispatch_get_main_queue(), ^{
                        [phoneAuth setOrderId:orderId];
                        GTAuthenticateService.sharedInstance.bizNo = orderId;
                        [weakSelf addChildViewController:phoneAuth];
                        phoneAuth.view.backgroundColor = [UIColor clearColor];
                        [weakSelf.view addSubview:phoneAuth.view];
                        [phoneAuth didMoveToParentViewController:weakSelf];
                    });
                }
                weakSelf.isPhoneAuthing = NO;
            } fail:^(GTNetError *error) {
                [GTHUD showToastWithText:error.msg];
                weakSelf.isPhoneAuthing = NO;
            }];            
        }
    } else {
        
        [self.navigationController pushViewController:phoneAuth animated:YES];
    }
}

//支付宝认证
- (void)gotoAlipayAuthorization
{
    //需要前3项认证通过
    if (![self userInfoAuthDetect]) {
        return;
    }
    if (![self bankCardAuthDetect]) {
        return;
    }
    if (![self phoneAuthDetect]) {
        return;
    }

    //需要支付宝认证
    GTAlipayAuthViewController *alipayAuth = [[GTAlipayAuthViewController alloc] initWithAlipayAuth:self.authInfoModel.zfbStatus];
    [self.navigationController pushViewController:alipayAuth animated:YES];
}

- (void)postUserLocation
{
    WEAKSELF
    __block NSMutableDictionary *dict = [NSMutableDictionary dictionary];
    dict[@"productCode"] = @"certcard";
    //地理解码
    [GTAuthenticateService.sharedInstance reverseGeocodeLocation:self.location succ:^(NSDictionary *locasDict) {
        
        dict[@"locationCity"] = locasDict[@"city"];
        dict[@"regAddress"] = locasDict[@"address"];

        //创建用户认证订单流水
        [GTAuthenticateService.sharedInstance createAuthOrderWithDict:dict succ:^(GTResModelAuth *resModel) {
            NSString *orderId = resModel.bizNo;
            if (orderId) {
                weakSelf.orderId = orderId;
                GTAuthenticateService.sharedInstance.bizNo = orderId;
                [weakSelf gotoIDAuthorization];
            }
            weakSelf.location = nil;
        } fail:^(GTNetError *error) {
            weakSelf.location = nil;
            [GTHUD showToastWithText:error.msg];
        }];
        
    } fail:^(NSError *error) {
        [GTHUD showToastWithText:@"获取位置信息失败"];
    }];
}

- (void)refreshAuthAfterSubmit
{
    [self requestNetwork];
}

//用户认证检测
- (BOOL )userInfoAuthDetect
{
    if (self.authInfoModel.certStatus != GTAuthStatusSucceed) {
        //未通过实名认证
        WEAKSELF
        [self detectAlertWithInfo:@"您需要先完成实名认证" authBlock:^{
            [weakSelf gotoIDAuthorization];
        }];
        return NO;
    }
    return YES;
}

- (BOOL )bankCardAuthDetect
{
    if (self.authInfoModel.cardStatus != GTAuthStatusSucceed) {
        //未通过银行卡
        WEAKSELF
        [self detectAlertWithInfo:@"您需要先完成银行卡认证" authBlock:^{
            [weakSelf gotoBankcardAuthorization];
        }];
        return NO;
    }
    return YES;
}

- (BOOL )phoneAuthDetect
{
    if (self.authInfoModel.carrierStatus != GTAuthStatusSucceed) {
        //未通过运营商认证
        WEAKSELF
        [self detectAlertWithInfo:@"您需要先完成运营商认证" authBlock:^{
            [weakSelf gotoPhoneAuthorization];
        }];
        return NO;
    }
    return YES;
}

- (void)detectAlertWithInfo:(NSString *)info authBlock:(void(^)())authBlock
{
    UIAlertController *alertController = [UIAlertController alertControllerWithTitle:nil message:info preferredStyle:UIAlertControllerStyleAlert];
    UIAlertAction *cancelAction = [UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleDefault handler:nil];
    UIAlertAction *authAction = [UIAlertAction actionWithTitle:@"去认证" style:UIAlertActionStyleCancel handler:^(UIAlertAction * _Nonnull action) {
        //take photo
        if (authBlock) {
            authBlock();
        }
    }];
    
    [alertController addAction:cancelAction];
    [alertController addAction:authAction];
    [self presentViewController:alertController animated:YES completion:nil];
}

- (CLLocationManager *)locationManager
{
    if (!_locationManager) {
        _locationManager = [CLLocationManager new];
        _locationManager.delegate = self;
        _locationManager.distanceFilter = 100;
        _locationManager.desiredAccuracy = kCLLocationAccuracyBest;
    }
    return _locationManager;
}

//授权认证页面配置信息
- (NSArray *)authFunctionsConfigArray
{
    return @[
             @{
                 @"icon" : @"id",
                 @"mTitle" : @"实名认证"
                 },
             @{
                 @"icon" : @"bank",
                 @"mTitle" : @"银行卡认证"
                 },
             @{
                 @"icon" : @"phone",
                 @"mTitle" : @"运营商认证"
                 },
             @{
                 @"icon" : @"alipay",
                 @"mTitle" : @"支付宝认证"
                 }
             ];
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

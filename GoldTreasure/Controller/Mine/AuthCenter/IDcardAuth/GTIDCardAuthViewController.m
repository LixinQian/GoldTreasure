//
//  GTIDCardAuthViewController.m
//  GoldTreasure
//
//  Created by wangyaxu on 29/06/2017.
//  Copyright © 2017 zhaofanjinrong.com. All rights reserved.
//

#import "GTIDCardAuthViewController.h"
#import "GTAuthenticateService.h"
#import "GTIDCardSubmitView.h"
#import "GTAuthProcessingView.h"
#import "GTIDCardSucceedView.h"
#import "GTAuthFailureInfoView.h"
#import "GTSystemAuth.h"
#import <Masonry/Masonry.h>
#import "UDIDSafeOCREngine.h"
#import "UDIDSafeAuthEngine.h"

#import "GTUserAuthModel.h"

@interface GTIDCardAuthViewController ()<UDIDSafeAuthDelegate, UINavigationControllerDelegate, UIImagePickerControllerDelegate, CLLocationManagerDelegate>

@property (nonatomic, strong) GTIDCardSubmitView *submitView;
@property (nonatomic, assign) GTAuthStatus status;
@property (nonatomic, strong) GTUserAuthModel *authModel;
@property (nonatomic, assign) BOOL byUserSelf; //是否手动提交
@property (nonatomic, copy) NSString *orderId;

@property (nonatomic, strong) CLLocation *location;
@property (nonatomic, strong) CLLocationManager *locationManager;
@property (nonatomic, assign) CLAuthorizationStatus locationStatus;

@end

@implementation GTIDCardAuthViewController

- (instancetype)initWithUserAuth:(GTAuthStatus)status userSelf:(BOOL)byUserSelf
{
    self = [super init];
    if (self) {
        _status = status;
        _byUserSelf = byUserSelf;
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    self.automaticallyAdjustsScrollViewInsets = NO;
    self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc]initWithCustomView:[ReturnBack buttonWithType:UIButtonTypeCustom ReturnBackStyle:ReturnBackStyleBlack Target:self Action:@selector(returnBackAction)]];
    self.navigationItem.title = @"实名认证";
    self.view.backgroundColor = [GTColor gtColorC3];
    if (self.status == GTAuthStatusLack) {
        [self userAuthInterface];
    } else {
        [GTHUD showStatusWithTitle:nil];
        WEAKSELF
        [self requestNetworkWithCompletion:^{
            dispatch_async(dispatch_get_main_queue(), ^{
                [weakSelf userAuthStatusInterface];
                [GTHUD dismiss];
            });
        }];
    }
}

- (void)viewWillAppear:(BOOL)animated
{
//    [super viewWillAppear:animated];
//    if (self.status == GTAuthStatusLack) {
//        if (self.byUserSelf) {
//            [self interactivePopGesture:false];
//        }
//    }
    [GTHUD dismiss];
}

- (void) viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
    if (self.status == GTAuthStatusLack) {
        if (self.byUserSelf) {
            [self interactivePopGesture:false];
        }
    }
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark    - interface & 6    -

- (void)userAuthInterface
{
    //需要用户认证
    if (self.byUserSelf) {
        
        GTIDCardSubmitView *submitView = [GTIDCardSubmitView new];
        [self.view addSubview:submitView];
        self.submitView = submitView;
        [submitView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.right.and.bottom.equalTo(self.view);
            make.top.equalTo(self.mas_topLayoutGuide);
        }];
        
        WEAKSELF
        submitView.takePhotoBlock = ^{
            [weakSelf takePhoto];
        };
        
        submitView.submitBlock = ^(NSString *name, NSString *idCard, UIImage *frontImage, UIImage *backImage, UIImage *fullImage) {
            [weakSelf submitInfoToServerWithName:name idCardNumber:idCard frontImage:frontImage backImage:backImage fullImage:fullImage];
        };
    } else {
        [self gotoUserInfoAuth];
    }
}

- (void)userAuthStatusInterface
{
    //用户认证状态
    switch (self.authModel.authStatus) {
        case GTAuthStatusLack:
            break;
        case GTAuthStatusReview:
        {
            NSDateFormatter *formatter = [NSDateFormatter new];
            [formatter setDateFormat:@"yyyy.MM.dd"];
            NSString *dateString = [formatter stringFromDate:[NSDate date]];
            if (self.authModel.commitTime) {
                dateString = self.authModel.commitTime;
            }
            GTAuthProcessingView *processingView = [[GTAuthProcessingView alloc] initWithTitle:@"提交成功，审核中" reason:[dateString stringByAppendingString:@"  提交实名认证审核"] tip:@"实名认证一般在一至两个工作日内认证完毕。\n认证时间：9:00-18:00（周一至周日）\n如超时还未认证，请联系客服："];
            [self.view addSubview:processingView];
            [processingView mas_makeConstraints:^(MASConstraintMaker *make) {
                make.left.right.and.bottom.equalTo(self.view);
                make.top.equalTo(self.mas_topLayoutGuide).with.offset(60);
            }];
        }
            break;
        case GTAuthStatusSucceed:
        {
            NSMutableArray *array = [NSMutableArray array];
            [array addObject:@{@"姓名" : self.authModel.name}];
            [array addObject:@{@"身份证号" : self.authModel.idCard}];
            if (self.authModel.cardValid) {
                [array addObject:@{@"有效期" : self.authModel.cardValid}];
            } else {
                [array addObject:@{@"有效期" : @"-"}];
            }
            [array addObject:@{@"审核状态" : @"审核通过"}];
            [array addObject:@{@"提交时间" : self.authModel.commitTime}];
            if (self.authModel.successTime) {
                [array addObject:@{@"通过时间" : self.authModel.successTime}];
            }
            
            GTIDCardSucceedView *succeedView = [[GTIDCardSucceedView alloc] initWithInfoArray:array];
            [self.view addSubview:succeedView];
            [succeedView mas_makeConstraints:^(MASConstraintMaker *make) {
                make.left.right.equalTo(self.view);
                make.top.equalTo(self.mas_topLayoutGuide).with.offset(15);
            }];
        }
            
            break;
        case GTAuthStatusFailed:
        {
            NSString *reason = self.authModel.auditRemark ?: @"身份证照片不清晰，请重新提交。";
            
            GTAuthFailureInfoView *failureView = [[GTAuthFailureInfoView alloc] initWithTitle:@"实名认证失败" reason:reason btnTitle:@"手动输入审核"];
            [self.view addSubview:failureView];
            [failureView mas_makeConstraints:^(MASConstraintMaker *make) {
                make.left.right.and.bottom.equalTo(self.view);
                make.top.equalTo(self.mas_topLayoutGuide).with.offset(60);
            }];
            
            WEAKSELF
            failureView.submitInfoBlock = ^{
                [weakSelf submitInfoUserSelf];
            };
        }
            break;
        case GTAuthStatusAbsolutelyFailed:
        {
            NSString *reason = self.authModel.auditRemark ?: @"抱歉，您的资料不符合贷款要求。";
            
            GTAuthFailureInfoView *failureView = [[GTAuthFailureInfoView alloc] initWithTitle:@"实名认证失败" reason:reason btnTitle:nil];
            [self.view addSubview:failureView];
            [failureView mas_makeConstraints:^(MASConstraintMaker *make) {
                make.left.right.and.bottom.equalTo(self.view);
                make.top.equalTo(self.mas_topLayoutGuide).with.offset(60);
            }];
        }
            
        default:
            break;
    }
}

- (void)requestNetworkWithCompletion:(void(^)())completion
{
    NSDictionary *dict = @{
                           @"authType" : @"cert"
                           };
    WEAKSELF
    [GTAuthenticateService.sharedInstance fetchAuthDetailWithDict:dict res:[GTUserAuthModel new] succ:^(GTUserAuthModel *resModel) {
        weakSelf.authModel = resModel;
        if (completion) {
            completion();
        }
    } fail:^(GTNetError *error) {
        [GTHUD showToastWithText:error.msg];
    }];
}

#pragma mark    -   location delegate   -

- (void)locationManager:(CLLocationManager *)manager didUpdateLocations:(NSArray<CLLocation *> *)locations
{
    if (!self.location) {
        self.location = locations.firstObject;
        GTLog(@"%@", self.location);
        // 上传用户位置信息
        [self.locationManager stopUpdatingLocation];
        [self submitInfoUserSelf];
    }
}

- (void)locationManager:(CLLocationManager *)manager didChangeAuthorizationStatus:(CLAuthorizationStatus)status
{
    if (status == kCLAuthorizationStatusAuthorizedWhenInUse && self.locationStatus != status) {
        //已获取位置授权，且授权信息有所改变
        [self submitInfoUserSelf];
    } else if (status == kCLAuthorizationStatusDenied) {
        //未获得位置授权
    }
}

//再验证
- (void)submitInfoUserSelf
{
    self.locationStatus = [CLLocationManager authorizationStatus];
    //只有上传位置后才可以进行个人认证
    WEAKSELF
    [GTSystemAuth showAlertWithAuthType:GTSystemAuthTypeLocation completionHandler:^(GTSystemAuthStatus status) {
        if (status == GTSystemAuthStatusNotDetermined) {
            
            [weakSelf.locationManager requestWhenInUseAuthorization];
        } else if (status == GTSystemAuthStatusAuthorized) {
            
            if ([CLLocationManager locationServicesEnabled] && !weakSelf.location) {
                [weakSelf.locationManager startUpdatingLocation];
            }
            
            if (weakSelf.location) {
                dispatch_async(dispatch_get_main_queue(), ^{
                    //用户手动提交个人信息
                    GTAuthStatus status = GTAuthStatusLack;
                    GTIDCardAuthViewController *authVC = [[GTIDCardAuthViewController alloc] initWithUserAuth:status userSelf:YES];
                    [authVC setLocation:weakSelf.location];
                    [weakSelf.navigationController pushViewController:authVC animated:YES];
                });
            }
        }
    }];
}

- (void)takePhoto
{
    if ([UIImagePickerController isSourceTypeAvailable:UIImagePickerControllerSourceTypeCamera]) {
        WEAKSELF
        [GTSystemAuth showAlertWithAuthType:GTSystemAuthTypeCamera completionHandler:^(GTSystemAuthStatus status) {
            if (status == GTSystemAuthStatusAuthorized) {
                // 初始化图片选择控制器
                UIImagePickerController *controller = [[UIImagePickerController alloc] init];
                [controller setSourceType:UIImagePickerControllerSourceTypeCamera];
                controller.delegate = weakSelf;
                [weakSelf presentViewController:controller animated:YES completion:nil];
            }
        }];
    } else {
        NSLog(@"can't use camera");
    }
}

- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingImage:(UIImage *)image editingInfo:(nullable NSDictionary<NSString *,id> *)editingInfo
{
    if (image) {
        self.submitView.imagesCount ++;
        switch (self.submitView.imagesCount) {
            case 1:
                [self.submitView setFrontImage:image];
                break;
            case 2:
                [self.submitView setBackImage:image];
                break;
            case 3:
                [self.submitView setFullImage:image];
                break;
                
            default:
                break;
        }
    }
    
    [picker dismissViewControllerAnimated:YES completion:nil];
}

- (void)gotoUserInfoAuth
{
    UDIDSafeAuthEngine *engine = [[UDIDSafeAuthEngine alloc] init];
    engine.delegate = self;
    engine.authKey = IDCARDAUTHKEY;
    engine.notificationUrl = IDCARDNOTIURL;
    engine.showInfo = YES;
    engine.outOrderId = self.orderId;
    
    [engine startIdSafeWithUserName:nil IdentityNumber:nil InViewController:self];
}

- (void)idSafeAuthFinishedWithResult:(UDIDSafeAuthResult)result UserInfo:(id)userInfo
{
    if (result == UDIDSafeAuthResult_Cancel) {
    } else if (result == UDIDSafeAuthResult_Done) {
        //订单成功后，订单号置空
        GTAuthenticateService.sharedInstance.bizNo = nil;
    }
    if ([self.delegate respondsToSelector:@selector(refreshAuthAfterSubmit)]) {
        [self.delegate refreshAuthAfterSubmit];
    }
    [self.view removeFromSuperview];
    [self removeFromParentViewController];

    GTLog(@"%lu, %@", (unsigned long)result, userInfo);
}

- (void)submitInfoToServerWithName:(NSString *)name
                      idCardNumber:(NSString *)idCard
                        frontImage:(UIImage *)frontImage
                         backImage:(UIImage *)backImage
                         fullImage:(UIImage *)fullImage
{
    [GTHUD showStatusWithTitle:nil];
    //设置提交按钮不可点
    [self.submitView setSubmitBtnEnabled:NO];
    
    //网络手动提交个人信息
    __block NSMutableDictionary *dict = [NSMutableDictionary dictionary];
    dict[@"interId"] = GTApiCode.submitCertify;
    dict[@"custName"] = name;
    dict[@"cardNumber"] = idCard;
#warning 等待列表上传
    WEAKSELF
    [GTAuthenticateService.sharedInstance reverseGeocodeLocation:self.location succ:^(NSDictionary *locasDict) {
        
        dict[@"regCity"] = locasDict[@"city"];
        dict[@"regAddress"] = locasDict[@"address"];
        
        [GTAuthenticateService.sharedInstance uploadIdCardImageWithName:@"front.jpg" image:frontImage andProgress:nil succ:^(NSString *imageUrl) {
            dict[@"img1"] = imageUrl;
            
            [GTAuthenticateService.sharedInstance uploadIdCardImageWithName:@"back.jpg" image:backImage andProgress:nil succ:^(NSString *imageUrl) {
                dict[@"img2"] = imageUrl;
                
                [GTAuthenticateService.sharedInstance uploadIdCardImageWithName:@"half.jpg" image:fullImage andProgress:nil succ:^(NSString *imageUrl) {
                    dict[@"img3"] = imageUrl;
                    
                    [GTAuthenticateService.sharedInstance submitAuthInfoWithDict:dict succ:^(id resDict) {
                        [weakSelf popToAuthCenterViewController];
                    } fail:^(GTNetError *error) {
                        //            [weakSelf popToAuthCenterViewController];
                        [weakSelf.submitView setSubmitBtnEnabled:YES];
                        [GTHUD showErrorWithTitle:error.msg];
                    }];

                } fail:^(GTNetError *error) {
                    GTLog(@"身份证图片3上传失败")
                    [GTHUD showErrorWithTitle:error.msg];
                }];
                
            } fail:^(GTNetError *error) {
                GTLog(@"身份证图片2上传失败")
                [GTHUD showErrorWithTitle:error.msg];
            }];
            
        } fail:^(GTNetError *error) {
            GTLog(@"身份证图片1上传失败")
            [GTHUD showErrorWithTitle:error.msg];
        }];

    } fail:^(NSError *error) {
        
    }];
}

- (void)popToAuthCenterViewController
{
    __block UIViewController *targetVC = nil;
    [self.navigationController.viewControllers enumerateObjectsUsingBlock:^(__kindof UIViewController * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        if ([obj isKindOfClass:[GTAuthCenterViewController class]]) {
            targetVC = obj;
            *stop = YES;
        }
    }];
    if (targetVC) {
        [self.navigationController popToViewController:targetVC animated:YES];
    } else {
        [self.navigationController popToViewController:self.navigationController.viewControllers[0] animated:YES];
    }
}

- (void)setOrderId:(NSString *)orderId
{
    _orderId = orderId;
}

- (void)setLocation:(CLLocation *)location
{
    _location = location;
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

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end

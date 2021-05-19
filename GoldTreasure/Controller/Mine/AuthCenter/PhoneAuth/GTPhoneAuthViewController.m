//
//  GTPhoneAuthViewController.m
//  GoldTreasure
//
//  Created by wangyaxu on 29/06/2017.
//  Copyright © 2017 zhaofanjinrong.com. All rights reserved.
//

#import "GTPhoneAuthViewController.h"
#import "GTPhoneAuthModel.h"
#import "GTUploadAddressBookView.h"
#import "GTAuthProcessingView.h"
#import "GTPhoneSucceedView.h"
#import "GTAuthFailureInfoView.h"
#import "GTAuthenticateService.h"
#import "GTSystemAuth.h"
#import "GTUploadAddressBookViewController.h"
#import "MoxieSDK.h"

#import <Masonry/Masonry.h>

@interface GTPhoneAuthViewController ()<MoxieSDKDelegate>

@property (nonatomic, assign) GTAuthStatus status;
@property (nonatomic, strong) GTPhoneAuthModel *authModel;
@property (nonatomic, copy) NSString *orderId;

@property (nonatomic, assign) BOOL contactsUploaded;

@end

@implementation GTPhoneAuthViewController

- (instancetype)initWithCarrierAuth:(GTAuthStatus)status
{
    self = [super init];
    if (self) {
        _status = status;
        _contactsUploaded = NO;
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc]initWithCustomView:[ReturnBack buttonWithType:UIButtonTypeCustom ReturnBackStyle:ReturnBackStyleBlack Target:self Action:@selector(returnBackAction)]];
    self.navigationItem.title = @"运营商认证";
    self.view.backgroundColor = [GTColor gtColorC3];

    if (self.status == GTAuthStatusLack) {
        [self userAuthInterface];
    } else if (self.status == GTAuthStatusReview) {
        self.authModel = [GTPhoneAuthModel new];
        self.authModel.authStatus = self.status;
        [self userAuthStatusInterface];
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
    [super viewWillAppear:animated];
    [GTHUD dismiss];
}

- (void)viewDidDisappear:(BOOL)animated
{
    [super viewDidDisappear:animated];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark    - interface & network    -

- (void)userAuthInterface
{
    //需要用户认证
    //            [[MoxieSDK shared] clearCustomLogin];
    [MoxieSDK shared].mxUserId = self.orderId;
    [MoxieSDK shared].mxApiKey = IDCARDAUTHKEY;
    [MoxieSDK shared].taskType = @"carrier";
    [MoxieSDK shared].fromController = self;
    [MoxieSDK shared].delegate = self;
    [MoxieSDK shared].backImageName = @"back";
    [MoxieSDK shared].themeColor = [GTColor gtColorC1];
    [MoxieSDK shared].quitDisable = YES;
    //自动使用用户的实名信息
    GTResModelUserInfo *info = GTUser.manger.userInfoModel;
    [MoxieSDK shared].carrier_name = info.custName;
    [MoxieSDK shared].carrier_phone = info.phoneNo;
    [MoxieSDK shared].carrier_idcard = info.custNumber;
    
    [[MoxieSDK shared] startFunction];
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
            GTAuthProcessingView *processingView = [[GTAuthProcessingView alloc] initWithTitle:@"提交成功，审核中" reason:[dateString stringByAppendingString:@"  提交认证审核"] tip:@"运营商认证一般在一至两个工作日内认证完毕。\n认证时间：9:00-18:00（周一至周日）\n如超时还未认证，请联系客服："];
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
            [array addObject:@{@"手机号码" : self.authModel.phoneNo}];
            [array addObject:@{@"通讯录" : @"已上传"}];
            [array addObject:@{@"运营商认证" : @"认证通过"}];
            [array addObject:@{@"风控审核" : @"审核通过"}];
            [array addObject:@{@"提交时间" : self.authModel.commitTime}];
            if (self.authModel.successTime) {
                [array addObject:@{@"通过时间" : self.authModel.successTime}];
            }
            
            
            GTPhoneSucceedView *succeedView = [[GTPhoneSucceedView alloc] initWithInfoArray:array];
            [self.view addSubview:succeedView];
            [succeedView mas_makeConstraints:^(MASConstraintMaker *make) {
                make.left.right.and.bottom.equalTo(self.view);
                make.top.equalTo(self.mas_topLayoutGuide).with.offset(15);
            }];
        }
            
            break;
        case GTAuthStatusFailed:
        {
            NSString *reason = self.authModel.auditRemark ?: @"您的条件不匹配，请联系客服。";
            GTAuthFailureInfoView *failureView = [[GTAuthFailureInfoView alloc] initWithTitle:@"运营商认证失败" reason:reason btnTitle:@"重新提交审核"];
            [self.view addSubview:failureView];
            [failureView mas_makeConstraints:^(MASConstraintMaker *make) {
                make.left.right.and.bottom.equalTo(self.view);
                make.top.equalTo(self.mas_topLayoutGuide).with.offset(60);
            }];
            
            WEAKSELF
            failureView.submitInfoBlock = ^{
                [weakSelf reSubmitCarrierInfo];
            };
        }
            break;
            
        default:
            break;
    }
}

- (void)requestNetworkWithCompletion:(void(^)())completion
{
    NSDictionary *dict = @{
                           @"authType" : @"carrier"
                           };
    WEAKSELF
    [GTAuthenticateService.sharedInstance fetchAuthDetailWithDict:dict res:[GTPhoneAuthModel new] succ:^(GTPhoneAuthModel *resModel) {
        weakSelf.authModel = resModel;
        if (completion) {
            completion();
        }
    } fail:^(GTNetError *error) {
        [GTHUD showToastWithText:error.msg];
    }];
}

- (void)receiveMoxieSDKResult:(NSDictionary *)resultDictionary
{
#if __DEV
    NSString *desc = [NSString stringWithFormat:@"订单号：%@\n%@", GTAuthenticateService.sharedInstance.bizNo, [resultDictionary JSONString]];
    GTLog(@"%@", desc)
    
    NSArray *pathArr=NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString *strPath=[pathArr lastObject];
    NSString *strFinalPath=[NSString stringWithFormat:@"%@/%@",strPath, [[NSDate date] dateStringWithDateFormatter:@"yyyyMMddHHmmss"]];
    NSData *data=[desc dataUsingEncoding:NSUTF8StringEncoding];
    BOOL bResult=[data writeToFile:strFinalPath atomically:YES];
#endif
    
    NSNumber *code = resultDictionary[@"code"];
    if (code.integerValue == 2) {
        
    } else if (code.integerValue == 1) {
        //假如code是1则成功
        //订单成功后，订单号置空
//        GTAuthenticateService.sharedInstance.bizNo = nil;
        GTAuthenticateService.sharedInstance.taskId = resultDictionary[@"taskId"];
    } else if (code.integerValue == -1) {
        //用户没有做任何操作
    } else {
        //该任务失败按失败处理
    
    }
    if ([self.delegate respondsToSelector:@selector(refreshAuthAfterSubmit)]) {
        [self.delegate refreshAuthAfterSubmit];
    }

    [self popToAuthCenterViewController];
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

- (void)reSubmitCarrierInfo
{
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
                    
                    uploadAddressBookVC.uploadResultBlock = ^(BOOL isSuccess) {
                        if (isSuccess) {
                            //通讯录上传成功
                            
                            weakSelf.contactsUploaded = YES;
                            [weakSelf reSubmitCarrierInfo];
                        } else {
                            [GTHUD showAlertWithTitle:nil desc:@"通讯录上传失败"];
                        }
                    };
                });
            }
        }];
    } else {
        [GTHUD showStatusWithTitle:nil];
        
        GTAuthStatus authStatus = GTAuthStatusLack;
        __block GTPhoneAuthViewController *phoneAuth = [[GTPhoneAuthViewController alloc] initWithCarrierAuth:authStatus];

        NSDictionary *dict = @{
                               @"productCode" : @"carrier"
                               };
        
        //需要运营商认证，先创建认证订单流水
        WEAKSELF
        [GTAuthenticateService.sharedInstance createAuthOrderWithDict:dict succ:^(GTResModelAuth *resModel) {
            NSString *orderId = resModel.bizNo;
            
            if (orderId) {
                dispatch_async(dispatch_get_main_queue(), ^{
                    [phoneAuth setOrderId:orderId];
                    GTAuthenticateService.sharedInstance.bizNo = orderId;
                    [weakSelf addChildViewController:phoneAuth];
                    phoneAuth.view.alpha = 0;
                    [weakSelf.view addSubview:phoneAuth.view];
                    [phoneAuth didMoveToParentViewController:weakSelf];
                });
            }
        } fail:^(GTNetError *error) {
            [GTHUD showErrorWithTitle:error.msg];
        }];
    }
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

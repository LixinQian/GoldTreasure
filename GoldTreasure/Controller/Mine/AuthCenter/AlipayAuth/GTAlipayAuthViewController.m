//
//  GTAlipayAuthViewController.m
//  GoldTreasure
//
//  Created by wangyaxu on 29/06/2017.
//  Copyright © 2017 zhaofanjinrong.com. All rights reserved.
//

#import "GTAlipayAuthViewController.h"
#import "GTAlipayAuthModel.h"
#import "GTAlipaySubmitView.h"
#import "GTAuthProcessingView.h"
#import "GTAlipaySucceedView.h"
#import "GTAuthFailureInfoView.h"
#import "GTAuthenticateService.h"

#import <Masonry/Masonry.h>

@interface GTAlipayAuthViewController ()

@property (nonatomic, assign) GTAuthStatus status;
@property (nonatomic, strong) GTAlipayAuthModel *authModel;
@property (nonatomic, strong) GTAlipaySubmitView *submitView;

@end

@implementation GTAlipayAuthViewController

- (instancetype)initWithAlipayAuth:(GTAuthStatus)status;
{
    self = [super init];
    if (self) {
        _status = status;
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.

    self.automaticallyAdjustsScrollViewInsets = NO;
    self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc]initWithCustomView:[ReturnBack buttonWithType:UIButtonTypeCustom ReturnBackStyle:ReturnBackStyleBlack Target:self Action:@selector(returnBackAction)]];
    self.navigationItem.title = @"支付宝认证";
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

//- (void)viewWillAppear:(BOOL)animated
//{
//    [super viewWillAppear:animated];
//    if (self.status == GTAuthStatusLack) {
//        [self interactivePopGesture:false];
//    }
//}

- (void) viewDidAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    if (self.status == GTAuthStatusLack) {
        [self interactivePopGesture:false];
    }
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark    - interface & network    -

- (void)userAuthInterface
{
    //需要用户认证
    GTAlipaySubmitView *submitView = [GTAlipaySubmitView new];
    self.submitView = submitView;
    [self.view addSubview:submitView];
    [submitView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.mas_topLayoutGuide).with.offset(20);
        make.left.right.and.bottom.equalTo(self.view);
    }];
    
    WEAKSELF
    submitView.submitInfoBlock = ^(NSString *account, NSString *password) {
        [weakSelf submitAlipayInfoToServerWithAccount:account password:password];
    };
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
            GTAuthProcessingView *processingView = [[GTAuthProcessingView alloc] initWithTitle:@"提交成功，审核中" reason:[dateString stringByAppendingString:@"  提交支付宝认证审核"] tip:@"支付宝认证一般在一至两个工作日内认证完毕。\n认证时间：9:00-18:00（周一至周日）\n如超时还未认证，请联系客服："];
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
            [array addObject:@{@"支付宝账户" : self.authModel.alipayAccount}];
            [array addObject:@{@"认证状态" : @"认证通过"}];
            [array addObject:@{@"提交时间" : self.authModel.commitTime}];
            if (self.authModel.successTime) {
                [array addObject:@{@"通过时间" : self.authModel.successTime}];
            }
            
            GTAlipaySucceedView *succeedView = [[GTAlipaySucceedView alloc] initWithInfoArray:array];
            [self.view addSubview:succeedView];
            [succeedView mas_makeConstraints:^(MASConstraintMaker *make) {
                make.left.right.and.bottom.equalTo(self.view);
                make.top.equalTo(self.mas_topLayoutGuide).with.offset(15);
            }];
        }
            
            break;
        case GTAuthStatusFailed:
        {
            NSString *reason = self.authModel.auditRemark ?: @"您的帐号信息不正确，请重新提交。";
            GTAuthFailureInfoView *failureView = [[GTAuthFailureInfoView alloc] initWithTitle:@"支付宝认证失败" reason:reason btnTitle:@"重新提交审核"];
            [self.view addSubview:failureView];
            [failureView mas_makeConstraints:^(MASConstraintMaker *make) {
                make.left.right.and.bottom.equalTo(self.view);
                make.top.equalTo(self.mas_topLayoutGuide).with.offset(60);
            }];
            
            WEAKSELF
            failureView.submitInfoBlock = ^{
                [weakSelf reSubmitAlipay];
            };
        }
            break;
        case GTAuthStatusAbsolutelyFailed:
        {
            NSString *reason = self.authModel.auditRemark ?: @"抱歉，您的资料不符合贷款要求。";
            GTAuthFailureInfoView *failureView = [[GTAuthFailureInfoView alloc] initWithTitle:@"支付宝认证失败" reason:reason btnTitle:nil];
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
                           @"authType" : @"zfb"
                           };
    WEAKSELF
    [GTAuthenticateService.sharedInstance fetchAuthDetailWithDict:dict res:[GTAlipayAuthModel new] succ:^(GTAlipayAuthModel *resModel) {
        weakSelf.authModel = resModel;
        if (completion) {
            completion();
        }
    } fail:^(GTNetError *error) {
        [GTHUD showToastWithText:error.msg];
    }];
}

- (void)submitAlipayInfoToServerWithAccount:(NSString *)account password:(NSString *)password
{
    [GTHUD showStatusWithTitle:nil];
    [self.submitView setSubmitBtnEnabled:NO];
    //加密alipay密码
    password = [GTSecUtils encodeAlipayPasswordByAES128WithStrToEncode:password];
    
    NSDictionary *alipayInfo = @{
                                 @"interId" : GTApiCode.submitZfbCertify,
                                 @"loginPwd" : password,
                                 @"loginName" : account
                                 };
    
    //此处提交支付宝信息
    WEAKSELF
    [GTAuthenticateService.sharedInstance submitAuthInfoWithDict:alipayInfo succ:^(id resDict) {
        //成功返回授权中心
        [weakSelf popToAuthCenterViewController];
    } fail:^(GTNetError *error) {
//        [weakSelf popToAuthCenterViewController];
        //失败可以继续提交
        [weakSelf.submitView setSubmitBtnEnabled:YES];
        [GTHUD showErrorWithTitle:error.msg];
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

- (void)reSubmitAlipay
{
    GTAuthStatus authStatus = GTAuthStatusLack;
    GTAlipayAuthViewController *authVC = [[GTAlipayAuthViewController alloc] initWithAlipayAuth:authStatus];
    [self.navigationController pushViewController:authVC animated:YES];
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

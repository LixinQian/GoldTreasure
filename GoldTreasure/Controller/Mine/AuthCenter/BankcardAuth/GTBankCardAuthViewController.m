//
//  GTBankCardAuthViewController.m
//  GoldTreasure
//
//  Created by wangyaxu on 29/06/2017.
//  Copyright © 2017 zhaofanjinrong.com. All rights reserved.
//

#import "GTBankCardAuthViewController.h"
#import "GTBankCardAuthModel.h"
#import "GTAuthProcessingView.h"
#import "GTBankCardSucceedView.h"
#import "GTAuthFailureInfoView.h"
#import "GTAuthenticateService.h"
#import "GTBankCardCommitViewController.h"

#import <Masonry/Masonry.h>
#import <SDWebImage/UIImageView+WebCache.h>

@interface GTBankCardAuthViewController ()

@property (nonatomic, assign) GTAuthStatus status;
@property (nonatomic, strong) GTBankCardAuthModel *authModel;

@property (nonatomic, strong) GTBankCardCommitViewController *commitVC;

@end

@implementation GTBankCardAuthViewController

- (instancetype)initWithBankCardAuth:(GTAuthStatus)status
{
    self = [super init];
    if (self) {
        _status = status;
    }
    return self;
}

- (instancetype)initWithBankCardAuthModel:(GTBankCardAuthModel *)model
{
    self = [super init];
    if (self) {
        _status = model.authStatus;
        _authModel = model;
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    self.automaticallyAdjustsScrollViewInsets = NO;
    self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc]initWithCustomView:[ReturnBack buttonWithType:UIButtonTypeCustom ReturnBackStyle:ReturnBackStyleBlack Target:self Action:@selector(returnBackAction)]];
    self.navigationItem.title = @"银行卡认证";
    self.view.backgroundColor = [GTColor gtColorC3];

    if (self.status == GTAuthStatusLack) {
        [self userAuthInterface];
    } else {
        if (self.authModel) {
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
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark    - interface & network    -

- (void)userAuthInterface
{
    //需要用户认证
    GTBankCardCommitViewController *commitVC = [GTBankCardCommitViewController new];
    self.commitVC = commitVC;
    [self addChildViewController:commitVC];
    [self.view addSubview:commitVC.view];
    [commitVC didMoveToParentViewController:self];
    
    [commitVC.view mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.and.bottom.equalTo(self.view);
        make.top.equalTo(self.mas_topLayoutGuide);
    }];
    
    WEAKSELF
    commitVC.commitBlock = ^(NSString *mobile, NSString *bankNo) {
        [weakSelf bandBankCardWithMobile:mobile cardNumber:bankNo];
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
            GTAuthProcessingView *processingView = [[GTAuthProcessingView alloc] initWithTitle:@"银行卡认证审核中" reason:[dateString stringByAppendingString:@"  提交实名认证审核"] tip:@"银行卡认证为系统自动认证。\n如在1小时内还未完成认证，请联系客服："];
            [self.view addSubview:processingView];
            [processingView mas_makeConstraints:^(MASConstraintMaker *make) {
                make.left.right.and.bottom.equalTo(self.view);
                make.top.equalTo(self.mas_topLayoutGuide).with.offset(60);
            }];
        }
            break;
        case GTAuthStatusSucceed:
        {
            GTBankCardSucceedView *succeedView = [[GTBankCardSucceedView alloc] init];
            [self.view addSubview:succeedView];
            [succeedView mas_makeConstraints:^(MASConstraintMaker *make) {
                make.left.right.and.bottom.equalTo(self.view);
                make.top.equalTo(self.mas_topLayoutGuide).with.offset(20);
            }];
            
            [succeedView.bankIcon sd_setImageWithURL:[NSURL URLWithString:self.authModel.logoUrl]];
            [succeedView setBankNumber:self.authModel.cardNo];
            [succeedView setAddDate:[self.authModel.addTime stringByAppendingString:@"  添加"]];
            [succeedView setBankName:self.authModel.bankName];
            
            GTResModelUserInfo *userInfo = GTUser.manger.userInfoModel;
            if (userInfo.status.integerValue == 2) {
                //用户四项认证通过，不能再更换银行卡，隐藏更换银行卡按钮
                [succeedView setChangeCardBtnHidden:YES];
            }
            
            WEAKSELF
            succeedView.changeCardBlock = ^{
                [weakSelf reSubmitBankCard];
            };
        }
            
            break;
        case GTAuthStatusFailed:
        {
            NSString *reason = self.authModel.auditRemark ?: @"户名、证件信息或手机号等验证失败，请重新提交。";
            
            GTAuthFailureInfoView *failureView = [[GTAuthFailureInfoView alloc] initWithTitle:@"银行卡认证失败" reason:reason btnTitle:@"重新提交审核"];
            [self.view addSubview:failureView];
            [failureView mas_makeConstraints:^(MASConstraintMaker *make) {
                make.left.right.and.bottom.equalTo(self.view);
                make.top.equalTo(self.mas_topLayoutGuide).with.offset(60);
            }];
            
            WEAKSELF
            failureView.submitInfoBlock = ^{
                [weakSelf reSubmitBankCard];
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
                           @"authType" : @"bank"
                           };
    WEAKSELF
    [GTAuthenticateService.sharedInstance fetchAuthDetailWithDict:dict res:[GTBankCardAuthModel new] succ:^(GTBankCardAuthModel *resModel) {
        weakSelf.authModel = resModel;
        if (completion) {
            completion();
        }
    } fail:^(GTNetError *error) {
        [GTHUD showToastWithText:error.msg];
    }];
}

- (void)reSubmitBankCard
{
    GTAuthStatus authStatus = GTAuthStatusLack;
    GTBankCardAuthViewController *authVC = [[GTBankCardAuthViewController alloc] initWithBankCardAuth:authStatus];
    [self.navigationController pushViewController:authVC animated:YES];
}

- (void)bandBankCardWithMobile:(NSString *)mobile cardNumber:(NSString *)cardNumber
{
    [GTHUD showStatusWithTitle:nil];
    [self.commitVC setSubmitBtnEnabled:NO];
    
    NSDictionary *bankInfoDic = @{
                                  @"interId" : GTApiCode.submitCardBind,
                                  @"cardNo" : cardNumber,
                                  @"mobile" : mobile
                                  };
    WEAKSELF
    //此处提交银行卡信息
    [GTAuthenticateService.sharedInstance submitAuthInfoWithDict:bankInfoDic succ:^(id resDict) {

        [weakSelf.commitVC setSubmitBtnEnabled:YES];
        
        GTBankCardAuthModel *model = [GTBankCardAuthModel new];
        if ([model yy_modelSetWithJSON:resDict]) {
            model.authStatus = [resDict[@"code"] integerValue];
            model.addTime = [resDict[@"submitTime"] substringToIndex:10];
            model.auditRemark = resDict[@"message"];
            [weakSelf bandBandCardSucceedWithModel:model];
        }
    } fail:^(GTNetError *error) {
        [weakSelf.commitVC setSubmitBtnEnabled:YES];
        //错误则清空银行卡号
        [weakSelf.commitVC reInputBankcardNumber];
        [GTHUD showErrorWithTitle:error.msg];
    }];
}

- (void)bandBandCardSucceedWithModel:(GTBankCardAuthModel *)model
{
    GTBankCardAuthViewController *authVC = [[GTBankCardAuthViewController alloc] initWithBankCardAuthModel:model];
    [self.navigationController pushViewController:authVC animated:YES];
}

- (void)returnBackAction
{
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

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end


//
//  GTLoginController.m
//  GoldTreasure
//
//  Created by 王超 on 2017/6/28.
//  Copyright © 2017年 zhaofanjinrong.com. All rights reserved.
//

#import "GTLoginController.h"
#import "GTLoginView.h"
#import <Masonry/Masonry.h>
#import "GTRegisterController.h"
#import "GTForgetPasswordController.h"
#import "GTShowMessage.h"
#import "NSObject+GT.h"
#import "GTVerification.h"


@interface GTLoginController ()
{
    GTLoginView *login;
}
@property (nonatomic, strong) NSString *phoneNo;
@property (nonatomic, strong) NSString *password;

@end

@implementation GTLoginController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self initData];
    [self setUpLoginView];
}

- (void) initData {
    
    if (![GTUser isLogin]) {
        
        self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc]initWithCustomView:[ReturnBack buttonWithType:UIButtonTypeCustom ReturnBackStyle:ReturnBackStyleWhite Target:self Action:@selector(dismissViewC)]];
    }
    
    _phoneNo = [NSString string];
    _password = [NSString string];
}

- (void) viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    [UIApplication sharedApplication].statusBarStyle = UIStatusBarStyleLightContent;
    [self transNav:true];
}
- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
    [UIApplication sharedApplication].statusBarStyle = UIStatusBarStyleDefault;
}
//
-(void)setUpLoginView {
    
    login = [GTLoginView new];
    [self.view addSubview:login];
    
    [login mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.view);
        make.top.mas_equalTo(self.view);
        make.right.equalTo(self.view);
        make.bottom.equalTo(self.view);
    }];
    
    // 触发登录
    WEAKSELF
    login.login = ^(NSString *telNum, NSString *passWord, UIButton *btn) {
        
        weakSelf.password = passWord;
        weakSelf.phoneNo = telNum;
//        btn.enabled = false;
        [weakSelf loginUserWith:^(id model) {
//            btn.enabled = true;
        } andWithFail:^(GTNetError *error) {
//            btn.enabled = true;
        }];
    };
    
    login.registerVC = ^{
        
        [[NSOperationQueue mainQueue] addOperationWithBlock:^{
            GTRegisterController *regist = [[GTRegisterController alloc]init];
            [weakSelf.navigationController pushViewController:regist animated:YES];
        }];
    };

    login.passWordVC = ^{

        GTForgetPasswordController *reset = [[GTForgetPasswordController alloc]init];
        reset.passWordFlag = 1;
        [weakSelf.navigationController pushViewController:reset animated:YES];
    };
    
}

// 触发登录操作
- (void) loginUserWith:(void(^)(id model)) succ andWithFail:(void(^)(GTNetError *error)) fail {
    
    if ([_password isEmptyOrWhitespace] || [_phoneNo isEmptyOrWhitespace] || !_password || !_phoneNo ) { return; };
    if (![GTVerification checkTelNumber:_phoneNo]) {
        [GTHUD showErrorWithTitle:@"手机格式不正确！"];
        return;
    }
    GTReqModelLogin *model = [[GTReqModelLogin alloc] init]; // 请求model 暂定为 GTReqModelLogin 需要参数 自定义 添加
    model.interId = GTApiCode.loginByPhone;  // 接口编号 在GTApiCode 中定义,要自己定义
    model.phoneNo = _phoneNo;
    model.password = [GTSecUtils pwdAddSaltWithPhone:_phoneNo pwd:_password];
    
    WEAKSELF
    [GTHUD showStatusWithTitle:@"登录中"];
    [[GTLoginService sharedInstance] loginWithReqModel:model succ:^(GTResModelUserInfo *resModel) {
        
        if (succ != nil) {
            succ(resModel);
        }
        
        GTLog(@"%@",[resModel yy_modelToJSONObject]);
        [GTHUD showSuccessWithTitle:@"登录成功"];

        
        [weakSelf dismissViewC];
    } fail:^(GTNetError *error) {
        
        if (fail != nil) {
            fail(error);
        }
        [GTHUD showErrorWithTitle:error.msg];
    }];
    
//    [GTHUD showMaskStatusWithView:login title:@"登录中..." block:^(MBProgressHUD * _Nonnull hud) {
//
//        [[GTLoginService sharedInstance] loginWithReqModel:model succ:^(GTResModelUserInfo *resModel) {
//            
//            if (succ != nil) {
//                succ(resModel);
//            }
//        
//            GTLog(@"%@",[resModel yy_modelToJSONObject]);
//            [GTHUD showSuccessWithTitle:@"登录成功"];
//            [hud hideAnimated:true];
//            
//            [weakSelf dismissViewC];
//        } fail:^(GTNetError *error) {
//            
//            if (fail != nil) {
//                fail(error);
//            }
//            [GTHUD showErrorWithTitle:error.msg];
//            [hud hideAnimated:true];
//        }];
//
//    }];

}
//// 登录
//-(void)postLoginWithTel:(NSString *)tel Pwd:(NSString *)pwd
//{
//    GTReqModelLogin *model = [[GTReqModelLogin alloc] init]; // 请求model 暂定为 GTReqModelLogin 需要参数 自定义 添加
//    model.interId = GTApiCode.loginByPhone;  // 接口编号 在GTApiCode 中定义,要自己定义
//    model.phoneNo = tel;
//    model.password = [GTSecUtils pwdAddSaltWithPhone:tel pwd:pwd];
//    //
//    WEAKSELF
//    [GTHUD showStatusWithStr:@"登录中..."];
//    [[GTLoginService sharedInstance] loginWithReqModel:model succ:^(GTResModelUserInfo *resModel) {
//        
//        //缓存数据
//        GTLog(@"%@",[resModel yy_modelToJSONObject]);
//        [GTHUD showSuccessWithStr:@"登录成功"];
//        [weakSelf dismissViewC];
//    } fail:^(GTNetError *error) {
//        [GTHUD showErrorWithStr:error.msg];
//    }];
//}

-(void)dismissViewC {
    
//    if (self.navigationController) {
//        [self.navigationController popViewControllerAnimated:true];
//    } else {
//        [self dismissViewControllerAnimated:YES completion:nil];
//    }
//    [self.navigationController popViewControllerAnimated:true];
    [[GTHUD currentNav] dismissViewControllerAnimated:true completion:nil];
    
}

@end

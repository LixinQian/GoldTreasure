//
//  GTForgetPasswordController.m
//  GoldTreasure
//
//  Created by 王超 on 2017/6/29.
//  Copyright © 2017年 zhaofanjinrong.com. All rights reserved.
//

#import "GTForgetPasswordController.h"
#import "GTForgetPasswordCell.h"
#import <Masonry/Masonry.h>
#import "GTVerification.h"

@interface GTForgetPasswordController ()<UITableViewDelegate,UITableViewDataSource>
{
    NSInteger _timerNumber;
}
@property (nonatomic, strong) UITableView *forgetPasswordTableView;

@property (nonatomic, strong) UIButton *reSetBtn;

/**
 *  定时器
 */
@property (nonatomic, strong) NSTimer *timer;
//验证码按钮
@property (nonatomic, strong) UIButton *codeBtn;

@property (nonatomic, strong) NSMutableArray *dataArr;

@end

@implementation GTForgetPasswordController
-(NSMutableArray *)dataArr
{
    if (!_dataArr) {
        _dataArr = [NSMutableArray array];
    }
    return _dataArr;
}
-(UITableView *)forgetPasswordTableView
{
    if (!_forgetPasswordTableView) {
        _forgetPasswordTableView = [[UITableView alloc]initWithFrame:CGRectMake(0, 0, ScreenWidth, ScreenHeight-64) style:UITableViewStyleGrouped];
        _forgetPasswordTableView.delegate = self;
        _forgetPasswordTableView.dataSource = self;
        _forgetPasswordTableView.backgroundColor = [GTColor gtColorC3];
        _forgetPasswordTableView.bounces = NO;
        
        UIView *footView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, ScreenWidth, 50)];
        _forgetPasswordTableView.tableFooterView = footView;
        _reSetBtn = [UIButton buttonWithType:UIButtonTypeCustom];
//        _reSetBtn.backgroundColor = [GTColor gtColorC1];
        [_reSetBtn setBackgroundImage:[UIImage initWithColor:[GTColor gtColorC1]] forState:UIControlStateNormal];

        if (_passWordFlag == 1) {
            [_reSetBtn setTitle:@"重  置" forState:UIControlStateNormal];
        }else
        {
            [_reSetBtn setTitle:@"修  改" forState:UIControlStateNormal];
        }
        _reSetBtn.titleLabel.font = [GTFont gtFontF1];
        [_reSetBtn setTitleColor:[GTColor gtBtnColorC] forState:UIControlStateNormal];
        _reSetBtn.layer.cornerRadius = 5;
        _reSetBtn.layer.masksToBounds = YES;
        [_reSetBtn addTarget:self action:@selector(resetBtnAction) forControlEvents:UIControlEventTouchUpInside];
        [footView addSubview:_reSetBtn];
        [_reSetBtn mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.mas_equalTo(footView).offset(autoScaleW(15));
            make.top.equalTo(footView);
            make.right.mas_equalTo(footView).offset(autoScaleW(-15));
            make.height.mas_equalTo(autoScaleH(50));
        }];
    }
    
    return _forgetPasswordTableView;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    if (_passWordFlag == 1) {
        self.title = @"忘记密码";
    }else
    {
        self.title = @"修改登录密码";
    }
    self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc]initWithCustomView:[ReturnBack buttonWithType:UIButtonTypeCustom ReturnBackStyle:ReturnBackStyleBlack Target:self Action:@selector(returnBackAction)]];
    
    [self transNav:false];
    self.view.backgroundColor = [GTColor gtColorC3];
    [self.view addSubview:self.forgetPasswordTableView];
    
}

#pragma UITableView代理方法
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if (_passWordFlag == 1) {
        return 4;
    }
    return 3;
}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return autoScaleH(50);
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *indentifier = @"cell";
    GTForgetPasswordCell *cell = [tableView dequeueReusableCellWithIdentifier:indentifier];
    if (cell == nil) {
        cell = [[GTForgetPasswordCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:indentifier];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
    }
    if (_passWordFlag == 1) {
        
        if (indexPath.row == 0) {
            [cell setCellWithStyle:CellStyleNormal];
            // 长度截取
            [[[cell.subTitleTF rac_newTextChannel] map:^id _Nullable(NSString * _Nullable value) {
                if (value.length > 11) {
                    return [value substringToIndex:11];
                }
                return value;
            }] subscribeNext:^(id  _Nullable x) {
                cell.subTitleTF.text = x;
            }];
        } else if (indexPath.row == 1) {
            
            [cell setCellWithStyle:CellStyleCode];
            [self codeAction:cell];
            
        } else {
            [cell setCellWithStyle:CellStyleNormal];
        }
    }else
    {
        [cell setCellWithStyle:CellStyleNormal];
    }
    
    [cell setValueWithIndex:indexPath.row Flag:_passWordFlag];
    
    return cell;
    
}
-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    return autoScaleH(15);
}
-(CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section
{
    return autoScaleH(30);
}
-(void)resetBtnAction
{
    if (_passWordFlag == 1) {
        
//        NSLog(@"重置密码");
        [self resetBtnRequest];
    } else {
        [self changePassword];
    }
}

//获取cell上的值
- (void)getCellText
{
    [self.dataArr removeAllObjects];
    
    if (_passWordFlag == 1) {
        for (int i = 0; i < 4; i++) {
            GTForgetPasswordCell *cell = [_forgetPasswordTableView cellForRowAtIndexPath:[NSIndexPath indexPathForRow:i inSection:0]];
            [self.dataArr addObject:[cell getText]];
        }
    }
    else
    {
        for (int i = 0; i < 3; i++) {
            GTForgetPasswordCell *cell = [_forgetPasswordTableView cellForRowAtIndexPath:[NSIndexPath indexPathForRow:i inSection:0]];
            [self.dataArr addObject:[cell getText]];
        }
    }
    
}
//修改密码
-(void)changePassword
{
    [self getCellText];
    _reSetBtn.enabled = NO;
    
    if (![GTVerification checkPwdNumber:self.dataArr[0]]) {
        [GTHUD showErrorWithTitle:@"原密码格式不正确！6到16位字母数字下划线"];
        _reSetBtn.enabled = YES;
        return;
    }
    if (![GTVerification checkPwdNumber:self.dataArr[1]]) {
        [GTHUD showErrorWithTitle:@"新密码格式不正确！6到16位字母数字下划线"];
        _reSetBtn.enabled = YES;
        return;
    }
    
    if ([self.dataArr[0] isEqualToString:self.dataArr[1]]) {
        [GTHUD showErrorWithTitle:@"新密码与原密码相同！"];
        _reSetBtn.enabled = YES;
        return;
    }
    if (![self.dataArr[1] isEqualToString:self.dataArr[2]]) {
        [GTHUD showErrorWithTitle:@"两次密码输入不一致！"];
        _reSetBtn.enabled = YES;
        return;
    }
    
    if (![GTUser isLogin]) {
        [GTHUD showErrorWithTitle:@"请求数据错误！"];
        _reSetBtn.enabled = YES;
        return;
    }
    GTReqModelLogin *model = [[GTReqModelLogin alloc] init];
    model.interId = GTApiCode.modifyCustPassword;
    model.ver = GTApiCommonParam.ver;
    model.companyId = GTApiCommonParam.companyId;
    model.oldPassword = [GTSecUtils pwdAddSaltWithPhone:GTUser.manger.userInfoModel.phoneNo pwd:self.dataArr[0]];
    model.newPassword = [GTSecUtils pwdAddSaltWithPhone:GTUser.manger.userInfoModel.phoneNo pwd:self.dataArr[1]];
    
    NSDictionary *dict = [model yy_modelToJSONObject];
    
    WEAKSELF
    [GTHUD showStatusWithTitle:@"努力修改中..."];
    [[GTApi requestParams:dict andResmodel: [GTResModelUserInfo class] andAuthStatus:nil]
     subscribeNext:^(GTResModelUserInfo  *_Nullable x) {
         
         [GTHUD showSuccessWithTitle:@"密码修改成功！"];
         [GTUser.manger logoutWithTitle:@"修改成功，请重新登录" proTitle:nil succ:^{
             [weakSelf.navigationController popToRootViewControllerAnimated:NO];
         } fail:nil];
         
     } error:^(NSError * _Nullable error) {
         
         GTNetError *err = (GTNetError *) error;
         GTLog(@"#####%@", err);
         
         [GTHUD showErrorWithTitle:[NSString stringWithFormat:@"%@",err.msg]];
         _reSetBtn.enabled = YES;
     }];

    
    
}
//获取验证码
-(void)codeAction:(GTForgetPasswordCell *)cell
{
    WEAKSELF
    cell.myBolck = ^(UIButton *btn) {
      
        self.codeBtn = btn;
        [weakSelf postCode];
    };
}
// 重置密码
- (void) resetBtnRequest {
    
    [self getCellText];
    _reSetBtn.enabled = NO;
    
    if (![GTVerification checkTelNumber:self.dataArr[0]]) {
        [GTHUD showErrorWithTitle:@"手机格式不正确！"];
        _reSetBtn.enabled = YES;
        return;
    }
    if ([self.dataArr[1] length] < 4) {
        [GTHUD showErrorWithTitle:@"请输入完整验证码至少为4位！"];
        _reSetBtn.enabled = YES;
        return;
    }
    if (![GTVerification checkPwdNumber:self.dataArr[2]]) {
        [GTHUD showErrorWithTitle:@"密码格式不正确！6到16位字母数字下划线"];
        _reSetBtn.enabled = YES;
        return;
    }
    if (![self.dataArr[2] isEqualToString:self.dataArr[3]]) {
        [GTHUD showErrorWithTitle:@"两次密码输入不一致！"];
        _reSetBtn.enabled = YES;
        return;
    }
    
    GTReqModelLogin *model = [[GTReqModelLogin alloc] init];
    model.interId = GTApiCode.resetCustPassword;
    model.ver = GTApiCommonParam.ver;
    model.companyId = GTApiCommonParam.companyId;
    model.phoneNo = self.dataArr[0];
    model.verificationCode = self.dataArr[1];
    model.password = [GTSecUtils pwdAddSaltWithPhone:self.dataArr[0] pwd:self.dataArr[2]];
    
    NSDictionary *dict = [model yy_modelToJSONObject];
    
    WEAKSELF
    [GTHUD showStatusWithTitle:@"正在重置..."];
    [[GTApi requestParams:dict andResmodel: [GTResModelUserInfo class] andAuthStatus:nil]
     subscribeNext:^(GTResModelUserInfo  *_Nullable x) {
        
         [GTHUD showSuccessWithTitle:@"密码重置成功！"];
         [weakSelf.navigationController popViewControllerAnimated:YES];
         
    } error:^(NSError * _Nullable error) {
        
        GTNetError *err = (GTNetError *) error;
        GTLog(@"#####%@", err);
        
        [GTHUD showErrorWithTitle:[NSString stringWithFormat:@"%@",err.msg]];
        _reSetBtn.enabled = YES;
    }];
}

-(void)postCode
{
    [self getCellText];
    
    if (![GTVerification checkTelNumber:self.dataArr[0]]) {
        [GTHUD showErrorWithTitle:@"手机格式不正确！"];
        return;
    }
    self.codeBtn.enabled = NO;
    
    GTReqModelLogin *model = [[GTReqModelLogin alloc] init]; // 请求model 暂定为 GTReqModelLogin 需要参数 自定义 添加
    model.interId = GTApiCode.getVerificationCode;  // 接口编号 在GTApiCode 中定义,要自己定义
    model.ver = GTApiCommonParam.ver;
    model.companyId = GTApiCommonParam.companyId;
    model.type = @2;
    model.phoneNo = self.dataArr[0];
    
    NSDictionary *dict = [model yy_modelToJSONObject]; // 转为字典
    //
    [[GTApi requestParams:dict andResmodel:[GTResModelCommon class] andAuthStatus:nil]
     subscribeNext:^(GTResModelCommon*  _Nullable model) {
         
         //         model.message
         GTLog(@"请求内容:\n%@",[model yy_modelToJSONObject]);
         [GTHUD showSuccessWithTitle:@"验证码发送成功！"];
         [self startTimeAction];
         
         
     } error:^(NSError * _Nullable error) {
         
         GTNetError *err = (GTNetError *) error;
         GTLog(@"#####%@", err);
         
         [GTHUD showErrorWithTitle:[NSString stringWithFormat:@"%@",err.msg]];
         self.codeBtn.enabled = YES;
     }];
}

- (void)startTimeAction
{
    _timerNumber = 60;
    _timer = [NSTimer scheduledTimerWithTimeInterval:1.0 target:self selector:@selector(timerAction:) userInfo:nil repeats:YES];
}

- (void)timerAction:(NSTimer *)timer
{
    
    _timerNumber--;
    [_codeBtn setTitle:[NSString stringWithFormat:@"%ld秒后重发", (long)_timerNumber] forState:UIControlStateNormal];
    if (_timerNumber < 1) {
        [_timer invalidate];
        _timer = nil;
        [_codeBtn setTitle:@"重新获取" forState:UIControlStateNormal];
        self.codeBtn.enabled = YES;
    }
}

@end

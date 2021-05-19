//
//  GTRegisterController.m
//  GoldTreasure
//
//  Created by 王超 on 2017/6/29.
//  Copyright © 2017年 zhaofanjinrong.com. All rights reserved.
//

#import "GTRegisterController.h"
#import <Masonry/Masonry.h>
#import "GTVerification.h"
#import "NSString+TelNumber.h"
#import "GTUserAgreementController.h"

@interface GTRegisterController ()
{
    NSInteger _timerNumber;
}
@property (nonatomic, strong) UIImageView *telIcon;
@property (nonatomic, strong) UITextField *telTF;
@property (nonatomic, strong) UIView *line1;
@property (nonatomic, strong) UIImageView *codeIcon;
@property (nonatomic, strong) UITextField *codeTF;
@property (nonatomic, strong) UIView *line2;
@property (nonatomic, strong) UIButton *codeBtn;
@property (nonatomic, strong) UIImageView *passWordIcon;
@property (nonatomic, strong) UITextField *passWordTF;
@property (nonatomic, strong) UIView *line3;
@property (nonatomic, strong) UIImageView *verifyPwdIcon;
@property (nonatomic, strong) UITextField *verifyPwdTF;
@property (nonatomic, strong) UIView *line4;
@property (nonatomic, strong) UIButton *selectBtn;
@property (nonatomic, strong) UILabel *userAgreement;
@property (nonatomic, strong) UIButton *registerBtn;

/**
 *  定时器
 */
@property (nonatomic, strong) NSTimer *timer;

@end

@implementation GTRegisterController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"注册";

    self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc]initWithCustomView:[ReturnBack buttonWithType:UIButtonTypeCustom ReturnBackStyle:ReturnBackStyleBlack Target:self Action:@selector(returnBackAction)]];
    
//    self.navigationController.navigationBar.translucent = false;
//    [self.navigationController.navigationBar setShadowImage:[UIImage initWithColor:[UIColor grayColor]]];
    [self transNav:false];
    self.view.backgroundColor = [GTColor gtColorC2];
    
    
    [self setUI];
    [self initHandle];
}

- (void) initHandle {
    
    
    // 校验位数
    WEAKSELF
    [[self.telTF.rac_newTextChannel map:^id _Nullable(NSString * _Nullable value) {
       
        if (value.length > 11) {
            
            return [value substringToIndex:11];
        }
        return value;
    }] subscribeNext:^(id  _Nullable x) {
        weakSelf.telTF.text = x;
    }];
    
}

-(void)setUI
{
    self.telIcon = [UIImageView new];
    self.telIcon.contentMode = UIViewContentModeScaleAspectFit;
    self.telIcon.image = [UIImage imageNamed:@"tel_n"];
    [self.view addSubview:self.telIcon];
    self.passWordIcon = [UIImageView new];
    self.passWordIcon.image = [UIImage imageNamed:@"password_n"];
    self.passWordIcon.contentMode = UIViewContentModeScaleAspectFit;
    [self.view addSubview:self.passWordIcon];
    self.codeIcon = [UIImageView new];
    self.codeIcon.image = [UIImage imageNamed:@"code_n"];
    self.codeIcon.contentMode = UIViewContentModeScaleAspectFit;
    [self.view addSubview:self.codeIcon];
    self.verifyPwdIcon = [UIImageView new];
    self.verifyPwdIcon.image = [UIImage imageNamed:@"password_n"];
    self.verifyPwdIcon.contentMode = UIViewContentModeScaleAspectFit;
    [self.view addSubview:self.verifyPwdIcon];
    
    self.telTF = [UITextField new];
    self.telTF.textColor = [GTColor gtColorC4];
    self.telTF.font = [GTFont gtFontF2];
    self.telTF.placeholder = @"请输入手机号码（学生请勿注册）";
    self.telTF.keyboardType = UIKeyboardTypePhonePad;
    [self.view addSubview:self.telTF];
    self.codeTF = [UITextField new];
    self.codeTF.textColor = [GTColor gtColorC4];
    self.codeTF.font = [GTFont gtFontF2];
    self.codeTF.placeholder = @"请输入验证码";
    self.codeTF.keyboardType = UIKeyboardTypePhonePad;
    [self.view addSubview:self.codeTF];
    self.passWordTF = [UITextField new];
    self.passWordTF.textColor = [GTColor gtColorC4];
    self.passWordTF.font = [GTFont gtFontF2];
    self.passWordTF.placeholder = @"请输入6-16位密码";
    self.passWordTF.secureTextEntry = YES;
    [self.view addSubview:self.passWordTF];
    self.verifyPwdTF = [UITextField new];
    self.verifyPwdTF.textColor = [GTColor gtColorC4];
    self.verifyPwdTF.font = [GTFont gtFontF2];
    self.verifyPwdTF.placeholder = @"重复密码";
    self.verifyPwdTF.secureTextEntry = YES;
    [self.view addSubview:self.verifyPwdTF];
    
    self.line1 = [UIView new];
    self.line1.backgroundColor = [GTColor gtColorC8];
    [self.view addSubview:self.line1];
    self.line2 = [UIView new];
    self.line2.backgroundColor = [GTColor gtColorC8];
    [self.view addSubview:self.line2];
    self.line3 = [UIView new];
    self.line3.backgroundColor = [GTColor gtColorC8];
    [self.view addSubview:self.line3];
    self.line4 = [UIView new];
    self.line4.backgroundColor = [GTColor gtColorC8];
    [self.view addSubview:self.line4];
    
    self.codeBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [self.codeBtn setTitle:@"发送验证码" forState:UIControlStateNormal];
    [self.codeBtn setTitleColor:[GTColor gtBtnColorC] forState:UIControlStateNormal];
    self.codeBtn.titleLabel.font = [GTFont gtFontF2];
    self.codeBtn.layer.cornerRadius = 5;
    self.codeBtn.layer.masksToBounds = YES;
    [self.codeBtn setBackgroundImage:[UIImage initWithColor:[GTColor gtColorC1]] forState:UIControlStateNormal];
    [self.view addSubview:self.codeBtn];
    [self.codeBtn addTarget:self action:@selector(codebtnAction) forControlEvents:UIControlEventTouchUpInside];
    
    self.selectBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [self.selectBtn setImage:[UIImage imageNamed:@"disagree"] forState:UIControlStateNormal];
    [self.selectBtn setImage:[UIImage imageNamed:@"agree"] forState:UIControlStateSelected];
    [self.selectBtn setAdjustsImageWhenHighlighted:NO];
    [self.selectBtn addTarget:self action:@selector(selectbtnAction:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:self.selectBtn];
    self.selectBtn.selected = YES;
    
    self.userAgreement = [UILabel new];
    self.userAgreement.text = @"我已阅读并同意 用户注册协议";
    self.userAgreement.textColor = [GTColor gtColorC6];
    self.userAgreement.font = [GTFont gtFontF3];
    NSRange range = [self.userAgreement.text rangeOfString:@"用户注册协议"];
    [self setTextColor:self.userAgreement AndRange:range AndColor:[GTColor gtColorUserAgreementBlue]];
    [self.view addSubview:self.userAgreement];
    self.userAgreement.userInteractionEnabled = YES;
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(userAgreementAction)];  
    [self.userAgreement addGestureRecognizer:tap];
    
    self.registerBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [self.registerBtn setBackgroundImage:[UIImage initWithColor:[GTColor gtColorC1]] forState:UIControlStateNormal];
    
    self.registerBtn.enabled = YES;
    self.registerBtn.layer.cornerRadius = 5;
    self.registerBtn.layer.masksToBounds = YES;
    [self.registerBtn setTitle:@"注  册" forState:UIControlStateNormal];
    self.registerBtn.titleLabel.font = [GTFont gtFontF1];
    [self.registerBtn setTitleColor:[GTColor gtBtnColorC] forState:UIControlStateNormal];
    [self.registerBtn addTarget:self action:@selector(registerBtnAction) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:self.registerBtn];
    
    [self setLayout];
}

-(void)setLayout
{
    [self.telIcon mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(self.view).offset(autoScaleW(42));
        make.top.mas_equalTo(self.view).offset(autoScaleH(43));
        make.size.mas_equalTo(CGSizeMake(autoScaleW(16), autoScaleH(16)));
    }];
    [self.telTF mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(self.telIcon.mas_right).offset(autoScaleW(12));
        make.top.mas_equalTo(self.view).offset(autoScaleH(42));
        make.right.mas_equalTo(self.view).offset(autoScaleW(-30));
        make.height.mas_equalTo(autoScaleH(18));
    }];
    [self.line1 mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(self.view).offset(autoScaleW(30));
        make.top.mas_equalTo(self.telIcon.mas_bottom).offset(autoScaleH(13));
        make.right.equalTo(self.telTF);
        make.height.mas_equalTo(autoScaleH(1));
    }];
    [self.codeIcon mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(self.telIcon);
        make.top.mas_equalTo(self.line1.mas_bottom).offset(autoScaleH(27));
        make.size.mas_equalTo(CGSizeMake(autoScaleW(16), autoScaleH(16)));
    }];
    [self.codeTF mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.telTF);
        make.top.mas_equalTo(self.line1.mas_bottom).offset(autoScaleH(25));
        make.right.mas_equalTo(self.codeBtn.mas_left).offset(autoScaleW(-15));
        make.height.equalTo(self.telTF);
    }];
    [self.codeBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(self.line1.mas_bottom).offset(autoScaleH(15));
        make.right.equalTo(self.line1);
        make.bottom.equalTo(self.line2);
        make.width.mas_equalTo(autoScaleW(110));
    }];
    [self.line2 mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.line1);
        make.top.mas_equalTo(self.codeIcon.mas_bottom).offset(autoScaleH(11));
        make.right.mas_equalTo(self.codeBtn.mas_left).offset(autoScaleW(-15));
        make.height.equalTo(self.line1);
    }];
    [self.passWordIcon mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.codeIcon);
        make.top.mas_equalTo(self.line2.mas_bottom).offset(autoScaleH(25));
        make.size.mas_equalTo(CGSizeMake(autoScaleW(16), autoScaleH(16)));
    }];
    [self.passWordTF mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.telTF);
        make.top.mas_equalTo(self.line2.mas_bottom).offset(autoScaleH(23));
        make.right.equalTo(self.line1);
        make.height.equalTo(self.telTF);
    }];
    [self.line3 mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.line1);
        make.top.mas_equalTo(self.passWordIcon.mas_bottom).offset(autoScaleH(13));
        make.right.equalTo(self.line1);
        make.height.equalTo(self.line1);
    }];
    [self.verifyPwdIcon mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.passWordIcon);
        make.top.mas_equalTo(self.line3.mas_bottom).offset(autoScaleH(25));
        make.size.equalTo(self.passWordIcon);
    }];
    [self.verifyPwdTF mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.telTF);
        make.top.mas_equalTo(self.line3.mas_bottom).offset(autoScaleH(23));
        make.right.equalTo(self.line1);
        make.height.equalTo(self.telTF);
    }];
    [self.line4 mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.line1);
        make.top.mas_equalTo(self.verifyPwdIcon.mas_bottom).offset(autoScaleH(13));
        make.right.equalTo(self.line1);
        make.height.equalTo(self.line1);
    }];
    [self.selectBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(self.view).offset(autoScaleW(34));
        make.top.mas_equalTo(self.line4.mas_bottom).offset(autoScaleH(35));
        make.size.mas_equalTo(CGSizeMake(autoScaleW(30), autoScaleH(30)));
    }];
    [self.userAgreement mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(self.selectBtn.mas_right).offset(autoScaleW(3));
        make.top.mas_equalTo(self.line4.mas_bottom).offset(autoScaleH(41));
        make.size.mas_equalTo(CGSizeMake(autoScaleW(220), autoScaleH(16)));
    }];
    [self.registerBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.line4);
        make.top.mas_equalTo(self.userAgreement.mas_bottom).offset(autoScaleH(24));
        make.right.equalTo(self.line4);
        make.height.mas_equalTo(autoScaleH(50));
    }];
}
-(void)codebtnAction
{
    [self postCode];
}
-(void)selectbtnAction:(UIButton *)btn
{
    if (btn.selected) {
        btn.selected = NO;
        self.registerBtn.backgroundColor = [GTColor gtColorC7];
        self.registerBtn.enabled = NO;
        [self.registerBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];

    }else
    {
        btn.selected = YES;
        self.registerBtn.backgroundColor = [GTColor gtColorC1];
        self.registerBtn.enabled = YES;
        [self.registerBtn setTitleColor:[GTColor gtColorC4] forState:UIControlStateNormal];

    }
}
-(void)registerBtnAction
{
    [self postRegisteUser];
}
-(void)postRegisteUser
{
    if (![GTVerification checkTelNumber:_telTF.text]) {
        [GTHUD showErrorWithTitle:@"手机格式不正确！"];
        return;
    }
    if (_codeTF.text.length < 4) {
        [GTHUD showErrorWithTitle:@"请输入完整验证码至少为4位！"];
        return;
    }
    if (![GTVerification checkPwdNumber:_passWordTF.text]) {
        [GTHUD showErrorWithTitle:@"密码格式不正确！"];
        return;
    }
    if (![_passWordTF.text isEqualToString:_verifyPwdTF.text]) {
        [GTHUD showErrorWithTitle:@"两次密码输入不一致！"];
        return;
    }
    
    self.registerBtn.enabled = NO;
    GTReqModelLogin *model = [[GTReqModelLogin alloc] init]; // 请求model 暂定为 GTReqModelLogin 需要参数 自定义 添加
    model.interId = GTApiCode.registerAppCust;  // 接口编号 在GTApiCode 中定义,要自己定义
    model.phoneNo = self.telTF.text;
    model.verificationCode = _codeTF.text;
    model.password = [GTSecUtils pwdAddSaltWithPhone:_telTF.text pwd:_passWordTF.text];

    
    // 注册
    WEAKSELF
    [GTHUD showStatusWithTitle:@"注册中..."];
    [[GTLoginService sharedInstance] loginWithReqModel:model succ:^(GTResModelUserInfo * _Nullable resModel) {
        
        self.registerBtn.enabled = YES;
        [GTHUD showSuccessWithTitle:@"注册成功！"];
        [weakSelf.navigationController dismissViewControllerAnimated:YES completion:nil];
    } fail:^(GTNetError * _Nullable error) {
        
        [GTHUD showErrorWithTitle:[NSString stringWithFormat:@"%@",error.msg]];
        self.registerBtn.enabled = YES;
    }];
//    [[GTApi requestParams:dict andResmodel:[GTResModelUserInfo class] andAuthStatus:nil]
//     subscribeNext:^(GTResModelUserInfo*  _Nullable resModel) {
//         self.registerBtn.enabled = YES;
//         // model.message
//         GTLog(@"注册请求内容:\n%@",[model yy_modelToJSONObject]);
//         [GTHUD showSuccessWithStr:@"注册成功！"];
//         [weakSelf.navigationController dismissViewControllerAnimated:YES completion:nil];
//         
//         GTUser.manger.userInfoModel = resModel;
//         //缓存数据
//         [GTUser loginUserWithPhone:model.phoneNo cusId:resModel.custId token:resModel.token];
//         
//     } error:^(NSError * _Nullable error) {
//         
//         GTNetError *err = (GTNetError *) error;
//         GTLog(@"#####%@", err);
//         [GTHUD showErrorWithStr:[NSString stringWithFormat:@"%@",err.msg]];
//         self.registerBtn.enabled = YES;
//
//     }];

}
-(void)postCode
{

    if (![GTVerification checkTelNumber:_telTF.text]) {
        [GTHUD showErrorWithTitle:@"手机格式不正确！"];
        return;
    }
    
    self.codeBtn.enabled = NO;
    
    GTReqModelLogin *model = [[GTReqModelLogin alloc] init]; // 请求model 暂定为 GTReqModelLogin 需要参数 自定义 添加
    model.interId = GTApiCode.getVerificationCode;  // 接口编号 在GTApiCode 中定义,要自己定义
    model.type = @1;
    model.phoneNo = self.telTF.text;
    
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

//设置不同字体颜色
-(void)setTextColor:(UILabel *)label AndRange:(NSRange)range AndColor:(UIColor *)vaColor
{
    NSMutableAttributedString *str = [[NSMutableAttributedString alloc] initWithString:label.text];
    //设置文字颜色
    [str addAttribute:NSForegroundColorAttributeName value:vaColor range:range];
    
    label.attributedText = str;
}
-(void)userAgreementAction
{
//    [self.navigationController pushViewController:[[GTWKWebVC alloc]initWithUrlStr:USERAGREEMENT] animated:YES];
    [self.navigationController pushViewController:[GTUserAgreementController new] animated:YES];
}
-(void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event
{
    [self.telTF resignFirstResponder];
    [self.codeTF resignFirstResponder];
    [self.passWordTF resignFirstResponder];
    [self.verifyPwdTF resignFirstResponder];
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
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

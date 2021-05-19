//
//  GTLoginView.m
//  GoldTreasure
//
//  Created by 王超 on 2017/6/28.
//  Copyright © 2017年 zhaofanjinrong.com. All rights reserved.
//

#import "GTLoginView.h"
#import <Masonry/Masonry.h>

@interface GTLoginView ()

@property (nonatomic, strong) UIImageView *bgImage;
@property (nonatomic, strong) UIImageView *logoImage;
@property (nonatomic, strong) UIImageView *telIcon;
@property (nonatomic, strong) UITextField *telTF;
@property (nonatomic, strong) UIView *line1;
@property (nonatomic, strong) UIView *inputBGView;
@property (nonatomic, strong) UIImageView *passWordIcon;
@property (nonatomic, strong) UITextField *passWordTF;
//@property (nonatomic, strong) UIView *line2;
@property (nonatomic, strong) UIButton *loginBtn;
@property (nonatomic, strong) UIButton *registerBtn;
@property (nonatomic, strong) UIButton *passWordBtn;
@property (nonatomic, strong) UIView *line3;
//@property (nonatomic, strong) UIButton *dismissBtn;

@end

@implementation GTLoginView

-(instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        [self createView];
    }
    return self;
}

-(void)createView
{
    self.bgImage = [UIImageView new];
    self.bgImage.userInteractionEnabled = YES;
    [self addSubview:self.bgImage];
    self.bgImage.image = [UIImage imageNamed:@"bg-login"];
    
    //    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(dismissKeyboard)];
//        [self.bgImage addGestureRecognizer:tap];
    
    self.logoImage = [UIImageView new];
    self.logoImage.userInteractionEnabled = YES;
    [self addSubview:self.logoImage];
    self.logoImage.image = [UIImage imageNamed:@"logoword"];
    
    self.inputBGView = [UIView new];
    self.inputBGView.backgroundColor = [UIColor whiteColor];
    self.inputBGView.layer.cornerRadius = 5;
    self.inputBGView.layer.masksToBounds = YES;
    [self addSubview:self.inputBGView];
    
    
    self.telIcon = [[UIImageView alloc]initWithImage:[UIImage imageNamed:@"user"]];
    self.telIcon.userInteractionEnabled = YES;
    [self.inputBGView addSubview:self.telIcon];
//    self.telIcon.image = [UIImage imageNamed:@"user"];
    
    self.passWordIcon = [[UIImageView alloc]initWithImage:[UIImage imageNamed:@"passwprd_s"]];
    self.passWordIcon.userInteractionEnabled = YES;
    [self.inputBGView addSubview:self.passWordIcon];
//    self.passWordIcon.image = [UIImage imageNamed:@"passwprd_s"];
    
    self.telTF = [UITextField new];
    self.telIcon.backgroundColor = [UIColor whiteColor];
    self.telTF.textColor = [GTColor gtColorC4];
    self.telTF.font = [GTFont gtFontF2];
    self.telTF.placeholder = @"请输入手机号码";
    self.telTF.keyboardType = UIKeyboardTypePhonePad;
    self.telTF.clearButtonMode = UITextFieldViewModeWhileEditing;
    [self.telTF setValue:[GTColor gtColorC7] forKeyPath:@"_placeholderLabel.textColor"];
//    self.telTF.leftView = self.telIcon;
//    self.telTF.leftViewMode = UITextFieldViewModeAlways;
    
    [self.inputBGView addSubview:self.telTF];
    
    self.passWordTF = [UITextField new];
    self.telIcon.backgroundColor = [UIColor whiteColor];
    self.passWordTF.textColor = [GTColor gtColorC4];
    self.passWordTF.font = [GTFont gtFontF2];
    self.passWordTF.placeholder = @"请输入密码";
    self.passWordTF.clearButtonMode = UITextFieldViewModeWhileEditing;
    self.passWordTF.secureTextEntry = YES;
    [self.passWordTF setValue:[GTColor gtColorC7] forKeyPath:@"_placeholderLabel.textColor"];
//    self.passWordTF.leftView = self.passWordIcon;
//    self.passWordTF.leftViewMode = UITextFieldViewModeAlways;
    [self.inputBGView addSubview:self.passWordTF];
    
    self.line1 = [UIView new];
    self.line1.backgroundColor = [GTColor gtColorC8];
    [self.inputBGView addSubview:self.line1];
    
//    self.line2 = [UIView new];
//    self.line2.backgroundColor = [GTColor gtColorC8];
//    [self addSubview:self.line2];
    self.line3 = [UIView new];
    self.line3.backgroundColor = [GTColor gtColorC6];
    [self addSubview:self.line3];
    
    self.loginBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    self.loginBtn.backgroundColor = [GTColor gtColorC1];
    
    [self.loginBtn setTitleColor:[UIColor blackColor] forState:UIControlStateDisabled];
    
    [self.loginBtn setTitleColor:[GTColor gtBtnColorC] forState:UIControlStateNormal];
    
    [self.loginBtn setBackgroundImage:[UIImage initWithColor:[GTColor gtColorC1]] forState:UIControlStateNormal];
    [self.loginBtn setBackgroundImage:[UIImage initWithColor:[GTColor gtBtnBackColorC]] forState:UIControlStateDisabled];
    

    self.loginBtn.layer.cornerRadius = 5;
    self.loginBtn.layer.masksToBounds = YES;
    [self.loginBtn setTitle:@"登  录" forState:UIControlStateNormal];
    self.loginBtn.titleLabel.font = [GTFont gtFontF1];
    [self.loginBtn addTarget:self action:@selector(loginBtnAction) forControlEvents:UIControlEventTouchUpInside];
    [self addSubview:self.loginBtn];
    
    self.registerBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [self.registerBtn setTitle:@"立即注册" forState:UIControlStateNormal];
    [self.registerBtn setTitleColor:[GTColor gtBtnColorC] forState:UIControlStateNormal];
    self.registerBtn.titleLabel.font = [GTFont gtFontF2];
    [self.registerBtn addTarget:self action:@selector(registerBtnAction) forControlEvents:UIControlEventTouchUpInside];
    [self addSubview:self.registerBtn];
    
    self.passWordBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [self.passWordBtn setTitle:@"忘记密码" forState:UIControlStateNormal];
    [self.passWordBtn setTitleColor:[GTColor gtBtnColorC] forState:UIControlStateNormal];
    self.passWordBtn.titleLabel.font = [GTFont gtFontF2];
    [self.passWordBtn addTarget:self action:@selector(passWordBtnAction) forControlEvents:UIControlEventTouchUpInside];
    [self addSubview:self.passWordBtn];
    
    
    // 文本框校验操作
    WEAKSELF
    RACSignal *phoneSignal = [[_telTF rac_textSignal] filter:^BOOL(NSString * _Nullable value) {
        
        if (value.length > 11) {
            weakSelf.telTF.text = [value substringToIndex:11];
        }
        if (!value) { return false; }
        return true;
    }];
    
    RACSignal *pwdSignal = [[_passWordTF rac_textSignal] filter:^BOOL(NSString * _Nullable value) {
        
        if (!value) { return false; }
        return true;
    }];
    
    RACSignal *allSignal = [RACSignal combineLatest:@[phoneSignal,pwdSignal]];
    
    RAC(_loginBtn,enabled) = [allSignal map:^id _Nullable(RACTuple  *_Nullable x) {
        
        NSString *pwd = (NSString *)x[1];
        if ([x[0] isEqual:@""] || pwd.length < 6 ) {
            
            return @(false);
        } else {
            return @(true);
        }
    }];

    
    
    //    self.dismissBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    //    [self.dismissBtn setImage:[UIImage imageNamed:@"close_white"] forState:UIControlStateNormal];
    //    [self addSubview:self.dismissBtn];
    //    [self.dismissBtn addTarget:self action:@selector(dimissView) forControlEvents:UIControlEventTouchUpInside];
}
-(void)layoutSubviews
{
    [super layoutSubviews];
    
    [self.bgImage mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(self);
    }];
    [self.logoImage mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(self);
        make.top.mas_equalTo(self).offset(20);
        make.size.mas_equalTo(CGSizeMake(100, 30));
    }];
    
    [self.inputBGView mas_makeConstraints:^(MASConstraintMaker *make) {
         make.centerX.equalTo(self);
        make.top.mas_equalTo(self).offset(autoScaleH(131));
        make.left.mas_equalTo(self).offset(30);
        make.right.mas_equalTo(self).offset(-30);
        make.height.mas_equalTo(111);
    }];

    [self.telIcon mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(self.inputBGView).offset(5);
        make.top.mas_equalTo(self.inputBGView).offset(22);
        make.size.mas_equalTo(CGSizeMake(16, 16));
    }];
    [self.telTF mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(self.telIcon.mas_right).offset(7);
        make.top.mas_equalTo(self.inputBGView).offset(5);
        make.right.mas_equalTo(self.inputBGView);
        make.height.mas_equalTo(50);
    }];
    [self.line1 mas_makeConstraints:^(MASConstraintMaker *make) {
//        make.left.mas_equalTo(self).offset(autoScaleW(30));
//        make.top.mas_equalTo(self.telTF.mas_bottom).offset(autoScaleH(13));
//        make.right.equalTo(self.telTF);
        make.center.equalTo(self.inputBGView);
        make.width.mas_equalTo(self.inputBGView);
        make.height.mas_equalTo(1);
    }];
    [self.passWordIcon mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.telIcon);
        make.top.mas_equalTo(self.line1.mas_bottom).offset(22);
        make.size.equalTo(self.telIcon);
    }];
    [self.passWordTF mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(self.telTF);
        make.bottom.mas_equalTo(self.inputBGView.mas_bottom);
        make.right.equalTo(self.telTF);
        make.height.equalTo(self.telTF);
    }];
//    [self.line2 mas_makeConstraints:^(MASConstraintMaker *make) {
//        make.left.equalTo(self.line1);
//        make.top.mas_equalTo(self.passWordTF.mas_bottom).offset(autoScaleH(13));
//        make.right.equalTo(self.line1);
//        make.height.equalTo(self.line1);
//    }];
    [self.loginBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(self.inputBGView);
        make.top.mas_equalTo(self.inputBGView.mas_bottom).offset(autoScaleH(20));
        make.right.equalTo(self.inputBGView);
        make.height.mas_equalTo(autoScaleH(50));
    }];
    [self.line3 mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(self);
        make.top.mas_equalTo(self.loginBtn.mas_bottom).offset(autoScaleH(20));
        make.size.mas_equalTo(CGSizeMake(autoScaleW(1), autoScaleH(20)));
    }];
    [self.registerBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(self.loginBtn.mas_bottom).offset(autoScaleH(21));
        make.right.mas_equalTo(self.line3.mas_left).offset(autoScaleW(-40));
        make.size.mas_equalTo(CGSizeMake(autoScaleW(70), autoScaleH(18)));
    }];
    [self.passWordBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.registerBtn);
        make.left.mas_equalTo(self.line3.mas_right).offset(autoScaleW(40));
        make.size.equalTo(self.registerBtn);
    }];
    //    [self.dismissBtn mas_makeConstraints:^(MASConstraintMaker *make) {
    //        make.top.mas_equalTo(self).offset(32);
    //        make.left.mas_equalTo(self).offset(15);
    //        make.size.mas_equalTo(CGSizeMake(30, 30));
    //    }];
    
    
    
    //    [[_passWordTF.rac_textSignal map:^id _Nullable(NSString * _Nullable value) {
    //
    //
    //
    //        return @"dfadf";
    //    }] subscribeNext:^(id  _Nullable x) {
    //
    //        GTLog(@"%@",x)
    //    }];
}
-(void)loginBtnAction {
    
    if (self.login) {
        self.login(_telTF.text, _passWordTF.text,_loginBtn);
    }
}

-(void)registerBtnAction {
    
    if (self.registerVC) {
        self.registerVC();
    }
    
}
-(void)passWordBtnAction {
    if (self.passWordVC) {
        self.passWordVC();
    }
    
}
//-(void)dimissView
//{
//    self.dismissVC();
//}
//-(void)dismissKeyboard
//{
//    if ([self.telTF isFirstResponder]) {
//
//        [self.telTF resignFirstResponder];
//    }else if ([self.passWordTF isFirstResponder])
//    {
//        [self.passWordTF resignFirstResponder];
//    }
//}
@end

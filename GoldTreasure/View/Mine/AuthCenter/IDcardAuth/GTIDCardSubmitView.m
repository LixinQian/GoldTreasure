 //
//  GTIDCardSubmitView.m
//  GoldTreasure
//
//  Created by wangyaxu on 29/06/2017.
//  Copyright © 2017 zhaofanjinrong.com. All rights reserved.
//

#import "GTIDCardSubmitView.h"
#import "GTLabelTextFieldView.h"
#import "GTContactUsBarView.h"
#import "GTVerification.h"

#import <Masonry/Masonry.h>

@interface GTIDCardSubmitView ()

@property (nonatomic, strong) UIImageView *frontImageView;
@property (nonatomic, strong) UIImageView *backImageView;
@property (nonatomic, strong) UIImageView *fullImageView;

@property (nonatomic, strong) GTLabelTextFieldView *nameTF;
@property (nonatomic, strong) GTLabelTextFieldView *idCardTF;

@property (nonatomic, strong) UIImage *frontImage;
@property (nonatomic, strong) UIImage *backImage;
@property (nonatomic, strong) UIImage *fullImage;

@property (nonatomic, strong) UIButton *submitBtn;

@end

@implementation GTIDCardSubmitView

- (instancetype)init
{
    self = [super init];
    if (self) {
        [self setup];
        _imagesCount = 0;
        UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(handleTap)];
        [self addGestureRecognizer:tap];
    }
    return self;
}

- (void)setup
{
    //add things to content view
    UIScrollView *scrollView = [UIScrollView new];
    scrollView.contentInset = UIEdgeInsetsMake(15, 0, 0, 0);
    scrollView.showsVerticalScrollIndicator = NO;
    scrollView.showsHorizontalScrollIndicator = NO;
    
    UIView *contentView = [UIView new];
    
    UIView *inputView = [self addInputView];

    UIView *takePhotoView = [self addTakePhotoView];
    
    UILabel *tipLabel = [UILabel labelWithFont:[GTFont gtFontF3] textColor:[GTColor gtColorC6] text:@"实名人工认证一般在一至两个工作日内认证完毕。\n认证时间：9:00-18:00（周一至周日）\n如有疑问，请联系客服："];
    tipLabel.numberOfLines = 0;
    
    GTContactUsBarView *barView = [[GTContactUsBarView alloc] initWithBarMode:ContactUsBarRegular];
    
    UIButton *submitBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    self.submitBtn = submitBtn;
    [submitBtn setBackgroundColor:[GTColor gtColorC1]];
    submitBtn.titleLabel.font = [GTFont gtFontF1];
    [submitBtn setTitleColor:[GTColor gtColorC4] forState:UIControlStateNormal];
    submitBtn.layer.cornerRadius = 5;
    [submitBtn setTitle:@"提交审核" forState:UIControlStateNormal];
    [submitBtn addTarget:self action:@selector(clickSubmitBtn:) forControlEvents:UIControlEventTouchUpInside];

    [self addSubview:scrollView];
    [scrollView addSubview:contentView];
    [contentView addSubview:inputView];
    [contentView addSubview:takePhotoView];
    [contentView addSubview:tipLabel];
    [contentView addSubview:barView];
    [contentView addSubview:submitBtn];
    
    {
        [scrollView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.edges.equalTo(self);
        }];
        
        [contentView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.edges.equalTo(scrollView);
            make.width.equalTo(scrollView);
        }];
        
        [inputView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.right.and.top.equalTo(contentView);
            make.height.equalTo(@100);
        }];
        
        [takePhotoView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.right.equalTo(contentView);
            make.top.equalTo(inputView.mas_bottom).with.offset(15);
        }];
        
        [tipLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(takePhotoView.mas_bottom).with.offset(10);
            make.left.equalTo(contentView.mas_left).with.offset(15);
            make.right.equalTo(contentView.mas_right).with.offset(-15);
        }];
        
        [barView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.right.equalTo(contentView);
            make.top.equalTo(tipLabel.mas_bottom).with.offset(5);
        }];
        
        [submitBtn mas_makeConstraints:^(MASConstraintMaker *make) {
            make.height.equalTo(@50);
            make.top.equalTo(barView.mas_bottom).with.offset(20);
            make.left.equalTo(contentView.mas_left).with.offset(15);
            make.right.equalTo(contentView.mas_right).with.offset(-15);
            make.bottom.equalTo(contentView.mas_bottom).with.offset(-25);
        }];
    }
    
}

- (UIView *)addInputView
{
    UIView *backgoundView = [UIView new];
    backgoundView.backgroundColor = [UIColor whiteColor];
    [self addSubview:backgoundView];

    self.nameTF = [GTLabelTextFieldView new];
    [self.nameTF setTitle:@"姓名" placeHolder:@"请填写真实姓名"];
    
    self.idCardTF = [GTLabelTextFieldView new];
    [self.idCardTF setTitle:@"身份证号" placeHolder:@"请填写身份证号码"];
    [self.idCardTF shouldHideSeparatorLine:YES];
    
    [backgoundView addSubview:self.nameTF];
    [backgoundView addSubview:self.idCardTF];

    {
        [self.nameTF mas_makeConstraints:^(MASConstraintMaker *make) {
            make.height.equalTo(@50);
            make.left.right.and.top.equalTo(backgoundView);
        }];
        
        [self.idCardTF mas_makeConstraints:^(MASConstraintMaker *make) {
            make.height.equalTo(@50);
            make.top.equalTo(self.nameTF.mas_bottom);
            make.left.right.and.bottom.equalTo(backgoundView);
        }];
    }
    
    return backgoundView;
}

- (UIView *)addTakePhotoView
{
    UIView *backgroundView = [UIView new];
    backgroundView.backgroundColor = [UIColor whiteColor];
    [self addSubview:backgroundView];

    UILabel *titleLabel = [UILabel labelWithFont:[GTFont gtFontF2] textColor:[GTColor gtColorC4] text:@"需要您提交以下照片，以验证您的身份"];
    
    UIView *line = [UIView new];
    line.backgroundColor = [GTColor gtColorC15];
    
    UILabel *tipLabel = [UILabel labelWithFont:[GTFont gtFontF2] textColor:[GTColor gtColorC4] text:@"拍摄二代身份证正反面照片"];

    self.frontImageView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"id_positive"]];
    self.frontImageView.userInteractionEnabled = YES;
    self.frontImageView.contentMode = UIViewContentModeScaleAspectFit;

    self.backImageView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"id_negative"]];
    self.backImageView.contentMode = UIViewContentModeScaleAspectFit;

    UILabel *tip2Label = [UILabel labelWithFont:[GTFont gtFontF2] textColor:[GTColor gtColorC4] text:@"拍摄本人手持身份证照片"];

    UILabel *subTipLabel = [UILabel labelWithFont:[GTFont gtFontF3] textColor:[GTColor gtColorC6] text:@"要求：清晰的手持人上半身照片\n且手持的身份证号码清晰"];
    subTipLabel.numberOfLines = 0;
    
    self.fullImageView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"id_half"]];
    self.fullImageView.contentMode = UIViewContentModeScaleAspectFit;

    UIButton *frontBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    UIButton *backBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    UIButton *halfBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [frontBtn setBackgroundImage:[UIImage imageNamed:@"photograph_border"] forState:UIControlStateNormal];
    [backBtn setBackgroundImage:[UIImage imageNamed:@"photograph_border"] forState:UIControlStateNormal];
    [halfBtn setBackgroundImage:[UIImage imageNamed:@"photograph_border"] forState:UIControlStateNormal];
    [frontBtn addTarget:self action:@selector(clickTakePhotoBtn:) forControlEvents:UIControlEventTouchUpInside];
    [backBtn addTarget:self action:@selector(clickTakePhotoBtn:) forControlEvents:UIControlEventTouchUpInside];
    [halfBtn addTarget:self action:@selector(clickTakePhotoBtn:) forControlEvents:UIControlEventTouchUpInside];
    
    UILabel *frontLabel = [UILabel labelWithFont:[GTFont gtFontF4] textColor:[GTColor gtColorC6] text:@"拍摄正面照片"];
    UILabel *backLabel = [UILabel labelWithFont:[GTFont gtFontF4] textColor:[GTColor gtColorC6] text:@"拍摄反面照片"];
    UILabel *halfLabel = [UILabel labelWithFont:[GTFont gtFontF4] textColor:[GTColor gtColorC6] text:@"点击拍摄"];
    
    [backgroundView addSubview:titleLabel];
    [backgroundView addSubview:line];
    [backgroundView addSubview:tipLabel];
    [backgroundView addSubview:self.frontImageView];
    [backgroundView addSubview:self.backImageView];
    [backgroundView addSubview:tip2Label];
    [backgroundView addSubview:subTipLabel];
    [backgroundView addSubview:self.fullImageView];
    [self.frontImageView addSubview:frontBtn];
    [self.frontImageView addSubview:frontLabel];
    [self.backImageView addSubview:backBtn];
    [self.backImageView addSubview:backLabel];
    [self.fullImageView addSubview:halfBtn];
    [self.fullImageView addSubview:halfLabel];

    {
        [titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(backgroundView.mas_top).with.offset(15);
            make.centerX.equalTo(backgroundView.mas_centerX);
        }];
        
        [line mas_makeConstraints:^(MASConstraintMaker *make) {
            make.height.equalTo(@.5f);
            make.top.equalTo(backgroundView).with.offset(50);
            make.left.equalTo(backgroundView.mas_left).with.offset(15);
            make.right.equalTo(backgroundView.mas_right).with.offset(-15);
        }];
        
        [tipLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(line.mas_bottom).with.offset(15);
            make.left.equalTo(backgroundView.mas_left).with.offset(15);
        }];
        
        [self.frontImageView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(line.mas_bottom).with.offset(50);
            make.left.equalTo(backgroundView.mas_left).with.offset(15);
            make.width.mas_equalTo(self.frontImageView.mas_height).with.multipliedBy(160.0 / 100);
        }];
        
        [self.backImageView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(self.frontImageView.mas_top);
            make.left.equalTo(self.frontImageView.mas_right).with.offset(25);
            make.right.equalTo(backgroundView.mas_right).with.offset(-15);
            make.size.equalTo(self.frontImageView);
        }];
        
        [tip2Label mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(self.frontImageView.mas_bottom).with.offset(20);
            make.left.equalTo(backgroundView.mas_left).with.offset(15);
        }];
        
        [subTipLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(tip2Label.mas_bottom).with.offset(10);
            make.left.equalTo(backgroundView.mas_left).with.offset(15);
        }];
        
        [self.fullImageView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(subTipLabel.mas_bottom).with.offset(10);
            make.left.equalTo(backgroundView.mas_left).with.offset(15);
            make.right.equalTo(backgroundView.mas_right).with.offset(-15);
            make.width.mas_equalTo(self.fullImageView.mas_height).with.multipliedBy(345.0 / 200);
            make.bottom.equalTo(backgroundView.mas_bottom).with.offset(-20);
        }];
        
        [frontBtn mas_makeConstraints:^(MASConstraintMaker *make) {
            make.center.equalTo(self.frontImageView);
            make.width.equalTo(self.frontImageView.mas_width).with.multipliedBy(.5f);
            make.height.equalTo(self.frontImageView.mas_height).with.multipliedBy(.5f);
        }];
        
        [frontLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(frontBtn.mas_bottom).with.offset(4);
            make.centerX.equalTo(self.frontImageView);
        }];
        
        [backBtn mas_makeConstraints:^(MASConstraintMaker *make) {
            make.center.equalTo(self.backImageView);
            make.size.equalTo(frontBtn);
        }];
        
        [backLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(backBtn.mas_bottom).with.offset(4);
            make.centerX.equalTo(self.backImageView);
        }];
        
        [halfBtn mas_makeConstraints:^(MASConstraintMaker *make) {
            make.center.equalTo(self.fullImageView);
            make.size.equalTo(frontBtn);
        }];
        
        [halfLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerX.equalTo(self.fullImageView);
            make.bottom.equalTo(self.fullImageView.mas_bottom).with.offset(-15);
        }];
    }
    
    return backgroundView;
}

- (void)setFrontImage:(UIImage *)image
{
    _frontImage = image;
    [self.frontImageView.subviews makeObjectsPerformSelector:@selector(removeFromSuperview)];
    self.frontImageView.image = image;
    self.backImageView.userInteractionEnabled = YES;
}

- (void)setBackImage:(UIImage *)image
{
    _backImage = image;
    [self.backImageView.subviews makeObjectsPerformSelector:@selector(removeFromSuperview)];
    self.backImageView.image = image;
    self.fullImageView.userInteractionEnabled = YES;
}

- (void)setFullImage:(UIImage *)image
{
    _fullImage = image;
    [self.fullImageView.subviews makeObjectsPerformSelector:@selector(removeFromSuperview)];
    self.fullImageView.image = image;
}

- (void)setSubmitBtnEnabled:(BOOL )enabled
{
    self.submitBtn.userInteractionEnabled = enabled;
}

- (void)handleTap
{
    [self endEditing:YES];
}

- (void)clickTakePhotoBtn:(UIButton *)sender
{
    [self handleTap];
    self.takePhotoBlock();
}

- (void)clickSubmitBtn:(UIButton *)sender
{
    //校验姓名，身份证号
    NSString *name = [self.nameTF getTextFieldText];
    
    if (![GTVerification isValidateChinese:name]) {
        //如果姓名不全为汉字
        [GTHUD showToastWithInfo:@"姓名必须为汉字"];
        return;
    }
    
    NSString *idCardNumber = [self.idCardTF getTextFieldText];
    
    if (![GTVerification checkIdCardNumber:idCardNumber]) {
        //身份证位数不合法
        [GTHUD showToastWithInfo:@"身份证号不合法"];
        return;
    }
    
    if (!self.frontImage || !self.backImage || !self.fullImage) {
        [GTHUD showToastWithInfo:@"身份证照片不完整"];
        return;
    }
    [self handleTap];
    self.submitBlock(name, idCardNumber, self.frontImage, self.backImage, self.fullImage);
}

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end

//
//  GTShowSignature.m
//  GoldTreasure
//
//  Created by 王超 on 2017/7/5.
//  Copyright © 2017年 zhaofanjinrong.com. All rights reserved.
//

#import "GTShowSignature.h"

@interface GTShowSignature ()

//返回按钮
@property (nonatomic, strong) UIButton *backBtn;
//重签
@property (nonatomic, strong) UIButton *cleanBtn;

//白色背景
@property (nonatomic, strong) UIView *bgView;
//签名板
@property (nonatomic, strong) GTSignatureView *signature;

@end

@implementation GTShowSignature

-(instancetype)init
{
    self = [super init];
    if (self) {
        
        self.backgroundColor = [UIColor colorWithRed:0 green:0 blue:0 alpha:0.6];
        self.frame = CGRectMake(0, 0, ScreenWidth, ScreenHeight);
        
        [self setUI];
    }
    return self;
}

-(void)setUI
{
    _bgView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, autoScaleH(500), autoScaleW(315))];
    _bgView.center = self.center;
    _bgView.backgroundColor = [GTColor gtColorC3];
    _bgView.layer.cornerRadius = 5;
    _bgView.layer.masksToBounds = YES;
    [self addSubview:_bgView];
    CGAffineTransform transform =CGAffineTransformMakeRotation(M_PI/2*3);
    _bgView.transform = transform;

    _signature = [[GTSignatureView alloc]initSignatureView];
    _signature.frame = CGRectMake(0, 0, _bgView.frame.size.height, autoScaleW(240));
    [_signature resetLabel];
    [_bgView addSubview:_signature];
    __weak GTShowSignature *wself = self;
    _signature.setBlock = ^(NSInteger count) {
        if (count >= 1) {
            [wself.okBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
            wself.okBtn.backgroundColor = [GTColor gtColorCD69];
            wself.okBtn.enabled = YES;
        }
        else
        {
            [wself.okBtn setTitleColor:[GTColor gtColorC4] forState:UIControlStateNormal];
            wself.okBtn.backgroundColor = [GTColor gtColorC7];
            wself.okBtn.enabled = NO;
        }
    };
    
    _backBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    _backBtn.frame = CGRectMake(40, _bgView.frame.size.width-autoScaleW(65), autoScaleH(80), autoScaleW(50));
    [_backBtn setTitle:@"返回" forState:UIControlStateNormal];
    [_backBtn setTitleColor:[GTColor gtColorC4] forState:UIControlStateNormal];
    _backBtn.titleLabel.font = [GTFont gtFontF1];
    _backBtn.layer.cornerRadius = 5;
    _backBtn.layer.masksToBounds = YES;
    _backBtn.backgroundColor = [GTColor gtColorC7];
    [_backBtn addTarget:self action:@selector(backBtnAction) forControlEvents:UIControlEventTouchUpInside];
    [_bgView addSubview:_backBtn];
    
    _cleanBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    _cleanBtn.frame = CGRectMake(_bgView.frame.size.height/2-autoScaleH(40), _bgView.frame.size.width-autoScaleW(65), autoScaleH(80), autoScaleW(50));
    [_cleanBtn setTitle:@"重签" forState:UIControlStateNormal];
    [_cleanBtn setTitleColor:[GTColor gtColorC4] forState:UIControlStateNormal];
    _cleanBtn.titleLabel.font = [GTFont gtFontF1];
    _cleanBtn.layer.cornerRadius = 5;
    _cleanBtn.layer.masksToBounds = YES;
    _cleanBtn.backgroundColor = [GTColor gtColorC1];
    [_cleanBtn addTarget:self action:@selector(cleanBtnAction) forControlEvents:UIControlEventTouchUpInside];
    [_bgView addSubview:_cleanBtn];
    
    _okBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    _okBtn.frame = CGRectMake(_bgView.frame.size.height-autoScaleH(120), _bgView.frame.size.width-autoScaleW(65), autoScaleH(80), autoScaleW(50));
    [_okBtn setTitle:@"确定" forState:UIControlStateNormal];
    [_okBtn setTitleColor:[GTColor gtColorC4] forState:UIControlStateNormal];
    _okBtn.backgroundColor = [GTColor gtColorC7];
    _okBtn.enabled = NO;
    _okBtn.titleLabel.font = [GTFont gtFontF1];
    _okBtn.layer.cornerRadius = 5;
    _okBtn.layer.masksToBounds = YES;
    [_okBtn addTarget:self action:@selector(okBtnAction) forControlEvents:UIControlEventTouchUpInside];
    [_bgView addSubview:_okBtn];
    
    
}

-(void)backBtnAction
{
    [self removeFromSuperview];
}
-(void)cleanBtnAction
{
    [_signature doCancel];
}
-(void)okBtnAction
{
//    [self removeFromSuperview];
    [_signature saveImage:^(UIImage *image) {
        
        if (_saveBlock) {
            _saveBlock(image);
        }
    }];
}

-(void)showView
{
    UIWindow *window = [[[UIApplication sharedApplication] windows] lastObject];
    [window addSubview:self];
    
}

@end

//
//  GTSubmittedSuccessfullyController.m
//  GoldTreasure
//
//  Created by 王超 on 2017/7/5.
//  Copyright © 2017年 zhaofanjinrong.com. All rights reserved.
//

#import "GTSubmittedSuccessfullyController.h"
#import <Masonry/Masonry.h>

@interface GTSubmittedSuccessfullyController ()
{
    NSInteger _timerNumber;
}
@property (nonatomic, strong) UIImageView *image;
@property (nonatomic, strong) UILabel *success;
@property (nonatomic, strong) UILabel *explain;
@property (nonatomic, strong) UIButton *backBtn;
@property (nonatomic, strong) UILabel *timeLabel;

/**
 *  定时器
 */
@property (nonatomic, strong) NSTimer *timer;

@end

@implementation GTSubmittedSuccessfullyController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"我要借款";
    self.view.backgroundColor = [GTColor gtColorC3];
    self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc]initWithCustomView:[UIView new]];
    
//    self.rt_disableInteractivePop = true;
//    [self.navigationController.interactivePopGestureRecognizer setEnabled:false];
    
    _image = [UIImageView new];
    _image.image = [UIImage imageNamed:@"successfully"];
    [self.view addSubview:_image];
    
    _success = [UILabel new];
    _success.textAlignment = NSTextAlignmentCenter;
    _success.font = [GTFont gtFontF6];
    _success.textColor = [GTColor gtColorC4];
    _success.text = @"借款提交成功";
    [self.view addSubview:_success];
    
    _explain = [UILabel new];
    _explain.textAlignment = NSTextAlignmentCenter;
    _explain.font = [GTFont gtFontF2];
    _explain.textColor = [GTColor gtColorC6];
    _explain.text = @"客服会在审核通过后极速放款";
    [self.view addSubview:_explain];
    
    _backBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    _backBtn.titleLabel.font = [GTFont gtFontF1];
    [_backBtn setTitle:@"回到首页" forState:UIControlStateNormal];
    [_backBtn setTitleColor:[GTColor gtColorC6] forState:UIControlStateNormal];
    _backBtn.layer.cornerRadius = 5;
    _backBtn.layer.masksToBounds = YES;
    _backBtn.layer.borderColor = [GTColor gtColorC6].CGColor;
    _backBtn.layer.borderWidth = 1;
    [_backBtn addTarget:self action:@selector(backAction) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:_backBtn];
    
    _timeLabel = [UILabel new];
    _timeLabel.textColor = [GTColor gtColorC6];
    _timeLabel.font = [GTFont gtFontF2];
    _timeLabel.textAlignment = NSTextAlignmentCenter;
    [self.view addSubview:_timeLabel];
    _timeLabel.text = @"3秒后自动跳转回首页...";
    
    [_image mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(self.view);
        make.top.equalTo(self.view).offset(autoScaleH(80)+64);
        make.size.mas_equalTo(CGSizeMake(autoScaleW(101), autoScaleH(100)));
    }];
    [_success mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(self.view);
        make.top.equalTo(_image.mas_bottom).offset(autoScaleH(30));
        make.width.equalTo(self.view);
        make.height.mas_equalTo(autoScaleH(22));
    }];
    [_explain mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(self.view);
        make.top.equalTo(_success.mas_bottom).offset(autoScaleH(26));
        make.width.equalTo(self.view);
        make.height.mas_equalTo(autoScaleH(18));
    }];
    
    [_backBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(self.view);
        make.top.equalTo(_explain.mas_bottom).offset(autoScaleH(50));
        make.size.mas_equalTo(CGSizeMake(autoScaleW(160), autoScaleH(40)));
    }];
    [_timeLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(self.view);
        make.top.equalTo(_backBtn.mas_bottom).offset(autoScaleH(10));
    }];
    
    [self startTimeAction];
}

- (void)viewDidAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    [self interactivePopGesture:false];
}

- (void)viewWillDisappear:(BOOL)animated {
    
//    self.rt_disableInteractivePop = false;
//    [self.navigationController.interactivePopGestureRecognizer setEnabled:true];
    [self interactivePopGesture:true];
}

- (void)startTimeAction
{
    _timerNumber = 3;
    _timer = [NSTimer scheduledTimerWithTimeInterval:1.0 target:self selector:@selector(timerAction:) userInfo:nil repeats:YES];
}

- (void)timerAction:(NSTimer *)timer
{
    
    _timerNumber--;
    _timeLabel.text = [NSString stringWithFormat:@"%ld秒后自动跳转回首页...", (long)_timerNumber];
    if (_timerNumber < 1) {

        [self backAction];
    }
}

-(void)backAction
{
    [self.navigationController popToRootViewControllerAnimated:NO];
    [_timer invalidate];
    _timer = nil;
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

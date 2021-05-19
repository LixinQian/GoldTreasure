//
//  PaybackEndViewController.m
//  GoldTreasure
//
//  Created by targeter on 2017/7/13.
//  Copyright © 2017年 zhaofanjinrong.com. All rights reserved.
//

#import "PaybackEndViewController.h"
#import <Masonry/Masonry.h>
#import "GTContactUsBarView.h"
@interface PaybackEndViewController ()
/** myview */
@property(nonatomic, strong)UIView *myView;
/** bottomButton */
@property(nonatomic, strong)UIButton *confirm;
/** payCash */
@property(nonatomic, strong)UILabel *payCash;

@end

@implementation PaybackEndViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self setUserInterface];
    
}

- (void)viewWillAppear:(BOOL)animated
{
    self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc]initWithCustomView:[UIView new]];
    //    self.rt_disableInteractivePop = true;
    //    [self.navigationController.interactivePopGestureRecognizer setEnabled:false];
    //    [self interactivePopGesture:false];
    
}

-(void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
    [self interactivePopGesture:false];
}

- (void)viewWillDisappear:(BOOL)animated
{
    //    self.rt_disableInteractivePop = false;
    //    [self.navigationController.interactivePopGestureRecognizer setEnabled:true];
    [self interactivePopGesture:true];
}
- (void)setUserInterface
{
    self.view.backgroundColor = [GTColor gtColorC3];
    
    self.title = self.payType == 1 ? @"还款成功" : @"续借成功";
    
    [self.view addSubview:self.myView];
    [self.view addSubview:self.confirm];
    
    [_myView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.view).offset(64);
        make.left.right.equalTo(self.view);
        make.height.equalTo(@290);
    }];
    [_confirm mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.view).offset(15);
        make.right.equalTo(self.view).offset(-15);
        make.top.equalTo(self.myView.mas_bottom).offset(20);
        make.height.equalTo(@50);
    }];
}
- (UIView *)myView
{
    if (!_myView) {
        _myView = [[UIView alloc] init];
        _myView.backgroundColor = [UIColor whiteColor];
        UIImageView *topIcon = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"pay_sueecss"]];
        UIImageView *gradientLine = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"xian"]];
        
        UIImageView *bottomIcon = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"finish"]];
        UILabel *topLabel = [[UILabel alloc] init];
        topLabel.text = self.payType == 1 ? @"支付成功，您的还款申请已提交" : @"支付成功，您的续借申请已提交";
        topLabel.textColor = [GTColor gtColorC1];
        topLabel.font = [GTFont gtFontF2];
        
        _payCash = [[UILabel alloc] init];
        _payCash.numberOfLines = 0;[self.payCashString stringByAppendingString:self.payCashString];
        _payCash.text = [@"支付金额" stringByAppendingString:self.payCashString];
        _payCash.textColor = [GTColor gtColorC6];
        _payCash.font = [GTFont gtFontF3];
        
        
        UILabel *finishPayLabel = [[UILabel alloc] init];
        finishPayLabel.text = self.payType == 1 ? @"完成还款" : @"完成续借";
        finishPayLabel.textColor = [GTColor gtColorC6];
        finishPayLabel.font = [GTFont gtFontF2];
        
        UILabel *finishDetailLabel = [[UILabel alloc] init];
        finishDetailLabel.numberOfLines = 0;
        
        NSString *noti = @"您的订单状态将在1-2分钟内更新，请稍后查看，若届时还未更新，请联系客服。";        
        finishDetailLabel.attributedText = [noti getAttrFormStringWithLineH:6 font:[UIFont systemFontOfSize:13]];
        finishDetailLabel.textColor = [GTColor gtColorC6];
        finishDetailLabel.font = [GTFont gtFontF3];
        GTContactUsBarView *contact = [[GTContactUsBarView alloc] initWithBarMode:ContactUsBarNoLeftMargin];
        
        
        [_myView addSubview:topIcon];
        [_myView addSubview:gradientLine];
        [_myView addSubview:bottomIcon];
        [_myView addSubview:topLabel];
        [_myView addSubview:_payCash];
        [_myView addSubview:finishPayLabel];
        [_myView addSubview:finishDetailLabel];
        [_myView addSubview:contact];
        [topIcon mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(_myView).offset(31);
            make.left.equalTo(_myView).offset(15);
        }];
        [gradientLine mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(topIcon.mas_centerY).offset(10);
            make.bottom.equalTo(bottomIcon.mas_top).offset(10);
            make.centerX.equalTo(topIcon);
        }];
        [bottomIcon mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(_myView).offset(151);
            make.centerX.equalTo(topIcon);
        }];
        [topLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerY.equalTo(topIcon);
            make.left.equalTo(topIcon.mas_right).offset(15);
        }];
        [_payCash mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(topLabel.mas_bottom).offset(10);
            make.left.equalTo(topLabel);
        }];
        [finishPayLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerY.equalTo(bottomIcon);
            make.left.equalTo(bottomIcon.mas_right).offset(15);
        }];
        [finishDetailLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(finishPayLabel.mas_bottom).offset(10);
            make.right.equalTo(_myView);
            make.left.equalTo(bottomIcon.mas_right).offset(15);
        }];
        [contact mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(finishDetailLabel.mas_bottom).offset(20);
            make.left.right.equalTo(finishDetailLabel);
        }];
        
    }
    return _myView;
}
- (UIButton *)confirm
{
    if (!_confirm) {
        _confirm = [UIButton buttonWithType:UIButtonTypeCustom];
        [_confirm setBackgroundImage:[UIImage initWithColor:[GTColor gtColorC1]] forState:UIControlStateNormal];
        [_confirm setTitle:@"确 定" forState:UIControlStateNormal];
        [_confirm setTitleColor:[GTColor gtColorC4] forState:UIControlStateNormal];
        [_confirm addTarget:self action:@selector(confirmAction) forControlEvents:UIControlEventTouchUpInside];
    }
    return _confirm;
}

- (void)confirmAction
{
    [self.navigationController popToRootViewControllerAnimated:YES];
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

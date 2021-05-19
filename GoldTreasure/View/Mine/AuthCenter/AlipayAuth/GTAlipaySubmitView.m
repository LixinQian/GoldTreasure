//
//  GTAlipaySubmitView.m
//  GoldTreasure
//
//  Created by wangyaxu on 05/07/2017.
//  Copyright © 2017 zhaofanjinrong.com. All rights reserved.
//

#import "GTAlipaySubmitView.h"
#import "GTLabelTextFieldTableViewCell.h"

#import "GTVerification.h"

#import <Masonry/Masonry.h>

@interface GTAlipaySubmitView ()<UITableViewDelegate, UITableViewDataSource>

@property (nonatomic, strong) UITableView *tableView;
@property (nonatomic, strong) UIButton *submitBtn;

@end

@implementation GTAlipaySubmitView

- (instancetype)init
{
    self = [super init];
    if (self) {
        [self setup];
        UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(handleTap)];
        [self addGestureRecognizer:tap];
    }
    return self;
}

- (void)setup
{
    //    UILabel *tipLabel = [UILabel labelWithFont:[GTFont gtFontF3] textColor:[GTColor gtColorC6]];
    //    tipLabel.numberOfLines = 0;
    //    [self.view addSubview:tipLabel];
    //    tipLabel.text = @"请认证您的收款银行卡，作为入账银行帐户，持卡人必须是 王艳艳 才有效";
    //
    //    [self.view addSubview:tipLabel];
    
    UITableView *tableView = [[UITableView alloc] initWithFrame:CGRectZero style:UITableViewStylePlain];
    tableView.scrollEnabled = NO;
    tableView.backgroundColor = [UIColor clearColor];
    [tableView setSeparatorStyle:UITableViewCellSeparatorStyleNone];
    tableView.delegate = self;
    tableView.dataSource = self;
    [self addSubview:tableView];
    self.tableView = tableView;
    
    UIButton *submitBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    self.submitBtn = submitBtn;
    [submitBtn setBackgroundColor:[GTColor gtColorC1]];
    submitBtn.titleLabel.font = [GTFont gtFontF1];
    [submitBtn setTitleColor:[GTColor gtColorC4] forState:UIControlStateNormal];
    submitBtn.layer.cornerRadius = 5;
    [submitBtn setTitle:@"提交审核" forState:UIControlStateNormal];
    [submitBtn addTarget:self action:@selector(clickSubmitBtn:) forControlEvents:UIControlEventTouchUpInside];
    [self addSubview:submitBtn];
    
    {
        //        [tipLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        //            make.top.equalTo(self.view.mas_top).with.offset(15);
        //            make.left.equalTo(self.view.mas_left).with.offset(15);
        //            make.right.equalTo(self.view.mas_right).with.offset(-15);
        //        }];
        
        [self.tableView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.height.equalTo(@100);
            make.left.right.and.top.equalTo(self);
        }];
        
        [submitBtn mas_makeConstraints:^(MASConstraintMaker *make) {
            make.height.equalTo(@50);
            make.top.equalTo(self.tableView.mas_bottom).with.offset(20);
            make.left.equalTo(self.mas_left).with.offset(15);
            make.right.equalTo(self.mas_right).with.offset(-15);
        }];
    }
    
    [self.tableView registerClass:[GTLabelTextFieldTableViewCell class] forCellReuseIdentifier:@"GTLabelTextFieldTableViewCell"];

}

#pragma mark    -   table view  -

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return 2;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 50;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    GTLabelTextFieldTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"GTLabelTextFieldTableViewCell" forIndexPath:indexPath];
    [self configCell:cell WithIndexPath:indexPath];
    return cell;
}

- (void)configCell:(GTLabelTextFieldTableViewCell *)cell WithIndexPath:(NSIndexPath *)indexPath
{
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    [cell setTextFieldEnabled:YES];
    switch (indexPath.row) {
        case 0:
            [cell setTitle:@"支付宝账户" placeHolder:@"请填写支付宝账户"];
            break;
        case 1:
            [cell setTitle:@"登录密码" placeHolder:@"请填写支付宝登录密码"];
            [cell setTextFieldSecureTextEntry:YES];
            [cell shouldHideSeparatorLine:YES];
            break;
            
        default:
            break;
    }
}

- (void)setSubmitBtnEnabled:(BOOL )enabled
{
    self.submitBtn.userInteractionEnabled = enabled;
}

- (void)handleTap
{
    [self endEditing:YES];
}

- (void)clickSubmitBtn:(UIButton *)btn
{
    GTLabelTextFieldTableViewCell *accountCell = [self.tableView cellForRowAtIndexPath:[NSIndexPath indexPathForRow:0 inSection:0]];
    GTLabelTextFieldTableViewCell *passwordCell = [self.tableView cellForRowAtIndexPath:[NSIndexPath indexPathForRow:1 inSection:0]];
    NSString *account = [accountCell getTextFieldText];
    NSString *password = [passwordCell getTextFieldText];
    
    if (![GTVerification checkMaxNumLength:account length:40]) {
        [GTHUD showToastWithInfo:@"支付宝账户名过长！"];
        return;
    }
    
    if (![GTVerification checkAlipayPassword:password]) {
        [GTHUD showToastWithInfo:@"密码格式错误！"];
        return;
    }
    
    self.submitInfoBlock(account, password);    
}

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end

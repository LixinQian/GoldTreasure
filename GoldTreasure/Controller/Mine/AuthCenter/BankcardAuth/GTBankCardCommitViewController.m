//
//  GTBankCardCommitViewController.m
//  GoldTreasure
//
//  Created by wangyaxu on 03/07/2017.
//  Copyright © 2017 zhaofanjinrong.com. All rights reserved.
//

#import "GTBankCardCommitViewController.h"
#import "GTLabelTextFieldTableViewCell.h"
#import "GTVerification.h"

#import <Masonry/Masonry.h>

@interface GTBankCardCommitViewController ()<UITableViewDelegate, UITableViewDataSource>

@property (nonatomic, strong) UITableView *tableView;

@property (nonatomic, strong) UIButton *submitBtn;

@end

@implementation GTBankCardCommitViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    self.view.backgroundColor = [GTColor gtColorC3];
    
    [self setupInterface];
//    
//    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(handleTap)];
//    [self.view addGestureRecognizer:tap];
    
//    if (ScreenWidth < 375) {
//        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardWillShow:) name:UIKeyboardWillShowNotification object:nil];
//        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardWillHide:) name:UIKeyboardWillHideNotification object:nil];
//    }
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)dealloc
{
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

#pragma mark    -   set up interface    -

- (void)setupInterface
{
    UITableView *tableView = [[UITableView alloc] initWithFrame:CGRectZero style:UITableViewStylePlain];
    tableView.scrollEnabled = NO;
    tableView.backgroundColor = [UIColor clearColor];
    [tableView setSeparatorStyle:UITableViewCellSeparatorStyleNone];
    tableView.delegate = self;
    tableView.dataSource = self;
    [self.view addSubview:tableView];
    self.tableView = tableView;
 
    UIButton *submitBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    self.submitBtn = submitBtn;
    [submitBtn setBackgroundColor:[GTColor gtColorC1]];
    submitBtn.titleLabel.font = [GTFont gtFontF1];
    [submitBtn setTitleColor:[GTColor gtColorC4] forState:UIControlStateNormal];
    submitBtn.layer.cornerRadius = 5;
    [submitBtn setTitle:@"提交审核" forState:UIControlStateNormal];
    [submitBtn addTarget:self action:@selector(clickSubmitBtn:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:submitBtn];
    
    {
        [self.tableView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.height.equalTo(@195);
            make.top.equalTo(self.view.mas_top).with.offset(20);
            make.left.right.equalTo(self.view);
        }];
        
        [submitBtn mas_makeConstraints:^(MASConstraintMaker *make) {
            make.height.equalTo(@50);
            make.top.equalTo(self.tableView.mas_bottom).with.offset(20);
            make.left.equalTo(self.view.mas_left).with.offset(15);
            make.right.equalTo(self.view.mas_right).with.offset(-15);
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
    return 3;
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    UIView *view = [UIView new];
    view.backgroundColor = [UIColor whiteColor];
    
    UIView *markView = [UIView new];
    markView.backgroundColor = [GTColor gtColorC1];
    markView.layer.cornerRadius = 2;
    
    UILabel *titleLabel = [UILabel labelWithFont:[GTFont gtFontF2] textColor:[GTColor gtColorC9] text:@"银行卡信息"];
    
    UIView *line = [UIView new];
    line.backgroundColor = [GTColor gtColorC15];
    
    [view addSubview:markView];
    [view addSubview:titleLabel];
    [view addSubview:line];
    
    {
        [markView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(view.mas_left).with.offset(15);
            make.centerY.equalTo(view.mas_centerY);
            make.size.mas_equalTo(CGSizeMake(6, 20));
        }];
        
        [titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(markView.mas_right).with.offset(10);
            make.centerY.equalTo(view.mas_centerY);
        }];
        
        [line mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.right.and.bottom.equalTo(view);
            make.height.equalTo(@.5f);
        }];
    }
    
    return view;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    return 40;
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
    GTResModelUserInfo *info = GTUser.manger.userInfoModel;
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    [cell setTextFieldEnabled:NO];
    switch (indexPath.row) {
        case 0:
            [cell setTitle:@"持卡人" placeHolder:@""];
            [cell setTextFieldText:info.custName];
            break;
        case 1:
            [cell setTitle:@"预留手机" placeHolder:@""];
            [cell setTextFieldText:info.phoneNo];
            break;
        case 2:
            [cell setTitle:@"银行卡号" placeHolder:@"请输入银行卡号"];
            [cell setTextFieldEnabled:YES];
            [cell setTextFieldInputType:UIKeyboardTypeNumberPad];
            [cell shouldHideSeparatorLine:YES];
            break;
            
        default:
            break;
    }
}

- (void)reInputBankcardNumber
{
    //清空银行卡号
    GTLabelTextFieldTableViewCell *cell = [self.tableView cellForRowAtIndexPath:[NSIndexPath indexPathForRow:2 inSection:0]];
    [cell setTextFieldText:@""];
}

- (void)setSubmitBtnEnabled:(BOOL )enabled
{
    self.submitBtn.userInteractionEnabled = enabled;
}

- (void)clickSubmitBtn:(UIButton *)btn
{
    GTLabelTextFieldTableViewCell *mobileCell = [self.tableView cellForRowAtIndexPath:[NSIndexPath indexPathForRow:1 inSection:0]];
    GTLabelTextFieldTableViewCell *cardCell = [self.tableView cellForRowAtIndexPath:[NSIndexPath indexPathForRow:2 inSection:0]];
    NSString *mobile = [mobileCell getTextFieldText];
    NSString *cardNumber = [cardCell getTextFieldText];
    
    if (![GTVerification checkBankCardNumber:cardNumber]) {
        [GTHUD showToastWithInfo:@"银行卡格式不正确，请验证"];
        return;
    }
    [self handleTap];
    self.commitBlock(mobile, cardNumber);
}

- (void)handleTap
{
    [self.view endEditing:YES];
}

- (void)keyboardWillShow:(NSNotification *)noti
{
    [self.tableView setContentOffset:CGPointMake(0, 50) animated:YES];
}

- (void)keyboardWillHide:(NSNotification *)noti
{
    [self.tableView setContentOffset:CGPointMake(0, 0) animated:YES];
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

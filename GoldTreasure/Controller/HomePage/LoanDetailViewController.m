//
//  LoanDetailViewController.m
//  GoldTreasure
//
//  Created by targeter on 2017/6/30.
//  Copyright © 2017年 zhaofanjinrong.com. All rights reserved.
//

#import "LoanDetailViewController.h"
#import "NowPaybackViewController.h"
#import "PersistLoanViewController.h"
#import "LoanDeatialHeadrView.h"
#import "LateFeeHeaderCell.h"
#import "LateFeeCell.h"
#import "feeSummaryFooterView.h"
#import <Masonry/Masonry.h>

@class GTLoanOrderDetailReqModel;
@class GTLoanOrderDetailResModel;
@class GTLatefees;
@class GTPayWayReqModel;

#import "GTTradeService.h"
#import "OrderModel.h"
@interface LoanDetailViewController ()<UITableViewDelegate,UITableViewDataSource>

@property(nonatomic, strong)UITableView *myTableView;
/** model */
@property(nonatomic, strong)GTLoanOrderDetailResModel *resModel;
/** 滞纳金总额value */
@property(nonatomic, assign)float sumLateFeeFloat;
/** 利息 */
@property(nonatomic, assign)float rate;

@end

@implementation LoanDetailViewController
#define idTopHeader @"idTopHeader"
#define idLateFeeHeaderCell @"LateFeeHeaderCell"
#define idLateFeeCell @"LateFeeCell"
#define idFeeSummaryFooterView @"feeSummaryFooterView"


- (void)viewDidLoad {
    [super viewDidLoad];
    self.sumLateFeeFloat = 0.0;
    self.automaticallyAdjustsScrollViewInsets = NO;
    self.title = @"借款详情";
    [self myTableView];
    [self requestLoanOrderDetail];
}

#pragma mark -- netWorkRequest
- (void)rateRequest:(void(^)())success
{
    WEAKSELF
    [[GTCommonService manger] requestRate:^(OrderModel * _Nonnull listModel) {
        int a = listModel.magFeeDay.intValue;
        int b = listModel.interestDay.intValue;
        weakSelf.rate = (a + b) * 0.0001;
        success();
    }];
}

-(void)requestLoanOrderDetail
{
    WEAKSELF
    [[GTTradeService sharedInstance] requestOrderDetail:self.reqModel.loanId.stringValue succ:^(GTLoanOrderDetailResModel *resModel) {
        
        [weakSelf rateRequest:^{
            weakSelf.resModel = resModel;
            for (int i = 0; i < weakSelf.resModel.latefees.count; i++) {
                GTLatefees *feeModel = weakSelf.resModel.latefees[i];
                float feeValue = feeModel.money.intValue;
                if (feeModel.type.intValue == 2) {
                    weakSelf.sumLateFeeFloat -= feeValue;
                } else {
                    weakSelf.sumLateFeeFloat += feeValue;
                }
            }
            
            [[NSOperationQueue mainQueue] addOperationWithBlock:^{
                [weakSelf.myTableView reloadData];
                if (resModel.loanStatus.intValue == 3 || resModel.loanStatus.intValue == 6) {
                    [weakSelf setBottomButtons];
                }
                
            }];

        }];
        
    } fail:^(GTNetError *error) {
        
        GTNetError *err = (GTNetError *) error;
        [GTHUD showErrorWithTitle:[NSString stringWithFormat:@"%@",err.msg]];
        
    }];
    
}


- (void)setBottomButtons
{
    
    UIButton *buttonA = [UIButton buttonWithType:UIButtonTypeSystem];
    buttonA.backgroundColor = [UIColor whiteColor];
    buttonA.titleLabel.font = [GTFont gtFontF1];
    [buttonA setTitleColor:[GTColor gtColorC4] forState:UIControlStateNormal];
    [buttonA setTitle:@"立即还款" forState:UIControlStateNormal];
    [buttonA addTarget:self action:@selector(paybackPush) forControlEvents:UIControlEventTouchUpInside];
    
    UIButton *buttonB = [UIButton buttonWithType:UIButtonTypeSystem];
    buttonB.backgroundColor = [GTColor gtColorC953];
    buttonB.titleLabel.font = [GTFont gtFontF1];
    [buttonB setTitleColor:[GTColor gtColorC4] forState:UIControlStateNormal];
    [buttonB setTitle:@"续借" forState:UIControlStateNormal];
    [buttonB addTarget:self action:@selector(persistLoan) forControlEvents:UIControlEventTouchUpInside];
    
    [self.view addSubview:buttonA];
    [self.view addSubview:buttonB];
    [buttonA mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.bottom.equalTo(self.view);
        make.height.equalTo(@50);
        make.right.equalTo(buttonB.mas_left);
        make.width.equalTo(buttonB);
    }];
    [buttonB mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(buttonA.mas_right);
        make.height.equalTo(@50);
        make.right.bottom.equalTo(self.view);
        make.width.equalTo(buttonA);
    }];
    
    
}
- (UITableView *)myTableView
{
    if (!_myTableView) {
        _myTableView = [[UITableView alloc] initWithFrame:CGRectZero style:UITableViewStyleGrouped];
        _myTableView.backgroundColor = [GTColor gtColorC3];
        _myTableView.contentInset = UIEdgeInsetsMake(0, 0, 52, 0);
        _myTableView.separatorStyle = UITableViewCellSeparatorStyleNone;
        _myTableView.delegate = self;
        _myTableView.dataSource = self;
        [_myTableView registerClass:[LoanDeatialHeadrView class] forCellReuseIdentifier:idTopHeader];
        [_myTableView registerClass:[LateFeeHeaderCell class] forCellReuseIdentifier:idLateFeeHeaderCell];
        [_myTableView registerClass:[LateFeeCell class] forCellReuseIdentifier:idLateFeeCell];
        [_myTableView registerClass:[feeSummaryFooterView class] forHeaderFooterViewReuseIdentifier:idFeeSummaryFooterView];
        
        [self.view addSubview:_myTableView];
        
        [_myTableView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.right.and.bottom.equalTo(self.view);
            make.top.equalTo(self.mas_topLayoutGuide);
        }];
        
    }
    return _myTableView;
}


#pragma mark -- tableViewDataSource
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    
    if (self.resModel.loanStatus.intValue == 6 || self.resModel.loanStatus.intValue == 3) {
        if (self.resModel.lateFlag.intValue == 1 && self.sumLateFeeFloat != 0) {
            return 3;
        } else {
            return 2;
        }
    } else {
        return 2;
    }
    
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    if (section == 0) {
        return 1;
        
    } else if (section == 1){
        return 1;
        
    } else {
        return self.resModel.latefees.count;
        
    }
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    if (section == 0) {
        return 0.01;
        
    } else if (section == 1){
        return 15;
        
    } else {
        return 0.01;
        
    }
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section
{
    if (section == 0) {
        
        return 0.01;
    } else if (section == 1){
        if (self.resModel.loanStatus.intValue == 6 || self.resModel.loanStatus.intValue == 3) {
            if (self.resModel.lateFlag.intValue == 1 && self.sumLateFeeFloat != 0) {
                return 0.01;

            } else {
                return 62;
            }
        } else {
            return 62;
        }
        
    } else {
        return 48;
        
    }
}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.section == 0) {
        return 280;
    } else if (indexPath.section == 1) {
        
        return 40;
    } else{
        return 40;
    }
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.section == 0) {
        
        LoanDeatialHeadrView *cell = [tableView dequeueReusableCellWithIdentifier:idTopHeader forIndexPath:indexPath];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        cell.model = self.resModel;
        
        return cell;
    } else if (indexPath.section == 1){
        LateFeeHeaderCell *cell = [tableView dequeueReusableCellWithIdentifier:idLateFeeHeaderCell forIndexPath:indexPath];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
//        cell.comma.hidden = YES;
//        if (self.resModel.loanStatus.intValue == 6 || self.resModel.loanStatus.intValue == 3) {
//            if (self.resModel.lateFlag.intValue == 1 && self.sumLateFeeFloat != 0) {
//                cell.comma.hidden = NO;
//            }
//        }
        if (self.resModel.loanStatus.intValue == 6 || self.resModel.loanStatus.intValue == 3) {
            if (self.resModel.lateFlag.intValue == 1 && self.sumLateFeeFloat != 0) {
            }
        }
        
        return cell;
    } else {
        LateFeeCell *cell = [tableView dequeueReusableCellWithIdentifier:idLateFeeCell forIndexPath:indexPath];
        cell.lateFeeModel = self.resModel.latefees[indexPath.row];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        
        
        return cell;
    }
    
    
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
//    if (indexPath.section == 1 && self.resModel.loanStatus.intValue == 6) {
//        GTWKWebVC *rateVC = [[GTWKWebVC alloc] initWithUrlStr:RATE];
//        [self.navigationController pushViewController:rateVC animated:YES];
//    }
    if (indexPath.section == 1) {
        GTWKWebVC *rateVC = [[GTWKWebVC alloc] initWithUrlStr:RATE];
        [self.navigationController pushViewController:rateVC animated:YES];
    }

}
- (UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section
{
    if (section == 1) {
        UIView *footerSectionA = [[UIView alloc] init];
        footerSectionA.backgroundColor = [UIColor whiteColor];
        UILabel *textLabel = [[UILabel alloc] init];
        textLabel.font = [GTFont gtFontF2];
        textLabel.textColor = [GTColor gtColorC6];
        textLabel.text = @"无逾期，暂无产生滞纳金";
        textLabel.textAlignment = NSTextAlignmentCenter;
        textLabel.backgroundColor = [UIColor whiteColor];
        [footerSectionA addSubview:textLabel];
        [textLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.width.equalTo(footerSectionA);
            make.centerX.equalTo(footerSectionA);
            make.height.mas_equalTo(@62);
        }];
        footerSectionA.hidden = NO;
        if (self.resModel.loanStatus.intValue == 6 || self.resModel.loanStatus.intValue == 3) {
            if (self.resModel.lateFlag.intValue == 1 && self.sumLateFeeFloat != 0) {
                footerSectionA.hidden = YES;
            } else {
                footerSectionA.hidden = NO;
            }
        }
        return footerSectionA;
    } else if (section == 2){
        feeSummaryFooterView *footerSectionB = [tableView dequeueReusableHeaderFooterViewWithIdentifier:idFeeSummaryFooterView];
        NSNumber *feeNumber = [NSNumber numberWithFloat:self.sumLateFeeFloat];
        footerSectionB.feeSummary.text = [[@"=" stringByAppendingString:[feeNumber centToYuan]] addYuan];
        
        return footerSectionB;
        
    }
    return nil;
    
}

#pragma mark -- bottomButtonAction
- (void)paybackPush
{
    // model
    GTPayWayReqModel *PayWayReqModel = [[GTPayWayReqModel alloc] init];
    PayWayReqModel.loanId = self.resModel.loanId;
    PayWayReqModel.interId = GTApiCode.getQuickPayMent;
    PayWayReqModel.type = [@2 toString];

    float sum = self.resModel.reqMoney.intValue + self.sumLateFeeFloat;
    NSNumber *sumMoney = [NSNumber numberWithFloat:sum];
    PayWayReqModel.payMoney = [sumMoney toString];
    PayWayReqModel.latefee = [@(self.sumLateFeeFloat) toString];
    PayWayReqModel.payType = [@2 toString];
    
    
    // 给子控制器赋值
    NowPaybackViewController *nowPayback = [[NowPaybackViewController alloc] init];
    nowPayback.PayWayReqModel = PayWayReqModel;
    nowPayback.sumCash = [[sumMoney centToYuan] addYuan];
    nowPayback.handleFee = @"0.00元";
    nowPayback.lateFee = [[@(self.sumLateFeeFloat) centToYuan] addYuan];
    nowPayback.loanCashString = [[self.resModel.reqMoney centToYuan] addYuan];
    
    
    [self.navigationController pushViewController:nowPayback animated:YES];
    
    
}

- (void)persistLoan
{
    // model
    GTPayWayReqModel *PayWayReqModel = [[GTPayWayReqModel alloc] init];
    PayWayReqModel.loanId = self.resModel.loanId;
    PayWayReqModel.interId = GTApiCode.getQuickPayMent;
    PayWayReqModel.type = [@1 toString];
    float handleIntFee = self.resModel.reqMoney.intValue * 7 * self.rate;
    float sum = handleIntFee + self.sumLateFeeFloat;
    NSNumber *sumMoney = [NSNumber numberWithFloat:sum];
    PayWayReqModel.payMoney = [sumMoney toString];
    PayWayReqModel.latefee = [@(self.sumLateFeeFloat) toString];
    PayWayReqModel.payType = [@2 toString];
    
    
    // 给子控制器赋值
    PersistLoanViewController *PersistLoan = [[PersistLoanViewController alloc] init];
    PersistLoan.PayWayReqModel = PayWayReqModel;
    PersistLoan.loanCashString = [[self.resModel.reqMoney centToYuan] addYuan];
    PersistLoan.lateFee = [[@(self.sumLateFeeFloat) centToYuan] addYuan];
    PersistLoan.sumCash = [[sumMoney centToYuan] addYuan];
    PersistLoan.handleFee = [[@(handleIntFee) centToYuan] addYuan];
    PersistLoan.reqTime = [self.resModel.reqTime TimeToMinutes];
    PersistLoan.startTime = [self.resModel.startTime localNetTimeToDate];
    PersistLoan.endTime = [self.resModel.endTime localNetTimeToDate];
    [self.navigationController pushViewController:PersistLoan animated:YES];
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end

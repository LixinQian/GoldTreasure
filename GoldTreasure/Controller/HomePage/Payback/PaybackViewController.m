//
//  PaybackViewController.m
//  GoldTreasure
//
//  Created by targeter on 2017/6/27.
//  Copyright © 2017年 zhaofanjinrong.com. All rights reserved.
//

#import "PaybackViewController.h"
#import "LoanDetailViewController.h"
#import "PersistLoanViewController.h"
#import "NowPaybackViewController.h"
#import "GTTradeService.h"
#import "GTShowMessage.h"
#import "PaybackHeaderView.h"
#import <Masonry/Masonry.h>
#import "PaybackView.h"
#import "OrderModel.h"

#import "GTTradeService.h"
#import "GTShowMessage.h"
#import <MJRefresh/MJRefresh.h>
@class GTPaybackListResModel;
@class GTPayWayReqModel;
typedef enum : NSUInteger {
    WeiShenHe                 = 0, // 1XX
    ShenHeWeiTongGuo          = 1, // 1XX
    ShenHeTongGuo             = 2, // 2XX
    YiFangKuan                = 3, // 3XX
    FangKuanShiBai            = 4, // 4XX
    YiHuanKuan                = 5, // 5XX
    HuaiZhang                 = 6, // 5XX
    
} DetailLoanStatus;

@interface PaybackViewController ()<UITableViewDelegate,UITableViewDataSource>
/** PaybackView */
@property(nonatomic, strong)PaybackHeaderView *headerView;
@property(nonatomic, strong)UITableView *myTableView;

/** 模型 */
/** PaybackListResModel */
@property(nonatomic, strong)GTPaybackListResModel *PaybackListResModel;
/** 缺省图片 */
//@property(nonatomic, strong)UIImageView *noLoanImage;
/** 缺省label */
@property(nonatomic, strong)UILabel *noLoanLabel;
/** 利息 */
@property(nonatomic, assign)float rate;


@end

@implementation PaybackViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self setAppearance];
    [self setHeaderView];
    [self setTableView];
    [self requestPaybackList];
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
-(void)requestPaybackList
{
    GTPaybackListReqModel *model = [[GTPaybackListReqModel alloc] init];
    model.interId = GTApiCode.getNeedPayLoans;
    
    WEAKSELF
    [weakSelf rateRequest:^{
        [[GTTradeService sharedInstance] paybackListResModelReqModel:model succ:^(GTPaybackListResModel *resModel) {
            weakSelf.PaybackListResModel = resModel;
            if ([resModel.payBackNum integerValue]) {
                dispatch_async(dispatch_get_main_queue(), ^{
//                    [weakSelf.noLoanImage removeFromSuperview];
                    [weakSelf.noLoanLabel removeFromSuperview];
                    [weakSelf.myTableView reloadData];
                    weakSelf.headerView.PaybackListResModel = weakSelf.PaybackListResModel;
                });
                
            } else {
                [weakSelf.myTableView removeFromSuperview];
                [weakSelf setnoLoanView];
                
            }
        }  fail:^(GTNetError *error) {
            [weakSelf.myTableView removeFromSuperview];
            [weakSelf setnoLoanView];
        }];

    }];
}

#pragma mark -- view appearance
//导航栏设置
-(void)setAppearance
{
    self.automaticallyAdjustsScrollViewInsets = NO;
    self.navigationController.navigationBar.translucent = YES;
//    self.title = @"还款";
    self.view.backgroundColor = [UIColor whiteColor];
    self.navBarTintColor = [GTColor gtColorC2];
    self.navBarAlpha = 0;
    UILabel *lab = [[UILabel alloc]init];
    lab.text = @"还款";
    lab.textColor = [GTColor gtColorC2];
    [lab sizeToFit];
    lab.backgroundColor = [UIColor clearColor];
    self.navigationItem.titleView = lab;
////    self.navBarAlpha = 1;
//    [self.navigationController.navigationBar setBackgroundImage:[UIImage new] forBarMetrics:UIBarMetricsDefault];
//    [self.navigationController.navigationBar setShadowImage:[UIImage new]];
    self.navigationController.navigationBar.translucent = YES;
}

- (void) viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    [UIApplication sharedApplication].statusBarStyle = UIStatusBarStyleLightContent;
    self.navBarAlpha = 0;
}

- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
    [UIApplication sharedApplication].statusBarStyle = UIStatusBarStyleLightContent;
}
- (void) viewWillDisappear:(BOOL)animated {
    [super viewWillAppear:animated];
    [UIApplication sharedApplication].statusBarStyle = UIStatusBarStyleDefault;
    self.navBarAlpha = 1;
}

//您没有欠款～
-(void)setnoLoanView
{
//    _noLoanImage = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"no_loan"]];
    _noLoanLabel = [[UILabel alloc] init];
    _noLoanLabel.textColor = [GTColor gtColorC6];
    _noLoanLabel.font = [GTFont gtFontF2];
    _noLoanLabel.text = @"您没有欠款～";
    
//    [self.view addSubview:_noLoanImage];
    [self.view addSubview:_noLoanLabel];
    
//    [_noLoanImage mas_makeConstraints:^(MASConstraintMaker *make) {
//        make.centerX.equalTo(self.view);
//        make.top.equalTo(self.headerView.mas_bottom).offset(78);
//    }];
    [_noLoanLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(self.view);
        make.height.equalTo(@18);
        make.top.equalTo(self.headerView.mas_bottom).offset(120);
    }];
    
}

- (void)setTableView
{
    _myTableView = [[UITableView alloc] init];
    
    _myTableView.delegate = self;
    _myTableView.dataSource = self;
    _myTableView.showsVerticalScrollIndicator = NO;
    [self.view addSubview:_myTableView];
    
    [_myTableView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.view);
        make.top.equalTo(self.headerView.mas_bottom);
        make.right.equalTo(self.view);
        make.bottom.equalTo(self.view);
    }];
}
/**
- (void)setRefreshHeader
{
    // 刷新
    WEAKSELF
    GTPaybackListReqModel *model = [[GTPaybackListReqModel alloc] init];
    model.interId = GTApiCode.getNeedPayLoans;

    _myTableView.mj_header = [GTRefreshView.sharedInstance headerWithClosure:^{
        [[GTTradeService sharedInstance] PaybackListResModelReqModel:model succ:^(GTPaybackListResModel *resModel) {
            weakSelf.PaybackListResModel = resModel;
        } fail:^(GTNetError *error) {
            [weakSelf.myTableView.mj_header endRefreshing];
        }];
        [weakSelf.myTableView.mj_header endRefreshing];

    }];

    _myTableView.mj_footer = [GTRefreshView.sharedInstance footerWithClosure:^{
        [[GTTradeService sharedInstance] PaybackListResModelReqModel:model succ:^(GTPaybackListResModel *resModel) {
            weakSelf.PaybackListResModel = resModel;
        } fail:^(GTNetError *error) {
            [weakSelf.myTableView.mj_footer endRefreshing];
        }];
        [weakSelf.myTableView.mj_footer endRefreshing];


    }];
}
*/
- (void)setHeaderView
{
    _headerView = [[PaybackHeaderView alloc] init];
    [self.view addSubview:_headerView];
    
    WEAKSELF
    [_headerView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.top.right.equalTo(weakSelf.view);
        make.height.equalTo(@281);
    }];
}

#pragma mark -- tableviewDataSource
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return self.PaybackListResModel.loans.count;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return 1;
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section
{
    return 1;
}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    GTPaybackCellModel *model = self.PaybackListResModel.loans[indexPath.section];

    if (model.lateDays.intValue == 0) {
        return 100;
    } else {
        return 140;

    }
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    

    __block GTPaybackCellModel *model = self.PaybackListResModel.loans[indexPath.section];
    PaybackView *cell = [PaybackView cellWithTableView:tableView];

    cell.PaybackCellModel = model;
    GTPayWayReqModel *PayWayReqModel = [[GTPayWayReqModel alloc] init];
    PayWayReqModel.loanId = model.loanId;
    PayWayReqModel.interId = GTApiCode.getQuickPayMent;
    PayWayReqModel.latefee = [model.lateFee toString];

    //手续费
    __block float handleIntFee = model.reqMoney.longValue * 7 * self.rate;
    __block NSNumber *handleNumFee = [NSNumber numberWithFloat:handleIntFee];
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    cell.persistLoan = ^{
        
        // model
        PayWayReqModel.type = [@1 toString];
        
        //手续费加滞纳金的总额
        float sum = model.lateFee.intValue + handleIntFee;
        NSNumber *sumMoney = [NSNumber numberWithFloat:sum];
        
        PayWayReqModel.payMoney = [sumMoney toString];
        PayWayReqModel.payType = [@2 toString];
        
        
        PersistLoanViewController *PersistLoan = [[PersistLoanViewController alloc] init];
        PersistLoan.PayWayReqModel = PayWayReqModel;
        PersistLoan.sumCash = [[sumMoney centToYuan] addYuan];
        PersistLoan.handleFee = [[handleNumFee centToYuan] addYuan];
        PersistLoan.lateFee = [[model.lateFee centToYuan] addYuan];
        PersistLoan.loanCashString = [[model.reqMoney centToYuan] addYuan];
        PersistLoan.sumCash = [[sumMoney centToYuan] addYuan];

        [self.navigationController pushViewController:PersistLoan animated:true];

//        [self.navigationController pushViewController:PersistLoan animated:YES complete:nil];
    };
    
    cell.nowPayback = ^{
        // model
        PayWayReqModel.type = [@2 toString];
        //手续费加滞纳金和本金的总额
        float sum = model.reqMoney.intValue + model.lateFee.intValue ;
        NSNumber *sumMoney = [NSNumber numberWithFloat:sum];

        PayWayReqModel.payMoney = [sumMoney toString];
        PayWayReqModel.payType = [@2 toString];

        // 给子控制器赋值
        NowPaybackViewController *nowPayback = [[NowPaybackViewController alloc] init];
        nowPayback.PayWayReqModel = PayWayReqModel;
        nowPayback.sumCash = [[sumMoney centToYuan] addYuan];
        nowPayback.handleFee = @"0.00元";
        nowPayback.lateFee = [[model.lateFee centToYuan] addYuan];
        nowPayback.loanCashString = [[model.reqMoney centToYuan] addYuan];
        nowPayback.sumCash = [[sumMoney centToYuan] addYuan];
        

        [self.navigationController pushViewController:nowPayback animated:YES];
    };

    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    LoanDetailViewController *loan = [[LoanDetailViewController alloc] init];
    loan.reqModel = [[GTLoanOrderDetailReqModel alloc] init];
    loan.reqModel.interId = GTApiCode.getLoanDetail;
    //    LoanOrderResModel *cellModel = self.orderlistModel[indexPath.row];
    //    loan.reqModel.orderNo = model.orderNo;
    //PaybackCellModel *model = [PaybackCellModel yy_modelWithDictionary:self.PaybackListResModel.loans[indexPath.section]] ;
    GTPaybackCellModel *model = self.PaybackListResModel.loans[indexPath.section];

    loan.reqModel.loanId = model.loanId;
    [self.navigationController pushViewController:loan animated:YES];
}

- (void)scrollViewDidScroll:(UIScrollView *)scrollView
{
    CGFloat alpha = 1.0 - ABS(scrollView.contentOffset.y / 64);
    if (alpha < 1) {
        [[[self navigationController] navigationBar] setTitleTextAttributes:@{
                                                                              NSForegroundColorAttributeName : [[UIColor whiteColor] colorWithAlphaComponent:alpha]
                                                                              }];
        self.navigationItem.titleView.hidden = YES;
        
    }else {
        [[[self navigationController] navigationBar] setTitleTextAttributes:@{
                                                                              NSForegroundColorAttributeName : [[UIColor blackColor] colorWithAlphaComponent:1]
                                                                              }];
        self.navigationItem.titleView.hidden = NO;
    }
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

@end

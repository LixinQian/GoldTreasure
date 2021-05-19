//
//  GTLoanOrderViewController.m
//  GoldTreasure
//
//  Created by targeter on 2017/6/27.
//  Copyright © 2017年 zhaofanjinrong.com. All rights reserved.
//

#import "GTLoanOrderViewController.h"
#import "GTTableViewCell.h"
#import "LoanDeatialHeadrView.h"
#import "LoanDetailViewController.h"
#import "OrderModel.h"
#import "GTTradeService.h"
#import "GTShowMessage.h"
#import <Masonry/Masonry.h>
#import <MJRefresh/MJRefresh.h>

@class GTReqModelLoanOrder;
@class GTResModelLoanOrder;
@class GTLoanOrderDetailReqModel;

@interface GTLoanOrderViewController ()<UITableViewDelegate,UITableViewDataSource>
///** 模型 */
//@property(nonatomic, strong)GTReqModelLoanOrder *model;
/** 缺省图片 */
@property(nonatomic, strong)UIImageView *noOrderImage;
/** 缺省label */
@property(nonatomic, strong)UILabel *noOrderLabel;
/** tableview */
@property(nonatomic, strong)UITableView *myTableView;
/** tableview */
@property(nonatomic, strong)NSArray<GTResModelLoanOrder *> *modelList;

/** page 索引页 */
@property(nonatomic, assign) int currentPage;

@end


@implementation GTLoanOrderViewController

- (void)viewDidLoad {
    
    [super viewDidLoad];
    [self initUI];
    [self initData];
    [self initHandle];
    
    
}

// 逻辑操作
- (void) initHandle {
    
    // 监听数组变化
    WEAKSELF
    [RACObserve(self, modelList) subscribeNext:^(id _Nullable x) {
        [weakSelf reloadTableView];
    }];
    
    // 下拉刷新
    self.myTableView.mj_header = [[GTRefreshView sharedInstance] headerWithClosure:^{
        [weakSelf reloadNewData];
    }];
    // 上拉加载
    self.myTableView.mj_footer = [[GTRefreshView sharedInstance] footerWithClosure:^{
        [weakSelf reloadMoreData];
    }];
}
// 刷新操作
- (void) reloadTableView {
    
    // 刷新
    if (self.modelList.count > 0) {
        
        [[NSOperationQueue mainQueue] addOperationWithBlock:^{
            [self.myTableView reloadData];
            [self hiddenNoOrderView];
        }];
    } else {
        
        [[NSOperationQueue mainQueue] addOperationWithBlock:^{
            [self showNoOrderView];
        }];
    }
    
}

- (void) initUI {
    
    self.view.backgroundColor = [GTColor gtColorC3];
    self.title = @"借款订单";
    
    [self.view addSubview:self.myTableView];
    [self setNoOrderView];
    
    // 加入左右间距
    [_myTableView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.mas_equalTo(UIEdgeInsetsMake(0, 15, 0, 15));
    }];
    
}

// 初始化 数据
- (void) initData {
    
    _currentPage = 1;
    _modelList = [NSArray array];
}

// 请求 更多的 信息
- (void) reloadMoreData {
    
    // 页面累加
    int newPage = _currentPage + 1;
    [self.myTableView.mj_header endRefreshing];
    
    WEAKSELF
    [[GTTradeService sharedInstance] reqLoanOrderListWittPage:newPage succ:^(NSArray *modelList) {
        
        
        NSArray *newArr = [weakSelf.modelList arrayByAddingObjectsFromArray:modelList];
        weakSelf.modelList = newArr;
        
        if (modelList.count) {
            
            _currentPage ++;
            [weakSelf.myTableView.mj_footer endRefreshing];
        } else {
            
            [weakSelf.myTableView.mj_footer endRefreshingWithNoMoreData];
        }
    } fail:^(GTNetError *error) {
        
        [weakSelf.myTableView.mj_footer endRefreshing];
    }];
}
// 请求 新的 信息
- (void) reloadNewData {
    
    // 默认第一页
    _currentPage = 1;
    [self.myTableView.mj_footer endRefreshing];
    WEAKSELF
    [[GTTradeService sharedInstance] reqLoanOrderListWittPage:_currentPage succ:^(NSArray<GTResModelLoanOrder *> *modelList) {
        
        [weakSelf.myTableView.mj_header endRefreshing];
        weakSelf.modelList = modelList;
    } fail:^(GTNetError *error) {
        
        [weakSelf.myTableView.mj_header endRefreshing];
        [weakSelf showNoOrderView];
    }];
}

// 隐藏 站位图
- (void) hiddenNoOrderView {
    
    _noOrderImage.hidden = true;
    _noOrderLabel.hidden = true;
    _myTableView.hidden = false;
    
}
// 显示 站位图
- (void) showNoOrderView {
    
    
    _noOrderImage.hidden = false;
    _noOrderLabel.hidden = false;
    _myTableView.hidden = true;
}

// 刷新视图
- (void)viewWillAppear:(BOOL)animated {
    
    [GTHUD showStatusWithTitle:nil];
    [self reloadNewData];
}
// 站位图
-(void)setNoOrderView
{
    UIImageView *noOrderImage = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"no_order"]];
    UILabel *noOrderLabel = [UILabel intiWithTitle:@"您尚未借款～" titleFont:[GTFont gtFontF2] titleColor:[GTColor gtColorC6] bgColor:nil];
    
    _noOrderImage = noOrderImage;
    _noOrderLabel = noOrderLabel;
    
    _noOrderLabel.hidden = true;
    _noOrderImage.hidden = true;
    
    [self.view addSubview:_noOrderImage];
    [self.view addSubview:_noOrderLabel];
    
    [_noOrderImage mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(self.view);
        make.centerY.equalTo(self.view).multipliedBy(0.6);
    }];
    [_noOrderLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(self.noOrderImage);
        make.top.equalTo(_noOrderImage.mas_bottom).offset(20);
    }];
    
}


- (UITableView *)myTableView {
    
    if (!_myTableView) {
        _myTableView = [[UITableView alloc] initWithFrame:self.view.bounds style:UITableViewStyleGrouped];
        _myTableView.backgroundColor = [GTColor gtColorC3];
        _myTableView.delegate = self;
        _myTableView.dataSource = self;
        _myTableView.separatorStyle = UITableViewCellSeparatorStyleNone;
        _myTableView.showsVerticalScrollIndicator = NO;
        _myTableView.contentInset = UIEdgeInsetsMake(0, 0, 15, 0);
    }
    return _myTableView;
}



#pragma MARK UITableview delegate
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    
    return self.modelList.count;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return 1;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    return 15;
}
- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section
{
    return 0.01;
}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 116;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    
    
    GTResModelLoanOrder *cellModel = self.modelList[indexPath.section];
    GTTableViewCell *cell = [GTTableViewCell cellWithTableView:tableView];
    
    // Configure the cell...
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    cell.orderList = cellModel;
    
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    //    [GTHUD showStatusWithTitle:nil];
    LoanDetailViewController *loan = [[LoanDetailViewController alloc] init];
    loan.reqModel = [[GTLoanOrderDetailReqModel alloc] init];
    loan.reqModel.interId = GTApiCode.getLoanDetail;
    loan.reqModel.loanId = self.modelList[indexPath.section].loanId;
    
    
    [self.navigationController pushViewController:loan animated:YES];
}

@end

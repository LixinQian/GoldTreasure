//
//  GTAmountController.m
//  GoldTreasure
//
//  Created by 王超 on 2017/7/3.
//  Copyright © 2017年 zhaofanjinrong.com. All rights reserved.
//

#import "GTAmountController.h"
#import <Masonry/Masonry.h>
#import "GTSelectAmountCell.h"
#import "GTAmountNormalCell.h"
#import "OrderModel.h"
#import "GTTripartiteContractController.h"

@interface GTAmountController ()<UITableViewDelegate,UITableViewDataSource>

@property (nonatomic, strong) UITableView *amountTableView;

@property (nonatomic, strong) UIButton *nextStep;

@property (nonatomic, strong) GTAmountNormalCell *normalCell;

@property (nonatomic, strong) OrderModel *model;

//借款金额
@property (nonatomic, assign) double Acount;
//手续费
@property (nonatomic, assign) double Fee;


@end

@implementation GTAmountController

-(UITableView *)amountTableView
{
    if (!_amountTableView) {
        _amountTableView = [[UITableView alloc]initWithFrame:self.view.frame style:UITableViewStyleGrouped];
        _amountTableView.delegate = self;
        _amountTableView.dataSource = self;
        _amountTableView.bounces = NO;
        _amountTableView.backgroundColor = [GTColor gtColorC3];

        _amountTableView.sectionFooterHeight = 0.1;
        
        UIView *footView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, ScreenWidth, autoScaleH(140))];
        _amountTableView.tableFooterView = footView;
        UILabel *explain = [UILabel new];
        [footView addSubview:explain];
        explain.textColor = [GTColor gtColorC6];
        explain.font = [GTFont gtFontF3];
        explain.text = @"到账金额 = 借款金额 - 手续费（借款利息 + 管理费）";
        explain.numberOfLines = 0;
        [explain mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(footView).offset(autoScaleW(15));
            make.top.equalTo(footView).offset(autoScaleH(10));
            make.right.equalTo(footView);
//            make.height.mas_equalTo(16);
        }];
        _nextStep = [UIButton buttonWithType:UIButtonTypeCustom];
        _nextStep.backgroundColor = [GTColor gtColorC1];
        [_nextStep setTitle:@"点击签《三方借款合同》并提交申请" forState:UIControlStateNormal];
        _nextStep.titleLabel.font = [GTFont gtFontF1];
        [_nextStep setTitleColor:[GTColor gtColorC4] forState:UIControlStateNormal];
        _nextStep.layer.cornerRadius = 5;
        _nextStep.layer.masksToBounds = YES;
        [_nextStep addTarget:self action:@selector(nextAction) forControlEvents:UIControlEventTouchUpInside];
        [footView addSubview:_nextStep];
        [_nextStep mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.mas_equalTo(footView).offset(autoScaleW(15));
            make.top.equalTo(explain.mas_bottom).offset(autoScaleH(24));
            make.right.mas_equalTo(footView).offset(autoScaleW(-15));
            make.height.mas_equalTo(autoScaleH(50));
        }];
    }
    return _amountTableView;
}


-(void)initData
{
    
    [GTHUD showStatusWithTitle:@"请求中..."];
    _model = [[OrderModel alloc] init];
    
    OrderModel *model = [[OrderModel alloc] init];
    model.interId = GTApiCode.getConfig;  // 接口编号 在GTApiCode 中定义,要自己定义
    NSDictionary *dict = [model yy_modelToJSONObject]; // 转为字典
    
    
    WEAKSELF
    [[GTApi requestParams:dict andResmodel:[OrderModel class] andAuthStatus:nil]
     subscribeNext:^(OrderModel*  _Nullable resModel) {
         [GTHUD dismiss];
         // model.message
         GTLog(@"请求内容:\n%@",dict);
         weakSelf.model = resModel;
         [weakSelf.amountTableView reloadData];
         
         
     } error:^(NSError * _Nullable error) {
         
         GTNetError *err = (GTNetError *) error;
         GTLog(@"#####%@", err);
         [GTHUD showErrorWithTitle:[NSString stringWithFormat:@"%@",err.msg]];

     }];

}
- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"我要借款";
    self.view.backgroundColor = [GTColor gtColorC3];
    [self initData];
    [self.view addSubview:self.amountTableView];
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if (section == 0) {
        return 1;
    }else if (section == 1)
    {
        return 3;
    }
    return 2;
}
-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 3;
}
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.section == 0) {
        return autoScaleH(175);
    }
    return autoScaleH(50);
}
-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    return autoScaleH(15);
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    __weak GTAmountController *wself = self;
    
    if (indexPath.section == 0) {
        GTSelectAmountCell *cell = [GTSelectAmountCell cellWithTableView:tableView];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        cell.selectBlock = ^(OrderModel *model) {
          
            [wself setCellWithModel:model];
            _Acount = [model.borrowAmount floatValue];
            if ([model.borrowAmount floatValue] > 0) {
                _nextStep.enabled = YES;
                _nextStep.backgroundColor = [GTColor gtColorC1];
                [_nextStep setTitleColor:[GTColor gtColorC4] forState:UIControlStateNormal];
            }
            else
            {
                _nextStep.enabled = NO;
                _nextStep.backgroundColor = [GTColor gtColorC7];
                [_nextStep setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
            }
        };
        return cell;
    }
    _normalCell = [GTAmountNormalCell cellWithTableView:tableView];
 
    _normalCell.indexP = indexPath;
    _normalCell.model = _model;
    
    _normalCell.selectionStyle = UITableViewCellSelectionStyleNone;
    
    _normalCell.amountCellBlock = ^{
        [wself.navigationController pushViewController:[[GTWKWebVC alloc]initWithUrlStr:RATE] animated:YES];
    };
    return _normalCell;
}

-(void)setCellWithModel:(OrderModel *)model
{
    NSIndexPath *indexPath = [NSIndexPath indexPathForRow:0 inSection:1];
    GTAmountNormalCell *cell = [self.amountTableView cellForRowAtIndexPath:indexPath];
    [cell setAmountWithIndexPath:indexPath Model:model];
    
    indexPath = [NSIndexPath indexPathForRow:1 inSection:1];
    cell = [self.amountTableView cellForRowAtIndexPath:indexPath];
    [cell setAmountWithIndexPath:indexPath Model:model];
    
    indexPath = [NSIndexPath indexPathForRow:2 inSection:1];
    cell = [self.amountTableView cellForRowAtIndexPath:indexPath];
    [cell setAmountWithIndexPath:indexPath Model:model];
    indexPath = [NSIndexPath indexPathForRow:0 inSection:2];
    cell = [self.amountTableView cellForRowAtIndexPath:indexPath];
    [cell setAmountWithIndexPath:indexPath Model:model];

}
-(void)nextAction
{
    if (!_model.interestDay || !_model.magFeeDay) {
        [GTHUD showErrorWithTitle:@"数据请求失败！"];
        return;
    }
    //手续费赋值下一页使用
    
    _Fee =  _Acount * ([_model.interestDay intValue] + [_model.magFeeDay intValue]) * 7 / 10000;
    
    GTTripartiteContractController *contract = [[GTTripartiteContractController alloc]init];
    contract.acount = _Acount * 100;
    contract.fee = round(_Fee * 100);
    [self.navigationController pushViewController:contract animated:YES];
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

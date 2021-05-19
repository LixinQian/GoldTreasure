//
//  PersistLoanViewController.m
//  GoldTreasure
//
//  Created by targeter on 2017/7/1.
//  Copyright © 2017年 zhaofanjinrong.com. All rights reserved.
//

#import "PersistLoanViewController.h"
#import "PaybackViewController.h"
#import "PaybackEndViewController.h"
#import <Masonry/Masonry.h>
#import "GTContactsTitleCell.h"
#import "NowPaybackCell.h"
#import "PaybackWayCell.h"
#import <Masonry/Masonry.h>
#import "GTTradeService.h"
#import <AlipaySDK/AlipaySDK.h>
#import "LLOrder.h"
@class GTPayWayReqModel;

typedef void(^confirmBlock)();

typedef NS_ENUM(NSUInteger, GTPayType) {
    
    GTPayTypeZfb = 1,
    GTPayTypeLL = 2,
};

@interface PersistLoanViewController ()<UITableViewDelegate, UITableViewDataSource,LLPaySdkDelegate>


/** 确认用哪种支付方式 */
@property (copy, nonatomic) confirmBlock confirmed;

@property (nonatomic, strong) UITableView *tableView;

@property (nonatomic, strong) UIButton *confirm;

@property (nonatomic, assign) GTPayType paytype;
/** model */
@property(nonatomic, strong)GTLoanOrderDetailResModel *resModel;


@end

@implementation PersistLoanViewController


- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"续借";
    self.view.backgroundColor = [GTColor gtColorC3];
    
    [self.view addSubview:self.tableView];
    [self initNet];
}
/**
- (void)LianlianPay
{
    WEAKSELF
//    GTPayWayReqModel *model = self.PayWayReqModel;
    [[GTTradeService sharedInstance] LianlianPay:self.PayWayReqModel succ:^(id resModel) {
        GTLog(@"请求内容:\n%@",[resModel yy_modelToJSONObject]);
        
        [weakSelf lianlianSdkHandle:[resModel yy_modelToJSONObject]];
        
    } fail:^(GTNetError *error) {
        [GTHUD showErrorWithStr:[NSString stringWithFormat:@"%@",error]];
        GTLog(@"#####%@", error);
        
    }];
    
}
*/

- (void)initNet
{
    WEAKSELF
    if (!self.reqTime) {
        [[GTTradeService sharedInstance] requestOrderDetail:_PayWayReqModel.loanId.stringValue succ:^(GTLoanOrderDetailResModel *resModel) {
            
            weakSelf.resModel = resModel;
            weakSelf.reqTime = [resModel.reqTime TimeToMinutes];
//            weakSelf.startTime = [resModel.startTime localNetTimeToDate];
//            weakSelf.endTime = [resModel.endTime localNetTimeToDate];
            
            
            
            
            [weakSelf.tableView reloadData];
        } fail:^(GTNetError *error) {
            
            GTNetError *err = (GTNetError *) error;
            [GTHUD showErrorWithTitle:[NSString stringWithFormat:@"%@",err.msg]];
            
        }];

    }

    

}

- (void)actionPay {
    
    WEAKSELF
    self.PayWayReqModel.interId = GTApiCode.getQuickPayMent;

    if (!self.paytype) {
        [GTHUD showErrorWithTitle:@"请选择支付方式"];
    } else {
        if (self.paytype == GTPayTypeLL) {
            self.PayWayReqModel.payType = [NSString stringWithFormat:@"%d",(int)GTPayTypeLL];
        } else if (self.paytype == GTPayTypeZfb) {
            self.PayWayReqModel.payType = [NSString stringWithFormat:@"%d",(int)GTPayTypeZfb];
        }
        
        [GTHUD showStatusWithTitle:nil];
        [[GTApi requestParams:[self.PayWayReqModel yy_modelToJSONObject] andAuthStatus:nil] subscribeNext:^(NSDictionary<NSString*,NSString*>  *_Nullable x) {
            
            if (self.paytype == GTPayTypeLL) {
                
             [LLPaySdk sharedSdk].sdkDelegate = weakSelf;
             [[LLPaySdk sharedSdk] presentLLPaySDKInViewController:weakSelf withPayType:LLPayTypeVerify andTraderInfo:x];
             [GTHUD dismiss];
               
            } else {
                
                if (![x isKindOfClass:[NSDictionary class]]) {
                    
                    [GTHUD showErrorWithTitle:@"参数错误"];
                    return;
                }
                NSDictionary *dict = (NSDictionary *)x;
                NSString *jsonStr = dict[@"alipay"];

                [[AlipaySDK defaultService] payOrder:jsonStr fromScheme:GTALIPAYSCHEME callback:^(NSDictionary *resultDic) {
                
                    [GTHUD dismiss];
                    if ([resultDic[@"resultStatus"] isEqual:@"9000"]) {
                        PaybackEndViewController *end = [[PaybackEndViewController alloc] init];
                        end.payCashString = self.sumCash;
                        end.payType = 2;
//                        [GTUser.manger reloadUserInfoWithSucc:nil fail:nil];
                        [weakSelf.navigationController pushViewController:end animated:YES];
                    } else {
                        [GTHUD showErrorWithTitle:resultDic[@"memo"]];
                    }

                }];
            }
        } error:^(NSError * _Nullable error) {
            [GTHUD showErrorWithTitle:[NSString stringWithFormat:@"%@",error]];
        }];
        
        
    }
    
    
}

- (void) lianlianSdkHandle:(NSDictionary *)dict {
    
    [LLPaySdk sharedSdk].sdkDelegate = self;
    [[LLPaySdk sharedSdk] presentLLPaySDKInViewController:self withPayType:LLPayTypeRealName andTraderInfo:dict];
}

//连连支付 回调  delegate
-(void)paymentEnd:(LLPayResult)resultCode withResultDic:(NSDictionary *)dic {
    
    PaybackEndViewController *end = [[PaybackEndViewController alloc] init];
    if ([dic[@"ret_msg"] isEqualToString:@"交易成功"]) {
        end.payCashString = self.sumCash;
        end.payType = 2;
//        [GTUser.manger reloadUserInfoWithSucc:nil fail:nil];
        [self.navigationController pushViewController:end animated:YES];
    }  else {
        [GTHUD showErrorWithTitle:dic[@"ret_msg"]];
        
    }

}



-(UITableView *)tableView
{
    if (!_tableView) {
        _tableView = [[UITableView alloc]initWithFrame:self.view.frame style:UITableViewStyleGrouped];
        _tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
        _tableView.delegate = self;
        _tableView.dataSource = self;
        _tableView.bounces = NO;
        _tableView.backgroundColor = [GTColor gtColorC3];
        
    }
    return _tableView;
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if (section == 0) {
        return 5;
    } else if (section == 1) {
        return 4;
    } else {
        return 3;
    }
}
-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 3;
}
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    if (indexPath.section == 0) {
        if (indexPath.row == 0) {
            return 41;
        } else if (indexPath.row == 1) {
            return 33;
        } else if (indexPath.row == 2) {
            return 32;
        } else if (indexPath.row == 3) {
            return 32;
        } else {
            return 52;
        }
    } else if (indexPath.section == 1) {
        if (indexPath.row == 0) {
            return 41;
        } else if (indexPath.row == 1) {
            return 33;
        } else if (indexPath.row == 2) {
            return 51;
        } else if (indexPath.row == 3) {
            return 52;
        } else {
            return 52;
        }
    } else {
        if (indexPath.row == 0) {
            return 40;
        } else if (indexPath.row == 1 || indexPath.row == 2 || indexPath.row == 3) {
            return 80;
        } else {
            return 51;
        }

    }
}
-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    return 15;
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section
{
    if (section == 0) {
        return 1;
        
    } else if (section == 1){
        
        return 1;
    } else {
        return 108;
    }
}


-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    if (indexPath.section == 0) {
        if (indexPath.row == 0) {
            GTContactsTitleCell *cell = [GTContactsTitleCell cellWithTableView:tableView];
            cell.selectionStyle = UITableViewCellSelectionStyleNone;
            [cell setValueWithTitle:@"续借明细"];
            cell.footerLine.hidden = NO;
            return cell;
            
        } else if (indexPath.row == 1) {
            NowPaybackCell *cell = [NowPaybackCell cellWithTableView:tableView];
            cell.selectionStyle = UITableViewCellSelectionStyleNone;
            [cell setTitle:@"申请时间" AndValue: self.reqTime];
            return cell;
            
        } else if (indexPath.row == 2) {
            NowPaybackCell *cell = [NowPaybackCell cellWithTableView:tableView];
            cell.selectionStyle = UITableViewCellSelectionStyleNone;
            [cell setTitle:@"固定周期" AndValue: @"7天"];
            return cell;
            
        } else if (indexPath.row == 3) {
            NowPaybackCell *cell = [NowPaybackCell cellWithTableView:tableView];
            cell.selectionStyle = UITableViewCellSelectionStyleNone;
            NSDate *present = [NSDate date];
            NSString *datePresent = [present dateStringWithFormatterYYYYMMDD];
            NSString *dateSixDayAfter = [present timeStringWithSixDays];
            NSString *temp = [datePresent stringByAppendingString:@"至"];
            NSString *period = [temp stringByAppendingString:dateSixDayAfter];
            [cell setTitle:@"续借时间" AndValue: period];
            return cell;
        } else if (indexPath.row == 4) {
            NowPaybackCell *cell = [NowPaybackCell cellWithTableView:tableView];
            cell.selectionStyle = UITableViewCellSelectionStyleNone;
            [cell setTitle:@"续借本金" AndValue: self.loanCashString];
            return cell;
        } else {
            return nil;
        }
        
        
        
    } else if (indexPath.section == 1) {
        if (indexPath.row == 0) {
            GTContactsTitleCell *cell = [GTContactsTitleCell cellWithTableView:tableView];
            cell.selectionStyle = UITableViewCellSelectionStyleNone;
            [cell setValueWithTitle:@"续借费用"];
            cell.footerLine.hidden = NO;
            return cell;
            
        } else if (indexPath.row == 1) {
            NowPaybackCell *cell = [NowPaybackCell cellWithTableView:tableView];
            cell.selectionStyle = UITableViewCellSelectionStyleNone;
            [cell setTitle:@"手续费" AndValue: self.handleFee];
            return cell;
            
        } else if(indexPath.row == 2) {
            NowPaybackCell *cell = [NowPaybackCell cellWithTableView:tableView];
            cell.selectionStyle = UITableViewCellSelectionStyleNone;
            [cell setTitle:@"滞纳金" AndValue: self.lateFee];
            return cell;
        } else if (indexPath.row == 3) {
            NowPaybackCell *cell = [NowPaybackCell cellWithTableView:tableView];
            cell.selectionStyle = UITableViewCellSelectionStyleNone;
            cell.headerLine.hidden = NO;
            [cell setTitle:@"应付费用" AndValue: self.sumCash];
            return cell;
        } else {
            return nil;
        }
        
    } else {
        if (indexPath.row == 0) {
            GTContactsTitleCell *cell = [GTContactsTitleCell cellWithTableView:tableView];
            cell.selectionStyle = UITableViewCellSelectionStyleNone;
            [cell setValueWithTitle:@"选择支付方式"];
            cell.footerLine.hidden = NO;
            return cell;
            
        }  else {
            PaybackWayCell *cell = [PaybackWayCell cellWithTableView:tableView];
            cell.selectionStyle = UITableViewCellSelectionStyleNone;
            [cell setValueWithIndex:indexPath.row];
            if (indexPath.row == 1) {
                cell.footerLine.hidden = NO;
            }
            [self.tableView selectRowAtIndexPath:[NSIndexPath indexPathForRow:1 inSection:2] animated:NO scrollPosition:UITableViewScrollPositionNone];
            return cell;
        }
    }
}
/**
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.section == 2 && indexPath.row != 0) {
        WEAKSELF
        if (indexPath.row == 1) {
            self.confirmed = ^{
                weakSelf.paytype = GTPayTypeLL;
                NSLog(@"连连续借");
                
            };
        } else if (indexPath.row == 2) {
            self.confirmed = ^{
                weakSelf.paytype = GTPayTypeZfb;
                NSLog(@"支付宝续借");
            };
        }
    }
}
*/
-(void)confirmAction
{
    NSLog(@"确认续借");
    NSIndexPath *indexPath = self.tableView.indexPathForSelectedRow;
    GTLog(@"%ld, %ld", indexPath.section, indexPath.row)
    if (indexPath.section == 2) {
        if (indexPath.row == 1) {
            self.paytype = GTPayTypeLL;
        } else if (indexPath.row == 2) {
            self.paytype = GTPayTypeZfb;
        }
        [self actionPay];
    }


    /**
    Class popVCClass = [self.rt_navigationController.rt_viewControllers[1] class];
    if (popVCClass == [PaybackViewController class] ) {
        [self.rt_navigationController popToViewController:self.rt_navigationController.rt_viewControllers[1] animated:YES complete:nil];
        
    } else {
        [self.rt_navigationController popViewControllerAnimated:YES];
    }
    */
}


- (UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section
{
    if (section == 2) {
        UIView *footView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, ScreenWidth, 50)];
        self.confirm = [UIButton buttonWithType:UIButtonTypeCustom];
        self.confirm.backgroundColor = [GTColor gtColorC1];
        [self.confirm setTitle:@"确认续借" forState:UIControlStateNormal];
        self.confirm.titleLabel.font = [GTFont gtFontF1];
        [self.confirm setTitleColor:[GTColor gtColorC4] forState:UIControlStateNormal];
        self.confirm.layer.cornerRadius = 5;
        self.confirm.layer.masksToBounds = YES;
        [self.confirm addTarget:self action:@selector(confirmAction) forControlEvents:UIControlEventTouchUpInside];
        [footView addSubview:self.confirm];
        [self.confirm mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.mas_equalTo(footView).offset(15);
            make.top.equalTo(footView).offset(20);
            make.right.mas_equalTo(footView).offset(-15);
            make.height.mas_equalTo(50);
        }];
        return footView;
    } else {
        return nil;
        
    }
    
}
@end

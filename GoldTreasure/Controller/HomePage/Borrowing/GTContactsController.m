//
//  GTContactsController.m
//  GoldTreasure
//
//  Created by 王超 on 2017/7/1.
//  Copyright © 2017年 zhaofanjinrong.com. All rights reserved.
//

#import "GTContactsController.h"
#import "GTContactsCell.h"
#import "GTContactsTitleCell.h"
#import <Masonry/Masonry.h>
#import "GTAmountController.h"
#import "OrderModel.h"
#import "GTVerification.h"
#import "GTValuePickerView.h"

@interface GTContactsController ()<UITableViewDelegate,UITableViewDataSource>

@property (nonatomic, strong) UITableView *contactsTableView;

@property (nonatomic, strong) UIButton *nextStep;

//选择关系控件
@property (nonatomic, strong) GTValuePickerView *pickerView;
// cell 列表
@property (nonatomic, strong) NSArray *cellList;
// cell text
@property (nonatomic, strong) NSMutableArray *cellTextList;

@end

@implementation GTContactsController
-(UITableView *)contactsTableView
{
    if (!_contactsTableView) {
        _contactsTableView = [[UITableView alloc]initWithFrame:self.view.frame style:UITableViewStyleGrouped];
        _contactsTableView.delegate = self;
        _contactsTableView.dataSource = self;
        _contactsTableView.bounces = NO;
        _contactsTableView.backgroundColor = [GTColor gtColorC3];
        
        UILabel *titleLabel = [[UILabel alloc]initWithFrame:CGRectMake(0, 0, ScreenWidth, autoScaleH(50))];
        titleLabel.backgroundColor = [UIColor whiteColor];
        titleLabel.text = @"请如实填写您的紧急联系人";
        titleLabel.font = [GTFont gtFontF2];
        titleLabel.textColor = [GTColor gtColorC4];
        titleLabel.textAlignment = NSTextAlignmentCenter;
        _contactsTableView.tableHeaderView = titleLabel;
        _contactsTableView.sectionFooterHeight = 0.1;
        
        UIView *footView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, ScreenWidth, autoScaleH(140))];
        _contactsTableView.tableFooterView = footView;
        _nextStep = [UIButton buttonWithType:UIButtonTypeCustom];
        _nextStep.backgroundColor = [GTColor gtColorC1];
//        _nextStep.enabled = NO;
        [_nextStep setTitle:@"下一步" forState:UIControlStateNormal];
        _nextStep.titleLabel.font = [GTFont gtFontF1];
        [_nextStep setTitleColor:[GTColor gtColorC4] forState:UIControlStateNormal];
        _nextStep.layer.cornerRadius = 5;
        _nextStep.layer.masksToBounds = YES;
        [_nextStep addTarget:self action:@selector(nextStepAction) forControlEvents:UIControlEventTouchUpInside];
        [footView addSubview:_nextStep];
        [_nextStep mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.mas_equalTo(footView).offset(autoScaleW(15));
            make.top.equalTo(footView).offset(autoScaleH(20));
            make.right.mas_equalTo(footView).offset(autoScaleW(-15));
            make.height.mas_equalTo(autoScaleH(50));
        }];
    }
    return _contactsTableView;
}

-(void)initPickerView
{
    self.pickerView = [[GTValuePickerView alloc]init];

    self.pickerView.dataSource = @[@"父母",@"子女",@"亲属",@"情侣",@"同学",@"朋友",@"其他"];

    self.pickerView.pickerTitle = @"关系";
    
}
- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.title = @"我要借款";
    self.view.backgroundColor = [GTColor gtColorC3];
    self.navBarAlpha = 1;
    
    [self.view addSubview:self.contactsTableView];
    
    [self initPickerView];
    
    
    _cellTextList = [NSMutableArray arrayWithObjects:[NSMutableArray arrayWithCapacity:3],[NSMutableArray arrayWithCapacity:3],nil];
    _cellList = [self getCellList];
    
//    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardWillShow:) name:UIKeyboardWillShowNotification object:nil];
//    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardWillHide:) name:UIKeyboardWillHideNotification object:nil];

}

//- (void)keyboardWillShow:(NSNotification *)info
//{
//    CGRect keyboardBounds = [[[info userInfo] objectForKey:UIKeyboardFrameEndUserInfoKey] CGRectValue];
//    _contactsTableView.contentInset = UIEdgeInsetsMake(_contactsTableView.contentInset.top, 0, keyboardBounds.size.height-autoScaleH(65), 0);
//    
//}
//- (void)keyboardWillHide:(NSNotification *)info
//{
//    _contactsTableView.contentInset = UIEdgeInsetsMake(_contactsTableView.contentInset.top, 0, 0, 0);
//}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return 4;
}
-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 2;
}
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.row == 0) {
        return autoScaleH(40);
    }
    return autoScaleH(50);
}
-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    return autoScaleH(15);
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.row == 0) {
        GTContactsTitleCell *cell = [GTContactsTitleCell cellWithTableView:tableView];
        [cell setValueWithIndex:indexPath.section];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        return cell;
    }
    
    GTContactsCell *cell = _cellList[indexPath.section][indexPath.row-1];
    [cell setValueWithIndex:indexPath.row-1];
    WEAKSELF
    [[cell.titleTF rac_textSignal] subscribeNext:^(NSString * _Nullable x) {
        weakSelf.cellTextList[indexPath.section][indexPath.row-1] = x;

    }];
    
    if (indexPath.row == 2) {
        cell.titleTF.enabled = NO;
    }
    return cell;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    //先回收键盘
    [self.view endEditing:YES];

    if (indexPath.section == 0) {
        if (indexPath.row == 2) {
            
            [self.pickerView show];
            
            GTContactsCell *cell = _cellList[indexPath.section][indexPath.row-1];
            
            WEAKSELF
            self.pickerView.valueDidSelect = ^(NSString *value){
                NSArray * stateArr = [value componentsSeparatedByString:@"/"];
                cell.titleTF.text= stateArr[0];
                
                weakSelf.cellTextList[indexPath.section][indexPath.row-1] = stateArr[0];
            };
        }
    }else
    {
        if (indexPath.row == 2) {
            
            [self.pickerView show];
            
            WEAKSELF
            GTContactsCell *cell = _cellList[indexPath.section][indexPath.row-1];
            //[tableView cellForRowAtIndexPath:indexPath];
            self.pickerView.valueDidSelect = ^(NSString *value){
                NSArray * stateArr = [value componentsSeparatedByString:@"/"];
                cell.titleTF.text= stateArr[0];
                weakSelf.cellTextList[indexPath.section][indexPath.row-1] = stateArr[0];
            };
            
            
        }
    }
    
    
}

-(NSArray<GTContactsCell *>*)getCellList {
    
    NSMutableArray *mutArr = [NSMutableArray array];
    NSMutableArray *mutArrSec1 = [NSMutableArray array];
    NSMutableArray *mutArrSec2 = [NSMutableArray array];
    for (int i = 0; i < 6; i++) {
        
        GTContactsCell *cell = [[GTContactsCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:nil];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        
        if (i < 3) {
            [mutArrSec1 addObject:cell];
        } else {
            [mutArrSec2 addObject:cell];
        }
    }
    [mutArr addObject:mutArrSec1];
    [mutArr addObject:mutArrSec2];
    
    
    return mutArr;
    
}
-(void)nextStepAction
{
    //防止提交成功返回重新提交
//    if ([GTUser.manger.userInfoModel.hasElinkman integerValue] == 1) {
//        
//        GTAmountController *amount = [[GTAmountController alloc]init];
//        [self.navigationController pushViewController:amount animated:YES];
//        return;
//    }
    
    _nextStep.enabled = NO;
    NSMutableArray *mutarr = [NSMutableArray array];
    
    for (NSArray *arr in _cellTextList) {
        [mutarr addObjectsFromArray:arr];
        
    }
    
    for (int i = 0; i < 6; i++) {
        NSString *str = mutarr[i];
        if ([str isEqualToString:@""]) {
            [GTHUD showErrorWithTitle:@"请补全信息！"];
            _nextStep.enabled = YES;
            return;
        }
    }
    if (![GTVerification isValidateChinese:mutarr[0]]) {
        [GTHUD showErrorWithTitle:@"联系人1请填写中文姓名！"];
        _nextStep.enabled = YES;
        return;
    }
    if (![GTVerification checkTelNumber:mutarr[2]]) {
        [GTHUD showErrorWithTitle:@"联系人1手机号格式不正确！"];
        _nextStep.enabled = YES;
        return;
    }
    if ([mutarr[0] isEqualToString:mutarr[3]]) {
        [GTHUD showErrorWithTitle:@"请填写不同联系人！"];
        _nextStep.enabled = YES;
        return;
    }
    if (![GTVerification isValidateChinese:mutarr[3]]) {
        [GTHUD showErrorWithTitle:@"联系人2请填写中文姓名！"];
        _nextStep.enabled = YES;
        return;
    }
    if (![GTVerification checkTelNumber:mutarr[5]]) {
        [GTHUD showErrorWithTitle:@"联系人2手机号格式不正确！"];
        _nextStep.enabled = YES;
        return;
    }
    if ([mutarr[2] isEqualToString:mutarr[5]]) {
        [GTHUD showErrorWithTitle:@"请填写不同手机号！"];
        _nextStep.enabled = YES;
        return;
    }
    if ([GTUser.manger.userInfoModel.phoneNo isEqualToString:mutarr[2]] || [GTUser.manger.userInfoModel.phoneNo isEqualToString:mutarr[5]]) {
        [GTHUD showErrorWithTitle:@"联系电话不能为本人注册账号！"];
        _nextStep.enabled = YES;
        return;
    }
    
    [GTHUD showStatusWithTitle:@"请求中..."];
    
    OrderModel *model1 = [[OrderModel alloc] init];
    model1.name = mutarr[0];
    model1.relation = mutarr[1];
    model1.phoneNo = mutarr[2];
    NSDictionary *dic1 = [model1 yy_modelToJSONObject]; // 转为字典
    
    
    OrderModel *model2 = [[OrderModel alloc] init];
    model2.name = mutarr[3];
    model2.relation = mutarr[4];
    model2.phoneNo = mutarr[5];
    NSDictionary *dic2 = [model2 yy_modelToJSONObject]; // 转为字典
    
    NSMutableArray *data = [NSMutableArray arrayWithObjects:dic1,dic2, nil];
    
    NSDictionary *dict = [NSDictionary dictionaryWithObjectsAndKeys:GTApiCode.submitElinkman,@"interId",data,@"persons", nil];

    WEAKSELF
    [[GTApi requestParams:dict andResmodel:[OrderModel class] andAuthStatus:nil]
     subscribeNext:^(OrderModel*  _Nullable resModel) {
         
         // model.message
         GTLog(@"上传紧急联系人请求内容:\n%@",dict);
         [GTHUD showSuccessWithTitle:@"提交成功！"];
//         [GTUser.manger reloadUserInfoWithSucc:nil fail:nil];
         
         GTAmountController *amount = [[GTAmountController alloc]init];
         [weakSelf.navigationController pushViewController:amount animated:YES];
         
         _nextStep.enabled = YES;
         
     } error:^(NSError * _Nullable error) {
         
         GTNetError *err = (GTNetError *) error;
         GTLog(@"#####%@", err);
         [GTHUD showErrorWithTitle:[NSString stringWithFormat:@"%@",err.msg]];
         
         _nextStep.enabled = YES;
     }];
}
- (void) dealloc {
    //
    [[NSNotificationCenter defaultCenter] removeObserver:self];
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

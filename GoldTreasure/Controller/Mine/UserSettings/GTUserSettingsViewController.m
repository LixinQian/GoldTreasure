//
//  GTUserSettingsViewController.m
//  GoldTreasure
//
//  Created by wangyaxu on 30/06/2017.
//  Copyright © 2017 zhaofanjinrong.com. All rights reserved.
//

#import "GTUserSettingsViewController.h"
#import "GTMineTableViewCell.h"
//#import "GTFeedBackViewController.h"
#import "GTQiYuCustomerService.h"
#import "GTForgetPasswordController.h"

#import <Masonry/Masonry.h>
#import <SDWebImage/SDImageCache.h>

@interface GTUserSettingsViewController ()<UITableViewDelegate, UITableViewDataSource>

@property (nonatomic, strong) UITableView *tableView;

@end

@implementation GTUserSettingsViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc]initWithCustomView:[ReturnBack buttonWithType:UIButtonTypeCustom ReturnBackStyle:ReturnBackStyleBlack Target:self Action:@selector(returnBackAction)]];
    self.navigationItem.title = @"设置";
    self.view.backgroundColor = [GTColor gtColorC3];
    self.automaticallyAdjustsScrollViewInsets = NO;

    [self setupInterface];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark    -   set up interface    -

- (void)setupInterface
{
    UITableView *tableView = [[UITableView alloc] initWithFrame:CGRectZero style:UITableViewStylePlain];
    tableView.backgroundColor = [UIColor clearColor];
    tableView.contentInset = UIEdgeInsetsMake(15, 0, 0, 0);
    [tableView setSeparatorStyle:UITableViewCellSeparatorStyleNone];
    tableView.delegate = self;
    tableView.dataSource = self;
    [self.view addSubview:tableView];
    self.tableView = tableView;
        
    [self.tableView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.mas_topLayoutGuide);
        make.left.right.and.bottom.equalTo(self.view);
    }];
    
    [self.tableView registerClass:[GTMineTableViewCell class] forCellReuseIdentifier:@"GTMineTableViewCell"];
}

#pragma mark    -   table View methods -

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    NSArray *configArray = [self functionsConfigArray];
    return configArray.count;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    NSArray *configArray = [self functionsConfigArray];
    NSArray *sectionArray = configArray[section];
    return sectionArray.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    GTMineTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"GTMineTableViewCell" forIndexPath:indexPath];
    NSArray *configArray = [self functionsConfigArray];
    if (indexPath.section == configArray.count - 1) {
        
        UILabel *logOutLabel = [UILabel labelWithFont:[GTFont gtFontF2] textColor:[GTColor gtColorC14] text:@"退出登录"];
        [cell shouldHideSeparatorLine:YES];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        [cell.contentView addSubview:logOutLabel];
        
        [logOutLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.center.equalTo(cell);
        }];
    } else {
        [self config:cell atIndexPath:indexPath withContent:configArray];
    }
    return cell;
}

- (void)config:(GTMineTableViewCell *)cell atIndexPath:(NSIndexPath *)indexPath withContent:(NSArray *)content
{
    NSArray *sectionArray = content[indexPath.section];
    NSString *title = sectionArray[indexPath.row];
    [cell setTitle: title];
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    
    if (indexPath.section == 0 && indexPath.row == 0) {
        CGFloat fileSize = [self calculateCaches];
        [cell setSubTitle:[NSString stringWithFormat:@"%.2fMB", fileSize] withOffset:-15];
    } else {
        cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
    }
    //每个分区最后一格无分割线
    if (indexPath.row == sectionArray.count - 1) {
        [cell shouldHideSeparatorLine:YES];
    }
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 50;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    switch (section) {
        case 0:
            return 0;
            break;
        case 1:
            return 15;
            break;
        case 2:
            return 60;
            break;
            
        default:
            break;
    }
    return 15;
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    UIView *headerView = [UIView new];
    return headerView;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    switch (indexPath.section) {
        case 0:
        {
            switch (indexPath.row) {
                case 0:
                    [self cleanCaches];
                    break;
                case 1:
                    [self commonProblem];
                    break;
                case 2:
                    [self feedBack];
                    break;
                    
                default:
                    break;
            }
        }
            break;
        case 1:
            [self forgetPassword];
            break;
        case 2:
            [self logoutUser];
            break;
            
        default:
            break;
    }
}

- (CGFloat )calculateCaches
{
    CGFloat folderSize = 0.0;
    //目前只算图片的缓存
    folderSize = [[SDImageCache sharedImageCache] getSize];
    //转换为M为单位
    CGFloat sizeM = folderSize /1024.0/1024.0;
    
    return sizeM;
}

- (void)cleanCaches
{
    [GTHUD showStatusWithTitle:@"缓存清理中"];
    WEAKSELF
    //目前只清理sd缓存的图片
    [[SDImageCache sharedImageCache] clearDiskOnCompletion:^{
        //至少清理1s
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1.0 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
            CGFloat fileSize = [self calculateCaches];
            GTMineTableViewCell *cell = [weakSelf.tableView cellForRowAtIndexPath:[NSIndexPath indexPathForRow:0 inSection:0]];
            [cell setSubTitle:[NSString stringWithFormat:@"%.2fMB", fileSize] withOffset:-15];
            [GTHUD dismiss];
        });
    }];
}

- (void)commonProblem
{
    GTWKWebVC *problemVC = [[GTWKWebVC alloc] initWithUrlStr:FAQ];
    [self.navigationController pushViewController:problemVC animated:YES];
}

- (void)feedBack
{
//    GTFeedBackViewController *feedBackVC = [GTFeedBackViewController new];
//    [self.navigationController pushViewController:feedBackVC animated:YES];
    QYSessionViewController *sessionViewController = [GTQiYuCustomerService defaultSessionControllerWithSessionType:QYSessionTypeFeedBack];
    [self.navigationController pushViewController:sessionViewController animated:YES];
}

- (void)forgetPassword
{
    GTForgetPasswordController *reset = [[GTForgetPasswordController alloc]init];
    reset.passWordFlag = 2;
    [self.navigationController pushViewController:reset animated:YES];
}

- (void)logoutUser
{
    WEAKSELF
    [GTHUD showAlertWithContent:@"确认退出" trueTitle:@"确认" cancelTitle:@"取消" trueCol:^{
        [GTUser.manger logoutWithTitle:nil proTitle:@"退出中..." succ:^{
            [weakSelf.navigationController popToRootViewControllerAnimated:YES];
        } fail:nil];
    } cancelCol:nil];

}

- (NSArray *)functionsConfigArray
{
    return @[
             @[
                 @"清除缓存",
                 @"常见问题",
                 @"意见反馈"
                 ],
             @[
                 @"修改登录密码"
                 ],
             @[
                 @"退出登录"
                 ]
             ];
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

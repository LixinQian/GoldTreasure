//
//  GTContactUsViewController.m
//  GoldTreasure
//
//  Created by wangyaxu on 30/06/2017.
//  Copyright © 2017 zhaofanjinrong.com. All rights reserved.
//

#import "GTContactUsViewController.h"
//#import "GTOnlineServiceViewController.h"
#import "GTContactUsItemView.h"
#import "GTQiYuCustomerService.h"

#import <Masonry/Masonry.h>
#import <IQKeyboardManager/IQKeyboardManager.h>

@interface GTContactUsViewController ()<UITableViewDelegate, UITableViewDataSource>

@property (nonatomic, strong) UITableView *tableView;
@property (nonatomic, strong) UIView *barShelter;

@end

@implementation GTContactUsViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    [[IQKeyboardManager sharedManager] setEnable:NO];
    self.view.backgroundColor = [UIColor colorWithWhite:0 alpha:.5f];
    
    [self setupInterface];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark    -   set up interface    -

- (void)setupInterface
{
    UIButton *bigBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [bigBtn addTarget:self action:@selector(cancelContact:) forControlEvents:UIControlEventTouchDown];
    [self.view addSubview:bigBtn];
    
    [bigBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(self.view);
    }];
    
    UITableView *tableView = [[UITableView alloc] initWithFrame:CGRectZero style:UITableViewStylePlain];
    tableView.layer.cornerRadius = 12;
    tableView.scrollEnabled = NO;
    tableView.backgroundColor = [UIColor whiteColor];
    [tableView setSeparatorStyle:UITableViewCellSeparatorStyleNone];
    tableView.delegate = self;
    tableView.dataSource = self;
    [self.view addSubview:tableView];
    self.tableView = tableView;
    
    {
        [self.tableView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.size.mas_equalTo(CGSizeMake(295, 182));
            make.center.equalTo(self.view);
        }];
    }
    
    [self.tableView registerClass:[UITableViewCell class] forCellReuseIdentifier:@"cell"];
    
    self.barShelter = [UIView new];
    self.barShelter.backgroundColor = [UIColor colorWithWhite:0 alpha:.5f];
    self.barShelter.frame = CGRectMake(0, 0, ScreenWidth, 100);
    
    [self.tabBarController.tabBar addSubview:self.barShelter];
}

#pragma mark    -   table View methods -

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return 2;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"cell" forIndexPath:indexPath];
    switch (indexPath.row) {
        case 0:
        {
            GTContactUsItemView *onlineItem = [[GTContactUsItemView alloc] initWithIcon:[UIImage imageNamed:@"service_online"] title:@"在线客服" tip:@"每日在线时间：8:30-17:00"];
            [cell.contentView addSubview:onlineItem];
            [onlineItem mas_makeConstraints:^(MASConstraintMaker *make) {
                make.edges.equalTo(cell.contentView);
            }];
        }
            break;
        case 1:
        {
            GTContactUsItemView *phoneItem = [[GTContactUsItemView alloc] initWithIcon:[UIImage imageNamed:@"service_tel"] title:@"拨打客服电话" tip:[NSString stringWithFormat:@"%@", SERVICETELE]];
            [phoneItem setSeparatorLineHidden:YES];
            [cell.contentView addSubview:phoneItem];
            [phoneItem mas_makeConstraints:^(MASConstraintMaker *make) {
                make.edges.equalTo(cell.contentView);
            }];
        }
            break;
            
        default:
            break;
    }
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 70;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    return 40;
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    UIView *headerView = [UIView new];
    
    UILabel *label = [UILabel labelWithFont:[GTFont gtFontF2] textColor:[GTColor gtColorC4] text:@"请选择联系方式"];
    
    UIView *line = [UIView new];
    line.backgroundColor = [GTColor gtColorC8];
    
    [headerView addSubview:label];
    [headerView addSubview:line];
    
    [label mas_makeConstraints:^(MASConstraintMaker *make) {
        make.center.equalTo(headerView);
    }];
    
    [line mas_makeConstraints:^(MASConstraintMaker *make) {
        make.height.equalTo(@.5f);
        make.left.right.and.bottom.equalTo(headerView);
    }];
    
    return headerView;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    switch (indexPath.row) {
        case 0:
            [self contactByOnlineService];
            break;
        case 1:
            [self contactByPhoneCall];
            break;
            
        default:
            break;
    }
}

#pragma mark    -   other methods   -

- (void)contactByOnlineService
{
    QYSessionViewController *sessionViewController = [GTQiYuCustomerService defaultSessionControllerWithSessionType:QYSessionTypeService];
    sessionViewController.hidesBottomBarWhenPushed = YES;
    
    [self.navigationController pushViewController:sessionViewController animated:YES];

    [self cancelContact:nil];
}

- (void)contactByPhoneCall
{
    NSString *urlString = [NSString stringWithFormat:@"tel://%@", SERVICETELE];
    [[UIApplication sharedApplication] openURL:[NSURL URLWithString:urlString]];
    [self cancelContact:nil];
}

- (void)cancelContact:(id )sender
{
    [UIView animateWithDuration:.3f animations:^{
        self.view.alpha = 0;
        self.barShelter.alpha = 0;
    } completion:^(BOOL finished) {
        [self.view removeFromSuperview];
        [self.barShelter removeFromSuperview];
        [self removeFromParentViewController];
    }];
}

- (void)dealloc{

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

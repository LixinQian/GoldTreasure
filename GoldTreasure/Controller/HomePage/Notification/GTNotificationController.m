//
//  GTNotificationController.m
//  GoldTreasure
//
//  Created by 王超 on 2017/6/28.
//  Copyright © 2017年 zhaofanjinrong.com. All rights reserved.
//

#import "GTNotificationController.h"
#import "GTNotificationCell.h"
#import "GTNotificationModel.h"
#import "GTNotificationNormalCell.h"
#import <Masonry/Masonry.h>

@interface GTNotificationController ()<UITableViewDelegate,UITableViewDataSource>

@property (nonatomic, strong) UITableView *notificationTableView;

@property (nonatomic, strong) NSMutableArray<GTNotificationModel *> *allDataArr;

//无消息缺省页
@property (nonatomic, strong) UIImageView *messageImage;
@property (nonatomic, strong) UILabel *messageLabel;

@end

@implementation GTNotificationController

-(UITableView *)notificationTableView
{
    if (!_notificationTableView) {
        _notificationTableView = [[UITableView alloc]initWithFrame:self.view.frame style:UITableViewStylePlain];
        _notificationTableView.delegate = self;
        _notificationTableView.dataSource = self;
        _notificationTableView.backgroundColor = [GTColor gtColorC3];
        _notificationTableView.separatorStyle = UITableViewCellSeparatorStyleNone;
//        _notificationTableView.showsVerticalScrollIndicator = NO;
        
        [_notificationTableView registerClass:[GTNotificationCell class] forCellReuseIdentifier:@"cellAction"];
        [_notificationTableView registerClass:[GTNotificationNormalCell class] forCellReuseIdentifier:@"cellNormal"];
        
        UIView *view = [[UIView alloc]initWithFrame:CGRectMake(0, 0, ScreenWidth, autoScaleH(7.5))];
        view.backgroundColor = [GTColor gtColorC3];
        _notificationTableView.tableHeaderView = view;
        
        UIView *view1 = [[UIView alloc]initWithFrame:CGRectMake(0, 0, ScreenWidth, autoScaleH(7.5))];
        view1.backgroundColor = [GTColor gtColorC3];
        _notificationTableView.tableFooterView = view1;
        
        //自适应高度处理
        _notificationTableView.estimatedRowHeight = 10;
        _notificationTableView.rowHeight = UITableViewAutomaticDimension;
    }
    
    return _notificationTableView;
}

-(NSMutableArray *)allDataArr
{
    if (!_allDataArr) {
        _allDataArr = [NSMutableArray array];
    }
    return _allDataArr;
}

- (void)viewDidLoad {
    
    [super viewDidLoad];
    self.navigationItem.title = @"系统通知";
    self.view.backgroundColor = [GTColor gtColorC3];
    
    [self.view addSubview:self.notificationTableView];
    [self showDefault];
    [self loadNotiData];
    
    // 监听个推 通知
    WEAKSELF
    [GTNoti listenNotiChangeWithBlock:^{
        [weakSelf loadNotiData];
    }];
}

-(void)viewWillAppear:(BOOL)animated {
    
    self.navBarAlpha = 1;
//    self.navBarTintColor = [UIColor redColor];
    self.navBarTintColor = [GTColor gtColorC2];
}
// 视图消失
- (void) viewWillDisappear:(BOOL)animated {
    
//    self.navBarBgAlpha = 1;
//    self.navBarTintColor = [UIColor redColor];
    [GTUser setAppHasNoReadNotiWithIsFrist:false];
}

#pragma UITableView代理方法
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return self.allDataArr.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    GTNotificationModel *model = [_allDataArr objectAtIndex:indexPath.row];
    
    if ([model.bText isEmptyOrWhitespace] || !model.bText) {
        
        static NSString *indentifier = @"cellNormal";
        GTNotificationNormalCell *cell = [tableView dequeueReusableCellWithIdentifier:indentifier];
        if (cell == nil) {
            cell = [[GTNotificationNormalCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:indentifier];
        }
        cell.model = model;
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        return cell;
        
    }
    else
    {

        static NSString *indentifier = @"cellAction";
        GTNotificationCell *cell = [tableView dequeueReusableCellWithIdentifier:indentifier];
        if (cell == nil) {
            cell = [[GTNotificationCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:indentifier];
        }
        [self setBtnActionWithCell:cell];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        cell.model = model;
        return cell;
    }
    
    
}

//删除
-(UITableViewCellEditingStyle)tableView:(UITableView *)tableView editingStyleForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return UITableViewCellEditingStyleDelete;
}

-(void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath
{

    if (editingStyle == UITableViewCellEditingStyleDelete) {
        if (tableView == self.notificationTableView) {
            
            [GTNoti.manger deleteNotiWithRlm:_allDataArr[indexPath.row] succ:^{
            
                [self.allDataArr removeObjectAtIndex:indexPath.row];
                [self.notificationTableView deleteRowsAtIndexPaths:[NSMutableArray arrayWithObject:indexPath] withRowAnimation:UITableViewRowAnimationRight];
                
                if (self.allDataArr.count == 0) {
                    [self.notificationTableView setHidden:YES];
                    [self.messageImage setHidden:NO];
                    [self.messageLabel setHidden:NO];
                    
                }
            }];
            
        }
    }
    
}

-(NSString *)tableView:(UITableView *)tableView titleForDeleteConfirmationButtonForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return @"删除";
}


-(void)setBtnActionWithCell:(GTNotificationCell *)cell
{
    
    cell.notiBlock = ^(GTNotificationModel *model) {
        
        [[NSOperationQueue mainQueue] addOperationWithBlock:^{
            
            [GTRouter routerWithUrlWithStr:model.appUrl];
        }];
        
//        1.huajinbao://auth.list
//        2.huajinbao://repay.list
//        3.huajinbao://repay.order
//        GTLog(@"%@",model);
    };
}

- (void)showDefault
{
    _messageImage = [UIImageView new];
    _messageImage.image = [UIImage imageNamed:@"no_message"];
    [self.view addSubview:_messageImage];
    _messageLabel = [UILabel new];
    _messageLabel.text = @"暂无消息~";
    _messageLabel.textAlignment = NSTextAlignmentCenter;
    _messageLabel.font = [GTFont gtFontF2];
    _messageLabel.textColor = [GTColor gtColorC6];
    [self.view addSubview:_messageLabel];
    
    [_messageImage mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(self.view);
        make.top.equalTo(self.view).offset(autoScaleH(125));
        make.size.mas_equalTo(CGSizeMake(autoScaleW(70), autoScaleH(60)));
    }];
    [_messageLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(self.view);
        make.top.equalTo(_messageImage.mas_bottom).offset(autoScaleH(25));
        make.size.mas_equalTo(CGSizeMake(autoScaleW(150), autoScaleH(18)));
    }];
}

// 请求 通知信息 通过
- (void) loadNotiData {
    
    WEAKSELF
    [GTNoti.manger getNotiFronDBWithResultBlock:^(NSArray<GTNotificationModel *> * _Nonnull list) {
        
        weakSelf.allDataArr = [list mutableCopy];
        
        if (weakSelf.allDataArr.count > 0) {
            [self.notificationTableView setHidden:NO];
            [self.messageImage setHidden:YES];
            [self.messageLabel setHidden:YES];
            
            [_notificationTableView reloadData];
            
        } else {
            [self.notificationTableView setHidden:YES];
            [self.messageImage setHidden:NO];
            [self.messageLabel setHidden:NO];
            
        }
        
    }];

}

@end

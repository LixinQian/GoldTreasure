//
//  GTMineViewController.m
//  GoldTreasure
//
//  Created by wangyaxu on 27/06/2017.
//  Copyright © 2017 zhaofanjinrong.com. All rights reserved.
//

#import "GTMineViewController.h"
#import "GTMineHeaderView.h"
#import "GTMineTableViewCell.h"
#import "GTLoginController.h"
#import "GTAuthCenterViewController.h"
#import "GTAboutUsViewController.h"
#import "GTContactUsViewController.h"
#import "GTUserSettingsViewController.h"
#import "GTSystemAuth.h"
#import "WDImageManager.h"

#import <Masonry/Masonry.h>
#import <SDWebImage/UIImageView+WebCache.h>

@interface GTMineViewController ()<UITableViewDelegate, UITableViewDataSource, UINavigationControllerDelegate, UIImagePickerControllerDelegate>

@property (nonatomic, strong) GTMineHeaderView *headerView;
@property (nonatomic, strong) UITableView *functionsTableView;

@end

@implementation GTMineViewController

//取消导航栏分割线
//-(void)setNavigationBarShadowImage
//{
//    [self.navigationController.navigationBar setBackgroundImage:[UIImage new] forBarMetrics:UIBarMetricsDefault];
//    [self.navigationController.navigationBar setShadowImage:[UIImage new]];
//}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    self.automaticallyAdjustsScrollViewInsets = NO;
    self.navigationController.navigationBar.translucent = YES;
//    self.navigationItem.title = @"我的";
    UILabel *lab = [[UILabel alloc]init];
    lab.text = @"我的";
    [lab sizeToFit];
    lab.textColor = [GTColor gtColorC2];
    lab.backgroundColor = [UIColor clearColor];
    self.navigationItem.titleView = lab;
//    [self setNavigationBarShadowImage];

    self.navBarTintColor = [GTColor gtColorC2];
    
    

    [self setupInterface];
    [self requestNetwork];
}


- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    [UIApplication sharedApplication].statusBarStyle = UIStatusBarStyleLightContent;
    self.navBarAlpha = 0;
    self.view.backgroundColor = [GTColor gtColorC3];
}

- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
    [UIApplication sharedApplication].statusBarStyle = UIStatusBarStyleLightContent;
}

- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
    [UIApplication sharedApplication].statusBarStyle = UIStatusBarStyleDefault;
    self.navBarAlpha = 1;
}

#pragma mark    -   set up interface    -

- (void)setupInterface
{
    UITableView *functionsTableView = [[UITableView alloc] initWithFrame:CGRectZero style:UITableViewStylePlain];
    functionsTableView.backgroundColor = [UIColor clearColor];
    [functionsTableView setSeparatorStyle:UITableViewCellSeparatorStyleNone];
    functionsTableView.delegate = self;
    functionsTableView.dataSource = self;
    [self.view addSubview:functionsTableView];
    self.functionsTableView = functionsTableView;
    
    {
        [self.functionsTableView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.edges.equalTo(self.view);
        }];
    }
    
    [self.functionsTableView registerClass:[GTMineTableViewCell class] forCellReuseIdentifier:@"GTMineTableViewCell"];
}

#pragma mark    -   network request -

- (void)requestNetwork
{
    WEAKSELF
    //监听个人信息的变更
    [GTUser.manger listenUserInfoChangedWithChanged:^(GTResModelUserInfo * _Nonnull info) {

        dispatch_async(dispatch_get_main_queue(), ^{
            if (info.certificationStatus.integerValue == GTAuthStatusSucceed) {
                [weakSelf.headerView setName:info.custName];
            } else {
                [weakSelf.headerView setName:@"尚未实名认证"];
            }
            [weakSelf.headerView setPhoneNumber:info.phoneNo];
            //设置头像
            if (info.headimgUrl) {
                NSURL *headImgUrl = [NSURL URLWithString:info.headimgUrl];
                [weakSelf.headerView.avatarImageView sd_setImageWithURL:headImgUrl];
            } else {
                weakSelf.headerView.avatarImageView.image = [UIImage imageNamed:@"default_avatar"];
            }
            [weakSelf.headerView setNeedsDisplay];
            GTMineTableViewCell *statusCell = [self.functionsTableView cellForRowAtIndexPath:[NSIndexPath indexPathForRow:0 inSection:1]];
            [weakSelf setUserAuthStatusWithCell:statusCell];
        });
    }];
}

#pragma mark    -   table View methods -

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    NSArray *configArray = [self mineFunctionsConfigArray];
    return configArray.count;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    NSArray *configArray = [self mineFunctionsConfigArray];
    NSArray *sectionArray = configArray[section];
    return sectionArray.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    GTMineTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"GTMineTableViewCell" forIndexPath:indexPath];
    NSArray *configArray = [self mineFunctionsConfigArray];
    [self config:cell atIndexPath:indexPath withContent:configArray];
    return cell;
}

- (void)config:(GTMineTableViewCell *)cell atIndexPath:(NSIndexPath *)indexPath withContent:(NSArray *)content
{
    NSArray *sectionArray = content[indexPath.section];
    NSString *iconName = sectionArray[indexPath.row][@"icon"];
    NSString *title = sectionArray[indexPath.row][@"mTitle"];
    UIImage *icon = [UIImage imageNamed:iconName];
    [cell setIcon: icon];
    [cell setTitle: title];
    cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    
    //每个分区最后伊格无分割线
    if (indexPath.row == sectionArray.count - 1) {
        [cell shouldHideSeparatorLine:YES];
    }
    
    if (indexPath.row == 0 && indexPath.section == 1) {
        [self setUserAuthStatusWithCell:cell];
    }
}

- (void)setUserAuthStatusWithCell:(GTMineTableViewCell *)statusCell
{
    //设置审核状态
    GTResModelUserInfo *user = GTUser.manger.userInfoModel;
    NSInteger certificationStatus = user.certificationStatus.integerValue;
    NSInteger cardBindStatus = user.cardBindStatus.integerValue;
    NSInteger mobileStatus = user.mobileStatus.integerValue;
    NSInteger zfbStatus = user.zfbStatus.integerValue;
    if (certificationStatus == 0 && cardBindStatus == 0 && mobileStatus == 0 && zfbStatus == 0) {
        if ([GTUser isLogin]) {
            [statusCell setSubTitle:@"未认证" withOffset:0];
        } else {
            [statusCell setSubTitle:@"" withOffset:0];
        }
    } else if (certificationStatus == 2 && cardBindStatus == 2 && mobileStatus == 2 && zfbStatus == 2) {
        [statusCell setSubTitle:@"已认证" withOffset:0];
    } else {
        [statusCell setSubTitle:@"认证中" withOffset:0];
    }
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 50;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    if (section == 0) {
        return 205;
    }
    return 15;
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    if (section == 0) {
        GTMineHeaderView *headerView = [GTMineHeaderView new];
        [self.view addSubview:headerView];
        self.headerView = headerView;
        WEAKSELF
        headerView.changeAvatarBlock = ^{
            [weakSelf setAvatar];
        };
        headerView.loginBlock = ^{
            [GTUser.manger loginInSucc:nil fail:nil];
        };
        
        //赋初值
        GTResModelUserInfo *info = GTUser.manger.userInfoModel;
        if (info.certificationStatus.integerValue == GTAuthStatusSucceed) {
            [self.headerView setName:info.custName];
        } else {
            [self.headerView setName:@"尚未实名认证"];
        }
        [self.headerView setPhoneNumber:info.phoneNo];
        //设置头像
        if (info.headimgUrl) {
            NSURL *headImgUrl = [NSURL URLWithString:info.headimgUrl];
            [self.headerView.avatarImageView sd_setImageWithURL:headImgUrl];
        } else {
            self.headerView.avatarImageView.image = [UIImage imageNamed:@"default_avatar"];
        }
        
        return headerView;
    }

    UIView *headerView = [UIView new];
    return headerView;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    BOOL rate = indexPath.section == 1 && indexPath.row == 1;
    BOOL aboutUs = indexPath.section == 2 && indexPath.row == 0;
    BOOL contactUs = indexPath.section == 2 && indexPath.row == 1;
    
    if (!GTUser.isLogin && !rate && !aboutUs && !contactUs) {
        [GTUser.manger loginInSucc:nil fail:nil];
        return;
    }
    if (indexPath.section == 1) {
        switch (indexPath.row) {
            case 0:
                [self gotoAuthenticateUser];
                break;
            case 1:
                [self gotoInquireRate];
                
            default:
                break;
        }
    } else if (indexPath.section == 2) {
        switch (indexPath.row) {
            case 0:
                [self gotoKnowUs];
                break;
            case 1:
                [self gotoContactUs];
                break;
            case 2:
                [self gotoSettings];
                
            default:
                break;
        }
    }
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

#pragma mark    -   other methods   -

- (void)gotoAuthenticateUser
{
    GTAuthCenterViewController *authCenterVC = [GTAuthCenterViewController new];
    [self.navigationController pushViewController:authCenterVC animated:YES];
}

- (void)gotoInquireRate
{
    GTWKWebVC *rateInquiryVC = [[GTWKWebVC alloc] initWithUrlStr:RATE];
    rateInquiryVC.hidesBottomBarWhenPushed = YES;
    [self.navigationController pushViewController:rateInquiryVC animated:YES];
}

- (void)gotoKnowUs
{
    GTAboutUsViewController *aboutUsVC = [GTAboutUsViewController new];
    aboutUsVC.hidesBottomBarWhenPushed = YES;
    [self.navigationController pushViewController:aboutUsVC animated:YES];
}

- (void)gotoContactUs
{
    GTContactUsViewController *contactUsVC = [GTContactUsViewController new];
    [self addChildViewController:contactUsVC];
    [self.view addSubview:contactUsVC.view];
    [contactUsVC didMoveToParentViewController:self];
}

- (void)gotoSettings
{
    GTUserSettingsViewController *userSettingsVC = [GTUserSettingsViewController new];
    userSettingsVC.hidesBottomBarWhenPushed = YES;
    [self.navigationController pushViewController:userSettingsVC animated:YES];
}

- (void)setAvatar
{
    if (!GTUser.isLogin) {
        [GTUser.manger loginInSucc:nil fail:nil];
        return;
    }
    
    [[WDImageManager sharedManager] getCircleImageInVc:self withSize:CGSizeMake(200, 200) withCallback:^(UIImage *image) {
        [self sendChangeAvatarReqWithImage:image];
    }];
    /*
    WEAKSELF
    UIAlertController *alertController = [UIAlertController alertControllerWithTitle:nil message:nil preferredStyle:UIAlertControllerStyleActionSheet];
    UIAlertAction *takePhotoAction = [UIAlertAction actionWithTitle:@"拍照上传" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        //take photo
        [weakSelf takePhoto];
    }];
    UIAlertAction *albumAction = [UIAlertAction actionWithTitle:@"从相册选择" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        //album
        [weakSelf showAlbum];
    }];
    UIAlertAction *cancelAction = [UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleCancel handler:nil];

    [alertController addAction:takePhotoAction];
    [alertController addAction:albumAction];
    [alertController addAction:cancelAction];
    [self presentViewController:alertController animated:YES completion:nil];*/
}
/*
- (void)takePhoto
{
    if ([UIImagePickerController isSourceTypeAvailable:UIImagePickerControllerSourceTypeCamera]) {
        WEAKSELF
        [GTSystemAuth showAlertWithAuthType:GTSystemAuthTypeCamera completionHandler:^(GTSystemAuthStatus status) {
            if (status == GTSystemAuthStatusAuthorized) {
                // 初始化图片选择控制器
                UIImagePickerController *controller = [[UIImagePickerController alloc] init];
                [controller setSourceType:UIImagePickerControllerSourceTypeCamera];
                controller.allowsEditing = YES;
                controller.delegate = weakSelf;
                [weakSelf presentViewController:controller animated:YES completion:nil];
            }
        }];
    } else {
        NSLog(@"can't use camera");
    }
}

- (void)showAlbum
{
    if ([UIImagePickerController isSourceTypeAvailable:UIImagePickerControllerSourceTypePhotoLibrary]) {
        WEAKSELF
        [GTSystemAuth showAlertWithAuthType:GTSystemAuthTypePhotos completionHandler:^(GTSystemAuthStatus status) {
            if (status == GTSystemAuthStatusAuthorized) {
                UIImagePickerController *controller = [[UIImagePickerController alloc] init];
                [controller setSourceType:UIImagePickerControllerSourceTypePhotoLibrary];// 设置类型
                controller.allowsEditing = YES;
                controller.delegate = weakSelf;
                [weakSelf presentViewController:controller animated:YES completion:nil];
            }
        }];
    } else {
        NSLog(@"can't use library");
    }
}

- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary<NSString *,id> *)info
{
    UIImage *originImage = [info[UIImagePickerControllerOriginalImage] fixOrientation];
    CGRect cropRect = [info[UIImagePickerControllerCropRect] CGRectValue];
    UIImage *croppedImage = [self cropImage:originImage cropRect:cropRect];
    
    //upload image here
    [self sendChangeAvatarReqWithImage:croppedImage];
    //dismiss image picker
    [picker dismissViewControllerAnimated:YES completion:nil];
    
}

- (UIImage *)cropImage:(UIImage *)originImage cropRect:(CGRect )rect
{
    if (originImage.size.width == originImage.size.height) {
        return originImage;
    }
    
    UIImage *newImage = originImage;
    CGImageRef sourceImageRef = [originImage CGImage];
    CGImageRef newImageRef = CGImageCreateCopy(sourceImageRef);
    if (rect.origin.x >= 0 && rect.origin.y >= 0) {
        //根据系统框区域进行裁剪
        newImageRef = CGImageCreateWithImageInRect(sourceImageRef, rect);
    }
        //若图片不是正方形，先裁剪成正方形
    CGRect cropFrame = CGRectZero;
    CGFloat imgWidth = CGImageGetWidth(newImageRef);
    CGFloat imgHeight = CGImageGetHeight(newImageRef);
    
    if (fabs(imgWidth - imgHeight) < 2) {
        
    } else {
        if (imgWidth < imgHeight) {
            cropFrame = CGRectMake( 0, (imgHeight - imgWidth) / 2, imgWidth, imgWidth);
        } else {
            cropFrame = CGRectMake((imgWidth - imgHeight) / 2, 0, imgHeight, imgHeight);
        }
        newImageRef = CGImageCreateWithImageInRect(newImageRef, cropFrame);
    }
    newImage = [UIImage imageWithCGImage:newImageRef scale:1.0 orientation:originImage.imageOrientation];
    CGImageRelease(newImageRef);
    
    return newImage;
}*/

- (void)sendChangeAvatarReqWithImage:(UIImage *)image
{
    WEAKSELF
    [GTLoginService.sharedInstance uploadUserAvatarWithImage:image andProgress:^(float progress) {
        [GTHUD showProgressWithPro:progress];
        //progress
    } succ:^(id resModel, NSString *imageUrl) {
        GTLog(@"%@", resModel)
        dispatch_async(dispatch_get_main_queue(), ^{
            NSURL *avatarUrl = [NSURL URLWithString:imageUrl];
            [weakSelf.headerView.avatarImageView sd_setImageWithURL:avatarUrl];
            [GTHUD dismiss];
        });
    } fail:^(GTNetError *error) {
        [GTHUD showErrorWithTitle:error.msg];
    }];

}

//我的页面配置信息
- (NSArray *)mineFunctionsConfigArray
{
    return @[
             @[
                 ],
             
             @[
                 @{
                     @"icon" : @"authentication",
                     @"mTitle" : @"认证中心"
                     },
                 @{
                     @"icon" : @"rate",
                     @"mTitle" : @"费率查询"
                     }
                 ],
             @[
                 @{
                     @"icon" : @"about_us",
                     @"mTitle" : @"关于我们"
                     },
                 @{
                     @"icon" : @"customer_service",
                     @"mTitle" : @"联系我们"
                     },
                 @{
                     @"icon" : @"set",
                     @"mTitle" : @"设置"
                     }
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

//
//  GTAboutUsViewController.m
//  GoldTreasure
//
//  Created by wangyaxu on 30/06/2017.
//  Copyright © 2017 zhaofanjinrong.com. All rights reserved.
//

#import "GTAboutUsViewController.h"

#import <Masonry/Masonry.h>

@interface GTAboutUsViewController ()

@end

@implementation GTAboutUsViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc]initWithCustomView:[ReturnBack buttonWithType:UIButtonTypeCustom ReturnBackStyle:ReturnBackStyleBlack Target:self Action:@selector(returnBackAction)]];
    self.navigationItem.title = @"关于我们";
    self.view.backgroundColor = [GTColor gtColorC3];

    [self setupInterface];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark    -   set up interface    -

- (void)setupInterface
{
    UIImageView *mainImageView = [UIImageView new];
    mainImageView.layer.cornerRadius = 30;
    
    UILabel *titleLabel = [UILabel labelWithFont:[GTFont gtFontF1] textColor:[GTColor gtColorC4]];
    
    UIButton *agreementBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    
    UILabel *rightsLabel = [UILabel labelWithFont:[GTFont gtFontF4] textColor:[GTColor gtColorC6]];
    
    mainImageView.image = [UIImage imageNamed:@"LOGO"];
    NSDictionary *appInfoDict = [GTClient getAppInfoDict];

#if __DEV
    titleLabel.text = [NSString stringWithFormat:@"花乐宝 v%@（%@）", appInfoDict[@"CFBundleShortVersionString"], appInfoDict[@"CFBundleVersion"]];
#else
    titleLabel.text = [NSString stringWithFormat:@"花乐宝 v%@", appInfoDict[@"CFBundleShortVersionString"]];
#endif
    agreementBtn.titleLabel.font = [GTFont gtFontF3];
    [agreementBtn setTitle:@"用户协议" forState:UIControlStateNormal];
    [agreementBtn setTitleColor:[GTColor gtColorC17] forState:UIControlStateNormal];
    [agreementBtn addTarget:self action:@selector(clickAgreementBtn:) forControlEvents:UIControlEventTouchUpInside];
    
    rightsLabel.text = @"Copyright 2017 宁波零加零新材料有限公司 版权所有";
    
    [self.view addSubview:mainImageView];
    [self.view addSubview:titleLabel];
    [self.view addSubview:agreementBtn];
    [self.view addSubview:rightsLabel];
    
    {
        [mainImageView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.size.mas_equalTo(CGSizeMake(100, 100));
            make.top.equalTo(self.mas_topLayoutGuide).with.offset(140);
            make.centerX.equalTo(self.view.mas_centerX);
        }];
     
        [titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(mainImageView.mas_bottom).with.offset(20);
            make.centerX.equalTo(self.view.mas_centerX);
        }];
        
        [agreementBtn mas_makeConstraints:^(MASConstraintMaker *make) {
            make.bottom.equalTo(rightsLabel.mas_top).with.offset(-10);
            make.centerX.equalTo(self.view.mas_centerX);
        }];
        
        [rightsLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.bottom.equalTo(self.view.mas_bottom).with.offset(-20);
            make.centerX.equalTo(self.view.mas_centerX);
        }];
    }
}

- (void)clickAgreementBtn:(UIButton *)btn
{
    GTWKWebVC *agreementVC = [[GTWKWebVC alloc] initWithUrlStr:USERAGREEMENT];
    [self.navigationController pushViewController:agreementVC animated:YES];
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

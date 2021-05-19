//
//  GTTripartiteContractController.m
//  GoldTreasure
//
//  Created by 王超 on 2017/7/4.
//  Copyright © 2017年 zhaofanjinrong.com. All rights reserved.
//

#import "GTTripartiteContractController.h"
#import "GTShowSignature.h"
#import "GTSubmittedSuccessfullyController.h"
#import "OrderModel.h"

@interface GTTripartiteContractController ()<UIWebViewDelegate>
{
    UIWebView *webView;
    
    UIActivityIndicatorView *activityIndicator;
    GTShowSignature *signature;
}

@property (nonatomic, strong) UIButton *submitBtn;

@end

@implementation GTTripartiteContractController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"三方借款合同";
    self.view.backgroundColor = [UIColor whiteColor];
    
    webView = [[UIWebView alloc] initWithFrame:CGRectMake(0, 0, ScreenWidth, ScreenHeight-autoScaleH(50))];
    NSURLRequest *request =[NSURLRequest requestWithURL:[NSURL URLWithString:LOANCONTRACT]];
    [self.view addSubview: webView];
    [webView loadRequest:request];
    webView.backgroundColor = [UIColor whiteColor];
    webView.delegate = self;
}

- (void) webViewDidStartLoad:(UIWebView *)webView
{
    //创建UIActivityIndicatorView背底半透明View
    UIView *view = [[UIView alloc] initWithFrame:CGRectMake(0, 0, ScreenWidth, ScreenHeight)];
    [view setTag:108];
    [view setBackgroundColor:[UIColor blackColor]];
    [view setAlpha:0.4];
    [self.view addSubview:view];
    
    activityIndicator = [[UIActivityIndicatorView alloc] initWithFrame:CGRectMake(0.0f, 0.0f, 32.0f, 32.0f)];
    [activityIndicator setCenter:view.center];
    [activityIndicator setActivityIndicatorViewStyle:UIActivityIndicatorViewStyleWhite];
    [view addSubview:activityIndicator];
    
    [activityIndicator startAnimating];
    
}
- (void) webViewDidFinishLoad:(UIWebView *)webView
{
    [activityIndicator stopAnimating];
    UIView *view = (UIView*)[self.view viewWithTag:108];
    [view removeFromSuperview];
    
    //加载完成添加按钮
    [self.view addSubview:self.submitBtn];
    
}
- (void) webView:(UIWebView *)webView didFailLoadWithError:(NSError *)error
{
    [activityIndicator stopAnimating];
    UIView *view = (UIView*)[self.view viewWithTag:108];
    [view removeFromSuperview];
}
-(UIButton *)submitBtn
{
    if (!_submitBtn) {
        _submitBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        _submitBtn.frame = CGRectMake(0, ScreenHeight-autoScaleH(50), ScreenWidth, autoScaleH(50));
        _submitBtn.backgroundColor = [GTColor gtColorC1];
        _submitBtn.adjustsImageWhenHighlighted = NO;
        [_submitBtn setTitle:@"已阅读并同意签署合同" forState:UIControlStateNormal];
        [_submitBtn setTitleColor:[GTColor gtColorC4] forState:UIControlStateNormal];
        _submitBtn.titleLabel.font = [GTFont gtFontF1];
        [_submitBtn addTarget:self action:@selector(submitBtnAction) forControlEvents:UIControlEventTouchUpInside];
    }
    return _submitBtn;
}

-(void)submitBtnAction
{
    signature = [[GTShowSignature alloc]init];
    [signature showView];
    
    __weak GTTripartiteContractController *weakSelf = self;
    
    signature.saveBlock = ^(UIImage *image) {
        
        if (image) {
            [weakSelf postDataWithImage:image];
        }
        
    };
}

-(void)postDataWithImage:(UIImage *)image
{

    if (!image) {
        [GTHUD showErrorWithTitle:@"签名失败！"];
        return;
    }
    signature.okBtn.enabled = NO;
    
    OrderModel *model = [[OrderModel alloc] init];
    model.interId = GTApiCode.submitLoan;  // 接口编号 在GTApiCode 中定义,要自己定义
    model.reqMoney = [NSNumber numberWithInt:_acount];
    model.handleFee = [NSNumber numberWithInt:_fee];
    model.clientid = [GTUser getGeTuiClentID];
    NSDictionary *dict = [model yy_modelToJSONObject]; // 转为字典
    
    WEAKSELF
     __block NSMutableDictionary *mutdict = [dict mutableCopy];
    [GTHUD showMaskStatusWithView:signature title:@"正在提交..." block:^(MBProgressHUD * _Nonnull hud) {
        signature.userInteractionEnabled = NO;
        self.navigationController.view.userInteractionEnabled = NO;
        [[[[GTApi upLoadData:UIImagePNGRepresentation(image) andFileName:@"signature.jpg" andProgress:^(float progress) {
            //
            GTLog(@"上传进度：%f",progress);
            
        } andAuthStatus:GTNetAuthStatusTypeLogined] doNext:^(NSString  *_Nullable urlPath) {
            
            GTLog(@"oss地址：%@",urlPath);
            mutdict[@"signImage"] = urlPath;
        }] then:^RACSignal * _Nonnull{
            
            NSDictionary *dict = [mutdict copy];
            return [GTApi requestParams:dict andResmodel:[OrderModel class] andAuthStatus:nil];
        }] subscribeNext:^(OrderModel  *_Nullable x) {
            signature.userInteractionEnabled = YES;
            self.navigationController.view.userInteractionEnabled = YES;
            [hud hideAnimated:true];
//            [GTHUD dismiss];
            [signature removeFromSuperview];
//            [GTUser.manger reloadUserInfoWithSucc:nil fail:nil];
            GTLog(@"%@",[x yy_modelToJSONObject])
            [weakSelf.navigationController pushViewController:[GTSubmittedSuccessfullyController new] animated:YES];
            
        } error:^(NSError * _Nullable error) {
            signature.userInteractionEnabled = YES;
            self.navigationController.view.userInteractionEnabled = YES;
            [hud hideAnimated:true];
//            [GTHUD dismiss];
            GTNetError *err = (GTNetError *)error;
            GTLog(@"%@",error);
            [signature removeFromSuperview];
            [GTHUD showErrorWithTitle:[NSString stringWithFormat:@"%@",err.msg]];
            signature.okBtn.enabled = YES;
        }];
        
        
    }];
    
   
    

    

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

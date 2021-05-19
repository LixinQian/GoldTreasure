//
//  GTUploadAddressBookViewController.m
//  GoldTreasure
//
//  Created by wangyaxu on 05/07/2017.
//  Copyright © 2017 zhaofanjinrong.com. All rights reserved.
//

#import "GTUploadAddressBookViewController.h"
#import "GTUploadAddressBookView.h"
#import "GTAuthenticateService.h"

#import <AddressBook/AddressBook.h>
#import <Masonry/Masonry.h>

@interface GTUploadAddressBookViewController ()

@property (nonatomic, strong) NSMutableArray *addressBookArray;
@property (nonatomic, strong) GTUploadAddressBookView *uploadAddressBookView;

@end

@implementation GTUploadAddressBookViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
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
    //未上传通讯录，先上传通讯录
    GTUploadAddressBookView *uploadAddressBookView = [GTUploadAddressBookView new];
    self.uploadAddressBookView = uploadAddressBookView;
    uploadAddressBookView.backgroundColor = [UIColor whiteColor];
    [self.view addSubview:uploadAddressBookView];
    [uploadAddressBookView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.size.mas_equalTo(CGSizeMake(250, 275));
        make.center.equalTo(self.view);
    }];
    
    WEAKSELF
    uploadAddressBookView.uploadAddressBlock = ^{
        //开始上传
        [weakSelf startService];
    };
    
    uploadAddressBookView.closeBlock = ^{
        [weakSelf dismiss];
    };
}

- (void)startService
{
    //加载通讯录
    [self loadPresion];
}

#pragma mark    -   other methods   -

- (void)loadPresion{
    CFErrorRef *error1 = NULL;
    ABAddressBookRef addressBook = ABAddressBookCreateWithOptions(NULL, error1);
    [self copyAddressBook:addressBook];
    //上传通讯录
    [self uploadAddressBook];
}

- (void)copyAddressBook:(ABAddressBookRef)addressBook{
    //获取联系人个数
    CFIndex numberOfPeoples = ABAddressBookGetPersonCount(addressBook);
    CFArrayRef peoples = ABAddressBookCopyArrayOfAllPeople(addressBook);
    NSLog(@"有%ld个联系人", numberOfPeoples);
    //循环获取联系人
    for (int i = 0; i < numberOfPeoples; i++) {
        ABRecordRef person = CFArrayGetValueAtIndex(peoples, i);
        NSString *firstName = (__bridge NSString *)ABRecordCopyValue(person, kABPersonFirstNameProperty);
        NSString *lastName = (__bridge NSString *)(ABRecordCopyValue(person, kABPersonLastNameProperty));
        NSString *nickName = (__bridge NSString*)ABRecordCopyValue(person, kABPersonNicknameProperty);
        NSString *organiztion = (__bridge NSString*)ABRecordCopyValue(person, kABPersonOrganizationProperty);
        
        NSString *fullName = nil;
        
        if (firstName && lastName) {
            fullName = [lastName stringByAppendingString:firstName];
        }else if(!firstName){
            fullName = lastName;
        }else{
            fullName = firstName;
        }
        if (!fullName) {
            fullName = nickName;
        }
        if (!fullName) {
            fullName = organiztion;
        }
        
        //读取电话多值
        NSMutableArray *phoneArray = [NSMutableArray array];
        ABMultiValueRef phone = ABRecordCopyValue(person, kABPersonPhoneProperty);
        for (int k = 0; k<ABMultiValueGetCount(phone); k++)
        {
            //获取該Label下的电话值
            NSString *tempstr = (__bridge NSString*)ABMultiValueCopyValueAtIndex(phone, k);
            if (tempstr) {
                [phoneArray addObject:tempstr];
            }
            NSDictionary *personDic = nil;
            if (fullName && tempstr) {
                //有名字且存在电话号码的联系人
                personDic = @{
                              @"name" : fullName,
                              @"phoneNo" : tempstr
                              };
                //加入通讯录数组
                [self.addressBookArray addObject:personDic];
            }
        }
    }
}

- (void)uploadAddressBook
{
    [self.uploadAddressBookView setSubmitBtnEnabled:NO];
    NSDictionary *dict = @{
                           @"interId" : GTApiCode.submitAddrbook,
                           @"list" : self.addressBookArray
                           };
    
    [GTHUD showStatusWithTitle:@"通讯录上传中"];
    WEAKSELF
    [GTAuthenticateService.sharedInstance submitAuthInfoWithDict:dict succ:^(id resDict) {
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
            [GTHUD dismiss];
            if (weakSelf) {
                weakSelf.uploadResultBlock(YES);
            }
        });
    } fail:^(GTNetError *error) {
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
            [GTHUD showErrorWithTitle:error.msg];
            if (weakSelf) {
                [weakSelf dismiss];
            }
        });
    }];
}

- (void)dismiss
{
    [self.view removeFromSuperview];
    [self removeFromParentViewController];
}

- (NSMutableArray *)addressBookArray
{
    if (!_addressBookArray) {
        _addressBookArray = [NSMutableArray array];
    }
    return _addressBookArray;
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

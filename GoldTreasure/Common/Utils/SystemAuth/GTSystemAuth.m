//
//  GTSystemAuth.m
//  GoldTreasure
//
//  Created by wangyaxu on 07/07/2017.
//  Copyright © 2017 zhaofanjinrong.com. All rights reserved.
//

#import "GTSystemAuth.h"
#import <AVFoundation/AVFoundation.h>
#import <AssetsLibrary/AssetsLibrary.h>
#import <Photos/Photos.h>
#import <CoreLocation/CoreLocation.h>
#import <AddressBook/AddressBook.h>
#import <Contacts/Contacts.h>

@implementation GTSystemAuth

+ (instancetype)shareInstance{
    static GTSystemAuth *shared = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        shared = [[GTSystemAuth alloc] init];
    });
    return shared;
}


+ (void)showAlertWithAuthType:(GTSystemAuthType)authType completionHandler:(void (^)(GTSystemAuthStatus status))handler{
    switch (authType) {
        case GTSystemAuthTypeCamera:
            [self showAlertForMediaType:AVMediaTypeVideo completionHandler:handler];
            break;
            
        case GTSystemAuthTypePhotos:
            [self showAlertForPHAuth:handler];
            break;
            
        case GTSystemAuthTypeContacts:
            [self showAlertForContactsAuth:handler];
            break;
            
        case GTSystemAuthTypeLocation:
            [self showAlertForLocationAuth:handler];
            break;
            
        case GTSystemAuthTypeNotificaction:
            break;
        default:
            //(@"暂未支持");
            break;
    }
}

#pragma mark - show alert view
+ (void)showAlertWithType:(GTSystemAuthType)authType{
    NSString *title = @"";
    NSString *prefs = @"";
    switch (authType) {
        case GTSystemAuthTypeCamera:
            title = [NSString stringWithFormat:@"请在iPhone的“设置-隐私-相机”选项中，允许【%@】访问您的相机",[[NSBundle mainBundle]objectForInfoDictionaryKey:@"CFBundleDisplayName"]];
            prefs = @"prefs:root=Privacy&&path=CAMERA";
            break;
            
        case GTSystemAuthTypePhotos:
            title = [NSString stringWithFormat:@"请在iPhone的“设置-隐私-照片”选项中，允许【%@】访问您的照片",[[NSBundle mainBundle]objectForInfoDictionaryKey:@"CFBundleDisplayName"]];
            prefs = @"prefs:root=Privacy&&path=PHOTOS";
            break;
            
        case GTSystemAuthTypeContacts:
            title = [NSString stringWithFormat:@"请在iPhone的“设置-隐私-通讯录”选项中，允许【%@】访问您的通讯录",[[NSBundle mainBundle]objectForInfoDictionaryKey:@"CFBundleDisplayName"]];
            prefs = @"prefs:root=Privacy&&path=CONTACTS";
            break;
            
        case GTSystemAuthTypeLocation:
            title = [NSString stringWithFormat:@"请在iPhone的“设置-隐私-定位服务”选项中，允许【%@】访问您的位置",[[NSBundle mainBundle]objectForInfoDictionaryKey:@"CFBundleDisplayName"]];
            prefs = @"prefs:root=LOCATION_SERVICES";
            break;
            
//        case GTSystemAuthTypeNotificaction:
//            mTitle = [NSString stringWithFormat:@"请在iPhone的“设置-通知”选项中，允许【%@】给您发送通知",[[NSBundle mainBundle]objectForInfoDictionaryKey:@"CFBundleDisplayName"]];
//            prefs = @"prefs:root=LOCATION_SERVICES";
//            break;

        default:
            title = @"未支持";
            break;
    }
    
    [self showAlertWithMessage:title toUrl:prefs];
}

+ (void)showAlertWithMessage:(NSString *)message toUrl:(NSString *)url{
    UIAlertController *alertController = [UIAlertController alertControllerWithTitle:nil message:message preferredStyle:UIAlertControllerStyleAlert];
    UIAlertAction *cancelAction = [UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleDefault handler:nil];
    UIAlertAction *authAction = [UIAlertAction actionWithTitle:@"去开启" style:UIAlertActionStyleCancel handler:^(UIAlertAction * _Nonnull action) {
        UIApplication *application = [UIApplication sharedApplication];
        
        if ([application respondsToSelector:@selector(openURL:options:completionHandler:)]) {
            
            NSURL *URL = [NSURL URLWithString:UIApplicationOpenSettingsURLString];
            [application openURL:URL options:@{}
               completionHandler:^(BOOL success) {
                   NSLog(@"Open %@: %d",UIApplicationOpenSettingsURLString,success);
               }];
        } else {
            NSURL *URL = [NSURL URLWithString:url];
            if ([application canOpenURL:URL]) {
                BOOL success = [application openURL:URL];
                NSLog(@"Open %@: %d",url,success);
            }
        }
    }];
    
    [alertController addAction:cancelAction];
    [alertController addAction:authAction];
    [[[UIApplication sharedApplication].delegate window].rootViewController presentViewController:alertController animated:YES completion:nil];
}

#pragma mark - private Method
// 摄像头 相机
+ (void)showAlertForMediaType:(NSString *)mediaType completionHandler:(void (^)(GTSystemAuthStatus status))handler{
    AVAuthorizationStatus authorizationStatus = [AVCaptureDevice authorizationStatusForMediaType:mediaType];
    switch (authorizationStatus) {
        case AVAuthorizationStatusNotDetermined:
          {
            [AVCaptureDevice requestAccessForMediaType:mediaType completionHandler:^(BOOL granted) {
                if (granted) {
                    if (handler) {
                        handler(GTSystemAuthStatusAuthorized);
                    }
                }
                else{
                    if (handler) {
                        handler(GTSystemAuthStatusDenied);
                    }
                }
            }];
            break;
        }
        case AVAuthorizationStatusAuthorized:
            if (handler) {
                handler(GTSystemAuthStatusAuthorized);
            }
            break;
        case AVAuthorizationStatusRestricted:
        case AVAuthorizationStatusDenied:
            if (handler) {
                handler(GTSystemAuthStatusDenied);
            }
            [self showAlertWithType:GTSystemAuthTypeCamera];
            break;
    }
}

// 照片
+ (void)showAlertForPHAuth:(void (^)(GTSystemAuthStatus))handler{
    PHAuthorizationStatus authorizationStatus = [PHPhotoLibrary authorizationStatus];
    switch (authorizationStatus) {
        case PHAuthorizationStatusNotDetermined:
        {
            [PHPhotoLibrary requestAuthorization:^(PHAuthorizationStatus status) {
                switch (status) {
                    case PHAuthorizationStatusAuthorized:
                        if (handler) {
                            handler(GTSystemAuthStatusAuthorized);
                        }
                        break;
                    default:
                        if (handler) {
                            handler(GTSystemAuthStatusDenied);
                        }
                        break;
                }
            }];
            break;
        }
        case PHAuthorizationStatusAuthorized:
            if (handler) {
                handler(GTSystemAuthStatusAuthorized);
            }
            break;
        case PHAuthorizationStatusRestricted:
        case PHAuthorizationStatusDenied:
            if (handler) {
                handler(GTSystemAuthStatusDenied);
            }
            [self showAlertWithType:GTSystemAuthTypePhotos];
            break;
    }

}

// 通讯录
+ (void)showAlertForContactsAuth:(void (^)(GTSystemAuthStatus))handler{
    if ([UIDevice currentDevice].systemVersion.doubleValue > 9.0) {

        CNAuthorizationStatus status = [CNContactStore authorizationStatusForEntityType:CNEntityTypeContacts];
        switch (status) {
            case CNAuthorizationStatusNotDetermined:
            {
                [[CNContactStore new] requestAccessForEntityType:CNEntityTypeContacts completionHandler:^(BOOL granted, NSError * _Nullable error) {
                    if (granted) {
                        if (handler) {
                            handler(GTSystemAuthStatusAuthorized);
                        }
                    }
                    else{
                        if (handler) {
                            handler(GTSystemAuthStatusDenied);
                        }
                    }
                }];
            }
                break;
            case CNAuthorizationStatusAuthorized:
                if (handler) {
                    handler(GTSystemAuthStatusAuthorized);
                }
                break;
            case CNAuthorizationStatusRestricted:
            case CNAuthorizationStatusDenied:
                if (handler) {
                    handler(GTSystemAuthStatusDenied);
                }
                [self showAlertWithType:GTSystemAuthTypeContacts];
                break;
        }
    } else {
        
        ABAuthorizationStatus status = ABAddressBookGetAuthorizationStatus();
        switch (status) {
            case kABAuthorizationStatusNotDetermined:
            {
                ABAddressBookRef addressBook = NULL;
                ABAddressBookRequestAccessWithCompletion(addressBook, ^(bool granted, CFErrorRef error) {
                    if (granted) {
                        if (handler) {
                            handler(GTSystemAuthStatusAuthorized);
                        }
                    }
                    else{
                        if (handler) {
                            handler(GTSystemAuthStatusDenied);
                        }
                    }
                });
            }
                break;
            case kABAuthorizationStatusAuthorized:
                if (handler) {
                    handler(GTSystemAuthStatusAuthorized);
                }
                break;
            case kABAuthorizationStatusRestricted:
            case kABAuthorizationStatusDenied:
                if (handler) {
                    handler(GTSystemAuthStatusDenied);
                }
                [self showAlertWithType:GTSystemAuthTypeContacts];
                break;
                
        }
    }
    
}

// 位置
+ (void)showAlertForLocationAuth:(void (^)(GTSystemAuthStatus))handler{
    CLAuthorizationStatus status = [CLLocationManager authorizationStatus];
    switch (status) {
        case kCLAuthorizationStatusNotDetermined:{
            handler(GTSystemAuthStatusNotDetermined);
        }
            break;
        case kCLAuthorizationStatusAuthorizedAlways:
        case kCLAuthorizationStatusAuthorizedWhenInUse:
            if (handler) {
                handler(GTSystemAuthStatusAuthorized);
            }
            break;
        case kCLAuthorizationStatusRestricted:
        case kCLAuthorizationStatusDenied:
            if (handler) {
                handler(GTSystemAuthStatusDenied);
            }
            [self showAlertWithType:GTSystemAuthTypeLocation];
            break;
    }
}

@end

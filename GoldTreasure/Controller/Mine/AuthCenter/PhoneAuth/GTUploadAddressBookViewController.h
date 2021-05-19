//
//  GTUploadAddressBookViewController.h
//  GoldTreasure
//
//  Created by wangyaxu on 05/07/2017.
//  Copyright © 2017 zhaofanjinrong.com. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef void(^resultBlock)(BOOL isSuccess);

@interface GTUploadAddressBookViewController : UIViewController

@property (nonatomic, copy) resultBlock uploadResultBlock;

- (void)dismiss;

@end

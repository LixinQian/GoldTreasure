//
//  GTAuthInfoModel.h
//  GoldTreasure
//
//  Created by wangyaxu on 07/07/2017.
//  Copyright © 2017 zhaofanjinrong.com. All rights reserved.
//

#import "BaseModel.h"

@interface GTAuthInfoModel : BaseModel

//authStatus(1审核中，2通过，3审核不通过)

//@property (nonatomic, copy) NSString *certificationStatus;

@property (nonatomic, assign) GTAuthStatus certStatus;

@property (nonatomic, assign) GTAuthStatus cardStatus;

@property (nonatomic, assign) GTAuthStatus carrierStatus;

@property (nonatomic, assign) GTAuthStatus zfbStatus;

- (NSUInteger )authSuccessCount;

@end

//
//  GTContactsCell.h
//  GoldTreasure
//
//  Created by 王超 on 2017/7/1.
//  Copyright © 2017年 zhaofanjinrong.com. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface GTContactsCell : UITableViewCell

@property (nonatomic, weak) UITextField *titleTF;

-(void)setValueWithIndex:(NSInteger)index;

- (NSString *)getTextFieldText;


@end

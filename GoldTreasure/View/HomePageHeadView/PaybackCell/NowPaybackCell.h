//
//  NowPaybackCell.h
//  GoldTreasure
//
//  Created by targeter on 2017/7/3.
//  Copyright © 2017年 zhaofanjinrong.com. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface NowPaybackCell : UITableViewCell
/** title */
@property(nonatomic, strong)NSString *title;
/** value */
@property(nonatomic, strong)NSString *value;
/** headerLine */
@property(nonatomic, strong)UIView *headerLine;
/** footerLine */
@property(nonatomic, strong)UIView *footerLine;


/** 设置左右两边的title和数值 */
-(void)setTitle:(NSString *)Title AndValue:(NSString *)Value;
+ (instancetype)cellWithTableView:(UITableView *)tableView;

@end

//
//  GTContactsTitleCell.h
//  GoldTreasure
//
//  Created by 王超 on 2017/7/1.
//  Copyright © 2017年 zhaofanjinrong.com. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface GTContactsTitleCell : UITableViewCell

/** footerLine */
@property(nonatomic, strong)UIView *footerLine;

+ (instancetype)cellWithTableView:(UITableView *)tableView;

-(void)setValueWithIndex:(NSInteger)index;

-(void)setValueWithTitle:(NSString *)Title;

@end

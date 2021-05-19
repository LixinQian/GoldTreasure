//
//  PaybackWayCell.h
//  GoldTreasure
//
//  Created by targeter on 2017/7/3.
//  Copyright © 2017年 zhaofanjinrong.com. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface PaybackWayCell : UITableViewCell


-(void)setValueWithIndex:(NSInteger)index;
/** headerLine */
@property(nonatomic, strong)UIView *headerLine;
/** footerLine */
@property(nonatomic, strong)UIView *footerLine;
/** singleButton */
@property(nonatomic, strong)UIImageView *singleButton;
/** singleButton */
@property(nonatomic, strong)UIImage *singleButtonImage;

+ (instancetype)cellWithTableView:(UITableView *)tableView;

@end

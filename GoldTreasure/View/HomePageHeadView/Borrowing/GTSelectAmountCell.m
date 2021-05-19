//
//  GTSelectAmountCell.m
//  GoldTreasure
//
//  Created by 王超 on 2017/7/3.
//  Copyright © 2017年 zhaofanjinrong.com. All rights reserved.
//

#import "GTSelectAmountCell.h"
#import <Masonry/Masonry.h>
#import "ScrollPickerView.h"

#define kauthedCredit ([[GTUser.manger.userInfoModel authedCredit] integerValue] - [[GTUser.manger.userInfoModel usedCredit] integerValue]) / 10000

@interface GTSelectAmountCell ()<ScrollPickerViewDelegate>

@property (nonatomic, strong) UILabel *titleLbl;
@property (nonatomic, strong) UIView *line;

@property (nonatomic, strong) ScrollPickerView *picker;

@property (nonatomic, strong) UIView *lgView;
@property (nonatomic, strong) UILabel *countLabel;

@property (nonatomic, strong) UILabel *headLabel;
@property (nonatomic, strong) UILabel *footLabel;

@end

@implementation GTSelectAmountCell

+ (instancetype)cellWithTableView:(UITableView *)tableView
{
    // NSLog(@"cellForRowAtIndexPath");
    static NSString *identifier = @"cell";
    // 1.缓存中取
    GTSelectAmountCell *cell = [tableView dequeueReusableCellWithIdentifier:identifier];
    // 2.创建
    if (cell == nil) {
        cell = [[GTSelectAmountCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:identifier];
    }
    return cell;
}

-(instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        
        UILabel *titleLabel = [UILabel new];
        titleLabel.font = [GTFont gtFontF2];
        titleLabel.textColor = [GTColor gtColorC4];
        [self.contentView addSubview:titleLabel];
        titleLabel.text = @"借款金额";
        self.titleLbl = titleLabel;
        
        UIView *line = [UIView new];
        line.backgroundColor = [GTColor gtColorC8];
        [self.contentView addSubview:line];
        self.line = line;
        
        UILabel *countLbl = [UILabel new];
        countLbl.font = [GTFont gtFontF7];
        countLbl.textColor = [GTColor gtColorC4];
        countLbl.textAlignment = NSTextAlignmentCenter;
        [self.contentView addSubview:countLbl];
        self.countLabel = countLbl;
        
        self.picker = [[ScrollPickerView alloc] init];
        self.picker.delegate = self;
        self.picker.horizontalScrolling = YES;
        self.picker.debug = NO;
        //可用额度
        if (kauthedCredit < 10) {
            self.picker.selectedIndex = kauthedCredit;
        }else if (kauthedCredit >= 10 && kauthedCredit < 20)
        {
            self.picker.selectedIndex = 10;
        }else if (kauthedCredit >= 20)
        {
            self.picker.selectedIndex = 15;
        }
        self.picker.layer.borderWidth = 1;
        self.picker.layer.borderColor = [GTColor gtColorC8].CGColor;
        self.picker.layer.cornerRadius = 10;
        self.picker.layer.masksToBounds = YES;
        [self.contentView addSubview:self.picker];
        self.picker.backgroundColor = [GTColor gtColorRulerBG];

        UIView *lineView = [UIView new];
        lineView.backgroundColor = [GTColor gtColorC1];
        lineView.layer.cornerRadius = 5;
        lineView.layer.masksToBounds = YES;
        [self.contentView addSubview:lineView];
        self.lgView = lineView;

        [self setLayout];
    }
    return self;
}

-(void)setLayout
{
    [self.titleLbl mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self).offset(autoScaleW(15));
        make.top.equalTo(self).offset(autoScaleH(10));
        make.size.mas_equalTo(CGSizeMake(autoScaleW(100), autoScaleH(18)));
    }];
    [self.line mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self).offset(autoScaleW(15));
        make.top.equalTo(self.titleLbl.mas_bottom).offset(autoScaleH(12));
        make.right.mas_equalTo(self).offset(autoScaleW(-15));
        make.height.mas_equalTo(autoScaleH(0.5));
    }];
    
    [self.countLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(self);
        make.top.equalTo(self.line.mas_bottom).offset(autoScaleH(20));
        make.size.mas_equalTo(CGSizeMake(autoScaleW(100), autoScaleH(26)));
    }];
    
    [self.picker mas_makeConstraints:^(MASConstraintMaker *make) {
//        make.centerX.equalTo(self);
        make.top.equalTo(self.countLabel.mas_bottom).offset(autoScaleH(22));
        make.left.equalTo(self).offset(autoScaleW(15));
        make.right.equalTo(self).offset(autoScaleW(-15));
        make.height.mas_equalTo(41);

    }];
    
    self.headLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, ScreenWidth/2, 300)];
//    self.headLabel.text = @"qwqwqqqqqqq";
//    self.headLabel.backgroundColor = [UIColor yellowColor];
    self.picker.headerView = self.headLabel;

    self.footLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, ScreenWidth/2, 300)];
//    self.footLabel.text = @"wwwwwwww";
//    self.footLabel.backgroundColor = [UIColor blueColor];
    
    self.picker.footerView = self.footLabel;
    
    
    [self.lgView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(self);
        make.top.equalTo(self.picker).offset(-5);
        make.size.mas_equalTo(CGSizeMake(10, 51));
    }];
    
    
}

- (NSInteger)numberOfRows{
    
    return kauthedCredit + 1;
}

- (UIView *)viewForRowAtIndex:(NSUInteger)index{
    BOOL isMultipleOfTen = !(index % 2);
    int height;
    NSString *count;
    
    if (isMultipleOfTen) {
        height = 20;
        count = [NSString stringWithFormat:@"%d", (int)index*100];
    }
    else
    {
        height = 10;
    }
    UIView *bgView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, 41, 41)];
//    bgView.backgroundColor = [UIColor orangeColor];
    
    UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, 30, 20)];
    label.text = count;
    label.textAlignment = NSTextAlignmentCenter;
    label.font = [UIFont systemFontOfSize:8];
    label.textColor = [GTColor gtColorC7];
//    label.backgroundColor = [UIColor greenColor];
    [bgView addSubview:label];
    
    UIView *line= [[UIView alloc]initWithFrame:CGRectMake(bgView.center.x-5.5, bgView.frame.size.height-height, 1, height)];
//    line.center = bgView.center;
    line.backgroundColor = [GTColor gtColorC8];
    [bgView addSubview:line];
    return bgView;
}

- (CGFloat)heightForCellAtIndex:(NSUInteger)index{
    return 30;
}

- (void)maySelectIndex:(NSUInteger)index{
    self.countLabel.text = [NSString stringWithFormat:@"%ld",index*100];
    OrderModel *model = [[OrderModel alloc]init];
    model.borrowAmount = [NSNumber numberWithInteger:index*100];
    model.period = [NSNumber numberWithInteger:7];
    self.selectBlock(model);
}
- (void)didSelectIndex:(NSUInteger)index{
    self.countLabel.text = [NSString stringWithFormat:@"%ld",index*100];
    OrderModel *model = [[OrderModel alloc]init];
    model.borrowAmount = [NSNumber numberWithInteger:index*100];
    model.period = [NSNumber numberWithInteger:7];
    self.selectBlock(model);
}



- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end

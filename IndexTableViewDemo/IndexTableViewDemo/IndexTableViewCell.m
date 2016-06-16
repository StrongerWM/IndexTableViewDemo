//
//  IndexTableViewCell.m
//  IndexTableViewDemo
//
//  Created by Stronger_WM on 16/6/16.
//  Copyright © 2016年 Stronger_WM. All rights reserved.
//

#import "IndexTableViewCell.h"

@interface IndexTableViewCell ()
@property (nonatomic ,strong) UILabel *indexLabel;
@property (nonatomic ,strong) UIImageView *accessoryImgView;
@end

@implementation IndexTableViewCell

- (void)updateCellModel:(DemoModel *)model
{
    if (model.is_selected) {
        _indexLabel.backgroundColor = [UIColor lightGrayColor];
        _accessoryImgView.hidden = NO;
    }
    else
    {
        _indexLabel.backgroundColor = [UIColor blackColor];
        _accessoryImgView.hidden = YES;
    }
    _indexLabel.text = model.province;
}

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        [self configSubviews];
    }
    return self;
}

- (void)configSubviews
{
    //省份
    _indexLabel = [[UILabel alloc] initWithFrame:CGRectMake(10, 10, 40, 40)];
    _indexLabel.textColor = [UIColor whiteColor];
    _indexLabel.textAlignment = NSTextAlignmentCenter;
    _indexLabel.layer.cornerRadius = 20;
    _indexLabel.clipsToBounds = YES;
    [self.contentView addSubview:_indexLabel];
    
    //指示器accessory
    NSString *path = [[NSBundle mainBundle] pathForResource:@"arrow.png" ofType:nil];
    UIImage *img = [UIImage imageWithContentsOfFile:path];
    _accessoryImgView = [[UIImageView alloc] initWithFrame:CGRectMake(60-6, (60-13)/2.0, 6, 13)];
    _accessoryImgView.image = img;
    [self.contentView addSubview:_accessoryImgView];
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

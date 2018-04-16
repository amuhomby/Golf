//
//  HomeViewCell.m
//  Dress_d
//
//  Created by MacAdmin on 9/12/17.
//  Copyright © 2017 dev. All rights reserved.
//

#import "HomeViewCell.h"

@implementation HomeViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
    _imgPhoto.layer.cornerRadius = _imgPhoto.layer.bounds.size.height/2;
    _imgPhoto.layer.masksToBounds = YES;
    
    CGRect imgFrame = _viewImage.frame;
    CGFloat height = ([UIScreen mainScreen].bounds.size.width *3)/4;
    imgFrame.size.height = height;
    _viewImage.frame = imgFrame;
    
    CGRect likeFrame = _viewlike.frame;
    CGFloat oriY = 60 + _viewImage.frame.size.height;
    likeFrame.origin.y = oriY;
    _viewlike.frame = likeFrame;
    
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end

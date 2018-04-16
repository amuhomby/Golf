//
//  dressAFTableViewCell.m
//  Strangrs
//
//  Created by MacAdmin on 9/7/17.
//  Copyright © 2017 AppDupe. All rights reserved.
//

#import "dressAFTableViewCell.h"

@implementation dressAFTableViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
//    _imgProfile.layer.cornerRadius = 5;
//    _imgProfile.layer.masksToBounds = YES;
    _btnHead.layer.cornerRadius = 5;
    _btnHead.layer.masksToBounds = YES;
    
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end

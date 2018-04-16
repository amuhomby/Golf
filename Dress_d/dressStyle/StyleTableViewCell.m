//
//  StyleTableViewCell.m
//  Strangrs
//
//  Created by MacAdmin on 9/6/17.
//  Copyright © 2017 AppDupe. All rights reserved.
//

#import "StyleTableViewCell.h"

@implementation StyleTableViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
    self.btnStyle.layer.cornerRadius = self.btnStyle.frame.size.height/2;
    self.btnStyle.layer.masksToBounds = YES;
    self.btnStyle.layer.borderWidth = 1.0f;
    self.btnStyle.layer.borderColor = [[UIColor colorWithRed:(149.0/255) green:(181.0/255) blue:(202.0/255) alpha:1.0f] CGColor];

}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
//    if(selected){
//        [_btnStyle setBackgroundColor:mainGreenColor];
//    }else{
//        [_btnStyle setBackgroundColor:UIColor.whiteColor];
//    }
//    
}

@end

//
//  CartCell.h
//  Golf
//
//  Created by MacAdmin on 4/1/18.
//  Copyright © 2018 MacAdmin. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface CartCell : UITableViewCell
@property (nonatomic, retain) IBOutlet UIImageView * imgPhoto;
@property (nonatomic, retain) IBOutlet UILabel * lbName;
@property (nonatomic, retain) IBOutlet UILabel * lbColor;
@property (nonatomic, retain) IBOutlet UILabel * lbPrice;
@property (nonatomic, retain) IBOutlet UILabel * lbAmount;
@property (nonatomic, retain) IBOutlet UILabel * lbSize;
@property (nonatomic, retain) IBOutlet UIButton * btnMinus;
@property (nonatomic, retain) IBOutlet UIButton * btnPlus;

@end

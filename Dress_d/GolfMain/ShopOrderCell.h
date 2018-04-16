//
//  ShopOrderCell.h
//  Golf
//
//  Created by MacAdmin on 3/31/18.
//  Copyright © 2018 MacAdmin. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ShopOrderCell : UITableViewCell
@property (nonatomic, weak) IBOutlet UIImageView * imgPhoto;
@property (nonatomic, weak) IBOutlet UILabel * lbGoodName;
@property (nonatomic, weak) IBOutlet UILabel * lbPrice;
@property (nonatomic, weak) IBOutlet UILabel * lbDate;
@property (nonatomic, weak) IBOutlet UILabel * lbSize;
@property (nonatomic, weak) IBOutlet UILabel * lbTotal;
@property (nonatomic, weak) IBOutlet UILabel * lbTotalPrice;
@property (nonatomic, weak) IBOutlet UIButton * btnPay;

@end

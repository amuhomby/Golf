//
//  RankCell.h
//  Golf
//
//  Created by MacAdmin on 3/31/18.
//  Copyright © 2018 MacAdmin. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface RankCell : UITableViewCell
@property (nonatomic,weak) IBOutlet UIImageView * imgPhoto;
@property (nonatomic,weak) IBOutlet UILabel * lbNo;
@property (nonatomic,weak) IBOutlet UILabel * lbName;
@property (nonatomic,weak) IBOutlet UILabel * lbNum;
@property (nonatomic,weak) IBOutlet UILabel * lbTotal;
@property (nonatomic,weak) IBOutlet UILabel * lbFan;
@property (nonatomic,weak) IBOutlet UILabel * lbException;
@property (nonatomic,weak) IBOutlet UIButton * btnView;




@end

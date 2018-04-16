//
//  ShoesCell.h
//  Golf
//
//  Created by MacAdmin on 4/1/18.
//  Copyright © 2018 MacAdmin. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ShoesCell : UICollectionViewCell
@property (nonatomic, retain) IBOutlet UIImageView * imgPhoto;
@property (nonatomic, retain) IBOutlet UILabel * lbName;
@property (nonatomic, retain) IBOutlet UILabel * lbDes;
@property (nonatomic, retain) IBOutlet UILabel * lbPrice;

@end

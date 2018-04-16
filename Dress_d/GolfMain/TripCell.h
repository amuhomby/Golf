//
//  TripCell.h
//  Golf
//
//  Created by MacAdmin on 3/29/18.
//  Copyright © 2018 MacAdmin. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface TripCell : UITableViewCell
@property (nonatomic, retain) IBOutlet UIImageView * imgPhoto;
@property (nonatomic, retain) IBOutlet UILabel * lbDate;
@property (nonatomic, retain) IBOutlet UILabel * lbContent;
@property (nonatomic, retain) IBOutlet UILabel * lbSmallCon;
@property (nonatomic, retain) IBOutlet UILabel * lbPrice;
@property (nonatomic, retain) IBOutlet UILabel * lbszPerson;


@end

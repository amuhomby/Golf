//
//  TripViewController.h
//  Golf
//
//  Created by MacAdmin on 3/29/18.
//  Copyright © 2018 MacAdmin. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "HMSegmentedControl.h"

@interface TripViewController : ProgressViewController
@property (nonatomic, retain) IBOutlet UIView * vwTop;
@property (nonatomic, retain) IBOutlet UIView * vwBack;
@property (nonatomic, retain) IBOutlet UIView * vwImage;
@property (nonatomic, retain) IBOutlet UILabel * lbTripName;
@property (nonatomic, retain) IBOutlet UILabel * lbTripNumber;
@property (nonatomic, retain) IBOutlet UISearchBar * srhTrip;

@property (nonatomic, retain) IBOutlet UIImageView * imgTop;
@property (nonatomic, retain) IBOutlet UIView * vwSort;
@property (nonatomic, retain) IBOutlet UIButton * btnCountry;
@property (nonatomic, retain) IBOutlet UIButton * btnRecommend;
@property (nonatomic, retain) IBOutlet UIButton * btnDate;
@property (nonatomic, retain) IBOutlet UITableView * tbView;


@end

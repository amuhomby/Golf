//
//  ProfileController.h
//  Golf
//
//  Created by MacAdmin on 3/30/18.
//  Copyright © 2018 MacAdmin. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ProfileController : ProgressViewController

@property (nonatomic, retain) IBOutlet UIView * vwTop;
@property (nonatomic, retain) IBOutlet UIView * vwBack;
@property (nonatomic, retain) IBOutlet UIScrollView * scrollview;
@property (nonatomic, retain) IBOutlet UIView * vwProfile;
@property (nonatomic, retain) IBOutlet UIImageView * imgProfile;
@property (nonatomic, retain) IBOutlet UIImageView * imgEdit;
@property (nonatomic, retain) IBOutlet UIButton * btnEdit;
@property (nonatomic, retain) IBOutlet UILabel * lbName;

@property (nonatomic, retain) IBOutlet UIView * vwRating;
@property (nonatomic, retain) IBOutlet UILabel * lbFollow;
@property (nonatomic, retain) IBOutlet UILabel * lbFans;

@property (nonatomic, retain) IBOutlet UILabel * lbAnchor;
@property (nonatomic, retain) IBOutlet UILabel * lbAnchorRed;
@property (nonatomic, retain) IBOutlet UIButton * btnAnchor;

@property (nonatomic, retain) IBOutlet UILabel * lbCollection;
@property (nonatomic, retain) IBOutlet UILabel * lbCollectionRed;
@property (nonatomic, retain) IBOutlet UIButton * btnCollection;

@property (nonatomic, retain) IBOutlet UILabel * lbOrder;
@property (nonatomic, retain) IBOutlet UILabel * lbOrderRed;
@property (nonatomic, retain) IBOutlet UIButton * btnOrder;

@property (nonatomic, retain) IBOutlet UILabel * lbLesson;
@property (nonatomic, retain) IBOutlet UILabel * lbLessonRed;
@property (nonatomic, retain) IBOutlet UIButton * btnLesson;

@property (nonatomic, retain) IBOutlet UILabel * lbPay;
@property (nonatomic, retain) IBOutlet UILabel * lbPayRed;
@property (nonatomic, retain) IBOutlet UIButton * btnPay;

@property (nonatomic, retain) IBOutlet UIView * vwLast;

@end

//
//  PostStyleViewController.h
//  Dress_d
//
//  Created by MacAdmin on 9/14/17.
//  Copyright © 2017 dev. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface PostStyleViewController : UIViewController
{
    NSMutableArray * arrImage;
    IBOutlet UIButton * btnBack;
    IBOutlet UIButton * btnSrh;
    IBOutlet UIButton * btnStyle;
    IBOutlet UIScrollView * scrView;
    IBOutlet UIView * vwStyle;
    IBOutlet UIView * vwImage;
}

@property (nonatomic, retain) NSString * strStyle;
@property (nonatomic, retain) NSString * profile_id;
@end

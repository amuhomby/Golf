//
//  dressWelcomeController.h
//  Dress_d
//
//  Created by MacAdmin on 9/8/17.
//  Copyright © 2017 dev. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ProgressViewController.h"

@interface dressWelcomeController : ProgressViewController
{
    IBOutlet UIView * viewMy;
    IBOutlet UIImageView * imgProfile;
    IBOutlet UILabel * lbName;
    
    IBOutlet UIView * viewStyle;
    IBOutlet UIButton * btnStyle;
}
@end

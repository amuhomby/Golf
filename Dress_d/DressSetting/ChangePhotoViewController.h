//
//  ChangePhotoViewController.h
//  Dress_d
//
//  Created by MacAdmin on 11/28/17.
//  Copyright © 2017 MacAdmin. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ChangePhotoViewController : ProgressViewController
{
    IBOutlet UIView * vwBack;
    IBOutlet UIImageView * igPhoto;
    IBOutlet UIButton * btnTakePhoto;
    IBOutlet UIButton * btnChangePhoto;
    IBOutlet UIView * vwCover;
}

@end

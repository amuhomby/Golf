//
//  ProductController.h
//  Golf
//
//  Created by MacAdmin on 4/1/18.
//  Copyright © 2018 MacAdmin. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ProductController : ProgressViewController
{
    IBOutlet UIView * vwTop;
    IBOutlet UIButton * btnBack;
    
    IBOutlet UIView * vwBack;
    IBOutlet UIView * vwBtn;
    IBOutlet UIButton * btnAll;
    IBOutlet UIButton * btnRunning;
    IBOutlet UIButton * btnNormal;
    IBOutlet UILabel * lbLineAll;
    IBOutlet UILabel  * lbLineRunning;
    IBOutlet UILabel * lbLineNormal;
    IBOutlet UICollectionView * collView;
}

@end

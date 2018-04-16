//
//  ProductViewController.h
//  Dress_d
//
//  Created by MacAdmin on 12/14/17.
//  Copyright © 2017 MacAdmin. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ProductViewController : ProgressViewController
{
    NSMutableDictionary * userData;
    NSMutableArray * _dicPostDetail;
    NSMutableArray * _arrShop1;
    NSMutableArray * _arrShop2;
    NSMutableArray * _arrShop3;
    NSMutableArray * _arrShop0;
    
    
    IBOutlet UIView * viewTop;
    
    IBOutlet UIScrollView * scrView;
    
    IBOutlet UIView * viewMain;
    IBOutlet UIImageView * imgProfile;
    IBOutlet UIButton * btnName;
    IBOutlet UIView * viewImage;
    IBOutlet UIScrollView * scrImage;
    IBOutlet UIImageView * moreIcon;
    
    IBOutlet UIView * vwButton;
    IBOutlet UIButton * btnMan;
    IBOutlet UIButton * btnWomen;
    IBOutlet UIView * vwProduct;
    
    IBOutlet UIButton * btn1;
    IBOutlet UIButton * btn2;
    IBOutlet UIButton * btn3;
}
    
@property (nonatomic, retain) NSString * post_id;
@end

//
//  GoldHomeViewController.h
//  Dress_d
//
//  Created by MacAdmin on 9/11/17.
//  Copyright © 2017 dev. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ProgressViewController.h"
#import "HMSegmentedControl.h"
#import <TYCyclePagerView/TYCyclePagerView.h>
#import "TYPageControl.h"
#import "GolfHomeCollectionViewCell.h"

@interface GoldHomeViewController : ProgressViewController
{
    IBOutlet UIView * vwTop;
    IBOutlet UISearchBar* srhBar;
    IBOutlet UIButton * btnSelection;
    IBOutlet UIButton * btnBadge;
    IBOutlet UILabel * lbBadge;
    IBOutlet UIView * vwBtnCategory;
    IBOutlet UIImageView * igCategory;
    IBOutlet UIButton * btnCategory;
    
    IBOutlet UIView * vwBack;
    IBOutlet UIScrollView * scrollview;
    IBOutlet UIView * vwWidget;
    IBOutlet UIImageView * imgOne;
    IBOutlet UIImageView * imgTwo;
    IBOutlet UIImageView * imgThr;
    IBOutlet UILabel * lbOne;
    IBOutlet UILabel * lbTwo;
    IBOutlet UILabel * lbThr;
    IBOutlet UIButton * btnWidget;
    
    IBOutlet UIView * vwSee;
    IBOutlet UILabel * lbSee;
    IBOutlet UIButton * btnSee;
    
    IBOutlet UICollectionView * collView;
    
    IBOutlet UIView * vwCategory;
    IBOutlet UIButton * btnHideCategory;
    IBOutlet UIButton * btnCate1;
    IBOutlet UIButton * btnCate2;
    IBOutlet UIButton * btnCate3;
    IBOutlet UIButton * btnCate4;
    IBOutlet UIButton * btnCate5;
    IBOutlet UIButton * btnCate6;

}

+(GoldHomeViewController *)sharedInstance;
@end

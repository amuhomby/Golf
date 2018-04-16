//
//  GolfShopController.h
//  Golf
//
//  Created by MacAdmin on 3/29/18.
//  Copyright © 2018 MacAdmin. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <TYCyclePagerView/TYCyclePagerView.h>
#import "TYPageControl.h"

@interface GolfShopController : ProgressViewController
{
    IBOutlet UIView * vwTop;
    IBOutlet UIView * vwBack;
    IBOutlet UIScrollView * scrollview;
    IBOutlet UICollectionView * collView;

}
@end

//
//  GolfMainViewController.h
//  Golf
//
//  Created by MacAdmin on 9/11/17.
//  Copyright © 2017 dev. All rights reserved.
//

#import <UIKit/UIKit.h>
@protocol GolfMainDelegate <UITabBarControllerDelegate>;
@optional -(void)tabBar:(UITabBar *_Nullable)tabBar didSelectItem:(UITabBarItem *_Nullable)item;
@end
@interface GolfMainViewController : UITabBarController
{
    IBOutlet UITabBar * tabbar;
}
+(GolfMainViewController *_Nullable)sharedInstance;
-(void)changTab:(NSInteger)index;
-(void)hideTab:(BOOL)flag;


@property(nullable, nonatomic,weak) id<GolfMainDelegate> delegate;

@end

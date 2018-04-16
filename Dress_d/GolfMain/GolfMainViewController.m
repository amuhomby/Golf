//
//  GolfMainViewController.m
//  Dress_d
//
//  Created by MacAdmin on 9/11/17.
//  Copyright © 2017 dev. All rights reserved.
//

#import "GolfMainViewController.h"
#import "AddViewController.h"
#import "DressProfileViewController.h"
#import "NotificationViewController.h"

@interface GolfMainViewController ()<GolfMainDelegate>

@end

@implementation GolfMainViewController
static GolfMainViewController * mainInstance;
@dynamic delegate;

+(GolfMainViewController *)sharedInstance{
    return mainInstance;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    mainInstance = self;
    self.selectedIndex = 0;
    self.delegate = self;
//    [UITabBar appearance].unselectedItemTintColor = mainTransColor;
//    [UITabBar appearance].tintColor = mainGoldColor;
//    [UITabBar appearance].backgroundColor = UIColor.blackColor;
    
    [tabbar setBarTintColor: mainDarkColor];
    UITabBarItem *tabBarItem1 = [tabbar.items objectAtIndex:0];
    UITabBarItem *tabBarItem2 = [tabbar.items objectAtIndex:1];
    UITabBarItem *tabBarItem3 = [tabbar.items objectAtIndex:2];
    UITabBarItem *tabBarItem4 = [tabbar.items objectAtIndex:3];
    UITabBarItem *tabBarItem5 = [tabbar.items objectAtIndex:4];
    
    tabBarItem1.title = @"Home";
    tabBarItem2.title = @"Shop";
    tabBarItem4.title = @"Customize";
    tabBarItem5.title = @"User";
    
    [tabBarItem1 setImage:[[UIImage imageNamed:@"golf_home_un.png"] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal]];
    [tabBarItem1 setSelectedImage:[[UIImage imageNamed:@"golf_home.png"] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal]];

    [tabBarItem2 setImage:[[UIImage imageNamed:@"golf_shop_un.png"] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal]];
    [tabBarItem2 setSelectedImage:[[UIImage imageNamed:@"golf_shop.png"] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal]];

    [tabBarItem3 setImage:[[UIImage imageNamed:@"golf_circle.png"] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal]];
    [tabBarItem3 setSelectedImage:[[UIImage imageNamed:@"golf_circle.png"] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal]];
    
    [tabBarItem4 setImage:[[UIImage imageNamed:@"golf_custom_un.png"] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal]];
    [tabBarItem4 setSelectedImage:[[UIImage imageNamed:@"golf_custom.png"] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal]];

    [tabBarItem5 setImage:[[UIImage imageNamed:@"golf_user_un.png"] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal]];
    [tabBarItem5 setSelectedImage:[[UIImage imageNamed:@"golf_user.png"] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal]];

    
    CGFloat controlSize = 2;
    CGRect tabFrame = self.tabBar.frame;
    tabFrame.size.height -= controlSize;
    tabFrame.origin.y += controlSize;
    tabbar.frame = tabFrame;
}

-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:YES];
}

-(void)viewWillLayoutSubviews{
    [super viewWillLayoutSubviews];
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
- (void)tabBarController:(UITabBarController *)tabBarController didSelectViewController:(UIViewController *)viewController{
    NSInteger index = tabBarController.selectedIndex;
    
   
    NSString * tabIndex = [NSString stringWithFormat:@"%ld", (long)index];
    NSString * oldTabIndex = [Global sharedGlobal].tabIndex;
    if(![tabIndex isEqualToString: @"2"]){
        [Global sharedGlobal].tabIndex = tabIndex;
        [[Global sharedGlobal] SaveParam];
    }else{
        [Global sharedGlobal].tabIndex = tabIndex;
        [[Global sharedGlobal] SaveParam];
        AddViewController *VC = [AddViewController sharedInstance];
        VC.szCount = 0;
    }
    

    
    if([tabIndex isEqualToString:@"1"]){
        if([oldTabIndex isEqualToString:@"1"]){
            [[DressProfileViewController sharedInstance] ToTop:YES];
        }else {
            [Global sharedGlobal].whoProfile = [Global sharedGlobal].fbid;
            [[Global sharedGlobal] SaveParam];
            [[DressProfileViewController sharedInstance] getData];
        }
    }
    
    if([tabIndex isEqualToString:@"3"]){
        [[NotificationViewController sharedNotifi] ToTop:NO];
    }
    
    
    [[tabBarController.viewControllers objectAtIndex:index] popToRootViewControllerAnimated:NO];
 
}
- (BOOL)tabBarController:(UITabBarController *)tabBarController shouldSelectViewController:(UIViewController *)viewController{
    
    AddViewController *VC = [AddViewController sharedInstance];
    VC.szCount = 0;
    
    [Global sharedGlobal].bakeToAdd = @"no";
    [[Global sharedGlobal] SaveParam];
    

    return YES;
}

- (void)tabBar:(UITabBar *)tabBar didSelectItem:(UITabBarItem *)item{
//    NSInteger index = self.selectedIndex;
//    
//    NSString * tabIndex = [NSString stringWithFormat:@"%ld", (long)index];
//    NSString * oldTabIndex = [Global sharedGlobal].tabIndex;
//    if(![tabIndex isEqualToString: @"2"]){
//        [Global sharedGlobal].tabIndex = tabIndex;
//        [[Global sharedGlobal] SaveParam];
//    }else{
//        [Global sharedGlobal].tabIndex = tabIndex;
//        [[Global sharedGlobal] SaveParam];
//        AddViewController *VC = [AddViewController sharedInstance];
//        VC.szCount = 0;
//    }
//    
//    if([tabIndex isEqualToString:@"0"]){
//        [[DressHomeViewController sharedInstance] ToTop:NO];
//    }
//    
//
//     if([tabIndex isEqualToString:@"1"]){
//         if([oldTabIndex isEqualToString:@"1"] || [oldTabIndex isEqualToString:@"2"]){
//             [[DressProfileViewController sharedInstance] ToTop:YES];
//         }else {
//             //[Global sharedGlobal].whoProfile = [Global sharedGlobal].fbid;
//             //[[Global sharedGlobal] SaveParam];
//             //[[DressProfileViewController sharedInstance] getData];
//         }
//     }
//
//    if([tabIndex isEqualToString:@"3"]){
//        [[NotificationViewController sharedNotifi] ToTop:NO];
//    }
}


-(void)changTab:(NSInteger)index{
    self.selectedIndex = index;
    NSInteger tabitem = self.selectedIndex;
    if(index == 2){
        AddViewController *VC = [AddViewController sharedInstance];
        VC.szCount = 0;
        
        [Global sharedGlobal].bakeToAdd = @"no";
        [[Global sharedGlobal] SaveParam];
    }
    [[mainInstance.viewControllers objectAtIndex:tabitem] popToRootViewControllerAnimated:NO];
}
-(void)hideTab:(BOOL)flag{
    mainInstance.tabBar.hidden = flag;
}

@end

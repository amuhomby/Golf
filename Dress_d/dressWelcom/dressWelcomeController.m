//
//  dressWelcomeController.m
//  Dress_d
//
//  Created by MacAdmin on 9/8/17.
//  Copyright © 2017 dev. All rights reserved.
//

#import "dressWelcomeController.h"
#import "UIImageView+WebCache.h"
#import "dressStyleController.h"

@interface dressWelcomeController ()

@end

@implementation dressWelcomeController
- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
}

-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];

}
-(void)viewDidLayoutSubviews{
    viewMy.layer.cornerRadius = 20;
    viewMy.layer.masksToBounds = YES;
    [viewMy.layer setShadowOffset:CGSizeMake(3, 3)];
    [viewMy.layer setShadowColor:[[UIColor blackColor] CGColor]];
    //    [viewMy.layer setShadowOpacity:0.8f];
    
    
    CGRect imgframe = imgProfile.frame;
    imgframe.size.height = imgframe.size.width;
//    imgframe.origin.y = (viewMy.frame.size.height - imgProfile.frame.size.height) / 2;
    imgframe.origin.y = (lbName.frame.origin.y - imgProfile.frame.size.height) / 2 + 40;
    imgProfile.frame = imgframe;
    imgProfile.layer.cornerRadius = imgframe.size.height/2;
    imgProfile.layer.masksToBounds = YES;
    
    
    viewStyle.layer.cornerRadius =20;
    viewStyle.layer.masksToBounds = YES;
//    [viewStyle.layer setShadowOffset:CGSizeMake(3, 3)];
//    [viewStyle.layer setShadowColor:[[UIColor blackColor] CGColor]];
    //    [viewStyle.layer setShadowOpacity:0.8f];
    
    CGRect btnframe = btnStyle.layer.bounds;
    btnStyle.layer.cornerRadius = btnframe.size.height/2;
    btnStyle.layer.masksToBounds = YES;
    [btnStyle.layer setShadowOffset:CGSizeMake(8, 8)];
    [btnStyle.layer setShadowColor:[[UIColor blackColor] CGColor]];
    //    [btnStyle.layer setShadowOpacity:0.8f];
    

    NSString *  userProfilePhoto= [Global sharedGlobal].avatar;

    [imgProfile setImageWithURL:[NSURL URLWithString:userProfilePhoto] placeholderImage:[UIImage imageNamed:@"place_man.png"]];
    
    NSString * firstName = [[Global sharedGlobal]fbfname];
    //NSString * lastName = [[Global sharedGlobal]fblname];
    
    NSString * name =[NSString stringWithFormat:@"Welcome %@", firstName];
    lbName.text = name;
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(IBAction)onClickStyle:(id)sender{
    
    dressStyleController * vc = [[dressStyleController alloc] initWithNibName:@"dressStyleController" bundle:nil];
    [self.navigationController pushViewController:vc animated:YES];
//    [self presentViewController:vc animated:NO completion:nil];
}
@end

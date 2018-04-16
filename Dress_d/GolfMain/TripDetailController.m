//
//  TripDetailController.m
//  Golf
//
//  Created by MacAdmin on 4/1/18.
//  Copyright © 2018 MacAdmin. All rights reserved.
//

#import "TripDetailController.h"
#import "GolfMainViewController.h"
#import "TripOrderController.h"


@interface TripDetailController ()

@end

@implementation TripDetailController
{
    BOOL bShuttle;
    BOOL bMeal;
}
- (void)viewDidLoad {
    [super viewDidLoad];
    [self initData];
    // Do any additional setup after loading the view from its nib.
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    [[GolfMainViewController sharedInstance] hideTab:YES];
}
-(void)viewDidLayoutSubviews{
    [super viewDidLayoutSubviews];
    [self layoutControl];
    [self ChangeShuttle];
    [self ChangeMeal];
}
-(void)initData{
    bShuttle = NO;
    bMeal = NO;
}

-(void)layImgPhoto{
    CGRect frame = imgPhoto.frame;
    frame.origin.x = 0;
    frame.origin.y = 0;
    frame.size.height = frame.size.width * 0.6;
    imgPhoto.frame = frame;
}

-(void)layMiddle{
    CGRect frame = vwMiddle.frame;
    frame.origin.y = imgPhoto.frame.origin.y + imgPhoto.frame.size.height + 1;
    vwMiddle.frame = frame;
}

-(void)layDes{
    [lbDes sizeToFit];
    CGRect frame = vwDes.frame;
    frame.origin.y = vwMiddle.frame.origin.y + vwMiddle.frame.size.height + 1;
    frame.size.height = lbDes.frame.size.height + 16;
    vwDes.frame = frame;
}

-(void)layBottom{
    CGRect frame = vwBottom.frame;
    frame.origin.y = vwDes.frame.origin.y + vwDes.frame.size.height + 1;
    vwBottom.frame = frame;
}

-(void)layScr{
    CGFloat bottom = vwBottom.frame.origin.y + vwBottom.frame.size.height + 10;
    CGSize scrollContentSize = CGSizeMake(scrollview.frame.size.width, MAX(scrollview.frame.size.height, bottom));
    scrollview.contentSize = scrollContentSize;
}

-(void)layoutControl{
    [self layImgPhoto];
    [self layMiddle];
    [self layDes];
    [self layBottom];
    [self layScr];
}

-(IBAction)ClickShuttle:(UIButton *)sender{
    NSInteger tag = sender.tag;
    if(tag == 1){
        bShuttle = YES;
    }else{
        bShuttle = NO;
    }
    [self ChangeShuttle];
}

-(void)ChangeShuttle{
    if(bShuttle){
        imgShuttleYes.image =[UIImage imageNamed:@"golf_yes.png"];
        imgShuttleNo.image =[UIImage imageNamed:@"golf_no.png"];
    }else{
        imgShuttleYes.image =[UIImage imageNamed:@"golf_no.png"];
        imgShuttleNo.image =[UIImage imageNamed:@"golf_yes.png"];
    }
}
-(IBAction)ClickMeal:(UIButton *)sender{
    NSInteger tag = sender.tag;
    if(tag == 1){
        bMeal = YES;
    }else{
        bMeal = NO;
    }
    [self ChangeMeal];
}

-(void)ChangeMeal{
    if(bMeal){
        imgMealYes.image = [UIImage imageNamed:@"golf_yes.png"];
        imgMealNo.image = [UIImage imageNamed:@"golf_no.png"];
    }else{
        imgMealYes.image = [UIImage imageNamed:@"golf_no.png"];
        imgMealNo.image = [UIImage imageNamed:@"golf_yes.png"];
    }
}

-(IBAction)ClickBack:(id)sender{
    [[GolfMainViewController sharedInstance] hideTab:NO];
    [self.navigationController popViewControllerAnimated:YES];
}

-(IBAction)ClickOnline:(id)sender{
    
}

-(IBAction)ClickBuy:(id)sender{
    TripOrderController * vc =[[TripOrderController alloc]initWithNibName:@"TripOrderController" bundle:nil];
    [self.navigationController pushViewController:vc animated:YES];
}


@end

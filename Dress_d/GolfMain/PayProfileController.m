//
//  PayProfileController.m
//  Golf
//
//  Created by MacAdmin on 3/31/18.
//  Copyright © 2018 MacAdmin. All rights reserved.
//

#import "PayProfileController.h"
#import "RechargeController.h"
#import "PayDetailController.h"
#import "GolfMainViewController.h"

@interface PayProfileController ()

@end

@implementation PayProfileController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    [[GolfMainViewController sharedInstance] hideTab:YES];
    [self getData];
}
-(void)getData{
    lbPrice.text = @"Y 345.645";
}

-(IBAction)ClickCharge:(id)sender{
    RechargeController * vc = [[RechargeController alloc] initWithNibName:@"RechargeController" bundle:nil];
    [self.navigationController pushViewController:vc animated:YES];
}

-(IBAction)ClickDetail:(id)sender{
    PayDetailController * vc = [[PayDetailController alloc] initWithNibName:@"PayDetailController" bundle:nil];
    [self.navigationController pushViewController:vc animated:YES];}
-(IBAction)ClickBack:(id)sender{
    [[GolfMainViewController sharedInstance] hideTab:NO];
    [self.navigationController popViewControllerAnimated:YES];
}
@end

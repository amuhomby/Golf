//
//  DetailController.m
//  Golf
//
//  Created by MacAdmin on 3/31/18.
//  Copyright © 2018 MacAdmin. All rights reserved.
//

#import "DetailController.h"
#import "GolfMainViewController.h"
#import "VideoPlayController.h"

@interface DetailController ()

@end

@implementation DetailController

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
}


-(IBAction)ClickThumb:(id)sender{
    VideoPlayController * vc = [[VideoPlayController alloc] initWithNibName:@"VideoPlayController" bundle:nil];
    [self.navigationController pushViewController:vc animated:YES];
}

-(IBAction)ClickBack:(id)sender{
    [[GolfMainViewController sharedInstance] hideTab:NO];
    [self.navigationController popViewControllerAnimated:YES];
}
@end

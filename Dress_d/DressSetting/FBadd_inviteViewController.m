//
//  FBadd_inviteViewController.m
//  Dress_d
//
//  Created by MacAdmin on 12/4/17.
//  Copyright © 2017 MacAdmin. All rights reserved.
//

#import "FBadd_inviteViewController.h"
#import "AddFBFriendViewController.h"
#import "DressSearchViewController.h"


#import "GolfMainViewController.h"

@interface FBadd_inviteViewController ()
@end

@implementation FBadd_inviteViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    UISwipeGestureRecognizer *swipe = [[UISwipeGestureRecognizer alloc] initWithTarget:self action:@selector(goBack)];
    swipe.direction = UISwipeGestureRecognizerDirectionRight;
    [vwBack addGestureRecognizer:swipe];

}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
-(void)goBack{
    [self.navigationController popViewControllerAnimated:YES];
}

-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];

    [[GolfMainViewController sharedInstance] hideTab:YES];
    [self initView];
}
-(void)initView{
    CGFloat ratio = 0.4;
    CGFloat w = [UIScreen mainScreen].bounds.size.width * ratio;
    CGFloat h = [UIScreen mainScreen].bounds.size.width * ratio;
    CGFloat gap = [UIScreen mainScreen].bounds.size.width * (0.5 - ratio)/2;

    CGRect fadd =  btnAdd.frame;
    fadd.size.width = w;
    fadd.size.height = h;
    btnAdd.frame = fadd;
    
    
    CGRect finvite = btnInvite.frame;
    finvite.size.width = w;
    finvite.size.height = h;
    finvite.origin.y = fadd.origin.y + fadd.size.height + gap;
    btnInvite.frame = finvite;
    
    
    CGFloat one = [UIScreen mainScreen].bounds.size.width * 0.5;
    CGPoint padd = btnAdd.center;
    padd.x = one;
    btnAdd.center = padd;
    
    
    CGPoint pin = btnInvite.center;
    pin.x = one;
    btnInvite.center = pin;

    btnAdd.layer.cornerRadius = w/2;
    btnAdd.layer.masksToBounds = YES;
    btnAdd.layer.borderWidth = 2;
    btnAdd.layer.borderColor = [UIColor whiteColor].CGColor;
    
    btnInvite.layer.cornerRadius = w/2;
    btnInvite.layer.masksToBounds = YES;
    btnInvite.layer.borderWidth = 2;
    btnInvite.layer.borderColor = [UIColor whiteColor].CGColor;
}

- (IBAction)onClickedAddFriends:(id)sender
{
    AddFBFriendViewController *VC = [[AddFBFriendViewController alloc] initWithNibName:@"AddFBFriendViewController" bundle:nil];
    [self.navigationController pushViewController:VC animated:YES];
}

-(IBAction)onClickInviteFriend:(id)sender{

}


-(IBAction)onClickBack:(id)sender{
    [self goBack];
}

-(IBAction)onClickSrh:(id)sender{
    DressSearchViewController * vc = [[DressSearchViewController alloc]initWithNibName:@"DressSearchViewController" bundle:nil];
    [self.navigationController pushViewController:vc animated:YES];
}
@end

//
//  EditProfileViewController.m
//  Dress_d
//
//  Created by MacAdmin on 21/09/2017.
//  Copyright © 2017 MacAdmin. All rights reserved.
//

#import "EditProfileViewController.h"
#import "SelectStyleView.h"
#import "BioViewController.h"
#import "DressSearchViewController.h"
#import "ChangePhotoViewController.h"
#import "GolfMainViewController.h"




@interface EditProfileViewController ()
{
    
}

@end

@implementation EditProfileViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    
    if([Global sharedGlobal].bFBLogin){
        btnPicture.hidden = YES;
    }
    btnStyle.layer.cornerRadius = 10;
    btnStyle.layer.masksToBounds = YES;
    
    btnBio.layer.cornerRadius = 10;
    btnBio.layer.masksToBounds = YES;
    
    btnPicture.layer.cornerRadius = 10;
    btnPicture.layer.masksToBounds = YES;
    
    
    UISwipeGestureRecognizer *swipe = [[UISwipeGestureRecognizer alloc] initWithTarget:self action:@selector(goBack)];
    // And assuming the "Up" direction in your screenshot is no accident
    swipe.direction = UISwipeGestureRecognizerDirectionRight;
    [viewBack addGestureRecognizer:swipe];

}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];

    [[GolfMainViewController sharedInstance] hideTab:YES];

    CGFloat ratio = 0.4;
    CGFloat w = [UIScreen mainScreen].bounds.size.width * ratio;
    CGFloat h = [UIScreen mainScreen].bounds.size.width * ratio;
    CGFloat gap = [UIScreen mainScreen].bounds.size.width * (0.5 - ratio)/2;
    
    CGRect fadd =  btnStyle.frame;
    if([Global sharedGlobal].bFBLogin == NO){
        fadd.origin.y =  gap;
    }

    fadd.size.width = w;
    fadd.size.height = h;
    btnStyle.frame = fadd;
    
    
    CGRect finvite = btnBio.frame;
    finvite.size.width = w;
    finvite.size.height = h;
    finvite.origin.y = fadd.origin.y + fadd.size.height + gap;
    btnBio.frame = finvite;
    
    CGRect fprofile = btnPicture.frame;
    fprofile.size.width = w;
    fprofile.size.height = h;
    fprofile.origin.y = finvite.origin.y + finvite.size.height + gap;
    btnPicture.frame = fprofile;
    
    
    CGFloat one = [UIScreen mainScreen].bounds.size.width * 0.5;
    CGPoint padd = btnStyle.center;
    padd.x = one;
    btnStyle.center = padd;
    
    
    CGPoint pin = btnBio.center;
    pin.x = one;
    btnBio.center = pin;
    
    CGPoint ppic = btnPicture.center;
    ppic.x = one;
    btnPicture.center = ppic;
    
    btnStyle.layer.cornerRadius = w/2;
    btnStyle.layer.masksToBounds = YES;
    btnStyle.layer.borderWidth = 2;
    btnStyle.layer.borderColor = [UIColor whiteColor].CGColor;
    
    btnBio.layer.cornerRadius = w/2;
    btnBio.layer.masksToBounds = YES;
    btnBio.layer.borderWidth = 2;
    btnBio.layer.borderColor = [UIColor whiteColor].CGColor;
    
    btnPicture.layer.cornerRadius = w/2;
    btnPicture.layer.masksToBounds = YES;
    btnPicture.layer.borderWidth = 2;
    btnPicture.layer.borderColor = [UIColor whiteColor].CGColor;
    btnPicture.titleLabel.numberOfLines = 0;
    [btnPicture setTitle:@"Profile\nPic" forState:UIControlStateNormal];
    [btnPicture.titleLabel setTextAlignment:NSTextAlignmentCenter];
    
    CGFloat szheight;
    if([Global sharedGlobal].bFBLogin == YES){
        szheight = btnBio.frame.origin.y  + btnBio.frame.size.height + gap;
    }else{
        szheight = btnPicture.frame.origin.y  + btnPicture.frame.size.height + gap;
    }
    scrollview.contentSize = CGSizeMake(scrollview.frame.size.width, szheight);
}

- (IBAction)onClickedBack:(id)sender
{
    [self goBack];
}
-(void)goBack{
    [self.navigationController popViewControllerAnimated:YES];
}
- (IBAction)onClickedSearch:(id)sender
{
    DressSearchViewController * vc = [[DressSearchViewController alloc]initWithNibName:@"DressSearchViewController" bundle:nil];
    [self.navigationController pushViewController:vc animated:YES];
}

- (IBAction)onClickedStyle:(id)sender
{
    SelectStyleView *VC = [[SelectStyleView alloc] initWithNibName:@"SelectStyleView" bundle:nil];
    [self.navigationController pushViewController:VC animated:YES];
}

- (IBAction)onClickedBio:(id)sender
{
    BioViewController * vc = [[BioViewController alloc] initWithNibName:@"BioViewController" bundle:nil];
    [self.navigationController pushViewController:vc animated:YES];
}

- (IBAction)onClickedPicture:(id)sender
{
    ChangePhotoViewController * vc = [[ChangePhotoViewController alloc]initWithNibName:@"ChangePhotoViewController" bundle:nil];
    [self.navigationController pushViewController:vc animated:YES];
}


@end

//
//  ShoesDetailController.m
//  Golf
//
//  Created by MacAdmin on 4/1/18.
//  Copyright © 2018 MacAdmin. All rights reserved.
//

#import "ShoesDetailController.h"
#import "ShoesBuyController.h"
#import "CartController.h"

@interface ShoesDetailController ()

@end

@implementation ShoesDetailController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void)viewDidLayoutSubviews{
    [super viewDidLayoutSubviews];
    [self initData];
    [self layouControl];
}
-(void)initData{
    lbGoodDes.text = @"Do any additional setup after loading the view from its nib.Do any additional setup after loading the view from its nib.Do any additional setup after loading the view from its nib.Do any additional setup after loading the view from its nib.Do any additional setup after loading the view from its nib.Do any additional setup after loading the view from its nib.";
    
}
-(void)layImgPhoto{
    CGRect frame = imgPhoto.frame;
    frame.size.height = frame.size.width * 0.8;
    imgPhoto.frame = frame;
}

-(void)layGoodInfo{
    [lbGoodDes sizeToFit];
    CGRect flbDes = lbGoodDes.frame;

    CGRect flbPrice = lbPrice.frame;
    flbPrice.origin.y = flbDes.origin.y + flbDes.size.height + 8;
    lbPrice.frame = flbPrice;
    
    CGRect frame = vwInfo.frame;
    frame.origin.y = imgPhoto.frame.origin.y + imgPhoto.frame.size.height;
    frame.size.height = lbPrice.frame.origin.y + lbPrice.frame.size.height + 4;
    vwInfo.frame = frame;
}

-(void)laySelect{
    CGRect frame = vwSelect.frame;
    CGRect frame1 = vwInfo.frame;
    frame.origin.y = frame1.origin.y + frame1.size.height + 1;
    vwSelect.frame = frame;
    
    CGRect frame2 = vwQuick.frame;
    frame2.origin.y = frame.origin.y + frame.size.height + 1;
    vwQuick.frame = frame2;
}

-(void)layScroll{
    scrollview.contentSize = CGSizeMake(scrollview.frame.size.width, vwQuick.frame.origin.y + vwQuick.frame.size.height);
}
-(void)layouControl{
    [self layImgPhoto];
    [self layGoodInfo];
    [self laySelect];
    [self layScroll];
}

-(IBAction)ClickBack:(id)sender{
    [self.navigationController popViewControllerAnimated:YES];
}

-(IBAction)ClickSelect:(id)sender{
    
}
-(IBAction)ClickQuick:(id)sender{
    
}
-(IBAction)ClickCollect:(id)sender{
    
}
-(IBAction)ClickCar:(id)sender{
    CartController * vc = [[CartController alloc]initWithNibName:@"CartController" bundle:nil];
    [self.navigationController pushViewController:vc animated:YES];
}
-(IBAction)ClickBuy:(id)sender{
    ShoesBuyController * vc = [[ShoesBuyController alloc]initWithNibName:@"ShoesBuyController" bundle:nil];
    [self.navigationController pushViewController:vc animated:YES];
}
-(IBAction)ClickAdd:(id)sender{
    
}
-(IBAction)ClickEdit:(id)sender{
    
}
@end

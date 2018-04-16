//
//  ShoesBuyController.m
//  Golf
//
//  Created by MacAdmin on 4/1/18.
//  Copyright © 2018 MacAdmin. All rights reserved.
//

#import "ShoesBuyController.h"

@interface ShoesBuyController ()

@end

@implementation ShoesBuyController
{
    NSString * selectSize;
    NSInteger amount;
}
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
    [self layoutControl];
    [self ShowAmount];
}

-(void)initData{
    selectSize = @"M";
    amount = 1;
    [self ShowAmount];

}
-(void)layoutControl{
    imgPhoto.layer.cornerRadius = imgPhoto.frame.size.height/2;
    imgPhoto.layer.masksToBounds = YES;
    
    btnSz.backgroundColor =[UIColor blackColor];
    btnSz.layer.borderColor = GrayButtonColor.CGColor;
    btnSz.layer.borderWidth = 1;
}
-(void)ChangeSelect{
    if([selectSize isEqualToString:@"M"]){
        btnM.backgroundColor = mainGoldColor;
        btnL.backgroundColor = GrayButtonColor;
        btnXL.backgroundColor=GrayButtonColor;
        btnXXL.backgroundColor = GrayButtonColor;
    }else if([selectSize isEqualToString:@"L"]){
        btnM.backgroundColor = GrayButtonColor;
        btnL.backgroundColor = mainGoldColor;
        btnXL.backgroundColor=GrayButtonColor;
        btnXXL.backgroundColor = GrayButtonColor;
    }else if([selectSize isEqualToString:@"XL"]){
        btnM.backgroundColor = GrayButtonColor;
        btnL.backgroundColor = GrayButtonColor;
        btnXL.backgroundColor=mainGoldColor;
        btnXXL.backgroundColor = GrayButtonColor;
    }else{
        btnM.backgroundColor = GrayButtonColor;
        btnL.backgroundColor = GrayButtonColor;
        btnXL.backgroundColor=GrayButtonColor;
        btnXXL.backgroundColor = mainGoldColor;
    }
}

-(IBAction)ClickSize:(UIButton *)sender{
    NSInteger tag = sender.tag;
    if(tag == 1){
        selectSize=@"M";
    }else if(tag ==2){
        selectSize=@"L";
    }else if(tag == 3){
        selectSize = @"XL";
    }else{
        selectSize = @"XXL";
    }
    
    [self ChangeSelect];
}

-(IBAction)ClickMinus:(id)sender{
    amount--;
    if(amount < 1){
        amount = 1;
    }

    [self ShowAmount];
}
-(IBAction)ClickPlus:(id)sender{

    amount++;
    [self ShowAmount];
}
-(void)ShowAmount{
    NSString *inStr = [NSString stringWithFormat: @"%ld", (long)amount];
    [btnSz setTitle:inStr forState:UIControlStateNormal];
}
-(IBAction)ClickBack:(id)sender{
    [self.navigationController popViewControllerAnimated:YES];
}
@end

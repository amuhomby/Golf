//
//  RechargeController.m
//  Golf
//
//  Created by MacAdmin on 3/31/18.
//  Copyright © 2018 MacAdmin. All rights reserved.
//

#import "RechargeController.h"

@interface RechargeController ()<UITextFieldDelegate>
@end

@implementation RechargeController
{
    NSString * amount;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    [self layoutControl];
    [editAmount addTarget:self
                  action:@selector(textFieldDidChange:)
        forControlEvents:UIControlEventEditingChanged];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void)layoutControl{
    btnCharge.layer.cornerRadius = btnCharge.frame.size.height/2;
    btnCharge.layer.masksToBounds =YES;
}
-(void)textFieldDidChange:(UITextField *) textfield{
    amount = textfield.text;
    if(![amount isEqualToString:@""]){
        lbCaution.hidden = YES;
    }
}
-(IBAction)ClickNext:(id)sender{
    if([amount isEqualToString:@""]){
        lbCaution.hidden = NO;
    }
}

-(IBAction)ClickBack:(id)sender{
    [self.navigationController popViewControllerAnimated:YES];
}
@end

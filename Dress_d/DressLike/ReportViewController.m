//
//  ReportViewController.m
//  Dress_d
//
//  Created by MacAdmin on 11/17/17.
//  Copyright © 2017 MacAdmin. All rights reserved.
//

#import "ReportViewController.h"
#import "DressSearchViewController.h"

@interface ReportViewController ()

@end

@implementation ReportViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
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

    [self performSelector:@selector(initView) withObject:nil afterDelay:0.1];
}

-(void)initView{
    NSString * strReport  = @"Report this photo if it is offensive, contains violent, nude, partially nude, discriminatory, unlawful, infringing, hateful, pornographic or sexually suggestive material.";
    NSMutableAttributedString* attrString = [[NSMutableAttributedString  alloc] initWithString:strReport];
    NSMutableParagraphStyle *style = [[NSMutableParagraphStyle alloc] init];
    [style setLineSpacing:8];
    
    [attrString addAttribute:NSParagraphStyleAttributeName
          value:style
          range:NSMakeRange(0, strReport.length)];
    lbReport.attributedText = attrString;
    lbReport.textAlignment = NSTextAlignmentCenter;
    
    
     
    CGRect frameLbReport = lbReport.frame;
    frameLbReport.size.width = [UIScreen mainScreen].bounds.size.width * 0.8;
    lbReport.frame = frameLbReport;
    
    [lbReport sizeToFit];
    frameLbReport = lbReport.frame;
    frameLbReport.origin.x = ([UIScreen mainScreen].bounds.size.width - frameLbReport.size.width ) / 2;
    lbReport.frame = frameLbReport;
    
    btnReport.layer.cornerRadius = 10;
    btnReport.layer.masksToBounds = YES;
//    CGRect frameBtnReport = btnReport.frame;
//    frameLbReport = lbReport.frame;
//    frameBtnReport.origin.y = frameLbReport.origin.y + frameLbReport.size.height + 20;
//
//    btnReport.frame = frameBtnReport;
    
    lbThanks.hidden = YES;
    lbReport.hidden = NO;
    btnReport.hidden  = NO;
}
-(IBAction)onClickReport:(id)sender{
    UIAlertController * alert = [UIAlertController
                                 alertControllerWithTitle:nil
                                 message:@"Are you sure?"
                                 preferredStyle:UIAlertControllerStyleAlert];
    
    UIAlertAction* noButton = [UIAlertAction
                               actionWithTitle:@"Yes"
                               style:UIAlertActionStyleDefault
                               handler:^(UIAlertAction * action) {
                                   //Handle no, thanks button
                                   [self showBusyDialog];
                                   [self performSelector:@selector(reportOutfit) withObject:sender afterDelay:0.3];
                               }];
    UIAlertAction* okButton = [UIAlertAction
                               actionWithTitle:@"No"
                               style:UIAlertActionStyleDefault
                               handler:^(UIAlertAction * action) {
                                   //Handle no, thanks button
                               }];
    
    [alert addAction:noButton];
    [alert addAction:okButton];
    [self presentViewController:alert animated:YES completion:nil];

}
-(void)reportOutfit{
    NSMutableDictionary * params = [[NSMutableDictionary alloc]init];
    
    NSString * myfbid = [Global sharedGlobal].fbid;
    NSString * _token = [Global sharedGlobal].fbToken;
    [params setObject:_token forKey:@"_token"];
    [params setObject:_post_id forKey:@"post_id"];
    [params setObject:myfbid forKey:@"user_id"];
    NSDictionary * result = [UtilComm report:params];
    [self hideBusyDialog];
    
    if(result != nil){
        NSDecimalNumber * deccode = [result objectForKey:@"code"];
        NSString * code = [NSString stringWithFormat:@"%@", deccode];
        if([code isEqualToString:@"1"]){
            lbThanks.hidden = NO;
            
            lbReport.hidden = YES;
            btnReport.hidden  = YES;
        }else{
            
        }
    }else{
        [APPDELEGATE showToastMessage:CONNECT_ERROR];
    }
}
-(IBAction)onClickBack:(id)sender{
    [self goBack];
}
-(void)goBack{
    [self.navigationController popViewControllerAnimated:YES];
}
-(IBAction)onClickSrh:(id)sender{
    DressSearchViewController * vc = [[DressSearchViewController alloc]initWithNibName:@"DressSearchViewController" bundle:nil];
    [self.navigationController pushViewController:vc animated:YES];
}
@end

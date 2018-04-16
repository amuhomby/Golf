//
//  ContactViewController.m
//  Dress_d
//
//  Created by MacAdmin on 10/11/17.
//  Copyright © 2017 MacAdmin. All rights reserved.
//

#import "ContactViewController.h"
#import "DressSearchViewController.h"
#import <MessageUI/MessageUI.h>
#import "GolfMainViewController.h"

@interface ContactViewController ()<MFMailComposeViewControllerDelegate>
{
    MFMailComposeViewController *mailComposer;
}
@end

@implementation ContactViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    UISwipeGestureRecognizer *swipe = [[UISwipeGestureRecognizer alloc] initWithTarget:self action:@selector(goBack)];
    // And assuming the "Up" direction in your screenshot is no accident
    swipe.direction = UISwipeGestureRecognizerDirectionRight;
    [viewBack addGestureRecognizer:swipe];
    
}
-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];

    [[GolfMainViewController sharedInstance] hideTab:YES];

}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
-(void)sendMail{
    if([MFMailComposeViewController canSendMail]){
        mailComposer = [[MFMailComposeViewController alloc]init];
        mailComposer.mailComposeDelegate = self;
        [mailComposer setSubject:@"To Dress'd admin"];
        [mailComposer setToRecipients:[NSArray arrayWithObject:@"support@dressd.us"]];
        [self presentViewController:mailComposer animated:YES completion:nil];
    }else{
        lbCaution.hidden = NO;
    }

}
     
#pragma mark - mail compose delegate
-(void)mailComposeController:(MFMailComposeViewController *)controller
        didFinishWithResult:(MFMailComposeResult)result error:(NSError *)error{
            if (result) {
                NSLog(@"Result : %ld",(long)result);
            }
            if (error) {
                NSLog(@"Error : %@",error);
            }
       [self dismissViewControllerAnimated:YES completion:nil];
    
}
-(IBAction)onClickMail:(id)sender{
    lbCaution.hidden = YES;
    [self sendMail];
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

-(IBAction)onClickHow:(id)sender{
    UIApplication *application = [UIApplication sharedApplication];
    NSURL *URL = [NSURL URLWithString:@"http://dressd.us/index.php/howitworks"];
    [application openURL:URL options:@{} completionHandler:^(BOOL success) {
        if (success) {
            NSLog(@"Opened %@",@"fb://");
        }else{
            
        }
    }];
	}
@end

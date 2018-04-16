//
//  dressAFGateController.m
//  Strangrs
//
//  Created by MacAdmin on 9/6/17.
//  Copyright © 2017 AppDupe. All rights reserved.
//

#import "dressAFGateController.h"
#import "UIImageView+WebCache.h"
#import "dressAFViewController.h"
#import "GolfMainViewController.h"

#import <MessageUI/MessageUI.h>
#import <ContactsUI/ContactsUI.h>
#import <Contacts/Contacts.h>
#import <MessageUI/MessageUI.h>
@interface dressAFGateController ()<MFMessageComposeViewControllerDelegate, CNContactPickerDelegate>

@end

@implementation dressAFGateController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.

    if([Global sharedGlobal].bFBLogin == NO){
        btnAF.hidden = YES;
        
    }else{
        btnAF.hidden = NO;

    }
}

-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];

}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void)viewDidLayoutSubviews{
    viewCenter.layer.cornerRadius = 20;
    viewCenter.layer.masksToBounds = YES;
    
    btnAF.layer.cornerRadius = 10;
    btnAF.layer.borderWidth = 2;
    btnAF.layer.borderColor = [UIColor whiteColor].CGColor;
    btnAF.layer.masksToBounds = YES;
    
    btnContact.layer.cornerRadius = 10;
    btnContact.layer.borderWidth = 2;
    btnContact.layer.borderColor = [UIColor whiteColor].CGColor;
    btnContact.layer.masksToBounds = YES;
    
    CGRect figProfile = imgProfile.frame;
    figProfile.size.height = figProfile.size.width;
    figProfile.origin.y = (btnContact.frame.origin.y - figProfile.size.height+40)/2;
    imgProfile.frame = figProfile;
    imgProfile.layer.cornerRadius = imgProfile.layer.bounds.size.height/2;
    imgProfile.layer.masksToBounds = YES;
    
    if([Global sharedGlobal].bFBLogin == NO){
        CGRect fbtnContact = btnContact.frame;
        fbtnContact.origin.y += 10;
        btnContact.frame = fbtnContact;
    }else{
        CGRect fbtnFb = btnAF.frame;
        fbtnFb.origin.y =btnContact.frame.origin.y + btnContact.frame.size.height + (btnContact.frame.origin.y -imgProfile.frame.origin.y - imgProfile.frame.size.height);
        btnAF.frame = fbtnFb;
    }

    
    NSString * userProfilePhoto = [Global sharedGlobal].avatar;
    
    [imgProfile setImageWithURL:[NSURL URLWithString:userProfilePhoto] placeholderImage:[UIImage imageNamed:@"place_man.png"]];

//    if([Global sharedGlobal].bFBLogin == NO){
//        CGRect fcenter = viewCenter.frame;
//        viewCenter.frame = fcenter;
//
//        imgProfile.center = CGPointMake(fcenter.size.width/2, (btnCon.frame.origin.y / 2));
//    }else{
//        btnAF.hidden = NO;
//        CGRect fcenter = viewCenter.frame;
//        imgProfile.center = CGPointMake(fcenter.size.width/2, (btnAF.frame.origin.y / 2));
//
//    }

}

-(IBAction)onClickAF:(id)sender{
    dressAFViewController * vc = [[dressAFViewController alloc] initWithNibName:@"dressAFViewController" bundle:nil];
    [self presentViewController:vc animated:NO completion:nil];
}

-(IBAction)onClickHome:(id)sender{
    GolfMainViewController *VC = [[UIStoryboard storyboardWithName:@"GolfMain" bundle:nil] instantiateViewControllerWithIdentifier:@"main"];
    [self presentViewController:VC animated:YES completion:nil];
}
-(IBAction)onClickInviteContact:(id)sender{
    //    ContactMsgViewController * vc = [[ContactMsgViewController alloc]initWithNibName:@"ContactMsgViewController" bundle:nil];
    //    [self.navigationController pushViewController:vc animated:YES];
    
    [self getContactPermission];
}
-(void)getContactPermission{
    if ([CNContactStore class]) {
        //ios9 or later
        CNEntityType entityType = CNEntityTypeContacts;
        if( [CNContactStore authorizationStatusForEntityType:entityType] == CNAuthorizationStatusNotDetermined)
        {
            CNContactStore * contactStore = [[CNContactStore alloc] init];
            [contactStore requestAccessForEntityType:entityType completionHandler:^(BOOL granted, NSError * _Nullable error) {
                if(granted){
                    [self showContactViewController];
                }
            }];
        }
        else if( [CNContactStore authorizationStatusForEntityType:entityType]== CNAuthorizationStatusAuthorized)
        {
            [self showContactViewController];
        }
    }
}
-(void)showContactViewController{
    
    CNContactPickerViewController * vc = [[CNContactPickerViewController alloc]init];
    vc.delegate = self;
    [self presentViewController:vc animated:YES completion:nil];
    
}

- (void)contactPickerDidCancel:(CNContactPickerViewController *)picker{
    [self dismissViewControllerAnimated:YES completion:nil];
}

- (void)contactPicker:(CNContactPickerViewController *)picker didSelectContact:(CNContact *)contact{
    [self dismissViewControllerAnimated:YES completion:nil];
    NSArray <CNLabeledValue<CNPhoneNumber *> *> *phoneNumbers = contact.phoneNumbers;
    CNLabeledValue<CNPhoneNumber *> *firstPhone = [phoneNumbers firstObject];
    CNPhoneNumber *number = firstPhone.value;
    NSString *digits = number.stringValue; // 1234567890
    [self performSelector:@selector(showSMS:) withObject:digits afterDelay:0.01];
}


- (void)showSMS:(NSString *) phone {
    
    if(![MFMessageComposeViewController canSendText]) {
        UIAlertController * alert = [UIAlertController
                                     alertControllerWithTitle:@"Error"
                                     message:@"Your device doesn't support SMS!"
                                     preferredStyle:UIAlertControllerStyleAlert];
        
        UIAlertAction* okButton = [UIAlertAction
                                   actionWithTitle:@"OK"
                                   style:UIAlertActionStyleDefault
                                   handler:^(UIAlertAction * action) {
                                       //Handle ok button
                                   }];
        
        [alert addAction:okButton];
        [self presentViewController:alert animated:YES completion:nil];
        return;
    }
    
    NSArray *recipents = @[phone];
    NSString *message = @"Hey! Check out Dress'd: the social media app for outfits. Download the app from the Apple App Store and add me as a friend!\nhttps://itunes.apple.com/us/app/dressd/id1288417946?mt=8";
    
    MFMessageComposeViewController *messageController = [[MFMessageComposeViewController alloc] init];
    messageController.messageComposeDelegate = self;
    [messageController setRecipients:recipents];
    [messageController setBody:message];
    
    
    // Present message view controller on screen
    [self presentViewController:messageController animated:YES completion:nil];
}

- (void)messageComposeViewController:(MFMessageComposeViewController *)controller didFinishWithResult:(MessageComposeResult) result
{
    switch (result) {
        case MessageComposeResultCancelled:
            break;
            
        case MessageComposeResultFailed:
        {
            UIAlertController * alert = [UIAlertController
                                         alertControllerWithTitle:@"Error"
                                         message:@"Failed to send SMS!"
                                         preferredStyle:UIAlertControllerStyleAlert];
            
            UIAlertAction* okButton = [UIAlertAction
                                       actionWithTitle:@"OK"
                                       style:UIAlertActionStyleDefault
                                       handler:^(UIAlertAction * action) {
                                           //Handle ok button
                                       }];
            
            [alert addAction:okButton];
            [self presentViewController:alert animated:YES completion:nil];
            break;
        }
            
        case MessageComposeResultSent:
            break;
            
        default:
            break;
    }
    [self dismissViewControllerAnimated:YES completion:nil];
}

-(IBAction)onClickInvite:(id)sender{

}

@end

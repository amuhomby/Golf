//
//  SettingViewController.m
//  Dress_d
//
//  Created by MacAdmin on 12/7/17.
//  Copyright © 2017 MacAdmin. All rights reserved.
//

#import "SettingViewController.h"
#import "EditProfileViewController.h"
#import "EditPrivacyViewController.h"
#import "NotifiSettingViewController.h"
#import "HomeViewController.h"
#import "AddFBFriendViewController.h"
#import "DressSearchViewController.h"
#import "SelectStyleView.h"

#import "FriendListViewController.h"
#import "BioViewController.h"
#import "ContactViewController.h"
#import "PrivacyViewController.h"
#import "FBadd_inviteViewController.h"

#import <MessageUI/MessageUI.h>
#import <ContactsUI/ContactsUI.h>
#import <Contacts/Contacts.h>
#import <MessageUI/MessageUI.h>
#import "GolfMainViewController.h"

@interface SettingViewController ()<MFMessageComposeViewControllerDelegate, CNContactPickerDelegate>
{
    IBOutlet UILabel * lbTerms;
    NSMutableArray * arrSetting;
}
@end

@implementation SettingViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    UISwipeGestureRecognizer *swipe = [[UISwipeGestureRecognizer alloc] initWithTarget:self action:@selector(goBack)];
    // And assuming the "Up" direction in your screenshot is no accident
    swipe.direction = UISwipeGestureRecognizerDirectionRight;
    [scrollview addGestureRecognizer:swipe];

    // Do any additional setup after loading the view from its nib.
    self.navigationController.navigationBarHidden = YES;
    //    [self controlButton];
    
    if([Global sharedGlobal].bFBLogin == YES){
        arrSetting = [[NSMutableArray alloc] initWithObjects:@"Friends", @"Profile", @"FB\nFriends", @"Notifications", @"Privacy", @"Contacts", @"Terms", @"Policy",@"Support", @"Log out",  nil];
    }else{
        arrSetting = [[NSMutableArray alloc] initWithObjects:@"Friends", @"Profile", @"Notifications", @"Privacy", @"Contacts", @"Terms", @"Policy", @"Support", @"Log out", nil];
    }
    [self addButtons];
    
}

-(void)goBack{
    [self.navigationController popViewControllerAnimated:YES];
}
-(void)addButtons{
    [self RemoveAllSubViews:scrollview];
    CGFloat ratio = 0.4;
    CGFloat w = [UIScreen mainScreen].bounds.size.width * ratio;
    CGFloat h = [UIScreen mainScreen].bounds.size.width * ratio;
    CGFloat gap = [UIScreen mainScreen].bounds.size.width * (0.5 - ratio)/2;
    CGFloat one = [UIScreen mainScreen].bounds.size.width * 0.25;
    CGFloat three =  [UIScreen mainScreen].bounds.size.width * 0.75;
    
    for(int i=0; i < [arrSetting count]; i++){
        NSString * row = [arrSetting objectAtIndex:i];
        
        int b = i % 2;
        int a = (i - b)/2;
        
        CGRect fbtn = CGRectMake(0, 0, w, h);
        UIButton * btn = [[UIButton alloc]initWithFrame:fbtn];
        
        CGFloat x = 0, y= 0;
        
        if(b == 0){
            x = one;
        }else{
            x = three;
        }
        y = (gap + h) * (a + 1) - h/2;
        
        btn.center = CGPointMake(x, y);
        
        btn.layer.cornerRadius = h/2;
        btn.layer.masksToBounds = YES;
        btn.layer.borderColor = [UIColor whiteColor].CGColor;
        btn.layer.borderWidth = 2;
        [btn setBackgroundColor:[UIColor clearColor]];
        btn.titleLabel.numberOfLines = 0;
        [btn.titleLabel setTextAlignment:NSTextAlignmentCenter];
        btn.tag = i;
        [btn addTarget:self action:@selector(bindAction:) forControlEvents:UIControlEventTouchUpInside];
        btn.titleLabel.font = [UIFont fontWithName:@"Georgia" size:18];
        [btn setTitle:row forState:UIControlStateNormal];
        [btn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        [scrollview addSubview:btn];
        btn.selected = NO;
    }
    
    CGFloat height =(floorf(([arrSetting count]+ 1) / 2)) * (gap + h) + gap;
    scrollview.contentSize = CGSizeMake(scrollview.frame.size.width, height);
    
}
-(void)RemoveAllSubViews:(UIView *)sender{
    NSArray *viewsToRemove = [sender subviews];
    for (UIView *v in viewsToRemove) {
        [v removeFromSuperview];
    }
}
-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];

    [[GolfMainViewController sharedInstance] hideTab:YES];
    [scrollview setContentOffset:
     CGPointMake(0, -scrollview.contentInset.top) animated:YES];
}

-(void)viewWillDisappear:(BOOL)animated{
    [[GolfMainViewController sharedInstance] hideTab:NO];
}

-(void)bindAction:(UIButton *) sender{
    NSInteger index = sender.tag;
    
    if([Global sharedGlobal].bFBLogin == YES){
        switch (index) {
            case 0:
                [self onClickedFriend];
                break;
            case 1:
                [self onClickedEditProfile];
                break;
            case 2:
                [self onClickedFB];
                break;
            case 3:
                [self onClickedNotifications:@"notification"];
                break;
            case 4:
                [self onClickedNotifications:@"privacy"];
                break;
            case 5:
                [self onClickInviteContac];
                break;
            case 6:
                [self onClickedTerms];
                break;
            case 7:
                [self onClickedPrivacyPolicy];
                break;
            case 8:
                [self onClickedContact];
                break;
            case 9:
                [self onClickedLogout];
                break;
                
            default:
                break;
        }
    }else{
        switch (index) {
            case 0:
                [self onClickedFriend];
                break;
            case 1:
                [self onClickedEditProfile];
                break;
            case 2:
                [self onClickedNotifications:@"notification"];
                break;
            case 3:
                [self onClickedNotifications:@"privacy"];
                break;
            case 4:
                [self onClickInviteContac];
                break;
            case 5:
                [self onClickedTerms];
                break;
            case 6:
                [self onClickedPrivacyPolicy];
                break;
            case 7:
                [self onClickedContact];
                break;
            case 8:
                [self onClickedLogout];
                break;
                
            default:
                break;
        }
    }
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)onClickedSearch:(id)sender
{
    DressSearchViewController * vc = [[DressSearchViewController alloc]initWithNibName:@"DressSearchViewController" bundle:nil];
    [self.navigationController pushViewController:vc animated:YES];
    
}



- (void)onClickedFriend
{
    
    FriendListViewController * vc = [[FriendListViewController alloc]initWithNibName:@"FriendListViewController" bundle:nil];
    NSString * my_id = [Global sharedGlobal].fbid;
    vc.user_id = my_id;
    vc.fromSetting = @"yes";
    [self.navigationController pushViewController:vc animated:YES];
}


- (void)onClickedEditProfile
{
    EditProfileViewController *VC = [[EditProfileViewController alloc] initWithNibName:@"EditProfileViewController" bundle:nil];
    [self.navigationController pushViewController:VC animated:YES];
}

- (void)onClickedFB
{
    if([Global sharedGlobal].bFBLogin == NO){
        
    }else{
        FBadd_inviteViewController *VC = [[FBadd_inviteViewController alloc] initWithNibName:@"FBadd_inviteViewController" bundle:nil];
        [self.navigationController pushViewController:VC animated:YES];
    }
}



- (void)onClickedNotifications:(NSString *) type
{
    NotifiSettingViewController *VC = [[NotifiSettingViewController alloc] initWithNibName:@"NotifiSettingViewController" bundle:nil];
    VC.type = type;
    [self.navigationController pushViewController:VC animated:YES];
}


-(void)onClickInviteContac{
    //    ContactMsgViewController * vc = [[ContactMsgViewController alloc]initWithNibName:@"ContactMsgViewController" bundle:nil];
    //    [self.navigationController pushViewController:vc animated:YES];
    
    [self getContactPermission];
}


- (void)onClickedTerms
{
    PrivacyViewController * vc = [[PrivacyViewController alloc]initWithNibName:@"PrivacyViewController" bundle:nil];
    vc.webAddress =@"http://app.dressd.us/terms/terms.html";
    
    [self.navigationController pushViewController:vc animated:YES];
    
}


- (void)onClickedPrivacyPolicy
{
    //    EditPrivacyViewController *VC = [[EditPrivacyViewController alloc] initWithNibName:@"EditPrivacyViewController" bundle:nil];
    //    [self.navigationController pushViewController:VC animated:YES];
    
    
    PrivacyViewController * vc = [[PrivacyViewController alloc]initWithNibName:@"PrivacyViewController" bundle:nil];
    vc.webAddress =@"http://app.dressd.us/privacy/privacy.html";
    
    [self.navigationController pushViewController:vc animated:YES];
}

- (void)onClickedLogout
{
 
}



- (void)onClickedContact
{
    
    ContactViewController * vc = [[ContactViewController alloc]initWithNibName:@"ContactViewController" bundle:nil];
    
    [self.navigationController pushViewController:vc animated:YES];
    
}

-(IBAction)onClickInviteFriend:(id)sender{
    

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
    viewCover.hidden = NO;
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
        viewCover.hidden = YES;
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
    viewCover.hidden = YES;
    [self dismissViewControllerAnimated:YES completion:nil];
}

@end

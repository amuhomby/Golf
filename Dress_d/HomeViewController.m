//
//  HomeViewController.m
//  Vala
//
//  Created by MacAdmin on 5/31/16.
//  Copyright © 2016 dev. All rights reserved.
//

#import "HomeViewController.h"

#import "GolfMainViewController.h"

#import "dressWelcomeController.h"
#import "GolfMainViewController.h"
#import "AppDelegate.h"
#import "FTermsViewController.h"
#import "SignUpViewController.h"
#import "ResetViewController.h"

@interface HomeViewController ()<UITextFieldDelegate>
{
    BOOL _isObserving;
    float _oriStoryY;
    
    float       _keyboardHeight;
    UIView      *_curEditingField;
    int         _ScrolHeight;
}
@end

@implementation HomeViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    _ScrolHeight = scrollview.bounds.size.height;
    scrollview.contentSize = CGSizeMake(scrollview.frame.size.width, _ScrolHeight);

    UITapGestureRecognizer *tapRecog = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(dismissKeyboard)];
    tapRecog.cancelsTouchesInView = NO;
    [vwBack addGestureRecognizer:tapRecog];
    
    self.navigationController.navigationBarHidden = YES;
    
    btnLogin.layer.cornerRadius = 10;
    btnLogin.layer.masksToBounds =YES;
    
    viewEmail.layer.cornerRadius = 10;
    viewEmail.layer.borderWidth = 2;
    viewEmail.layer.borderColor = [UIColor whiteColor].CGColor;
    viewEmail.layer.masksToBounds =YES;

    viewPwd.layer.cornerRadius = 10;
    viewPwd.layer.borderWidth = 2;
    viewPwd.layer.borderColor = [UIColor whiteColor].CGColor;
    viewPwd.layer.masksToBounds =YES;

    btnFBLogin.layer.cornerRadius = 10;
    btnFBLogin.layer.borderWidth = 2;
    btnFBLogin.layer.borderColor = [UIColor whiteColor].CGColor;
    btnFBLogin.layer.masksToBounds =YES;
}


-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    
    self.navigationController.navigationBarHidden = YES;
    [UIView commitAnimations];
    if (!_isObserving) {
        NSNotificationCenter *noticication = [NSNotificationCenter defaultCenter];
        [noticication addObserver:self selector:@selector(keyboardWillShow:) name:UIKeyboardWillShowNotification object:nil];
        [noticication addObserver:self selector:@selector(keyboardWillHide:) name:UIKeyboardWillHideNotification object:nil];
        
        _isObserving = YES;
    }
}

- (void)viewWillDisappear:(BOOL)animated
{
    if (_isObserving) {
        NSNotificationCenter *noticication = [NSNotificationCenter defaultCenter];
        [noticication removeObserver:self name:UIKeyboardWillShowNotification object:nil];
        [noticication removeObserver:self name:UIKeyboardWillHideNotification object:nil];
        
        _isObserving = NO;
    }
    
    [super viewWillDisappear:animated];
}


-(BOOL)textFieldShouldBeginEditing:(UITextField *)textField{
    _curEditingField = textField;
    return YES;
    
}

-(void) keyboardWillShow:(NSNotification *) notification{
    
    NSTimeInterval duration = [[[notification userInfo] objectForKey:UIKeyboardAnimationDurationUserInfoKey] doubleValue];
    
    [UIView animateWithDuration:duration animations:^{
        
        NSDictionary *userInfo = [notification userInfo];
        CGSize kbSize = [[userInfo objectForKey:UIKeyboardFrameEndUserInfoKey] CGRectValue].size;
        
        if( kbSize.width < kbSize.height )
            _keyboardHeight = kbSize.width;
        else
            _keyboardHeight = kbSize.height;
        
        CGSize size = scrollview.frame.size;
        size.height = _ScrolHeight + _keyboardHeight;
        scrollview.contentSize = size;
        
        CGRect  contentRect = [scrollview convertRect:_curEditingField.bounds fromView:_curEditingField];
        contentRect.size.height += _keyboardHeight  + 20;
        
        [scrollview scrollRectToVisible:contentRect animated:YES];
        
    } completion:NULL];
}

-(void) keyboardWillHide:(NSNotification *)notification{
    
    NSTimeInterval duration = [[[notification userInfo] objectForKey:UIKeyboardAnimationDurationUserInfoKey] doubleValue];
    
    [UIView animateWithDuration:duration animations:^{
        
        CGSize size = scrollview.frame.size;
        size.height = _ScrolHeight;
        scrollview.contentSize = size;
        scrollview.contentOffset = CGPointMake(0, -20);
        _curEditingField = nil;
    } completion:NULL];
}
- (void)dismissKeyboard
{
    [_curEditingField resignFirstResponder];
}

-(BOOL)textFieldShouldEndEditing:(UITextField *)textField{
    [self dismissKeyboard];
    return  YES;
}

-(BOOL)textFieldShouldReturn:(UITextField *)textField{
    [self dismissKeyboard];
    return YES;
}
- (BOOL)validateEmailWithString
{
    NSString * email = tfEmail.text;
    NSString *emailRegex = @"[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,4}";
    NSPredicate *emailTest = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", emailRegex];
    BOOL validEmail = [emailTest evaluateWithObject:email];
    if(!validEmail){
        [APPDELEGATE showToastMessage:@"Invalid email"];
        return NO;
    }
    
    NSString * pwd = tfPwd.text;
    NSInteger szlen = pwd.length;
    if(szlen < 6){
        [APPDELEGATE showToastMessage:@"Password length should exceed 6character."];
        return  NO;
    }else{
        return YES;
    }

}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(IBAction)onLoginFB:(id)sender
{
    
}
- (void)processLogin
{
   
    NSString * fb_id = [Global sharedGlobal].fbid;
    NSString * fbAccessToken = [Global sharedGlobal].fbToken;
    NSString * first_name = [Global sharedGlobal].fbfname;
    NSString * last_name = [Global sharedGlobal].fblname;
    NSString * fbemail = [Global sharedGlobal].fbEmail;
    NSString * avatar = [NSString stringWithFormat:@"https://graph.facebook.com/%@/picture?type=large", fb_id];
    
    NSMutableDictionary *params = [[NSMutableDictionary alloc] initWithCapacity:0];
    [params setValue:fb_id forKey:@"fb_id"];
    [params setValue:fbAccessToken forKey:@"_token"];
    [params setValue:first_name forKey:@"first_name"];
    [params setValue:last_name forKey:@"last_name"];
    [params setValue:fbemail forKey:@"email"];
    [params setValue:avatar forKey:@"avatar"];
    
    NSDictionary *result = [UtilComm loginUser:params];
    [self hideBusyDialog];
    
    if ( result != nil )
    {
        NSDecimalNumber* deccode = [result objectForKey:@"code"];
        NSString * code = [NSString stringWithFormat:@"%@", deccode];
        if([code isEqualToString:@"1"])
        {
            NSString * strUserStyle = [result objectForKey:@"userstyles"];
            NSMutableDictionary * dicNoti  = [result objectForKey:@"profile"];
            NSString * szNoti =[NSString stringWithFormat:@"%@", [dicNoti objectForKey:@"mynotification"]];
            NSString * szFri  =[NSString stringWithFormat:@"%@", [dicNoti objectForKey:@"friendnotification"]];
            [Global sharedGlobal].szFri = szFri;
            [Global sharedGlobal].szNoti = szNoti;
            [Global sharedGlobal].userStyle = strUserStyle;
            [Global sharedGlobal].bLogin = YES;
            [Global sharedGlobal].bFBLogin = YES;
            [[Global sharedGlobal] SaveParam];
            
            NSString * usingapp  = [Global sharedGlobal].usingApp;
            if ( usingapp == (NSString *)[NSNull null] )
            {
                usingapp = @"";
            }
            if([usingapp isEqualToString:@"usingApp"])
            {
                GolfMainViewController *VC = [[UIStoryboard storyboardWithName:@"GolfMain" bundle:nil] instantiateViewControllerWithIdentifier:@"main"];
                [self presentViewController:VC animated:YES completion:nil];
            }else{
//                dressWelcomeController *venuView = [[dressWelcomeController alloc] initWithNibName:@"dressWelcomeController" bundle:nil];
//                [self presentViewController:venuView animated:NO completion:nil];
                
                FTermsViewController *view = [[FTermsViewController alloc] initWithNibName:@"FTermsViewController" bundle:nil];
                [self.navigationController pushViewController:view animated:YES];
            }
            
            
        }else {
            NSString * data =@"Username/password is incorrect.";// [result objectForKey:@"data"];
            UIAlertController * alert = [UIAlertController
                                         alertControllerWithTitle:@"Error"
                                         message:data
                                         preferredStyle:UIAlertControllerStyleAlert];
            
            UIAlertAction* noButton = [UIAlertAction
                                       actionWithTitle:@"OK"
                                       style:UIAlertActionStyleDefault
                                       handler:^(UIAlertAction * action) {
                                           //Handle ok button
                                       }];
            
            [alert addAction:noButton];
            [self presentViewController:alert animated:YES completion:nil];
        }
        
    }else{
        [APPDELEGATE showToastMessage:@"Could not connect to server"];
    }
    
}

-(IBAction)onClickLogin:(id)sender{
    if([self validateEmailWithString]){
        [self showBusyDialog];
        [self performSelector:@selector(signin) withObject:nil afterDelay:0.1];
    };
}

-(void)signin{
    NSMutableDictionary * params = [[NSMutableDictionary  alloc]init];
    NSString * email = tfEmail.text;
    NSString * password = tfPwd.text;
    [params setObject:email forKey:@"email"];
    [params setObject:password forKey:@"password"];
    NSDictionary * result = [UtilComm signin:params];
    [self hideBusyDialog];
    
    if ( result != nil )
    {
        NSDecimalNumber* deccode = [result objectForKey:@"code"];
        NSString * code = [NSString stringWithFormat:@"%@", deccode];
        if([code isEqualToString:@"1"])
        {
            NSString * strUserStyle = [result objectForKey:@"userstyles"];
            NSMutableDictionary * dicNoti  = [result objectForKey:@"profile"];
            NSString * szNoti =[NSString stringWithFormat:@"%@", [dicNoti objectForKey:@"mynotification"]];
            NSString * szFri  =[NSString stringWithFormat:@"%@", [dicNoti objectForKey:@"friendnotification"]];
            NSString * avatar = [result objectForKey:@"avatar"];
            NSString * userid = [result objectForKey:@"user_id"];
            NSString * _token = [result objectForKey:@"_token"];
            NSString * fname = [result objectForKey:@"firstname"];
            NSString * lname = [result objectForKey:@"lastname"];
            
            [Global sharedGlobal].szFri = szFri;
            [Global sharedGlobal].szNoti = szNoti;
            [Global sharedGlobal].userStyle = strUserStyle;
            [Global sharedGlobal].bLogin = YES;
            [Global sharedGlobal].bFBLogin = NO;
            
            [Global sharedGlobal].avatar = avatar;
            [Global sharedGlobal].fbid = userid;
            [Global sharedGlobal].fbToken = _token;
            [Global sharedGlobal].fbfname = fname;
            [Global sharedGlobal].fblname = lname;
            
            [Global sharedGlobal].fbEmail = tfEmail.text;
            [Global sharedGlobal].password = tfPwd.text;
            [[Global sharedGlobal] SaveParam];
            
            
            NSString * usingapp  = [Global sharedGlobal].usingApp;
            if ( usingapp == (NSString *)[NSNull null] )
            {
                usingapp = @"";
            }
            if([usingapp isEqualToString:@"usingApp"])
            {
                GolfMainViewController *VC = [[UIStoryboard storyboardWithName:@"GolfMain" bundle:nil] instantiateViewControllerWithIdentifier:@"main"];
                [self presentViewController:VC animated:YES completion:nil];
            }else{
                //                dressWelcomeController *venuView = [[dressWelcomeController alloc] initWithNibName:@"dressWelcomeController" bundle:nil];
                //                [self presentViewController:venuView animated:NO completion:nil];
                
                FTermsViewController *view = [[FTermsViewController alloc] initWithNibName:@"FTermsViewController" bundle:nil];
                [self.navigationController pushViewController:view animated:YES];
            }
            
            
        }else {
            NSString * data = @"Username/password is incorrect.";//[result objectForKey:@"data"];
            UIAlertController * alert = [UIAlertController
                                         alertControllerWithTitle:@"Error"
                                         message:data
                                         preferredStyle:UIAlertControllerStyleAlert];
            
            UIAlertAction* noButton = [UIAlertAction
                                       actionWithTitle:@"OK"
                                       style:UIAlertActionStyleDefault
                                       handler:^(UIAlertAction * action) {
                                           //Handle ok button
                                       }];
            
            [alert addAction:noButton];
            [self presentViewController:alert animated:YES completion:nil];
        }
        
    }else{
        [APPDELEGATE showToastMessage:@"Could not connect to server"];
    }

}
-(IBAction)onClickSignUp:(id)sender{
    SignUpViewController * vc = [[SignUpViewController alloc]initWithNibName:@"SignUpViewController" bundle:nil];
    [self.navigationController pushViewController:vc animated:YES];
}

-(IBAction)onClickReset:(id)sender{
    ResetViewController * vc = [[ResetViewController alloc]initWithNibName:@"ResetViewController" bundle:nil];
    [self.navigationController pushViewController:vc animated:YES];
}
@end

//
//  EditPrivacyViewController.m
//  Dress_d
//
//  Created by MacAdmin on 21/09/2017.
//  Copyright © 2017 MacAdmin. All rights reserved.
//

#import "EditPrivacyViewController.h"
#import "DressSearchViewController.h"
#import "GolfMainViewController.h"


@interface EditPrivacyViewController ()
{
    IBOutlet UIButton *_btnFriends;
    IBOutlet UIButton *_btnStyle;
    IBOutlet UIButton *_btnPublic;
    
}

@end

@implementation EditPrivacyViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    UISwipeGestureRecognizer *swipe = [[UISwipeGestureRecognizer alloc] initWithTarget:self action:@selector(goBack)];
    // And assuming the "Up" direction in your screenshot is no accident
    swipe.direction = UISwipeGestureRecognizerDirectionRight;
    [viewBack addGestureRecognizer:swipe];

    
    _btnFriends.layer.cornerRadius = _btnFriends.frame.size.height/2;
    _btnFriends.layer.borderColor = mainGreenColor.CGColor;
    _btnFriends.layer.borderWidth = 1;
    _btnFriends.layer.masksToBounds = YES;
    
    _btnStyle.layer.cornerRadius = _btnStyle.frame.size.height/2;
    _btnStyle.layer.borderColor = mainGreenColor.CGColor;
    _btnStyle.layer.borderWidth = 1;
    _btnStyle.layer.masksToBounds = YES;
    
    _btnPublic.layer.cornerRadius = _btnPublic.frame.size.height/2;
    _btnPublic.layer.borderColor = mainGreenColor.CGColor;
    _btnPublic.layer.borderWidth = 1;
    _btnPublic.layer.masksToBounds = YES;

    [self showBusyDialog];
    [self performSelector:@selector(getPrivacySettings) withObject:nil afterDelay:0.5];
}


-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];

    [[GolfMainViewController sharedInstance] hideTab:YES];
}


- (void)getPrivacySettings
{
    NSMutableDictionary *params = [[NSMutableDictionary alloc] initWithCapacity:0];
    NSString * _token = [Global sharedGlobal].fbToken;
    NSString * _fb_id = [Global sharedGlobal].fbid;
    [params setObject:_token forKey:@"_token"];
    [params setObject:_fb_id forKey:@"user_id"];

    NSDictionary * result = [UtilComm getPrivacy:params];
    if ( result != nil )
    {
        if ( [[result objectForKey:@"code"] intValue] == 1 )
        {
            NSDictionary *data = [result objectForKey:@"data"];
            if ( data != nil )
            {
                int nFriend = [[data objectForKey:@"friends"] intValue];
                int nStyle = [[data objectForKey:@"style"] intValue];
                int nPublic = [[data objectForKey:@"public"] intValue];
                if ( nFriend == 1 )
                    _btnFriends.selected = YES;
                if ( nStyle == 1 )
                    _btnStyle.selected = YES;
                if ( nPublic == 1 )
                    _btnPublic.selected = YES;
            }
        }
    }
    else
    {
        UIAlertController * alert = [UIAlertController
                                     alertControllerWithTitle:@"Error"
                                     message:@"Fail to connect server"
                                     preferredStyle:UIAlertControllerStyleAlert];
        
        UIAlertAction* noButton = [UIAlertAction
                                   actionWithTitle:@"OK"
                                   style:UIAlertActionStyleDefault
                                   handler:^(UIAlertAction * action) {
                                       //Handle no, thanks button
                                   }];
        
        [alert addAction:noButton];
        
        [self presentViewController:alert animated:YES completion:nil];
    }

    [self hideBusyDialog];
    [self selectBtns];
}

- (void)selectBtns
{
    if ( _btnFriends.selected )
    {
        _btnFriends.backgroundColor = mainGreenColor;
        [_btnFriends setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    }
    else
    {
        _btnFriends.backgroundColor = [UIColor whiteColor];
        [_btnFriends setTitleColor:mainGreenColor forState:UIControlStateNormal];
    }
    
    if ( _btnStyle.selected )
    {
        _btnStyle.backgroundColor = mainGreenColor;
        [_btnStyle setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    }
    else
    {
        _btnStyle.backgroundColor = [UIColor whiteColor];
        [_btnStyle setTitleColor:mainGreenColor forState:UIControlStateNormal];
    }
    
    if ( _btnPublic.selected )
    {
        _btnPublic.backgroundColor = mainGreenColor;
        [_btnPublic setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    }
    else
    {
        _btnPublic.backgroundColor = [UIColor whiteColor];
        [_btnPublic setTitleColor:mainGreenColor forState:UIControlStateNormal];
    }
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
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

- (IBAction)onClickedFriends:(id)sender
{
    _btnFriends.selected = !_btnFriends.selected;
    if ( _btnFriends.selected )
    {
        _btnFriends.backgroundColor = mainGreenColor;
        [_btnFriends setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    }
    else
    {
        _btnFriends.backgroundColor = [UIColor whiteColor];
        [_btnFriends setTitleColor:mainGreenColor forState:UIControlStateNormal];
    }
    [self showBusyDialog];
    [self performSelector:@selector(setPrivacyChanges) withObject:nil afterDelay:0.5];

}

- (IBAction)onClickedStyle:(id)sender
{
    _btnStyle.selected = !_btnStyle.selected;
    if ( _btnStyle.selected )
    {
        _btnStyle.backgroundColor = mainGreenColor;
        [_btnStyle setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    }
    else
    {
        _btnStyle.backgroundColor = [UIColor whiteColor];
        [_btnStyle setTitleColor:mainGreenColor forState:UIControlStateNormal];
    }
    [self showBusyDialog];
    [self performSelector:@selector(setPrivacyChanges) withObject:nil afterDelay:0.5];

}

- (IBAction)onClickedPublic:(id)sender
{
    _btnPublic.selected = !_btnPublic.selected;
    if ( _btnPublic.selected )
    {
        _btnPublic.backgroundColor = mainGreenColor;
        [_btnPublic setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    }
    else
    {
        _btnPublic.backgroundColor = [UIColor whiteColor];
        [_btnPublic setTitleColor:mainGreenColor forState:UIControlStateNormal];
    }
    [self showBusyDialog];
    [self performSelector:@selector(setPrivacyChanges) withObject:nil afterDelay:0.5];

}

- (IBAction)onClickedContinue:(id)sender
{
//    [self showBusyDialog];
//    [self performSelector:@selector(setPrivacyChanges) withObject:nil afterDelay:0.5];
}

- (void)setPrivacyChanges
{
    NSMutableDictionary *params = [[NSMutableDictionary alloc] initWithCapacity:0];
    NSString * _token = [Global sharedGlobal].fbToken;
    NSString * _fb_id = [Global sharedGlobal].fbid;
    [params setObject:_token forKey:@"_token"];
    [params setObject:_fb_id forKey:@"user_id"];
    if ( _btnFriends.selected )
        [params setObject:@"1" forKey:@"friends"];
    else
        [params setObject:@"0" forKey:@"friends"];
    
    if ( _btnStyle.selected )
        [params setObject:@"1" forKey:@"style"];
    else
        [params setObject:@"0" forKey:@"style"];

    if ( _btnPublic.selected )
        [params setObject:@"1" forKey:@"public"];
    else
        [params setObject:@"0" forKey:@"public"];
    
    NSDictionary * result = [UtilComm setPrivacy:params];
    if ( result != nil )
    {
        if ( [[result objectForKey:@"code"] intValue] == 1 )
        {
        }
//        [self.navigationController popViewControllerAnimated:YES];
    }
    else
    {
        UIAlertController * alert = [UIAlertController
                                     alertControllerWithTitle:@"Error"
                                     message:@"Fail to connect server"
                                     preferredStyle:UIAlertControllerStyleAlert];
        
        UIAlertAction* noButton = [UIAlertAction
                                   actionWithTitle:@"OK"
                                   style:UIAlertActionStyleDefault
                                   handler:^(UIAlertAction * action) {
                                       //Handle no, thanks button
                                   }];
        
        [alert addAction:noButton];
        
        [self presentViewController:alert animated:YES completion:nil];
    }
    
    [self hideBusyDialog];
}

@end

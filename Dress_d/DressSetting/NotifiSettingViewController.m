//
//  NotifiSettingViewController.m
//  Dress_d
//
//  Created by MacAdmin on 21/09/2017.
//  Copyright © 2017 MacAdmin. All rights reserved.
//

#import "NotifiSettingViewController.h"
#import "DressSearchViewController.h"
#import "GolfMainViewController.h"


@interface NotifiSettingViewController ()
{
    IBOutlet UIButton *_btnMeOn;
    IBOutlet UIButton *_btnMeOff;
    
    IBOutlet UIButton *_btnPublickOn;
    IBOutlet UIButton *_btnPublicOff;
    
    IBOutlet UIButton *_btnStyleOn;
    IBOutlet UIButton *_btnStyleOff;
    
    
}

@end

@implementation NotifiSettingViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    UISwipeGestureRecognizer *swipe = [[UISwipeGestureRecognizer alloc] initWithTarget:self action:@selector(goBack)];
    // And assuming the "Up" direction in your screenshot is no accident
    swipe.direction = UISwipeGestureRecognizerDirectionRight;
    [viewBack addGestureRecognizer:swipe];

    

    [self showBusyDialog];
    [self performSelector:@selector(getNotificationsSettings) withObject:nil afterDelay:0.5];
    
}

-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];

    [[GolfMainViewController sharedInstance] hideTab:YES];

    [self RemoveAllSubViews:vwNoti];
    [self RemoveAllSubViews:vwPrivacy];
    CGFloat ratio = 0.4;
    CGFloat w = [UIScreen mainScreen].bounds.size.width * ratio;
    CGFloat h = [UIScreen mainScreen].bounds.size.width * ratio;
    CGFloat gap = [UIScreen mainScreen].bounds.size.width * (0.5 - ratio)/2;
    CGFloat one = [UIScreen mainScreen].bounds.size.width * 0.25;
    CGFloat three =  [UIScreen mainScreen].bounds.size.width * 0.75;

    
    CGRect fnoti = lbnoti.frame;
    fnoti.origin.y = gap;
    lbnoti.frame = fnoti;
    
    CGRect fadd =  _btnMeOn.frame;
    fadd.size.width = w;
    fadd.size.height = h;
    fadd.origin.y = lbnoti.frame.origin.y + lbnoti.frame.size.height + gap;
    _btnMeOn.frame = fadd;
    
    
    CGRect finvite = _btnMeOff.frame;
    finvite.size.width = w;
    finvite.size.height = h;
    finvite.origin.y = lbnoti.frame.origin.y + lbnoti.frame.size.height + gap;
    _btnMeOff.frame = finvite;
    
    
    CGPoint padd = _btnMeOn.center;
    padd.x = one;
    _btnMeOn.center = padd;
    
    
    CGPoint pin = _btnMeOff.center;
    pin.x = three;
    _btnMeOff.center = pin;
    
    _btnMeOn.layer.cornerRadius = w/2;
    _btnMeOn.layer.masksToBounds = YES;
    _btnMeOn.layer.borderWidth = 2;
    _btnMeOn.layer.borderColor = [UIColor whiteColor].CGColor;
    
    _btnMeOff.layer.cornerRadius = w/2;
    _btnMeOff.layer.masksToBounds = YES;
    _btnMeOff.layer.borderWidth = 2;
    _btnMeOff.layer.borderColor = [UIColor whiteColor].CGColor;
    
    _btnMeOn.selected = YES;
    _btnMeOff.selected = !_btnMeOn.selected;

    [vwNoti addSubview:lbnoti];
    [vwNoti addSubview:_btnMeOn];
    [vwNoti addSubview:_btnMeOff];
    CGRect fvwn = vwPrivacy.frame;
    fvwn.size.height = fadd.origin.y + fadd.size.height + gap * 2;
    vwNoti.frame = fvwn;

    
  
    CGRect fprivacy = lbprivacy.frame;
    fprivacy.origin.y = gap;
    lbprivacy.frame = fprivacy;
    
    CGRect fpon =  _btnPublickOn.frame;
    fpon.size.width = w;
    fpon.size.height = h;
    fpon.origin.y = lbprivacy.frame.origin.y + lbprivacy.frame.size.height + gap;
    _btnPublickOn.frame = fpon;
    
    
    CGRect fpoff = _btnPublicOff.frame;
    fpoff.size.width = w;
    fpoff.size.height = h;
    fpoff.origin.y = lbprivacy.frame.origin.y + lbprivacy.frame.size.height + gap;
    _btnPublicOff.frame = fpoff;
    
    
    CGPoint ppon = _btnPublickOn.center;
    ppon.x = one;
    _btnPublickOn.center = ppon;
    
    
    CGPoint ppoff = _btnPublicOff.center;
    ppoff.x = three;
    _btnPublicOff.center = ppoff;
    
    _btnPublickOn.layer.cornerRadius = w/2;
    _btnPublickOn.layer.masksToBounds = YES;
    _btnPublickOn.layer.borderWidth = 2;
    _btnPublickOn.layer.borderColor = [UIColor whiteColor].CGColor;
    
    _btnPublicOff.layer.cornerRadius = w/2;
    _btnPublicOff.layer.masksToBounds = YES;
    _btnPublicOff.layer.borderWidth = 2;
    _btnPublicOff.layer.borderColor = [UIColor whiteColor].CGColor;

    _btnPublickOn.selected = YES;
    _btnPublicOff.selected = !_btnPublickOn.selected;
    
    
    
    CGRect fstyle = lbstyletab.frame;
    fstyle.origin.y = _btnPublicOff.frame.origin.y + _btnPublicOff.frame.size.height + gap * 2;
    lbstyletab.frame = fstyle;
    
    CGRect fson =  _btnStyleOn.frame;
    fson.size.width = w;
    fson.size.height = h;
    fson.origin.y = lbstyletab.frame.origin.y + lbstyletab.frame.size.height + gap;
    _btnStyleOn.frame = fson;
    
    
    CGRect fsoff = _btnStyleOff.frame;
    fsoff.size.width = w;
    fsoff.size.height = h;
    fsoff.origin.y = lbstyletab.frame.origin.y + lbstyletab.frame.size.height + gap;
    _btnStyleOff.frame = fsoff;
    
    
    CGPoint pson = _btnStyleOn.center;
    pson.x = one;
    _btnStyleOn.center = pson;
    
    
    CGPoint psoff = _btnStyleOff.center;
    psoff.x = three;
    _btnStyleOff.center = psoff;
    
    _btnStyleOn.layer.cornerRadius = w/2;
    _btnStyleOn.layer.masksToBounds = YES;
    _btnStyleOn.layer.borderWidth = 2;
    _btnStyleOn.layer.borderColor = [UIColor whiteColor].CGColor;
    
    _btnStyleOff.layer.cornerRadius = w/2;
    _btnStyleOff.layer.masksToBounds = YES;
    _btnStyleOff.layer.borderWidth = 2;
    _btnStyleOff.layer.borderColor = [UIColor whiteColor].CGColor;
    
    _btnStyleOn.selected = YES;
    _btnStyleOff.selected = !_btnMeOn.selected;
    

    [vwPrivacy addSubview:lbprivacy];
    [vwPrivacy addSubview:_btnPublickOn];
    [vwPrivacy addSubview:_btnPublicOff];
    
    [vwPrivacy addSubview:lbstyletab];
    [vwPrivacy addSubview:_btnStyleOn];
    [vwPrivacy addSubview:_btnStyleOff];
    
    CGRect fvwp = vwPrivacy.frame;
    fvwp.size.height = fsoff.origin.y + fsoff.size.height + gap * 2;
    vwPrivacy.frame = fvwp;
    
    CGFloat szheight ;
    if([_type isEqualToString:@"notification"]){
        vwNoti.hidden = NO;
        vwPrivacy.hidden= YES;
        szheight = vwNoti.frame.size.height;
    }else{
        vwNoti.hidden = YES;
        vwPrivacy.hidden = NO;
        szheight = vwPrivacy.frame.size.height;
    }
    
    scrollview.contentSize = CGSizeMake(scrollview.frame.size.width, szheight);
}

-(void)RemoveAllSubViews:(UIView *)sender{
    NSArray *viewsToRemove = [sender subviews];
    for (UIView *v in viewsToRemove) {
        [v removeFromSuperview];
    }
}


- (void)getNotificationsSettings
{
    NSMutableDictionary *params = [[NSMutableDictionary alloc] initWithCapacity:0];
    NSString * _token = [Global sharedGlobal].fbToken;
    NSString * _fb_id = [Global sharedGlobal].fbid;
    [params setObject:_token forKey:@"_token"];
    [params setObject:_fb_id forKey:@"user_id"];
    
    NSDictionary * result = [UtilComm getNotificationSettings:params];
    if ( result != nil )
    {
        if ( [[result objectForKey:@"code"] intValue] == 1 )
        {
            scrollview.hidden = NO;
            NSDictionary *data = [result objectForKey:@"data"];
            if ( data != nil )
            {
                int nFriend = [[data objectForKey:@"public"] intValue];
                int nMe = [[data objectForKey:@"friendnotification"] intValue];
                int nStyle = [[data objectForKey:@"styletab"] intValue];
                
                if ( nFriend == 1 )
                    _btnPublickOn.selected = YES;
                else
                    _btnPublickOn.selected = NO;
                _btnPublicOff.selected = !_btnPublickOn.selected;
                
                if ( nMe == 1 )
                    _btnMeOn.selected = YES;
                else
                    _btnMeOn.selected = NO;
                _btnMeOff.selected = !_btnMeOn.selected;
                
                if ( nStyle == 1 )
                    _btnStyleOn.selected = YES;
                else
                    _btnStyleOn.selected = NO;
                _btnStyleOff.selected = !_btnStyleOn.selected;
                
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

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)selectBtns
{
    if ( _btnPublickOn.selected )
    {
        _btnPublickOn.backgroundColor = [UIColor whiteColor];
        [_btnPublickOn setTitleColor:mainGreenColor forState:UIControlStateNormal];
    }
    else
    {
        _btnPublickOn.backgroundColor = [UIColor clearColor];
        [_btnPublickOn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    }
    
    if ( _btnPublicOff.selected )
    {
        _btnPublicOff.backgroundColor = [UIColor whiteColor];
        [_btnPublicOff setTitleColor:mainGreenColor forState:UIControlStateNormal];
    }
    else
    {
        _btnPublicOff.backgroundColor = [UIColor clearColor];
        [_btnPublicOff setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    }
    
    
    
    
    
    if ( _btnMeOn.selected )
    {
        _btnMeOn.backgroundColor = [UIColor whiteColor];
        [_btnMeOn setTitleColor:mainGreenColor forState:UIControlStateNormal];
    }
    else
    {
        _btnMeOn.backgroundColor = [UIColor clearColor];
        [_btnMeOn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    }
    
    if ( _btnMeOff.selected )
    {
        _btnMeOff.backgroundColor = [UIColor whiteColor];
        [_btnMeOff setTitleColor:mainGreenColor forState:UIControlStateNormal];
    }
    else
    {
        _btnMeOff.backgroundColor = [UIColor clearColor];
        [_btnMeOff setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    }
    
    
    
    
    if ( _btnStyleOn.selected )
    {
        _btnStyleOn.backgroundColor = [UIColor whiteColor];
        [_btnStyleOn setTitleColor:mainGreenColor forState:UIControlStateNormal];
    }
    else
    {
        _btnStyleOn.backgroundColor =[UIColor clearColor];
        [_btnStyleOn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    }
    
    if ( _btnStyleOff.selected )
    {
        _btnStyleOff.backgroundColor = [UIColor whiteColor];
        [_btnStyleOff setTitleColor:mainGreenColor forState:UIControlStateNormal];
    }
    else
    {
        _btnStyleOff.backgroundColor = [UIColor clearColor];
        [_btnStyleOff setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    }
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

- (IBAction)onClickedFriendOn:(id)sender
{
    _btnPublickOn.selected = !_btnPublickOn.selected;
    _btnPublicOff.selected = !_btnPublickOn.selected;
    
    [self selectBtns];
    [self showBusyDialog];
    [self performSelector:@selector(setNotificationChanges) withObject:nil afterDelay:0.5];

}

- (IBAction)onClickedFriendOff:(id)sender
{
    _btnPublicOff.selected = !_btnPublicOff.selected;
    _btnPublickOn.selected = !_btnPublicOff.selected;
    
    [self selectBtns];
    [self showBusyDialog];
    [self performSelector:@selector(setNotificationChanges) withObject:nil afterDelay:0.5];

}

- (IBAction)onClickedMeOn:(id)sender
{
    _btnMeOn.selected = !_btnMeOn.selected;
    _btnMeOff.selected = !_btnMeOn.selected;
    
    [self selectBtns];
    [self showBusyDialog];
    [self performSelector:@selector(setNotificationChanges) withObject:nil afterDelay:0.5];

}

- (IBAction)onClickedMeOff:(id)sender
{
    _btnMeOff.selected = !_btnMeOff.selected;
    _btnMeOn.selected = !_btnMeOff.selected;

    [self selectBtns];
    [self showBusyDialog];
    [self performSelector:@selector(setNotificationChanges) withObject:nil afterDelay:0.5];

}

- (IBAction)onClickedStyleOn:(id)sender
{
    _btnStyleOn.selected = !_btnStyleOn.selected;
    _btnStyleOff.selected = !_btnStyleOn.selected;
    
    [self selectBtns];
    [self showBusyDialog];
    [self performSelector:@selector(setNotificationChanges) withObject:nil afterDelay:0.5];
    
}


- (IBAction)onClickedStyleOff:(id)sender
{
    _btnStyleOff.selected = !_btnStyleOff.selected;
    _btnStyleOn.selected = !_btnStyleOff.selected;
    
    [self selectBtns];
    [self showBusyDialog];
    [self performSelector:@selector(setNotificationChanges) withObject:nil afterDelay:0.5];
}

- (IBAction)onClickedContinue:(id)sender
{
//    [self showBusyDialog];
//    [self performSelector:@selector(setNotificationChanges) withObject:nil afterDelay:0.5];
}

- (void)setNotificationChanges
{
    NSMutableDictionary *params = [[NSMutableDictionary alloc] initWithCapacity:0];
    NSString * _token = [Global sharedGlobal].fbToken;
    NSString * _fb_id = [Global sharedGlobal].fbid;
    [params setObject:_token forKey:@"_token"];
    [params setObject:_fb_id forKey:@"user_id"];
    if ( _btnPublickOn.selected )
        [params setObject:@"1" forKey:@"mynotification"];
    else
        [params setObject:@"1" forKey:@"mynotification"];
    
    if ( _btnPublickOn.selected )
        [params setObject:@"1" forKey:@"public"];
    else
        [params setObject:@"0" forKey:@"public"];

    
    if ( _btnMeOn.selected )
        [params setObject:@"1" forKey:@"friendnotification"];
    else
        [params setObject:@"0" forKey:@"friendnotification"];
    
    if ( _btnStyleOn.selected )
        [params setObject:@"1" forKey:@"styletab"];
    else
        [params setObject:@"0" forKey:@"styletab"];
    
    NSDictionary * result = [UtilComm setNotificationSettings:params];
    if ( result != nil )
    {
        if ( [[result objectForKey:@"code"] intValue] == 1 )
        {
        }
        [self.navigationController popViewControllerAnimated:YES];
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

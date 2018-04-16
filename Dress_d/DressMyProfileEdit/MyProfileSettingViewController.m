//
//  MyProfileSettingViewController.m
//  Dress_d
//
//  Created by MacAdmin on 9/14/17.
//  Copyright © 2017 dev. All rights reserved.
//

#import "MyProfileSettingViewController.h"
#import "MyProfileEditViewController.h"
#import "DressSearchViewController.h"
#import "GolfMainViewController.h"
@interface MyProfileSettingViewController ()
{
    NSMutableDictionary * _dicPostDetail;
    NSString * _mySaveFlag;
}
@end

@implementation MyProfileSettingViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    UISwipeGestureRecognizer *swipe = [[UISwipeGestureRecognizer alloc] initWithTarget:self action:@selector(goBack)];
    // And assuming the "Up" direction in your screenshot is no accident
    swipe.direction = UISwipeGestureRecognizerDirectionRight;
    [viewBack addGestureRecognizer:swipe];
    [self showBusyDialog];
    [self getData];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];

}

-(void)getData{
    NSMutableDictionary * params = [[NSMutableDictionary alloc]init];
    NSString * user_id = [Global sharedGlobal].fbid;
    NSString * _token = [Global sharedGlobal].fbToken;
    
    [params setObject:_post_id forKey:@"post_id"];
    [params setObject:_token forKey:@"_token"];
    [params setObject:user_id forKey:@"user_id"];
    NSDictionary * result = [UtilComm getpostdetail:params];
    [self hideBusyDialog];
    if(result != nil){
        NSDecimalNumber *deccode = [result objectForKey:@"code"];
        NSString * code = [NSString stringWithFormat:@"%@", deccode];
        //NSString * data = [result objectForKey:@"data"];
        if([code isEqualToString:@"1"]){
            
            _dicPostDetail = [result objectForKey:@"data"];

            _mySaveFlag   = [NSString stringWithFormat:@"%@",[result objectForKey:@"mysaveflg"]];
            _imgUrl = [_dicPostDetail objectForKey:@"photo"];
            _subject = [_dicPostDetail objectForKey:@"subject"];
            if(!(_subject != (id)[NSNull null] && _subject.length != 0))
                _subject = @"";

            [self initView];
        }else{
            [self.navigationController popViewControllerAnimated:YES];
        }
    }

}

-(void)viewDidLayoutSubviews{
//    [self initView];
}
-(void)initView{
    
    CGFloat ratio = 0.4;
    CGFloat w = [UIScreen mainScreen].bounds.size.width * ratio;
    CGFloat h = [UIScreen mainScreen].bounds.size.width * ratio;
    CGFloat gap = [UIScreen mainScreen].bounds.size.width * (0.5 - ratio)/2;
 
    CGFloat one = [UIScreen mainScreen].bounds.size.width * 0.5;


    
    CGRect finvite = btnDelPhoto.frame;
    finvite.size.width = w;
    finvite.size.height = h;
    btnDelPhoto.frame = finvite;
    
    CGPoint pin = btnDelPhoto.center;
    pin.x = one;
    pin.y = [UIScreen mainScreen].bounds.size.height/2 -30;
    btnDelPhoto.center = pin;
    finvite = btnDelPhoto.frame;


    CGRect fadd =  btnEdCap.frame;
    fadd.size.width = w;
    fadd.size.height = h;
    fadd.origin.y = finvite.origin.y - fadd.size.height - gap;
    btnEdCap.frame = fadd;
    
    
    CGRect fsave = btnSave.frame;
    fsave.size.width = w;
    fsave.size.height = h;
    fsave.origin.y = finvite.origin.y + finvite.size.height + gap;
    btnSave.frame = fsave;
    
    
    CGPoint padd = btnEdCap.center;
    padd.x = one;
    btnEdCap.center = padd;
    
    
    
    CGPoint psave = btnSave.center;
    psave.x = one;
    btnSave.center = psave;
    
    if([_mySaveFlag isEqualToString:@"1"]){
        btnSave.hidden = YES;
    }
    
    btnEdCap.layer.cornerRadius = w/2;
    btnEdCap.layer.masksToBounds = YES;
    btnEdCap.layer.borderWidth = 2;
    btnEdCap.layer.borderColor = mainGreenColor.CGColor;
    
    btnDelPhoto.layer.cornerRadius = w/2;
    btnDelPhoto.layer.masksToBounds = YES;
    btnDelPhoto.layer.borderWidth = 2;
    btnDelPhoto.layer.borderColor = mainGreenColor.CGColor;
    
    btnSave.layer.cornerRadius = w/2;
    btnSave.layer.masksToBounds = YES;
    btnSave.layer.borderWidth = 2;
    btnSave.layer.borderColor = mainGreenColor.CGColor;
    
}
-(IBAction)onClickBack:(id)sender{
    [self.navigationController popViewControllerAnimated:YES];
}

-(IBAction)onClickSrh:(id)sender{
    DressSearchViewController * vc = [[DressSearchViewController alloc]initWithNibName:@"DressSearchViewController" bundle:nil];
    [self.navigationController pushViewController:vc animated:YES];
}

-(IBAction)onClickEdit:(id)sender{
    MyProfileEditViewController * vc = [[MyProfileEditViewController alloc]initWithNibName:@"MyProfileEditViewController" bundle:nil];
    vc.post_id = _post_id;
    vc.imgUrl = _imgUrl;
    vc.subject = _subject;
    [self.navigationController pushViewController:vc animated:YES];
}

-(IBAction)onClickDel:(id)sender{
    UIAlertController * alert = [UIAlertController
                                 alertControllerWithTitle:@"DELETE"
                                 message:@"Are you sure?"
                                 preferredStyle:UIAlertControllerStyleAlert];
    
    UIAlertAction* okButton = [UIAlertAction
                               actionWithTitle:@"Yes"
                               style:UIAlertActionStyleDefault
                               handler:^(UIAlertAction * action) {
                                   //Handle no, thanks button
                                   [self showBusyDialog];
                                   [self performSelector:@selector(deletePost) withObject:nil afterDelay:0.2];
                                   [self deletePost];
                               }];
    UIAlertAction* noButton = [UIAlertAction
                               actionWithTitle:@"No"
                               style:UIAlertActionStyleDefault
                               handler:^(UIAlertAction * action) {
                                   //Handle no, thanks button
                               }];
    [alert addAction:okButton];
    [alert addAction:noButton];
    [self presentViewController:alert animated:YES completion:nil];

}

-(void)deletePost{
    NSMutableDictionary * params = [[NSMutableDictionary alloc]init];
    NSString * user_id = [Global sharedGlobal].fbid;
    NSString * _token = [Global sharedGlobal].fbToken;
    [params setObject:_post_id forKey:@"post_id"];
    [params setObject:user_id forKey:@"user_id"];
    [params setObject:_token forKey:@"_token"];
    
    NSDictionary * result = [UtilComm deletepost:params];
    if(result != nil){
        NSDecimalNumber * deccode = [result objectForKey:@"code"];
        NSString * code = [NSString stringWithFormat:@"%@", deccode];
        //NSString * data = [result objectForKey:@"data"];
        if([code isEqualToString:@"1"]){
            [[GolfMainViewController sharedInstance] changTab:1];
        }else{
            [self hideBusyDialog];
        }
        
    }else{
        [self hideBusyDialog];
        [APPDELEGATE showToastMessage:CONNECT_ERROR];
    }
}

-(void)goBack{
    [self hideBusyDialog];
    [self.navigationController popViewControllerAnimated:YES];

}

-(IBAction)onClickSave:(id)sender{
    if(![_mySaveFlag isEqualToString:@"1"]){
        [self showBusyDialog];
        [self performSelector:@selector(savePhoto) withObject:nil afterDelay:0.5];
    }

}

-(void)savePhoto{
    NSMutableDictionary * params = [[NSMutableDictionary alloc]init];
    NSString * user_id = [Global sharedGlobal].fbid;
    NSString * post_id = _post_id;
    NSString * _token = [Global sharedGlobal].fbToken;
    [params setObject:user_id forKey:@"user_id"];
    [params setObject:post_id forKey:@"post_id"];
    [params setObject:_token forKey:@"_token"];
    
    NSDictionary * result = [UtilComm savepost:params];
    if(result != nil){
        NSDecimalNumber * deccode = [result objectForKey:@"code"];
        NSString * code = [NSString stringWithFormat:@"%@", deccode];
        NSString * data = [result objectForKey:@"data"];
        if([code isEqualToString:@"1"]){
            [self goBack];
        }else{
            [APPDELEGATE showToastMessage:data];
        }
    }else{
        [APPDELEGATE showToastMessage:@"Connection Error!"];
    }
    
    [self hideBusyDialog];
    
}
@end

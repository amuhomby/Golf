//
//  AddStyleViewController.m
//  Dress_d
//
//  Created by MacAdmin on 12/7/17.
//  Copyright © 2017 MacAdmin. All rights reserved.
//

#import "AddStyleViewController.h"
#import "dressAFGateController.h"
#import "StyleTableViewCell.h"
#import "ExpireHourViewController.h"
#import "GolfMainViewController.h"

@interface AddStyleViewController ()

@end

@implementation AddStyleViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    
    UISwipeGestureRecognizer *swipe = [[UISwipeGestureRecognizer alloc] initWithTarget:self action:@selector(goback)];
    // And assuming the "Up" direction in your screenshot is no accident
    swipe.direction = UISwipeGestureRecognizerDirectionRight;
    [scrollview addGestureRecognizer:swipe];
    
    
    
    UISwipeGestureRecognizer *swipeLeft = [[UISwipeGestureRecognizer alloc] initWithTarget:self action:@selector(onClickConti)];
    // And assuming the "Up" direction in your screenshot is no accident
    swipeLeft.direction = UISwipeGestureRecognizerDirectionLeft;
    [scrollview addGestureRecognizer:swipeLeft];
    

    [self getStyleList];
}


-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];

    [[GolfMainViewController sharedInstance] hideTab:YES];
    [self showStyle];
    if([[Global sharedGlobal].cameraBack isEqualToString:@"yes"]){
        [[GolfMainViewController sharedInstance] hideTab:NO];
        NSInteger index = 1;
        [[GolfMainViewController sharedInstance]changTab:index];
        [self.navigationController popViewControllerAnimated:YES];
    }
    
    [btnCancel addTarget:self action:@selector(goback) forControlEvents:UIControlEventTouchUpInside];
    [btnConti addTarget:self action:@selector(onClickConti) forControlEvents:UIControlEventTouchUpInside];
}


-(void)viewWillDisappear:(BOOL)animated{
    [[GolfMainViewController sharedInstance] hideTab:NO];
}


-(void)viewDidLayoutSubviews{
    btnConti.layer.cornerRadius = btnConti.frame.size.height/2;
    btnConti.layer.masksToBounds = YES;
    
}
-(void)getStyleList{
    arrStyle = [[NSMutableArray alloc]init];
    arruserStyle = [[NSMutableArray alloc]init];
    
    NSDictionary * params = [[NSMutableDictionary alloc]init];
    NSString * _token = [Global sharedGlobal].fbToken;
    NSString * userid = [Global sharedGlobal].fbid;
    [params setValue:userid forKey:@"user_id"];
    [params setValue:_token forKey:@"_token"];
    NSDictionary * result = [UtilComm getStyle:params];
    if(result != nil){
        NSDecimalNumber * deccode = [result objectForKey:@"code"];
        NSString * code = [NSString stringWithFormat:@"%@", deccode];
        //NSString * data = [result objectForKey:@"data"];
        if([code isEqualToString:@"1"]){
            arrStyle = [result objectForKey:@"data"];
//            arruserStyle = [result objectForKey:@"my_style"];
            
            [self showStyle];
            //            [tbStyle reloadData];
        }else{
            UIAlertController * alert = [UIAlertController
                                         alertControllerWithTitle:@"Error"
                                         message:@"Server Error"
                                         preferredStyle:UIAlertControllerStyleAlert];
            
            UIAlertAction* noButton = [UIAlertAction
                                       actionWithTitle:@"Retry"
                                       style:UIAlertActionStyleDefault
                                       handler:^(UIAlertAction * action) {
                                           //Handle ok button
                                           [self getStyleList];
                                           
                                       }];
            UIAlertAction* okButton = [UIAlertAction
                                       actionWithTitle:@"Cancel"
                                       style:UIAlertActionStyleDefault
                                       handler:^(UIAlertAction * action) {
                                           //Handle ok button
                                       }];
            
            [alert addAction:noButton];
            [alert addAction:okButton];
            [self presentViewController:alert animated:YES completion:nil];
            
        }
    }
    
    
}
-(void)showStyle{
    CGRect fvwscroll = scrollview.frame;
    fvwscroll.origin.y = 0;
    scrollview.frame = fvwscroll;
    
    CGRect fvwbutton = vwButton.frame;
    fvwbutton.origin.y = 0;
    vwButton.frame = fvwbutton;
    
    [self RemoveAllSubViews:viewStyle];
    CGFloat ratio = 0.4;
    CGFloat w = [UIScreen mainScreen].bounds.size.width * ratio;
    CGFloat h = [UIScreen mainScreen].bounds.size.width * ratio;
    CGFloat gap = [UIScreen mainScreen].bounds.size.width * (0.5 - ratio)/2;
    CGFloat one = [UIScreen mainScreen].bounds.size.width * 0.25;
    CGFloat three =  [UIScreen mainScreen].bounds.size.width * 0.75;
    
    for(int i=0; i < [arrStyle count]; i++){
        NSMutableDictionary * rowDic = [arrStyle objectAtIndex:i];
        NSString * row = [rowDic objectForKey:@"name"];
        
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
        btn.tag = i;
        [btn addTarget:self action:@selector(addStyle:) forControlEvents:UIControlEventTouchUpInside];
        btn.titleLabel.font = [UIFont fontWithName:@"Georgia" size:18];
        [btn setTitle:row forState:UIControlStateNormal];
        [btn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        [viewStyle addSubview:btn];
        btn.selected = NO;
        
        if([arruserStyle containsObject:rowDic])
        {
            [btn setBackgroundColor:[UIColor whiteColor]];
            [btn setTitleColor:mainGreenColor forState:UIControlStateNormal];
            btn.selected = YES;
        }
    }
    
    CGFloat height =(floorf(([arrStyle count]+ 1) / 2)) * (gap + h) + 20 ;
 
    
    
    CGRect fvstyle = viewStyle.frame;
    fvstyle.origin.y = fvwbutton.origin.y + fvwbutton.size.height;
    fvstyle.size.height = height + 40;
    fvstyle.size.width = [UIScreen mainScreen].bounds.size.width;
    viewStyle.frame = fvstyle;
    CGFloat scrollH = fvstyle.size.height - 10;
    scrollview.contentSize = CGSizeMake(scrollview.frame.size.width, scrollH);
}

-(void)RemoveAllSubViews:(UIView *)sender{
    NSArray *viewsToRemove = [sender subviews];
    for (UIView *v in viewsToRemove) {
        [v removeFromSuperview];
    }
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)addStyle:(UIButton *)sender {
    
    [self performSelector:@selector(synch:) withObject:sender afterDelay:0.2];
}

-(void)synch:(UIButton *)sender{
    if(sender.selected){
        NSInteger index = sender.tag;
        NSMutableDictionary * dicStyle = [arrStyle objectAtIndex:index];
        [arruserStyle removeObject:dicStyle];

        
    }else{

        NSInteger index = sender.tag;
        NSMutableDictionary * dicStyle = [arrStyle objectAtIndex:index];
        [arruserStyle addObject:dicStyle];

    }
    [self showStyle];
}

-(void)onClickConti{
    NSString * style_ids = @"";
    
    for(int x=0; x< [arruserStyle count]; x++){
        NSMutableDictionary * styleItem = [arruserStyle objectAtIndex:x];
        NSString * style = [styleItem objectForKey:@"id"];
        if(x==0){
            style_ids = style;
        }else{
            style_ids = [NSString stringWithFormat:@"%@,%@", style_ids, style];
        }
    }

    ExpireHourViewController * vc = [[ExpireHourViewController alloc]initWithNibName:@"ExpireHourViewController" bundle:nil];
    vc.subject = _subject;
    vc.strBrand = _strBrand;
    vc.imgData1 = _imgData1;
    vc.imgData2 = _imgData2;
    vc.imgData3 = _imgData3;
    vc.imgData4 = _imgData4;
    vc.style_ids = style_ids;
    [self.navigationController pushViewController:vc animated:YES];
}

-(void)goback{
    [Global sharedGlobal].cameraBack = @"yes";
    [[Global sharedGlobal] SaveParam];

    [self.navigationController popViewControllerAnimated:YES];
}
@end

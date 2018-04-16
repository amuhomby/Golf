//
//  ExpireHourViewController.m
//  Dress_d
//
//  Created by MacAdmin on 9/20/17.
//  Copyright © 2017 dev. All rights reserved.
//

#import "ExpireHourViewController.h"
#import "GolfMainViewController.h"
#import "DressSearchViewController.h"
#import "AddViewController.h"

@interface ExpireHourViewController ()<UIPickerViewDelegate>
{
    NSArray *_pickerData;
    NSString * expHour;
    NSString * isExpire;

}
@end

@implementation ExpireHourViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    UISwipeGestureRecognizer *swipe = [[UISwipeGestureRecognizer alloc] initWithTarget:self action:@selector(goBack)];
    // And assuming the "Up" direction in your screenshot is no accident
    swipe.direction = UISwipeGestureRecognizerDirectionRight;
    [viewBack addGestureRecognizer:swipe];

     //    [tbLike addGestureRecognizer:swipe];
    _pickerData = @[@"0.5", @"1", @"1.5", @"2", @"2.5", @"3",@"3.5", @"4", @"4.5", @"5", @"5.5", @"6",@"7.5", @"8", @"8.5", @"9", @"9.5", @"10",@"10.5", @"11", @"11.5", @"12"];
    expHour = @"0";
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];

    [[GolfMainViewController sharedInstance] hideTab:YES];
    isExpire = @"no";
}
-(void)viewWillDisappear:(BOOL)animated{
    [[GolfMainViewController sharedInstance] hideTab:NO];
}
- (void)viewDidLayoutSubviews
{
    [super viewDidLayoutSubviews];
    
//    viewMain.layer.cornerRadius = 20;
//    viewMain.layer.masksToBounds = YES;
//    viewMain.layer.borderColor = [UIColor colorWithRed:240/255.0 green:240/255.0 blue:240/255.0 alpha:0.8].CGColor;
//    viewMain.layer.borderWidth = 1;
//    
//    int r = 20;
//    viewParent.layer.cornerRadius=r;
//    CGRect bounds2 = viewParent.bounds;
//    UIBezierPath *maskPath2 = [UIBezierPath bezierPathWithRoundedRect:bounds2
//                                                    byRoundingCorners:UIRectCornerTopLeft|UIRectCornerTopRight|UIRectCornerBottomRight|UIRectCornerBottomLeft
//                                                          cornerRadii:CGSizeMake(r, r)];
//    
//    CAShapeLayer *maskLayer2 = [CAShapeLayer layer];
//    maskLayer2.frame = bounds2;
//    maskLayer2.path = maskPath2.CGPath;
//    maskLayer2.shadowRadius = 2;
//    maskLayer2.shadowOpacity = 0.05;
//    
//    maskLayer2.shadowColor =[UIColor blackColor].CGColor;
//    maskLayer2.fillColor = [UIColor colorWithRed:252/256.0 green:252/256.0 blue:252/256.0 alpha:1].CGColor;
//    maskLayer2.shadowOffset = CGSizeMake(0, 4);
//    
//    [viewParent.layer insertSublayer:maskLayer2 atIndex:0];
    
    
    
    btnHours.layer.cornerRadius = 15;
    btnHours.layer.masksToBounds = YES;
    btnHours.layer.borderWidth = 2;
    btnHours.layer.borderColor = [UIColor whiteColor].CGColor;
    
    btnNoExpire.layer.cornerRadius = 15;
    btnNoExpire.layer.masksToBounds = YES;
    btnNoExpire.layer.borderWidth = 2;
    btnNoExpire.layer.borderColor = [UIColor whiteColor].CGColor;
    
    btnCon.layer.cornerRadius = btnCon.bounds.size.height/2;
    btnCon.layer.masksToBounds = YES;
    
    btnCancel.layer.cornerRadius = btnCancel.bounds.size.height/2;
    btnCancel.layer.masksToBounds = YES;
}

-(void)initView{
    
    viewMain.layer.cornerRadius =20;
    viewMain.layer.masksToBounds = YES;
   
//    viewMain.layer.borderColor = [UIColor colorWithRed:240/255.0 green:240/255.0 blue:240/255.0 alpha:0.8].CGColor;
//    viewMain.layer.borderWidth = 1;
    
    
//    int r = 20;
//    self.view.layer.cornerRadius=r;
//    CGRect bounds2 = self.view.bounds;
//    UIBezierPath *maskPath2 = [UIBezierPath bezierPathWithRoundedRect:bounds2
//                                                    byRoundingCorners:UIRectCornerTopLeft|UIRectCornerTopRight|UIRectCornerBottomRight|UIRectCornerBottomLeft
//                                                          cornerRadii:CGSizeMake(r, r)];
//    
//    CAShapeLayer *maskLayer2 = [CAShapeLayer layer];
//    maskLayer2.frame = bounds2;
//    maskLayer2.path = maskPath2.CGPath;
//    maskLayer2.shadowRadius = 2;
//    maskLayer2.shadowOpacity = 0.05;
//    
//    maskLayer2.shadowColor =[UIColor blackColor].CGColor;
//    maskLayer2.fillColor = [UIColor colorWithRed:252/256.0 green:252/256.0 blue:252/256.0 alpha:1].CGColor;
//    maskLayer2.shadowOffset = CGSizeMake(0, 4);
    
//    [self.view.layer insertSublayer:maskLayer2 atIndex:0];
    
    
    btnHours.layer.cornerRadius = 15;
    btnHours.layer.masksToBounds = YES;
    btnHours.layer.borderWidth = 2;
    btnHours.layer.borderColor = [UIColor whiteColor].CGColor;
    
    btnNoExpire.layer.cornerRadius = 15;
    btnNoExpire.layer.masksToBounds = YES;
    btnNoExpire.layer.borderWidth = 2;
    btnNoExpire.layer.borderColor = [UIColor whiteColor].CGColor;
    
    
    btnCon.layer.cornerRadius = 10;
    btnCon.layer.masksToBounds = YES;
    
    btnCancel.layer.cornerRadius = 10;
    btnCancel.layer.masksToBounds = YES;
}
// The number of columns of data
- (NSInteger)numberOfComponentsInPickerView:(UIPickerView *)pickerView
{
    return 1;
}

// The number of rows of data
- (NSInteger)pickerView:(UIPickerView *)pickerView numberOfRowsInComponent:(NSInteger)component
{
    return _pickerData.count;
}

// The data to return for the row and component (column) that's being passed in
- (NSString*)pickerView:(UIPickerView *)pickerView titleForRow:(NSInteger)row forComponent:(NSInteger)component
{
    NSString * val = [NSString stringWithFormat:@"%@ Hours", _pickerData[row]];
    return val;
}

- (void)pickerView:(UIPickerView *)pickerView didSelectRow:(NSInteger)row inComponent:(NSInteger)component
{
    // This method is triggered whenever the user makes a change to the picker selection.
    // The parameter named row and component represents what was selected.
    
    expHour = _pickerData[row];
    lbHours.text = [NSString stringWithFormat:@"%@ Hours", _pickerData[row]];
    
}

-(void)ShowPicker{
    CGRect frame = viewPick.frame;
    frame.origin.y = [UIScreen mainScreen].bounds.size.height - frame.size.height;
    [UIView animateWithDuration:1.0 animations:^{
        [viewPick setFrame:frame];
        viewPick.hidden = NO;
    }];
}

-(void)HidePicker{
    CGRect frame = viewPick.frame;
    frame.origin.y = [UIScreen mainScreen].bounds.size.height;
    [UIView animateWithDuration:1.0 animations:^{
        [viewPick setFrame:frame];
        //viewPick.hidden = YES;
    }];
}
-(IBAction)onClickDone:(id)sender{
    [self HidePicker];
}

-(IBAction)onClickBack:(id)sender{
//    [self dismissViewControllerAnimated:YES completion:nil];
    [self goBack];
}
-(void)goBack{
    [self.navigationController popViewControllerAnimated:YES];
    
}
-(IBAction)onClickSrh:(id)sender{
    DressSearchViewController * vc = [[DressSearchViewController alloc]initWithNibName:@"DressSearchViewController" bundle:nil];
    [self.navigationController pushViewController:vc animated:YES];
}

-(IBAction)onClickHour:(id)sender{
    if([isExpire isEqualToString:@"yes"]){
        lbHours.text = @"Time in Hours";
        [self HidePicker];
        return;
    }
    [self ShowPicker];
}
-(IBAction)onClickNoExpire:(id)sender{
    if([isExpire isEqualToString:@"no"]){
        lbHours.text = @"Time in Hours";
        [self HidePicker];
        isExpire = @"yes";
        expHour = @"0";
        [btnNoExpire setBackgroundColor:UIColor.whiteColor];
        [btnNoExpire setTitleColor:mainGreenColor forState:UIControlStateNormal];
        
    }else{
        isExpire = @"no";
        [btnNoExpire setBackgroundColor:[UIColor clearColor]];
        [btnNoExpire setTitleColor:UIColor.whiteColor forState:UIControlStateNormal];
    }
}

-(IBAction)onClickCon:(id)sender{
    [self showBusyDialog];
    [self performSelector:@selector(savepost) withObject:nil afterDelay:0.5];

 }


-(void)savepost{
    
    if ( _imgData1 == nil )
    {
        [self hideBusyDialog];
        return;
    }
    
    if([expHour isEqualToString:@"0"] && [isExpire isEqualToString:@"no"]){
        [self hideBusyDialog];
        [APPDELEGATE showToastMessage:@"Choose an expiry time"];
        return;
    }
    NSMutableDictionary * params = [[NSMutableDictionary alloc]init];
    NSString * user_id = [Global sharedGlobal].fbid;
    NSString * _token = [Global sharedGlobal].fbToken;
    NSString * subject = _subject;
    NSString * strBrand = _strBrand;
    NSString * style_ids = _style_ids;
    NSString * expiredhour = expHour;

    [params setObject:subject forKey:@"subject"];
    [params setObject:strBrand forKey:@"brand"];
    [params setObject:user_id forKey:@"user_id"];
    [params setObject:_token forKey:@"_token"];
    [params setObject:style_ids forKey:@"style"];
    [params setObject:expiredhour forKey:@"exp"];
    [params setObject:isExpire forKey:@"noexpire"];
    
    NSDictionary * retCode = [UtilComm addPost: @"photo1.jpg" :_imgData1 :@"photo2.jpg" :_imgData2: @"photo3.jpg" :_imgData3: @"photo4.jpg" :_imgData4 :params];
    
    [self hideBusyDialog];
    
    if ( retCode != nil )
    {
        NSDecimalNumber * deccode = [retCode objectForKey:@"code"];
        NSString * code = [NSString stringWithFormat:@"%@", deccode];
        if([code isEqualToString:@"1"]){
            [self.navigationController popViewControllerAnimated:NO];
            NSString * myfbid = [Global sharedGlobal].fbid;
            [Global sharedGlobal].whoProfile = myfbid;
            
            [Global sharedGlobal].cameraBack = @"yes";
            [[Global sharedGlobal] SaveParam];
            [self.navigationController popViewControllerAnimated:NO];
            [[GolfMainViewController sharedInstance]changTab:1];
        }
        else{
            NSString * data = [retCode objectForKey:@"data"];
            [APPDELEGATE showToastMessage:data];
        }
    }else{
        [self.navigationController popViewControllerAnimated:NO];
        NSString * myfbid = [Global sharedGlobal].fbid;
        [Global sharedGlobal].whoProfile = myfbid;
        [[Global sharedGlobal] SaveParam];
        [[GolfMainViewController sharedInstance]changTab:1];
       
    }

}

-(IBAction)onClickCancel:(id)sender{
    [Global sharedGlobal].cameraBack = @"yes";
    [[Global sharedGlobal] SaveParam];
    [self.navigationController popViewControllerAnimated:NO];
}
@end

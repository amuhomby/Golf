//
//  BioViewController.m
//  Dress_d
//
//  Created by MacAdmin on 10/9/17.
//  Copyright © 2017 MacAdmin. All rights reserved.
//

#import "BioViewController.h"
#import "DressSearchViewController.h"
#import "GolfMainViewController.h"


@interface BioViewController ()<UITextFieldDelegate>
{
    BOOL _isObserving;
    
    float       _keyboardHeight;
    UIView      *_curEditingField;
    int         _ScrolHeight;

}
@end

@implementation BioViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    UITapGestureRecognizer *tapRecog = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(dismissKeyboard)];
    tapRecog.cancelsTouchesInView = NO;
    [scrollview addGestureRecognizer:tapRecog];
    
    UISwipeGestureRecognizer *swipe = [[UISwipeGestureRecognizer alloc] initWithTarget:self action:@selector(goBack)];
    // And assuming the "Up" direction in your screenshot is no accident
    swipe.direction = UISwipeGestureRecognizerDirectionRight;
    [scrollview addGestureRecognizer:swipe];

    
    _ScrolHeight = scrollview.bounds.size.height;
    self.navigationController.navigationBarHidden = YES;
    [self initView];

}

-(BOOL)textFieldShouldBeginEditing:(UITextField *)textField{
    _curEditingField = textField;
    return YES;
}

-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];

    [[GolfMainViewController sharedInstance] hideTab:YES];

    if (!_isObserving) {
        NSNotificationCenter *noticication = [NSNotificationCenter defaultCenter];
        [noticication addObserver:self selector:@selector(keyboardWillShow:) name:UIKeyboardWillShowNotification object:nil];
        [noticication addObserver:self selector:@selector(keyboardWillHide:) name:UIKeyboardWillHideNotification object:nil];
        
        _isObserving = YES;
    }
    [self showBusyDialog];
    [self performSelector:@selector(getbio) withObject:nil afterDelay:0.3];
}
- (void)viewWillDisappear:(BOOL)animated
{
    if (_isObserving) {
        NSNotificationCenter *noticication = [NSNotificationCenter defaultCenter];
        [noticication removeObserver:self name:UIKeyboardWillShowNotification object:nil];
        [noticication removeObserver:self name:UIKeyboardWillHideNotification object:nil];
        
        _isObserving = NO;
    }
    
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
        contentRect.size.height += _keyboardHeight -40;
        
        [scrollview scrollRectToVisible:contentRect animated:YES];
        
        
        
    } completion:NULL];
}

-(void) keyboardWillHide:(NSNotification *)notification{
    
    NSTimeInterval duration = [[[notification userInfo] objectForKey:UIKeyboardAnimationDurationUserInfoKey] doubleValue];
    
    [UIView animateWithDuration:duration animations:^{
        
        CGSize size = scrollview.frame.size;
        size.height = _ScrolHeight;
        scrollview.contentSize = size;
        scrollview.contentOffset = CGPointMake(0, 0);
        
        _curEditingField = nil;
        
        
    } completion:NULL];
}
- (void)dismissKeyboard
{
    [_curEditingField resignFirstResponder];
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (BOOL)textView:(UITextView *)textView shouldChangeTextInRange:(NSRange)range replacementText:(NSString *)text
{
    return textView.text.length + (text.length - range.length) <= 140;
}

-(BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string{
    return textField.text.length + (string.length - range.length) <= 140;
}

-(void)getbio{
    NSString* userid = [Global sharedGlobal].fbid;
    NSString * _token = [Global sharedGlobal].fbToken;
    NSMutableDictionary * params = [[NSMutableDictionary alloc]init];
    [params setObject:userid forKey:@"user_id"];
    [params setObject:_token forKey:@"_token"];
    
    NSDictionary * result = [UtilComm getbio:params];
    [self hideBusyDialog];
    if(result != nil){
        NSDecimalNumber * deccode = [result objectForKey:@"code"];
        NSString * code = [NSString stringWithFormat:@"%@",deccode];
        if([code isEqualToString:@"1"]){
            NSMutableDictionary * data = [result objectForKey:@"data"];
            NSString * bio = [data objectForKey:@"bio_content"];
            
            
            NSData * commentData = [[NSData alloc] initWithBase64EncodedString:bio options:0];
            NSString * comment = [[NSString alloc]initWithData:commentData encoding:NSUTF8StringEncoding];

            tfBio.text = comment;
        }
    }
}
-(void)initView{
    btnSave.layer.cornerRadius = btnSave.frame.size.height/2;
    btnSave.layer.masksToBounds = YES;
    
//    viewContent.layer.cornerRadius = 20;
//    viewContent.layer.masksToBounds = YES;
//    viewContent.layer.borderColor = [UIColor colorWithRed:240/255.0 green:240/255.0 blue:240/255.0 alpha:0.8].CGColor;
//    viewContent.layer.borderWidth = 1;
//    
//    int r = 20;
//    viewMain.layer.cornerRadius=r;
//    CGRect bounds2 = viewMain.bounds;
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
//    [viewMain.layer insertSublayer:maskLayer2 atIndex:0];
    
    vwBio.layer.borderWidth = 2;
    vwBio.layer.borderColor = [UIColor whiteColor].CGColor;
    vwBio.layer.cornerRadius = 5;
    vwBio.layer.masksToBounds = YES;
    
}
-(IBAction)onClickSave:(id)sender{
    [self showBusyDialog];
    [self performSelector:@selector(saveBio) withObject:nil afterDelay:0.3];
}

-(void)saveBio{
    NSString* userid = [Global sharedGlobal].fbid;
    NSString * _token = [Global sharedGlobal].fbToken;
    NSString * bio = tfBio.text;
 
    
    NSData *commentdata = [bio dataUsingEncoding:NSUTF8StringEncoding];
    NSString *base64Encoded = [commentdata base64EncodedStringWithOptions:0];

    NSMutableDictionary * params = [[NSMutableDictionary alloc]init];
    [params setObject:userid forKey:@"user_id"];
    [params setObject:_token forKey:@"_token"];
    [params setObject:base64Encoded forKey:@"bio_content"];
    
    NSDictionary * result = [UtilComm addbio:params];
    [self hideBusyDialog];
    if(result != nil){
        NSDecimalNumber * deccode = [result objectForKey:@"code"];
        NSString * code = [NSString stringWithFormat:@"%@",deccode];
        if([code isEqualToString:@"1"]){
            [self.navigationController popViewControllerAnimated:YES];
        }
    }
}

-(IBAction)onClickBack:(id)sender{
    [self goBack];
}

-(void)goBack{
    [self.navigationController popViewControllerAnimated:YES];
}
-(IBAction)onClickSrh:(id)sender{
    DressSearchViewController * vc = [[DressSearchViewController alloc]initWithNibName:@"" bundle:nil];
    [self.navigationController pushViewController:vc animated:YES];
}
@end

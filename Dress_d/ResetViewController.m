//
//  ResetViewController.m
//  Dress_d
//
//  Created by MacAdmin on 11/27/17.
//  Copyright © 2017 MacAdmin. All rights reserved.
//

#import "ResetViewController.h"

@interface ResetViewController ()
{
    BOOL _isObserving;
    float _oriStoryY;
    
    float       _keyboardHeight;
    UIView      *_curEditingField;
    int         _ScrolHeight;
    
}
@end

@implementation ResetViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self initView];
    _ScrolHeight = scrollview.bounds.size.height;
    scrollview.contentSize = CGSizeMake(scrollview.frame.size.width, _ScrolHeight);
    UITapGestureRecognizer *tapRecog = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(dismissKeyboard)];
    tapRecog.cancelsTouchesInView = NO;
    [vwBack addGestureRecognizer:tapRecog];
    
    UISwipeGestureRecognizer *swipe = [[UISwipeGestureRecognizer alloc] initWithTarget:self action:@selector(goBack)];
    swipe.direction = UISwipeGestureRecognizerDirectionRight;
    [vwBack addGestureRecognizer:swipe];

    // Do any additional setup after loading the view from its nib.
}

-(void)goBack{
    [self.navigationController popViewControllerAnimated:YES];
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void)initView{
    vwEmail.layer.cornerRadius = 10;
    vwEmail.layer.borderWidth = 2;
    vwEmail.layer.borderColor = [UIColor whiteColor].CGColor;
    vwEmail.layer.masksToBounds = YES;
    
    vwNewPwd.layer.cornerRadius = 10;
    vwNewPwd.layer.borderWidth = 2;
    vwNewPwd.layer.borderColor = [UIColor whiteColor].CGColor;
    vwNewPwd.layer.masksToBounds = YES;
    
    vwRePwd.layer.cornerRadius = 10;
    vwRePwd.layer.borderWidth = 2;
    vwRePwd.layer.borderColor = [UIColor whiteColor].CGColor;
    vwRePwd.layer.masksToBounds = YES;
    
    btnReset.layer.cornerRadius = btnReset.frame.size.height/2;
    btnReset.layer.masksToBounds = YES;

    btnCode.layer.cornerRadius = btnCode.frame.size.height/2;
    btnCode.layer.masksToBounds = YES;
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
    if(validEmail){
        return YES;
    }else{
        [APPDELEGATE showToastMessage:@"Invalid email"];
        return NO;
    }
}

-(IBAction)onClickSendCode:(id)sender{
    if([self validateEmailWithString]){
        [self showBusyDialog];
        [self performSelector:@selector(sendcode) withObject:nil afterDelay:0.1];
    }
}

-(void)sendcode{
    NSString * email = tfEmail.text;
    NSMutableDictionary * params = [[NSMutableDictionary alloc]init];
    [params setObject:email forKey:@"email"];
    NSDictionary * result = [UtilComm sendcode:params];
    [self hideBusyDialog];
    if(result != nil){
        NSDecimalNumber* deccode = [result objectForKey:@"code"];
        NSString * code = [NSString stringWithFormat:@"%@", deccode];
        if([code isEqualToString:@"1"]){
            tfEmail.hidden = YES;
            tfCode.hidden = NO;
            
            vwNewPwd.hidden = NO;
            vwRePwd.hidden = NO;
            
            btnReset.hidden = YES;
            btnCode.hidden = NO;
        }
    }
}

-(BOOL)checkCodeValidate{
    NSString * code = tfCode.text;
    if([code isEqualToString:@""]){
        lbCaution.text = @"Enter code";
        return NO;
    }
    
    NSString * pwd = tfNewPwd.text;
    if(pwd.length < 6){
        lbCaution.text = @"Password length must be minimum 6 characters";

        return NO;
    }
    
    NSString * repwd = tfRePwd.text;
    if(![pwd isEqualToString:repwd]){
        lbCaution.text = @"Password is incorrect";

        return NO;
    }else{
        lbCaution.text = @"";

        return YES;
    }
}
-(IBAction)onClickVerifyCode:(id)sender{
    if([self checkCodeValidate]){
        [self showBusyDialog];
        [self performSelector:@selector(changepassword) withObject:nil afterDelay:0.1];
    }
}

-(void)changepassword{
    NSMutableDictionary * params = [[NSMutableDictionary alloc]init];
    NSString * code = tfCode.text;
    NSString * pwd  = tfRePwd.text;
    NSString * email = tfEmail.text;
    [params setObject:email forKey:@"email"];
    [params setObject:code forKey:@"verifycode"];
    [params setObject:pwd forKey:@"newpassword"];
    NSDictionary * result = [UtilComm changepassword:params];
    [self hideBusyDialog];
    if(result != nil){
        NSDecimalNumber* deccode = [result objectForKey:@"code"];
        NSString * code = [NSString stringWithFormat:@"%@", deccode];
        if([code isEqualToString:@"1"]){
            [self.navigationController popViewControllerAnimated:YES];
        }
    }

}
@end

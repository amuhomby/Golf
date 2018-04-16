//
//  SignUpViewController.m
//  Dress_d
//
//  Created by MacAdmin on 11/27/17.
//  Copyright © 2017 MacAdmin. All rights reserved.
//

#import "SignUpViewController.h"
#import "PhotoViewController.h"
@interface SignUpViewController ()<UITextFieldDelegate>
{
    BOOL _isObserving;
    float _oriStoryY;
    
    float       _keyboardHeight;
    UIView      *_curEditingField;
    int         _ScrolHeight;

}
@end

@implementation SignUpViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self initView];
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
    vwfname.layer.cornerRadius = 10;
    vwfname.layer.borderWidth = 2;
    vwfname.layer.borderColor = [UIColor whiteColor].CGColor;
    vwfname.layer.masksToBounds = YES;
    
    vwlname.layer.cornerRadius = 10;
    vwlname.layer.borderWidth = 2;
    vwlname.layer.borderColor = [UIColor whiteColor].CGColor;
    vwlname.layer.masksToBounds = YES;
    
    vwEmail.layer.cornerRadius = 10;
    vwEmail.layer.borderWidth = 2;
    vwEmail.layer.borderColor = [UIColor whiteColor].CGColor;
    vwEmail.layer.masksToBounds = YES;
    
    vwPwd.layer.cornerRadius = 10;
    vwPwd.layer.borderWidth = 2;
    vwPwd.layer.borderColor = [UIColor whiteColor].CGColor;
    vwPwd.layer.masksToBounds = YES;
    
    vwRePwd.layer.cornerRadius = 10;
    vwRePwd.layer.borderWidth = 2;
    vwRePwd.layer.borderColor = [UIColor whiteColor].CGColor;
    vwRePwd.layer.masksToBounds = YES;
    
    btnContinue.layer.cornerRadius = 10;
    btnContinue.layer.masksToBounds = YES;
    

}
-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    _ScrolHeight = scrollview.bounds.size.height;
    scrollview.contentSize = CGSizeMake(scrollview.frame.size.width, _ScrolHeight);

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
        size.height = _ScrolHeight + _keyboardHeight + 50;
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
- (BOOL)checkValidate
{
    NSString * fname = tfname.text;
    if([fname isEqualToString:@""]){
        lbCaution.text = @"First Name is required";
        return NO;
    }
    
    NSString * lname = tflname.text;
    if([lname isEqualToString:@""]){
        lbCaution.text = @"Last Name is required";
        return NO;
    }
    
    
    NSString * email = tfEmail.text;
    NSString *emailRegex = @"[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,4}";
    NSPredicate *emailTest = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", emailRegex];
    BOOL validEmail = [emailTest evaluateWithObject:email];
    if(!validEmail){
        lbCaution.text = @"Invalid email";
        return NO;
    }
    
    NSString * pwd = tfPwd.text;
    NSInteger szlen = pwd.length;
    if(szlen < 6){
        lbCaution.text = @"Password length must be minimum 6 characters";
        return  NO;
    }
    
    NSString * repwd = tfRePwd.text;
    if(![pwd isEqualToString:repwd]){
        lbCaution.text = @"Password is incorrect";
        return  NO;
    }
    
    lbCaution.text = @"";
    return YES;
}

-(IBAction)onClickSignIn:(id)sender{
    if([self checkValidate]){
        PhotoViewController * vc = [[PhotoViewController alloc]initWithNibName:@"PhotoViewController" bundle:nil];
        vc.strFname = tfname.text;
        vc.strLname = tflname.text;
        vc.strEmail = tfEmail.text;
        vc.strPwd = tfPwd.text;
        
        [self.navigationController pushViewController:vc animated:YES];
    }
}
@end

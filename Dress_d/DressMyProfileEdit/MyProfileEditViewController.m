//
//  MyProfileEditViewController.m
//  Dress_d
//
//  Created by MacAdmin on 9/14/17.
//  Copyright © 2017 dev. All rights reserved.
//

#import "MyProfileEditViewController.h"
#import "UIImageView+WebCache.h"
#import "DressSearchViewController.h"

@interface MyProfileEditViewController ()<UITextFieldDelegate>
{
    BOOL _isObserving;
    float _oriStoryY;
    
    float       _keyboardHeight;
    UIView      *_curEditingField;
    int         _ScrolHeight;

}
@end

@implementation MyProfileEditViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    _ScrolHeight = scrollview.bounds.size.height;
    scrollview.contentSize = CGSizeMake(scrollview.frame.size.width, _ScrolHeight);

    // Do any additional setup after loading the view from its nib.
    UITapGestureRecognizer *tapRecog = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(dismissKeyboard)];
    tapRecog.cancelsTouchesInView = NO;
    [vwBack addGestureRecognizer:tapRecog];
    
    UISwipeGestureRecognizer *swipe = [[UISwipeGestureRecognizer alloc] initWithTarget:self action:@selector(goBack)];
    // And assuming the "Up" direction in your screenshot is no accident
    swipe.direction = UISwipeGestureRecognizerDirectionRight;
    [vwBack addGestureRecognizer:swipe];

}

-(void)viewDidLayoutSubviews{
    _oriStoryY = vwBack.frame.origin.y;
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
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
    [self initView];

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
//        scrollview.contentOffset = CGPointMake(0, -20);
        
        _curEditingField = nil;
        
        
    } completion:NULL];
}
- (void)dismissKeyboard
{
    [_curEditingField resignFirstResponder];
}

-(BOOL)textFieldShouldEndEditing:(UITextField *)textField{
    _subject = textField.text;
    return  YES;
}
-(void)initView{

    CGRect figPhoto = igPhoto.frame;
    figPhoto.origin.x = 0;
    figPhoto.origin.y = 0;
    figPhoto.size.width = [UIScreen mainScreen].bounds.size.width;
    figPhoto.size.height= [UIScreen mainScreen].bounds.size.width * PHOTO_RATIO;
    igPhoto.frame = figPhoto;
    [igPhoto setImageWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@%@",PHOTO_URL, _imgUrl]]  placeholderImage:[UIImage imageNamed:@"place_man.png"]];
    
    CGRect fvwCap = viewCap.frame;
    fvwCap.origin.y = figPhoto.origin.y + figPhoto.size.height + 26;
    viewCap.frame = fvwCap;
    viewCap.layer.borderWidth = 2;
    viewCap.layer.borderColor = mainGreenColor.CGColor;
    viewCap.layer.cornerRadius = 10;
    viewCap.layer.masksToBounds = YES;
    
    if(!(_subject != (id)[NSNull null] && _subject.length != 0))
        _subject = @"";
    
    NSData * subData = [[NSData alloc] initWithBase64EncodedString:_subject options:0];
    NSString * sub = [[NSString alloc]initWithData:subData encoding:NSUTF8StringEncoding];
    _subject = sub;
    tvCap.text = _subject;
    
    CGRect fbtnSave = btnSave.frame;
    fbtnSave.origin.y = fvwCap.origin.y + fvwCap.size.height + 20;
    btnSave.frame = fbtnSave;
    btnSave.layer.cornerRadius = btnSave.bounds.size.height/2;
    btnSave.layer.masksToBounds = YES;
    CGFloat scrollheight = btnSave.frame.origin.y + btnSave.frame.size.height + 90;
    CGSize scrollContentSize = CGSizeMake(scrollview.frame.size.width, scrollheight);
    scrollview.contentSize = scrollContentSize;
    _ScrolHeight = scrollheight;
 }
-(IBAction)onClickSave:(id)sender{
//    user_id, post_id, _token, subject
    NSString * newCaption = tvCap.text;
    if([newCaption isEqualToString:@""]){
        [APPDELEGATE showToastMessage:@"Add Subject"];
        return;
    }
    [self showBusyDialog];
    [self performSelector:@selector(savecaption) withObject:nil afterDelay:0.3];
}


-(void)savecaption{
    NSString * newCaption = tvCap.text;
    NSData *nsdata = [newCaption dataUsingEncoding:NSUTF8StringEncoding];
    NSString *base64Encoded = [nsdata base64EncodedStringWithOptions:0];
    
    NSMutableDictionary * params = [[NSMutableDictionary alloc]init];
    NSString * user_id = [Global sharedGlobal].fbid;
    NSString * _token = [Global sharedGlobal].fbToken;
    [params setObject:_post_id forKey:@"post_id"];
    [params setObject:user_id forKey:@"user_id"];
    [params setObject:_token forKey:@"_token"];
    [params setObject:base64Encoded forKey:@"subject"];
    
    NSDictionary * result = [UtilComm updatepost:params];
    
    [self hideBusyDialog];
    if(result != nil){
        NSDecimalNumber * deccode = [result objectForKey:@"code"];
        NSString * code = [NSString stringWithFormat:@"%@", deccode];
        NSString * data = [result objectForKey:@"data"];
        if([code isEqualToString:@"1"]){
            
            [self.navigationController popViewControllerAnimated:YES];

        }else{
            [APPDELEGATE showToastMessage:data];
        }
        
    }else{
        [APPDELEGATE showToastMessage:CONNECT_ERROR];
    }

}
-(IBAction)onClickBack:(id)sender{
    [self goBack];
}
-(void)goBack{
    [self.navigationController popViewControllerAnimated:YES];
}
-(IBAction)onClickSrh:(id)sender{
    DressSearchViewController * vc = [[DressSearchViewController alloc]initWithNibName:@"DressSearchViewController" bundle:nil];
    [self.navigationController pushViewController:vc animated:YES];
}


@end

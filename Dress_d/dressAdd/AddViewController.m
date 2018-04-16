//
//  AddViewController.m
//  Dress_d
//
//  Created by MacAdmin on 16/09/2017.
//  Copyright © 2017 dev. All rights reserved.
//

#import "AddViewController.h"
#import "CameraViewController.h"
#import "TOCropViewController.h"
#import "ExpireHourViewController.h"
#import "GolfMainViewController.h"
#import "DressSearchViewController.h"
#import "AddStyleViewController.h"
#import "PerviewController.h"

@interface AddViewController () <CameraViewDelegate, UITextFieldDelegate>
{
    BOOL _isObserving;
    
    float       _keyboardHeight;
    UIView      *_curEditingField;
    int         _ScrolHeight;
    NSMutableArray * arrBrands;
    CGFloat gapIg;
    UIImage * image1;
    UIImage * image2;
    UIImage * image3;
    UIImage * image4;
}

@end

static AddViewController * sharedObj;

@implementation AddViewController

+(AddViewController *) sharedInstance{
    return sharedObj;
}
-(BOOL)prefersStatusBarHidden{
    if(_szCount == 0)
        return YES;
    else
        return NO;
}

- (void)viewDidLoad {
//    [super viewDidLoad];

    UIView * statusBar = [[[UIApplication sharedApplication] valueForKey:@"statusBarWindow"] valueForKey:@"statusBar"];
    if([statusBar respondsToSelector:@selector(setBackgroundColor:)]){
        statusBar.backgroundColor = [UIColor clearColor];
    }

    // Do any additional setup after loading the view.
    UITapGestureRecognizer *tapRecog = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(dismissKeyboard)];
    [tapRecog setCancelsTouchesInView:YES];
    [scrollview addGestureRecognizer:tapRecog];
    

    UISwipeGestureRecognizer *swipeLeft = [[UISwipeGestureRecognizer alloc] initWithTarget:self action:@selector(goAhead)];
    // And assuming the "Up" direction in your screenshot is no accident
    swipeLeft.direction = UISwipeGestureRecognizerDirectionLeft;
    [scrollview addGestureRecognizer:swipeLeft];

    
    
    sharedObj = self;
    _szCount = 0;
    _ScrolHeight = scrollview.bounds.size.height;
    self.view.hidden = YES;

    self.navigationController.navigationBarHidden = YES;
    
    [btnCancel addTarget:self action:@selector(onClickCancel:) forControlEvents:UIControlEventTouchUpInside];
}


- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string
{
    NSInteger tag = textField.tag;
    if(tag == 1){
        return textField.text.length + (string.length - range.length) <= 20;
    }else{
        return YES;
    }
}

- (BOOL)textFieldShouldBeginEditing:(UITextField *)textField
{
    _curEditingField = textField;
    return YES;
}

- (BOOL)textFieldShouldReturn:(UITextField *)textField
{
    [textField resignFirstResponder];

    NSInteger tag = textField.tag;
    if(tag == 1){
        NSString * brand = tfBrand.text;
        if([arrBrands count] < 4){
            [arrBrands addObject:brand];
            [self addBrand];
        }
        textField.text = @"";
    }
    return YES;
}

-(void)addBrand{
    NSInteger szBrand = [arrBrands count];
    [self RemoveAllSubViews:viewBrandShow];
    CGRect fbrandshow = viewBrandShow.frame;
    CGFloat screenWidth = [UIScreen mainScreen].bounds.size.width;
    CGFloat gap = 3;
    CGFloat height = 21;
    switch (szBrand) {
        case 0:
        {
            fbrandshow.size.height = 0;
            [self performSelector:@selector(toBottom) withObject:nil afterDelay:0.1];
            break;}
        case 1:
        {
            
            CGRect flb1 = CGRectMake(0, 0, screenWidth, height);
            UILabel * lb1 = [[UILabel alloc] initWithFrame:flb1];
            lb1.text = [arrBrands objectAtIndex:0];
            [self addLabel:lb1];
            
            fbrandshow.size.height = height;
            [self performSelector:@selector(toBottom) withObject:nil afterDelay:0.1];
            break;
        }
        case 2:
        {
            
            CGRect flb1 = CGRectMake(0, 0, screenWidth, height);
            UILabel * lb1 = [[UILabel alloc] initWithFrame:flb1];
            lb1.text = [arrBrands objectAtIndex:0];
            [self addLabel:lb1];

            CGRect flb2 = CGRectMake(0, height + gap, screenWidth, height);
            UILabel * lb2 = [[UILabel alloc] initWithFrame:flb2];
            lb2.text = [arrBrands objectAtIndex:1];
            [self addLabel:lb2];

            fbrandshow.size.height = height +(height + gap) * 1;
            [self performSelector:@selector(toBottom) withObject:nil afterDelay:0.1];
            break;
        }
        case 3:
        {
            
            CGRect flb1 = CGRectMake(0, 0, screenWidth, height);
            UILabel * lb1 = [[UILabel alloc] initWithFrame:flb1];
            lb1.text = [arrBrands objectAtIndex:0];
            [self addLabel:lb1];

            CGRect flb2 = CGRectMake(0, (height + gap) * 1, screenWidth, height);
            UILabel * lb2 = [[UILabel alloc] initWithFrame:flb2];
            lb2.text = [arrBrands objectAtIndex:1];
            [self addLabel:lb2];

            CGRect flb3 = CGRectMake(0, (height + gap) * 2, screenWidth, height);
            UILabel * lb3 = [[UILabel alloc] initWithFrame:flb3];
            lb3.text = [arrBrands objectAtIndex:2];
            [self addLabel:lb3];

            fbrandshow.size.height = height + (height + gap) * 2;
            [self performSelector:@selector(toBottom) withObject:nil afterDelay:0.1];
            break;
        }
        case 4:
        {
            
            CGRect flb1 = CGRectMake(0, 0, screenWidth, height);
            UILabel * lb1 = [[UILabel alloc] initWithFrame:flb1];
            lb1.text = [arrBrands objectAtIndex:0];
            [self addLabel:lb1];
            
            CGRect flb2 = CGRectMake(0, height + gap, screenWidth, height);
            UILabel * lb2 = [[UILabel alloc] initWithFrame:flb2];
            lb2.text = [arrBrands objectAtIndex:1];
            [self addLabel:lb2];
            
            CGRect flb3 = CGRectMake(0, (height + gap) * 2, screenWidth, height);
            UILabel * lb3 = [[UILabel alloc] initWithFrame:flb3];
            lb3.text = [arrBrands objectAtIndex:2];
            [self addLabel:lb3];

            CGRect flb4 = CGRectMake(0, (height + gap) * 3, screenWidth, height);
            UILabel * lb4 = [[UILabel alloc] initWithFrame:flb4];
            lb4.text = [arrBrands objectAtIndex:3];
            [self addLabel:lb4];
            

            
            fbrandshow.size.height =height + ( height + gap) * 3;
            [self performSelector:@selector(toBottom) withObject:nil afterDelay:0.1];
            break;
        }

        default:

            break;
    }
    
    viewBrandShow.frame = fbrandshow;
    CGFloat yStyle = fbrandshow.origin.y + fbrandshow.size.height + 15;
    [self resetPosition:lbStyle :yStyle];
    
    CGFloat ySLine = lbStyle.frame.origin.y + lbStyle.frame.size.height + 3;
    [self resetPosition:lbLine :ySLine];
    
    CGFloat yViewStyle = lbLine.frame.origin.y + lbLine.frame.size.height + 13;
    [self resetPosition:viewStyle :yViewStyle];
    
//    CGFloat ybtncon = viewStyle.frame.origin.y + viewStyle.frame.size.height + 40;
//    CGFloat ybtncon = viewBrandShow.frame.origin.y + viewBrandShow.frame.size.height + 20;

//    [self resetPosition:btnContinue :ybtncon];
    
//    CGFloat ybtnCan = btnContinue.frame.origin.y + btnContinue.frame.size.height + 20;
//    CGFloat ybtnCan = ybtncon;
//    [self resetPosition:btnCancel :ybtnCan];
    
    CGRect fCan = viewBrandShow.frame;
    CGRect fMain = viewMain.frame;
    fMain.size.height = fCan.origin.y + fCan.size.height + 40;
    viewMain.frame = fMain;
    
    
//    CGFloat minY = [UIScreen mainScreen].bounds.size.height - ( viewMain.frame.origin.y + viewMain.frame.size.height) - 20;
//    if(minY > 0){
//        fMain.size.height = [UIScreen mainScreen].bounds.size.height - (viewMain.frame.origin.y + 20);
//        viewMain.frame = fMain;
//        ybtncon = fMain.size.height - 80;
//        [self resetPosition:btnContinue :ybtncon];
//        [self resetPosition:btnCancel :ybtncon];
//    }

    if((fMain.size.height + fMain.origin.y) < [UIScreen mainScreen].bounds.size.height  - 20){
        fMain.size.height = [UIScreen mainScreen].bounds.size.height - fMain.origin.y - 20;
        viewMain.frame = fMain;
        
//        CGRect fCon = btnContinue.frame;
//        fCon.origin.y = fMain.size.height - fCon.size.height - 40;
//        btnContinue.frame = fCon;
//        
//        CGRect fCan = btnCancel.frame;
//        fCan.origin.y = fMain.size.height - fCon.size.height - 40;
//        btnCancel.frame = fCan;
    }

    scrollview.contentSize = CGSizeMake(scrollview.frame.size.width, fMain.origin.y + fMain.size.height);
}

-(void)toBottom{
    CGPoint  bottomOffset = CGPointMake(0, scrollview.contentSize.height - scrollview.bounds.size.height);
    [scrollview setContentOffset:bottomOffset animated:YES];
}
-(void)resetPosition:(UIView *) view :(CGFloat) newVal{
    CGRect frame = view.frame;
    frame.origin.y = newVal;
    view.frame = frame;
}

-(void)addLabel:(UILabel *)lb{
    [lb setTextAlignment:NSTextAlignmentCenter];
    lb.textColor = [UIColor whiteColor];
    lb.font = [UIFont fontWithName:@"Georgia" size:17];
    [viewBrandShow addSubview:lb];
}


-(void)viewWillAppear:(BOOL)animated
{
    [[GolfMainViewController sharedInstance] hideTab:YES];
    UIView * statusBar = [[[UIApplication sharedApplication] valueForKey:@"statusBarWindow"] valueForKey:@"statusBar"];
    if([statusBar respondsToSelector:@selector(setBackgroundColor:)]){
        statusBar.backgroundColor = [UIColor clearColor];
    }

    self.view.hidden = YES;
    [self ToTop:NO];
    if(_szCount == 0)
    {
        arrSelStyle=[[NSMutableArray alloc]init];
        [self RemoveAllSubViews:viewStyle];
        arrBrands = [[NSMutableArray alloc]init];
        [self addBrand];
        _arrStyle = [Global sharedGlobal].arrStyle;

        [self initView];

    }
    
//    [APPDELEGATE getLocation];
    if(_szCount < 1){

        NSString * bakeAdd = [Global sharedGlobal].bakeToAdd;
        if([bakeAdd isEqualToString:@"no"]){
          [self performSelector:@selector(loadCamera) withObject:nil afterDelay:0.05];
        }
    }else{
        UIView * statusBar = [[[UIApplication sharedApplication] valueForKey:@"statusBarWindow"] valueForKey:@"statusBar"];
        if([statusBar respondsToSelector:@selector(setBackgroundColor:)]){
            statusBar.backgroundColor = mainGreenColor;
        }

        self.view.hidden = NO;
    }
    
    if(_szCount == 0){
    }
    if (!_isObserving) {
        NSNotificationCenter *noticication = [NSNotificationCenter defaultCenter];
        [noticication addObserver:self selector:@selector(keyboardWillShow:) name:UIKeyboardWillShowNotification object:nil];
        [noticication addObserver:self selector:@selector(keyboardWillHide:) name:UIKeyboardWillHideNotification object:nil];
        
        _isObserving = YES;
    }
}

-(void)getStyle{
    scrollview.hidden = YES;
    NSString * user_id = [Global sharedGlobal].fbid;
    NSString * _token = [Global sharedGlobal].fbToken;
    NSMutableDictionary * params = [[NSMutableDictionary alloc]init];
    [params setObject:user_id forKey:@"user_id"];
    [params setObject:_token forKey:@"_token"];
    NSDictionary * result = [UtilComm getStyle:params];
    scrollview.hidden = NO;
    [self hideBusyDialog];

    if(result != nil){
        NSDecimalNumber * deccode = [result objectForKey:@"code"];
        NSString * code = [NSString stringWithFormat:@"%@", deccode];
        NSString * data  =[result objectForKey:@"data"];
        if([code isEqualToString:@"1"]){
            _arrStyle = [result objectForKey:@"data"];
            
        }else{
            [APPDELEGATE showToastMessage:data];
        }
    }
    [self initView];

}
- (void)viewWillDisappear:(BOOL)animated
{
    [[GolfMainViewController sharedInstance] hideTab:NO];
    if (_isObserving) {
        NSNotificationCenter *noticication = [NSNotificationCenter defaultCenter];
        [noticication removeObserver:self name:UIKeyboardWillShowNotification object:nil];
        [noticication removeObserver:self name:UIKeyboardWillHideNotification object:nil];
        
        _isObserving = NO;
    }
    
    [super viewWillDisappear:animated];
    if(_szCount == 0)
        [self clear];
}


-(void) keyboardWillShow:(NSNotification *) notification{
    
    NSTimeInterval duration = [[[notification userInfo] objectForKey:UIKeyboardAnimationDurationUserInfoKey] doubleValue];
    
    _ScrolHeight = scrollview.contentSize.height;
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
        contentRect.size.height += _keyboardHeight + 10;
        
        [scrollview scrollRectToVisible:contentRect animated:YES];

        
        
    } completion:NULL];
}

-(void) keyboardWillHide:(NSNotification *)notification{
    
    NSTimeInterval duration = [[[notification userInfo] objectForKey:UIKeyboardAnimationDurationUserInfoKey] doubleValue];
    
    [UIView animateWithDuration:duration animations:^{
        
        CGSize size = scrollview.frame.size;
        size.height = _ScrolHeight;
        scrollview.contentSize = size;
        CGPoint currentPostion = scrollview.contentOffset;
        scrollview.contentOffset = currentPostion;
        
        _curEditingField = nil;
        
        
    } completion:NULL];
}
- (void)dismissKeyboard
{
    [_curEditingField resignFirstResponder];
}

-(void)initView{
    
    //NSString * city = [Global sharedGlobal].city;
    gapIg = 3;
    CGRect fvwbutton = vwButton.frame;
    fvwbutton.origin.y = 0;
    vwButton.frame = fvwbutton;
    
    CGRect figfirst = igFirst.frame;
    figfirst.origin.x = 0;
    figfirst.origin.y = fvwbutton.origin.y + fvwbutton.size.height + gapIg;
    figfirst.size.width = [UIScreen mainScreen].bounds.size.width;
    figfirst.size.height = [UIScreen mainScreen].bounds.size.width * PHOTO_RATIO;
    igFirst.frame = figfirst;
    
    CGRect figsecond = igSecond.frame;
    figsecond.origin.x = 0;
    figsecond.origin.y = figfirst.origin.y + figfirst.size.height + gapIg;
    figsecond.size.width = [UIScreen mainScreen].bounds.size.width;
    figsecond.size.height = [UIScreen mainScreen].bounds.size.width * PHOTO_RATIO;
    igSecond.frame = figsecond;
    
    CGRect figthird = igThird.frame;
    figthird.origin.x = 0;
    figthird.origin.y = figsecond.origin.y + figsecond.size.height + gapIg;
    figthird.size.width = [UIScreen mainScreen].bounds.size.width;
    figthird.size.height = [UIScreen mainScreen].bounds.size.width * PHOTO_RATIO;
    igThird.frame = figthird;
    
    CGRect figfourth = igFourth.frame;
    figfourth.origin.x = 0;
    figfourth.origin.y = figthird.origin.y + figthird.size.height + gapIg;
    figfourth.size.width = [UIScreen mainScreen].bounds.size.width;
    figfourth.size.height = [UIScreen mainScreen].bounds.size.width * PHOTO_RATIO;
    igFourth.frame = figfourth;
    
    
    
    viewCap.layer.cornerRadius = 15;
    viewCap.layer.masksToBounds = YES;
    viewCap.layer.borderWidth = 2;
    viewCap.layer.borderColor = [UIColor whiteColor].CGColor;
    tfCap.textColor = [UIColor whiteColor];
    
    viewBrand.layer.cornerRadius = 15;
    viewBrand.layer.masksToBounds = YES;
    viewBrand.layer.borderWidth = 2;
    viewBrand.layer.borderColor = [UIColor whiteColor].CGColor;
    tfBrand.textColor = [UIColor whiteColor];
    


    btnContinue.layer.cornerRadius = 10;
    btnContinue.layer.masksToBounds = YES;
    
    btnCancel.layer.cornerRadius = 10;
    btnCancel.layer.masksToBounds = YES;
    
    
    CGFloat rightEnd = 0;
    CGFloat bottomEnd = 0;
    CGFloat szhbtn = 0;
    CGRect fStyle = viewStyle.frame;
    
    UIView * viewStyleLine;
    
    for(int x=0; x < _arrStyle.count;x++){
        
        NSMutableDictionary * styleItem = [_arrStyle objectAtIndex:x];
        NSString * btnName = [styleItem objectForKey:@"name"];
        
        CGFloat gapHori = 6;
        CGFloat gapVer  = 5;
        CGFloat gapInner = 20;
        
        CGFloat szStyleW = fStyle.size.width;
        UIButton * btn = [[UIButton alloc]initWithFrame:CGRectMake(rightEnd, 0, 0, 0)];
        [btn setTitle:btnName forState:UIControlStateNormal];
        [btn setBackgroundColor:[UIColor whiteColor]];
        btn.titleLabel.font = [UIFont fontWithName:@"Georgia" size:18];

        [btn setTitleColor:mainGreenColor forState:UIControlStateNormal];
        [btn sizeToFit];
        CGRect framebtn = btn.frame;
        szhbtn = framebtn.size.height;
        framebtn.size.width = framebtn.size.width + gapInner;
        btn.frame = framebtn;
        btn.layer.cornerRadius = btn.layer.bounds.size.height/2;
        btn.layer.masksToBounds = YES;
        btn.layer.borderColor = mainGreenColor.CGColor;
        btn.layer.borderWidth = 1;
        
        btn.tag = x;
        [btn addTarget:self action:@selector(addStyle:) forControlEvents:UIControlEventTouchUpInside];
        
        if(rightEnd == 0){
            rightEnd = framebtn.size.width;
            viewStyleLine = [[UIView alloc]initWithFrame:CGRectMake(0,bottomEnd,0,0)];
            [viewStyleLine addSubview:btn];
        }else{
            rightEnd = rightEnd + framebtn.size.width + gapHori;
            
            if(rightEnd <= szStyleW){
                
                framebtn.origin.x = framebtn.origin.x + gapHori;
                btn.frame = framebtn;
                [viewStyleLine addSubview:btn];  // new
            }else{
                
                CGRect frameStyleLine = viewStyleLine.frame;
                frameStyleLine.size.width = rightEnd - btn.frame.size.width - gapHori;
                frameStyleLine.size.height = btn.frame.size.height;
                viewStyleLine.frame = frameStyleLine;
                viewStyleLine.center = CGPointMake(viewStyle.bounds.size.width/2, bottomEnd+viewStyleLine.frame.size.height/2);
                
                
                
                [viewStyle addSubview:viewStyleLine];

                bottomEnd = bottomEnd + framebtn.size.height + gapVer;
                rightEnd = 0;

                viewStyleLine = [[UIView alloc]initWithFrame:CGRectMake(0,bottomEnd,0,0)];
                
                framebtn.origin.x = rightEnd;
                framebtn.origin.y =0;// bottomEnd;
                btn.frame = framebtn;
                rightEnd = framebtn.size.width;
                
                [viewStyleLine addSubview:btn];

            }
        }
        
        if(x == [_arrStyle count]-1){
            CGRect frameStyleLine = viewStyleLine.frame;
            frameStyleLine.size.width = rightEnd;
            frameStyleLine.size.height = btn.frame.size.height;
            viewStyleLine.frame = frameStyleLine;
            viewStyleLine.center = CGPointMake(viewStyle.bounds.size.width/2, bottomEnd+viewStyleLine.frame.size.height/2);
            [viewStyle addSubview:viewStyleLine];

        }
       
    }
    fStyle.size.height = 0; // bottomEnd + szhbtn + 10;
    viewStyle.frame = fStyle;
    
//    CGRect fCon = btnContinue.frame;
//    fCon.origin.y = viewBrandShow.frame.origin.y + viewBrandShow.frame.size.height + 20;
//    btnContinue.frame = fCon;
//    
//    CGRect fCan = btnCancel.frame;
////    fCan.origin.y = btnContinue.frame.origin.y + btnContinue.frame.size.height + 20;
//    CGFloat ybtncon = viewBrandShow.frame.origin.y + viewBrandShow.frame.size.height + 20;
//
//
//    fCan.origin.y = ybtncon;
//    btnCancel.frame = fCan;
//    
    CGRect fMain = viewMain.frame;
    fMain.size.height = viewBrandShow.frame.origin.y + viewBrandShow.frame.size.height + 20;
    viewMain.frame = fMain;
    
//    CGFloat minY = [UIScreen mainScreen].bounds.size.height - ( viewMain.frame.origin.y + viewMain.frame.size.height) - 20;
//    if(minY > 0){
//        fMain.size.height = [UIScreen mainScreen].bounds.size.height - (viewMain.frame.origin.y + 20);
//        viewMain.frame = fMain;
//        ybtncon = fMain.size.height - 80;
//        fCon.origin.y = ybtncon;
//        fCan.origin.y = ybtncon;
//        btnCancel.frame = fCan;
//        btnContinue.frame = fCon;
//    }
    scrollview.contentSize = CGSizeMake(scrollview.frame.size.width, fMain.origin.y + fMain.size.height + 20);

}

- (void)addStyle:(UIButton *)sender {
    if(sender.selected){
        NSInteger index = sender.tag;
        [sender setBackgroundColor:UIColor.whiteColor];
        [sender setTitleColor:mainGreenColor forState:UIControlStateNormal];
        NSMutableDictionary * dicStyle = [_arrStyle objectAtIndex:index];
        NSString * deselInterest = [NSString stringWithFormat:@"%@", [dicStyle objectForKey:@"id"]];
        [arrSelStyle removeObject:deselInterest];
        sender.selected = NO;
    }else{
        NSInteger index = sender.tag;
        [sender setBackgroundColor:mainGreenColor];
        [sender setTitleColor:UIColor.whiteColor forState:UIControlStateNormal];
        NSMutableDictionary * dicStyle = [_arrStyle objectAtIndex:index];
        NSString * selInterest =[NSString stringWithFormat:@"%@",[dicStyle objectForKey:@"id"]];
        [arrSelStyle addObject:selInterest];
        sender.selected = YES;
    }
}



- (void)loadCamera
{
    
    [Global sharedGlobal].tocamera = @"no";
    [[Global sharedGlobal] SaveParam];
    CameraViewController *VC = [[CameraViewController alloc] initWithNibName:@"CameraViewController" bundle:nil];
    VC.delegate = self;
    NSString * imageNo = [NSString stringWithFormat:@"%d", _szCount];
    VC.imageNo = imageNo;
    
    [self presentViewController:VC animated:NO completion:nil];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
-(void)getImage:(UIImage *)image{
    _szCount += 4;
    _szCount = _szCount % 4 + 1;

    if(_szCount == 1){
        igFirst.image = image;
        image1 = image;
        //        btnAdd.hidden = NO;
        igSecond.hidden = YES;
        CGRect fMain = viewMain.frame;
        CGRect figSec = igSecond.frame;
        fMain.origin.y = figSec.origin.y;
        fMain.size.height = viewBrandShow.frame.origin.y + viewBrandShow.frame.size.height + 40;
        viewMain.frame = fMain;
        
        if((fMain.size.height + fMain.origin.y) < [UIScreen mainScreen].bounds.size.height  - 20){
            fMain.size.height = [UIScreen mainScreen].bounds.size.height - fMain.origin.y - 20;
            viewMain.frame = fMain;
            
//            CGRect fCon = btnContinue.frame;
//            fCon.origin.y = fMain.size.height - fCon.size.height - 40;
//            btnContinue.frame = fCon;
//            
//            CGRect fCan = btnCancel.frame;
//            fCan.origin.y = fMain.size.height - fCon.size.height - 40;
//            btnCancel.frame = fCan;
        }

        scrollview.contentSize = CGSizeMake(scrollview.bounds.size.width, fMain.origin.y + fMain.size.height);
        _ScrolHeight =fMain.origin.y + fMain.size.height;
        btnAdd.hidden = NO;
        
        PerviewController * vc = [[PerviewController alloc]initWithNibName:@"PerviewController" bundle:nil];
        vc.imgData = image1;
        [self.navigationController pushViewController:vc animated:NO];
        
    }else if(_szCount == 2){
        image2 = image;
        igSecond.image = image;
        CGRect fMain = viewMain.frame;
        CGRect figSec = igSecond.frame;
        igSecond.hidden = NO;
        //        btnAdd.hidden = YES;
        fMain.origin.y = figSec.origin.y + figSec.size.height + gapIg;
        viewMain.frame = fMain;
        scrollview.contentSize = CGSizeMake(scrollview.bounds.size.width, fMain.origin.y + fMain.size.height);
        _ScrolHeight = fMain.origin.y + fMain.size.height;
    }else if(_szCount == 3){
        image3 = image;
        igThird.image = image;
        CGRect fMain = viewMain.frame;
        CGRect figThr = igThird.frame;
        igThird.hidden = NO;
        //        btnAdd.hidden = YES;
        fMain.origin.y = figThr.origin.y + figThr.size.height + gapIg;
        viewMain.frame = fMain;
        scrollview.contentSize = CGSizeMake(scrollview.bounds.size.width, fMain.origin.y + fMain.size.height);
        _ScrolHeight = fMain.origin.y + fMain.size.height;
    }else if(_szCount == 4){
        image4 = image;
        igFourth.image = image;
        CGRect fMain = viewMain.frame;
        CGRect figFor = igFourth.frame;
        igFourth.hidden = NO;
        //        btnAdd.hidden = YES;
        fMain.origin.y = figFor.origin.y + figFor.size.height + gapIg;
        viewMain.frame = fMain;
        scrollview.contentSize = CGSizeMake(scrollview.bounds.size.width, fMain.origin.y + fMain.size.height);
        _ScrolHeight = fMain.origin.y + fMain.size.height;
        btnAdd.hidden = YES;
    }
}

-(void)didCaptureImage:(UIImage *)image {
    NSLog(@"CAPTURED IMAGE");

}

-(void)didCaptureImageWithData:(NSData *)imageData {
    NSLog(@"CAPTURED IMAGE DATA");
    //UIImage *image = [[UIImage alloc] initWithData:imageData];
    //UIImageWriteToSavedPhotosAlbum(image, self, @selector(image:didFinishSavingWithError:contextInfo:), nil);
    //[self.cameraView removeFromSuperview];
}

-(IBAction)onClickAdd:(id)sender{
    [self performSelector:@selector(loadCamera) withObject:nil afterDelay:0.05];
    
}
-(IBAction)onClickBack:(id)sender{
//    self.view.hidden = YES;
//    [self clear];
//    [self performSelector:@selector(loadCamera) withObject:nil afterDelay:0.2];
    
}
-(IBAction)onClickSrh:(id)sender{
    DressSearchViewController * vc = [[DressSearchViewController alloc]initWithNibName:@"DressSearchViewController" bundle:nil];
    [self.navigationController pushViewController:vc animated:YES];
  
}

-(IBAction)onClickCon:(id)sender{
    
    [self goAhead];
}

-(void)goAhead{
    
    NSString * strBrand = @"";
    for(int x=0; x < [arrBrands count]; x++){
        NSString * brand = [arrBrands objectAtIndex:x];
        if(x==0)
            strBrand = brand;
        else
            strBrand = [NSString stringWithFormat:@"%@,%@", strBrand, brand];
    }
    
    NSData *imgData1 = UIImageJPEGRepresentation(image1, 0.5);
    NSData *imgData2 = UIImageJPEGRepresentation(image2, 0.5);
    NSData *imgData3 = UIImageJPEGRepresentation(image3, 0.5);
    NSData *imgData4 = UIImageJPEGRepresentation(image4, 0.5);
    
    if ( imgData1 == nil )
    {
        [APPDELEGATE showToastMessage:@"Take Photo."];
        return;
    }
    
    [Global sharedGlobal].cameraBack = @"no";
    [[Global sharedGlobal] SaveParam];
    
    
    AddStyleViewController * vc = [[AddStyleViewController alloc]initWithNibName:@"AddStyleViewController" bundle:nil];
    vc.subject = tfCap.text;
    vc.strBrand = strBrand;
    vc.imgData1 = imgData1;
    vc.imgData2 = imgData2;
    vc.imgData3 = imgData3;
    vc.imgData4 = imgData4;
    
    [self.navigationController pushViewController:vc animated:YES];

}
-(void)onClickCancel:(UIButton *)sender{
    NSString * tabindex = [Global sharedGlobal].tabIndex;
    NSInteger index = [tabindex intValue];
    if(index ==0 ||index ==1 ||index ==3 ||index ==4){
        
    }else{
        index = 0;
    }
    [[GolfMainViewController sharedInstance] changTab:index];
}

-(void)clear{
    tfCap.text = @"";
    tfBrand.text = @"";
    [arrBrands removeAllObjects];
    igSecond.image = nil;
    igThird.image = nil;
    igFourth.image = nil;
    image2 = nil;
    image3 = nil;
    image4 = nil;
    CGRect fMain = viewMain.frame;
    CGRect figSec = igSecond.frame;
    fMain.origin.y = figSec.origin.y;
    viewMain.frame = fMain;
    scrollview.contentSize = CGSizeMake(scrollview.bounds.size.width, fMain.origin.y + fMain.size.height+50);
    _ScrolHeight =fMain.origin.y + fMain.size.height+50;
    
}

-(void)RemoveAllSubViews:(UIView *)sender{
    NSArray *viewsToRemove = [sender subviews];
    for (UIView *v in viewsToRemove) {
        [v removeFromSuperview];
    }
}

-(void)ToTop:(BOOL)flag{
    [scrollview setContentOffset:CGPointZero animated:flag];
}
@end

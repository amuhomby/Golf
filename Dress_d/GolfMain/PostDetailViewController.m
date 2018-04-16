//
//  PostDetailViewController.m
//  Dress_d
//
//  Created by MacAdmin on 9/12/17.
//  Copyright © 2017 dev. All rights reserved.
//

#import "PostDetailViewController.h"
#import "UIImageView+WebCache.h"
#import "MyProfileSettingViewController.h"
#import "DressSearchViewController.h"
#import "GolfMainViewController.h"
#import "LikeViewController.h"
#import "FriendProfileViewController.h"
#import "BrandViewController.h"
#import "ReportViewController.h"
#import "ProductViewController.h"

@interface PostDetailViewController ()<UITextFieldDelegate, UIScrollViewDelegate>
{
    BOOL _isObserving;
    float _oriStoryY;
    NSString * fbid;
    
    
    float       _keyboardHeight;
    UIView      *_curEditingField;
    int         _ScrolHeight;
    
    
    int currentPage;
    NSString * like1;
    NSString * like2;
    NSString * like3;
    NSString * like4;
    NSString * like5;
    NSString * like6;
    NSString * like7;
    NSString * like8;
    NSString * like9;
    NSString * like10;
    NSString * like11;
    NSString * like12;
    NSString * me1;
    NSString * me2;
    NSString * me3;
    NSString * me4;
    NSString * me5;
    NSString * me6;
    NSString * me7;
    NSString * me8;
    NSString * me9;
    NSString * me10;
    NSString * me11;
    NSString * me12;
   
}
@end

@implementation PostDetailViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    fbid = @"";
    // Do any additional setup after loading the view from its nib.
    UITapGestureRecognizer *tapRecog = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(dismissKeyboard)];
    tapRecog.cancelsTouchesInView = NO;
    [scrView addGestureRecognizer:tapRecog];
    
    UISwipeGestureRecognizer *swipe = [[UISwipeGestureRecognizer alloc] initWithTarget:self action:@selector(goBack)];
    // And assuming the "Up" direction in your screenshot is no accident
    swipe.direction = UISwipeGestureRecognizerDirectionRight;
    [scrView addGestureRecognizer:swipe];

    _ScrolHeight = scrView.bounds.size.height;
    
    viewCmt.layer.cornerRadius = viewCmt.layer.bounds.size.height/2;
    viewCmt.layer.masksToBounds = YES;
    viewCmt.layer.borderColor = mainGreenColor.CGColor;
    viewCmt.layer.borderWidth = 1;
    
    
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
    
    currentPage = 0;
    like1 = @"";
    like2 = @"";
    like3 = @"";
    like4 = @"";
    like5 = @"";
    like6 = @"";
    like7 = @"";
    like8 = @"";
    like9 = @"";
    like10 = @"";
    like11 = @"";
    like12 = @"";
    me1 = @"";
    me2 = @"";
    me3 = @"";
    me4 = @"";
    me5 = @"";
    me6 = @"";
    me7 = @"";
    me8 = @"";
    me9 = @"";
    me10 = @"";
    me11 = @"";
    me12 = @"";
    
    [self showBusyDialog];
    scrView.hidden = YES;
    [self performSelector:@selector(initData) withObject:nil afterDelay:0.5]; //0.5

    if (!_isObserving) {
        NSNotificationCenter *noticication = [NSNotificationCenter defaultCenter];
        [noticication addObserver:self selector:@selector(keyboardWillShow:) name:UIKeyboardWillShowNotification object:nil];
        [noticication addObserver:self selector:@selector(keyboardWillHide:) name:UIKeyboardWillHideNotification object:nil];
        
        _isObserving = YES;
    }
    
}
- (void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];

    if (_isObserving) {
        NSNotificationCenter *noticication = [NSNotificationCenter defaultCenter];
        [noticication removeObserver:self name:UIKeyboardWillShowNotification object:nil];
        [noticication removeObserver:self name:UIKeyboardWillHideNotification object:nil];
        
        _isObserving = NO;
    }
    
}
-(void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView
{
    int indexOfPage = scrollView.contentOffset.x / scrollView.frame.size.width;
    //your stuff with index
    currentPage = indexOfPage;
    [self dispLike56];
}

-(BOOL)textFieldShouldBeginEditing:(UITextField *)textField{
    btnSendComm.hidden = NO;
    igTick.hidden = NO;
    
    _curEditingField = textField;
    return YES;
}
-(BOOL)textFieldShouldEndEditing:(UITextField *)textField{
    if([textField.text isEqualToString:@""]){
        btnSendComm.hidden =YES;
        igTick.hidden = YES;
    }
    return YES;
}

- (BOOL)textFieldShouldReturn:(UITextField *)textField
{
    [self dismissKeyboard];
    [self showBusyDialog];
    [self performSelector:@selector(sendComment) withObject:nil afterDelay:0.05]; //0.5
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
        
        CGSize size = scrView.frame.size;
        size.height = _ScrolHeight + _keyboardHeight;
        scrView.contentSize = size;
        
        CGRect  contentRect = [scrView convertRect:_curEditingField.bounds fromView:_curEditingField];
        contentRect.size.height += _keyboardHeight  + 20;
        
        [scrView scrollRectToVisible:contentRect animated:YES];
        
        
        
    } completion:NULL];
}

-(void) keyboardWillHide:(NSNotification *)notification{
    
    NSTimeInterval duration = [[[notification userInfo] objectForKey:UIKeyboardAnimationDurationUserInfoKey] doubleValue];
    
    [UIView animateWithDuration:duration animations:^{
        
        CGSize size = scrView.frame.size;
        size.height = _ScrolHeight;
        scrView.contentSize = size;
//        scrView.contentOffset = CGPointMake(0, 0);
        
        _curEditingField = nil;
        
        
    } completion:NULL];
}
- (void)dismissKeyboard
{
    [_curEditingField resignFirstResponder];
}

-(void)viewDidLayoutSubviews{
    _oriStoryY = viewMain.frame.origin.y;
}
-(void)initData{
//    user_id, post_id, _token
    NSMutableDictionary * params = [[NSMutableDictionary alloc]init];
    NSString * user_id = [Global sharedGlobal].fbid;
    NSString * _token = [Global sharedGlobal].fbToken;
    
    [params setObject:_post_id forKey:@"post_id"];
    [params setObject:_token forKey:@"_token"];
    [params setObject:user_id forKey:@"user_id"];
    NSDictionary * result = [UtilComm getpostdetail:params];
    if(result != nil){
        NSDecimalNumber *deccode = [result objectForKey:@"code"];
        NSString * code = [NSString stringWithFormat:@"%@", deccode];
        //NSString * data = [result objectForKey:@"data"];
        if([code isEqualToString:@"1"]){
            scrView.hidden = NO;

            _dicPostDetail = [result objectForKey:@"data"];
            _arrComment = [result objectForKey:@"comments"];
            _myCommentFlag = [NSString stringWithFormat:@"%@",[result objectForKey:@"mycommentflg"] ];
            _mySaveFlag   = [NSString stringWithFormat:@"%@",[result objectForKey:@"mysaveflg"]];
            scrView.hidden = NO;
            [self initview];
        }else{
            scrView.hidden = YES;
            [self.navigationController popViewControllerAnimated:YES];
        }
    }else{
        scrView.hidden = YES;
        scrView.hidden = YES;
        [self.navigationController popViewControllerAnimated:YES];
    }
    [self hideBusyDialog];
}

-(void)initview{
    [self RemoveAllSubViews:scrImage];
    [scrImage setContentOffset:CGPointZero];

    fbid = [_dicPostDetail objectForKey:@"user_id"];
    NSString * first_name = [_dicPostDetail objectForKey:@"first_name"];
    NSString * last_name = [_dicPostDetail objectForKey:@"last_name"];
    NSString * profilePath = [_dicPostDetail objectForKey:@"avatar"];
    //NSString * expiredhour =[NSString stringWithFormat:@"%@", [_dicPostDetail objectForKey:@"expiredhour"]];
    like1 =[NSString stringWithFormat:@"%@", [_dicPostDetail objectForKey:@"like1"]];
    like2 =[NSString stringWithFormat:@"%@", [_dicPostDetail objectForKey:@"like2"]];
    like3 =[NSString stringWithFormat:@"%@", [_dicPostDetail objectForKey:@"like3"]];
    like4 =[NSString stringWithFormat:@"%@", [_dicPostDetail objectForKey:@"like4"]];
    
    like5 =[NSString stringWithFormat:@"%@", [_dicPostDetail objectForKey:@"like5"]];
    like6 =[NSString stringWithFormat:@"%@", [_dicPostDetail objectForKey:@"like6"]];
    like7 =[NSString stringWithFormat:@"%@", [_dicPostDetail objectForKey:@"like7"]];
    like8 =[NSString stringWithFormat:@"%@", [_dicPostDetail objectForKey:@"like8"]];
    
    like9 =[NSString stringWithFormat:@"%@", [_dicPostDetail objectForKey:@"like9"]];
    like10 =[NSString stringWithFormat:@"%@", [_dicPostDetail objectForKey:@"like10"]];
    like11 =[NSString stringWithFormat:@"%@", [_dicPostDetail objectForKey:@"like11"]];
    like12 =[NSString stringWithFormat:@"%@", [_dicPostDetail objectForKey:@"like12"]];
    
    me1 = [NSString stringWithFormat:@"%@", [_dicPostDetail objectForKey:@"me1"]];
    me2 = [NSString stringWithFormat:@"%@", [_dicPostDetail objectForKey:@"me2"]];
    me3 = [NSString stringWithFormat:@"%@", [_dicPostDetail objectForKey:@"me3"]];
    me4 = [NSString stringWithFormat:@"%@", [_dicPostDetail objectForKey:@"me4"]];
    
    me5 = [NSString stringWithFormat:@"%@", [_dicPostDetail objectForKey:@"me5"]];
    me6 = [NSString stringWithFormat:@"%@", [_dicPostDetail objectForKey:@"me6"]];
    me7 = [NSString stringWithFormat:@"%@", [_dicPostDetail objectForKey:@"me7"]];
    me8 = [NSString stringWithFormat:@"%@", [_dicPostDetail objectForKey:@"me8"]];
    
    me9 = [NSString stringWithFormat:@"%@", [_dicPostDetail objectForKey:@"me9"]];
    me10 = [NSString stringWithFormat:@"%@", [_dicPostDetail objectForKey:@"me10"]];
    me11 = [NSString stringWithFormat:@"%@", [_dicPostDetail objectForKey:@"me11"]];
    me12 = [NSString stringWithFormat:@"%@", [_dicPostDetail objectForKey:@"me12"]];

    subject =[NSString stringWithFormat:@"%@",[_dicPostDetail objectForKey:@"subject"]];
    if(!(subject != (id)[NSNull null] && subject.length != 0))
        subject = @"";
    NSData * subData = [[NSData alloc] initWithBase64EncodedString:subject options:0];
    NSString * sub = [[NSString alloc]initWithData:subData encoding:NSUTF8StringEncoding];
    subject = sub;
    lbSubj.text = subject;
    NSString * strBrand =[_dicPostDetail objectForKey:@"brand"];
    if(!(strBrand != (id)[NSNull null] && strBrand.length != 0))
        strBrand = @"";
    if([strBrand isEqualToString:@"<null>"])
        strBrand = @"";
    NSString * photo = [_dicPostDetail objectForKey:@"photo"];
    NSString * photo2 = [_dicPostDetail objectForKey:@"photo2"];
    NSString * photo3 = [_dicPostDetail objectForKey:@"photo3"];  ///
    NSString * photo4 = [_dicPostDetail objectForKey:@"photo4"];  ///

    NSDecimalNumber * remainTimeInt = [_dicPostDetail objectForKey:@"remaintime"];
    NSString * str = [NSString stringWithFormat:@"%@", remainTimeInt];
    int remain = [str intValue];
    int second = remain % 60;
    int minute = ((remain - second) / 60) % 60;
    int hour = (remain - second - minute * 60) / 3600;
    NSString * strHour = [NSString stringWithFormat:@"%ld", (long)hour];
    if(hour == 0){
       strHour = [NSString stringWithFormat:@"%@ Min", [NSString stringWithFormat:@"%d", minute]];
    }else{
        if(hour ==1 )
            strHour = [NSString stringWithFormat:@"%@ Hour", strHour];
        else
            strHour = [NSString stringWithFormat:@"%@ Hours", strHour];
    }
    if(remain < 0){
        igClock.hidden = YES;
        lbexphour.hidden = YES;
    }else{
        igClock.hidden = NO;
        lbexphour.hidden = NO;
    }
    
    [imgProfile setImageWithURL:[NSURL URLWithString:profilePath] placeholderImage:[UIImage imageNamed:@"place_man.png"]];
    imgProfile.layer.cornerRadius = imgProfile.layer.bounds.size.height/2;
    imgProfile.layer.masksToBounds = YES;

    [btnName setTitle:[NSString stringWithFormat:@"%@ %@", first_name, last_name] forState:UIControlStateNormal];
    [btnName sizeToFit];
    lbexphour.text = strHour;
    
    UIImageView * imgPhoto = [[UIImageView alloc]initWithFrame:CGRectMake(0,0,0,0)];
    [imgPhoto setImageWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@%@", PHOTO_URL, photo]] placeholderImage:[UIImage imageNamed:@"place_img.png"]];
    
    UIImageView * imgPhoto2 = [[UIImageView alloc]initWithFrame:CGRectMake(0,0,0,0)];
    [imgPhoto2 setImageWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@%@", PHOTO_URL, photo2]] placeholderImage:[UIImage imageNamed:@"place_img.png"]];
    
    UIImageView * imgPhoto3 = [[UIImageView alloc]initWithFrame:CGRectMake(0,0,0,0)];
    [imgPhoto3 setImageWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@%@", PHOTO_URL, photo3]] placeholderImage:[UIImage imageNamed:@"place_img.png"]];
    
    UIImageView * imgPhoto4 = [[UIImageView alloc]initWithFrame:CGRectMake(0,0,0,0)];
    [imgPhoto4 setImageWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@%@", PHOTO_URL, photo4]] placeholderImage:[UIImage imageNamed:@"place_img.png"]];
    
    if([like1 isEqualToString:@"0"]){
        like1 = @"";
    }
    if([like2 isEqualToString:@"0"]){
        like2 = @"";
    }
    if([like3 isEqualToString:@"0"]){
        like3 = @"";
    }
    if([like4 isEqualToString:@"0"]){
        like4 = @"";
    }
    if([like5 isEqualToString:@"0"]){
        like5 = @"";
    }
    if([like6 isEqualToString:@"0"]){
        like6 = @"";
    }
    if([like7 isEqualToString:@"0"]){
        like7 = @"";
    }
    if([like8 isEqualToString:@"0"]){
        like8 = @"";
    }
    if([like9 isEqualToString:@"0"]){
        like9 = @"";
    }
    if([like10 isEqualToString:@"0"]){
        like10 = @"";
    }
    if([like11 isEqualToString:@"0"]){
        like11 = @"";
    }
    if([like12 isEqualToString:@"0"]){
        like12 = @"";
    }
    
    [self dispLike56];

    CGRect frameBtnSetting = btnSetting.frame;
    frameBtnSetting.origin.x = [UIScreen mainScreen].bounds.size.width - frameBtnSetting.size.width - 14;
    btnSetting.frame = frameBtnSetting;

    
    CGRect fbtnStar = btnStar.frame;
    fbtnStar.origin.x = btnSetting.frame.origin.x - 39;
    btnStar.frame = fbtnStar;

    
    CGRect fscrImage = scrImage.frame;
    fscrImage.origin.x= 0;
    fscrImage.origin.y = 0;
    fscrImage.size.width = [UIScreen mainScreen].bounds.size.width;
    fscrImage.size.height= [UIScreen mainScreen].bounds.size.width * PHOTO_RATIO;
    scrImage.frame = fscrImage;
    
    
    CGRect vimgFrame = viewImage.frame;
    CGFloat vimgwidth  = [UIScreen mainScreen].bounds.size.width;
    CGFloat vimgheight =[UIScreen mainScreen].bounds.size.width * PHOTO_RATIO;
    
    CGRect fimg1 = imgPhoto.frame;
    fimg1.origin.y = 0;
    fimg1.origin.x = 0;
    fimg1.size.width = vimgwidth;
    fimg1.size.height = vimgheight;
    imgPhoto.frame = fimg1;
    
    
    if(photo2 != (id)[NSNull null] && photo2.length != 0){
        CGRect fimg2 = imgPhoto2.frame;
        fimg2.size.width = vimgwidth;
        fimg2.size.height = vimgheight;
        fimg2.origin.x = vimgwidth;
        imgPhoto2.frame = fimg2;
        
        viewlikeOne.hidden = NO;
        viewlikeTwo.hidden = YES;

        [scrImage addSubview:imgPhoto];
        [scrImage addSubview:imgPhoto2];
        scrImage.contentSize = CGSizeMake(vimgwidth * 2, vimgheight);
        moreIcon.hidden = NO;
        
        if(photo3 != (id)[NSNull null] && photo3.length != 0){
            CGRect fimg3 = imgPhoto3.frame;
            fimg3.origin.x = vimgwidth * 2;
            fimg3.origin.y = 0;
            fimg3.size.height = vimgheight;
            fimg3.size.width = vimgwidth;
            imgPhoto3.frame = fimg3;
            [scrImage addSubview:imgPhoto3];
            scrImage.contentSize = CGSizeMake(vimgwidth * 3, vimgheight);
            if(photo4 != (id)[NSNull null] && photo4.length != 0){
                CGRect fimg4 = imgPhoto4.frame;
                fimg4.origin.x = vimgwidth * 3;
                fimg4.origin.y = 0;
                fimg4.size.height = vimgheight;
                fimg4.size.width = vimgwidth;
                imgPhoto4.frame = fimg4;
                [scrImage addSubview:imgPhoto4];
                scrImage.contentSize = CGSizeMake(vimgwidth * 4, vimgheight);
            }
        }
        
    }else{
        viewlikeOne.hidden = NO;
        viewlikeTwo.hidden = YES;

        [scrImage addSubview:imgPhoto];
        scrImage.contentSize = CGSizeMake(vimgwidth, vimgheight);
        moreIcon.hidden = YES;
    }

    
    vimgFrame.size.width = vimgwidth;
    vimgFrame.size.height = vimgheight;
    viewImage.frame = vimgFrame;
    

    CGRect vlikFrame = viewlike.frame;
    CGFloat vlikY = vimgFrame.origin.y + vimgFrame.size.height;
    vlikFrame.origin.y = vlikY;
    viewlike.frame = vlikFrame;

    
    CGFloat szSubjW = lbSubj.frame.size.width;
    [lbSubj sizeToFit];
    CGRect lbsubFrame = lbSubj.frame;
    lbsubFrame.origin.y = vlikFrame.origin.y + vlikFrame.size.height + 20;
    lbsubFrame.size.width = szSubjW;
    lbSubj.frame = lbsubFrame;
    
   
    
    // divider line
    CGFloat scrWidth = [UIScreen mainScreen].bounds.size.width;
    CGRect frameLine = CGRectMake(scrWidth * 0.05, lbsubFrame.origin.y+ lbsubFrame.size.height + 10, scrWidth *0.9, 1);
    lbLine.frame = frameLine;
    
    [self addBrand:strBrand];
    CGRect lbbrandFrame = viewBrand.frame;
    lbbrandFrame.origin.y = frameLine.origin.y + frameLine.size.height + 10;
    viewBrand.frame = lbbrandFrame;
    
    CGRect vMFrame = viewMain.frame;
    vMFrame.size.width = [UIScreen mainScreen].bounds.size.width;
    
    viewCmt.hidden = NO;
    CGRect vcomFrame = viewCmt.frame;
    vcomFrame.origin.y = lbbrandFrame.origin.y + lbbrandFrame.size.height + 10;
    viewCmt.frame = vcomFrame;
    vMFrame.size.height = vcomFrame.origin.y + vcomFrame.size.height + 20;

    viewMain.frame = vMFrame;
    
    CGRect vcmtFrame = viewCnt.frame;
    vcmtFrame.origin.y = vMFrame.origin.y + vMFrame.size.height + 10;
    
    
    // add comment contents
    
    if(_arrComment.count > 0){
        
        viewCnt.hidden = NO;

        CGRect containerFrame = viewSample.frame;
        CGRect nameFrame = lbNameSample.frame;
        CGRect commFrame = lbComSample.frame;
        CGFloat commentHeight = 0;
        [self RemoveAllSubViews:viewCnt];
        for(int x=0; x < _arrComment.count; x++){
            NSMutableDictionary * commentI = [_arrComment objectAtIndex:x];
            NSString * strComfName = [commentI objectForKey:@"first_name"];
            NSString * strComlName = [commentI objectForKey:@"last_name"];
            NSString * strComName = [NSString stringWithFormat:@"%@ %@", strComfName, strComlName];
            NSString * strComment = [commentI objectForKey:@"comment"];
            NSData * commentData = [[NSData alloc] initWithBase64EncodedString:strComment options:0];
            NSString * comment = [[NSString alloc]initWithData:commentData encoding:NSUTF8StringEncoding];
            
            
            
            UILabel * lbName = [[UILabel alloc]initWithFrame:nameFrame];
            lbName.text = strComName;
            lbName.numberOfLines = 0;
            lbName.font = [UIFont fontWithName:@"Georgia" size:18];
            [lbName sizeToFit];
            lbName.textColor = mainGreenColor;

            UIButton * btnCmtName = [[UIButton alloc]initWithFrame:lbName.frame];
            btnCmtName.tag = x;
            [btnCmtName addTarget:self action:@selector(onClickCmtName:) forControlEvents:UIControlEventTouchUpInside];
            
            UILabel * lbComment=[[UILabel alloc]initWithFrame:commFrame];
            lbComment.text = comment;
            lbComment.font = [UIFont fontWithName:@"Georgia" size:18];
            lbComment.numberOfLines = 0;
            [lbComment sizeToFit];
            lbComment.textColor = mainGrayColor;

            UIButton * btnCmt = [[UIButton alloc]initWithFrame:lbComment.frame];
            btnCmt.tag = x;
            [btnCmt addTarget:self action:@selector(onDeleteCmt:) forControlEvents:UIControlEventTouchUpInside];
            
            CGRect endlbnameFrame = lbName.frame;
            CGRect endlbcommFrame = lbComment.frame;
            CGFloat endlbnameheight = endlbnameFrame.size.height;
            CGFloat endlbcommheight = endlbcommFrame.size.height;
            CGFloat endviewheight = MAX(endlbnameheight, endlbcommheight) + 20;
            
            UIView * viewCom = [[UIView alloc]initWithFrame:CGRectMake(containerFrame.origin.x, commentHeight, containerFrame.size.width, endviewheight)];
 
            commentHeight = commentHeight + endviewheight;
            [viewCom addSubview:lbName];
            [viewCom addSubview:lbComment];
            [viewCom addSubview:btnCmtName];
            [viewCom addSubview:btnCmt];
            [viewCnt addSubview:viewCom];
            
        }
        
        
        vcmtFrame.size.height = commentHeight + 80;
    }else{
        viewCnt.hidden = YES;
    }
    viewCnt.frame = vcmtFrame;

    CGRect vscrFrame = scrView.frame;
    vscrFrame.size.width = [UIScreen mainScreen].bounds.size.width;
    vscrFrame.size.height = vcmtFrame.origin.y + vcmtFrame.size.height;
    scrView.contentSize = CGSizeMake(vscrFrame.size.width, vscrFrame.size.height);
    _ScrolHeight = vscrFrame.size.height;
    // 60 + viewImage.frame.size.height + 50 + 10
}

-(void)addBrand:(NSString *) strBrand{
    if(strBrand.length > 2){
        strBrand = [strBrand substringWithRange:NSMakeRange(1, strBrand.length -2)];
    }

    NSArray * arrBrands = [strBrand componentsSeparatedByString:@","];
    
    NSInteger szBrand = [arrBrands count];
    if([strBrand isEqualToString:@""]){
        szBrand = 0;
    }
    [self RemoveAllSubViews:viewBrand];
    CGRect fbrandshow = viewBrand.frame;
    CGFloat screenWidth = [UIScreen mainScreen].bounds.size.width;
    CGFloat gap = 3;
    CGFloat height = 21;
    switch (szBrand) {
        case 0:
        {fbrandshow.size.height = 0;
            break;}
        case 1:
        {
            
            CGRect flb1 = CGRectMake(0, 0, screenWidth, height);
            UIButton * brd1 = [[UIButton alloc] initWithFrame:flb1];
            NSString * title1 = [arrBrands objectAtIndex:0];
            [self addBrandBtn:brd1:title1];
            
            fbrandshow.size.height = height;
            break;
        }
        case 2:
        {
            
            CGRect flb1 = CGRectMake(0, 0, screenWidth, height);
            UIButton * brd1 = [[UIButton alloc] initWithFrame:flb1];
            NSString * title1 = [arrBrands objectAtIndex:0];
            [self addBrandBtn:brd1:title1];
            
            CGRect flb2 = CGRectMake(0, height + gap, screenWidth, height);
            UIButton * brd2 = [[UIButton alloc] initWithFrame:flb2];
            NSString * title2 = [arrBrands objectAtIndex:1];
            [self addBrandBtn:brd2:title2];
            
            fbrandshow.size.height = height + (height + gap);
            break;
        }
        case 3:
        {
            
            CGRect flb1 = CGRectMake(0, 0, screenWidth, height);
            UIButton * brd1 = [[UIButton alloc] initWithFrame:flb1];
            NSString * title1 = [arrBrands objectAtIndex:0];
            [self addBrandBtn:brd1:title1];
            
            CGRect flb2 = CGRectMake(0, height + gap, screenWidth, height);
            UIButton * brd2 = [[UIButton alloc] initWithFrame:flb2];
            NSString * title2 = [arrBrands objectAtIndex:1];
            [self addBrandBtn:brd2:title2];
            
            CGRect flb3 = CGRectMake(0, (height + gap) * 2, screenWidth, height);
            UIButton * brd3 = [[UIButton alloc] initWithFrame:flb3];
            NSString * title3= [arrBrands objectAtIndex:2];
            [self addBrandBtn:brd3:title3];
            
            fbrandshow.size.height = height + (height + gap) * 2;
            break;
        }
        case 4:
        {
            
            CGRect flb1 = CGRectMake(0, 0, screenWidth, height);
            UIButton * brd1 = [[UIButton alloc] initWithFrame:flb1];
            NSString * title1 = [arrBrands objectAtIndex:0];
            [self addBrandBtn:brd1:title1];
            
            CGRect flb2 = CGRectMake(0, height + gap, screenWidth, height);
            UIButton * brd2 = [[UIButton alloc] initWithFrame:flb2];
            NSString * title2 = [arrBrands objectAtIndex:1];
            [self addBrandBtn:brd2:title2];
            
            CGRect flb3 = CGRectMake(0, (height + gap) * 2, screenWidth, height);
            UIButton * brd3 = [[UIButton alloc] initWithFrame:flb3];
            NSString * title3= [arrBrands objectAtIndex:2];
            [self addBrandBtn:brd3:title3];
            
            CGRect flb4 = CGRectMake(0, (height + gap) * 3, screenWidth, height);
            UIButton * brd4 = [[UIButton alloc] initWithFrame:flb4];
            NSString * title4 = [arrBrands objectAtIndex:3];
            [self addBrandBtn:brd4:title4];
            
            
            
            fbrandshow.size.height = height + ( height  + gap ) * 3;
            break;
        }
            
        default:
            break;
    }
    
    viewBrand.frame = fbrandshow;
}

-(void)addBrandBtn:(UIButton *) btn : (NSString *)title{

    NSString * sub2 = [self Decoding:title];
    sub2 = title;
    [btn setTitle:sub2 forState:UIControlStateNormal];
    btn.contentHorizontalAlignment = UIControlContentHorizontalAlignmentCenter;
    [btn setTitleColor:mainGreenColor forState:UIControlStateNormal];
    btn.titleLabel.font = [UIFont fontWithName:@"Georgia" size:17];
    [btn addTarget:self action:@selector(onClickBrand:) forControlEvents:UIControlEventTouchUpInside];
    [viewBrand addSubview:btn];
}





-(IBAction)onClickBack:(id)sender{
    [self goBack];
}
-(void)goBack{
    [self.navigationController popViewControllerAnimated:YES];
}
-(IBAction)onClickComm:(id)sender{
//    btnComment.hidden = YES;
//    tvComment.hidden = NO;
//    btnSendComm.hidden = NO;
}
-(IBAction)onClickSend:(id)sender{
    
    [self showBusyDialog];
    [self performSelector:@selector(sendComment) withObject:nil afterDelay:0.5];
}

-(void)sendComment{
    NSString * _comment = tvComment.text;
    if([_comment isEqualToString:@""]){
        UIAlertController * alert = [UIAlertController
                                     alertControllerWithTitle:@"Alert"
                                     message:@"Write comment"
                                     preferredStyle:UIAlertControllerStyleAlert];
        
        UIAlertAction* okButton = [UIAlertAction
                                   actionWithTitle:@"OK"
                                   style:UIAlertActionStyleDefault
                                   handler:^(UIAlertAction * action) {
                                       //Handle no, thanks button
                                   }];
        
        [alert addAction:okButton];
        [self presentViewController:alert animated:YES completion:nil];
        [self hideBusyDialog];
        return;
        
    }
    
    
    NSData *commentdata = [_comment dataUsingEncoding:NSUTF8StringEncoding];
    NSString *base64Encoded = [commentdata base64EncodedStringWithOptions:0];

//    btnComment.hidden = NO;
//    tvComment.hidden = YES;
//    btnSendComm.hidden = YES;
    
    NSMutableDictionary * params = [[NSMutableDictionary alloc]init];
    //    user_id, post_id, _token, comment
    NSString * user_id = [Global sharedGlobal].fbid;
    NSString * post_id = [NSString stringWithFormat:@"%@",_post_id];
    NSString * _token = [Global sharedGlobal].fbToken;
    [params setObject:user_id forKey:@"user_id"];
    [params setObject:post_id forKey:@"post_id"];
    [params setObject:_token forKey:@"_token"];
    [params setObject:base64Encoded forKey:@"comment"];
    NSDictionary * result = [UtilComm commentpost:params];
    if(result != nil){
        //NSDecimalNumber * deccode = [result objectForKey:@"code"];
        //NSString * code = [NSString stringWithFormat:@"%@", deccode];
        //NSString * data =  [result objectForKey:@"data"];
//        [APPDELEGATE showToastMessage:data];
        tvComment.text = @"";
        btnSendComm.hidden = YES;
        igTick.hidden = YES;
        [self showBusyDialog];
        [self performSelector:@selector(initData) withObject:nil afterDelay:0.5];
    }else{
//        btnComment.hidden = YES;
//        tvComment.hidden =NO;
//        btnSendComm.hidden = NO;
        
        [APPDELEGATE showToastMessage:@"Fail"];
    }

    [self hideBusyDialog];
}

-(IBAction)onClicklike:(UIButton *)sender{
    NSInteger mark = sender.tag;
    NSString * user_id = [Global sharedGlobal].fbid;
    if([user_id isEqualToString:fbid]){
        [self performSelector:@selector(goLikePage:) withObject:[NSString stringWithFormat:@"%ld",(long)mark] afterDelay:0.2];
        return;
    }
    [self showBusyDialog];
    [self performSelector:@selector(sendLike:) withObject:[NSString stringWithFormat:@"%ld",(long)mark] afterDelay:0.5];
}
-(void)goLikePage:(NSString *)mark{
    int like = [mark intValue];
    like = currentPage * 3 + like;
    mark = [NSString stringWithFormat:@"%d", like];
    
    LikeViewController * vc = [[LikeViewController alloc]initWithNibName:@"LikeViewController" bundle:nil];
    vc.post_id = _post_id;
    vc.like_num = mark;
    [self.navigationController pushViewController:vc animated:YES];
}
-(void)sendLike:(NSString *)mark{
    NSString * user_id = [Global sharedGlobal].fbid;
    NSString * _token = [Global sharedGlobal].fbToken;
    int like = [mark intValue];
    like = currentPage * 3 + like;
    mark = [NSString stringWithFormat:@"%d", like];

    //NSString * post_id = _post_id;
    
    NSString * likenum = mark;
    NSString * likeval = @"1";
    
   
    NSMutableDictionary * params = [[NSMutableDictionary alloc]init];
    [params setObject:user_id forKey:@"user_id"];
    [params setObject:_token forKey:@"_token"];
    [params setObject:_post_id forKey:@"post_id"];
    [params setObject:likenum forKey:@"likenum"];
    [params setObject:likeval forKey:@"likeval"];
    
    NSDictionary * result = [UtilComm addlike:params];
    if(result != nil){
        
        [self changeBtnBkImage:btn1 :NO];
        [self changeBtnBkImage:btn2 :NO];
        [self changeBtnBkImage:btn3 :NO];
        
        NSDecimalNumber * deccode = [result objectForKey:@"code"];
        NSString * code = [NSString stringWithFormat:@"%@",deccode];
        if([code isEqualToString:@"1"]){
            NSMutableDictionary * data = [result objectForKey:@"data"];
            like1 = [data objectForKey:@"like1"];
            like2 = [data objectForKey:@"like2"];
            like3 = [data objectForKey:@"like3"];
            like4 = [data objectForKey:@"like4"];
            
            like5 = [data objectForKey:@"like5"];
            like6 = [data objectForKey:@"like6"];
            like7 = [data objectForKey:@"like7"];
            like8 = [data objectForKey:@"like8"];
            
            like9 = [data objectForKey:@"like9"];
            like10 = [data objectForKey:@"like10"];
            like11 = [data objectForKey:@"like11"];
            like12 = [data objectForKey:@"like12"];
            
            me1 = [data objectForKey:@"me1"];
            me2 = [data objectForKey:@"me2"];
            me3 = [data objectForKey:@"me3"];
            me4 = [data objectForKey:@"me4"];
            
            me5 = [data objectForKey:@"me5"];
            me6 = [data objectForKey:@"me6"];
            me7 = [data objectForKey:@"me7"];
            me8 = [data objectForKey:@"me8"];
            
            me9 = [data objectForKey:@"me9"];
            me10 = [data objectForKey:@"me10"];
            me11 = [data objectForKey:@"me11"];
            me12 = [data objectForKey:@"me12"];
            
            if([like1 isEqualToString:@"0"]){
                like1 = @"";
            }
            if([like2 isEqualToString:@"0"]){
                like2 = @"";
            }
            if([like3 isEqualToString:@"0"]){
                like3 = @"";
            }
            if([like4 isEqualToString:@"0"]){
                like4 = @"";
            }
            if([like5 isEqualToString:@"0"]){
                like5 = @"";
            }
            if([like6 isEqualToString:@"0"]){
                like6 = @"";
            }
            if([like7 isEqualToString:@"0"]){
                like7 = @"";
            }
            if([like8 isEqualToString:@"0"]){
                like8 = @"";
            }
            if([like9 isEqualToString:@"0"]){
                like9 = @"";
            }
            if([like10 isEqualToString:@"0"]){
                like10 = @"";
            }
            if([like11 isEqualToString:@"0"]){
                like11 = @"";
            }
            if([like12 isEqualToString:@"0"]){
                like12 = @"";
            }
            
            
            [self dispLike56];
        }
    }
    [self hideBusyDialog];
}

-(void)changeBtnBkImage:(UIButton *)sender :(BOOL)flag{
    if(flag)
        [sender setBackgroundImage:[UIImage imageNamed:@"love_g.png"] forState:UIControlStateNormal];
    else
        [sender setBackgroundImage:[UIImage imageNamed:@"love.png"] forState:UIControlStateNormal];
    
}

-(void)dispLike56{
    if(currentPage == 0){
        lblike1.text = like1;
        lblike2.text = like2;
        lblike3.text = like3;
        
        [self changeBtnBkImage:btn1 :NO];
        [self changeBtnBkImage:btn2 :NO];
        [self changeBtnBkImage:btn3 :NO];
        
        if([me1 isEqualToString:@"1"]){
            [self changeBtnBkImage:btn1 :YES];
        }
        if([me2 isEqualToString:@"1"]){
            [self changeBtnBkImage:btn2 :YES];
        }
        if([me3 isEqualToString:@"1"]){
            [self changeBtnBkImage:btn3 :YES];
        }
    }else if(currentPage == 1){
        lblike1.text = like4;
        lblike2.text = like5;
        lblike3.text = like6;
        
        [self changeBtnBkImage:btn1 :NO];
        [self changeBtnBkImage:btn2 :NO];
        [self changeBtnBkImage:btn3 :NO];
        
        if([me4 isEqualToString:@"1"]){
            [self changeBtnBkImage:btn1 :YES];
        }
        if([me5 isEqualToString:@"1"]){
            [self changeBtnBkImage:btn2 :YES];
        }
        if([me6 isEqualToString:@"1"]){
            [self changeBtnBkImage:btn3 :YES];
        }
    }else if(currentPage == 2){
        lblike1.text = like7;
        lblike2.text = like8;
        lblike3.text = like9;
        
        [self changeBtnBkImage:btn1 :NO];
        [self changeBtnBkImage:btn2 :NO];
        [self changeBtnBkImage:btn3 :NO];
        
        if([me7 isEqualToString:@"1"]){
            [self changeBtnBkImage:btn1 :YES];
        }
        if([me8 isEqualToString:@"1"]){
            [self changeBtnBkImage:btn2 :YES];
        }
        if([me9 isEqualToString:@"1"]){
            [self changeBtnBkImage:btn3 :YES];
        }
    }else if(currentPage == 3){
        lblike1.text = like10;
        lblike2.text = like11;
        lblike3.text = like12;
        
        [self changeBtnBkImage:btn1 :NO];
        [self changeBtnBkImage:btn2 :NO];
        [self changeBtnBkImage:btn3 :NO];
        
        if([me10 isEqualToString:@"1"]){
            [self changeBtnBkImage:btn1 :YES];
        }
        if([me11 isEqualToString:@"1"]){
            [self changeBtnBkImage:btn2 :YES];
        }
        if([me12 isEqualToString:@"1"]){
            [self changeBtnBkImage:btn3 :YES];
        }
    }
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
            [btnSave setBackgroundImage:[UIImage imageNamed:@"tick.png"] forState:UIControlStateNormal];
        }else{
            [APPDELEGATE showToastMessage:data];
        }
    }else{
        [APPDELEGATE showToastMessage:@"Connection Error!"];
    }
    
    [self hideBusyDialog];

}
-(IBAction)onClickSetting:(id)sender{
    NSString * myfbid = [Global sharedGlobal].fbid;
    if([fbid isEqualToString:myfbid]){
        MyProfileSettingViewController * vc = [[MyProfileSettingViewController alloc]initWithNibName:@"MyProfileSettingViewController" bundle:nil];
        vc.post_id = _post_id;
        vc.imgUrl =  _imageUrl;
        vc.subject = subject;
        [self.navigationController pushViewController:vc animated:YES];
    }else{
        ReportViewController * vc = [[ReportViewController alloc]initWithNibName:@"ReportViewController" bundle:nil];
        vc.post_id = _post_id;
        [self.navigationController pushViewController:vc animated:YES];
    }
}

-(IBAction)onClickSrh:(id)sender{
    DressSearchViewController * vc = [[DressSearchViewController alloc]initWithNibName:@"DressSearchViewController" bundle:nil];
    [self.navigationController pushViewController:vc animated:YES];
}

-(void)onClickCmtName:(UIButton *)sender{
    NSInteger index = sender.tag;
    NSMutableDictionary * comItem = [_arrComment objectAtIndex:index];
    NSString * friend_id = [comItem objectForKey:@"friend_id"];
    
    
    NSString * myfbid = [Global sharedGlobal].fbid;
    if([friend_id isEqualToString:myfbid]){
        [Global sharedGlobal].whoProfile = friend_id;
        [[Global sharedGlobal] SaveParam];
        [[GolfMainViewController sharedInstance] changTab:1];
    }else{
        FriendProfileViewController * vc = [[FriendProfileViewController alloc]initWithNibName:@"FriendProfileViewController" bundle:nil];
        vc.friendid = friend_id;
        [self.navigationController pushViewController:vc animated:YES];
    }
 }

-(void)onDeleteCmt:(UIButton *)sender{
    NSInteger index = sender.tag;
    NSMutableDictionary * comItem = [_arrComment objectAtIndex:index];
    NSString * friend_id = [comItem objectForKey:@"friend_id"];
    NSString * myfbid = [Global sharedGlobal].fbid;
    if([myfbid isEqualToString:friend_id]){
        UIAlertController * alert = [UIAlertController
                                     alertControllerWithTitle:@"Alert"
                                     message:@"Are you sure you want to delete comment?"
                                     preferredStyle:UIAlertControllerStyleAlert];
        
        UIAlertAction* noButton = [UIAlertAction
                                   actionWithTitle:@"Yes"
                                   style:UIAlertActionStyleDefault
                                   handler:^(UIAlertAction * action) {
                                       //Handle no, thanks button
                                       [self showBusyDialog];
                                       [self performSelector:@selector(deleteComment:) withObject:sender afterDelay:0.3];
                                   }];
        UIAlertAction* okButton = [UIAlertAction
                                   actionWithTitle:@"No"
                                   style:UIAlertActionStyleDefault
                                   handler:^(UIAlertAction * action) {
                                       //Handle no, thanks button
                                   }];
        
        [alert addAction:noButton];
        [alert addAction:okButton];
        [self presentViewController:alert animated:YES completion:nil];
    }
    
}

-(void)deleteComment:(UIButton *)sender{
    NSInteger index = sender.tag;
    NSMutableDictionary * comItem = [_arrComment objectAtIndex:index];
    NSString * _token = [Global sharedGlobal].fbToken;
    NSString * comment_id = [comItem objectForKey:@"id"];
    NSString * friend_id = [comItem objectForKey:@"friend_id"];
    NSMutableDictionary * params = [[NSMutableDictionary alloc]init];
    [params setObject:friend_id forKey:@"friend_id"];
    [params setObject:comment_id forKey:@"comment_id"];
    [params setObject:_token forKey:@"_token"];
    NSDictionary * result = [UtilComm deletecomment:params];
    if(result != nil){
        NSDecimalNumber * deccode = [result objectForKey:@"code"];
        NSString * code = [NSString stringWithFormat:@"%@", deccode];
        if([code isEqualToString:@"1"]){
            [self showBusyDialog];
            [self performSelector:@selector(initData) withObject:nil afterDelay:0.3];
        }
    }

}
-(void)RemoveAllSubViews:(UIView *)sender{
    NSArray *viewsToRemove = [sender subviews];
    for (UIView *v in viewsToRemove) {
        [v removeFromSuperview];
    }
}

-(IBAction)onClickName:(id)sender{
    NSString * myfbid = [Global sharedGlobal].fbid;
    if([fbid isEqualToString:myfbid]){
        [Global sharedGlobal].whoProfile = fbid;
        [[Global sharedGlobal] SaveParam];
        [[GolfMainViewController sharedInstance] changTab:1];
    }else{
        FriendProfileViewController * vc = [[FriendProfileViewController alloc]initWithNibName:@"FriendProfileViewController" bundle:nil];
        vc.friendid = fbid;
        [self.navigationController pushViewController:vc animated:YES];
    }

}

-(void)onClickBrand:(UIButton *)sender{
    NSString * strBrand =sender.titleLabel.text;
    BrandViewController * vc = [[BrandViewController alloc]initWithNibName:@"BrandViewController" bundle:nil];
    vc.strBrand = strBrand;
    [self.navigationController pushViewController:vc animated:YES];
}

-(IBAction)onClickStar:(id)sender{
    ProductViewController * vc = [[ProductViewController alloc]initWithNibName:@"ProductViewController" bundle:nil];
    vc.post_id = _post_id;
    [self.navigationController pushViewController:vc animated:YES];
}
@end

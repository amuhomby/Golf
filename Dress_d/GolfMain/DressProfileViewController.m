//
//  DressProfileViewController.m
//  Dress_d
//
//  Created by MacAdmin on 9/13/17.
//  Copyright © 2017 dev. All rights reserved.
//

#import "DressProfileViewController.h"
#import "UIImageView+WebCache.h"
#import "PostDetailViewController.h"
#import "StylePostViewController.h"
#import "DressSearchViewController.h"
#import "SavePostDetailViewController.h"
#import "FriendListViewController.h"
#import "GolfMainViewController.h"
#import "MuteFriendViewController.h"
#import "SettingViewController.h"
@interface DressProfileViewController ()<UIScrollViewDelegate>
{
//    UIRefreshControl * refresh;
    NSString * type;
    
    NSString * direction;
    CGFloat lastContentOffset;

}
@end

@implementation DressProfileViewController
static DressProfileViewController * mainInstance;

+(DressProfileViewController *)sharedInstance{
    return mainInstance;
    
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    type = @"save";
    
    [btnSaveOutfit setTitleColor:mainGrayColor forState:UIControlStateNormal];
    [btnActvOutfit setTitleColor:mainGreenColor forState:UIControlStateNormal];

    if(mainInstance == nil)
        mainInstance = self;
   
    self.pongRefreshControl = [BOZPongRefreshControl attachToScrollView:scrV
                                                      withRefreshTarget:self
                                                       andRefreshAction:@selector(getDataRefresh)];
    self.pongRefreshControl.backgroundColor = [UIColor whiteColor];

    strBio = @"";
    UISwipeGestureRecognizer *swipe = [[UISwipeGestureRecognizer alloc] initWithTarget:self action:@selector(showPhoto)];
    // And assuming the "Up" direction in your screenshot is no accident
    swipe.direction = UISwipeGestureRecognizerDirectionRight;
    [viewBio addGestureRecognizer:swipe];

    
    UISwipeGestureRecognizer *swipeToCamera = [[UISwipeGestureRecognizer alloc] initWithTarget:self action:@selector(gotoCamera)];
    // And assuming the "Up" direction in your screenshot is no accident
    swipeToCamera.direction = UISwipeGestureRecognizerDirectionLeft;
    [scrV addGestureRecognizer:swipeToCamera];
    
    UISwipeGestureRecognizer *swipeToHome = [[UISwipeGestureRecognizer alloc] initWithTarget:self action:@selector(gotoHome)];
    // And assuming the "Up" direction in your screenshot is no accident
    swipeToHome.direction = UISwipeGestureRecognizerDirectionRight;
    [scrV addGestureRecognizer:swipeToHome];
    lastContentOffset = 0;
    
}

-(void)pullDown{
    lbTitle.hidden = NO;
    [UIView animateWithDuration:0.1 animations:^{
        [viewTop setFrame:CGRectMake(0, 0, viewTop.frame.size.width, 60)];
        CGFloat y = vwBack.frame.origin.y;
        if(y < 30)
            [vwBack setFrame:CGRectMake(0, 60, vwBack.frame.size.width, vwBack.frame.size.height - 40)];
    }];
}

-(void)pullUp{
    lbTitle.hidden = YES;
    [UIView animateWithDuration:0.1 animations:^{
        [viewTop setFrame:CGRectMake(0, 0, viewTop.frame.size.width, 20)];
        CGFloat y = vwBack.frame.origin.y;
        if(y > 30)
            [vwBack setFrame:CGRectMake(0, 20, vwBack.frame.size.width, vwBack.frame.size.height + 40)];
    }];
}


-(void)gotoCamera{
    CGRect ftb =scrV.frame;
    ftb.origin.x = -[UIScreen mainScreen].bounds.size.width;
    
    [UIView animateWithDuration:0.3 animations:^{
        scrV.frame = ftb;
    }completion:^(BOOL finished){
        CGRect ftb = scrV.frame;
        ftb.origin.x = 0;
        scrV.frame = ftb;
        [[GolfMainViewController sharedInstance] changTab:2];
    }];
    
}

-(void)gotoHome{
    CGRect ftb =scrV.frame;
    ftb.origin.x = [UIScreen mainScreen].bounds.size.width;
    
    [UIView animateWithDuration:0.3 animations:^{
        scrV.frame = ftb;
    }completion:^(BOOL finished){
        CGRect ftb = scrV.frame;
        ftb.origin.x = 0;
        scrV.frame = ftb;
        [[GolfMainViewController sharedInstance] changTab:0];
    }];
    
}

- (void)scrollViewDidScroll:(UIScrollView *)scrollView
{
    [self.pongRefreshControl scrollViewDidScroll];
    if([scrollView isEqual:scrV]){
        if(lastContentOffset > scrollView.contentOffset.y){
            direction = @"down";
        }else{
            direction = @"up";
        }
        if(scrollView.contentOffset.y < 0 ){
            if([direction isEqualToString:@"down"]){
                [self pullDown];
            }
        }
        if(scrollView.contentOffset.y > 0 ){
            if([direction isEqualToString:@"up"]){
                [self pullUp];
            }
        }
        
    }

}

- (void)scrollViewDidEndDragging:(UIScrollView *)scrollView willDecelerate:(BOOL)decelerate
{
    [self.pongRefreshControl scrollViewDidEndDragging];
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:YES];

    [self.navigationController setNavigationBarHidden:YES animated:NO];
    scrV.hidden = YES;
    viewBio.hidden = YES;
    [self performSelector:@selector(getData) withObject:nil afterDelay:0.05];//0.5
    [self pullDown];
}

-(void)viewWillDisappear:(BOOL)animated{
//    [self.pongRefreshControl finishedLoading];
}

-(void)getData{
    [self showBusyDialog];
    scrV.hidden = YES;
    [self performSelector:@selector(doInBackground) withObject:nil afterDelay:0.01];//0.1
}
-(void)getDataRefresh{
    [self performSelector:@selector(doInBackground) withObject:nil afterDelay:0.01];//0.1
}

-(void)doInBackground{
    [self ToTop:NO];
    profile_id = [[Global sharedGlobal]whoProfile];
    NSString * user_id = [Global sharedGlobal].fbid;
    NSString * _token = [Global sharedGlobal].fbToken;
    NSMutableDictionary * params = [[NSMutableDictionary alloc]init];
    [params setObject:user_id forKey:@"user_id"];
    [params setObject:profile_id forKey:@"friend_id"];
    [params setObject:_token forKey:@"_token"];
    NSDictionary * result = [UtilComm getpostbyuser:params];
    [self hideBusyDialog];
    [self.pongRefreshControl finishedLoading];
     if(result != nil){
        NSDecimalNumber * deccode = [result objectForKey:@"code"];
        NSString * code = [NSString stringWithFormat:@"%@",deccode];
       // NSString * data = [result objectForKey:@"data"];
        if([code isEqualToString:@"1"]){

            scrV.hidden = NO;
            
            arrAPost = [result objectForKey:@"activeposts"];
            arrSPost =[ result objectForKey:@"saveposts"];
            NSMutableSet * set = [NSMutableSet setWithArray:arrAPost];
            [set addObjectsFromArray:arrSPost];
            [arrAPost removeAllObjects];
            [arrSPost removeAllObjects];
            
            arrSPost =[NSMutableArray arrayWithArray:[set allObjects]];
            arrAPost =[NSMutableArray arrayWithArray:[set allObjects]];
            [self sortArray];

            arrStyle = [result objectForKey:@"userstyles"];
            NSMutableDictionary * user = [result objectForKey:@"user"];
            profile_ig = [user objectForKey:@"avatar"];
            send_invite =[result objectForKey:@"sentinvite"];
            profile_name = [NSString stringWithFormat:@"%@ %@", [user objectForKey:@"first_name"], [user objectForKey:@"last_name"]];
            szFriend = [NSString stringWithFormat:@"%@", [result objectForKey:@"friendcount"]];
          
            strBio = [result objectForKey:@"bio"];
            if(strBio != (id)[NSNull null] && strBio.length != 0)
            {
            }else{
                strBio = @"asd";
            }
            szMuteFriend =[NSString stringWithFormat:@"%@", [result objectForKey:@"mutefriendcount"]];

            [self initView];
        }else{

        }
    }
}
-(void)sortArray{
    NSSortDescriptor * dateDescriptor = [NSSortDescriptor sortDescriptorWithKey:@"createdtime" ascending:NO];
    NSArray * sortDescriptors = [NSArray arrayWithObject:dateDescriptor];
    arrAPost = [NSMutableArray arrayWithArray:[arrAPost sortedArrayUsingDescriptors:sortDescriptors]];
    
    if(![arrAPost isKindOfClass:[NSString class]]){
       if([arrAPost count] > 2){
           NSString * igurl1 = [[arrAPost objectAtIndex:0] objectForKey:@"photo"];
           NSString * igurl2 = [[arrAPost objectAtIndex:1] objectForKey:@"photo"];
           if([igurl1 isEqualToString:igurl2]){
               [arrAPost removeObjectAtIndex:0];
           }
       }
    }
    
    arrSPost = arrAPost;
}


-(void)initView{
    NSString * user_id = [Global sharedGlobal].fbid;
    if([user_id isEqualToString:profile_id]){
        viewMyProperty.hidden = NO;
        viewFriendProperty.hidden = YES;
        [btnMyBio addTarget:self action:@selector(onClickBio:) forControlEvents:UIControlEventTouchUpInside];
        [btnMyFri addTarget:self action:@selector(onClickFriend:) forControlEvents:UIControlEventTouchUpInside];
        lbMyFri.text = szFriend;
        btnDel.hidden = YES;
        
        [btnSetting addTarget:self action:@selector(onClickSetting) forControlEvents:UIControlEventTouchUpInside];
    }else{
        viewMyProperty.hidden = YES;
        viewFriendProperty.hidden = NO;
        
        [btnBio addTarget:self action:@selector(onClickBio:) forControlEvents:UIControlEventTouchUpInside];
        
        [btnMute addTarget:self action:@selector(onClickMute:) forControlEvents:UIControlEventTouchUpInside];
        
        [btnFri addTarget:self action:@selector(onClickFriend:) forControlEvents:UIControlEventTouchUpInside];
        
        lbMute.text = szMuteFriend;
        lbFriendNum.text = szFriend;

        btnDel.hidden = NO;
        [btnDel addTarget:self action:@selector(onClickDel) forControlEvents:UIControlEventTouchUpInside];
        if([send_invite isEqualToString:@"friend"])
            [btnDel setBackgroundImage:[UIImage imageNamed:@"tick.png"] forState:UIControlStateNormal];
        else if( [send_invite isEqualToString:@"sent"])
            [btnDel setBackgroundImage:[UIImage imageNamed:@"hourglass.png"] forState:UIControlStateNormal];
        else if([send_invite isEqualToString:@"none"])
            [btnDel setBackgroundImage:[UIImage imageNamed:@"addfriend.png"] forState:UIControlStateNormal];
        else
            [btnDel setBackgroundImage:[UIImage imageNamed:@"receive.png"] forState: UIControlStateNormal];

    }
    
    [self RemoveAllSubViews:vwStyle];
    [self RemoveAllSubViews:vwAImage];
    [self RemoveAllSubViews:vwSImage];
    
    CGFloat ruler = 0;
    // control profile view height
    CGRect fProfile = vwProfile.frame;
    CGRect fStyle = vwStyle.frame;

    igProfile.layer.cornerRadius = igProfile.bounds.size.height/2;
    igProfile.layer.masksToBounds = YES;
    [igProfile setImageWithURL:[NSURL URLWithString:profile_ig] placeholderImage:[UIImage imageNamed: @"place_man.png"]];
    
    lbName.text = profile_name;
    
    // add style buttons
    CGFloat rightEnd = 0;
    CGFloat bottomEnd = 0;
    CGFloat szhbtn = 0;
    
    
    for(int x=0; x < arrStyle.count;x++){
        
        NSMutableDictionary * styleItem = [arrStyle objectAtIndex:x];
        NSString * btnName = [styleItem objectForKey:@"name"];

        CGFloat gapHori = 6;
        CGFloat gapVer  = 5;
        CGFloat gapInner = 20;
        
        CGFloat szStyleW = fStyle.size.width;
        UIButton * btn = [[UIButton alloc]initWithFrame:CGRectMake(rightEnd, bottomEnd, 0, 0)];
        [btn setTitle:btnName forState:UIControlStateNormal];
        btn.titleLabel.font = [UIFont fontWithName:@"Georgia" size:18];

        [btn setBackgroundColor:mainGreenColor];
        [btn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        [btn sizeToFit];
        CGRect framebtn = btn.frame;
        szhbtn = framebtn.size.height;
        framebtn.size.width = framebtn.size.width + gapInner;
        btn.frame = framebtn;
        btn.layer.cornerRadius = btn.layer.bounds.size.height/2;
        btn.layer.masksToBounds = YES;

        btn.tag = x;
        [btn addTarget:self action:@selector(onClickStyle:) forControlEvents:UIControlEventTouchUpInside];
        
        if(rightEnd == 0){
            rightEnd = framebtn.size.width;
        }else{
            rightEnd = rightEnd + framebtn.size.width + gapHori;
            
            if(rightEnd <= szStyleW){

                framebtn.origin.x = framebtn.origin.x + gapHori;
                btn.frame = framebtn;
                
            }else{
                rightEnd = 0;
                bottomEnd = bottomEnd + framebtn.size.height + gapVer;
                framebtn.origin.x = rightEnd;
                framebtn.origin.y = bottomEnd;
                btn.frame = framebtn;
                rightEnd = framebtn.size.width;
            }
        }
        
        [vwStyle addSubview:btn];
    }
    fStyle.size.height = bottomEnd + szhbtn + 10;
    vwStyle.frame = fStyle;
    
    fProfile.size.height = MAX(igProfile.bounds.size.height, fStyle.size.height + fStyle.origin.y);
    vwProfile.frame = fProfile;
    
    ruler = ruler + fProfile.size.height;
    ruler += 10;
    CGRect fFriend = viewFriend.frame;
    fFriend.origin.y = ruler;
    viewFriend.frame = fFriend;
    
    ruler += fFriend.size.height + 10;
    //////////////////
    CGRect fva = vwA.frame;
    fva.origin.y = ruler;
    fva.size.height = 0;
    vwA.frame = fva;
    ruler = ruler + fva.size.height;
    
    ////////////////
    // add posted photos
    CGRect fvaimage = vwAImage.frame;
    fvaimage.origin.y = ruler;
    vwAImage.frame= fvaimage;
    
    CGFloat szGap  = 1;//[UIScreen mainScreen].bounds.size.width * 2/1000;
    CGFloat szImage = ([UIScreen mainScreen].bounds.size.width - szGap * 2)/3;
    CGFloat szGapTopBot = 20;
    int mul = 0;
    [self RemoveAllSubViews:vwAImage];
    if([type isEqualToString:@"active"]){
        for(int indexA=0; indexA < arrAPost.count; indexA++){
            NSMutableDictionary * apostItem = [arrAPost objectAtIndex:indexA];
            NSString * igUrl = [NSString stringWithFormat:@"%@%@", PHOTO_URL, [apostItem objectForKey:@"photo"]];
            NSString * igUrl2 = [NSString stringWithFormat:@"%@%@", PHOTO_URL, [apostItem objectForKey:@"photo2"]];
            
            int remainder = indexA%3;
            mul =(int)(indexA/3);
            
            CGFloat coorY = szGapTopBot + mul * (szImage* PHOTO_RATIO + szGap);
            CGFloat coorX = szGapTopBot;
            if(remainder == 0){
                coorX = 0;
            }else if(remainder ==1){
                coorX = szGap * 1 + szImage;
            }else if(remainder ==2){
                coorX = szGap * 2 + 2 * szImage;
            }
            UIView * vwigItem = [[UIView alloc]initWithFrame:CGRectMake(coorX, coorY, szImage, szImage* PHOTO_RATIO)];
            UIImageView * igmore = [[UIImageView alloc]initWithFrame:CGRectMake(szImage * 0.75, szImage * 0.05, szImage * 0.2, szImage * 0.2)];
            [igmore setImage:[UIImage imageNamed:@"more.png"]];
            [igmore setContentMode:UIViewContentModeScaleAspectFit];
            if([igUrl2 isEqualToString:PHOTO_URL]){
                igmore.hidden = YES;
            }else{
                igmore.hidden = NO;
            }
            UIImageView * ig = [[UIImageView alloc]initWithFrame:CGRectMake(0, 0, szImage, szImage* PHOTO_RATIO)];
            [ig setImageWithURL:[NSURL URLWithString:igUrl] placeholderImage:[UIImage imageNamed:@"place_img.png"]];
            ig.contentMode = UIViewContentModeScaleToFill;
            UIButton * btn = [[UIButton alloc]initWithFrame:CGRectMake(coorX, coorY, szImage, szImage* PHOTO_RATIO)];
            btn.tag = indexA;
            [btn addTarget:self action:@selector(onClickAPhoto:) forControlEvents:UIControlEventTouchUpInside];
            [vwigItem addSubview:ig];
            [vwigItem addSubview:igmore];
            [vwAImage addSubview:vwigItem];
            [vwAImage addSubview:btn];
        }
        
        CGFloat szvwaIgH = szGapTopBot*2 + (mul+1) * (szImage* PHOTO_RATIO + szGap);
        fvaimage.size.height = szvwaIgH;
        fvaimage.origin.x =0;
        vwAImage.frame = fvaimage;
        
        
        ruler = ruler + fvaimage.size.height;
    }else{
        NSString * firstImage = @""; // there seems to be sent active and save photo same when just posted.Check the first two items photo link is same ?
        
        for(int indexA=0; indexA < arrSPost.count; indexA++){
            NSMutableDictionary * apostItem = [arrSPost objectAtIndex:indexA];
            NSString * igUrl = [NSString stringWithFormat:@"%@%@", PHOTO_URL, [apostItem objectForKey:@"photo"]];
            NSString * igUrl2 = [NSString stringWithFormat:@"%@%@", PHOTO_URL, [apostItem objectForKey:@"photo2"]];
            if(indexA == 0){
                firstImage = igUrl;
            }
            
            if(indexA == 1){
                if([firstImage isEqualToString:igUrl]){
                    continue;
                }
            }
            int remainder = indexA%3;
            mul =(int)(indexA/3);
            
            CGFloat coorY = szGapTopBot + mul * (szImage* PHOTO_RATIO + szGap);
            CGFloat coorX = szGapTopBot;
            if(remainder == 0){
                coorX = 0;
            }else if(remainder ==1){
                coorX = szGap * 1 + szImage;
            }else if(remainder ==2){
                coorX = szGap * 2 + 2 * szImage;
            }
            UIView * vwigItem = [[UIView alloc]initWithFrame:CGRectMake(coorX, coorY, szImage, szImage* PHOTO_RATIO)];
            UIImageView * igmore = [[UIImageView alloc]initWithFrame:CGRectMake(szImage * 0.75, szImage * 0.05, szImage * 0.2, szImage * 0.2)];
            [igmore setImage:[UIImage imageNamed:@"more.png"]];
            [igmore setContentMode:UIViewContentModeScaleAspectFit];
            if([igUrl2 isEqualToString:PHOTO_URL]){
                igmore.hidden = YES;
            }else{
                igmore.hidden = NO;
            }
            UIImageView * ig = [[UIImageView alloc]initWithFrame:CGRectMake(0, 0, szImage, szImage* PHOTO_RATIO)];
            [ig setImageWithURL:[NSURL URLWithString:igUrl] placeholderImage:[UIImage imageNamed:@"place_img.png"]];
            ig.contentMode = UIViewContentModeScaleToFill;
            UIButton * btn = [[UIButton alloc]initWithFrame:CGRectMake(coorX, coorY, szImage, szImage* PHOTO_RATIO)];
            btn.tag = indexA;
            [btn addTarget:self action:@selector(onClickSPhoto:) forControlEvents:UIControlEventTouchUpInside];
            [vwigItem addSubview:ig];
            [vwigItem addSubview:igmore];
            [vwAImage addSubview:vwigItem];
            [vwAImage addSubview:btn];
        }
        
        CGFloat szvwaIgH = szGapTopBot*2 + (mul+1) * (szImage* PHOTO_RATIO + szGap);
        fvaimage.size.height = szvwaIgH;
        fvaimage.origin.x =0;
        vwAImage.frame = fvaimage;
        
        
        ruler = ruler + fvaimage.size.height;
    }
    
    
    
    
    
//
//
//    ////////////////
//    CGRect fvs = vwS.frame;
//    fvs.origin.y = ruler;
//    vwS.frame = fvs;
//    ruler = ruler + fvs.size.height;
//    
//    //////////////////
//    CGRect fvsimage = vwSImage.frame;
//    fvsimage.origin.y = ruler;
//    vwSImage.frame = fvsimage;
//    
//    int mulSave = 0;
//    for(int indexA=0; indexA < arrSPost.count; indexA++){
//        NSMutableDictionary * spostItem = [arrSPost objectAtIndex:indexA];
//        NSString * igUrl = [NSString stringWithFormat:@"%@%@", PHOTO_URL, [spostItem objectForKey:@"photo"]];
//        NSString * igUrl2 = [NSString stringWithFormat:@"%@%@", PHOTO_URL, [spostItem objectForKey:@"photo2"]];
//        int remainder = indexA%3;
//        mulSave =(int)(indexA/3);
//        
//        CGFloat coorY = szGapTopBot + mulSave * (szImage* PHOTO_RATIO + szGap);
//        CGFloat coorX = szGapTopBot;
//        if(remainder == 0){
//            coorX = 0;
//        }else if(remainder ==1){
//            coorX = szGap * 1 + szImage;
//        }else if(remainder ==2){
//            coorX = szGap * 2 + 2 * szImage;
//        }
//        UIView * vwigItem = [[UIView alloc]initWithFrame:CGRectMake(coorX, coorY, szImage, szImage* PHOTO_RATIO)];
//        UIImageView * igmore = [[UIImageView alloc]initWithFrame:CGRectMake(szImage * 0.75, szImage * 0.05, szImage * 0.2, szImage * 0.2)];
//        [igmore setImage:[UIImage imageNamed:@"more.png"]];
//        [igmore setContentMode:UIViewContentModeScaleAspectFit];
//        if([igUrl2 isEqualToString:PHOTO_URL]){
//            igmore.hidden = YES;
//        }else{
//            igmore.hidden = NO;
//        }
//        UIImageView * ig = [[UIImageView alloc]initWithFrame:CGRectMake(0, 0, szImage, szImage* PHOTO_RATIO)];
//        [ig setImageWithURL:[NSURL URLWithString:igUrl] placeholderImage:[UIImage imageNamed:@"place_img.png"]];
//        UIButton * btn = [[UIButton alloc]initWithFrame:CGRectMake(coorX, coorY, szImage, szImage * PHOTO_RATIO)];
//        ig.contentMode = UIViewContentModeScaleToFill;
//
//        btn.tag = indexA;
//        [btn addTarget:self action:@selector(onClickSPhoto:) forControlEvents:UIControlEventTouchUpInside];
//        [vwigItem addSubview:ig];
//        [vwigItem addSubview:igmore];
//        [vwSImage addSubview:vwigItem];
//        [vwSImage addSubview:btn];
//    }
//    CGFloat szvwsIgH = szGapTopBot*2 + (mulSave+1) * (szImage* PHOTO_RATIO + szGap);
//    fvsimage.size.height = szvwsIgH;
//    vwSImage.frame = fvsimage;
//    
//    ruler = ruler + fvsimage.size.height;
    
    /////////////////
    CGFloat height = [UIScreen mainScreen].bounds.size.height;
    if(ruler < height)
        ruler = height;
    scrV.contentSize = CGSizeMake([UIScreen mainScreen].bounds.size.width, ruler);
    
    
    NSData * bioData = [[NSData alloc] initWithBase64EncodedString:strBio options:0];
    NSString * bio = [[NSString alloc]initWithData:bioData encoding:NSUTF8StringEncoding];
    CGFloat wlbio = lbBio.frame.size.width;

    lbBio.text = bio;
    [lbBio sizeToFit];
    CGRect flbio = lbBio.frame;
    flbio.size.width = wlbio;
    lbBio.frame = flbio;

    CGRect fviewBio = viewBio.frame;
    CGFloat newOY = viewFriend.frame.origin.y + viewFriend.frame.size.height + 10;
    CGFloat newSH = fviewBio.origin.y - newOY + fviewBio.size.height;
    fviewBio.origin.y = newOY;
    fviewBio.size.height = newSH;
    viewBio.frame = fviewBio;
    
    CGRect fbc = viewParent.frame;

    fbc.size.height = lbBio.frame.size.height + lbBio.frame.origin.y + 20;
    if(fbc.size.height < fbc.size.width*0.3){
        fbc.size.height = fbc.size.width*0.3;
    }
    viewParent.frame = fbc;
    
    
    viewRealParent.frame = fbc;
    [self RemoveAllSubViews:viewRealParent];
    CGRect fcontainer = CGRectMake(0, 0, fbc.size.width, fbc.size.height);
    UIView * viewRealContainer = [[UIView alloc]initWithFrame:fcontainer];
    UIView * viewRealContent = [[UIView alloc]initWithFrame:fcontainer];
    [viewRealContent addSubview:lbBio];
    [viewRealContainer addSubview:viewRealContent];
    [viewRealParent addSubview:viewRealContainer];
    
    
//    viewRealContent.layer.cornerRadius = 20;
//    viewRealContent.layer.masksToBounds = YES;
//    viewRealContent.layer.borderColor = [UIColor colorWithRed:240/255.0 green:240/255.0 blue:240/255.0 alpha:0.8].CGColor;
//    viewRealContent.layer.borderWidth = 1;
//    
//    int r = 0;
//    viewRealContainer.layer.cornerRadius=r;
//    CGRect bounds2 = viewRealContainer.bounds;
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
//    [viewRealContainer.layer insertSublayer:maskLayer2 atIndex:0];

    [self showPhoto];

}
-(IBAction)onClickActvOutfit:(id)sender{
    type = @"active";

    [btnActvOutfit setTitleColor:mainGrayColor forState:UIControlStateNormal];
    [btnSaveOutfit setTitleColor:mainGreenColor forState:UIControlStateNormal];

    [self initView];
}

-(IBAction)onClickSaveOutfit:(id)sender{
    type = @"save";
    [btnSaveOutfit setTitleColor:mainGrayColor forState:UIControlStateNormal];
    [btnActvOutfit setTitleColor:mainGreenColor forState:UIControlStateNormal];

    [self initView];
}


-(void)onClickStyle:(UIButton *)sender{
    NSInteger index = sender.tag;
    NSDecimalNumber * decStyleNo = [[arrStyle objectAtIndex:index] objectForKey:@"id"];
    // profile_id
    NSString * noStyle = [NSString stringWithFormat:@"%@", decStyleNo];
    NSString * titleStyle = [[arrStyle objectAtIndex:index] objectForKey:@"name"];
    StylePostViewController * vc = [[StylePostViewController alloc]initWithNibName:@"StylePostViewController" bundle:nil];
    vc.style_id = noStyle;
    vc.friend_id = profile_id;
    vc.titleStyle = titleStyle;
    [self.navigationController pushViewController:vc animated:YES];
}

-(void)onClickAPhoto:(UIButton *)sender{
    NSInteger index = sender.tag;
    NSDecimalNumber * decPostid = [[arrAPost objectAtIndex:index] objectForKey:@"id"];
    NSString * post_id = [NSString stringWithFormat:@"%@", decPostid];

    PostDetailViewController * vc = [[PostDetailViewController alloc]initWithNibName:@"PostDetailViewController" bundle:nil];
    vc.post_id = post_id;
    vc.imageUrl = [[arrAPost objectAtIndex:index] objectForKey:@"photo"];
    
    NSString * user_id = [Global sharedGlobal].fbid;
    if([user_id isEqualToString:profile_id]){
        vc.fromView = @"";
    }else{
        if(![send_invite isEqualToString:@"friend"]){
            return;
        }
        vc.fromView = FROM_FRIEND;
    }
    [self.navigationController pushViewController:vc animated:YES];
    
}
-(void)onClickSPhoto:(UIButton *)sender{
    NSInteger index = sender.tag;
    NSDecimalNumber * decPostid = [[arrSPost objectAtIndex:index] objectForKey:@"id"];
    NSString * post_id = [NSString stringWithFormat:@"%@", decPostid];
    NSString * user_id = [Global sharedGlobal].fbid;
    SavePostDetailViewController * vc = [[SavePostDetailViewController alloc]initWithNibName:@"SavePostDetailViewController" bundle:nil];
    vc.post_id = post_id;
    if(![user_id isEqualToString:profile_id]){
        if(![send_invite isEqualToString:@"friend"]){
            return;
        }
    }
    
    [self.navigationController pushViewController:vc animated:YES];
    
}
-(void)onClickFriend:(UIButton *)sender{
    FriendListViewController * vc = [[FriendListViewController alloc]initWithNibName:@"FriendListViewController" bundle:nil];
    vc.user_id = profile_id;
    vc.name = profile_name;
    vc.showChk = @"no";
    [self.navigationController pushViewController:vc animated:YES];
}

-(void)onClickBio:(UIButton *)sender{
    [self showBio];
}

-(void)showBio{
    viewBio.hidden = NO;
    btnBack.hidden = NO;
    btnBackArrow.hidden =NO;
    CGFloat ruler =[UIScreen mainScreen].bounds.size.height-100;
    scrV.contentSize = CGSizeMake([UIScreen mainScreen].bounds.size.width, ruler);

}
-(IBAction)onClickProfile:(id)sender{
    [self showPhoto];
}

-(void)showPhoto{
    viewBio.hidden = YES;
    btnBackArrow.hidden = YES;
    btnBack.hidden = YES;
    CGFloat ruler =vwAImage.frame.size.height + vwAImage.frame.origin.y;
    CGFloat height = [UIScreen mainScreen].bounds.size.height;
    if(ruler < height)
        ruler = height;
    scrV.contentSize = CGSizeMake([UIScreen mainScreen].bounds.size.width, ruler);
    
    
}
-(void)onClickMute:(UIButton *)sender{
    MuteFriendViewController * vc = [[MuteFriendViewController alloc]initWithNibName:@"MuteFriendViewController" bundle:nil];
    vc.friend_id = profile_id;
    [self.navigationController pushViewController:vc animated:YES];
}





-(void)onClickDel{
    if([send_invite isEqualToString:@"friend"]){
        UIAlertController * alert = [UIAlertController
                                     alertControllerWithTitle:@"Alert"
                                     message:@"Are you sure you want to unfriend?"
                                     preferredStyle:UIAlertControllerStyleAlert];
        
        UIAlertAction* noButton = [UIAlertAction
                                   actionWithTitle:@"Yes"
                                   style:UIAlertActionStyleDefault
                                   handler:^(UIAlertAction * action) {
                                       //Handle no, thanks button
                                       [self showBusyDialog];
                                       [self performSelector:@selector(deleteFriend) withObject:nil afterDelay:0.3];
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
        return;
    }else if([send_invite isEqualToString:@"none"]){
        [self showBusyDialog];
        [self performSelector:@selector(sendInvite) withObject:nil afterDelay:0.3];
    }else if([send_invite isEqualToString:@"receive"]){
        [self showBusyDialog];
        [self performSelector:@selector(acceptfriend) withObject:nil afterDelay:0.3];
        return;
    }else{
        return;
    }
}

-(void)acceptfriend{
    
    NSString * user_id = [Global sharedGlobal].fbid;
    NSString * _token = [Global sharedGlobal].fbToken;
    NSMutableDictionary * params = [[NSMutableDictionary alloc]init];
    [params setObject:user_id forKey:@"myfb_id"];
    [params setObject:profile_id forKey:@"fb_id"];
    [params setObject:_token forKey:@"_token"];
    NSDictionary * result = [UtilComm accepttofriend:params];
    [self hideBusyDialog];
    if(result != nil){
        NSDecimalNumber * deccode = [result objectForKey:@"code"];
        NSString * code = [NSString stringWithFormat:@"%@", deccode];
        //NSString * data = [result objectForKey:@"data"];
        
        
        if([code isEqualToString:@"1"]){
            [self showBusyDialog];
            [self performSelector:@selector(getData) withObject:nil afterDelay:0.3];
        }else{
            [APPDELEGATE showToastMessage:@"Fail to accept"];
        }
        
    }else{
        [APPDELEGATE showToastMessage:CONNECT_ERROR];
    }
    
}

-(void)deleteFriend{
    NSString * user_id =[Global sharedGlobal].fbid;
    NSString * _token  = [Global sharedGlobal].fbToken;
    NSString * friend_id = profile_id;
    NSMutableDictionary * params = [[NSMutableDictionary alloc]init];
    [params setObject:user_id forKey:@"user_id"];
    [params setObject:_token forKey:@"_token"];
    [params setObject:friend_id forKey:@"friend_id"];
    NSDictionary * result = [UtilComm deletefriend:params];
    [self hideBusyDialog];
    if(result != nil){
        NSDecimalNumber * deccode = [result objectForKey:@"code"];
        NSString * code = [NSString stringWithFormat:@"%@", deccode];
        if([code isEqualToString:@"1"]){
            //NSString * data = [result objectForKey:@"data"];
            [self showBusyDialog];
            [self performSelector:@selector(getData) withObject:nil afterDelay:0.3];
        }else{
            [APPDELEGATE showToastMessage:@"Fail to delete"];
        }
    }else{
        [APPDELEGATE showToastMessage:CONNECT_ERROR];
    }
}
-(void)sendInvite{
    NSString * _nonfriend_id = profile_id;
    NSString * user_id = [Global sharedGlobal].fbid;
    NSString * _token = [Global sharedGlobal].fbToken;
    NSMutableDictionary * params = [[NSMutableDictionary alloc]init];
    [params setObject:user_id forKey:@"myfb_id"];
    [params setObject:_token forKey:@"_token"];
    [params setObject:_nonfriend_id forKey:@"fb_ids"];
    NSDictionary * result = [UtilComm invitetofriends:params];
    [self hideBusyDialog];
    if(result != nil){
        NSDecimalNumber * deccode = [result objectForKey:@"code"];
        NSString * code = [NSString stringWithFormat:@"%@", deccode];
        NSString * data = [result objectForKey:@"data"];
        if([code isEqualToString:@"1"]){
            [self showBusyDialog];
            [self performSelector:@selector(getData) withObject:nil afterDelay:0.3];
            
            [APPDELEGATE showToastMessage:data];
        }else{
            [APPDELEGATE showToastMessage:data];
        }
    }else{
        [APPDELEGATE showToastMessage:CONNECT_ERROR];
    }
    
}

-(void)RemoveAllSubViews:(UIView *)sender{
    NSArray *viewsToRemove = [sender subviews];
    for (UIView *v in viewsToRemove) {
        [v removeFromSuperview];
    }
}

-(IBAction)onClickSrh:(id)sender{
    DressSearchViewController * vc = [[DressSearchViewController alloc]initWithNibName:@"DressSearchViewController" bundle:nil];
    [self.navigationController pushViewController:vc animated:YES];
}

-(void)onClickSetting{
    SettingViewController * vc = [[SettingViewController alloc]initWithNibName:@"SettingViewController" bundle:nil];
    [self.navigationController pushViewController:vc animated:YES];
}
-(void)ToTop:(BOOL)flag{
    [scrV setContentOffset:CGPointZero animated:flag];
}

-(void)outLine:(UIButton *)btn :(NSString *)strTitle{
    btn.titleLabel.attributedText = [[NSAttributedString alloc] initWithString:strTitle attributes:@{NSStrokeColorAttributeName:[UIColor grayColor], NSForegroundColorAttributeName:[UIColor whiteColor], NSStrokeWidthAttributeName:@-3.0}];
}

-(void)nonoutLine:(UIButton *)btn :(NSString *)strTitle{
    btn.titleLabel.attributedText = [[NSAttributedString alloc] initWithString:strTitle attributes:@{NSStrokeColorAttributeName:[UIColor grayColor], NSForegroundColorAttributeName:[UIColor whiteColor], NSStrokeWidthAttributeName:@0.0}];
}
@end

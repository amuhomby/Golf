//
//  NonFProfViewController.m
//  Dress_d
//
//  Created by MacAdmin on 9/16/17.
//  Copyright © 2017 dev. All rights reserved.
//

#import "NonFProfViewController.h"
#import "UIImageView+WebCache.h"
#import "StylePostViewController.h"

@interface NonFProfViewController ()
{
    UIRefreshControl * refresh;
}
@end

@implementation NonFProfViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    refresh = [[UIRefreshControl alloc]init];
    [refresh addTarget:self action:@selector(getData) forControlEvents:UIControlEventValueChanged];
    [scrV insertSubview:refresh atIndex:0];
    
    UISwipeGestureRecognizer *swipe = [[UISwipeGestureRecognizer alloc] initWithTarget:self action:@selector(goBack)];
    // And assuming the "Up" direction in your screenshot is no accident
    swipe.direction = UISwipeGestureRecognizerDirectionRight;
    [scrV addGestureRecognizer:swipe];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];

    [btnInvite setBackgroundImage:[UIImage imageNamed: @"addfriend.png" ] forState:UIControlStateNormal];
    [self showBusyDialog];
    [self performSelector:@selector(getData) withObject:nil afterDelay:0.5];
    
}

-(void)getData{
    [self performSelector:@selector(doInbackground) withObject:nil afterDelay:0.2];
    
}

-(void)doInbackground{
    NSString * user_id = [Global sharedGlobal].fbid;
    NSString * _token = [Global sharedGlobal].fbToken;
    NSMutableDictionary * params = [[NSMutableDictionary alloc]init];
    [params setObject:user_id forKey:@"user_id"];
    [params setObject:_nonfriend_id forKey:@"friend_id"];
    [params setObject:_token forKey:@"_token"];
    NSDictionary * result = [UtilComm getpostbyuser:params];
    dispatch_async(dispatch_get_main_queue(), ^{
        if(refresh)
            [refresh endRefreshing];
    });
    
    if(result != nil){
        NSDecimalNumber * deccode = [result objectForKey:@"code"];
        NSString * code = [NSString stringWithFormat:@"%@",deccode];
        //NSString * data = [result objectForKey:@"data"];
        if([code isEqualToString:@"1"]){
            arrAPost = [result objectForKey:@"activeposts"];
            arrSPost =[ result objectForKey:@"saveposts"];

            NSMutableSet * set = [NSMutableSet setWithArray:arrAPost];
            [set addObjectsFromArray:arrSPost];
            [arrAPost removeAllObjects];
            [arrSPost removeAllObjects];
            
            arrSPost = [set allObjects];
            arrAPost = [set allObjects];

            
            arrStyle = [result objectForKey:@"userstyles"];
            NSMutableDictionary * user = [result objectForKey:@"user"];
            profile_ig = [user objectForKey:@"avatar"];
            send_invite =[result objectForKey:@"sentinvite"];
            profile_name = [NSString stringWithFormat:@"%@ %@", [user objectForKey:@"first_name"], [user objectForKey:@"last_name"]];
            [self initView];
            
        }else{
            
        }
    }
    [self hideBusyDialog];
    

}
-(void)initView{
    [self RemoveAllSubViews:vwStyle];
    [self RemoveAllSubViews:vwAImage];
    [self RemoveAllSubViews:vwSImage];
    
    if([send_invite isEqualToString:@"invite"]){
        [btnInvite setBackgroundImage:[UIImage imageNamed:@"hourglass.png"] forState:UIControlStateNormal];
    }else{
        [btnInvite setBackgroundImage:[UIImage imageNamed:@"addfriend.png"] forState:UIControlStateNormal];
    }
    
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
    
    CGFloat szImage = [UIScreen mainScreen].bounds.size.width * 330/1000;
    CGFloat szGap  = [UIScreen mainScreen].bounds.size.width *2/1000;
    CGFloat szGapTopBot = 20;
    int mul = 0;
    for(int indexA=0; indexA < arrAPost.count; indexA++){
        NSMutableDictionary * apostItem = [arrAPost objectAtIndex:indexA];
        NSString * igUrl = [NSString stringWithFormat:@"%@%@", PHOTO_URL, [apostItem objectForKey:@"photo"]];
        NSString * igUrl2 = [NSString stringWithFormat:@"%@%@", PHOTO_URL, [apostItem objectForKey:@"photo2"]];
        
        int remainder = indexA%3;
        mul =(int)(indexA/3);
        
        CGFloat coorY = szGapTopBot + mul * (szImage * PHOTO_RATIO+ szGap);
        CGFloat coorX = szGapTopBot;
        if(remainder == 0){
            coorX = szGap;
        }else if(remainder ==1){
            coorX = szGap * 2 + szImage;
        }else if(remainder ==2){
            coorX = szGap * 3 + 2 * szImage;
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
        UIImageView * ig = [[UIImageView alloc]initWithFrame:CGRectMake(0, 0, szImage, szImage * PHOTO_RATIO)];
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
    vwAImage.frame = fvaimage;
    
    
    ruler = ruler + fvaimage.size.height;
    
    ////////////////
    CGRect fvs = vwS.frame;
    fvs.origin.y = ruler;
    vwS.frame = fvs;
    ruler = ruler + fvs.size.height;
    
    //////////////////
    CGRect fvsimage = vwSImage.frame;
    fvsimage.origin.y = ruler;
    vwSImage.frame = fvsimage;
    
    int mulSave = 0;
    for(int indexA=0; indexA < arrSPost.count; indexA++){
        NSMutableDictionary * spostItem = [arrSPost objectAtIndex:indexA];
        NSString * igUrl = [NSString stringWithFormat:@"%@%@", PHOTO_URL, [spostItem objectForKey:@"photo"]];
        NSString * igUrl2 = [NSString stringWithFormat:@"%@%@", PHOTO_URL, [spostItem objectForKey:@"photo2"]];
        
        int remainder = indexA%3;
        mulSave =(int)(indexA/3);
        
        CGFloat coorY = szGapTopBot + mulSave * (szImage* PHOTO_RATIO + szGap);
        CGFloat coorX = szGapTopBot;
        if(remainder == 0){
            coorX = szGap;
        }else if(remainder ==1){
            coorX = szGap * 2 + szImage;
        }else if(remainder ==2){
            coorX = szGap * 3 + 2 * szImage;
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
        [vwSImage addSubview:vwigItem];
        [vwSImage addSubview:btn];

    }
    CGFloat szvwsIgH = szGapTopBot*2 + (mulSave+1) * (szImage* PHOTO_RATIO + szGap);
    fvsimage.size.height = szvwsIgH;
    vwSImage.frame = fvsimage;
    
    ruler = ruler + fvsimage.size.height;
    
    /////////////////
    scrV.contentSize = CGSizeMake([UIScreen mainScreen].bounds.size.width, ruler);
    
}

-(void)onClickStyle:(UIButton *)sender{
    
//    NSInteger index = sender.tag;
//    NSDecimalNumber * decStyleNo = [[arrStyle objectAtIndex:index] objectForKey:@"id"];
//    // profile_id
//    NSString * noStyle = [NSString stringWithFormat:@"%@", decStyleNo];
//    NSString * titleStyle = [[arrStyle objectAtIndex:index] objectForKey:@"name"];
//    StylePostViewController * vc = [[StylePostViewController alloc]initWithNibName:@"StylePostViewController" bundle:nil];
//    vc.style_id = noStyle;
//    vc.friend_id = _nonfriend_id;
//    vc.titleStyle = titleStyle;
//    [self.navigationController pushViewController:vc animated:YES];

}

-(void)onClickAPhoto:(UIButton *)sender{
//    NSInteger index = sender.tag;
//    NSDecimalNumber * decPostid = [[arrAPost objectAtIndex:index] objectForKey:@"id"];
//    NSString * post_id = [NSString stringWithFormat:@"%@", decPostid];
//    
//    PostDetailViewController * vc = [[PostDetailViewController alloc]initWithNibName:@"PostDetailViewController" bundle:nil];
//    vc.post_id = post_id;
//    vc.imageUrl = [[arrAPost objectAtIndex:index] objectForKey:@"photo"];
//    vc.fromView = FROM_FRIEND;
//    [self.navigationController pushViewController:vc animated:YES];
    
}
-(void)onClickSPhoto:(UIButton *)sender{
//    NSInteger index = sender.tag;
//    NSDecimalNumber * decPostid = [[arrSPost objectAtIndex:index] objectForKey:@"id"];
//    NSString * post_id = [NSString stringWithFormat:@"%@", decPostid];
}

-(IBAction)onClickBack:(id)sender{
    [self goBack];
}

-(void)goBack{
    [self.navigationController popViewControllerAnimated: YES];
}
-(IBAction)onClickInvite:(id)sender{
    if([send_invite isEqualToString:@"1"])
        return;
    [self showBusyDialog];
    [self performSelector:@selector(sendInvite) withObject:nil afterDelay:0.3];
}

-(void)sendInvite{
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
            [btnInvite setBackgroundImage:[UIImage imageNamed: @"hourglass.png" ] forState:UIControlStateNormal];
            
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


@end

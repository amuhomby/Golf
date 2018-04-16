//
//  StylePostViewController.m
//  Dress_d
//
//  Created by MacAdmin on 9/20/17.
//  Copyright © 2017 dev. All rights reserved.
//

#import "StylePostViewController.h"
#import "UIImageView+WebCache.h"
#import "DressSearchViewController.h"
#import "PostDetailViewController.h"

@interface StylePostViewController ()

@end

@implementation StylePostViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    arrPost = [[NSMutableArray alloc]init];
    arrSave = [[NSMutableArray alloc]init];
    arrAll  = [[NSMutableArray alloc]init];
    
    UISwipeGestureRecognizer *swipe = [[UISwipeGestureRecognizer alloc] initWithTarget:self action:@selector(goBack)];
    // And assuming the "Up" direction in your screenshot is no accident
    swipe.direction = UISwipeGestureRecognizerDirectionRight;
    [scrollview addGestureRecognizer:swipe];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:YES];

    [self showBusyDialog];
    [self performSelector:@selector(getData) withObject:nil afterDelay:0.5];
}

-(void)viewDidLayoutSubviews{
    [super viewDidLayoutSubviews];
    [self initView];

}
-(void)getData{
    [arrPost removeAllObjects];
    [arrSave removeAllObjects];
    [arrAll  removeAllObjects];
    NSString * user_id = [Global sharedGlobal].fbid;
    NSString * _token = [Global sharedGlobal].fbToken;
    NSMutableDictionary * params = [[NSMutableDictionary alloc]init];
    [params setObject:user_id forKey:@"user_id"];
    [params setObject:_token forKey:@"_token"];
    [params setObject:_friend_id forKey:@"friend_id"];
    [params setObject:_style_id forKey:@"style_id"];
    
    NSDictionary * result = [UtilComm getpostsbyuserstyle:params];
    if(result != nil){
        NSDecimalNumber * deccode = [result objectForKey:@"code"];
        NSString * code = [NSString stringWithFormat:@"%@", deccode];
        if([code isEqualToString:@"1"]){
            arrPost = [result objectForKey:@"activeposts"];
            arrSave = [result objectForKey:@"saveposts"];
            
            arrAll = arrPost;
            [arrAll addObjectsFromArray: arrSave];
        }else{
            NSString * data  =[result objectForKey:@"data"];
            
            [APPDELEGATE showToastMessage:data];
        }
        [self layoutControl];
    }else{
    }
    [self hideBusyDialog];

}

-(void)initView{
    [btnStyle setTitle:_titleStyle forState:UIControlStateNormal];
    [btnStyle sizeToFit];
    CGRect frame = btnStyle.frame;
    frame.size.width +=30;
    btnStyle.frame = frame;
    CGFloat cx = [UIScreen mainScreen].bounds.size.width/2;
    CGFloat cy = frame.origin.y + frame.size.height/2;
    btnStyle.center = CGPointMake(cx, cy);
    btnStyle.layer.cornerRadius = btnStyle.bounds.size.height/2;
    btnStyle.layer.masksToBounds = YES;
}

-(void)layoutControl{
    CGRect fvaimage = viewMain.frame;
    
   // CGFloat devicewidth = [UIScreen mainScreen].bounds.size.width;
    CGFloat szGap  = 1;//[UIScreen mainScreen].bounds.size.width * 2/1000;
    CGFloat szImage = ([UIScreen mainScreen].bounds.size.width - szGap * 2)/3;
    CGFloat szGapTopBot = 20;
    int mul = 0;
    for(int indexA=0; indexA < arrAll.count; indexA++){
        NSMutableDictionary * apostItem = [arrAll objectAtIndex:indexA];
        NSString * igUrl = [NSString stringWithFormat:@"%@%@", PHOTO_URL, [apostItem objectForKey:@"photo"]];
        NSString * igUrl2 = [NSString stringWithFormat:@"%@%@", PHOTO_URL, [apostItem objectForKey:@"photo2"]];

        int remainder = indexA%3;
        mul =(int)(indexA/3);
        
        CGFloat coorY = szGapTopBot + mul * (szImage *PHOTO_RATIO + szGap);
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
        [viewMain addSubview:vwigItem];
        [viewMain addSubview:btn];
    }
    
    CGFloat szvwaIgH = szGapTopBot*2 + (mul+1) * (szImage * PHOTO_RATIO + szGap);
    fvaimage.size.height = szvwaIgH;
    viewMain.frame = fvaimage;

    scrollview.contentSize = CGSizeMake(scrollview.frame.size.width, fvaimage.origin.y + fvaimage.size.height + 60);
}
-(void)onClickAPhoto:(UIButton *)sender{
    NSInteger index = sender.tag;
    NSDecimalNumber * decPostid = [[arrAll objectAtIndex:index] objectForKey:@"id"];
    NSString * post_id = [NSString stringWithFormat:@"%@", decPostid];
    
    PostDetailViewController * vc = [[PostDetailViewController alloc]initWithNibName:@"PostDetailViewController" bundle:nil];
    vc.post_id = post_id;
    vc.imageUrl = [[arrAll objectAtIndex:index] objectForKey:@"photo"];
    
    NSString * user_id = [Global sharedGlobal].fbid;
    if([user_id isEqualToString:_friend_id]){
        vc.fromView = @"";
    }else{
        vc.fromView = FROM_FRIEND;
    }
    [self.navigationController pushViewController:vc animated:YES];
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

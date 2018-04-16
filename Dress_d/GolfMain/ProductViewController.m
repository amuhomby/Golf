//
//  ProductViewController.m
//  Dress_d
//
//  Created by MacAdmin on 12/14/17.
//  Copyright © 2017 MacAdmin. All rights reserved.
//

#import "ProductViewController.h"
#import "UIImageView+WebCache.h"
#import "MyProfileSettingViewController.h"
#import "DressSearchViewController.h"
#import "GolfMainViewController.h"
#import "LikeViewController.h"
#import "FriendProfileViewController.h"
#import "BrandViewController.h"
#import "ReportViewController.h"

#define MEN @"men"
#define WOMEN @"women"
#define BOTH @"both"

#define LOW_PRICE @"LOW_PRICE"
#define MIDDLE_PRICE @"MIDDLE_PRICE"
#define HIGH_PRICE @"HIGH_PRICE"
#define ALL_PRICE @"ALL_PRICE"

@interface ProductViewController ()<UIScrollViewDelegate>
    {
        NSString * fbid;
        int currentPage;
        NSString * gender;
        NSString * priceOption;
    }

@end

@implementation ProductViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    fbid = @"";
    // Do any additional setup after loading the view from its nib.
    
    UISwipeGestureRecognizer *swipe = [[UISwipeGestureRecognizer alloc] initWithTarget:self action:@selector(goBack)];
    // And assuming the "Up" direction in your screenshot is no accident
    swipe.direction = UISwipeGestureRecognizerDirectionRight;
    [scrView addGestureRecognizer:swipe];
    
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
        gender = BOTH;
        priceOption = ALL_PRICE;
        
        [self showBusyDialog];
        scrView.hidden = YES;
        [self performSelector:@selector(initData) withObject:nil afterDelay:0.5]; //0.5
        
    }
- (void)viewWillDisappear:(BOOL)animated
    {
        [super viewWillDisappear:animated];
        
    }
    
-(void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView
    {
        int indexOfPage = scrollView.contentOffset.x / scrollView.frame.size.width;
        //your stuff with index
        currentPage = indexOfPage;
        [self showProduct];
    }
    
-(void)viewDidLayoutSubviews{
}
-(void)initData{
    //    user_id, post_id, _token
    _arrShop1= [[NSMutableArray alloc] init];
    _arrShop2= [[NSMutableArray alloc] init];
    _arrShop3= [[NSMutableArray alloc] init];
    _arrShop0= [[NSMutableArray alloc] init];
    
    NSMutableDictionary * params = [[NSMutableDictionary alloc]init];
    NSString * user_id = [Global sharedGlobal].fbid;
    NSString * _token = [Global sharedGlobal].fbToken;
    
    [params setObject:_post_id forKey:@"post_id"];
    [params setObject:_token forKey:@"_token"];
    [params setObject:user_id forKey:@"user_id"];
    NSDictionary * result = [UtilComm getshopstyle:params];
    if(result != nil){
        NSDecimalNumber *deccode = [result objectForKey:@"code"];
        NSString * code = [NSString stringWithFormat:@"%@", deccode];
        //NSString * data = [result objectForKey:@"data"];
        if([code isEqualToString:@"1"]){
            scrView.hidden = NO;
            
            _dicPostDetail = [result objectForKey:@"data"];
            userData = [result objectForKey:@"user"];
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
    
    fbid = [userData objectForKey:@"user_id"];
    NSString * first_name = [userData objectForKey:@"first_name"];
    NSString * last_name = [userData objectForKey:@"last_name"];
    NSString * profilePath = [userData objectForKey:@"avatar"];
    

    NSString * photo = [[_dicPostDetail objectAtIndex:0] objectForKey:@"photo"];
    NSString * photo2 = [[_dicPostDetail objectAtIndex:1] objectForKey:@"photo"];
    NSString * photo3 = [[_dicPostDetail objectAtIndex:2] objectForKey:@"photo"];  ///
    NSString * photo4 = [[_dicPostDetail objectAtIndex:3] objectForKey:@"photo"];  ///
    
    
    _arrShop0 = [[_dicPostDetail objectAtIndex:0] objectForKey:@"result"];
    _arrShop1 = [[_dicPostDetail objectAtIndex:1] objectForKey:@"result"];
    _arrShop2 = [[_dicPostDetail objectAtIndex:2] objectForKey:@"result"];
    _arrShop3 = [[_dicPostDetail objectAtIndex:3] objectForKey:@"result"];
    
    [self RemoveDuplication];
    
    [imgProfile setImageWithURL:[NSURL URLWithString:profilePath] placeholderImage:[UIImage imageNamed:@"place_man.png"]];
    imgProfile.layer.cornerRadius = imgProfile.layer.bounds.size.height/2;
    imgProfile.layer.masksToBounds = YES;
    
    [btnName setTitle:[NSString stringWithFormat:@"%@ %@", first_name, last_name] forState:UIControlStateNormal];
    [btnName sizeToFit];
    
    UIImageView * imgPhoto = [[UIImageView alloc]initWithFrame:CGRectMake(0,0,0,0)];
    [imgPhoto setImageWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@", photo]] placeholderImage:[UIImage imageNamed:@"place_img.png"]];
    
    UIImageView * imgPhoto2 = [[UIImageView alloc]initWithFrame:CGRectMake(0,0,0,0)];
    [imgPhoto2 setImageWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@", photo2]] placeholderImage:[UIImage imageNamed:@"place_img.png"]];
    
    UIImageView * imgPhoto3 = [[UIImageView alloc]initWithFrame:CGRectMake(0,0,0,0)];
    [imgPhoto3 setImageWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@", photo3]] placeholderImage:[UIImage imageNamed:@"place_img.png"]];
    
    UIImageView * imgPhoto4 = [[UIImageView alloc]initWithFrame:CGRectMake(0,0,0,0)];
    [imgPhoto4 setImageWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@",  photo4]] placeholderImage:[UIImage imageNamed:@"place_img.png"]];
    
    

    
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
        
        [scrImage addSubview:imgPhoto];
        scrImage.contentSize = CGSizeMake(vimgwidth, vimgheight);
        moreIcon.hidden = YES;
    }
    
    
    vimgFrame.size.width = vimgwidth;
    vimgFrame.size.height = vimgheight;
    viewImage.frame = vimgFrame;
    
//    CGRect fvwproduct = vwProduct.frame;
//    fvwproduct.origin.y = vimgFrame.origin.y + vimgFrame.size.height + 20;
//    vwProduct.frame = fvwproduct;
//    
//    CGRect vMFrame = viewMain.frame;
//    vMFrame.size.width = [UIScreen mainScreen].bounds.size.width;
//    vMFrame.size.height = fvwproduct.origin.y + fvwproduct.size.height;
//    viewMain.frame = vMFrame;
//    
//    
//    CGRect vscrFrame = scrView.frame;
//    vscrFrame.size.width = [UIScreen mainScreen].bounds.size.width;
//    vscrFrame.size.height = vMFrame.origin.y + vMFrame.size.height;
//    scrView.contentSize = CGSizeMake(vscrFrame.size.width, vscrFrame.size.height);
    // 60 + viewImage.frame.size.height + 50 + 10
    btnMan.selected = NO;
    btnWomen.selected = NO;
    btnMan.layer.cornerRadius = btnMan.frame.size.height/2;
    btnMan.layer.masksToBounds = YES;
    btnMan.layer.borderColor = mainGreenColor.CGColor;
    btnMan.layer.borderWidth = 1;
    
    btnWomen.layer.cornerRadius = btnMan.frame.size.height/2;
    btnWomen.layer.masksToBounds = YES;
    btnWomen.layer.borderColor = mainGreenColor.CGColor;
    btnWomen.layer.borderWidth = 1;
    
    CGPoint cenMan = CGPointMake(btn1.frame.origin.x+btn1.frame.size.width-5, btnMan.center.y);
    btnMan.center = cenMan;
    
    CGPoint cenWomen = CGPointMake(btn2.frame.origin.x+btn2.frame.size.width+5, btnWomen.center.y);
    btnWomen.center = cenWomen;
    
    
    btn1.selected = NO;
    btn2.selected = NO;
    btn3.selected = NO;
    
    [self seleteButton];
    [self selectPriceOption];
    [self showProduct];
}
-(void)seleteButton{
    
    [btnMan setBackgroundColor:UIColor.whiteColor];
    
    [btnWomen setBackgroundColor:UIColor.whiteColor];
    if(btnMan.selected == YES){
        [btnMan setTitleColor:[UIColor whiteColor] forState:UIControlStateSelected];
        [btnMan setBackgroundColor:mainGreenColor];
    }else{
        [btnMan setTitleColor:mainGreenColor forState:UIControlStateNormal];
        [btnMan setBackgroundColor:[UIColor whiteColor]];
    }

    if(btnWomen.selected == YES){
        [btnWomen setBackgroundColor:mainGreenColor];
        [btnWomen setTitleColor:[UIColor whiteColor] forState:UIControlStateSelected];
    }else{
        [btnWomen setTitleColor:mainGreenColor forState:UIControlStateNormal];
        [btnWomen setBackgroundColor:[UIColor whiteColor]];
    }
}

-(IBAction)onClickMen:(id)sender{
    BOOL sel = [btnMan isSelected];
    
    if(sel){
        btnMan.selected = NO;
        gender  = BOTH;
    }else{
        if(btnWomen.selected == YES){
            btnWomen.selected = NO;
        }
        btnMan.selected = YES;
        gender = MEN;
    }
    
    [self seleteButton];
    [self showProduct];
}

-(IBAction)onClickWomen:(id)sender{
    if(btnWomen.selected == YES){
        btnWomen.selected = NO;
        gender  = BOTH;
    }else{
        if(btnMan.selected == YES){
            btnMan.selected = NO;
        }
        btnWomen.selected = YES;
        gender = WOMEN;
    }
    
    [self seleteButton];
    [self showProduct];
}


-(void)selectPriceOption{
    if(btn1.selected){
        [btn1 setTitleColor:mainGrayColor forState:UIControlStateSelected];
    }else{
        [btn1 setTitleColor:mainGreenColor forState:UIControlStateNormal];
    }
    
    if(btn2.selected){
        [btn2 setTitleColor:mainGrayColor forState:UIControlStateSelected];
    }else{
        [btn2 setTitleColor:mainGreenColor forState:UIControlStateNormal];
    }
    
    if(btn3.selected){
        [btn3 setTitleColor:mainGrayColor forState:UIControlStateSelected];
    }else{
        [btn3 setTitleColor:mainGreenColor forState:UIControlStateNormal];
    }
}

-(IBAction)onClickPriceLow:(id)sender{
    if(btn1.selected){
        btn1.selected = NO;
        priceOption = ALL_PRICE;
    }else{
        btn1.selected = YES;
        btn2.selected = NO;
        btn2.selected = NO;
        priceOption = LOW_PRICE;
    }
    [self selectPriceOption];
    [self showProduct];
}

-(IBAction)onClickPriceMiddle:(id)sender{
    if(btn2.selected){
        btn2.selected =NO;
        priceOption = ALL_PRICE;
    }else{
        btn2.selected = YES;
        btn1.selected = NO;
        btn3.selected = NO;
        priceOption = MIDDLE_PRICE;
    }
    [self selectPriceOption];
    [self showProduct];
}

-(IBAction)onClickPriceHigh:(id)sender{
    if(btn3.selected){
        btn3.selected = NO;
        priceOption = ALL_PRICE;
    }else{
        btn3.selected = YES;
        btn1.selected = NO;
        btn2.selected = NO;
        priceOption = HIGH_PRICE;
    }
    [self selectPriceOption];
    [self showProduct];
}

-(IBAction)onClickBack:(id)sender{
    [self goBack];
}
    
-(void)goBack{
    [self.navigationController popViewControllerAnimated:YES];
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
    
   
-(void)showProduct{
    [self RemoveAllSubViews:vwProduct];
    CGFloat imageGap = 10;
    CGFloat hlbel = 14;

    CGFloat ratio = 0.45;
    CGFloat imageRatio = 1.3;
    CGFloat width = [UIScreen mainScreen].bounds.size.width * ratio;
    CGFloat height = width * imageRatio + imageGap + hlbel + imageGap + hlbel + imageGap;
    CGFloat one = [UIScreen mainScreen].bounds.size.width * (0.5 - ratio)/3 * 2;
    CGFloat two = [UIScreen mainScreen].bounds.size.width * 0.5 + one/2;
    
    CGFloat x = 0;
    CGFloat y = 0;
    CGFloat w = width;
    CGFloat h = height;
    
    CGFloat oneHeight = 0;
    CGFloat twoHeight = 0;
    CGFloat paddingBottom = 5;

    int count = -1;
    NSMutableArray * productData = [[NSMutableArray alloc]init];
    if(currentPage == 0){
        productData = _arrShop0;
    }else if(currentPage == 1){
        productData = _arrShop1;
    }else if(currentPage == 2){
        productData = _arrShop2;
    }else{
        productData = _arrShop3;
    }

    if([productData isKindOfClass:[NSMutableArray class]]){
        count =(int) [productData count];
        if(![gender isEqualToString:BOTH]){
            NSMutableArray * tempProduct = [[NSMutableArray alloc]init];
            for(int tIndex = 0; tIndex < count ; tIndex++){
                NSMutableDictionary * item = [productData objectAtIndex:tIndex];
                NSString * tgender = [[[item objectForKey:@"object"] objectForKey:@"metadata"] objectForKey:@"gender"];
                
                if([tgender isEqualToString:gender]){  // check gender
                    
                    NSString * tprice = [[[item objectForKey:@"object"] objectForKey:@"metadata"] objectForKey:@"price"];
                    int valPrice = [tprice intValue];
                    
                    if(valPrice >= 0 && valPrice <100 && [priceOption isEqualToString:LOW_PRICE]){
                        [tempProduct addObject:item];
                    }
                    
                    if(valPrice >= 100 && valPrice <500 && [priceOption isEqualToString:MIDDLE_PRICE]){
                        [tempProduct addObject:item];
                    }
                    
                    if(valPrice >= 1000 && [priceOption isEqualToString:HIGH_PRICE]){
                        [tempProduct addObject:item];
                    }
                    
                    if([priceOption isEqualToString:ALL_PRICE]){
                        [tempProduct addObject:item];
                    }
                    
                }
            }
            
            productData = tempProduct;
            count = [productData count];
        }else{
            NSMutableArray * tempProduct = [[NSMutableArray alloc]init];
            for(int tIndex = 0; tIndex < count ; tIndex++){
                NSMutableDictionary * item = [productData objectAtIndex:tIndex];
                
                NSString * tprice = [[[item objectForKey:@"object"] objectForKey:@"metadata"] objectForKey:@"price"];
                int valPrice = [tprice intValue];
                
                if(valPrice >= 0 && valPrice <100 && [priceOption isEqualToString:LOW_PRICE]){
                    [tempProduct addObject:item];
                }
                
                if(valPrice >= 100 && valPrice <500 && [priceOption isEqualToString:MIDDLE_PRICE]){
                    [tempProduct addObject:item];
                }
                
                if(valPrice >= 1000 && [priceOption isEqualToString:HIGH_PRICE]){
                    [tempProduct addObject:item];
                }
                
                if([priceOption isEqualToString:ALL_PRICE]){
                    [tempProduct addObject:item];
                }
            }
            
            productData = tempProduct;
            count = [productData count];

        }

        if(count > 0){
            for(NSInteger i=0; i < count;i++){
                
                
                NSString * photoUrl = [[[[productData objectAtIndex:i] objectForKey:@"object"] objectForKey:@"metadata" ] objectForKey:@"thumbnailUrl"];
                NSString * title  = [[[[productData objectAtIndex:i] objectForKey:@"object"] objectForKey:@"metadata" ] objectForKey:@"title"];
                NSString * currency = [[[[productData objectAtIndex:i] objectForKey:@"object"] objectForKey:@"metadata"] objectForKey:@"currency"];
                if([currency isEqualToString:@"USD"]){
                    currency = @"$";
                }
                NSString * price =[NSString stringWithFormat:@"%@",  [[[[productData objectAtIndex:i] objectForKey:@"object"] objectForKey:@"metadata"] objectForKey:@"price"]];
                price = [NSString stringWithFormat:@"%.2f", [price floatValue]];

                NSString * brand = [[[[productData objectAtIndex:i] objectForKey:@"object"] objectForKey:@"metadata"] objectForKey:@"brand"];
                
                NSString * genderInner = [[[[productData objectAtIndex:i] objectForKey:@"object"] objectForKey:@"metadata"] objectForKey:@"gender"];

                int xpos = i % 2;
                CGFloat ypos = (i - xpos)/2;
                
                w = width;
                h = height;
                
                if(xpos == 0){
                    x = one;
                }else{
                    x = two;
                }
                
                
                CGRect fviewCard = CGRectMake(x, y, w, h);
                UIView * viewCard = [[UIView alloc]initWithFrame:fviewCard];
                //        viewCard.layer.borderWidth = 1;
                //        viewCard.layer.borderColor = [UIColor lightGrayColor].CGColor;
                
                UIImageView * igCard = [[UIImageView alloc]initWithFrame:CGRectMake(imageGap/2, imageGap/2, width - imageGap, width * imageRatio - imageGap)];
                
                [igCard setImageWithURL:[NSURL URLWithString: photoUrl] ];
                igCard.contentMode = UIViewContentModeScaleAspectFit;
                
                UIButton * btn = [[UIButton alloc]initWithFrame:CGRectMake(0, 0, width, height)];
                btn.tag = i;
                [btn addTarget:self action:@selector(onClickProduct:) forControlEvents:UIControlEventTouchUpInside];
                
                UILabel * lbname = [[UILabel alloc]initWithFrame:CGRectMake(imageGap/2, igCard.frame.origin.y + igCard.frame.size.height + imageGap/2, width - 2 * imageGap, hlbel)];
                lbname.numberOfLines = 0;
                lbname.font = [UIFont fontWithName:@"Georgia" size:16];
                lbname.text = brand;
                
                [lbname sizeToFit];
                CGPoint nameCenter = lbname.center;
                nameCenter.x = w/2;
                lbname.center = nameCenter;
                
                [lbname setTextColor:mainGreenColor];
                
                UILabel * lbprice = [[UILabel alloc]initWithFrame:CGRectMake(imageGap/2, lbname.frame.origin.y + lbname.frame.size.height + imageGap/2, width - 2 * imageGap, hlbel)];
                lbprice.font = [UIFont fontWithName:@"Georgia" size:16];
                lbprice.text = [NSString stringWithFormat:@"%@ %@", currency, price];
                [lbprice sizeToFit];
                
                CGPoint priceCenter = lbprice.center;
                priceCenter.x = w/2;
                lbprice.center = priceCenter;
                
                [lbprice setTextColor:mainGreenColor];
                
                [viewCard addSubview:igCard];
                [viewCard addSubview:lbname];
                [viewCard addSubview:lbprice];
                [viewCard addSubview:btn];
                
                if(xpos == 0){
                    oneHeight = lbprice.frame.origin.y + lbprice.frame.size.height + paddingBottom;
                    fviewCard.size.height = oneHeight;
                    viewCard.frame = fviewCard;
                    if((i+1) == count){
                        y += (one + oneHeight);
                    }
                }else{
                    twoHeight = lbprice.frame.origin.y + lbprice.frame.size.height + paddingBottom;
                    CGFloat realheight = MAX(oneHeight, twoHeight);
                    y += (one + realheight);
                    fviewCard.size.height = twoHeight;
                    viewCard.frame = fviewCard;
                }
                
                [vwProduct addSubview:viewCard];
                
            }
        }
    
    }
    
    
    CGRect fvwButton = vwButton.frame;
    fvwButton.origin.y = viewImage.frame.origin.y + viewImage.frame.size.height + one;
    vwButton.frame = fvwButton;
    
    CGRect fviewproduct = vwProduct.frame;
    fviewproduct.origin.y =  vwButton.frame.origin.y + vwButton.frame.size.height + one;
    fviewproduct.size.height =   y;//    (height + one) * (ypos + xpos) ;
    vwProduct.frame = fviewproduct;
    
    CGRect vMFrame = viewMain.frame;
    vMFrame.size.width = [UIScreen mainScreen].bounds.size.width;
    vMFrame.size.height = fviewproduct.origin.y + fviewproduct.size.height;
    viewMain.frame = vMFrame;
    
    
    CGRect vscrFrame = scrView.frame;
    vscrFrame.size.width = [UIScreen mainScreen].bounds.size.width;
    vscrFrame.size.height = vMFrame.origin.y + vMFrame.size.height;
    scrView.contentSize = CGSizeMake(vscrFrame.size.width, vscrFrame.size.height);
}

-(void)onClickProduct:(UIButton *)sender{
    NSMutableArray * productData = [[NSMutableArray alloc]init];
    if(currentPage == 0){
        productData = _arrShop0;
    }else if(currentPage == 1){
        productData = _arrShop1;
    }else if(currentPage == 2){
        productData = _arrShop2;
    }else{
        productData = _arrShop3;
    }
    NSInteger count = -1;
    if([productData isKindOfClass:[NSMutableArray class]]){
        count =(int) [productData count];
        if(![gender isEqualToString:BOTH]){
            NSMutableArray * tempProduct = [[NSMutableArray alloc]init];
            for(int tIndex = 0; tIndex < count ; tIndex++){
                NSMutableDictionary * item = [productData objectAtIndex:tIndex];
                NSString * tgender = [[[item objectForKey:@"object"] objectForKey:@"metadata"] objectForKey:@"gender"];
                
                if([tgender isEqualToString:gender]){  // check gender
                    
                    NSString * tprice = [[[item objectForKey:@"object"] objectForKey:@"metadata"] objectForKey:@"price"];
                    int valPrice = [tprice intValue];
                    
                    if(valPrice >= 0 && valPrice <100 && [priceOption isEqualToString:LOW_PRICE]){
                        [tempProduct addObject:item];
                    }
                    
                    if(valPrice >= 100 && valPrice <500 && [priceOption isEqualToString:MIDDLE_PRICE]){
                        [tempProduct addObject:item];
                    }
                    
                    if(valPrice >= 1000 && [priceOption isEqualToString:HIGH_PRICE]){
                        [tempProduct addObject:item];
                    }
                    
                    if([priceOption isEqualToString:ALL_PRICE]){
                        [tempProduct addObject:item];
                    }
                    
                }
            }
            
            productData = tempProduct;
            count = [productData count];
        }else{
            NSMutableArray * tempProduct = [[NSMutableArray alloc]init];
            for(int tIndex = 0; tIndex < count ; tIndex++){
                NSMutableDictionary * item = [productData objectAtIndex:tIndex];
                
                NSString * tprice = [[[item objectForKey:@"object"] objectForKey:@"metadata"] objectForKey:@"price"];
                int valPrice = [tprice intValue];
                
                if(valPrice >= 0 && valPrice <100 && [priceOption isEqualToString:LOW_PRICE]){
                    [tempProduct addObject:item];
                }
                
                if(valPrice >= 100 && valPrice <500 && [priceOption isEqualToString:MIDDLE_PRICE]){
                    [tempProduct addObject:item];
                }
                
                if(valPrice >= 1000 && [priceOption isEqualToString:HIGH_PRICE]){
                    [tempProduct addObject:item];
                }
                
                if([priceOption isEqualToString:ALL_PRICE]){
                    [tempProduct addObject:item];
                }
            }
            
            productData = tempProduct;
            count = [productData count];
            
        }
    }
    if([productData isKindOfClass:[NSMutableArray class]]){
        NSInteger index = sender.tag;
        if([productData count] != 0){
            if(index > count){
                return;
            }
            NSString * productUrl = [[[[productData objectAtIndex:index] objectForKey:@"object"] objectForKey:@"metadata" ] objectForKey:@"extUrl"];
            [[UIApplication sharedApplication] openURL:[NSURL URLWithString: productUrl]];
        }
    }
}

-(void)RemoveDuplication{
    NSMutableArray * _arrShop00 = [[NSMutableArray alloc]init];
    NSMutableArray * _arrShop11 = [[NSMutableArray alloc]init];
    NSMutableArray * _arrShop22 = [[NSMutableArray alloc]init];
    NSMutableArray * _arrShop33 = [[NSMutableArray alloc]init];
    if([_arrShop0 isKindOfClass:[NSMutableArray class]]){
        NSInteger count = [_arrShop0 count];
        for(int index = 0;index < count;index ++){
            NSMutableDictionary * item = [_arrShop0 objectAtIndex:index];
            if(![self containProduct:item :_arrShop00]){
                [_arrShop00 addObject:item];
            }
        }
    }
    if([_arrShop1 isKindOfClass:[NSMutableArray class]]){
        NSInteger count = [_arrShop1 count];
        for(int index = 0;index < count;index ++){
            NSMutableDictionary * item = [_arrShop1 objectAtIndex:index];
            if(![self containProduct:item :_arrShop11]){
                [_arrShop11 addObject:item];
            }
        }
    }

    if([_arrShop2 isKindOfClass:[NSMutableArray class]]){
        NSInteger count = [_arrShop2 count];
        for(int index = 0;index < count;index ++){
            NSMutableDictionary * item = [_arrShop2 objectAtIndex:index];
            if(![self containProduct:item :_arrShop22]){
                [_arrShop22 addObject:item];
            }
        }
    }

    if([_arrShop3 isKindOfClass:[NSMutableArray class]]){
        NSInteger count = [_arrShop3 count];
        for(int index = 0;index < count;index ++){
            NSMutableDictionary * item = [_arrShop3 objectAtIndex:index];
            if(![self containProduct:item :_arrShop33]){
                [_arrShop33 addObject:item];
            }
        }
    }
    _arrShop0 = _arrShop00;
    _arrShop1 = _arrShop11;
    _arrShop2 = _arrShop22;
    _arrShop3 = _arrShop33;
    
}

-(BOOL)containProduct:(NSMutableDictionary *) item :(NSMutableArray *) arrProduct{
    if(![arrProduct isKindOfClass:[NSMutableArray class]]){
        return NO;
    }
    if([arrProduct count] == 0){
        return NO;
    }
    NSMutableDictionary * itemMeta = [[item objectForKey:@"object"] objectForKey:@"metadata"];
    NSInteger count = [arrProduct count];
    for(int index =0; index < count; index++){
        NSMutableDictionary * product = [arrProduct objectAtIndex:index];
        NSMutableDictionary * metadata = [[product objectForKey:@"object"] objectForKey:@"metadata"];
        if([itemMeta isEqual:metadata]){
            return YES;
        }
    }
    return NO;
}

@end

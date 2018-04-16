//
//  PerviewController.m
//  Dress_d
//
//  Created by MacAdmin on 1/5/18.
//  Copyright © 2018 MacAdmin. All rights reserved.
//

#import "PerviewController.h"
#import "UIImageView+WebCache.h"
#import "GolfMainViewController.h"

#define MEN @"men"
#define WOMEN @"women"
#define BOTH @"both"

#define LOW_PRICE @"LOW_PRICE"
#define MIDDLE_PRICE @"MIDDLE_PRICE"
#define HIGH_PRICE @"HIGH_PRICE"
#define ALL_PRICE @"ALL_PRICE"

@interface PerviewController ()
{
    NSString * fbid;
    NSString * gender;
    NSString * priceOption;
    CGFloat gap;
}
@end

@implementation PerviewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    fbid = @"";
    gap = 3;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    [[GolfMainViewController sharedInstance] hideTab:YES];

    self.navigationController.navigationBarHidden = YES;
    
    [UIView commitAnimations];
    
    gender = BOTH;
    priceOption = ALL_PRICE;
    
    [self initview];
    
}
- (void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    [[GolfMainViewController sharedInstance] hideTab:NO];
}
-(void)initData{
    //    user_id, post_id, _token
    _arrShop= [[NSMutableArray alloc] init];
    NSData *imgData1 = UIImageJPEGRepresentation(_imgData, 0.5);
 
    NSMutableDictionary * params = [[NSMutableDictionary alloc]init];
    NSString * user_id = [Global sharedGlobal].fbid;
    NSString * _token = [Global sharedGlobal].fbToken;
    
    [params setObject:_token forKey:@"_token"];
    [params setObject:user_id forKey:@"user_id"];
    NSDictionary * result = [UtilComm photopreview:@"photo1.jpg" :imgData1 :params];
    if(result != nil){
        NSDecimalNumber *deccode = [result objectForKey:@"code"];
        NSString * code = [NSString stringWithFormat:@"%@", deccode];
        //NSString * data = [result objectForKey:@"data"];
        if([code isEqualToString:@"1"]){
            vwButton.hidden = NO;
            vwOutfit.hidden = YES;
            _dicPostDetail = [result objectForKey:@"data"];
            _arrShop = [_dicPostDetail  objectForKey:@"result"];
            [self RemoveDuplication];
            [self showProduct];
        }else{
            [self.navigationController popViewControllerAnimated:YES];
        }
    }else{
        [self.navigationController popViewControllerAnimated:YES];
    }
    [self hideBusyDialog];
}


-(void)initview{
    
    
    imgPhoto.image =_imgData;

    CGRect fvwCancel = vwCancel.frame;
    fvwCancel.origin.y = 0 ;
    vwCancel.frame = fvwCancel;
    

    
    CGRect fvwImage = viewImage.frame;
    fvwImage.origin.x= 0;
    fvwImage.origin.y = fvwCancel.origin.y + fvwCancel.size.height + gap;
    fvwImage.size.width = [UIScreen mainScreen].bounds.size.width;
    fvwImage.size.height= [UIScreen mainScreen].bounds.size.width * PHOTO_RATIO;
    viewImage.frame = fvwImage;
    

//    CGRect fimg1 = imgPhoto.frame;
//    fimg1.origin.y = 0;
//    fimg1.origin.x = 0;
//    fimg1.size.width = fvwImage.size.width;
//    fimg1.size.height = fvwImage.size.height;
//    imgPhoto.frame = fimg1;
   
    CGRect fvwbtn = vwButton.frame;
    fvwbtn.origin.y = fvwImage.origin.y + fvwImage.size.height + gap + 10;
    vwButton.frame = fvwbtn;
    
    CGRect fvwoutfit = vwOutfit.frame;
    fvwoutfit.origin.y = fvwImage.origin.y + fvwImage.size.height + gap;
    if(fvwoutfit.size.height < [UIScreen mainScreen].bounds.size.height - 60 - fvwImage.size.height){
        fvwoutfit.size.height = [UIScreen mainScreen].bounds.size.height - 60 - fvwImage.size.height;
    }
    vwOutfit.frame = fvwoutfit;
    vwButton.hidden= YES;
    
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
    CGSize scrollSize = scrView.frame.size;
    CGFloat scrollheight = vwOutfit.frame.origin.y + vwOutfit.frame.size.height;
    scrView.contentSize = CGSizeMake(scrollSize.width, scrollheight);
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
-(IBAction)onClickCancel:(id)sender{
    [self.navigationController popViewControllerAnimated:NO];
    NSString * tabindex = [Global sharedGlobal].tabIndex;
    NSInteger index = [tabindex intValue];
    if(index ==0 ||index ==1 ||index ==3 ||index ==4){
        
    }else{
        index = 0;
    }
    [[GolfMainViewController sharedInstance] changTab:index];
}

-(IBAction)onClickCaption:(id)sender{
    [self.navigationController popViewControllerAnimated:NO];
}

-(IBAction)onClickStyle:(id)sender{
    [btnCaption setTitle:@"Caption" forState:UIControlStateNormal];
    [self showBusyDialog];
    [self performSelector:@selector(initData) withObject:nil afterDelay:0.5]; //0.5
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



-(void)showProduct{
    vwProduct.hidden = NO;
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
    productData = _arrShop;
    
    
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

                NSString * currency = [[[[productData objectAtIndex:i] objectForKey:@"object"] objectForKey:@"metadata"] objectForKey:@"currency"];
                if([currency isEqualToString:@"USD"]){
                    currency = @"$";
                }
                NSString * price =[NSString stringWithFormat:@"%@",  [[[[productData objectAtIndex:i] objectForKey:@"object"] objectForKey:@"metadata"] objectForKey:@"price"]];
                NSString * brand = [[[[productData objectAtIndex:i] objectForKey:@"object"] objectForKey:@"metadata"] objectForKey:@"brand"];
                
                
                int xpos = i % 2;
                
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
    
    CGRect fviewproduct = vwProduct.frame;
    fviewproduct.origin.y =  vwButton.frame.origin.y + vwButton.frame.size.height ;
    fviewproduct.size.height =   y;//    (height + one) * (ypos + xpos) ;
    vwProduct.frame = fviewproduct;
    
    CGRect vscrFrame = scrView.frame;
    vscrFrame.size.width = [UIScreen mainScreen].bounds.size.width;
    vscrFrame.size.height = fviewproduct.origin.y + fviewproduct.size.height + one;
    scrView.contentSize = CGSizeMake(vscrFrame.size.width, vscrFrame.size.height);
}

-(void)onClickProduct:(UIButton *)sender{
    NSMutableArray * productData = [[NSMutableArray alloc]init];
    productData = _arrShop;

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
    if([_arrShop isKindOfClass:[NSMutableArray class]]){
        NSInteger count = [_arrShop count];
        for(int index = 0;index < count;index ++){
            NSMutableDictionary * item = [_arrShop objectAtIndex:index];
            if(![self containProduct:item :_arrShop00]){
                [_arrShop00 addObject:item];
            }
        }
    }
 
    _arrShop = _arrShop00;
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

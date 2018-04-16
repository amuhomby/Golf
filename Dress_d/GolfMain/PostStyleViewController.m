//
//  PostStyleViewController.m
//  Dress_d
//
//  Created by MacAdmin on 9/14/17.
//  Copyright © 2017 dev. All rights reserved.
//

#import "PostStyleViewController.h"
#import "UIImageView+WebCache.h"

@interface PostStyleViewController ()

@end

@implementation PostStyleViewController

- (void)viewDidLoad {
    [super viewDidLoad];
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
-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];

}
-(void)initView{
    CGFloat bottom = 0;
    
    [btnStyle setTitle:_strStyle forState:UIControlStateNormal];
    [btnStyle sizeToFit];
    btnStyle.layer.cornerRadius = btnStyle.bounds.size.height/2;
    btnStyle.layer.masksToBounds = YES;
    
    bottom =bottom + vwStyle.bounds.size.height;
    
    CGRect fvimage = vwImage.frame;
    fvimage.origin.y = bottom;
    
    CGFloat szImage = [UIScreen mainScreen].bounds.size.width * 32/100;
    CGFloat szGap  = [UIScreen mainScreen].bounds.size.width /100;
    CGFloat szGapTopBot = 20;
    int mul = 0;
    for(int indexA=0; indexA < arrImage.count; indexA++){
        NSMutableDictionary * apostItem = [arrImage objectAtIndex:indexA];
        NSString * igUrl = [NSString stringWithFormat:@"%@%@", PHOTO_URL, [apostItem objectForKey:@"photo"]];
        
        int remainder = indexA%3;
        mul =(int)(indexA/3);
        
        CGFloat coorY = szGapTopBot + mul * (szImage + szGap);
        CGFloat coorX = szGapTopBot;
        if(remainder == 0){
            coorX = szGap;
        }else if(remainder ==1){
            coorX = szGap * 2 + szImage;
        }else if(remainder ==2){
            coorX = szGap * 3 + 2 * szImage;
        }
        
        UIImageView * ig = [[UIImageView alloc]initWithFrame:CGRectMake(coorX, coorY, szImage, szImage)];
        [ig setImageWithURL:[NSURL URLWithString:igUrl] placeholderImage:[UIImage imageNamed:@"place_img.png"]];
        UIButton * btn = [[UIButton alloc]initWithFrame:CGRectMake(coorX, coorY, szImage, szImage)];
        btn.tag = indexA;
        [btn addTarget:self action:@selector(onClickPhoto:) forControlEvents:UIControlEventTouchUpInside];
        [vwImage addSubview:ig];
        [vwImage addSubview:btn];
    }
    
    CGFloat szvwaIgH = szGapTopBot*2 + (mul+1) * (szImage + szGap);
    fvimage.size.height = szvwaIgH;
    vwImage.frame = fvimage;
    
    bottom = bottom + fvimage.size.height;
    
    scrView.contentSize = CGSizeMake([UIScreen mainScreen].bounds.size.width, bottom);
    
}

-(void)onClickPhoto:(UIButton *)sender{
    //NSInteger index = sender.tag;
    //NSMutableDictionary * photItem = [arrImage objectAtIndex:index];
    //NSString * post_id =[photItem objectForKey:@""];
}

@end

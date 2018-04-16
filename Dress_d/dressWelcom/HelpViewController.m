//
//  HelpViewController.m
//  Dress_d
//
//  Created by MacAdmin on 11/29/17.
//  Copyright © 2017 MacAdmin. All rights reserved.
//

#import "HelpViewController.h"
#import "dressStyleController.h"
#import "dressWelcomeController.h"
@interface HelpViewController ()<UIScrollViewDelegate>
{
    NSMutableArray * arrImage;
}

@end

@implementation HelpViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    UIView * statusBar = [[[UIApplication sharedApplication] valueForKey:@"statusBarWindow"] valueForKey:@"statusBar"];
    if([statusBar respondsToSelector:@selector(setBackgroundColor:)]){
        statusBar.backgroundColor = [UIColor colorWithRed:(157.0/255) green:(188.0/255) blue:(209.0/255) alpha:1.0];
    }

    // Do any additional setup after loading the view from its nib.
    arrImage = [[NSMutableArray alloc] init];
    [self performSelector:@selector(initView) withObject:nil afterDelay:0.3];
}

-(void)viewWillAppear:(BOOL)animated{

}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void)initView{
    [arrImage addObject:[UIImage imageNamed:@"1.png"]];
    [arrImage addObject:[UIImage imageNamed:@"2.png"]];
    [arrImage addObject:[UIImage imageNamed:@"2_5.png"]];
    [arrImage addObject:[UIImage imageNamed:@"3.png"]];
    [arrImage addObject:[UIImage imageNamed:@"4.png"]];
    [arrImage addObject:[UIImage imageNamed:@"5.png"]];
    [arrImage addObject:[UIImage imageNamed:@"6.png"]];
    [arrImage addObject:[UIImage imageNamed:@"7.png"]];
//    [arrImage addObject:[UIImage imageNamed:@"8.png"]];
    
    NSInteger szImage = [arrImage count];
    scrollview.contentSize = CGSizeMake([UIScreen mainScreen].bounds.size.width * (szImage + 1), [UIScreen mainScreen].bounds.size.height);
    CGRect fvwf = vwFirst.frame;
    fvwf.origin.x = 0;
    fvwf.origin.y = 0;
    fvwf.size.width = [UIScreen mainScreen].bounds.size.width;
    fvwf.size.height =[UIScreen mainScreen].bounds.size.height;
    vwFirst.frame = fvwf;
    [scrollview addSubview:vwFirst];
    
    for(int x = 0; x < [arrImage count]; x++){
        CGRect frame;
        frame.origin.x = scrollview.frame.size.width * (x + 1);
        frame.origin.y = 0;
        frame.size = scrollview.frame.size;
        UIImageView *imgView = [[UIImageView alloc] initWithFrame:frame];
        imgView.image = [arrImage objectAtIndex:x];
        imgView.contentMode = UIViewContentModeScaleAspectFill;
        [scrollview addSubview:imgView];
    }
}


- (void)scrollViewWillBeginDragging:(UIScrollView *)scrollView{
    CGFloat offsetX = scrollview.contentOffset.x;
    CGFloat MAX_OFFSET = scrollview.contentSize.width + 50;
    if(offsetX >= MAX_OFFSET){
        [self goAHead];
    }
}

-(void)scrollViewWillBeginDecelerating:(UIScrollView *)scrollView{
    CGFloat offsetX = scrollview.contentOffset.x + scrollview.frame.size.width;
    CGFloat MAX_OFFSET = scrollview.contentSize.width + 50;
    if(offsetX >= MAX_OFFSET){
        [self goAHead];
    }

}
-(void)goAHead{
    dressWelcomeController *venuView = [[dressWelcomeController alloc] initWithNibName:@"dressWelcomeController" bundle:nil];
    [self.navigationController pushViewController:venuView animated:YES];
}
@end

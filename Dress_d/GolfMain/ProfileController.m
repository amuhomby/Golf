//
//  ProfileController.m
//  Golf
//
//  Created by MacAdmin on 3/30/18.
//  Copyright © 2018 MacAdmin. All rights reserved.
//

#import "ProfileController.h"
#import "HCSStarRatingView.h"
#import "AnchorController.h"
#import "CollectionController.h"
#import "ShopOrderController.h"
#import "LessonController.h"
#import "PayProfileController.h"


@interface ProfileController ()
{
    HCSStarRatingView * starRatingView;

}
@end

@implementation ProfileController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    [self layoutControl];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void)layoutControl{
    _imgEdit.center = _btnEdit.center;
    _imgProfile.layer.cornerRadius = _imgProfile.frame.size.height/2;
    _imgProfile.layer.masksToBounds = YES;
    [_lbAnchor sizeToFit];
    _lbAnchorRed.center = CGPointMake(_lbAnchor.frame.origin.x + _lbAnchor.frame.size.width, _lbAnchor.frame.origin.y);
    [_lbCollection sizeToFit];
    _lbCollectionRed.center = CGPointMake(_lbCollection.frame.origin.x + _lbCollection.frame.size.width, _lbCollection.frame.origin.y);
    [_lbOrder sizeToFit];
    _lbOrderRed.center = CGPointMake(_lbOrder.frame.origin.x + _lbOrder.frame.size.width, _lbOrder.frame.origin.y);
    [_lbLesson sizeToFit];
    _lbLessonRed.center = CGPointMake(_lbLesson.frame.origin.x + _lbLesson.frame.size.width, _lbLesson.frame.origin.y);
    [_lbPay sizeToFit];
    _lbPayRed.center = CGPointMake(_lbPay.frame.origin.x + _lbPay.frame.size.width, _lbPay.frame.origin.y);
    
    
    _lbAnchorRed.layer.cornerRadius = _lbAnchorRed.frame.size.height/2;
    _lbAnchorRed.layer.masksToBounds = YES;
    _lbOrderRed.layer.cornerRadius = _lbOrderRed.frame.size.height/2;
    _lbOrderRed.layer.masksToBounds = YES;
    _lbCollectionRed.layer.cornerRadius = _lbCollectionRed.frame.size.height/2;
    _lbCollectionRed.layer.masksToBounds=YES;
    _lbLessonRed.layer.cornerRadius = _lbLessonRed.frame.size.height/2;
    _lbLessonRed.layer.masksToBounds=YES;
    _lbPayRed.layer.cornerRadius =_lbPayRed.frame.size.height/2;
    _lbPayRed.layer.masksToBounds=YES;
    
    
    starRatingView = [[HCSStarRatingView alloc] initWithFrame:CGRectMake(_vwRating.frame.size.width/4, 0 , _vwRating.frame.size.width * 2/4, _vwRating.frame.size.height)];
    starRatingView.maximumValue = 5;
    starRatingView.minimumValue = 0;
    starRatingView.value = 0;
    starRatingView.tintColor = [UIColor redColor];
    starRatingView.backgroundColor = [UIColor clearColor];
    starRatingView.userInteractionEnabled = NO;

    [_vwRating addSubview:starRatingView];
    
    starRatingView.emptyStarImage = [UIImage imageNamed:@"golf_star_g.png"];
    starRatingView.halfStarImage = [UIImage imageNamed:@"golf_star_g.png"]; // optional
    starRatingView.filledStarImage = [UIImage imageNamed:@"golf_crown1.png"];
    starRatingView.value = 4;
    
    CGRect fscrl = _scrollview.frame;
    CGRect fvback = _vwBack.frame;
    CGRect fvlast = _vwLast.frame;
    CGFloat bottom = fvlast.size.height + fvlast.origin.y+10;
    if(bottom > fvback.size.height){
        fscrl.size.height = bottom;
        _scrollview.contentSize = CGSizeMake(fscrl.size.width, bottom);
    }
}

-(IBAction)ClickAnchor:(id)sender{
    AnchorController * vc = [[AnchorController alloc]initWithNibName:@"AnchorController" bundle:nil];
    [self.navigationController pushViewController:vc animated:YES];
}

-(IBAction)ClickCollection:(id)sender{
    
    CollectionController * vc = [[CollectionController alloc]initWithNibName:@"CollectionController" bundle:nil];
    [self.navigationController pushViewController:vc animated:YES];
}

-(IBAction)ClickOrder:(id)sender{
    ShopOrderController * vc = [[ShopOrderController alloc]initWithNibName:@"ShopOrderController" bundle:nil];
    [self.navigationController pushViewController:vc animated:YES];}

-(IBAction)ClickLesson:(id)sender{
    LessonController * vc = [[LessonController alloc]initWithNibName:@"LessonController" bundle:nil];
    [self.navigationController pushViewController:vc animated:YES];
}

-(IBAction)ClickPay:(id)sender{
    PayProfileController * vc = [[PayProfileController alloc]initWithNibName:@"PayProfileController" bundle:nil];
    [self.navigationController pushViewController:vc animated:YES];}

-(IBAction)ClickEdit:(id)sender{
    
}

@end

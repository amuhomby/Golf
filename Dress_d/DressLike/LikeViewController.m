//
//  LikeViewController.m
//  Dress_d
//
//  Created by MacAdmin on 10/6/17.
//  Copyright © 2017 MacAdmin. All rights reserved.
//

#import "LikeViewController.h"
#import "dressAFTableViewCell.h"
#import "UIImageView+WebCache.h"
#import "GolfMainViewController.h"
#import "DressSearchViewController.h"
#import "FriendProfileViewController.h"


@interface LikeViewController ()<UITableViewDelegate, UITableViewDataSource, UIScrollViewDelegate>
{
    NSInteger nSelIndex;
}

@end

@implementation LikeViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    UISwipeGestureRecognizer *swipe = [[UISwipeGestureRecognizer alloc] initWithTarget:self action:@selector(goBack)];
    // And assuming the "Up" direction in your screenshot is no accident
    swipe.direction = UISwipeGestureRecognizerDirectionRight;
    [tbLike addGestureRecognizer:swipe];
    
    UISwipeGestureRecognizer *swipe2 = [[UISwipeGestureRecognizer alloc] initWithTarget:self action:@selector(goBack)];
    // And assuming the "Up" direction in your screenshot is no accident
    swipe.direction = UISwipeGestureRecognizerDirectionRight;

    [lbNotice addGestureRecognizer:swipe2];
    
    self.pongRefreshControl = [BOZPongRefreshControl attachToTableView:tbLike
                                                     withRefreshTarget:self
                                                      andRefreshAction:@selector(getData)];
    self.pongRefreshControl.backgroundColor = [UIColor whiteColor];
    
}
- (void)scrollViewDidScroll:(UIScrollView *)scrollView
{
    [self.pongRefreshControl scrollViewDidScroll];
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
    [super viewWillAppear:animated];

    [self.navigationController setNavigationBarHidden:YES animated:NO];
    lbNotice.hidden = YES;
    arrLike = [[NSMutableArray alloc]init];
    [self showBusyDialog];
    [self performSelector:@selector(getData) withObject:nil afterDelay:0.2];
    
}

-(void)viewWillDisappear:(BOOL)animated{
    [self.pongRefreshControl finishedLoading];
}
-(void)getData{
    [self performSelector:@selector(doInbackground) withObject:nil afterDelay:0.2];
}

-(void)doInbackground{
    NSMutableDictionary * param = [[NSMutableDictionary alloc]init];
    NSString * fbid = [Global sharedGlobal].fbid;
    NSString * _token = [Global sharedGlobal].fbToken;
    [param setObject:fbid forKey:@"user_id"];
    [param setObject:_token forKey:@"_token"];
    [param setObject:_post_id forKey:@"post_id"];
    [param setObject:_like_num forKey:@"like_num"];
    
//    NSMutableDictionary * result = [UtilComm friendlist:param];
    NSDictionary * result = [UtilComm likelist:param];
    [self hideBusyDialog];
    [self.pongRefreshControl finishedLoading];
    
    if(result != nil){
        NSDecimalNumber * deccode = [result objectForKey:@"code"];
        NSString * code = [NSString stringWithFormat:@"%@", deccode];
        if([code isEqualToString:@"1"]){
            arrLike = [result objectForKey:@"data"];
            if([arrLike count] == 0)
                lbNotice.hidden = NO;
            else
                lbNotice.hidden = YES;
            [tbLike reloadData];
        }else{
            lbNotice.hidden = NO;
        }
    }else{
        [APPDELEGATE showToastMessage:CONNECT_ERROR];
    }

}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return [arrLike count];
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    float h = 70;
    return h ;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    dressAFTableViewCell *cell = [[NSBundle mainBundle] loadNibNamed:@"dressAFTableViewCell" owner:self options:nil][0];
    
    NSMutableDictionary *row;
    //NSString * fbid;
    NSString * name;
    NSString * img ;
    
    
    row = [arrLike objectAtIndex:indexPath.row];
    name =[NSString stringWithFormat:@"%@ %@", [row objectForKey:@"first_name"],[row objectForKey:@"last_name"]];
    img = [row objectForKey:@"avatar"];
    
    cell.lbName.text = name;
    
    [cell.imgProfile setImageWithURL:[NSURL URLWithString:img] placeholderImage:[UIImage imageNamed:@"place_man.png"]];
//    [cell.btnChk setBackgroundImage:[UIImage imageNamed:@"tick.png"] forState:UIControlStateNormal];
//    cell.btnChk.tag = indexPath.row;
//    [cell.btnChk addTarget:self action:@selector(onClickDel:) forControlEvents:UIControlEventTouchUpInside];
    
    cell.btnHead.tag = indexPath.row;
    cell.btnName.tag = indexPath.row;
    
    [cell.btnHead addTarget:self action:@selector(onClickHead1:) forControlEvents:UIControlEventTouchUpInside];
    [cell.btnName addTarget:self action:@selector(onClickHead1:) forControlEvents:UIControlEventTouchUpInside];
    return cell;
}

-(void)onClickHead1:(UIButton *)sender{
    NSInteger index = sender.tag;
    NSMutableDictionary * friend ;
    NSString * whoprofile;
    
    friend = [arrLike objectAtIndex:index];
    whoprofile = [friend objectForKey:@"friend_id"];
    
    
    NSString * myfbid = [Global sharedGlobal].fbid;
    if([whoprofile isEqualToString:myfbid]){
        [Global sharedGlobal].whoProfile = whoprofile;
        [[Global sharedGlobal] SaveParam];
        [[GolfMainViewController sharedInstance] changTab:1];
    }else{
        FriendProfileViewController * vc = [[FriendProfileViewController alloc]initWithNibName:@"FriendProfileViewController" bundle:nil];
        vc.friendid = whoprofile;
        [self.navigationController pushViewController:vc animated:YES];
    }
    
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

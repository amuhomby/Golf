//
//  NotificationViewController.m
//  Dress_d
//
//  Created by MacAdmin on 9/16/17.
//  Copyright © 2017 dev. All rights reserved.
//

#import "NotificationViewController.h"
#import "NotiExpCell.h"
#import "NotirateCell.h"
#import "NotiInviteCell.h"
#import "UIImageView+WebCache.h"
#import "GolfMainViewController.h"
#import "PostDetailViewController.h"
#import "ExpirePostViewController.h"
#import "DressSearchViewController.h"
#import "FriendProfileViewController.h"
#import "LoadingCell.h"
#import "SVProgressHUD.h"

@interface NotificationViewController ()<UITableViewDelegate, UITableViewDataSource>
{
    NSInteger nSelIndex;
    BOOL bLoadMore;
    NSInteger  _pageNo;
    NSString * direction;
    CGFloat lastContentOffset;
    
}
@end

@implementation NotificationViewController


static NotificationViewController* _sharedNotifi = nil;

+ (NotificationViewController*)sharedNotifi;
{
    return _sharedNotifi;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    [self.navigationController setNavigationBarHidden:YES animated:NO];
    arrNot = [[NSMutableArray alloc]init];
    
    _sharedNotifi = self;
    
    self.pongRefreshControl = [BOZPongRefreshControl attachToTableView:tbNoti
                                                     withRefreshTarget:self
                                                      andRefreshAction:@selector(getData)];
    self.pongRefreshControl.backgroundColor = [UIColor whiteColor];
    
    
    UISwipeGestureRecognizer *swipeToCamera = [[UISwipeGestureRecognizer alloc] initWithTarget:self action:@selector(gotoCamera)];
    // And assuming the "Up" direction in your screenshot is no accident
    swipeToCamera.direction = UISwipeGestureRecognizerDirectionRight;
    [tbNoti addGestureRecognizer:swipeToCamera];


    UISwipeGestureRecognizer *swipeToSearch = [[UISwipeGestureRecognizer alloc] initWithTarget:self action:@selector(gotoSearch)];
    // And assuming the "Up" direction in your screenshot is no accident
    swipeToSearch.direction = UISwipeGestureRecognizerDirectionLeft;
    [tbNoti addGestureRecognizer:swipeToSearch];
    
    
    UISwipeGestureRecognizer *swipeToCamerav = [[UISwipeGestureRecognizer alloc] initWithTarget:self action:@selector(gotoCamera)];
    // And assuming the "Up" direction in your screenshot is no accident
    swipeToCamerav.direction = UISwipeGestureRecognizerDirectionRight;
    [viewNo addGestureRecognizer:swipeToCamerav];
    
    
    UISwipeGestureRecognizer *swipeToSearchv = [[UISwipeGestureRecognizer alloc] initWithTarget:self action:@selector(gotoSearch)];
    // And assuming the "Up" direction in your screenshot is no accident
    swipeToSearchv.direction = UISwipeGestureRecognizerDirectionLeft;
    [viewNo addGestureRecognizer:swipeToSearchv];
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


- (void)scrollViewDidScroll:(UIScrollView *)scrollView
{
    [self.pongRefreshControl scrollViewDidScroll];
    if([scrollView isEqual:tbNoti]){
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

-(void)gotoCamera{
    
    CGRect ftb = vwBack.frame;
    ftb.origin.x = [UIScreen mainScreen].bounds.size.width;
    
    [UIView animateWithDuration:0.3 animations:^{
        vwBack.frame = ftb;
    }completion:^(BOOL finished){
        CGRect ftb = vwBack.frame;
        ftb.origin.x = 0;
        vwBack.frame = ftb;
        [[GolfMainViewController sharedInstance] changTab:2];
    }];

}

-(void)gotoSearch{
    
    CGRect ftb = vwBack.frame;
    ftb.origin.x = -[UIScreen mainScreen].bounds.size.width;
    
    [UIView animateWithDuration:0.3 animations:^{
        vwBack.frame = ftb;
    }completion:^(BOOL finished){
        CGRect ftb = vwBack.frame;
        ftb.origin.x = 0;
        vwBack.frame = ftb;
        [[GolfMainViewController sharedInstance] changTab:4];
    }];
    
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];

    [self showBusyDialog];
    [self performSelector:@selector(getData) withObject:nil afterDelay:0.01]; // 0.5
    [self pullDown];

}

//Resetting the refresh control if the user leaves the screen
- (void)viewWillDisappear:(BOOL)animated
{
//    [self.pongRefreshControl finishedLoading];
}

#pragma mark - Notifying the pong refresh control of scrolling

- (void)scrollViewDidEndDragging:(UIScrollView *)scrollView willDecelerate:(BOOL)decelerate
{
    [self.pongRefreshControl scrollViewDidEndDragging];
}

-(void)getData
{
    bLoadMore = NO;
    _pageNo = 0;

    [self performSelector:@selector(doInbackground) withObject:nil afterDelay:0.01]; //0.2
}

-(void)doInbackground{
    NSUserDefaults  *defaults = [NSUserDefaults standardUserDefaults];
    [defaults setValue:@"0" forKey:@"noti_count"];
    [defaults synchronize];
    
    self.tabBarItem.badgeValue = nil;
    GolfMainViewController *mainVC = [GolfMainViewController sharedInstance];
    [[mainVC viewControllers] objectAtIndex:3].tabBarItem.badgeValue = nil;
    
    
    NSString * user_id = [Global sharedGlobal].fbid;
    NSString * _token  = [Global sharedGlobal].fbToken;
    NSMutableDictionary * params = [[NSMutableDictionary alloc]init];
    NSString * page = [NSString stringWithFormat:@"%ld", _pageNo];
    NSString * _szPage = [NSString stringWithFormat:@"%d", MOREVIEWCNT];

    [params setObject:user_id forKey:@"user_id"];
    [params setObject:_token forKey:@"_token"];
    [params setObject:page forKey:@"pageno"];
    [params setObject:_szPage forKey:@"num"];
    NSDictionary * result = [UtilComm getnotifications:params];
    
    [self.pongRefreshControl finishedLoading];
    
    if(result!= nil){
        NSDecimalNumber * deccode= [result objectForKey:@"code"];
        NSString * code = [NSString stringWithFormat:@"%@", deccode];
        //  NSString  * data = [result objectForKey:@"data"];
        if([code isEqualToString:@"1"]){
            arrNot = [result objectForKey:@"data"];
            if(![arrNot isKindOfClass:[NSString class]]){
                if([arrNot count] >= MOREVIEWCNT){
                    bLoadMore = YES;
                }
            }

            NSInteger count = [arrNot count];
            if(count == 0){
                viewNo.hidden = NO;
                lbNo.hidden = NO;
            }else{
                viewNo.hidden = YES;
                lbNo.hidden = YES;
            }
            [tbNoti reloadData];
        }
    }else{
        [APPDELEGATE showToastMessage:CONNECT_ERROR];
    }
    
    [self hideBusyDialog];
    

}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return [arrNot count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSMutableDictionary * notification = [arrNot objectAtIndex:indexPath.row];
//    NSDecimalNumber * type_id = [notification objectForKey:@"type_id"];
//    NSString * type = [NSString stringWithFormat:@"%@",type_id];
    
    
    NSString * type =[NSString stringWithFormat:@"%@", [notification objectForKey:@"type_id"]];
    //NSString * name = [NSString stringWithFormat:@"%@ %@", [notification objectForKey:@"first_name"], [notification objectForKey:@"last_name"]];
    NSString * content = [notification objectForKey:@"content"];
    NSString * pathProfile = [notification objectForKey:@"avatar"];
    NSString * pathPhoto =[NSString stringWithFormat:@"%@%@", PHOTO_URL, [notification objectForKey:@"photo"]];
    
    // expired
    NotiExpCell  *cell1 = [[NSBundle mainBundle] loadNibNamed:@"NotiExpCell" owner:self options:nil][0];
    
    cell1.lbContent.text = content;
    
//    cell1.igPost.layer.cornerRadius = 5;
//    cell1.igPost.layer.masksToBounds = YES;
    [cell1.igPost setImageWithURL:[NSURL URLWithString:pathPhoto] placeholderImage:[UIImage imageNamed:@"place_img.png"]];
    
    cell1.btnPost.tag = indexPath.row;
    [cell1.btnPost addTarget:self action:@selector(onClickPostExp:) forControlEvents:UIControlEventTouchUpInside];
    
    CGRect mScreenSize = [UIScreen mainScreen].bounds;
    CGFloat mSeparatorHeight = 1; // Change height of speatator as you want
    CGRect frame = CGRectMake(mScreenSize.size.width * 0.03, cell1.frame.size.height - mSeparatorHeight, mScreenSize.size.width * 0.94, mSeparatorHeight);

    UIView* mAddSeparator =[[UIView alloc]initWithFrame:frame];;

    mAddSeparator.backgroundColor = mainGreenColor; // Change backgroundColor of separator
    [cell1 addSubview:mAddSeparator];
    
    
    // rate, comment, post1
    NotirateCell * cell2 = [[NSBundle mainBundle]loadNibNamed:@"NotirateCell" owner:self options:nil][0];
    
    cell2.igProfile.layer.cornerRadius = cell2.igProfile.bounds.size.height/2;
    cell2.igProfile.layer.masksToBounds = YES;
    [cell2.igProfile setImageWithURL:[NSURL URLWithString:pathProfile] placeholderImage:[UIImage imageNamed:@"place_man.png"]];
    
//    cell2.igPost.layer.cornerRadius = 5;
//    cell2.igPost.layer.masksToBounds = YES;
    [cell2.igPost setImageWithURL:[NSURL URLWithString:pathPhoto]  placeholderImage:[UIImage imageNamed:@"place_img.png"]];
    
    cell2.btnProfile.tag = indexPath.row;
    cell2.btnPost.tag = indexPath.row;
    if([type isEqualToString:@"1"]){
        [cell2.btnPost addTarget:self action:@selector(onClickPostFriend:) forControlEvents:UIControlEventTouchUpInside];
    }else{
        [cell2.btnPost addTarget:self action:@selector(onClickPostMy:) forControlEvents:UIControlEventTouchUpInside];
    }
    [cell2.btnProfile addTarget:self action:@selector(onClickProfile:) forControlEvents:UIControlEventTouchUpInside];
   
    cell2.lbContent.text = content;
    
    UIView* mAddSeparator2 =[[UIView alloc]initWithFrame:frame];;
    
    mAddSeparator2.backgroundColor = mainGreenColor; // Change backgroundColor of separator

    [cell2 addSubview:mAddSeparator2];
    
    
    
    // invite, accept
    NotiInviteCell * cell3 = [[NSBundle mainBundle]loadNibNamed:@"NotiInviteCell" owner:self options:nil][0];
    cell3.igProfile.layer.cornerRadius = cell3.igProfile.bounds.size.height/2;
    cell3.igProfile.layer.masksToBounds = YES;
    [cell3.igProfile setImageWithURL:[NSURL URLWithString:pathProfile] placeholderImage:[UIImage imageNamed:@"place_man.png"]];
    cell3.btnProfile.tag = indexPath.row;
    [cell3.btnProfile addTarget:self action:@selector(onClickProfile:) forControlEvents:UIControlEventTouchUpInside];
    cell3.lbContent.text = content;
    if([type isEqualToString:@"2"]){
        NSMutableDictionary * itemNoti = [arrNot objectAtIndex:indexPath.row];
        [itemNoti setObject:@"no" forKey:@"invited"];
        [arrNot replaceObjectAtIndex:indexPath.row withObject:itemNoti];
        
        [cell3.btnAccept setBackgroundImage:[UIImage imageNamed: @"addfriend.png" ] forState:UIControlStateNormal];
        cell3.btnAccept.tag = indexPath.row;
        [cell3.btnAccept addTarget:self action:@selector(acceptInvite:) forControlEvents:UIControlEventTouchUpInside];
    }
    
    UIView* mAddSeparator3 =[[UIView alloc]initWithFrame:frame];;
    
    mAddSeparator3.backgroundColor = mainGreenColor; // Change backgroundColor of separator

    [cell3 addSubview:mAddSeparator3];

    
    ////////////////////////////////////// load  more ////////////////////////////////////
    ////////////////////////////////////// load  more ////////////////////////////////////
    ////////////////////////////////////// load  more ////////////////////////////////////
    ////////////////////////////////////// load  more ////////////////////////////////////
    
    BOOL lastItemReached = [notification isEqual:[arrNot lastObject]];
    if (lastItemReached && indexPath.row == [arrNot count] - 1)
    {
        NSString * loading = [notification objectForKey:@"loading"];
        if([loading isEqualToString:@"true"]){
            LoadingCell * cellloading =[[NSBundle mainBundle] loadNibNamed:@"LoadingCell" owner:self options:nil][0];
            
            [SVProgressHUD setContainerView: cellloading.viewHUD];
            [SVProgressHUD setRingNoTextRadius:16];
            [SVProgressHUD setRingThickness:4];
            [SVProgressHUD setBackgroundColor:[UIColor clearColor]];
            [SVProgressHUD show];

            return cellloading;
        }else{
            [self performSelector:@selector(launchLoadMore) withObject:nil afterDelay:0.01];
            if([type isEqualToString:@"1"]){  // post
                return cell2;
                
            }else if([type isEqualToString:@"2"]){ // invite
                return cell3;
                
            }else if([type isEqualToString:@"3"]){  // rate
                return cell2;
                
            }else if([type isEqualToString:@"4"]){  // comment
                return cell2;
                
            }else if([type isEqualToString:@"5"]){ // accept
                return cell3;
            }else{  // 6 expired
                return cell1;
            }            
        }
    }
    ////////////////////////////////////// load  more ////////////////////////////////////
    ////////////////////////////////////// load  more ////////////////////////////////////
    ////////////////////////////////////// load  more ////////////////////////////////////
    ////////////////////////////////////// load  more ////////////////////////////////////

    
    if([type isEqualToString:@"1"]){  // post
        return cell2;

    }else if([type isEqualToString:@"2"]){ // invite
        return cell3;
 
    }else if([type isEqualToString:@"3"]){  // rate
        return cell2;

    }else if([type isEqualToString:@"4"]){  // comment
        return cell2;

    }else if([type isEqualToString:@"5"]){ // accept
        return cell3;
    }else{  // 6 expired
        return cell1;
    }
}

-(void)initHUD{
    [SVProgressHUD setContainerView:nil];
    [SVProgressHUD dismiss];
    [self performSelector:@selector(SVProgressToOriSize) withObject:nil afterDelay:0.2];
}

-(void)SVProgressToOriSize{
    [SVProgressHUD setRingNoTextRadius:24];
}
-(void)launchLoadMore{
    if(!bLoadMore){
        [self initHUD];
        return;
    }
    _pageNo++;
    
    NSMutableDictionary * lastItem = [arrNot lastObject];
    NSString * loading = [lastItem objectForKey:@"loading"];
    if(![loading isEqualToString:@"true"]){
        NSMutableDictionary * loadItem = [[NSMutableDictionary alloc]init];
        [loadItem setObject:@"true" forKey:@"loading"];
        [arrNot addObject:loadItem];
        
        [tbNoti reloadData];
        /////////////////// get more data ///////////////////////
        [self moveToBottom];
        [self performSelector:@selector(doInbackgetLoadMore) withObject:nil afterDelay:0.4];
        
    }
}

-(void)moveToBottom{
    NSIndexPath * indexpath =[NSIndexPath indexPathForRow:[arrNot count]-1 inSection:0];
    [tbNoti scrollToRowAtIndexPath:indexpath atScrollPosition:UITableViewScrollPositionBottom animated:YES];
}
-(void)doInbackgetLoadMore
{
    NSString * user_id = [Global sharedGlobal].fbid;
    NSString * _token  = [Global sharedGlobal].fbToken;
    NSMutableDictionary * params = [[NSMutableDictionary alloc]init];
    NSString * _szPage = [NSString stringWithFormat:@"%d", MOREVIEWCNT];
    NSString * page = [NSString stringWithFormat:@"%ld", _pageNo];
    [params setObject:user_id forKey:@"user_id"];
    [params setObject:_token forKey:@"_token"];
    [params setObject:page forKey:@"pageno"];
    [params setObject:_szPage forKey:@"num"];
    
    NSDictionary * result = [UtilComm getnotifications:params];
    
    [arrNot removeLastObject];
    [self initHUD];
    bLoadMore = NO;
    if(result != nil){
        NSDecimalNumber * deccode = [result objectForKey:@"code"];
        NSString * code = [NSString stringWithFormat:@"%@", deccode];
        if([code isEqualToString:@"1"]){
            NSMutableArray * arrMore = [result objectForKey:@"data"];
            
            if(![arrMore isKindOfClass:[NSString class]]){
                if([arrMore count] >= MOREVIEWCNT){
                    bLoadMore = YES;
                }
                [arrNot addObjectsFromArray:arrMore];
            }
        }
    }
    [tbNoti reloadData];
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    float h = 70;
    ////////////////////////////////////// load  more ////////////////////////////////////
    ////////////////////////////////////// load  more ////////////////////////////////////
    ////////////////////////////////////// load  more ////////////////////////////////////
    ////////////////////////////////////// load  more ////////////////////////////////////
    NSMutableDictionary * item = [arrNot objectAtIndex:indexPath.row];
    BOOL lastItemReached = [item isEqual:[arrNot lastObject]];
    if (lastItemReached && indexPath.row == [arrNot count] - 1)
    {
        NSString * loading = [item objectForKey:@"loading"];
        if([loading isEqualToString:@"true"]){
            return 70;
        }
    }
    ////////////////////////////////////// load  more ////////////////////////////////////
    ////////////////////////////////////// load  more ////////////////////////////////////
    ////////////////////////////////////// load  more ////////////////////////////////////
    ////////////////////////////////////// load  more ////////////////////////////////////

    return h ;
    
}
//- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath {
//    // Return YES if you want the specified item to be editable.
//    return YES;
//}

// Override to support editing the table view.
//- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath {
//    if (editingStyle == UITableViewCellEditingStyleDelete){
//        //add code here for when you hit delete
//        nSelIndex = indexPath.row;
//        [self showBusyDialog];
//        [self performSelector:@selector(deleteNotification) withObject:nil afterDelay:0.5];
//    }
//}
//
//-(void)deleteNotification{
//    [APPDELEGATE showToastMessage:[NSString stringWithFormat:@"%ld", (long)nSelIndex]];
//    [self hideBusyDialog];
//}


-(void)acceptInvite:(UIButton *)sender{
    NSInteger index = sender.tag;
    NSMutableDictionary * itemNoti = [arrNot objectAtIndex:index];
    NSString * stateInvite = [itemNoti objectForKey:@"invited"];
    if([stateInvite isEqualToString:@"yes"]){
        return;
    }
    
    [self showBusyDialog];
    [self performSelector:@selector(sendAccept:) withObject:sender afterDelay:0.5];
    
}
-(void)sendAccept:(UIButton *)sender{
    NSInteger index = sender.tag;
    NSMutableDictionary * item = [arrNot objectAtIndex:index];
    NSString * friend_id = [item objectForKey:@"user_id"];

    NSString * user_id = [Global sharedGlobal].fbid;
    NSString * _token = [Global sharedGlobal].fbToken;
    NSMutableDictionary * params = [[NSMutableDictionary alloc]init];
    [params setObject:user_id forKey:@"myfb_id"];
    [params setObject:friend_id forKey:@"fb_id"];
    [params setObject:_token forKey:@"_token"];
    NSDictionary * result = [UtilComm accepttofriend:params];
    [self hideBusyDialog];
    if(result != nil){
        NSDecimalNumber * deccode = [result objectForKey:@"code"];
        NSString * code = [NSString stringWithFormat:@"%@", deccode];
        //NSString * data = [result objectForKey:@"data"];
        
        
        if([code isEqualToString:@"1"]){
            
            NSMutableDictionary * itemNoti = [arrNot objectAtIndex:index];
            [itemNoti removeObjectForKey:@"invited"];
            [itemNoti setObject:@"yes" forKey:@"invited"];
            [arrNot replaceObjectAtIndex:index withObject:itemNoti];
            
            [sender setBackgroundImage:[UIImage imageNamed: @"tick.png" ] forState:UIControlStateNormal];
        }else{
            [APPDELEGATE showToastMessage:@"Fail to accept"];
        }
        
    }else{
        [APPDELEGATE showToastMessage:CONNECT_ERROR];
    }

}

-(void)onClickPostExp:(UIButton *)sender{
    NSInteger index = sender.tag;
    NSMutableDictionary * item = [arrNot objectAtIndex:index];
    NSString * post_id = [item objectForKey:@"post_id"];
    NSString * pathPhoto =[NSString stringWithFormat:@"%@%@", SERVER_URL, [item objectForKey:@"photo"]];

    ExpirePostViewController * vc = [[ExpirePostViewController alloc]initWithNibName:@"ExpirePostViewController" bundle:nil];
    vc.post_id = post_id;
    vc.imageUrl = pathPhoto;
    [self.navigationController pushViewController:vc animated:YES];
}
-(void)onClickPostMy:(UIButton *)sender{
    NSInteger index = sender.tag;
    NSMutableDictionary * item = [arrNot objectAtIndex:index];
    NSString * post_id = [item objectForKey:@"post_id"];
    NSString * pathPhoto =[NSString stringWithFormat:@"%@%@", SERVER_URL, [item objectForKey:@"photo"]];
    PostDetailViewController * vc = [[PostDetailViewController alloc]initWithNibName:@"PostDetailViewController" bundle:nil];
    vc.fromView = @"";
    vc.post_id = post_id;
    vc.imageUrl=pathPhoto;
    [self.navigationController pushViewController:vc animated:YES];
}

-(void)onClickPostFriend:(UIButton *)sender{
    NSInteger index = sender.tag;
    NSMutableDictionary * item = [arrNot objectAtIndex:index];
    //NSString * friend_id = [item objectForKey:@"user_id"];
    NSString * post_id = [item objectForKey:@"post_id"];
    NSString * pathPhoto =[NSString stringWithFormat:@"%@%@", SERVER_URL, [item objectForKey:@"photo"]];
    PostDetailViewController * vc = [[PostDetailViewController alloc]initWithNibName:@"PostDetailViewController" bundle:nil];
    vc.fromView = FROM_FRIEND;
    vc.post_id = post_id;
    vc.imageUrl=pathPhoto;
    [self.navigationController pushViewController:vc animated:YES];
}

-(void)onClickProfile:(UIButton *)sender{
    NSInteger index = sender.tag;
    NSMutableDictionary * item = [arrNot objectAtIndex:index];
    NSString * friend_id = [item objectForKey:@"user_id"];
    //NSString * post_id = [item objectForKey:@"post_id"];
    
    
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

-(IBAction)onClickSrh:(id)sender{
    DressSearchViewController * vc = [[DressSearchViewController alloc]initWithNibName:@"DressSearchViewController" bundle:nil];
    [self.navigationController pushViewController:vc animated:YES];
}

-(IBAction)onClickBack:(id)sender{
    
}
-(void)ToTop:(BOOL)flag{
    [tbNoti setContentOffset:CGPointZero animated:flag];
}
@end

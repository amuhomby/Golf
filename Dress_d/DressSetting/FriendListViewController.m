//
//  FriendListViewController.m
//  Dress_d
//
//  Created by MacAdmin on 9/29/17.
//  Copyright © 2017 MacAdmin. All rights reserved.
//

#import "FriendListViewController.h"
#import "DressSearchViewController.h"
#import "dressAFTableViewCell.h"
#import "UIImageView+WebCache.h"
#import "GolfMainViewController.h"
#import "FriendProfileViewController.h"
@interface FriendListViewController ()<UITableViewDataSource, UITableViewDelegate>
{
    NSString * direction;
    CGFloat lastContentOffset;
}
@end

@implementation FriendListViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    UISwipeGestureRecognizer *swipe = [[UISwipeGestureRecognizer alloc] initWithTarget:self action:@selector(goBack)];
    // And assuming the "Up" direction in your screenshot is no accident
    swipe.direction = UISwipeGestureRecognizerDirectionRight;
    [tbList addGestureRecognizer:swipe];
    
    UISwipeGestureRecognizer *swipe2 = [[UISwipeGestureRecognizer alloc] initWithTarget:self action:@selector(goBack)];
    // And assuming the "Up" direction in your screenshot is no accident
    swipe.direction = UISwipeGestureRecognizerDirectionRight;

    [lbNotice addGestureRecognizer:swipe2];
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


-(void)viewDidLayoutSubviews{
    
    self.pongRefreshControl = [BOZPongRefreshControl attachToTableView:tbList
                                                     withRefreshTarget:self
                                                      andRefreshAction:@selector(getData)];
    self.pongRefreshControl.backgroundColor = [UIColor whiteColor];

}
- (void)viewWillDisappear:(BOOL)animated
{
    [[GolfMainViewController sharedInstance] hideTab:NO];
    [self.pongRefreshControl finishedLoading];
}

#pragma mark - Notifying the pong refresh control of scrolling

- (void)scrollViewDidScroll:(UIScrollView *)scrollView
{
    [self.pongRefreshControl scrollViewDidScroll];
    if([scrollView isEqual:tbList]){
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
    [super viewWillAppear: animated];
    if([_fromSetting isEqualToString:@"yes"]){
        [[GolfMainViewController sharedInstance] hideTab:YES];
        CGRect flbNo = lbNotice.frame;
        flbNo.size.height = [UIScreen mainScreen].bounds.size.height - 20 ;
        lbNotice.frame = flbNo;
    }else{
        CGRect flbNo = lbNotice.frame;
        flbNo.size.height = [UIScreen mainScreen].bounds.size.height - 20 - 50 ;
        lbNotice.frame = flbNo;
        [[GolfMainViewController sharedInstance] hideTab:NO];
    }

    
    arrFriends = [[NSMutableArray alloc]init];
    arrMuteFriends = [[NSMutableArray alloc]init];
    [self showBusyDialog];
    NSString * myid = [Global sharedGlobal].fbid;
    if([myid isEqualToString:_user_id]){
        [self performSelector:@selector(getData) withObject:nil afterDelay:0.5];
    }else{
        [self performSelector:@selector(getMuteFriend) withObject:nil afterDelay:0.5];
    }
    
    [self pullDown];

}


-(void)getData{
    NSString * myid = [Global sharedGlobal].fbid;
    if([myid isEqualToString:_user_id]){
        [self performSelector:@selector(doInbackground) withObject:nil afterDelay:0.2];
    }else{
        [self performSelector:@selector(getMuteFriend) withObject:nil afterDelay:0.5];
    }

}

-(void)doInbackground{
    NSString * my_id = [Global sharedGlobal].fbid;
    NSString * _token  = [Global sharedGlobal].fbToken;
    NSMutableDictionary * params = [[NSMutableDictionary alloc]init];
    [params setObject:my_id forKey:@"user_id"];
    [params setObject:_token forKey:@"_token"];
    [params setObject:_user_id forKey:@"friend_id"];
    NSDictionary * result = [UtilComm friendlist:params];
    [self hideBusyDialog];
    
    [self.pongRefreshControl finishedLoading];
    if(result != nil){
        NSDecimalNumber * deccode = [result objectForKey:@"code"];
        NSString * code = [NSString stringWithFormat:@"%@", deccode];
        if([code isEqualToString:@"1"]){
            arrFriends = [result objectForKey:@"data"];
            if([arrFriends count] == 0)
                lbNotice.hidden = NO;
            else
                lbNotice.hidden = YES;
            [tbList reloadData];
        }else{
            if([my_id isEqualToString:_user_id]){
                lbNotice.text = [NSString stringWithFormat:@"%@ has no friends.", _name];
            }
            lbNotice.hidden = NO;
            NSString * data = [result objectForKey:@"data"];
            [APPDELEGATE showToastMessage:data];
        }
    }else{
//        [APPDELEGATE showToastMessage:CONNECT_ERROR];
    }

}

-(void)getMuteFriend{
    NSString * my_id = [Global sharedGlobal].fbid;
    NSString * _token  = [Global sharedGlobal].fbToken;
    NSMutableDictionary * params = [[NSMutableDictionary alloc]init];
    [params setObject:my_id forKey:@"user_id"];
    [params setObject:_token forKey:@"_token"];
    [params setObject:_user_id forKey:@"friend_id"];
    NSDictionary * result = [UtilComm mutefriend:params];
    [self hideBusyDialog];

    if(result != nil){
        NSDecimalNumber * deccode = [result objectForKey:@"code"];
        NSString * code = [NSString stringWithFormat:@"%@", deccode];
        if([code isEqualToString:@"1"]){
            arrMuteFriends = [result objectForKey:@"data"];
            [self performSelector:@selector(doInbackground) withObject:nil afterDelay:0.1];
        }
    }
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return [arrFriends count];
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
    

    row = [arrFriends objectAtIndex:indexPath.row];
    name =[NSString stringWithFormat:@"%@ %@", [row objectForKey:@"first_name"],[row objectForKey:@"last_name"]];
    img = [row objectForKey:@"avatar"];
    
    cell.lbName.text = name;
    
    [cell.imgProfile setImageWithURL:[NSURL URLWithString:img] placeholderImage:[UIImage imageNamed:@"place_man.png"]];
    
    
    NSString * relation = [row objectForKey:@"relation"];
    
    if([relation isEqualToString:@"friend"]){
        [cell.btnChk setBackgroundImage:[UIImage imageNamed:@"tick.png"] forState:UIControlStateNormal];
    }else if([relation isEqualToString:@"sent"]){
        [cell.btnChk setBackgroundImage:[UIImage imageNamed:@"hourglass.png"] forState:UIControlStateNormal];
    }else if([relation isEqualToString:@"receive"]){
        [cell.btnChk setBackgroundImage:[UIImage imageNamed:@"receive.png"] forState:UIControlStateNormal];
    }else{
        [cell.btnChk setBackgroundImage:[UIImage imageNamed:@"addfriend.png"] forState:UIControlStateNormal];
    }
    cell.btnChk.tag = indexPath.row;
    NSString * friendid = [row objectForKey:@"friend_id"];
    NSString * myid = [Global sharedGlobal].fbid;
    if([friendid isEqualToString:myid]){
        cell.btnChk.hidden = YES;
    }
    
    if([_showChk isEqualToString:@"no"])
        cell.btnChk.hidden = YES;
    
    [cell.btnChk addTarget:self action:@selector(onClickChk:) forControlEvents:UIControlEventTouchUpInside];
    
    
    
    cell.btnHead.tag = indexPath.row;
    cell.btnName.tag = indexPath.row;
    [cell.btnHead addTarget:self action:@selector(onClickHead:) forControlEvents:UIControlEventTouchUpInside];
    [cell.btnName addTarget:self action:@selector(onClickHead:) forControlEvents:UIControlEventTouchUpInside];
    return cell;
}

-(BOOL)checkInMuteFriend:(NSString *)fb_id{
    BOOL result = NO;
    if([arrMuteFriends count] == 0){
        result = NO;
    }else{
        for(int x = 0; x < [arrMuteFriends count]; x++){
            NSString * muteid = [[arrMuteFriends objectAtIndex:x] objectForKey:@"friend_id"];
            if([muteid isEqualToString:fb_id]){
                result = YES;
                break;
            }
        }
    }
    return result;
}
-(void)onClickChk:(UIButton *)sender{
    NSInteger index = sender.tag;
    NSMutableDictionary * row = [arrFriends objectAtIndex:index];
    NSString * relation = [row objectForKey:@"relation"];
    if([relation isEqualToString:@"friend"]){
        [self performSelector:@selector(showdeldlg:) withObject:sender afterDelay:0.3];
    }else if([relation isEqualToString:@"none"]){
        [self showBusyDialog];
        [self performSelector:@selector(addFriendsrh:) withObject:sender afterDelay:0.3];
    }else if([relation isEqualToString:@"receive"]){
        [self showBusyDialog];
        [self performSelector:@selector(acceptfriend:) withObject:sender afterDelay:0.3];
    }
}


-(void)showdeldlg:(UIButton *)sender{
    UIAlertController * alert = [UIAlertController
                                 alertControllerWithTitle:@"Alert"
                                 message:@"Are you sure you want to unfriend?"
                                 preferredStyle:UIAlertControllerStyleAlert];
    
    UIAlertAction* noButton = [UIAlertAction
                               actionWithTitle:@"Yes"
                               style:UIAlertActionStyleDefault
                               handler:^(UIAlertAction * action) {
                                   //Handle no, thanks button
                                   [self performSelector:@selector(deleteFriend:) withObject:sender afterDelay:0.3];
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
}

-(void)deleteFriend:(UIButton *)sender{
    NSInteger index = sender.tag;

    NSString * user_id =[Global sharedGlobal].fbid;
    NSString * _token  = [Global sharedGlobal].fbToken;
    NSString * friend_id =[[arrFriends objectAtIndex:index] objectForKey:@"friend_id"];
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
//        [APPDELEGATE showToastMessage:CONNECT_ERROR];
    }
}
-(void)addFriendsrh:(UIButton *)sender{
    [self showBusyDialog];
    [self performSelector:@selector(requestFriendsrh:) withObject:sender afterDelay:0.5];
}


-(void)requestFriendsrh:(UIButton *)sender{
    
    NSInteger index  = sender.tag;
    NSMutableDictionary * row = [arrFriends objectAtIndex:index];
    NSString * friend_id = [row objectForKey:@"friend_id"];
    NSString * user_id = [Global sharedGlobal].fbid;
    NSString * _token = [Global sharedGlobal].fbToken;
    NSMutableDictionary * params = [[NSMutableDictionary alloc]init];
    [params setObject:user_id forKey:@"myfb_id"];
    [params setObject:_token forKey:@"_token"];
    [params setObject:friend_id forKey:@"fb_ids"];
    NSDictionary * result = [UtilComm invitetofriends:params];
    if(result != nil){
        NSDecimalNumber * deccode = [result objectForKey:@"code"];
        NSString * code = [NSString stringWithFormat:@"%@", deccode];
        NSString * data = [result objectForKey:@"data"];
        if([code isEqualToString:@"1"]){
            [self showBusyDialog];
            [self performSelector:@selector(getData) withObject:nil afterDelay:0.3];
        }else{
            [APPDELEGATE showToastMessage:data];
        }
    }else{
//        [APPDELEGATE showToastMessage:CONNECT_ERROR];
    }
    [self hideBusyDialog];
    
}

-(void)acceptfriend:(UIButton *)sender{
    NSInteger index = sender.tag;
    NSMutableDictionary * item = [arrFriends objectAtIndex:index];
    NSString * friend_id = [item objectForKey:@"friend_id"];
    
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
            [self showBusyDialog];
            [self performSelector:@selector(getData) withObject:nil afterDelay:0.3];
        }else{
            [APPDELEGATE showToastMessage:@"Fail to accept"];
        }
        
    }else{
//        [APPDELEGATE showToastMessage:CONNECT_ERROR];
    }
    
}
-(void)onClickHead:(UIButton *)sender{
    NSInteger index = sender.tag;
    NSMutableDictionary * friend ;
    NSString * whoprofile;
    
    friend = [arrFriends objectAtIndex:index];
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

//
//  MuteFriendViewController.m
//  Dress_d
//
//  Created by MacAdmin on 10/9/17.
//  Copyright © 2017 MacAdmin. All rights reserved.

#import "MuteFriendViewController.h"
#import "DressSearchViewController.h"
#import "dressAFTableViewCell.h"
#import "UIImageView+WebCache.h"
#import "GolfMainViewController.h"
#import "FriendProfileViewController.h"

@interface MuteFriendViewController ()<UITableViewDelegate, UITableViewDataSource, UIScrollViewDelegate>
{
    NSString * direction;
    CGFloat lastContentOffset;
}
@end

@implementation MuteFriendViewController
- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    
    self.pongRefreshControl = [BOZPongRefreshControl attachToTableView:tbList
                                                     withRefreshTarget:self
                                                      andRefreshAction:@selector(getData)];
    self.pongRefreshControl.backgroundColor = [UIColor whiteColor];
    
    UISwipeGestureRecognizer *swipe = [[UISwipeGestureRecognizer alloc] initWithTarget:self action:@selector(goBack)];
    // And assuming the "Up" direction in your screenshot is no accident
    swipe.direction = UISwipeGestureRecognizerDirectionRight;
    [tbList addGestureRecognizer:swipe];

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
    arrFriends = [[NSMutableArray alloc]init];
    [self showBusyDialog];
    [self performSelector:@selector(getData) withObject:nil afterDelay:0.5];
    [self pullDown];
}

-(void)viewWillDisappear:(BOOL)animated{
    [self.pongRefreshControl finishedLoading];
}

-(void)getData{
    [self performSelector:@selector(doInbackground) withObject:nil afterDelay:0.2];
}

-(void)doInbackground{
    NSString * user_id = [Global sharedGlobal].fbid;
    NSString * _token  = [Global sharedGlobal].fbToken;
    NSMutableDictionary * params = [[NSMutableDictionary alloc]init];
    [params setObject:user_id forKey:@"user_id"];
    [params setObject:_token forKey:@"_token"];
    [params setObject:_friend_id forKey:@"friend_id"];
    NSDictionary * result = [UtilComm mutefriend:params];
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
            lbNotice.hidden = NO;
            NSString * data = [result objectForKey:@"data"];
            [APPDELEGATE showToastMessage:data];
        }
    }else{
        [APPDELEGATE showToastMessage:CONNECT_ERROR];
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
    [cell.btnChk setBackgroundImage:[UIImage imageNamed:@"tick.png"] forState:UIControlStateNormal];
    cell.btnChk.tag = indexPath.row;
    [cell.btnChk addTarget:self action:@selector(onClickDel:) forControlEvents:UIControlEventTouchUpInside];
    cell.btnChk.hidden = YES;
    
    cell.btnHead.tag = indexPath.row;
    cell.btnName.tag = indexPath.row;
    [cell.btnHead addTarget:self action:@selector(onClickHead:) forControlEvents:UIControlEventTouchUpInside];
    [cell.btnName addTarget:self action:@selector(onClickHead:) forControlEvents:UIControlEventTouchUpInside];
    return cell;
}


-(void)onClickDel:(UIButton *)sender{
    UIAlertController * alert = [UIAlertController
                                 alertControllerWithTitle:@"Alert"
                                 message:@"Are you sure you want to unfriend?"
                                 preferredStyle:UIAlertControllerStyleAlert];
    
    UIAlertAction* noButton = [UIAlertAction
                               actionWithTitle:@"Yes"
                               style:UIAlertActionStyleDefault
                               handler:^(UIAlertAction * action) {
                                   //Handle no, thanks button
                                   [self showBusyDialog];
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
    return;
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
            NSString * data = [result objectForKey:@"data"];
            [APPDELEGATE showToastMessage:data];
            [self showBusyDialog];
            [self performSelector:@selector(getData) withObject:nil afterDelay:0.3];
        }else{
            [APPDELEGATE showToastMessage:@"Fail to delete"];
        }
    }else{
        [APPDELEGATE showToastMessage:CONNECT_ERROR];
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

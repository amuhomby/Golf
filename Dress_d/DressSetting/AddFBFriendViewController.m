//
//  AddFBFriendViewController.m
//  Dress_d
//
//  Created by MacAdmin on 21/09/2017.
//  Copyright © 2017 MacAdmin. All rights reserved.
//

#import "AddFBFriendViewController.h"
#import "dressAFTableViewCell.h"
#import "UIImageView+WebCache.h"
#import "GolfMainViewController.h"
#import "DressSearchViewController.h"
#import "FriendProfileViewController.h"

@interface AddFBFriendViewController () <UITableViewDataSource, UITableViewDelegate>
{
    BOOL      finishAppFriend;
    NSMutableArray * arrSend ;
    NSMutableArray * arrReceive ;
    


}

@end

@implementation AddFBFriendViewController

- (IBAction)onClickedBack:(id)sender
{
    [self goBack];
}
-(void)goBack{
    [self.navigationController popViewControllerAnimated:YES];
}
- (IBAction)onClickedSearch:(id)sender
{
    DressSearchViewController * vc = [[DressSearchViewController alloc]initWithNibName:@"DressSearchViewController" bundle:nil];
    [self.navigationController pushViewController:vc animated:YES];
}


- (void)viewDidLoad {
    [super viewDidLoad];
    arrSend       = [[NSMutableArray alloc]init];
    arrReceive    = [[NSMutableArray alloc]init];
    arrAppFriend  = [[NSMutableArray alloc]init];
    arrFbFriend   = [[NSMutableArray alloc]init];
    arrFbShow     = [[NSMutableArray alloc]init];
    UISwipeGestureRecognizer *swipe = [[UISwipeGestureRecognizer alloc] initWithTarget:self action:@selector(goBack)];
    // And assuming the "Up" direction in your screenshot is no accident
    swipe.direction = UISwipeGestureRecognizerDirectionRight;
    [tbfriend addGestureRecognizer:swipe];
    
    UISwipeGestureRecognizer *swipe2 = [[UISwipeGestureRecognizer alloc] initWithTarget:self action:@selector(goBack)];
    // And assuming the "Up" direction in your screenshot is no accident
    swipe.direction = UISwipeGestureRecognizerDirectionRight;

    [viewNo addGestureRecognizer:swipe2];
    

    self.pongRefreshControl = [BOZPongRefreshControl attachToTableView:tbfriend
                                                     withRefreshTarget:self
                                                      andRefreshAction:@selector(getFriendDataRefresh)];
    self.pongRefreshControl.backgroundColor = [UIColor whiteColor];
    
    
    
    // Do any additional setup after loading the view from its nib.
    [self getFriendData];
}

-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];

    [[GolfMainViewController sharedInstance] hideTab:YES];
}


- (void)viewWillDisappear:(BOOL)animated
{
    [self.pongRefreshControl finishedLoading];
}

#pragma mark - Notifying the pong refresh control of scrolling

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

-(void)viewDidLayoutSubviews{
}

-(void)getFriendData{
    if(arrAppFriend.count > 0){
        [arrAppFriend removeAllObjects];
    }
    if(arrFbFriend.count > 0)
        [arrFbFriend removeAllObjects];
    if(arrFbShow.count > 0)
        [arrFbShow removeAllObjects];
    
    NSString * user_id = [Global sharedGlobal].fbid;
    NSString * _token  = [Global sharedGlobal].fbToken;
    NSMutableDictionary * params = [[NSMutableDictionary alloc]init];
    [params setObject:user_id forKey:@"user_id"];
    [params setObject:_token forKey:@"_token"];
    
    NSDictionary * result = [UtilComm friendstate:params];
    [self hideBusyDialog];
    
    if(result != nil){
        NSDecimalNumber * deccode = [result objectForKey:@"code"];
        NSString * code = [NSString stringWithFormat:@"%@", deccode];
        //NSString * data = [result objectForKey:@"data"];
        if([code isEqualToString:@"1"]){
            arrAppFriend = [result objectForKey:@"friend"];
            arrSend = [result objectForKey:@"sent"];
            arrReceive = [result objectForKey:@"receive"];
            [self getFBFriend];
        }else{
            //            [APPDELEGATE showToastMessage:@""];
        }
        
    }else{
        [APPDELEGATE showToastMessage:CONNECT_ERROR];
    }
}
-(void)getFriendDataRefresh{
    [self performSelector:@selector(doInbackground) withObject:nil afterDelay:0.3];
}

-(void)doInbackground{
    if(arrAppFriend.count > 0){
        [arrAppFriend removeAllObjects];
    }
    if(arrFbFriend.count > 0)
        [arrFbFriend removeAllObjects];
    if(arrFbShow.count > 0)
        [arrFbShow removeAllObjects];
    
    NSString * user_id = [Global sharedGlobal].fbid;
    NSString * _token  = [Global sharedGlobal].fbToken;
    NSMutableDictionary * params = [[NSMutableDictionary alloc]init];
    [params setObject:user_id forKey:@"user_id"];
    [params setObject:_token forKey:@"_token"];
    
    NSDictionary * result = [UtilComm friendstate:params];
    
    if(result != nil){
        NSDecimalNumber * deccode = [result objectForKey:@"code"];
        NSString * code = [NSString stringWithFormat:@"%@", deccode];
        //NSString * data = [result objectForKey:@"data"];
        if([code isEqualToString:@"1"]){
            arrAppFriend = [result objectForKey:@"friend"];
            arrSend = [result objectForKey:@"sent"];
            arrReceive = [result objectForKey:@"receive"];
            [self getFBFriendRefresh];
        }else{
            //            [APPDELEGATE showToastMessage:@""];
        }
        
    }else{
        [APPDELEGATE showToastMessage:CONNECT_ERROR];
    }
}


-(void) getFBFriendRefresh{

}
-(void) getFBFriend{

}

-(NSString *)checkRelation:(NSString * )user_id{
    NSString * relation = @"none";
    
    if (![arrAppFriend isKindOfClass:[NSString class]]){
        for(int x=0; x < [arrAppFriend count];x++){
            NSString * friend_id = [[arrAppFriend objectAtIndex:x] objectForKey:@"friend_id"];
            if([user_id isEqualToString:friend_id]){
                relation = @"friend";
                return relation;
            }
        }
        
    }
    
    if(![arrSend isKindOfClass:[NSString class]]){
        for(int x=0; x < [arrSend count];x++){
            NSString * friend_id = [[arrSend objectAtIndex:x] objectForKey:@"friend_id"];
            if([user_id isEqualToString:friend_id]){
                relation = @"sent";
                return relation;
            }
        }
    }
    
    if(![arrReceive isKindOfClass:[NSString class]]){
        for(int x=0; x < [arrReceive count];x++){
            NSString * friend_id = [[arrReceive objectAtIndex:x] objectForKey:@"friend_id"];
            if([user_id isEqualToString:friend_id]){
                relation = @"receive";
                return relation;
            }
        }
    }
    
    return  relation;
}


- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return [arrFbShow count];
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    float h = 70;
    return h ;
    
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    dressAFTableViewCell *cell = [[NSBundle mainBundle] loadNibNamed:@"dressAFTableViewCell" owner:self options:nil][0];
    
    NSMutableDictionary *row = [arrFbShow objectAtIndex:indexPath.row];
    NSString * fbid = [row objectForKey:@"id"];
    NSString * name = [row objectForKey:@"name"];
    NSString * img = [row objectForKey:@"image"];
    NSString * relation;
    row = [arrFbShow objectAtIndex:indexPath.row];
    fbid = [row objectForKey:@"id"];
    name = [row objectForKey:@"name"];
    img = [row objectForKey:@"image"];
    relation = [row objectForKey:@"relation"];
    
    cell.btnChk.tag = indexPath.row;
    
    if([relation isEqualToString:@"sent"]){
        [cell.btnChk setBackgroundImage:[UIImage imageNamed:@"hourglass.png"] forState:UIControlStateNormal];
    }else if([relation isEqualToString:@"receive"]){
        [cell.btnChk setBackgroundImage:[UIImage imageNamed:@"receive.png"] forState:UIControlStateNormal];
        [cell.btnChk addTarget:self action:@selector(acceptfriendFB:) forControlEvents:UIControlEventTouchUpInside];
    }else{
        [cell.btnChk setBackgroundImage:[UIImage imageNamed:@"addfriend.png"] forState:UIControlStateNormal];
        [cell.btnChk addTarget:self action:@selector(requestFriend:) forControlEvents:UIControlEventTouchUpInside];
    }
    
    cell.lbName.text = name;
    cell.btnName.tag = indexPath.row;
    [cell.btnName addTarget:self action:@selector(onClickName:) forControlEvents:UIControlEventTouchUpInside];
    
    [cell.imgProfile setImageWithURL:[NSURL URLWithString:img] placeholderImage:[UIImage imageNamed:@"place_man.png"]];
    return cell;
}
-(void)onClickName:(UIButton *)sender{
    NSInteger index = sender.tag;
    NSMutableDictionary * friend ;
    NSString * whoprofile;
    
    friend = [arrFbShow objectAtIndex:index];
    whoprofile = [friend objectForKey:@"id"];
    
    
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

-(void)acceptfriendFB:(UIButton *)sender{
    NSInteger index = sender.tag;
    NSMutableDictionary * friend ;
    NSString * fbid;
    friend = [arrFbShow objectAtIndex:index];
    fbid = [friend objectForKey:@"id"];
    
    NSString * user_id = [Global sharedGlobal].fbid;
    NSString * _token = [Global sharedGlobal].fbToken;
    NSMutableDictionary * params = [[NSMutableDictionary alloc]init];
    [params setObject:user_id forKey:@"myfb_id"];
    [params setObject:fbid forKey:@"fb_id"];
    [params setObject:_token forKey:@"_token"];
    NSDictionary * result = [UtilComm accepttofriend:params];
    [self hideBusyDialog];
    if(result != nil){
        NSDecimalNumber * deccode = [result objectForKey:@"code"];
        NSString * code = [NSString stringWithFormat:@"%@", deccode];
        
        
        if([code isEqualToString:@"1"]){
            [self showBusyDialog];
            [self performSelector:@selector(getFriendData) withObject:nil afterDelay:0.3];
        }else{
            [APPDELEGATE showToastMessage:@"Fail to accept"];
        }
        
    }else{
        [APPDELEGATE showToastMessage:CONNECT_ERROR];
    }
    
}

-(void)requestFriend:(UIButton *)sender{
    NSInteger index = sender.tag;
    NSMutableDictionary * friend ;
    NSString * fbid;
    friend = [arrFbShow objectAtIndex:index];
    fbid = [friend objectForKey:@"id"];
    
    NSString * user_id = [Global sharedGlobal].fbid;
    NSString * _token = [Global sharedGlobal].fbToken;
    NSMutableDictionary * params = [[NSMutableDictionary alloc]init];
    [params setObject:user_id forKey:@"myfb_id"];
    [params setObject:_token forKey:@"_token"];
    [params setObject:fbid forKey:@"fb_ids"];
    NSDictionary * result = [UtilComm invitetofriends:params];
    if(result != nil){
        NSDecimalNumber * deccode = [result objectForKey:@"code"];
        NSString * code = [NSString stringWithFormat:@"%@", deccode];
        NSString * data = [result objectForKey:@"data"];
        if([code isEqualToString:@"1"]){
            [self showBusyDialog];
            [self performSelector:@selector(getFriendData) withObject:nil afterDelay:0.3];
            
        }else{
            [APPDELEGATE showToastMessage:data];
        }
    }else{
        [APPDELEGATE showToastMessage:CONNECT_ERROR];
    }
    [self hideBusyDialog];
    
}

@end

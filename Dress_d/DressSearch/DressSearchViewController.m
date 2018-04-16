//
//  DressSearchViewController.m
//  Dress_d
//
//  Created by MacAdmin on 9/15/17.
//  Copyright © 2017 dev. All rights reserved.
//

#import "DressSearchViewController.h"
#import "dressAFTableViewCell.h"
#import "UIImageView+WebCache.h"
#import "NonFProfViewController.h"
#import "GolfMainViewController.h"
#import "FriendProfileViewController.h"
#import "BrandViewCell.h"
#import "BrandViewController.h"

@interface DressSearchViewController ()<UITextFieldDelegate>
{
    NSString * request_id;
    NSString * type;
}
@end

@implementation DressSearchViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    UITapGestureRecognizer *tapRecog = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(dismissKeyboard)];
    tapRecog.cancelsTouchesInView = NO;
    [vwBack addGestureRecognizer:tapRecog];
    
//    UISwipeGestureRecognizer *swipe = [[UISwipeGestureRecognizer alloc] initWithTarget:self action:@selector(goBack)];
//    // And assuming the "Up" direction in your screenshot is no accident
//    swipe.direction = UISwipeGestureRecognizerDirectionRight;
//    [vwBack addGestureRecognizer:swipe];

    arrSend       = [[NSMutableArray alloc]init];
    arrReceive    = [[NSMutableArray alloc]init];
    arrAppFriend  = [[NSMutableArray alloc]init];
    arrFbFriend   = [[NSMutableArray alloc]init];
    arrFbShow     = [[NSMutableArray alloc]init];
    arrSrhResult  = [[NSMutableArray alloc]init];
    type = @"people";

    
    UISwipeGestureRecognizer *swipeToNoti = [[UISwipeGestureRecognizer alloc] initWithTarget:self action:@selector(gotoNoti)];
    // And assuming the "Up" direction in your screenshot is no accident
    swipeToNoti.direction = UISwipeGestureRecognizerDirectionRight;
    [tbPerson addGestureRecognizer:swipeToNoti];
    
    
    UISwipeGestureRecognizer *swipeToNotiv = [[UISwipeGestureRecognizer alloc] initWithTarget:self action:@selector(gotoNoti)];
    // And assuming the "Up" direction in your screenshot is no accident
    swipeToNotiv.direction = UISwipeGestureRecognizerDirectionRight;
    [viewNo addGestureRecognizer:swipeToNotiv];
   
}

-(void)gotoNoti{

    CGRect ftb = vwBack.frame;
    ftb.origin.x = [UIScreen mainScreen].bounds.size.width;
    
    [UIView animateWithDuration:0.3 animations:^{
        vwBack.frame = ftb;
    }completion:^(BOOL finished){
        CGRect ftb = vwBack.frame;
        ftb.origin.x = 0;
        vwBack.frame = ftb;
        [[GolfMainViewController sharedInstance] changTab:3];
    }];
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    [self ToTop:YES];/// Remove this line when maintain the position come back;

    if([type isEqualToString:@"people"]){
        [btnBrand setTitleColor:mainGreenColor forState:UIControlStateNormal];
        [btnPeople setTitleColor:mainGrayColor forState:UIControlStateNormal];
    }else{
        [btnBrand setTitleColor:mainGrayColor forState:UIControlStateNormal];
        [btnPeople setTitleColor:mainGreenColor forState:UIControlStateNormal];
    }
    
    searchWord = @"";
    tfSrh.text = searchWord;
    tbPerson.hidden = YES;
    [self getData];
    

}
-(void)viewDidAppear:(BOOL)animated{

}


-(IBAction)onClickPeople:(id)sender{
    if([type isEqualToString:@"people"]){
        
    }else{
        type = @"people";
        [btnBrand setTitleColor:mainGreenColor forState:UIControlStateNormal];
        [btnPeople setTitleColor:mainGrayColor forState:UIControlStateNormal];
        tbPerson.hidden = YES;
        [self ToTop:YES];
        [self getData];
    }
}

-(IBAction)onClickBrand:(id)sender{
    if([type isEqualToString:@"brand"]){

    }else{
        type = @"brand";
        [btnBrand setTitleColor:mainGrayColor forState:UIControlStateNormal];
        [btnPeople setTitleColor:mainGreenColor forState:UIControlStateNormal];
        tbPerson.hidden = YES;
        [self ToTop:YES];
        [self getData];
    }

}
-(void)viewDidLayoutSubviews{
    [self initView];
}

-(void)initView{

    viewSrh.layer.cornerRadius = viewSrh.bounds.size.height/2;
    viewSrh.layer.masksToBounds = YES;
    viewSrh.layer.borderWidth = 1;
    viewSrh.layer.borderColor = mainGreenColor.CGColor;
    
    btnAdd.layer.cornerRadius = btnAdd.bounds.size.height/2;
    btnAdd.layer.masksToBounds = YES;

}
- (void)dismissKeyboard
{
    [tfSrh resignFirstResponder];
}

- (BOOL)textFieldShouldReturn:(UITextField *)textField
{
    [self dismissKeyboard];
    searchWord = textField.text;
    [self getData];
    return YES;
}

-(void)getData{
    [arrSrhResult removeAllObjects];
    [tbPerson reloadData];
    
    [self performSelector:@selector(getData2) withObject:nil afterDelay:0.3];
}

-(void)getData2{
    if([type isEqualToString:@"brand"])
        [self initBrand];
    else
        [self initData1];
}

-(void)initBrand{
    [self showBusyDialog];
    [self performSelector:@selector(searchBrand) withObject:nil afterDelay:0.5];
}

-(void)initData1{
    if([searchWord isEqualToString:@""]){
        [self showBusyDialog];
        [self performSelector:@selector(getFBFriend) withObject:nil afterDelay:0.5];
    }else{
        [self showBusyDialog];
        [self performSelector:@selector(searchUser) withObject:nil afterDelay:0.5];
    }
}
-(void)searchUser{
//    user_id, _token, keyword
    NSString * user_id = [Global sharedGlobal].fbid;
    NSString * _token = [Global sharedGlobal].fbToken;
    searchWord = [tfSrh.text stringByTrimmingCharactersInSet:
                               [NSCharacterSet whitespaceCharacterSet]];
    NSMutableDictionary * params = [[NSMutableDictionary alloc]init];
    [params setObject:user_id forKey:@"user_id"];
    [params setObject:_token forKey:@"_token"];
    [params setObject:searchWord forKey:@"keyword"];
    
    NSDictionary * result = [UtilComm searchusers:params];
    [self hideBusyDialog];
    if(result != nil){
        NSDecimalNumber * deccode = [result objectForKey:@"code"];
        NSString * code = [NSString stringWithFormat:@"%@", deccode];
        NSString * data = [result objectForKey:@"data"];
        if([code isEqualToString:@"1"]){
            arrSrhResult = [result objectForKey:@"data"];
            if([arrSrhResult count] == 0){
                viewNo.hidden = NO;
                lbNo.text = @"";
            }else{
                viewNo.hidden = YES;
                lbNo.text = @"";
            }

        }else{
            [APPDELEGATE showToastMessage:data];
        }
    }else{
//        [APPDELEGATE showToastMessage:CONNECT_ERROR];
    }
    tbPerson.hidden = NO;
    [tbPerson reloadData];

}

-(void)searchBrand{
    //    user_id, _token, keyword

    NSString * user_id = [Global sharedGlobal].fbid;
    NSString * _token = [Global sharedGlobal].fbToken;
    searchWord = [tfSrh.text stringByTrimmingCharactersInSet:
                  [NSCharacterSet whitespaceCharacterSet]];
    
    
    NSMutableDictionary * params = [[NSMutableDictionary alloc]init];
    [params setObject:user_id forKey:@"user_id"];
    [params setObject:_token forKey:@"_token"];
    [params setObject:searchWord forKey:@"keyword"];
    
    NSDictionary * result = [UtilComm searchbrand:params];
    [self hideBusyDialog];
    if(result != nil){
        NSDecimalNumber * deccode = [result objectForKey:@"code"];
        NSString * code = [NSString stringWithFormat:@"%@", deccode];
        //NSString * data = [result objectForKey:@"data"];
        if([code isEqualToString:@"1"]){
            arrSrhResult = [result objectForKey:@"data"];
            if([arrSrhResult count] == 0){
                viewNo.hidden = NO;
                lbNo.text = @"There are no such Brands.";

            }else{
                viewNo.hidden = YES;
                tbPerson.hidden = NO;
                [tbPerson reloadData];
            }
        }else{
            
        }
    }else{
        //        [APPDELEGATE showToastMessage:CONNECT_ERROR];
    }
}


-(void) getFBFriend{
}


-(void) getAllUserWithfb:(NSString *) fbids{
    
    NSString * user_id = [Global sharedGlobal].fbid;
    NSString * _token  = [Global sharedGlobal].fbToken;
    NSMutableDictionary * params = [[NSMutableDictionary alloc]init];
    [params setObject:user_id forKey:@"user_id"];
    [params setObject:fbids forKey:@"fb_friendids"];
    [params setObject:_token forKey:@"_token"];
    
    NSDictionary * result = [UtilComm getalluserwithfb:params];
    [self hideBusyDialog];
    if(result != nil){
        NSDecimalNumber * deccode = [result objectForKey:@"code"];
        NSString * code = [NSString stringWithFormat:@"%@", deccode];
        //NSString * data = [result objectForKey:@"data"];
        if([code isEqualToString:@"1"]){
            arrFbShow = [result objectForKey:@"data"];
            arrAppFriend = [result objectForKey:@"friend"];
            arrSend = [result objectForKey:@"sent"];
            arrReceive = [result objectForKey:@"receive"];
        }else{}
    }else{}
    
    if([arrFbShow count] == 0){
        viewNo.hidden = NO;
        lbNo.text = @"";
        
    }else{
        viewNo.hidden = YES;
        tbPerson.hidden = NO;
        [tbPerson reloadData];
    }

    
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if([type isEqualToString:@"people"]){
        if([searchWord isEqualToString:@""]){
            return [arrFbShow count];
        }else{
            return [arrSrhResult count];
        }
    }else{
        return [arrSrhResult count];
    }
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    float h;
    if([type isEqualToString:@"people"])
        h = 70;
    else
        h = 50;
    return h ;
    
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    dressAFTableViewCell *cell = [[NSBundle mainBundle] loadNibNamed:@"dressAFTableViewCell" owner:self options:nil][0];
    BrandViewCell * cellbrand = [[NSBundle mainBundle] loadNibNamed:@"BrandViewCell" owner:self options:nil][0];
    
    NSMutableDictionary *row;
    NSString * fbid;
    NSString * name;
    NSString * img ;
    NSString * relation;

    if([type isEqualToString:@"people"]){
        if([searchWord isEqualToString:@""]){
            row = [arrFbShow objectAtIndex:indexPath.row];
            fbid = [row objectForKey:@"name"];
            name =[NSString stringWithFormat:@"%@ %@", [row objectForKey:@"first_name"],[row objectForKey:@"last_name"]];
            img = [row objectForKey:@"avatar"];
            relation = [row objectForKey:@"relation"];
            
            cell.btnChk.tag = indexPath.row;
            
            if([relation isEqualToString:@"friend"]){
                [cell.btnChk setBackgroundImage:[UIImage imageNamed:@"tick.png"] forState:UIControlStateNormal];
                [cell.btnChk addTarget:self action:@selector(showdeldlgInAlll:) forControlEvents:UIControlEventTouchUpInside];
            }else if([relation isEqualToString:@"sent"]){
                [cell.btnChk setBackgroundImage:[UIImage imageNamed:@"hourglass.png"] forState:UIControlStateNormal];
            }else if([relation isEqualToString:@"receive"]){
                [cell.btnChk setBackgroundImage:[UIImage imageNamed:@"receive.png"] forState:UIControlStateNormal];
                [cell.btnChk addTarget:self action:@selector(acceptfriendFB:) forControlEvents:UIControlEventTouchUpInside];
            }else{
                [cell.btnChk setBackgroundImage:[UIImage imageNamed:@"addfriend.png"] forState:UIControlStateNormal];
                [cell.btnChk addTarget:self action:@selector(requestFriend:) forControlEvents:UIControlEventTouchUpInside];
            }
            
        }else{
            row = [arrSrhResult objectAtIndex:indexPath.row];
            fbid = [row objectForKey:@"user_id"];
            name =[NSString stringWithFormat:@"%@ %@", [row objectForKey:@"first_name"],[row objectForKey:@"last_name"]];
            img = [row objectForKey:@"avatar"];
            relation = [row objectForKey:@"relation"];
            
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
            
            [cell.btnChk addTarget:self action:@selector(onClickChk:) forControlEvents:UIControlEventTouchUpInside];
            
        }
        
        cell.lbName.text = name;
        [cell.btnName setTitle:name forState:UIControlStateNormal];
        [cell.btnName sizeToFit];
        
        [cell.imgProfile setImageWithURL:[NSURL URLWithString:img] placeholderImage:[UIImage imageNamed:@"place_man.png"]];
        
        
        cell.btnHead.tag = indexPath.row;
        cell.btnName.tag = indexPath.row;
        [cell.btnHead addTarget:self action:@selector(onClickHead:) forControlEvents:UIControlEventTouchUpInside];
        [cell.btnName addTarget:self action:@selector(onClickHead:) forControlEvents:UIControlEventTouchUpInside];
        return cell;

    }else{
        row = [arrSrhResult objectAtIndex:indexPath.row];
        NSString * strBrand = [row objectForKey:@"brand"];
        NSString * szOutfit = [NSString stringWithFormat:@"%@",[row objectForKey:@"szpostwithbrand"]];
        NSString * szBrand;
        if([szOutfit isEqualToString:@"1" ]){
            szBrand = [NSString stringWithFormat:@"%@ Outfit", szOutfit];
        }else{
            szBrand = [NSString stringWithFormat:@"%@ Outfits", szOutfit];
        }
        [cellbrand.btnBrand setTitle:strBrand forState:UIControlStateNormal];
        [cellbrand.btnBrand sizeToFit];
        
        cellbrand.lbSize.text = szBrand;
        [cellbrand.lbSize sizeToFit];
        cellbrand.btnBrand.tag = indexPath.row;
        [cellbrand.btnBrand addTarget:self action:@selector(onClickBrandName:) forControlEvents:UIControlEventTouchUpInside];
        return cellbrand;
    }
}
-(void)onClickBrandName:(UIButton *)sender{
    NSInteger index = sender.tag;
    NSMutableDictionary * row = [arrSrhResult objectAtIndex:index];
    NSString * strBrand = [row objectForKey:@"brand"];
    BrandViewController * vc = [[BrandViewController alloc]initWithNibName:@"BrandViewController" bundle:nil];
    vc.strBrand = strBrand;
    [self.navigationController pushViewController:vc animated:YES];
}

-(void)onClickChk:(UIButton *)sender{
    NSInteger index = sender.tag;
    NSMutableDictionary * row = [arrSrhResult objectAtIndex:index];
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

-(void)addFriendsrh:(UIButton *)sender{
    [self showBusyDialog];
    [self performSelector:@selector(requestFriendsrh:) withObject:sender afterDelay:0.5];
}


-(void)acceptfriend:(UIButton *)sender{
    NSInteger index = sender.tag;
    NSMutableDictionary * item = [arrSrhResult objectAtIndex:index];
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
            [self showBusyDialog];
            [self performSelector:@selector(initData1) withObject:nil afterDelay:0.3];
        }else{
            [APPDELEGATE showToastMessage:@"Fail to accept"];
        }
        
    }else{
        [APPDELEGATE showToastMessage:CONNECT_ERROR];
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
    NSString * friend_id =[[arrSrhResult objectAtIndex:index] objectForKey:@"user_id"];
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
            [self performSelector:@selector(initData1) withObject:nil afterDelay:0.3];
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
    NSString * fbid;
    NSString * myfbid = [Global sharedGlobal].fbid;
    if([searchWord isEqualToString:@""]){
        friend = [arrFbShow objectAtIndex:index];
        fbid = [friend objectForKey:@"name"];
        
        if([fbid isEqualToString:myfbid]){
            [Global sharedGlobal].whoProfile = fbid;
            [[Global sharedGlobal] SaveParam];
            [[GolfMainViewController sharedInstance] changTab:1];
        }else{
            FriendProfileViewController * vc = [[FriendProfileViewController alloc]initWithNibName:@"FriendProfileViewController" bundle:nil];
            vc.friendid = fbid;
            [self.navigationController pushViewController:vc animated:YES];
        }

    }else{
        friend = [arrSrhResult objectAtIndex:index];
        fbid = [friend objectForKey:@"user_id"];
        
        NSString * relation = [friend objectForKey:@"relation"];
        if([relation isEqualToString:@"friend"]){
            if([fbid isEqualToString:myfbid]){
                [Global sharedGlobal].whoProfile = fbid;
                [[Global sharedGlobal] SaveParam];
                [[GolfMainViewController sharedInstance] changTab:1];
            }else{
                FriendProfileViewController * vc = [[FriendProfileViewController alloc]initWithNibName:@"FriendProfileViewController" bundle:nil];
                vc.friendid = fbid;
                [self.navigationController pushViewController:vc animated:YES];
            }

        }else{
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

    }
    

}



-(IBAction)onClickBack:(id)sender{
    [self goBack];
}

-(void)goBack{
    [self.navigationController popViewControllerAnimated:YES];
}
-(void)requestFriendsrh:(UIButton *)sender{

    NSInteger index  = sender.tag;
    NSMutableDictionary * row = [arrSrhResult objectAtIndex:index];
    NSString * friend_id = [row objectForKey:@"user_id"];
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
            [self performSelector:@selector(initData1) withObject:nil afterDelay:0.3];
        }else{
            [APPDELEGATE showToastMessage:data];
        }
    }else{
        [APPDELEGATE showToastMessage:CONNECT_ERROR];
    }
    [self hideBusyDialog];
    
}
-(void)requestFriend:(UIButton *)sender{
    NSInteger index = sender.tag;
    NSMutableDictionary * friend ;
    NSString * fbid;
    friend = [arrFbShow objectAtIndex:index];
    fbid = [friend objectForKey:@"name"];
    
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
            [self performSelector:@selector(initData1) withObject:nil afterDelay:0.3];
            
        }else{
            [APPDELEGATE showToastMessage:data];
        }
    }else{
        [APPDELEGATE showToastMessage:CONNECT_ERROR];
    }
    [self hideBusyDialog];
}

-(void)showdeldlgInAlll:(UIButton *)sender{
    UIAlertController * alert = [UIAlertController
                                 alertControllerWithTitle:@"Alert"
                                 message:@"Are you sure you want to unfriend?"
                                 preferredStyle:UIAlertControllerStyleAlert];
    
    UIAlertAction* noButton = [UIAlertAction
                               actionWithTitle:@"Yes"
                               style:UIAlertActionStyleDefault
                               handler:^(UIAlertAction * action) {
                                   //Handle no, thanks button
                                   [self performSelector:@selector(deleteFriendInAll:) withObject:sender afterDelay:0.3];
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

-(void)deleteFriendInAll:(UIButton *)sender{
    NSInteger index = sender.tag;
    NSMutableDictionary * friend ;
    NSString * fbid;
    friend = [arrFbShow objectAtIndex:index];
    fbid = [friend objectForKey:@"name"];
    
    NSString * user_id =[Global sharedGlobal].fbid;
    NSString * _token  = [Global sharedGlobal].fbToken;
    
    NSMutableDictionary * params = [[NSMutableDictionary alloc]init];
    [params setObject:user_id forKey:@"user_id"];
    [params setObject:_token forKey:@"_token"];
    [params setObject:fbid forKey:@"friend_id"];
    
    NSDictionary * result = [UtilComm deletefriend:params];
    [self hideBusyDialog];
    if(result != nil){
        NSDecimalNumber * deccode = [result objectForKey:@"code"];
        NSString * code = [NSString stringWithFormat:@"%@", deccode];
        if([code isEqualToString:@"1"]){
            //NSString * data = [result objectForKey:@"data"];
            [self showBusyDialog];
            [self performSelector:@selector(initData1) withObject:nil afterDelay:0.3];
        }else{
            [APPDELEGATE showToastMessage:@"Fail to delete"];
        }
    }else{
        [APPDELEGATE showToastMessage:CONNECT_ERROR];
    }
}


-(void)acceptfriendFB:(UIButton *)sender{
    NSInteger index = sender.tag;
    NSMutableDictionary * friend ;
    NSString * fbid;
    friend = [arrFbShow objectAtIndex:index];
    fbid = [friend objectForKey:@"name"];
    
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
        //NSString * data = [result objectForKey:@"data"];
        
        
        if([code isEqualToString:@"1"]){
            [self showBusyDialog];
            [self performSelector:@selector(initData1) withObject:nil afterDelay:0.3];
        }else{
            [APPDELEGATE showToastMessage:@"Fail to accept"];
        }
        
    }else{
        [APPDELEGATE showToastMessage:CONNECT_ERROR];
    }
    
}
-(void)ToTop:(BOOL)flag{
    [tbPerson setContentOffset:CGPointZero animated:flag];
}

@end

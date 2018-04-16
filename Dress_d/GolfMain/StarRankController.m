//
//  StarRankController.m
//  Golf
//
//  Created by MacAdmin on 3/31/18.
//  Copyright © 2018 MacAdmin. All rights reserved.
//

#import "StarRankController.h"
#import "RankCell.h"
#import "LoadingCell.h"
#import "GolfMainViewController.h"

@interface StarRankController ()<UITableViewDelegate, UITableViewDataSource>

@end

@implementation StarRankController
{
    // @"star" , @"rich", @"praise", @"cookie"
    NSString * select;
    NSMutableArray * arrData;
    BOOL bLoadMore;
    NSInteger  _pageNo;
    UIRefreshControl *refreshControl;
}
- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    [self initData];
    [self ChangeSelect];
    [self layoutControl];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear: animated];
    [[GolfMainViewController sharedInstance] hideTab:YES];
}
-(void)initData{
    select = @"star";
    refreshControl = [[UIRefreshControl alloc] init];
    refreshControl.backgroundColor = mainTripBackColor;
    refreshControl.tintColor = [UIColor whiteColor];
    [refreshControl addTarget:self action:@selector(refreshData) forControlEvents:UIControlEventValueChanged];
    
    _tbView.refreshControl = refreshControl;
    
    imgBlur.image = [UIImage imageNamed:@"golf_girl.png"];
    [self blurEffect:imgBlur];
}

-(void)layoutControl{
    imgPhoto.layer.cornerRadius = imgPhoto.frame.size.height/2;
    imgPhoto.layer.masksToBounds = YES;
    btnView.layer.cornerRadius = 5;
    btnView.layer.masksToBounds = YES;
}

-(void)ChangeSelect{
    if([select isEqualToString:@"star"]){
        [btnStar setTitleColor:mainGoldColor forState:UIControlStateNormal];
        lblineStar.backgroundColor = mainGoldColor;
        [btnRich setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        lblineRich.backgroundColor = [UIColor clearColor];
        [btnPraise setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        lblinePraise.backgroundColor = [UIColor clearColor];
        [btnCookie setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        lblineCookie.backgroundColor = [UIColor clearColor];
        
    }else if([select isEqualToString:@"rich"]){
        [btnStar setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        lblineStar.backgroundColor = [UIColor clearColor];
        [btnRich setTitleColor:mainGoldColor forState:UIControlStateNormal];
        lblineRich.backgroundColor = mainGoldColor;
        [btnPraise setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        lblinePraise.backgroundColor = [UIColor clearColor];
        [btnCookie setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        lblineCookie.backgroundColor = [UIColor clearColor];
        
        
    }else if([select isEqualToString:@"praise"]){
        [btnStar setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        lblineStar.backgroundColor = [UIColor clearColor];
        [btnRich setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        lblineRich.backgroundColor = [UIColor clearColor];
        [btnPraise setTitleColor:mainGoldColor forState:UIControlStateNormal];
        lblinePraise.backgroundColor = mainGoldColor;
        [btnCookie setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        lblineCookie.backgroundColor = [UIColor clearColor];
        
        
    }else{
        [btnStar setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        lblineStar.backgroundColor = [UIColor clearColor];
        [btnRich setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        lblineRich.backgroundColor = [UIColor clearColor];
        [btnPraise setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        lblinePraise.backgroundColor = [UIColor clearColor];
        [btnCookie setTitleColor:mainGoldColor forState:UIControlStateNormal];
        lblineCookie.backgroundColor = mainGoldColor;
       
    }
}

#pragma mark Table View Delegate

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    // Return the number of sections.
    if (arrData) {
        UILabel *messageLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, self.view.bounds.size.width, self.view.bounds.size.height)];
        
        messageLabel.textColor = [UIColor whiteColor];
        messageLabel.numberOfLines = 0;
        messageLabel.textAlignment = NSTextAlignmentCenter;
        [messageLabel sizeToFit];
        
        _tbView.backgroundView = messageLabel;
        //        _tbView.separatorStyle = UITableViewCellSeparatorStyleSingleLine;
        return 1;
        
    } else {
        
        // Display a message when the table is empty
        UILabel *messageLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, self.view.bounds.size.width, self.view.bounds.size.height)];
        
        messageLabel.text = @"No data is currently available. Please pull down to refresh.";
        messageLabel.textColor = [UIColor whiteColor];
        messageLabel.numberOfLines = 0;
        messageLabel.textAlignment = NSTextAlignmentCenter;
        messageLabel.font = [UIFont fontWithName:@"Palatino-Italic" size:20];
        [messageLabel sizeToFit];
        
        _tbView.backgroundView = messageLabel;
        _tbView.separatorStyle = UITableViewCellSeparatorStyleNone;
        
    }
    
    return 0;
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return [arrData count];
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    float h = 106;
    return h ;
    
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSMutableDictionary * row = [arrData objectAtIndex:indexPath.row];
    RankCell *cell = [[NSBundle mainBundle] loadNibNamed:@"RankCell" owner:self options:nil][0];
    cell.imgPhoto.layer.cornerRadius = cell.imgPhoto.frame.size.height/2;
    cell.imgPhoto.layer.masksToBounds = YES;
    cell.lbName.text = @"3月1日出发";
    cell.lbNo.text = @"中信嘉丽泽锦标场……";
    cell.lbNum.text = @"中信嘉丽泽锦标场……";
    cell.lbTotal.text = @"1399/人";
    cell.lbFan.text = @"3/12";
    cell.lbException.text = @"3/12";
    cell.btnView.layer.cornerRadius = 5;
    cell.btnView.layer.masksToBounds = YES;
    
    // this is where you set your color view
    UIView *customColorView = [[UIView alloc] init];
    customColorView.backgroundColor = [UIColor colorWithRed:180/255.0
                                                      green:138/255.0
                                                       blue:171/255.0
                                                      alpha:0.5];
    cell.selectedBackgroundView =  customColorView;
    BOOL lastItemReached = [row isEqual:[arrData lastObject]];
    if (lastItemReached && indexPath.row == [arrData count] - 1)
    {
        NSString * loading = [row objectForKey:@"loading"];
        if([loading isEqualToString:@"true"]){
            LoadingCell * cellloading =[[NSBundle mainBundle] loadNibNamed:@"LoadingCell" owner:self options:nil][0];
            
            return cellloading;
        }else{
            [self performSelector:@selector(launchLoadMore) withObject:nil afterDelay:0.01];
            return cell;
            
        }
    }
    return cell;
    
}

-(void)launchLoadMore{
    if(!bLoadMore){
        return;
    }
    _pageNo++;
    
    NSMutableDictionary * lastItem = [arrData lastObject];
    NSString * loading = [lastItem objectForKey:@"loading"];
    if(![loading isEqualToString:@"true"]){
        NSMutableDictionary * loadItem = [[NSMutableDictionary alloc]init];
        [loadItem setObject:@"true" forKey:@"loading"];
        [arrData addObject:loadItem];
        
        [_tbView reloadData];
        
        /////////////////// get more data ///////////////////////
        [self performSelector:@selector(getLoadMore) withObject:nil afterDelay:0.4];
        
    }
    
}
-(void)moveToBottom{
    NSIndexPath * indexpath =[NSIndexPath indexPathForRow:[arrData count]-1 inSection:0];
    [_tbView scrollToRowAtIndexPath:indexpath atScrollPosition:UITableViewScrollPositionBottom animated:YES];
    
}
#pragma mark Load Data
-(void)loadData{
    arrData = [[NSMutableArray alloc]init];
    NSMutableDictionary * item = [[NSMutableDictionary alloc]initWithCapacity:0];
    [item setObject:@"one" forKey:@"one"];
    [arrData addObject:item];
    [arrData addObject:item];
    [arrData addObject:item];
    [arrData addObject:item];
    [arrData addObject:item];
    [arrData addObject:item];
    [arrData addObject:item];
    
    bLoadMore = YES;
    
}

-(void)refreshData{
    arrData = [[NSMutableArray alloc]init];
    NSMutableDictionary * item = [[NSMutableDictionary alloc]initWithCapacity:0];
    [item setObject:@"one" forKey:@"one"];
    [arrData addObject:item];
    [arrData addObject:item];
    [arrData addObject:item];
    [arrData addObject:item];
    [arrData addObject:item];
    [arrData addObject:item];
    [arrData addObject:item];
    
    [refreshControl endRefreshing];
    [_tbView reloadData];
    _pageNo = 0;
    bLoadMore = YES;
    
}

-(void)getLoadMore{
    NSMutableDictionary * item = [[NSMutableDictionary alloc]initWithCapacity:0];
    // call loadmore api
    
    [self performSelector:@selector(moveToBottom) withObject:nil afterDelay:0];
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(2 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        [arrData removeLastObject];
        bLoadMore = NO;
        
        [item setObject:@"one" forKey:@"one"];
        [arrData addObject:item];
        [arrData addObject:item];
        [arrData addObject:item];
        [arrData addObject:item];
        [arrData addObject:item];
        [arrData addObject:item];
        [arrData addObject:item];
        bLoadMore = YES;
        
        [_tbView reloadData];
    });
    
    
}
-(IBAction)ClickSelect:(UIButton *)sender{
    NSInteger tag = sender.tag;
    if(tag == 1){
        select = @"star";

    }else if(tag == 2){
        select = @"rich";

    }else if(tag == 3){
        select = @"praise";

    }else{
        select = @"cookie";
    }
    [self ChangeSelect];
}

-(IBAction)ClickBack:(id)sender{
    [[GolfMainViewController sharedInstance] hideTab:NO];
    [self.navigationController popViewControllerAnimated:YES];
}
@end

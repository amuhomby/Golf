//
//  AnchorController.m
//  Golf
//
//  Created by MacAdmin on 3/30/18.
//  Copyright © 2018 MacAdmin. All rights reserved.
//

#import "AnchorController.h"
#import "AnchorCell.h"
#import "LoadingCell.h"
#import "SVProgressHUD.h"
#import "GolfMainViewController.h"
#import "UserProfileController.h"


@interface AnchorController ()<UITableViewDelegate, UITableViewDataSource>
{
    NSMutableArray * arrData;
    BOOL bLoadMore;
    NSInteger  _pageNo;
    UIRefreshControl *refreshControl;
}
@end

@implementation AnchorController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    [self initdata];
    
    refreshControl = [[UIRefreshControl alloc] init];
    refreshControl.backgroundColor = mainTripBackColor;
    refreshControl.tintColor = [UIColor whiteColor];
    [refreshControl addTarget:self action:@selector(refreshData) forControlEvents:UIControlEventValueChanged];
    
    _tbView.refreshControl = refreshControl;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    [[GolfMainViewController sharedInstance] hideTab:YES];
}

-(void)initdata{
    bLoadMore = NO;
    _pageNo = 0;
    
}
#pragma mark Table View Delegate
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    NSInteger index = indexPath.row;
    UserProfileController * vc = [[UserProfileController alloc] initWithNibName:@"UserProfileController" bundle:nil];
    [self.navigationController pushViewController:vc animated:YES];
}


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
        //        _tbTrip.separatorStyle = UITableViewCellSeparatorStyleSingleLine;
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
    
    float h = 80;
    return h ;
    
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSMutableDictionary * row = [arrData objectAtIndex:indexPath.row];
    AnchorCell *cell = [[NSBundle mainBundle] loadNibNamed:@"AnchorCell" owner:self options:nil][0];
    cell.imgPhoto.image = [UIImage imageNamed:@"golf_1.png"];
    cell.imgPhoto.layer.cornerRadius = cell.imgPhoto.frame.size.height/2;
    cell.imgPhoto.layer.masksToBounds = YES;
    cell.lbName.text = @"主播名称";
    cell.lbNum.text = @"3个新内容";
    
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
        [arrData addObject:item];
        [arrData addObject:item];

        bLoadMore = YES;
        
        [_tbView reloadData];
    });
    
}

-(IBAction)ClickBack:(id)sender{
    [[GolfMainViewController sharedInstance] hideTab: NO];
    [self.navigationController popViewControllerAnimated:YES];
}
@end

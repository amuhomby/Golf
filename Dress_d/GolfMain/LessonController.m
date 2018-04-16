//
//  LessonController.m
//  Golf
//
//  Created by MacAdmin on 3/31/18.
//  Copyright © 2018 MacAdmin. All rights reserved.
//

#import "LessonController.h"
#import "HMSegmentedControl.h"
#import "GolfMainViewController.h"
#import "LoadingCell.h"
#import "ShopOrderCell.h"

@interface LessonController ()<UITableViewDelegate, UITableViewDataSource>

@end

@implementation LessonController
{
    CGFloat segmentHeight;
    NSMutableArray * arrData;
    BOOL bLoadMore;
    NSInteger  _pageNo;
    UIRefreshControl *refreshControl;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    refreshControl = [[UIRefreshControl alloc] init];
    refreshControl.backgroundColor = mainTripBackColor;
    refreshControl.tintColor = [UIColor whiteColor];
    [refreshControl addTarget:self action:@selector(refreshData) forControlEvents:UIControlEventValueChanged];
    
    _tbView.refreshControl = refreshControl;
    [self initData];
    [self layoutControl];

}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    [[GolfMainViewController sharedInstance] hideTab:YES];
}

-(void)initData{
    segmentHeight = 40;
    bLoadMore = NO;
    _pageNo = 0;
}
-(void)layoutTBview{
    CGRect frame = _tbView.frame;
    CGFloat height= [UIScreen mainScreen].bounds.size.height;
    frame.origin.y = segmentHeight;
    frame.size.height = height - segmentHeight - vwTop.frame.size.height;
    _tbView.frame = frame;
}
-(void)layoutControl{
    //     Segmented control with more customization and indexChangeBlock
    CGFloat viewWidth = [UIScreen mainScreen].bounds.size.width;
    HMSegmentedControl *segmentedControl3 = [[HMSegmentedControl alloc] initWithSectionTitles:@[@"全部", @"待付款", @"待收货", @"已完成", @"已取消"]];
    [segmentedControl3 setFrame:CGRectMake(0, 0, viewWidth, segmentHeight)];
    [segmentedControl3 addTarget:self action:@selector(segmentedControlChangedValue:) forControlEvents:UIControlEventValueChanged];
    segmentedControl3.selectionIndicatorHeight = 2.0f;
    segmentedControl3.backgroundColor = mainDarkColor; //[UIColor colorWithRed:0.1 green:0.4 blue:0.8 alpha:1];
    segmentedControl3.titleTextAttributes = @{NSForegroundColorAttributeName : [UIColor whiteColor]};
    segmentedControl3.selectedTitleTextAttributes = @{NSForegroundColorAttributeName : mainGoldColor};
    
    segmentedControl3.selectionIndicatorColor = mainGoldColor;
    segmentedControl3.selectionIndicatorBoxColor = [UIColor blackColor];
    
    segmentedControl3.selectionIndicatorBoxOpacity = 1.0;
    segmentedControl3.selectionStyle = HMSegmentedControlSelectionStyleBox;
    segmentedControl3.selectedSegmentIndex = HMSegmentedControlNoSegment;
    segmentedControl3.selectionIndicatorLocation = HMSegmentedControlSelectionIndicatorLocationDown;
    segmentedControl3.shouldAnimateUserSelection = YES;
    segmentedControl3.tag = 2;
    [vwBack addSubview:segmentedControl3];
    
    [segmentedControl3 setSelectedSegmentIndex:0];
    
    
    CGRect frame = _tbView.frame;
    CGFloat height= [UIScreen mainScreen].bounds.size.height;
    frame.origin.y = segmentedControl3.frame.origin.y + segmentedControl3.frame.size.height;
    frame.size.height = height - segmentHeight - vwTop.frame.size.height;
    _tbView.frame = frame;
    
}

#pragma mark HMSegment Delegate
- (void)segmentedControlChangedValue:(HMSegmentedControl *)segmentedControl {
    NSLog(@"Selected index %ld (via UIControlEventValueChanged)", (long)segmentedControl.selectedSegmentIndex);
}


#pragma mark Table View Delegate
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    NSInteger index = indexPath.row;
    
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
    
    float h = 160;
    return h ;
    
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSMutableDictionary * row = [arrData objectAtIndex:indexPath.row];
    ShopOrderCell *cell = [[NSBundle mainBundle] loadNibNamed:@"ShopOrderCell" owner:self options:nil][0];
    cell.imgPhoto.image = [UIImage imageNamed:@"golf_1.png"];
    cell.imgPhoto.layer.cornerRadius = cell.imgPhoto.frame.size.height/8;
    cell.imgPhoto.layer.masksToBounds = YES;
    cell.lbGoodName.text = @"主播名称";
    cell.lbPrice.text = @"Y1399";
    cell.lbDate.text = @"20180-02-05 20:30";
    cell.lbSize.text = @"x2";
    cell.lbTotal.text = @"共1件商品，总金额";
    cell.lbTotalPrice.text = @"Y2399";
    cell.btnPay.layer.cornerRadius = cell.btnPay.frame.size.height/2;
    cell.btnPay.layer.masksToBounds=YES;
    cell.btnPay.tag = indexPath.row;
    [cell.btnPay addTarget:self action:@selector(ClickPay:) forControlEvents:UIControlEventTouchUpInside];
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
-(void)ClickPay:(UIButton *)btn{
    NSInteger index = btn.tag;
}
-(IBAction)ClickBack:(id)sender{
    [[GolfMainViewController sharedInstance] hideTab: NO];
    [self.navigationController popViewControllerAnimated:YES];
}


@end

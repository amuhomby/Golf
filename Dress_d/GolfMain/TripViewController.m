//
//  TripViewController.m
//  Golf
//
//  Created by MacAdmin on 3/29/18.
//  Copyright © 2018 MacAdmin. All rights reserved.
//

#import "TripViewController.h"
#import "TripCell.h"
#import "LoadingCell.h"
#import "SVProgressHUD.h"
#import "TripDetailController.h"

@interface TripViewController ()<UITableViewDelegate, UITableViewDataSource>
{
    NSMutableArray * arrTrip;
    BOOL bLoadMore;
    NSInteger  _pageNo;
    UIRefreshControl *refreshControl;
}
@end

@implementation TripViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
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
    [self layoutControl];
    
}
-(void)initdata{
    bLoadMore = NO;
    _pageNo = 0;
    
}
/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/


-(void)layoutTopImage{
    CGRect frame = _vwImage.frame;
    frame.origin.y = 0;
    frame.size.height = frame.size.width * 0.4;
    _vwImage.frame = frame;
}

-(void)layoutSegment{
    CGFloat viewWidth = [UIScreen mainScreen].bounds.size.width;
    UIImage * ig1 = [UIImage imageNamed:@"golf_person.png"];
    UIImage * ig2 = [UIImage imageNamed:@"golf_people.png"];
    UIImage * ig3 = [UIImage imageNamed:@"golf_select.png"];
    
    UIImage * igs1 = [UIImage imageNamed:@"golf_person_g.png"];
    UIImage * igs2 = [UIImage imageNamed:@"golf_people_g.png"];
    UIImage * igs3 = [UIImage imageNamed:@"golf_select_g.png"];
    
    NSArray<UIImage *> *images = @[ig1,ig2,ig3];
    
    NSArray<UIImage *> *selectedImages = @[igs1,igs2,igs3];
    NSArray<NSString *> *titles = @[@"单人参团", @"多人参团", @"定制"];
    
    HMSegmentedControl *segmentedControl3 = [[HMSegmentedControl alloc] initWithSectionImages:images sectionSelectedImages:selectedImages titlesForSections:titles];
        [segmentedControl3 setFrame:CGRectMake(0, 0, viewWidth, 75)];

        segmentedControl3.selectionIndicatorHeight = 2.0f;
        segmentedControl3.backgroundColor = mainDarkColor;
        segmentedControl3.titleTextAttributes = @{NSForegroundColorAttributeName : [UIColor whiteColor] };
    
        segmentedControl3.selectedTitleTextAttributes = @{NSForegroundColorAttributeName : mainGoldColor};
    
        segmentedControl3.selectionIndicatorColor = mainGoldColor;
        segmentedControl3.selectionIndicatorBoxColor = [UIColor blackColor];
    
        segmentedControl3.selectionIndicatorBoxOpacity = 1.0;
        segmentedControl3.selectionStyle = HMSegmentedControlSelectionStyleBox;
        segmentedControl3.selectedSegmentIndex = HMSegmentedControlNoSegment;
        segmentedControl3.selectionIndicatorLocation = HMSegmentedControlSelectionIndicatorLocationDown;
        segmentedControl3.shouldAnimateUserSelection = YES;
        [segmentedControl3 addTarget:self action:@selector(segmentedControlChangedValue:) forControlEvents:UIControlEventValueChanged];

        segmentedControl3.tag = 2;
        [_vwBack addSubview:segmentedControl3];
    
    [segmentedControl3 setSelectedSegmentIndex:0];
    CGRect frame = segmentedControl3.frame;
    frame.origin.x = 0;
    frame.origin.y = _imgTop.frame.origin.y + _imgTop.frame.size.height;
    segmentedControl3.frame = frame;
    
    CGRect frame1 = _vwSort.frame;
    frame1.origin.x = 0;
    frame1.origin.y = segmentedControl3.frame.origin.y + segmentedControl3.frame.size.height;
    _vwSort.frame = frame1;
}
-(void)layoutTable{
    CGRect frame = _tbView.frame;
    frame.origin.y = _vwSort.frame.origin.y + _vwSort.frame.size.height;
    frame.size.height = _vwBack.frame.size.height - frame.origin.y;
    _tbView.frame = frame;
}
-(void)layoutControl{

    [self layoutTopImage];
    [self layoutSegment];
    [self layoutTable];
}

#pragma mark HMSegment Delegate
- (void)segmentedControlChangedValue:(HMSegmentedControl *)segmentedControl {
    NSLog(@"Selected index %ld (via UIControlEventValueChanged)", (long)segmentedControl.selectedSegmentIndex);
}

#pragma mark Table View Delegate
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    NSInteger index = indexPath.row;
    TripDetailController * vc = [[TripDetailController alloc] initWithNibName:@"TripDetailController" bundle:nil];
    [self.navigationController pushViewController:vc animated:YES];
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    // Return the number of sections.
    if (arrTrip) {
        UILabel *messageLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, self.view.bounds.size.width, self.view.bounds.size.height)];
        
        messageLabel.textColor = [UIColor whiteColor];
        messageLabel.numberOfLines = 0;
        messageLabel.textAlignment = NSTextAlignmentCenter;
        [messageLabel sizeToFit];

        _tbView.backgroundView = messageLabel;
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
    return [arrTrip count];
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    float h = 106;
    return h ;
    
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSMutableDictionary * row = [arrTrip objectAtIndex:indexPath.row];
    TripCell *cell = [[NSBundle mainBundle] loadNibNamed:@"TripCell" owner:self options:nil][0];
    cell.imgPhoto.layer.cornerRadius = 5;
    cell.imgPhoto.layer.masksToBounds = YES;
    cell.lbDate.text = @"3月1日出发";
    cell.lbContent.text = @"中信嘉丽泽锦标场……";
    cell.lbSmallCon.text = @"中信嘉丽泽锦标场……";
    cell.lbPrice.text = @"1399/人";
    cell.lbszPerson.text = @"3/12";
    
    // this is where you set your color view
    UIView *customColorView = [[UIView alloc] init];
    customColorView.backgroundColor = [UIColor colorWithRed:180/255.0
                                                      green:138/255.0
                                                       blue:171/255.0
                                                      alpha:0.5];
    cell.selectedBackgroundView =  customColorView;
    BOOL lastItemReached = [row isEqual:[arrTrip lastObject]];
    if (lastItemReached && indexPath.row == [arrTrip count] - 1)
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
    
        NSMutableDictionary * lastItem = [arrTrip lastObject];
        NSString * loading = [lastItem objectForKey:@"loading"];
        if(![loading isEqualToString:@"true"]){
            NSMutableDictionary * loadItem = [[NSMutableDictionary alloc]init];
            [loadItem setObject:@"true" forKey:@"loading"];
            [arrTrip addObject:loadItem];
            
            [_tbView reloadData];

            /////////////////// get more data ///////////////////////
            [self performSelector:@selector(getLoadMore) withObject:nil afterDelay:0.4];
            
        }
    
}
-(void)moveToBottom{
        NSIndexPath * indexpath =[NSIndexPath indexPathForRow:[arrTrip count]-1 inSection:0];
        [_tbView scrollToRowAtIndexPath:indexpath atScrollPosition:UITableViewScrollPositionBottom animated:YES];

}
#pragma mark Load Data
-(void)loadData{
    arrTrip = [[NSMutableArray alloc]init];
    NSMutableDictionary * item = [[NSMutableDictionary alloc]initWithCapacity:0];
    [item setObject:@"one" forKey:@"one"];
    [arrTrip addObject:item];
    [arrTrip addObject:item];
    [arrTrip addObject:item];
    [arrTrip addObject:item];
    [arrTrip addObject:item];
    [arrTrip addObject:item];
    [arrTrip addObject:item];
    
    bLoadMore = YES;

}

-(void)refreshData{
    arrTrip = [[NSMutableArray alloc]init];
    NSMutableDictionary * item = [[NSMutableDictionary alloc]initWithCapacity:0];
    [item setObject:@"one" forKey:@"one"];
    [arrTrip addObject:item];
    [arrTrip addObject:item];
    [arrTrip addObject:item];
    [arrTrip addObject:item];
    [arrTrip addObject:item];
    [arrTrip addObject:item];
    [arrTrip addObject:item];
    
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
        [arrTrip removeLastObject];
        bLoadMore = NO;
        
        [item setObject:@"one" forKey:@"one"];
        [arrTrip addObject:item];
        [arrTrip addObject:item];
        [arrTrip addObject:item];
        [arrTrip addObject:item];
        [arrTrip addObject:item];
        [arrTrip addObject:item];
        [arrTrip addObject:item];
        bLoadMore = YES;
        
        [_tbView reloadData];
    });
}

@end

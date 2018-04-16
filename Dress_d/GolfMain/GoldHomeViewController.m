//
//  GoldHomeViewController.m
//  Dress_d
//
//  Created by MacAdmin on 9/11/17.
//  Copyright © 2017 dev. All rights reserved.
//
// https://www.youtube.com/watch?v=F68bbzOOOdY
// https://www.youtube.com/watch?v=IvVpbNaSk6k
// https://www.youtube.com/watch?v=PmaZ0SlyZ9E

#import "GoldHomeViewController.h"
#import "GolfHomeRecommendViewCell.h"
#import "GolfHomeRecommFlowLayout.h"
#import "StarRankController.h"
#import "DetailController.h"

#import "HomeViewCell.h"
#import "UIImageView+WebCache.h"
#import "PostDetailViewController.h"
#import "DressProfileViewController.h"
#import "GolfMainViewController.h"
#import "DressSearchViewController.h"
#import "LikeViewController.h"
#import "HomeStyleViewCell.h"
#import "NoRltViewCell.h"
#import "SVProgressHUD.h"
#import "BOZPongRefreshControl.h"
#import "FriendProfileViewController.h"
#import "BrandViewController.h"
#import "LoadingCell.h"
#import "AddViewController.h"
#import "ReportViewController.h"
#import "ProductViewController.h"
#import "MyProfileSettingViewController.h"

#import <MessageUI/MessageUI.h>
#import <ContactsUI/ContactsUI.h>
#import <Contacts/Contacts.h>
#import <MessageUI/MessageUI.h>
#import "NoRltFriendTableViewCell.h"


@interface GoldHomeViewController ()<TYCyclePagerViewDataSource,
TYCyclePagerViewDelegate,
UICollectionViewDelegate,
UICollectionViewDataSource>

@property (nonatomic, strong) TYCyclePagerView *pagerView;
@property (nonatomic, strong) TYPageControl *pageControl;
@property (nonatomic, strong) NSMutableArray *mDataPageViewer;
@property (nonatomic, strong) NSMutableArray *mDataCollection;

@end

@implementation GoldHomeViewController
{
    Boolean _waiting;
    UIRefreshControl * refreshControl;

}
static GoldHomeViewController * mainInstance;

+(GoldHomeViewController *)sharedInstance{
    return mainInstance;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.

    collView.collectionViewLayout = [[GolfHomeRecommFlowLayout alloc]init];
    refreshControl = [[UIRefreshControl alloc] init];
    refreshControl.backgroundColor = [UIColor blackColor];
    refreshControl.tintColor = [UIColor whiteColor];
    [refreshControl addTarget:self action:@selector(refreshData) forControlEvents:UIControlEventValueChanged];
    
    collView.refreshControl = refreshControl;
    if(mainInstance == nil)
        mainInstance = self;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void)viewWillDisappear:(BOOL)animated{
    [super viewWillDisappear:animated];
//    [self.pongRefreshControl finishedLoading];
}
-(void)viewDidAppear:(BOOL)animated{
    [super viewDidAppear:YES];
}
-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    [self layoutControl];

}



- (void)addPagerView {
    TYCyclePagerView *pagerView = [[TYCyclePagerView alloc]init];
    pagerView.layer.borderWidth = 0;
    pagerView.isInfiniteLoop = YES;
    pagerView.autoScrollInterval = 3.0;
    pagerView.dataSource = self;
    pagerView.delegate = self;
    // registerClass or registerNib
    [pagerView registerClass:[GolfHomeCollectionViewCell class] forCellWithReuseIdentifier:@"cellId"];
    [scrollview addSubview:pagerView];
    _pagerView = pagerView;
}

// add page controller to pagerview
- (void)addPageControl {
    TYPageControl *pageControl = [[TYPageControl alloc]init];
    //pageControl.numberOfPages = _datas.count;
    pageControl.currentPageIndicatorSize = CGSizeMake(8, 8);
    //    pageControl.pageIndicatorImage = [UIImage imageNamed:@"Dot"];
    //    pageControl.currentPageIndicatorImage = [UIImage imageNamed:@"DotSelected"];
    //    pageControl.contentInset = UIEdgeInsetsMake(0, 20, 0, 20);
    //    pageControl.contentHorizontalAlignment = UIControlContentHorizontalAlignmentCenter;
    //    pageControl.contentVerticalAlignment = UIControlContentVerticalAlignmentCenter;
    //    [pageControl addTarget:self action:@selector(pageControlValueChangeAction:) forControlEvents:UIControlEventValueChanged];
    [_pagerView addSubview:pageControl];
    _pageControl = pageControl;
    
    
    _pagerView.frame = CGRectMake(0, 0, CGRectGetWidth(self.view.frame), CGRectGetWidth(self.view.frame)* 0.5);
    _pageControl.frame = CGRectMake(0, CGRectGetHeight(_pagerView.frame) - 26, CGRectGetWidth(_pagerView.frame), 26);
}

- (void)loadPageViewData {
    _mDataCollection = [[NSMutableArray alloc]init];
    NSMutableArray *datas = [NSMutableArray array];
    for (int i = 0; i < 7; ++i) {
        NSMutableDictionary * item = [[NSMutableDictionary alloc]init];
        int remain = i%2;
        if (remain == 0) {
            [item setObject:@"golf_1.png" forKey:@"image"];
            [datas addObject:@"golf_1.png"];
        }else{
            [item setObject:@"golf_2.png" forKey:@"image"];
            [datas addObject:@"golf_2.png"];
        }
        [_mDataCollection addObject:item];
    }
    _mDataPageViewer = [datas copy];
    _pageControl.numberOfPages = _mDataPageViewer.count;
    [_pagerView reloadData];
    //[_pagerView scrollToItemAtIndex:3 animate:YES];
    
    [collView reloadData];
}
-(void)refreshData{
    
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        [refreshControl endRefreshing];
        _mDataCollection = [[NSMutableArray alloc]init];
        for (int i = 0; i < 7; ++i) {
            NSMutableDictionary * item = [[NSMutableDictionary alloc]init];
            int remain = i%2;
            if (remain == 0) {
                [item setObject:@"golf_1.png" forKey:@"image"];
            }else{
                [item setObject:@"golf_2.png" forKey:@"image"];
            }
            [_mDataCollection addObject:item];
        }
        
        //[_pagerView scrollToItemAtIndex:3 animate:YES];
        
        [collView reloadData];    });
}
-(void)viewWidget{
    CGRect frame = vwWidget.frame;
    CGRect frame1 = _pagerView.frame;
    frame.origin.x = 0;
    frame.origin.y = frame1.origin.y + frame1.size.height;
    vwWidget.frame = frame;
    
    imgOne.layer.cornerRadius = imgOne.frame.size.height/2;
    imgOne.layer.masksToBounds = YES;
    imgTwo.layer.cornerRadius = imgTwo.frame.size.height/2;
    imgTwo.layer.masksToBounds = YES;
    imgThr.layer.cornerRadius = imgThr.frame.size.height/2;
    imgThr.layer.masksToBounds = YES;
    
    lbOne.layer.cornerRadius = lbOne.frame.size.height/2;
    lbOne.layer.masksToBounds = YES;
    lbTwo.layer.cornerRadius = lbTwo.frame.size.height/2;
    lbTwo.layer.masksToBounds = YES;
    lbThr.layer.cornerRadius = lbThr.frame.size.height/2;
    lbThr.layer.masksToBounds = YES;
}

-(void)viewSee{
    CGRect frame = vwSee.frame;
    CGRect frame1 = vwWidget.frame;
    frame.origin.x = 0;
    frame.origin.y = frame1.origin.y + frame1.size.height;
    vwSee.frame = frame;
}

-(void)layoutCollview{
    CGRect frame = collView.frame;
    CGRect frame1 = vwSee.frame;
    frame.origin.y = frame1.origin.y + frame1.size.height;
    frame.size.height = scrollview.frame.size.height - frame.origin.y ;
    collView.frame = frame;
    
}

-(void)layoutScrollview{
    CGFloat width = [UIScreen mainScreen].bounds.size.width;
    CGFloat heigth = collView.frame.origin.y + collView.frame.size.height;
    CGSize scrollSize = CGSizeMake(width, heigth);
    scrollview.contentSize = scrollSize;
}

-(void)layoutCategoryBtns{
    CGFloat cornerR = 3;
    btnCate1.layer.cornerRadius = cornerR;
    btnCate1.layer.masksToBounds = YES;
    btnCate2.layer.cornerRadius = cornerR;
    btnCate2.layer.masksToBounds = YES;
    btnCate3.layer.cornerRadius = cornerR;
    btnCate3.layer.masksToBounds = YES;
    btnCate4.layer.cornerRadius = cornerR;
    btnCate4.layer.masksToBounds = YES;
    btnCate5.layer.cornerRadius = cornerR;
    btnCate5.layer.masksToBounds = YES;
    btnCate6.layer.cornerRadius = cornerR;
    btnCate6.layer.masksToBounds = YES;

}
-(void)layoutControl{
    [[UITextField appearanceWhenContainedInInstancesOfClasses:@[[UISearchBar class]]] setTextColor:[UIColor whiteColor]];

    UITextField *txfSearchField = [srhBar valueForKey:@"_searchField"];

    txfSearchField.layer.cornerRadius = 14;
    txfSearchField.layer.masksToBounds = YES;
    
    txfSearchField.textColor = [UIColor whiteColor];
    [txfSearchField setValue:[UIColor whiteColor] forKeyPath:@"_placeholderLabel.textColor"];
    
    UIImageView *imgView = (UIImageView*)txfSearchField.leftView;
    imgView.image = [imgView.image imageWithRenderingMode:UIImageRenderingModeAlwaysTemplate];
    imgView.tintColor = [UIColor whiteColor];
    
    UIButton *btnClear = (UIButton*)[txfSearchField valueForKey:@"clearButton"];
    [btnClear setImage:[btnClear.imageView.image imageWithRenderingMode:UIImageRenderingModeAlwaysTemplate] forState:UIControlStateNormal];
    btnClear.tintColor = [UIColor whiteColor];
    
    btnSelection.layer.cornerRadius = 3;
    btnSelection.layer.masksToBounds = YES;
    btnSelection.layer.borderWidth = 1;
    btnSelection.layer.borderColor = [UIColor whiteColor].CGColor;
    
    lbBadge.layer.cornerRadius = lbBadge.layer.bounds.size.height/2;
    lbBadge.layer.masksToBounds = YES;
    CGFloat pxBadge = btnBadge.frame.origin.x + btnBadge.frame.size.width;
    CGFloat pyBadge = btnBadge.frame.origin.y ;
    CGPoint badgeCenter = CGPointMake(pxBadge, pyBadge);
    lbBadge.center = badgeCenter;
    

    //     Segmented control with more customization and indexChangeBlock
    CGFloat viewWidth = [UIScreen mainScreen].bounds.size.width * 5/ 6;
    HMSegmentedControl *segmentedControl3 = [[HMSegmentedControl alloc] initWithSectionTitles:@[@"One", @"Two", @"Three", @"Four", @"Five", @"Six", @"Six", @"Six", @"Six"]];
    [segmentedControl3 setFrame:CGRectMake(0, 0, viewWidth, 40)];
    [segmentedControl3 addTarget:self action:@selector(segmentedControlChangedValue:) forControlEvents:UIControlEventValueChanged];

    segmentedControl3.selectionIndicatorHeight = 3.0f;
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
    
    CGRect fvbCategory = vwBtnCategory.frame;
    fvbCategory.origin.x = segmentedControl3.frame.origin.x + segmentedControl3.frame.size.width;
    fvbCategory.origin.y = 0;
    fvbCategory.size.width = [UIScreen mainScreen].bounds.size.width - segmentedControl3.frame.size.width;
    fvbCategory.size.height = 40;
    vwBtnCategory.frame = fvbCategory;
    [vwBtnCategory setBackgroundColor:mainDarkColor];
    igCategory.center = btnCategory.center;
    
    [self addPagerView];
    [self addPageControl];
    [self loadPageViewData];
    
    [self viewWidget];
    [self viewSee];
    [self layoutCollview];
    
    [self layoutScrollview];
    [self layoutCategoryBtns];
}

#pragma mark - TYCyclePagerViewDataSource

- (NSInteger)numberOfItemsInPagerView:(TYCyclePagerView *)pageView {
    return _mDataPageViewer.count;
}

- (UICollectionViewCell *)pagerView:(TYCyclePagerView *)pagerView cellForItemAtIndex:(NSInteger)index {
    GolfHomeCollectionViewCell *cell = [pagerView dequeueReusableCellWithReuseIdentifier:@"cellId" forIndex:index];
    NSString * url = [_mDataPageViewer objectAtIndex:index];
    UIImage * image = [UIImage imageNamed:url];
    [cell.img setImage:image];
    return cell;
}

- (TYCyclePagerViewLayout *)layoutForPagerView:(TYCyclePagerView *)pageView {
    TYCyclePagerViewLayout *layout = [[TYCyclePagerViewLayout alloc]init];
    layout.itemSize = CGSizeMake(CGRectGetWidth(pageView.frame)*1.0, CGRectGetHeight(pageView.frame)*1.0);
    layout.itemSpacing = 0;
    //layout.minimumAlpha = 0.3;
    layout.itemHorizontalCenter = YES;
    return layout;
}

- (void)pagerView:(TYCyclePagerView *)pageView didScrollFromIndex:(NSInteger)fromIndex toIndex:(NSInteger)toIndex {
    _pageControl.currentPage = toIndex;
    //[_pageControl setCurrentPage:newIndex animate:YES];
}

#pragma mark HMSegment Delegate
- (void)segmentedControlChangedValue:(HMSegmentedControl *)segmentedControl {
    NSLog(@"Selected index %ld (via UIControlEventValueChanged)", (long)segmentedControl.selectedSegmentIndex);
}

#pragma mark - CollectionDelegate
-(UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(nonnull NSIndexPath *)indexPath{
    
    GolfHomeRecommendViewCell * cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"golfrecell" forIndexPath:indexPath];
    cell.imageview.layer.cornerRadius = 5;
    cell.imageview.layer.masksToBounds = YES;
    NSString * url = [[_mDataCollection objectAtIndex:indexPath.row] objectForKey:@"image"];
    UIImage * image = [UIImage imageNamed:url];
    cell.imageview.image = image;
    return cell;
}
-(NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section{
    return _mDataCollection.count;
}

// for load more.
-(void)collectionView:(UICollectionView *)collectionView didEndDisplayingCell:(nonnull UICollectionViewCell *)cell forItemAtIndexPath:(nonnull NSIndexPath *)indexPath{
    if (indexPath.row == _mDataCollection.count - 1 && !_waiting){
        _waiting = YES;
        [self performSelector:@selector(loadMoreData) withObject:nil afterDelay:0.1];

    }
}

-(void)loadMoreData{
    NSMutableDictionary * item1 = [[NSMutableDictionary alloc]init];
    NSMutableDictionary * item2 = [[NSMutableDictionary alloc]init];
    [item1 setObject:@"golf_1.png" forKey:@"image"];
    [item2 setObject:@"golf_2.png" forKey:@"image"];
    [_mDataCollection addObject:item1];
    [_mDataCollection addObject:item2];
    [_mDataCollection addObject:item1];
    [_mDataCollection addObject:item2];
    [_mDataCollection addObject:item1];
    [_mDataCollection addObject:item2];
    [_mDataCollection addObject:item1];
    [_mDataCollection addObject:item2];
    [_mDataCollection addObject:item1];
    [_mDataCollection addObject:item2];
    [self performSelector:@selector(reloadCollView) withObject:nil afterDelay:2.0];
    _waiting = NO;
}

-(void)reloadCollView{
    [collView reloadData];
}
- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath{
    NSLog(@"DidSelect index %ld", (long)indexPath.row);
    [self goDetail];

}

-(void)goDetail{
    DetailController * vc = [[DetailController alloc]initWithNibName:@"DetailController" bundle:nil];
    [self.navigationController pushViewController:vc animated:YES];
}

-(IBAction)ShowCategory:(id)sender{
    vwCategory.hidden = NO;
    igCategory.image = [UIImage imageNamed:@"golf_rect_g"];
}
-(IBAction)HideCategory:(id)sender{
    vwCategory.hidden = YES;
    igCategory.image = [UIImage imageNamed:@"golf_rect_w"];
}
-(IBAction)SelectCategory:(UIButton *)sender{
    NSInteger categoryIndex = sender.tag;
    NSLog(@"%ld", (long)categoryIndex);
}


-(IBAction)ClickWidget:(id)sender{

    
    StarRankController * vc = [[StarRankController alloc] initWithNibName:@"StarRankController" bundle:nil];
    [self.navigationController pushViewController:vc animated:YES];
}
@end

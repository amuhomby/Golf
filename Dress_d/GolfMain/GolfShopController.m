//
//  GolfShopController.m
//  Golf
//
//  Created by MacAdmin on 3/29/18.
//  Copyright © 2018 MacAdmin. All rights reserved.
//

#import "GolfShopController.h"
#import "GolfHomeCollectionViewCell.h"
#import "GolfHomeRecommFlowLayout.h"
#import "ShopCell.h"
#import "ProductController.h"


@interface GolfShopController ()<TYCyclePagerViewDataSource,
TYCyclePagerViewDelegate,
UICollectionViewDelegate,
UICollectionViewDataSource>
@property (nonatomic, strong) TYCyclePagerView *pagerView;
@property (nonatomic, strong) TYPageControl *pageControl;
@property (nonatomic, strong) NSMutableArray *mDataPageViewer;
@property (nonatomic, strong) NSMutableArray *mDataCollection;
@end

@implementation GolfShopController
{
    Boolean _waiting;
    UIRefreshControl * refreshControl;
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
    
    [self layoutControl];
    

}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    
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
    
    CGFloat width = [UIScreen mainScreen].bounds.size.width;
    CGFloat height = width * 0.5;
    _pagerView.frame = CGRectMake(0, 0, width, height);
    _pageControl.frame = CGRectMake(0, CGRectGetHeight(_pagerView.frame) - 26, CGRectGetWidth(_pagerView.frame), 26);
}
-(void)layoutCollview{
    CGRect frame = collView.frame;
    CGRect frame1 = _pagerView.frame;
    frame.origin.y = frame1.origin.y + frame1.size.height;
    frame.size.height = scrollview.frame.size.height - frame.origin.y ;
    collView.frame = frame;
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
-(void)layoutControl{
    [self addPagerView];
    [self addPageControl];
    [self loadPageViewData];
    [self layoutCollview];
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

#pragma mark - CollectionDelegate
-(UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(nonnull NSIndexPath *)indexPath{
    
    ShopCell * cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"ShopCell" forIndexPath:indexPath];
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
    ProductController * vc=[[ProductController alloc] initWithNibName:@"ProductController" bundle:nil];
    [self.navigationController pushViewController:vc animated:YES];
}

@end

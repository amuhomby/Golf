//
//  ProductController.m
//  Golf
//
//  Created by MacAdmin on 4/1/18.
//  Copyright © 2018 MacAdmin. All rights reserved.
//

#import "ProductController.h"
#import <TYCyclePagerView/TYCyclePagerView.h>
#import "TYPageControl.h"
#import "GolfHomeCollectionViewCell.h"
#import "ShowFlowLayout.h"
#import "ShoesCell.h"
#import "GolfMainViewController.h"
#import "ShoesDetailController.h"

@interface ProductController ()<TYCyclePagerViewDataSource,
TYCyclePagerViewDelegate,
UICollectionViewDelegate,
UICollectionViewDataSource>

@property (nonatomic, strong) TYCyclePagerView *pagerView;
@property (nonatomic, strong) TYPageControl *pageControl;
@end

@implementation ProductController
{
   NSMutableArray *mDataPageViewer;
   NSMutableArray *mDataCollection;
    Boolean _waiting;
    UIRefreshControl * refreshControl;
    // @"total", @"running" @"normal"
    NSString * select;

}
- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    [self initData];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear: animated];
    [[GolfMainViewController sharedInstance] hideTab:YES];

}

-(void)viewDidLayoutSubviews{
    [self layoutControl];
}
-(void)initData{
    UINib *nib1 = [UINib nibWithNibName:@"ShoesCell" bundle: nil];
    [collView registerNib:nib1 forCellWithReuseIdentifier:@"ShoesCell"];
    
    collView.collectionViewLayout = [[ShowFlowLayout alloc]init];
    refreshControl = [[UIRefreshControl alloc] init];
    refreshControl.backgroundColor = [UIColor blackColor];
    refreshControl.tintColor = [UIColor whiteColor];
    [refreshControl addTarget:self action:@selector(refreshData) forControlEvents:UIControlEventValueChanged];
    
    collView.refreshControl = refreshControl;
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
    [vwBack addSubview:pagerView];
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
    _pagerView.frame = CGRectMake(0, 0, width, width* 0.5);
    _pageControl.frame = CGRectMake(0, CGRectGetHeight(_pagerView.frame) - 26, CGRectGetWidth(_pagerView.frame), 26);
}

- (void)loadPageViewData {
    mDataCollection = [[NSMutableArray alloc]init];
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
        [mDataCollection addObject:item];
    }
    mDataPageViewer = [datas copy];
    _pageControl.numberOfPages = mDataPageViewer.count;
    [_pagerView reloadData];
    //[_pagerView scrollToItemAtIndex:3 animate:YES];
    
    [collView reloadData];
}

-(void)layoutBtn{
    CGRect frame = vwBtn.frame;
    CGRect frame1 = _pagerView.frame;
    frame.origin.x= 0;
    frame.origin.y = frame1.origin.y + frame1.size.height;
    vwBtn.frame = frame;
}

-(void)layoutCollView{
    CGRect frame = collView.frame;
    CGRect frame1= vwBtn.frame;
    frame.origin.x = 10;
    frame.origin.y = frame1.origin.y + frame1.size.height;
    frame.size.width = vwBack.frame.size.width - 20;
    frame.size.height = vwBack.frame.size.height - frame.origin.y;
    collView.frame = frame;
}

-(void)layoutControl{
    [self addPagerView];
    [self addPageControl];
    [self loadPageViewData];
    [self layoutBtn];
    [self layoutCollView];
    [self ChangeSelect];
}
#pragma mark - TYCyclePagerViewDataSource

- (NSInteger)numberOfItemsInPagerView:(TYCyclePagerView *)pageView {
    return mDataPageViewer.count;
}

- (UICollectionViewCell *)pagerView:(TYCyclePagerView *)pagerView cellForItemAtIndex:(NSInteger)index {
    GolfHomeCollectionViewCell *cell = [pagerView dequeueReusableCellWithReuseIdentifier:@"cellId" forIndex:index];
    NSString * url = [mDataPageViewer objectAtIndex:index];
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

#pragma mark CollectionView 
-(void)refreshData{
    
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        [refreshControl endRefreshing];
        mDataCollection = [[NSMutableArray alloc]init];
        for (int i = 0; i < 7; ++i) {
            NSMutableDictionary * item = [[NSMutableDictionary alloc]init];
            int remain = i%2;
            if (remain == 0) {
                [item setObject:@"golf_1.png" forKey:@"image"];
            }else{
                [item setObject:@"golf_2.png" forKey:@"image"];
            }
            [mDataCollection addObject:item];
        }
        
        //[_pagerView scrollToItemAtIndex:3 animate:YES];
        
        [collView reloadData];    });
}

#pragma mark - CollectionDelegate
-(UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(nonnull NSIndexPath *)indexPath{
    
    ShoesCell * cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"ShoesCell" forIndexPath:indexPath];
    cell.imgPhoto.layer.cornerRadius = 5;
    cell.imgPhoto.layer.masksToBounds = YES;
    NSString * url = [[mDataCollection objectAtIndex:indexPath.row] objectForKey:@"image"];
    UIImage * image = [UIImage imageNamed:url];
    cell.imgPhoto.image = image;
    return cell;
}

-(NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section{
    return mDataCollection.count;
}

// for load more.
-(void)collectionView:(UICollectionView *)collectionView didEndDisplayingCell:(nonnull UICollectionViewCell *)cell forItemAtIndexPath:(nonnull NSIndexPath *)indexPath{
    if (indexPath.row == mDataCollection.count - 1 && !_waiting){
        _waiting = YES;
        [self performSelector:@selector(loadMoreData) withObject:nil afterDelay:0.1];
        
    }
}

-(void)loadMoreData{
    NSMutableDictionary * item1 = [[NSMutableDictionary alloc]init];
    NSMutableDictionary * item2 = [[NSMutableDictionary alloc]init];
    [item1 setObject:@"golf_1.png" forKey:@"image"];
    [item2 setObject:@"golf_2.png" forKey:@"image"];
    [mDataCollection addObject:item1];
    [mDataCollection addObject:item2];
    [mDataCollection addObject:item1];
    [mDataCollection addObject:item2];
    [mDataCollection addObject:item1];
    [mDataCollection addObject:item2];
    [mDataCollection addObject:item1];
    [mDataCollection addObject:item2];
    [mDataCollection addObject:item1];
    [mDataCollection addObject:item2];
    [self performSelector:@selector(reloadCollView) withObject:nil afterDelay:2.0];
    _waiting = NO;
}

-(void)reloadCollView{
    [collView reloadData];
}
- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath{
    NSLog(@"DidSelect index %ld", (long)indexPath.row);
    ShoesDetailController * vc = [[ShoesDetailController alloc] initWithNibName:@"ShoesDetailController" bundle:nil];
    [self.navigationController pushViewController:vc animated:YES];
}
#pragma mark Change Tab
-(void)ChangeSelect{
    if([select isEqualToString:@"total"]){
        [btnAll setTitleColor:mainGoldColor forState:UIControlStateNormal];
        lbLineAll.backgroundColor = mainGoldColor;
        [btnRunning setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        lbLineRunning.backgroundColor = [UIColor clearColor];
        [btnNormal setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        lbLineNormal.backgroundColor = [UIColor clearColor];
        
    }else if([select isEqualToString:@"running"]){
        [btnAll setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        lbLineAll.backgroundColor = [UIColor clearColor];
        [btnRunning setTitleColor:mainGoldColor forState:UIControlStateNormal];
        lbLineRunning.backgroundColor = mainGoldColor;
        [btnNormal setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        lbLineNormal.backgroundColor = [UIColor clearColor];
        
    }else{
        [btnAll setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        lbLineAll.backgroundColor = [UIColor clearColor];
        [btnRunning setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        lbLineRunning.backgroundColor = [UIColor clearColor];
        [btnNormal setTitleColor:mainGoldColor forState:UIControlStateNormal];
        lbLineNormal.backgroundColor = mainGoldColor;
        
    }
}

#pragma mark Button Click
-(IBAction)ClickBack:(id)sender{
    [[GolfMainViewController sharedInstance] hideTab:NO];
    [self.navigationController popViewControllerAnimated:YES];
}

-(IBAction)ClickTab:(UIButton *)sender{
    NSInteger tag = sender.tag;
    if(tag == 1){
        select = @"total";
    }else if(tag == 2){
        select = @"running";
    }else{
        select = @"normal";
    }
    
    [self ChangeSelect];
}
@end

//
//  CollectionController.m
//  Golf
//
//  Created by MacAdmin on 3/30/18.
//  Copyright © 2018 MacAdmin. All rights reserved.
//

#import "CollectionController.h"
#import "GolfHomeRecommFlowLayout.h"
#import "CollectionPageCell.h"
#import "GolfMainViewController.h"

@interface CollectionController ()
@property (nonatomic, strong) NSMutableArray *mDataCollection;

@end

@implementation CollectionController
{
    Boolean _waiting;
    UIRefreshControl * refreshControl;
    NSString * type;

}
- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    
    UINib *nib = [UINib nibWithNibName:@"CollectionPageCell" bundle: nil];
    [collView registerNib:nib forCellWithReuseIdentifier:@"collectionCell"];
    
    collView.collectionViewLayout = [[GolfHomeRecommFlowLayout alloc]init];
    refreshControl = [[UIRefreshControl alloc] init];
    refreshControl.backgroundColor = mainProfileBackColor;
    refreshControl.tintColor = [UIColor whiteColor];
    [refreshControl addTarget:self action:@selector(refreshData) forControlEvents:UIControlEventValueChanged];
    
    collView.refreshControl = refreshControl;
    [self initData];
    [self loadData];
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
    type = @"video";
}
-(void)layoutControl{
    [self changeColor];
}
-(void)changeColor{
    if([type isEqualToString:@"video"]){
        lineVideo.backgroundColor = mainGoldColor;
        lineSentence.backgroundColor = [UIColor clearColor];
        [btnVideo setTitleColor:mainGoldColor forState:UIControlStateNormal];
        [btnSentence setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    }else{
        lineSentence.backgroundColor = mainGoldColor;
        lineVideo.backgroundColor = [UIColor clearColor];
        [btnSentence setTitleColor:mainGoldColor forState:UIControlStateNormal];
        [btnVideo setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    }
}

#pragma mark GetData
- (void)loadData {
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

#pragma mark - CollectionDelegate
-(UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(nonnull NSIndexPath *)indexPath{
    
    CollectionPageCell * cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"collectionCell" forIndexPath:indexPath];
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
}

-(IBAction)ClickVideo:(id)sender{
    type = @"video";
    [self changeColor];
}
-(IBAction)ClickSentence:(id)sender{
    type = @"sentence";
    [self changeColor];
}
-(IBAction)ClickBack:(id)sender{
    [[GolfMainViewController sharedInstance] hideTab: NO];
    [self.navigationController popViewControllerAnimated:YES];
}
@end

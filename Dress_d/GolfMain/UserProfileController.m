//
//  UserProfileController.m
//  Golf
//
//  Created by MacAdmin on 3/31/18.
//  Copyright © 2018 MacAdmin. All rights reserved.
//

#import "UserProfileController.h"
#import "PhotoCell.h"
#import "ImageThreeFlowLayout.h"
#import "CollectionPageCell.h"
#import "GolfHomeRecommFlowLayout.h"
#import "FanCell.h"
#import "LoadingCell.h"

@interface UserProfileController ()
<
UITableViewDelegate ,
UITableViewDataSource,
UICollectionViewDelegate,
UICollectionViewDataSource
>

@end

@implementation UserProfileController
{
    NSString * select;
    Boolean _waiting;
    UIRefreshControl * refreshControl1;
    UIRefreshControl * refreshControl2;
    UIRefreshControl * refreshControl3;
    
    NSMutableArray * _mDataCollection1;
    NSMutableArray * _mDataCollection2;
    NSMutableArray * _mDataCollection3;
    
    NSInteger _pageNoPhoto;
    NSInteger _pageNoVideo;
    NSInteger _pageNoFan;
}


- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    [self initData];
    [self layoutControl];
    [self loadData:select];
    [self ChangeSelect];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
-(void)initData{
    select = @"photo"; // @"photo" @"video" @"fan"
    _pageNoPhoto = 0 ;
    _pageNoVideo = 0 ;
    _pageNoFan = 0;
    
    UINib *nib1 = [UINib nibWithNibName:@"PhotoCell" bundle: nil];
    [collView1 registerNib:nib1 forCellWithReuseIdentifier:@"PhotoCell"];
    
    collView1.collectionViewLayout = [[ImageThreeFlowLayout alloc]init];
    refreshControl1 = [[UIRefreshControl alloc] init];
    refreshControl1.tag = 1;
    refreshControl1.backgroundColor = mainProfileBackColor;
    refreshControl1.tintColor = [UIColor whiteColor];
    [refreshControl1 addTarget:self action:@selector(refreshData:) forControlEvents:UIControlEventValueChanged];
    collView1.refreshControl = refreshControl1;
    
    
    UINib *nib2 = [UINib nibWithNibName:@"CollectionPageCell" bundle: nil];
    [collView2 registerNib:nib2 forCellWithReuseIdentifier:@"collectionCell"];
    
    collView2.collectionViewLayout = [[GolfHomeRecommFlowLayout alloc]init];
    refreshControl2 = [[UIRefreshControl alloc] init];
    refreshControl2.tag = 2;
    refreshControl2.backgroundColor = mainProfileBackColor;
    refreshControl2.tintColor = [UIColor whiteColor];
    [refreshControl2 addTarget:self action:@selector(refreshData:) forControlEvents:UIControlEventValueChanged];
    collView2.refreshControl = refreshControl2;
    
    
    refreshControl3 = [[UIRefreshControl alloc] init];
    refreshControl3.tag = 3;
    refreshControl3.backgroundColor = mainProfileBackColor;
    refreshControl3.tintColor = [UIColor whiteColor];
    [refreshControl3 addTarget:self action:@selector(refreshData:) forControlEvents:UIControlEventValueChanged];
    
    _tbView.refreshControl = refreshControl3;
    
}
-(void)viewDidLayoutSubviews{
    [self layoutLivingStream];
}
-(void)layoutLivingStream{
    CAShapeLayer * maskLayer = [CAShapeLayer layer];
    maskLayer.path = [UIBezierPath bezierPathWithRoundedRect: vwLiveStream.bounds byRoundingCorners: UIRectCornerTopLeft | UIRectCornerBottomLeft cornerRadii: (CGSize){vwLiveStream.frame.size.height/2, vwLiveStream.frame.size.height/2}].CGPath;
    
    vwLiveStream.layer.mask = maskLayer;
}

-(void)layoutControl{
    imgPhoto.layer.cornerRadius = imgPhoto.frame.size.height/2;
    imgPhoto.layer.masksToBounds = YES;
    
    btn1.layer.cornerRadius = 3;
    btn1.layer.masksToBounds = YES;
    btn2.layer.cornerRadius = 3;
    btn2.layer.masksToBounds = YES;
    btn3.layer.cornerRadius = 3;
    btn3.layer.masksToBounds = YES;
    
    vwMsg.layer.cornerRadius = vwMsg.frame.size.height/2;
    vwMsg.layer.masksToBounds = YES;
    
    vwFocus.layer.cornerRadius = vwFocus.frame.size.height/2;
    vwFocus.layer.masksToBounds=YES;
    
    scrollview.contentSize = CGSizeMake([UIScreen mainScreen].bounds.size.width * 3, scrollview.frame.size.height);
    CGFloat offsetY = 5;
    CGRect frame1 = collView1.frame;
    frame1.origin.x = 0;
    frame1.origin.y = offsetY;
    frame1.size.width = [UIScreen mainScreen].bounds.size.width;
    frame1.size.height = scrollview.frame.size.height;
    collView1.frame = frame1;
    
    CGRect frame2 = collView2.frame;
    frame2.origin.x = [UIScreen mainScreen].bounds.size.width + 10;
    frame2.origin.y = offsetY;
    frame2.size.width = [UIScreen mainScreen].bounds.size.width - 20;
    frame2.size.height = scrollview.frame.size.height;
    collView2.frame = frame2;
    
    CGRect frame3 = _tbView.frame;
    frame3.origin.x = [UIScreen mainScreen].bounds.size.width * 2;
    frame3.origin.y = offsetY;
    frame3.size.width = [UIScreen mainScreen].bounds.size.width;
    frame3.size.height = scrollview.frame.size.height;
    _tbView.frame = frame3;
}

-(void)ChangeSelect{
    if([select isEqualToString:@"photo"]){
        
        lbPhoto.textColor = mainGoldColor;
        lbPhotoNum.textColor = mainGoldColor;
        lbLinePhoto.backgroundColor=mainGoldColor;
        
        lbVideo.textColor = [UIColor whiteColor];
        lbVideoNum.textColor=[UIColor whiteColor];
        lbLineVideo.backgroundColor=[UIColor clearColor];

        lbFan.textColor = [UIColor whiteColor];
        lbFanNum.textColor=[UIColor whiteColor];
        lbLineFan.backgroundColor=[UIColor clearColor];
        
    }else
    if([select isEqualToString:@"video"]){
        lbPhoto.textColor = [UIColor whiteColor];
        lbPhotoNum.textColor = [UIColor whiteColor];
        lbLinePhoto.backgroundColor=[UIColor clearColor];
        
        lbVideo.textColor = mainGoldColor;
        lbVideoNum.textColor=mainGoldColor;
        lbLineVideo.backgroundColor=mainGoldColor;
        
        lbFan.textColor = [UIColor whiteColor];
        lbFanNum.textColor=[UIColor whiteColor];
        lbLineFan.backgroundColor=[UIColor clearColor];
    }else{
        lbPhoto.textColor = [UIColor whiteColor];
        lbPhotoNum.textColor = [UIColor whiteColor];
        lbLinePhoto.backgroundColor=[UIColor clearColor];
        
        lbVideo.textColor = [UIColor whiteColor];
        lbVideoNum.textColor=[UIColor whiteColor];
        lbLineVideo.backgroundColor=[UIColor clearColor];
        
        lbFan.textColor = mainGoldColor;
        lbFanNum.textColor=mainGoldColor;
        lbLineFan.backgroundColor=mainGoldColor;
    }
}



- (void)loadData:(NSString *) tag {
    if([tag isEqualToString:@"photo"]){
        _mDataCollection1 = [[NSMutableArray alloc]init];
        for (int i = 0; i < 17; ++i) {
            NSMutableDictionary * item = [[NSMutableDictionary alloc]init];
            int remain = i%2;
            if (remain == 0) {
                [item setObject:@"golf_1.png" forKey:@"image"];
            }else{
                [item setObject:@"golf_2.png" forKey:@"image"];
            }
            [_mDataCollection1 addObject:item];
        }
        
        [collView1 reloadData];
    }else if([tag isEqualToString:@"video"]){
        _mDataCollection2 = [[NSMutableArray alloc]init];
        for (int i = 0; i < 17; ++i) {
            NSMutableDictionary * item = [[NSMutableDictionary alloc]init];
            int remain = i%2;
            if (remain == 0) {
                [item setObject:@"golf_1.png" forKey:@"image"];
            }else{
                [item setObject:@"golf_2.png" forKey:@"image"];
            }
            [_mDataCollection2 addObject:item];
        }
        
        [collView2 reloadData];

    }else{
        _mDataCollection3 = [[NSMutableArray alloc]init];
        for (int i = 0; i < 17; ++i) {
            NSMutableDictionary * item = [[NSMutableDictionary alloc]init];
            int remain = i%2;
            if (remain == 0) {
                [item setObject:@"golf_1.png" forKey:@"image"];
            }else{
                [item setObject:@"golf_2.png" forKey:@"image"];
            }
            [_mDataCollection3 addObject:item];
        }
        
        [_tbView reloadData];
    }
}

-(void)refreshData:(UIRefreshControl *) refresher{
    NSInteger tag = refresher.tag;
    if(tag == 1){
        _pageNoPhoto = 0;
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
            [refreshControl1 endRefreshing];
            _mDataCollection1 = [[NSMutableArray alloc]init];
            for (int i = 0; i < 7; ++i) {
                NSMutableDictionary * item = [[NSMutableDictionary alloc]init];
                int remain = i%2;
                if (remain == 0) {
                    [item setObject:@"golf_1.png" forKey:@"image"];
                }else{
                    [item setObject:@"golf_2.png" forKey:@"image"];
                }
                [_mDataCollection1 addObject:item];
            }
            
            [collView1 reloadData];
        });
    }else if(tag == 2){
        _pageNoVideo = 0;
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
            [refreshControl2 endRefreshing];
            _mDataCollection2 = [[NSMutableArray alloc]init];
            for (int i = 0; i < 7; ++i) {
                NSMutableDictionary * item = [[NSMutableDictionary alloc]init];
                int remain = i%2;
                if (remain == 0) {
                    [item setObject:@"golf_1.png" forKey:@"image"];
                }else{
                    [item setObject:@"golf_2.png" forKey:@"image"];
                }
                [_mDataCollection2 addObject:item];
            }
            
            [collView2 reloadData];
        });
    }else{
        _pageNoFan = 0;
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
            [refreshControl3 endRefreshing];
            _mDataCollection3 = [[NSMutableArray alloc]init];
            for (int i = 0; i < 7; ++i) {
                NSMutableDictionary * item = [[NSMutableDictionary alloc]init];
                int remain = i%2;
                if (remain == 0) {
                    [item setObject:@"golf_1.png" forKey:@"image"];
                }else{
                    [item setObject:@"golf_2.png" forKey:@"image"];
                }
                [_mDataCollection3 addObject:item];
            }
            
            [_tbView reloadData];
        });
    }
    
}

#pragma mark - CollectionDelegate
-(UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(nonnull NSIndexPath *)indexPath{
    NSInteger tag = collectionView.tag;
    if(tag == 1){
        PhotoCell * cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"PhotoCell" forIndexPath:indexPath];
        NSString * url = [[_mDataCollection1 objectAtIndex:indexPath.row] objectForKey:@"image"];
        UIImage * image = [UIImage imageNamed:url];
        cell.imgPhoto.image = image;
        return cell;
    }else{
        CollectionPageCell * cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"collectionCell" forIndexPath:indexPath];
        cell.imageview.layer.cornerRadius = 5;
        cell.imageview.layer.masksToBounds = YES;
        NSString * url = [[_mDataCollection2 objectAtIndex:indexPath.row] objectForKey:@"image"];
        UIImage * image = [UIImage imageNamed:url];
        cell.imageview.image = image;
        return cell;
    }
}
-(NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section{
    NSInteger tag = collectionView.tag;
    if(tag == 1){
        return [_mDataCollection1 count];
    }else{
        return [_mDataCollection2 count];
    }
}

// for load more.
-(void)collectionView:(UICollectionView *)collectionView didEndDisplayingCell:(nonnull UICollectionViewCell *)cell forItemAtIndexPath:(nonnull NSIndexPath *)indexPath{
    NSInteger tag = collectionView.tag;
    if(tag == 1){
        
        if (indexPath.row == [_mDataCollection1 count] - 1 && !_waiting){
            _waiting = YES;
            [self performSelector:@selector(loadMoreData:) withObject:@"photo" afterDelay:0.1];
        }
    }else{
        if (indexPath.row == [_mDataCollection2 count] - 1 && !_waiting){
            _waiting = YES;
            [self performSelector:@selector(loadMoreData:) withObject:@"video" afterDelay:0.1];
        }
    }
}

-(void)loadMoreData:(NSString *) tag{
    if([tag isEqualToString:@"photo"]){
        NSMutableDictionary * item1 = [[NSMutableDictionary alloc]init];
        NSMutableDictionary * item2 = [[NSMutableDictionary alloc]init];
        [item1 setObject:@"golf_1.png" forKey:@"image"];
        [item2 setObject:@"golf_2.png" forKey:@"image"];
        [_mDataCollection1 addObject:item1];
        [_mDataCollection1 addObject:item2];
        [_mDataCollection1 addObject:item1];
        [_mDataCollection1 addObject:item2];
        [_mDataCollection1 addObject:item1];
        [_mDataCollection1 addObject:item2];
        [_mDataCollection1 addObject:item1];
        [_mDataCollection1 addObject:item2];
        [_mDataCollection1 addObject:item1];
        [_mDataCollection1 addObject:item2];
        [self performSelector:@selector(reloadCollView:) withObject:tag afterDelay:2.0];
        _waiting = NO;
    }else if([tag isEqualToString:@"video"]){
        NSMutableDictionary * item1 = [[NSMutableDictionary alloc]init];
        NSMutableDictionary * item2 = [[NSMutableDictionary alloc]init];
        [item1 setObject:@"golf_1.png" forKey:@"image"];
        [item2 setObject:@"golf_2.png" forKey:@"image"];
        [_mDataCollection2 addObject:item1];
        [_mDataCollection2 addObject:item2];
        [_mDataCollection2 addObject:item1];
        [_mDataCollection2 addObject:item2];
        [_mDataCollection2 addObject:item1];
        [_mDataCollection2 addObject:item2];
        [_mDataCollection2 addObject:item1];
        [_mDataCollection2 addObject:item2];
        [_mDataCollection2 addObject:item1];
        [_mDataCollection2 addObject:item2];
        [self performSelector:@selector(reloadCollView:) withObject:tag afterDelay:2.0];
        _waiting = NO;
    }else{
        if(_waiting){
            return;
        }
        _pageNoFan++;
        
        NSMutableDictionary * lastItem = [_mDataCollection3 lastObject];
        NSString * loading = [lastItem objectForKey:@"loading"];
        if(![loading isEqualToString:@"true"]){
            NSMutableDictionary * loadItem = [[NSMutableDictionary alloc]init];
            [loadItem setObject:@"true" forKey:@"loading"];
            [_mDataCollection3 addObject:loadItem];
            
            [_tbView reloadData];
            
            /////////////////// get more data ///////////////////////
            [self performSelector:@selector(getLoadMore) withObject:nil afterDelay:0.4];
            
        }
        
    }
}

-(void)reloadCollView:(NSString *) tag{
    if([tag isEqualToString:@"photo"]){
        [collView1 reloadData];
    }else{
        [collView2 reloadData];
    }
}
- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath{
    NSInteger tag = collectionView.tag;
    if(tag == 1){
        
    }else{
        
    }
    NSLog(@"DidSelect index %ld", (long)indexPath.row);
}

#pragma mark TableView Delegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    NSInteger index = indexPath.row;

}


- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    // Return the number of sections.
    if (_mDataCollection3) {
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
    return [_mDataCollection3 count];
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    float h = 80;
    return h ;
    
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSMutableDictionary * row = [_mDataCollection3 objectAtIndex:indexPath.row];
    FanCell *cell = [[NSBundle mainBundle] loadNibNamed:@"FanCell" owner:self options:nil][0];
    cell.imgPhoto.image = [UIImage imageNamed:@"golf_1.png"];
    cell.imgPhoto.layer.cornerRadius = cell.imgPhoto.frame.size.height/2;
    cell.imgPhoto.layer.masksToBounds = YES;
    cell.lbName.text = @"主播名称";
    
    // this is where you set your color view
    UIView *customColorView = [[UIView alloc] init];
    customColorView.backgroundColor = [UIColor colorWithRed:180/255.0
                                                      green:138/255.0
                                                       blue:171/255.0
                                                      alpha:0.5];
    cell.selectedBackgroundView =  customColorView;
    BOOL lastItemReached = [row isEqual:[_mDataCollection3 lastObject]];
    if (lastItemReached && indexPath.row == [_mDataCollection3 count] - 1)
    {
        NSString * loading = [row objectForKey:@"loading"];
        if([loading isEqualToString:@"true"]){
            LoadingCell * cellloading =[[NSBundle mainBundle] loadNibNamed:@"LoadingCell" owner:self options:nil][0];
            return cellloading;
        }else{
            [self performSelector:@selector(loadMoreData:) withObject:@"fan" afterDelay:0.01];
            return cell;
            
        }
    }
    return cell;
    
}

-(void)moveToBottom{
    NSIndexPath * indexpath =[NSIndexPath indexPathForRow:[_mDataCollection3 count]-1 inSection:0];
    [_tbView scrollToRowAtIndexPath:indexpath atScrollPosition:UITableViewScrollPositionBottom animated:YES];
    
}


#pragma mark Load Data

-(void)getLoadMore{
    NSMutableDictionary * item = [[NSMutableDictionary alloc]initWithCapacity:0];
    // call loadmore api
    _waiting = YES;

    [self performSelector:@selector(moveToBottom) withObject:nil afterDelay:0];
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(2 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        [_mDataCollection3 removeLastObject];
        _waiting = NO;
        [item setObject:@"one" forKey:@"one"];
        [_mDataCollection3 addObject:item];
        [_mDataCollection3 addObject:item];
        [_mDataCollection3 addObject:item];
        [_mDataCollection3 addObject:item];
        [_mDataCollection3 addObject:item];
        [_mDataCollection3 addObject:item];
        [_mDataCollection3 addObject:item];
        [_mDataCollection3 addObject:item];
        [_mDataCollection3 addObject:item];
        
        [_tbView reloadData];
    });
}

-(IBAction)ClickMsg:(id)sender{
    
}

-(IBAction)ClickFocus:(id)sender{
    
}
-(IBAction)ClickPhoto:(UIButton *)sender{
    CGFloat offset = 0.0;
    NSInteger tag = sender.tag;
    if(tag == 1){
        select = @"photo";
        offset = 0.0;
    }else if(tag == 2){
        select = @"video";
        offset = [UIScreen mainScreen].bounds.size.width;
    }else{
        select= @"fan";
        offset = [UIScreen mainScreen].bounds.size.width * 2;
    }
    
    scrollview.contentOffset = CGPointMake(offset, 0);
    [self ChangeSelect];
}
-(IBAction)ClickBack:(id)sender{
    [self.navigationController popViewControllerAnimated:YES];
}
@end

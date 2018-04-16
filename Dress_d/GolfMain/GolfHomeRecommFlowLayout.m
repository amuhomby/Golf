//
//  GolfHomeRecommFlowLayout.m
//  Golf
//
//  Created by MacAdmin on 3/27/18.
//  Copyright © 2018 MacAdmin. All rights reserved.
//

#import "GolfHomeRecommFlowLayout.h"

@implementation GolfHomeRecommFlowLayout
-(instancetype)init{
    self = [super init];
    if(self){
        self.minimumLineSpacing = 5.0;
        self.minimumInteritemSpacing = 10.0;
        self.scrollDirection = UICollectionViewScrollDirectionVertical;
    }
    return self;
}
-(CGSize)itemSize{
    NSInteger numberOfColums = 2;
    CGFloat itemWidth = (CGRectGetWidth(self.collectionView.frame) - 10)/numberOfColums;
    return  CGSizeMake(itemWidth, itemWidth * 0.8);
}
@end

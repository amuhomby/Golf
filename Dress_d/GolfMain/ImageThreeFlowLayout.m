//
//  ImageThreeFlowLayout.m
//  Golf
//
//  Created by MacAdmin on 3/31/18.
//  Copyright © 2018 MacAdmin. All rights reserved.
//

#import "ImageThreeFlowLayout.h"

@implementation ImageThreeFlowLayout
-(instancetype)init{
    self = [super init];
    if(self){
        self.minimumLineSpacing = 5.0;
        self.minimumInteritemSpacing = 5.0;
        self.scrollDirection = UICollectionViewScrollDirectionVertical;
    }
    return self;
}
-(CGSize)itemSize{
    NSInteger numberOfColums = 3;
    CGFloat itemWidth = (CGRectGetWidth(self.collectionView.frame) - 10)/numberOfColums;
    return  CGSizeMake(itemWidth, itemWidth);
}

@end

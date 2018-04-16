//
//  ShowFlowLayout.m
//  Golf
//
//  Created by MacAdmin on 4/1/18.
//  Copyright © 2018 MacAdmin. All rights reserved.
//

#import "ShowFlowLayout.h"

@implementation ShowFlowLayout
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
    return  CGSizeMake(itemWidth, itemWidth);
}@end

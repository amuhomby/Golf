//
//  GolfHomeCollectionViewCell.m
//  Golf
//
//  Created by MacAdmin on 3/26/18.
//  Copyright © 2018 MacAdmin. All rights reserved.
//

#import "GolfHomeCollectionViewCell.h"

@interface GolfHomeCollectionViewCell ()
@property (nonatomic, weak) UIImageView *img;
@end

@implementation GolfHomeCollectionViewCell

- (instancetype)initWithFrame:(CGRect)frame {
    if (self = [super initWithFrame:frame]) {
        self.backgroundColor = [UIColor clearColor];
        [self addImage];
    }
    return self;
}

- (instancetype)initWithCoder:(NSCoder *)aDecoder {
    if (self = [super initWithCoder:aDecoder]) {
        self.backgroundColor = [UIColor clearColor];
        [self addImage];
    }
    return self;
}



-(void)addImage{
    UIImageView * imageView = [[UIImageView alloc]init];
    imageView.contentMode = UIViewContentModeScaleAspectFill;
    [self addSubview:imageView];
    _img = imageView;
}
- (void)layoutSubviews {
    [super layoutSubviews];
    _img.frame = self.bounds;
}

@end

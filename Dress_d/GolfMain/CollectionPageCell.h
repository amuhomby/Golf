//
//  CollectionPageCell.h
//  Golf
//
//  Created by MacAdmin on 3/31/18.
//  Copyright © 2018 MacAdmin. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface CollectionPageCell : UICollectionViewCell
@property (nonatomic, weak) IBOutlet UIImageView * imageview;
@property (nonatomic, weak) IBOutlet UILabel * lbhost;
@property (nonatomic, weak) IBOutlet UILabel * lbtitle;
@property (nonatomic, weak) IBOutlet UILabel * lbNum;
@end

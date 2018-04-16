//
//  StylePostViewController.h
//  Dress_d
//
//  Created by MacAdmin on 9/20/17.
//  Copyright © 2017 dev. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ProgressViewController.h"

@interface StylePostViewController : ProgressViewController
{
    IBOutlet UIButton * btnBack;
    IBOutlet UIButton * btnSrh;
    IBOutlet UIButton * btnStyle;
    IBOutlet UIScrollView * scrollview;
    IBOutlet UIView * viewMain;
    
    NSMutableArray * arrPost;
    NSMutableArray * arrSave;
    NSMutableArray * arrAll;
}

@property (nonatomic, retain) NSString * friend_id;
@property (nonatomic, retain) NSString * style_id;
@property (nonatomic, retain) NSString * titleStyle;


@end

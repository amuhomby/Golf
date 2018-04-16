//
//  VideoPlayController.h
//  Golf
//
//  Created by MacAdmin on 3/31/18.
//  Copyright © 2018 MacAdmin. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "VKVideoPlayer.h"
@interface VideoPlayController : ProgressViewController <VKVideoPlayerDelegate>
{
    IBOutlet UIView * vwTop;
    IBOutlet UIButton * btnBack;
    IBOutlet UIView * vwBack;
    IBOutlet UIButton * btn1;
    IBOutlet UIButton * btn2;

}
@property (nonatomic, strong) VKVideoPlayer* player;

@end

//
//  CameraViewController.h
//  Dress_d
//
//  Created by MacAdmin on 16/09/2017.
//  Copyright © 2017 dev. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "CameraSessionView.h"

@protocol CameraViewDelegate <NSObject>

@optional - (void)didCaptureImage:(UIImage *)image;
@optional - (void)didCaptureImageWithData:(NSData *)imageData;
@optional -(void)getImage:(UIImage *)image;
@end

@interface CameraViewController : UIViewController <CACameraSessionDelegate>
{
    IBOutlet UIView * cameraMainView;
    IBOutlet UILabel * lbLoading;
    
}
@property (nonatomic, strong) CameraSessionView *cameraView;
//Delegate Property
@property (nonatomic, weak) id <CameraViewDelegate> delegate;
@property (nonatomic, retain) NSString * imageNo;
@end

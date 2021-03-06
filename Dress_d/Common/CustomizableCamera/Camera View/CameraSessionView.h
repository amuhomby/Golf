//
//  CACameraSessionDelegate.h
//
//  Created by Christopher Cohen & Gabriel Alvarado on 1/23/15.
//  Copyright (c) 2015 Gabriel Alvarado. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <AudioUnit/AudioUnit.h>

///Protocol Definition
@protocol CACameraSessionDelegate <NSObject>

@optional - (void)didCaptureImage:(UIImage *)image;
@optional - (void)didCaptureImageWithData:(NSData *)imageData;

@end

@interface CameraSessionView : UIView

//Delegate Property
@property (nonatomic, weak) id <CACameraSessionDelegate> delegate;
@property (nonatomic, retain) UIButton * btnGallery;

//API Functions
- (void)setTopBarColor:(UIColor *)topBarColor;
- (void)hideFlashButton;
- (void)hideCameraToggleButton;
- (void)hideDismissButton;
- (void)addGalleryBtn:(UIButton *)btn;
- (void)onTapShutterButton;
@end

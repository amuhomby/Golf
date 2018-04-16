//
//  CameraViewController.m
//  Dress_d
//
//  Created by MacAdmin on 16/09/2017.
//  Copyright © 2017 dev. All rights reserved.
//

#import "CameraViewController.h"
#import "TOCropViewController.h"
#import "GolfMainViewController.h"
#import <MediaPlayer/MediaPlayer.h>

#define STR_LOAD @"STR_LOAD"
#define STR_PICKER @"STR_PICKER"
#define STR_PICKER_CANCEL @"STR_PICKER_CANCEL"
#define STR_CROP @"STR_CROP"
#define STR_CROP_CANCEL @"STR_CROP_CANCEL"

@interface CameraViewController ()<TOCropViewControllerDelegate,UINavigationControllerDelegate,UIImagePickerControllerDelegate,TOCropViewControllerDelegate>
{
    UIImagePickerController  *_imagePickerController;
    float volumLevel;
    NSString * strState;
}
@end

@implementation CameraViewController

- (void)viewDidLoad {
    UIView * statusBar = [[[UIApplication sharedApplication] valueForKey:@"statusBarWindow"] valueForKey:@"statusBar"];
    if([statusBar respondsToSelector:@selector(setBackgroundColor:)]){
        statusBar.backgroundColor = [UIColor clearColor];
    }

    strState = STR_LOAD;
    // Do any additional setup after loading the view from its nib.
    //Set white status bar
    _imagePickerController = [[UIImagePickerController alloc] init];
    _imagePickerController.delegate = self;
    _imagePickerController.allowsEditing = NO;
    
    [self setNeedsStatusBarAppearanceUpdate];
    
    CGRect vrect = CGRectMake(-5000, -5000,0, 0);
    MPVolumeView *volumeView = [[MPVolumeView alloc] initWithFrame: vrect];
    [self.view addSubview: volumeView];
 }
-(void)viewWillAppear:(BOOL)animated{
    [self RemoveAllSubViews:cameraMainView];
    [[GolfMainViewController sharedInstance] hideTab:YES];

    UIView * statusBar = [[[UIApplication sharedApplication] valueForKey:@"statusBarWindow"] valueForKey:@"statusBar"];
    if([statusBar respondsToSelector:@selector(setBackgroundColor:)]){
        statusBar.backgroundColor = [UIColor clearColor];
    }

    if([strState isEqualToString:STR_LOAD])
        [cameraMainView addSubview:lbLoading];
    
    if(![strState isEqualToString:STR_CROP]){
        [self performSelector:@selector(loadCamera) withObject:nil afterDelay:0.1];//1.5
    }
    [self performSelector:@selector(controlVol) withObject:nil afterDelay:0.05]; // 0.3

}
-(void)controlVol{
    
    AVAudioSession* audioSession = [AVAudioSession sharedInstance];
    [audioSession setActive:YES error:nil];
    [audioSession addObserver:self
                   forKeyPath:@"outputVolume"
                      options:0
                      context:nil];
    volumLevel = [[MPMusicPlayerController applicationMusicPlayer] volume];

}
-(void) observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary *)change context:(void *)context {
    
    if ([keyPath isEqual:@"outputVolume"]) {
        float volumeLevel = [[MPMusicPlayerController applicationMusicPlayer] volume];
        if(volumeLevel > 0.9){
            volumLevel = 0.9;
            [[MPMusicPlayerController applicationMusicPlayer] setVolume:volumLevel];
        }
        if(volumeLevel < 0.1)
        {
            volumLevel = 0.1;
            [[MPMusicPlayerController applicationMusicPlayer] setVolume:volumLevel];
        }
        [_cameraView onTapShutterButton];

        NSLog(@"volume changed! %f",volumeLevel);
    }
}
-(void)viewWillDisappear:(BOOL)animated{
    AVAudioSession* audioSession = [AVAudioSession sharedInstance];
    [audioSession removeObserver:self forKeyPath:@"outputVolume"];

}
- (void)loadCamera
{
    cameraMainView.hidden = NO;

    //Instantiate the camera view & assign its frame
    _cameraView = [[CameraSessionView alloc] initWithFrame:self.view.frame];
    
    //Set the camera view's delegate and add it as a subview
    _cameraView.delegate = self;
    
    //Apply animation effect to present the camera view
    CATransition *applicationLoadViewIn =[CATransition animation];
    [applicationLoadViewIn setDuration:0.05];
    [applicationLoadViewIn setType:kCATransitionReveal];
    [applicationLoadViewIn setTimingFunction:[CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseIn]];
    [[_cameraView layer]addAnimation:applicationLoadViewIn forKey:kCATransitionReveal];
    
    CGFloat x,y,width,height;
    CGFloat sWidth = [UIScreen mainScreen].bounds.size.width;
    CGFloat sHeight= [UIScreen mainScreen].bounds.size.height;
    
    x = sWidth* 0.1;
    y = sHeight*0.9;
    width = sWidth*0.075;
    height = sWidth*0.075;
    CGRect frame = CGRectMake(0, 0, width, height);

    UIButton * btnGallery = [[UIButton alloc]initWithFrame:frame];
    [btnGallery setBackgroundImage:[UIImage imageNamed:@"plus_g.png"] forState:UIControlStateNormal];
    [btnGallery addTarget:self action:@selector(onClickGal:) forControlEvents:UIControlEventTouchUpInside];
    btnGallery.center = CGPointMake(sWidth*0.5*1.4, sHeight*0.07 + 22);
    _cameraView.btnGallery = btnGallery;
    [cameraMainView addSubview:_cameraView];
    
    CGFloat w1= sWidth *0.045;
    CGFloat h1= sWidth * 0.07;
    CGRect frame2 = CGRectMake(0, 0, w1, h1);
    UIButton * btnBack = [[UIButton alloc]initWithFrame:frame2];
    [btnBack setBackgroundImage:[UIImage imageNamed:@"back_w.png"] forState:UIControlStateNormal];
    [btnBack addTarget:self action:@selector(dismiss) forControlEvents:UIControlEventTouchUpInside];
    btnBack.center = CGPointMake(sWidth*0.14, sHeight*0.5);
    [cameraMainView addSubview:btnBack];
    
    //____________________________Example Customization____________________________
    //[_cameraView setTopBarColor:[UIColor colorWithRed:0.97 green:0.97 blue:0.97 alpha: 0.64]];
    //[_cameraView hideFlashButton]; //On iPad flash is not present, hence it wont appear.
    //[_cameraView hideCameraToggleButton];
    //[_cameraView hideDismissButton];
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void)dismiss{
    if([_imageNo isEqualToString:@"0"]){
        [[GolfMainViewController sharedInstance] hideTab:NO];
        NSString * tabNo = [Global sharedGlobal].tabIndex;
        int tabIndex = [tabNo intValue];
        if(tabIndex == 2){
            tabIndex = 0;
        }
        [[GolfMainViewController sharedInstance] changTab:tabIndex];
    }else{
        [Global sharedGlobal].bakeToAdd = @"yes";
        [[Global sharedGlobal] SaveParam];
    }
    [self dismissViewControllerAnimated:NO completion:nil];
}

-(void)didCaptureImage:(UIImage *)image {
    NSLog(@"CAPTURED IMAGE");
    cameraMainView.hidden = YES;

    [self.delegate didCaptureImage:image];
    [self cropImageCtr:image];
}

-(void)didCaptureImageWithData:(NSData *)imageData {
    NSLog(@"CAPTURED IMAGE DATA");
    
    [self.delegate didCaptureImageWithData:imageData];
}

- (void)image:(UIImage *)image didFinishSavingWithError:(NSError *)error contextInfo:(void *)contextInfo
{
    //Show error alert if image could not be saved
    if (error){
        UIAlertController * alert = [UIAlertController
                                     alertControllerWithTitle:@"Error!"
                                     message:@"Image couldn't be saved"
                                     preferredStyle:UIAlertControllerStyleAlert];
        
        UIAlertAction* noButton = [UIAlertAction
                                   actionWithTitle:@"Ok"
                                   style:UIAlertActionStyleDefault
                                   handler:^(UIAlertAction * action) {
                                       //Handle ok button
                                       
                                   }];
       
        [alert addAction:noButton];
        [self presentViewController:alert animated:YES completion:nil];

    }
 }

- (BOOL)prefersStatusBarHidden {
    return YES;
}

-(void)onClickGal:(UIButton *)sender{
    strState = STR_PICKER;

    cameraMainView.hidden = YES;

    _imagePickerController.sourceType = UIImagePickerControllerSourceTypePhotoLibrary;
    _imagePickerController.allowsEditing = NO;
    
    [self presentViewController:_imagePickerController animated:YES completion:nil];
}

- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary *)info{
    cameraMainView.hidden = YES;

    [self dismissViewControllerAnimated:YES completion:nil];
    
    UIImage * img = [info valueForKey:UIImagePickerControllerOriginalImage];
//    [self performSelector:@selector(didCaptureImage:) withObject:img afterDelay:1.0];
    [self cropImageCtr:img];
//    myImageView.image = img;
    
}


- (void)imagePickerControllerDidCancel:(UIImagePickerController *)picker
{
    strState = STR_PICKER_CANCEL;

    [picker dismissViewControllerAnimated:NO completion:nil];
}



-(void)cropImageCtr:(UIImage *)image{
    strState = STR_CROP;

    cameraMainView.hidden = YES;

    TOCropViewCroppingStyle croppingStyle = TOCropViewCroppingStyleDefault;
    TOCropViewController * cropController = [[TOCropViewController alloc] initWithCroppingStyle:croppingStyle image:image];
    cropController.delegate = self;
    
    // -- Uncomment these if you want to test out restoring to a previous crop setting --
    //cropController.angle = 90; // The initial angle in which the image will be rotated
    //cropController.imageCropFrame = CGRectMake(0,0,2848,4288); //The
    
    // -- Uncomment the following lines of code to test out the aspect ratio features --
    CGFloat width = 1.0f;
    CGFloat height = width * PHOTO_RATIO;
    cropController.customAspectRatio = CGSizeMake(width, height);
    cropController.aspectRatioPreset = TOCropViewControllerAspectRatioPresetCustom;
//    cropController.aspectRatioPreset = TOCropViewControllerAspectRatioPresetSquare;
    //Set the initial aspect ratio as a square
    cropController.aspectRatioLockEnabled = YES; // The crop box is locked to the aspect ratio and can't be resized away from it
    //cropController.resetAspectRatioEnabled = NO; // When tapping 'reset', the aspect ratio will NOT be reset back to default
    
    // -- Uncomment this line of code to place the toolbar at the top of the view controller --
    // cropController.toolbarPosition = TOCropViewControllerToolbarPositionTop;
    
    
    //If profile picture, push onto the same navigation stack
    
    if (croppingStyle == TOCropViewCroppingStyleCircular) {
        //        [picker pushViewController:cropController animated:YES];
    }
    else { //otherwise dismiss, and then present from the main controller
        
        [self presentViewController:cropController animated:YES completion:nil];
    }
    
}
#pragma mark - Cropper Delegate -
- (void)cropViewController:(TOCropViewController *)cropViewController didCropToImage:(UIImage *)image withRect:(CGRect)cropRect angle:(NSInteger)angle
{
    cameraMainView.hidden = YES;
    [self getImage:image];
}

- (void)cropViewController:(TOCropViewController *)cropViewController didCropToCircularImage:(UIImage *)image withRect:(CGRect)cropRect angle:(NSInteger)angle
{
    //    self.croppedFrame = cropRect;
    //    self.angle = angle;
}

- (void)cropViewController:(nonnull TOCropViewController *)cropViewController didFinishCancelled:(BOOL)cancelled NS_SWIFT_NAME(cropViewController(_:didFinishCancelled:))
{
    strState = STR_CROP_CANCEL;
    [self dismissViewControllerAnimated:YES completion:nil];
}
-(void)getImage:(UIImage *)image{
    cameraMainView.hidden = YES;
    [self.delegate getImage:image];
    [self RemoveAllSubViews:cameraMainView];
    [self dismissViewControllerAnimated:YES completion:nil];
}
-(void)RemoveAllSubViews:(UIView *)sender{
    NSArray *viewsToRemove = [sender subviews];
    for (UIView *v in viewsToRemove) {
        [v removeFromSuperview];
    }
}

@end

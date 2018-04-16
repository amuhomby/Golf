//
//  PhotoViewController.m
//  Dress_d
//
//  Created by MacAdmin on 11/27/17.
//  Copyright © 2017 MacAdmin. All rights reserved.
//

#import "PhotoViewController.h"
#import "TOCropViewController.h"
#import "FTermsViewController.h"

@interface PhotoViewController ()<UIImagePickerControllerDelegate, UINavigationControllerDelegate, TOCropViewControllerDelegate>
{
    UIImagePickerController     *_imagePickerController;
    UIImage * image1;
}

@end

@implementation PhotoViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self initView];
    
    UISwipeGestureRecognizer *swipe = [[UISwipeGestureRecognizer alloc] initWithTarget:self action:@selector(goBack)];
    swipe.direction = UISwipeGestureRecognizerDirectionRight;
    [vwBack addGestureRecognizer:swipe];

    // Do any additional setup after loading the view from its nib.
}
-(void)goBack{
    BOOL taked = igProfile.isHidden;
    if(taked)
        [self.navigationController popViewControllerAnimated:YES];
    else{
        igProfile.hidden = YES;
        btnContinue.hidden = YES;
        btnTakePhoto.hidden = NO;
    }
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    igProfile.layer.cornerRadius = igProfile.frame.size.height/2;
    igProfile.layer.masksToBounds = YES;
}

-(void)initView{

    btnTakePhoto.layer.cornerRadius = btnTakePhoto.frame.size.height/2;
    btnTakePhoto.layer.masksToBounds = YES;
    
    btnContinue.layer.cornerRadius = 10;//btnContinue.frame.size.height/2;
    btnContinue.layer.masksToBounds = YES;
    
}

-(IBAction)onClickTakePhoto:(id)sender{
    if( _imagePickerController == nil )
    {
        _imagePickerController = [[UIImagePickerController alloc] init];
        _imagePickerController.delegate = self;
        _imagePickerController.allowsEditing = NO;
    }
    
    
    UIAlertController *actionSheet = [UIAlertController alertControllerWithTitle:nil message:nil preferredStyle:UIAlertControllerStyleActionSheet];
    
    [actionSheet addAction:[UIAlertAction actionWithTitle:@"Cancel" style:UIAlertActionStyleCancel handler:^(UIAlertAction *action) {
        
        // Cancel button tappped.
        //        [self dismissViewControllerAnimated:YES completion:^{
        //        }];
    }]];
    
    [actionSheet addAction:[UIAlertAction actionWithTitle:@"Camera" style:UIAlertActionStyleDestructive handler:^(UIAlertAction *action) {
        
        // Distructive button tapped.
        [self performSelector:@selector(onClickCamera) withObject:nil afterDelay:0.1];
        //        [self dismissViewControllerAnimated:YES completion:^{
        //        }];
    }]];
    
    [actionSheet addAction:[UIAlertAction actionWithTitle:@"Photo" style:UIAlertActionStyleDefault handler:^(UIAlertAction *action) {
        
        // OK button tapped.
        [self performSelector:@selector(onClickPhotoLibrary) withObject:nil afterDelay:0.1];
        //        [self dismissViewControllerAnimated:YES completion:^{
        //        }];
    }]];
    
    // Present action sheet.
    [self presentViewController:actionSheet animated:YES completion:nil];

}

- (void)onClickCamera
{
    vwCover.hidden = NO;
    if( [UIImagePickerController isCameraDeviceAvailable:UIImagePickerControllerCameraDeviceRear] == FALSE )
    {
        [ToastView showWithParent:self.view text:@"You can not use camera!"];
        return;
    }
    
    _imagePickerController.sourceType = UIImagePickerControllerSourceTypeCamera;
    
    [self presentViewController:_imagePickerController animated:YES completion:nil];
}

- (void)onClickPhotoLibrary
{
    vwCover.hidden = NO;
    _imagePickerController.sourceType = UIImagePickerControllerSourceTypePhotoLibrary;
    
    [self presentViewController:_imagePickerController animated:YES completion:nil];
}


- (void)imagePickerControllerDidCancel:(UIImagePickerController *)picker
{
    vwCover.hidden = YES;
    [picker dismissViewControllerAnimated:NO completion:nil];
}

- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary *)info
{
    [picker dismissViewControllerAnimated:NO completion:nil];
    
    NSString* mediaType = [info objectForKey:UIImagePickerControllerMediaType];
    if ( [mediaType isEqualToString:@"public.movie"] )
    {
    }
    else
    {
        UIImage * img = [info objectForKey:UIImagePickerControllerOriginalImage];
        [self cropImageCtr:img];
    }
}
-(void)cropImageCtr:(UIImage *)image{
    
    TOCropViewCroppingStyle croppingStyle = TOCropViewCroppingStyleDefault;
    TOCropViewController * cropController = [[TOCropViewController alloc] initWithCroppingStyle:croppingStyle image:image];
    cropController.delegate = self;
    
    // -- Uncomment these if you want to test out restoring to a previous crop setting --
    //cropController.angle = 90; // The initial angle in which the image will be rotated
    //cropController.imageCropFrame = CGRectMake(0,0,2848,4288); //The
    
    //    cropController.aspectRatioPreset = TOCropViewControllerAspectRatioPresetSquare; //Set the initial aspect ratio as a square
    
    
    CGFloat width = 1.0f;
    CGFloat height = width * 1.0f;
    cropController.customAspectRatio = CGSizeMake(width, height);
    cropController.aspectRatioPreset = TOCropViewControllerAspectRatioPresetCustom;
    
    
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
    vwCover.hidden = YES;
    image1 = image;
    igProfile.image = image1;
    
    igProfile.hidden = NO;
    btnContinue.hidden = NO;
    btnTakePhoto.hidden = YES;
}

- (void)cropViewController:(TOCropViewController *)cropViewController didCropToCircularImage:(UIImage *)image withRect:(CGRect)cropRect angle:(NSInteger)angle
{

}

- (void)cropViewController:(nonnull TOCropViewController *)cropViewController didFinishCancelled:(BOOL)cancelled NS_SWIFT_NAME(cropViewController(_:didFinishCancelled:))
{
    vwCover.hidden = YES;
    [self dismissViewControllerAnimated:YES completion:nil];
}

-(IBAction)onClickSignIn:(id)sender{
    if(image1 != nil){
        [self showBusyDialog];
        [self performSelector:@selector(signup) withObject:nil afterDelay:0.1];
    }
}

-(void)signup{
    NSMutableDictionary * params = [[NSMutableDictionary alloc]init];
    
    NSData *imgData1 = UIImageJPEGRepresentation(image1, 0.5);
    
    [params setObject:_strFname forKey:@"firstname"];
    [params setObject:_strLname forKey:@"lastname"];
    [params setObject:_strEmail forKey:@"email"];
    [params setObject:_strPwd forKey:@"password"];
    NSDictionary * result = [UtilComm signup:@"profile.jpg" :imgData1 :params];
    [self hideBusyDialog];
    
    if(result != nil){
        NSDecimalNumber* deccode = [result objectForKey:@"code"];
        NSString * code = [NSString stringWithFormat:@"%@", deccode];
        if([code isEqualToString:@"1"])
        {
            NSString * strUserStyle = [result objectForKey:@"userstyles"];
            NSMutableDictionary * dicNoti  = [result objectForKey:@"profile"];
            NSString * szNoti =[NSString stringWithFormat:@"%@", [dicNoti objectForKey:@"mynotification"]];
            NSString * szFri  =[NSString stringWithFormat:@"%@", [dicNoti objectForKey:@"friendnotification"]];
            NSString * _token =[result objectForKey:@"_token"];
            NSString * _avatar = [result objectForKey:@"avatar"];
            NSString * _userid = [result objectForKey:@"user_id"];
            [Global sharedGlobal].szFri = szFri;
            [Global sharedGlobal].szNoti = szNoti;
            [Global sharedGlobal].userStyle = strUserStyle;
            [Global sharedGlobal].bLogin = YES;
            [Global sharedGlobal].bFBLogin = NO;
            [Global sharedGlobal].fbToken = _token;
            
            [Global sharedGlobal].fbid = _userid;
            [Global sharedGlobal].avatar = _avatar;
            [Global sharedGlobal].fbfname = _strFname;
            [Global sharedGlobal].fblname = _strLname;
            [Global sharedGlobal].fbEmail = _strEmail;
            [Global sharedGlobal].password = _strPwd;
            [[Global sharedGlobal] SaveParam];
            
            FTermsViewController *view = [[FTermsViewController alloc] initWithNibName:@"FTermsViewController" bundle:nil];
            [self presentViewController:view animated:NO completion:nil];
        }else{
            NSString * data = [result objectForKey:@"data"];
            UIAlertController * alert = [UIAlertController
                                         alertControllerWithTitle:@"Alert"
                                         message:data
                                         preferredStyle:UIAlertControllerStyleAlert];
            
            UIAlertAction* noButton = [UIAlertAction
                                       actionWithTitle:@"OK"
                                       style:UIAlertActionStyleDefault
                                       handler:^(UIAlertAction * action) {
                                           //Handle ok button
                                           igProfile.hidden = YES;
                                           [self goBack];
                                       }];
            
            [alert addAction:noButton];
            [self presentViewController:alert animated:YES completion:nil];
            
        }
    }

}
@end

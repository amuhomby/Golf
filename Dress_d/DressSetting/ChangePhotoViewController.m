//
//  ChangePhotoViewController.m
//  Dress_d
//
//  Created by MacAdmin on 11/28/17.
//  Copyright © 2017 MacAdmin. All rights reserved.
//

#import "ChangePhotoViewController.h"
#import "TOCropViewController.h"
#import "UIImageView+WebCache.h"
#import "GolfMainViewController.h"
#import "DressSearchViewController.h"


@interface ChangePhotoViewController ()<UIImagePickerControllerDelegate, UINavigationControllerDelegate, TOCropViewControllerDelegate>
{
    UIImagePickerController     *_imagePickerController;
    UIImage * image1;

}
@end

@implementation ChangePhotoViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self initView];
    // Do any additional setup after loading the view from its nib.
    UISwipeGestureRecognizer *swipe = [[UISwipeGestureRecognizer alloc] initWithTarget:self action:@selector(goBack)];
    swipe.direction = UISwipeGestureRecognizerDirectionRight;
    [vwBack addGestureRecognizer:swipe];

}
-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    [[GolfMainViewController sharedInstance] hideTab:YES];

    NSString * avatar = [Global sharedGlobal].avatar;
    [igPhoto setImageWithURL:[NSURL URLWithString:avatar] placeholderImage:[UIImage imageNamed:@"place_man.png"]];
    igPhoto.layer.cornerRadius = igPhoto.frame.size.height/2;
    igPhoto.layer.masksToBounds = YES;
}

-(void)goBack{
    BOOL taken = igPhoto.isHidden;
    if(taken)
        [self.navigationController popViewControllerAnimated:YES];
    else{
        igPhoto.hidden = YES;
        btnChangePhoto.hidden = YES;
        btnTakePhoto.hidden = NO;
    }
}
-(void)initView{
    btnTakePhoto.layer.cornerRadius = btnTakePhoto.frame.size.height/2;
    btnTakePhoto.layer.masksToBounds = YES;
    btnChangePhoto.layer.cornerRadius = btnChangePhoto.frame.size.height/2;
    btnChangePhoto.layer.masksToBounds = YES;
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
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
    [self hideView];
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
    [self hideView];
    _imagePickerController.sourceType = UIImagePickerControllerSourceTypePhotoLibrary;
    [self presentViewController:_imagePickerController animated:YES completion:nil];
}

-(void)hideView{
    [[GolfMainViewController sharedInstance] hideTab:YES];

    vwCover.hidden = NO;
}
- (void)imagePickerControllerDidCancel:(UIImagePickerController *)picker
{
    [self showView];
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
    image1 = image;
    [self performSelector:@selector(setNewAvatar) withObject:nil afterDelay:0.3];
    igPhoto.hidden = NO;
    btnChangePhoto.hidden = NO;
    btnTakePhoto.hidden = YES;
}

-(void)setNewAvatar{
    
    igPhoto.image = image1;
    [self showView];
}

-(void)showView{

    [[GolfMainViewController sharedInstance] hideTab:NO];
    vwCover.hidden = YES;

}
- (void)cropViewController:(TOCropViewController *)cropViewController didCropToCircularImage:(UIImage *)image withRect:(CGRect)cropRect angle:(NSInteger)angle
{
    
}

- (void)cropViewController:(nonnull TOCropViewController *)cropViewController didFinishCancelled:(BOOL)cancelled NS_SWIFT_NAME(cropViewController(_:didFinishCancelled:))
{
    [self showView];
    [self dismissViewControllerAnimated:YES completion:nil];
}

-(IBAction)onClickChangePhoto:(id)sender{
    if(image1 != nil){
        [self showBusyDialog];
        [self performSelector:@selector(avatarupdate) withObject:nil afterDelay:0.1];
    }
}

-(void)avatarupdate{
    NSMutableDictionary * params = [[NSMutableDictionary alloc]init];
    NSData *imgData1 = UIImageJPEGRepresentation(image1, 0.5);
    NSString * userid = [Global sharedGlobal].fbid;
    NSString * _token = [Global sharedGlobal].fbToken;
    [params setObject:userid forKey:@"user_id"];
    [params setObject:_token forKey:@"_token"];
    NSDictionary * result = [UtilComm avatarupdate:@"photo1.jpg" :imgData1 :params];
    [self hideBusyDialog];
    if(result != nil){
        NSDecimalNumber * deccode = [result objectForKey:@"code"];
        NSString * code = [NSString stringWithFormat:@"%@", deccode];
        if([code isEqualToString:@"1"]){
            NSString * avatar = [result objectForKey:@"avatar"];
            [Global sharedGlobal].avatar = avatar;
            [[Global sharedGlobal] SaveParam];
            [self.navigationController popViewControllerAnimated:YES];
        }
    }

}

-(IBAction)onClickBack:(id)sender{
    [self.navigationController popViewControllerAnimated:YES];
}

-(IBAction)onClickSrh:(id)sender{
    DressSearchViewController * vc = [[DressSearchViewController alloc]initWithNibName:@"DressSearchViewController" bundle:nil];
    [self.navigationController pushViewController:vc animated:YES];
}
@end

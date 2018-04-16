
#import "ProgressViewController.h"
#import "MBProgressHUD.h"
#import "SVProgressHUD.h"

@interface ProgressViewController ()
{
    MBProgressHUD   *HUD;
}

@end

@implementation ProgressViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
//    UIView * statusBar = [[[UIApplication sharedApplication] valueForKey:@"statusBarWindow"] valueForKey:@"statusBar"];
//    if([statusBar respondsToSelector:@selector(setBackgroundColor:)]){
//        statusBar.backgroundColor = mainGreenColor;
//    }

}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    
//    UIView * statusBar = [[[UIApplication sharedApplication] valueForKey:@"statusBarWindow"] valueForKey:@"statusBar"];
//    if([statusBar respondsToSelector:@selector(setBackgroundColor:)]){
//        statusBar.backgroundColor = mainGreenColor;
//    }

    [self refreshContentByLangType];
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
//    UIView * statusBar = [[[UIApplication sharedApplication] valueForKey:@"statusBarWindow"] valueForKey:@"statusBar"];
//    if([statusBar respondsToSelector:@selector(setBackgroundColor:)]){
//        statusBar.backgroundColor = mainGreenColor;
//    }

}

- (void)refreshContentByLangType
{
    
}

- (void)showBusyDialogWithTitle:(NSString*)strTitle
{
    if( HUD != nil )
    {
        [self hideBusyDialog];
    }
    
    HUD = [[MBProgressHUD alloc] initWithView:self.view];
    [self.view addSubview:HUD];
    HUD.labelText = strTitle;
    [self.view bringSubviewToFront:HUD];
    HUD.removeFromSuperViewOnHide = true;
    [HUD show:YES];
}

- (void)showBusyDialog
{
    [SVProgressHUD setContainerView:nil];
    [SVProgressHUD setBackgroundColor:[UIColor clearColor]];
    [SVProgressHUD setForegroundColor:mainGreenColor];
    [SVProgressHUD setRingThickness:5];
    [SVProgressHUD show];
//    [self showBusyDialogWithTitle:nil];
}

- (void)hideBusyDialog
{
    [SVProgressHUD dismiss];
//    [HUD hide:YES];
//    [HUD removeFromSuperview];
//    HUD = nil;
}

- (void)goToChatPage
{

}

-(NSString *)Encoding:(NSString *)plain{
    if(!(plain != (id)[NSNull null] && plain.length != 0)){
        plain = @"";
    }
    NSData *nsdata = [plain dataUsingEncoding:NSUTF8StringEncoding];
    NSString *base64Encoded = [nsdata base64EncodedStringWithOptions:0];
    return base64Encoded;
}

-(NSString *)Decoding:(NSString *)ciper{
    if(!(ciper != (id)[NSNull null] && ciper.length != 0)){
        ciper = @"";
    }

    NSData * subData2 = [[NSData alloc] initWithBase64EncodedString:ciper options:0];
    NSString * sub2 = [[NSString alloc]initWithData:subData2 encoding:NSUTF8StringEncoding];
    return sub2;
}

- (UIImage *)blurredImageWithImage:(UIImage *)sourceImage{
    
    //  Create our blurred image
    CIContext *context = [CIContext contextWithOptions:nil];
    CIImage *inputImage = [CIImage imageWithCGImage:sourceImage.CGImage];
    
    //  Setting up Gaussian Blur
    CIFilter *filter = [CIFilter filterWithName:@"CIGaussianBlur"];
    [filter setValue:inputImage forKey:kCIInputImageKey];
    [filter setValue:[NSNumber numberWithFloat:15.0f] forKey:@"inputRadius"];
    CIImage *result = [filter valueForKey:kCIOutputImageKey];
    
    /*  CIGaussianBlur has a tendency to shrink the image a little, this ensures it matches
     *  up exactly to the bounds of our original image */
    CGImageRef cgImage = [context createCGImage:result fromRect:[inputImage extent]];
    
    UIImage *retVal = [UIImage imageWithCGImage:cgImage];
    
    if (cgImage) {
        CGImageRelease(cgImage);
    }
    
    return retVal;
}

-(void)blurEffect:(UIView *)view{
    if (!UIAccessibilityIsReduceTransparencyEnabled()) {
        view.backgroundColor = [UIColor clearColor];
        
        UIBlurEffect *blurEffect = [UIBlurEffect effectWithStyle:UIBlurEffectStyleRegular];
        UIVisualEffectView *blurEffectView = [[UIVisualEffectView alloc] initWithEffect:blurEffect];
        //always fill the view
        blurEffectView.frame = self.view.bounds;
        blurEffectView.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;
        
        [view addSubview:blurEffectView]; //if you have more UIViews, use an insertSubview API to place it where needed
    } else {
        view.backgroundColor = [UIColor blackColor];
    }
}
@end

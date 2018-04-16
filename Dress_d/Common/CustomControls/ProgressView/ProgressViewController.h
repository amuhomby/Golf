
#import <UIKit/UIKit.h>
#import "ToastView.h"

@interface ProgressViewController : UIViewController

- (void)refreshContentByLangType;

- (void)showBusyDialogWithTitle:(NSString*)strTitle;

- (void)showBusyDialog;

- (void)hideBusyDialog;

-(NSString *)Encoding:(NSString *)plain;

-(NSString *)Decoding:(NSString *)ciper;

-(UIImage *)blurredImageWithImage:(UIImage *)sourceImage;

-(void)blurEffect:(UIView *)view;
@end

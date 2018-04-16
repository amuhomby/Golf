
#import <UIKit/UIKit.h>
#import "ProgressViewController.h"


@interface WebViewController : ProgressViewController <UIWebViewDelegate>
{
    IBOutlet UILabel    *lblTitle;
    IBOutlet UIWebView  *webView;
    IBOutlet UIButton *btnBack;

    NSString    *_webAddress;
    NSString    *_Title;
}

+ (id)webViewWithAddress:(NSString *)webAddress ofTitle:(NSString*)strTitle;

- (id)initWithWebAddress:(NSString *)webAddress ofTitle:(NSString*)strTitle;

- (IBAction)onClickBack:(id)sender;

@end

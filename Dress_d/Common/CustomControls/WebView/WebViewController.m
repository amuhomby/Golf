
#import "WebViewController.h"
#import "AppDelegate.h"

@implementation WebViewController

+ (id)webViewWithAddress:(NSString*)webAddress ofTitle:(NSString*)strTitle
{
    WebViewController* detail = [[WebViewController alloc] initWithWebAddress:webAddress ofTitle:strTitle];
    
    return detail;
}

-(id)initWithWebAddress:(NSString*)webAddress ofTitle:(NSString*)strTitle
{
    self = [self initWithNibName:@"WebViewController" bundle:nil];
    
    _webAddress = [[NSString alloc] initWithString:webAddress];
    _Title = [[NSString alloc] initWithString:strTitle];

    return self;
}

#pragma mark - View lifecycle

- (void) loadWebView
{
    if ( _webAddress && _webAddress.length > 0 )
        [webView loadRequest:[NSURLRequest requestWithURL:[NSURL URLWithString:_webAddress]]];
    else
        [self hideBusyDialog];
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    self.navigationController.navigationBarHidden = YES;
    
    [self showBusyDialog];
    [self performSelector:@selector(loadWebView) withObject:nil afterDelay:0.5f];

    //self.title = _Title;

//    int index = [Global sharedGlobal].isEnLang == YES ? 0 : 1;
//   [btnBack setTitle:[[Global sharedGlobal].arrBackButton objectAtIndex:index] forState: UIControlStateNormal];

    lblTitle.text = _Title;
    if( [[UIDevice currentDevice] userInterfaceIdiom] == UIUserInterfaceIdiomPad )
        lblTitle.font = [UIFont systemFontOfSize:30];
}

- (void)viewDidUnload
{
    [super viewDidUnload];
}

- (IBAction)onClickBack:(id)sender
{
    [self.navigationController popViewControllerAnimated:YES];
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)toInterfaceOrientation
{
    return NO;
}

// New Autorotation support.
- (BOOL)shouldAutorotate
{
    return NO;
}

//- (NSUInteger)supportedInterfaceOrientations
//{
//    return UIInterfaceOrientationMaskPortrait;
//}

- (void)webViewDidFinishLoad:(UIWebView *)webView
{
    [self hideBusyDialog];
}

- (void)webView:(UIWebView *)webView didFailLoadWithError:(NSError *)error
{
    [self hideBusyDialog];
}

@end

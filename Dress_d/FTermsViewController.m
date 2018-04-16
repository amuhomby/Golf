//
//  FTermsViewController.m
//  Dress_d
//
//  Created by MacAdmin on 11/17/17.
//  Copyright © 2017 MacAdmin. All rights reserved.
//

#import "FTermsViewController.h"
#import "HelpViewController.h"

@interface FTermsViewController ()<UIWebViewDelegate, UIScrollViewDelegate>
{
    NSString * _webAddress;
    CGFloat hViewbtn;
}
@end

@implementation FTermsViewController

- (void) loadWebView
{
    if ( _webAddress && _webAddress.length > 0 )
        [webView loadRequest:[NSURLRequest requestWithURL:[NSURL URLWithString:_webAddress]]];
    else
        [self hideBusyDialog];
}

-(void)viewDidLayoutSubviews{
}
- (void)viewDidLoad {
    [super viewDidLoad];
    _webAddress = @"http://app.dressd.us/terms/terms.html";
    // Do any additional setup after loading the view from its nib.
    self.navigationController.navigationBarHidden = YES;
    [self showBusyDialog];
    [self performSelector:@selector(loadWebView) withObject:nil afterDelay:0.5f];
    btnAccept.layer.cornerRadius = btnAccept.frame.size.height/2;
    btnAccept.layer.masksToBounds = YES;
    
    btnReject.layer.cornerRadius = btnReject.frame.size.height/2;
    btnReject.layer.masksToBounds = YES;
    webView.scrollView.delegate = self;
    
}

-(void)viewWillAppear:(BOOL)animated{
    hViewbtn = viewBtn.frame.size.height;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)viewDidUnload
{
    [super viewDidUnload];
}

- (void)webViewDidFinishLoad:(UIWebView *)webView
{
    [self hideBusyDialog];
}

- (void)webView:(UIWebView *)webView didFailLoadWithError:(NSError *)error
{
    [self hideBusyDialog];
}

-(void)scrollViewDidScroll:(UIScrollView *)scrollView{
    if(scrollView.contentOffset.y >= (scrollView.contentSize.height - scrollView.frame.size.height )){

        [UIView animateWithDuration:0.1 animations:^(void){
            CGFloat hDevice = [UIScreen mainScreen].bounds.size.height;
            CGFloat hWebview = hDevice - 20 - hViewbtn;
            CGRect frameWeb = webView.frame;
            if(hWebview != frameWeb.size.height){
                frameWeb.size.height = hWebview;
                webView.frame = frameWeb;
                CGRect frameViewBtn = viewBtn.frame;
                frameViewBtn.origin.y = frameWeb.origin.y + frameWeb.size.height;
                viewBtn.frame = frameViewBtn;

            }
        }];
        
    }else if(scrollView.contentOffset.y <= (scrollView.contentSize.height - scrollView.frame.size.height - 60)){
        NSLog(@"move from bottom");

        [UIView animateWithDuration:0.1 animations:^(void){
           CGFloat hDevice = [UIScreen mainScreen].bounds.size.height;
           CGFloat hWebview = hDevice - 20 ;
           CGRect frameWeb = webView.frame;
            if(hWebview != frameWeb.size.height){
                frameWeb.size.height = hWebview;
                webView.frame = frameWeb;
                
                CGRect frameViewBtn = viewBtn.frame;
                frameViewBtn.origin.y = frameWeb.origin.y + frameWeb.size.height;
                viewBtn.frame = frameViewBtn;
            }
 
        }];
    }
}
-(IBAction)onClickAccept:(id)sender{
    HelpViewController *venuView = [[HelpViewController alloc] initWithNibName:@"HelpViewController" bundle:nil];
    [self.navigationController pushViewController:venuView animated:YES];
}

-(IBAction)onClickReject:(id)sender{

}
@end

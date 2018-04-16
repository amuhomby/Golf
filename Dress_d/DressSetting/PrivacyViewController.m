//
//  PrivacyViewController.m
//  Dress_d
//
//  Created by MacAdmin on 10/11/17.
//  Copyright © 2017 MacAdmin. All rights reserved.
//

#import "PrivacyViewController.h"
#import "DressSearchViewController.h"
#import "GolfMainViewController.h"

@interface PrivacyViewController ()
{

}
@end

@implementation PrivacyViewController

- (void) loadWebView
{
    if ( _webAddress && _webAddress.length > 0 )
        [webview loadRequest:[NSURLRequest requestWithURL:[NSURL URLWithString:_webAddress]]];
    else
        [self hideBusyDialog];
}
- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    self.navigationController.navigationBarHidden = YES;
    [self showBusyDialog];
    [self performSelector:@selector(loadWebView) withObject:nil afterDelay:0.5f];

    UISwipeGestureRecognizer *swipe = [[UISwipeGestureRecognizer alloc] initWithTarget:self action:@selector(goBack)];
    // And assuming the "Up" direction in your screenshot is no accident
    swipe.direction = UISwipeGestureRecognizerDirectionRight;
    [webview addGestureRecognizer:swipe];
    
}
-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];

    [[GolfMainViewController sharedInstance] hideTab:YES];

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


-(IBAction)onClickBack:(id)sender{
    [self goBack];
}

-(void)goBack{
    [self.navigationController popViewControllerAnimated:YES];
}
-(IBAction)onClickSrh:(id)sender{
    DressSearchViewController * vc = [[DressSearchViewController alloc]initWithNibName:@"DressSearchViewController" bundle:nil];
    [self.navigationController pushViewController:vc animated:YES];
}

@end

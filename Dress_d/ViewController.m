//
//  ViewController.m
//  Dress_d
//
//  Created by MacAdmin on 21/09/2017.
//  Copyright © 2017 MacAdmin. All rights reserved.
//

#import "ViewController.h"
#import "HomeViewController.h"
#import "GolfMainViewController.h"
#import "dressWelcomeController.h"
#import "FTermsViewController.h"

@interface ViewController ()

@end

@implementation ViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)viewDidAppear:(BOOL)animated
{
    self.view.alpha = 1.0f;
    [UIView beginAnimations:nil context:nil];
    [UIView setAnimationDuration:1.0f];
    [UIView setAnimationDelegate:self];
    self.view.alpha = 1.0f;
    [UIView setAnimationDidStopSelector:@selector(showAnimationStopped)];
    [UIView commitAnimations];
}

- (void)showAnimationStopped
{
    self.view.alpha = 1.0f;
    [UIView beginAnimations:nil context:nil];
    [UIView setAnimationDuration:1.0f];
    [UIView setAnimationDelegate:self];
    self.view.alpha = 1.0f;
    [UIView setAnimationDidStopSelector:@selector(hideAnimationStopped)];
    [UIView commitAnimations];
}

- (void)hideAnimationStopped
{
    if ( [Global sharedGlobal].bLogin == YES )
    {
        [self performSelector:@selector(processDressLogin) withObject:nil afterDelay:0.5];
        return;
    }

    HomeViewController *homeView = [[HomeViewController alloc] initWithNibName:@"HomeViewController" bundle:nil];
    
    UINavigationController *navVC = [[UINavigationController alloc] initWithRootViewController:homeView];
    [self presentViewController:navVC animated:NO completion:nil];
}


- (void)processDressLogin
{
    GolfMainViewController *VC = [[UIStoryboard storyboardWithName:@"GolfMain" bundle:nil] instantiateViewControllerWithIdentifier:@"main"];
    [self presentViewController:VC animated:YES completion:nil];
    
}


@end

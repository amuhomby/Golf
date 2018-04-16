//
//  ToastView.m
//  Community
//
//  Created by BST on 13-6-15.
//  Copyright 2013年 __MyCompanyName__. All rights reserved.
//

#import "ToastView.h"
#import <QuartzCore/QuartzCore.h>

@implementation ToastView

+ (void)showWithParent:(UIView*)parent commResultCode:(CommResult)retCode
{
    NSString*   text = @"";
    
    if( retCode == kCommResultFailNetwork )
        text = @"Server is not responding, Please try once more";
    else if( retCode == kCommResultServerError )
        text = @"Failed server response. Please try again.";
    else if( retCode == kCommResultNoParam )
        text = @"Missing some parameters. Please check and try again.";
    else if( retCode == kCommResultNoPermit )
        text = @"No permission. Please login again.";
    else if( retCode == kCommResultNoUser )
        text = @"No match user name. Please check and try again.";
    else if( retCode == kCommResultFailPassword )
        text = @"No match password. Please confirm password and try again.";
    else if( retCode == kCommResultEmailError )
        text = @"Already exist email. Please check email and try again.";
    else if( retCode == kCommResultPassPeriod )
        text = @"No logged date. Please login again.";
    else if( retCode == kCommResultInvalidAnswer )
        text = @"Invalid Answer. Please check security question and answer you selected.";
    else if( retCode == kCommResultNoChatTime )
        text = @"No chat time. Please try later.";
    else if( retCode == kCommResultICNoExist )
        text = @"Already exist IC No. Please check IC No and try again.";
    else if( retCode == kCommResultCompanyNoExist )
        text = @"No exist company. Please check and try again.";
    else if( retCode == kCommResultNoVerifyUser )
        text = @"No Verify user.";

    else// if( retCode == kCommResultUnknownError )
        text = @"Unknown Error";
    
    [ToastView showWithParent:parent text:text];
}

+ (void)showWithParent:(UIView*)parent text:(NSString*)text
{
    if ( text == nil )
        return;
    //[ToastView showWithParent:parent text:text afterDelay:0.0f];
    
    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@""
                                                    message:text
                                                   delegate:self
                                          cancelButtonTitle:@"OK"
                                          otherButtonTitles:nil];
    [alert show];
}

+(void) showWithParent:(UIView*)parent text:(NSString*)text afterDelay:(float)delay
{
    ToastView* view = [[ToastView alloc] initWithText:text delay:delay];
    [parent addSubview:view];
    
    view.layer.borderWidth = 2.0f;
    view.layer.borderColor = [[UIColor grayColor] CGColor];
    view.layer.cornerRadius = 5;
    view.backgroundColor = [UIColor blackColor];
    view.textColor = [UIColor whiteColor];
    view.font = [UIFont systemFontOfSize:18.0f];
    view.textAlignment = NSTextAlignmentCenter;;

    view.editable = FALSE;
    view.userInteractionEnabled = FALSE;
    
    CGSize parentSize = [parent frame].size;
    CGSize constrainedSize = parentSize;
    
    constrainedSize.width -= 30;
    
    CGSize textSize = [text sizeWithFont:view.font constrainedToSize:constrainedSize];
    
    view.frame = CGRectMake( (parentSize.width-textSize.width-30)/2, parentSize.height*3/4-textSize.height, textSize.width+30, textSize.height+15 );
    
    if( [parent isKindOfClass:[UIScrollView class]] ) {
        view.frame = CGRectMake(view.frame.origin.x, view.frame.origin.y + ((UIScrollView*)parent).contentOffset.y, view.frame.size.width, view.frame.size.height);
    }
}

-(id) initWithText:(NSString*)text delay:(float)delay
{
    self = [super init];
    
    if( self )
    {
        self.text = text;

        self.alpha = 0.0;
        [self performSelector:@selector(displayToast:) withObject:nil afterDelay:delay];
    }
    
    return self;
}

-(void) displayToast:(id)object
{
    [UIView beginAnimations: nil context: nil];
    [UIView setAnimationDuration:0.5f];
    [UIView setAnimationDelegate: self];
    self.alpha = 0.8;
    [UIView commitAnimations];
    
    [self performSelector:@selector(dismissToast:) withObject:nil afterDelay:1.5f];
}

-(void) dismissToast:(id)object
{
    [UIView beginAnimations: nil context: nil];
    [UIView setAnimationDuration:1.0f];
    [UIView setAnimationDelegate: self];
    [UIView setAnimationDidStopSelector:@selector(didDismissEnded:)];
    self.alpha = 0.0;
	[UIView commitAnimations];
}

-(void) didDismissEnded:(id) object
{
    [self removeFromSuperview];
}

@end

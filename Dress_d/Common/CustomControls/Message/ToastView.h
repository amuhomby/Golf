//
//  ToastView.h
//  Community
//
//  Created by BST on 13-6-15.
//  Copyright 2013年 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "UtilComm.h"

@interface ToastView : UITextView {
    
}

+(void) showWithParent:(UIView*)parent commResultCode:(CommResult)retCode;
+(void) showWithParent:(UIView*)parent text:(NSString*)text;
+(void) showWithParent:(UIView*)parent text:(NSString*)text afterDelay:(float)delay;

-(id) initWithText:(NSString*)text delay:(float)delay;

@end

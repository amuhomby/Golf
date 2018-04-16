//
//  EncodeUtil.h
//  Community
//
//  Created by BST on 13-6-5.
//  Copyright 2013年 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>


@interface UtilEncode : NSObject {

}

+ (NSString*)unicharToHexString:(unichar) nChar;
+ (NSString*)stringToHexArray:(NSString*) strText;

@end

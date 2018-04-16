//
//  EncodeUtil.m
//  Community
//
//  Created by BST on 13-6-5.
//  Copyright 2013年 __MyCompanyName__. All rights reserved.
//

#import "UtilEncode.h"

static const NSString* HEX_DIGITS[] = { @"0", @"1", @"2", @"3", @"4", @"5", @"6", @"7", @"8", @"9", @"a", @"b", @"c", @"d", @"e", @"f" };

@implementation UtilEncode

+ (NSString*)unicharToHexString:(unichar)nChar
{
    Byte  v1, v2, v3, v4;

    v1 = (Byte)(0x0F & nChar);
    v2 = (Byte)(0x0F & (nChar>>4));
    v3 = (Byte)(0x0F & (nChar>>8));
    v4 = (Byte)(0x0F & (nChar>>12));

    return [NSString stringWithFormat:@"%@%@%@%@", HEX_DIGITS[v1], HEX_DIGITS[v2], HEX_DIGITS[v3], HEX_DIGITS[v4]];
}

+ (NSString*)stringToHexArray:(NSString*)strText
{
    NSString *res = @"";
    
    for( int i = 0; i < [strText length]; i++ )
    {
        unichar c = [strText characterAtIndex:i];
        
        res = [res stringByAppendingString:[UtilEncode unicharToHexString:c]];
    }
    
    return res;
}

@end
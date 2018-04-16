//
//  NSString+Base64.m
//  PropertyKing5
//
//  Created by admin on 1/29/15.
//  Copyright (c) 2015 ___exchange___. All rights reserved.
//

#import "NSString+Base64.h"
#import "NSData+Base64.h"

@implementation NSString (Base64)

- (NSString*)base64DecodedString
{
    NSData      *data64 = [NSData dataFromBase64String:self];
        
    NSString    *strDecoded = [[NSString alloc] initWithData:data64 encoding:NSUTF8StringEncoding];
        
    return strDecoded;
}

@end

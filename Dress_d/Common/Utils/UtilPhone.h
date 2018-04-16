//
//  PhoneUtil.h
//  Community
//
//  Created by BST on 13-6-8.
//  Copyright 2013年 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>


@interface UtilPhone : NSObject {
    
}

+ (NSString *)getDevicePhoneNumber;

+ (void)sendCall:(NSString *)phoneNumber;
+ (void)sendCallWithOutGoBack:(NSString *)phoneNumber;

+ (BOOL)checkMobileNumber:(NSString *)mobileNumber;
+ (BOOL)checkTelNumber:(NSString *)telNumber;

+ (BOOL)checkCellPhone:(NSString *)cellNumber;

+ (BOOL)isValidEmail:(NSString *)checkString;

+ (BOOL)checkPhoneNumber:(NSString *)mobileNumber;

+ (BOOL)checkPostalcodeInUK:(NSString *)postalcode;

@end

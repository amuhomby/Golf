//
//  PhoneUtil.m
//  Community
//
//  Created by BST on 13-6-8.
//  Copyright 2013年 __MyCompanyName__. All rights reserved.
//

#import "UtilPhone.h"
#import <UIKit/UIKit.h>

#define REG_EXP_MOBILE          @"^0?1([3,5,8]{1}[0-9]{1})[0-9]{8}$"
#define REG_EXP_TEL             @"^([0-9][1-9][0-9]{1,2}-)?[0-9]{7,8}$"
#define REG_EXP_CELLPHONE       @"^(((\\+86)|(86))?(\\s)*((13[0-9])|(15[^4,\\D])|(18[0,5-9])))\\d{8}$"
#define REG_EXP_PHONE           @"^\\s*(?:\\+?(\\d{1,3}))?[-. (]*(\\d{3})[-. )]*(\\d{3})[-. ]*(\\d{4})(?: *x(\\d+))?\\s*$"

@implementation UtilPhone

+ (NSString *)getDevicePhoneNumber
{
    NSString *phoneNum = [[NSUserDefaults standardUserDefaults] stringForKey:@"SBFormattedPhoneNumber"];

    return phoneNum;
}

+ (void)sendCall:(NSString *)phoneNumber
{
    //if( [UtilPhone checkMobileNumber:phoneNumber] == FALSE &&
    //    [UtilPhone checkTelNumber:phoneNumber] == FALSE )
    //    return;
    
    phoneNumber = [phoneNumber stringByReplacingOccurrencesOfString:@" " withString:@""];
    phoneNumber = [phoneNumber stringByReplacingOccurrencesOfString:@"*" withString:@""];
    phoneNumber = [phoneNumber stringByReplacingOccurrencesOfString:@"#" withString:@""];
    
    if( [phoneNumber rangeOfString:@"+"].length == 0 )
        phoneNumber = [NSString stringWithFormat:@"+%@", phoneNumber];

    NSString *callURL = [@"telprompt://" stringByAppendingString:phoneNumber];
    [[UIApplication sharedApplication] openURL:[NSURL URLWithString:callURL]];
}

+ (void)sendCallWithOutGoBack:(NSString *)phoneNumber
{
    //if( [UtilPhone checkMobileNumber:phoneNumber] == FALSE &&
    //    [UtilPhone checkTelNumber:phoneNumber] == FALSE )
    //    return;
    
    phoneNumber = [phoneNumber stringByReplacingOccurrencesOfString:@" " withString:@""];
    phoneNumber = [phoneNumber stringByReplacingOccurrencesOfString:@"*" withString:@""];
    phoneNumber = [phoneNumber stringByReplacingOccurrencesOfString:@"#" withString:@""];
    
    if( [phoneNumber rangeOfString:@"+"].length == 0 )
        phoneNumber = [NSString stringWithFormat:@"+%@", phoneNumber];

    NSString *callURL = [@"tel://" stringByAppendingString:phoneNumber];
    [[UIApplication sharedApplication] openURL:[NSURL URLWithString:callURL]];
}

//(GIR 0AA)|((([A-Z-[QVX]][0-9][0-9]?)|(([A-Z-[QVX]][A-Z-[IJZ]][0-9][0-9]?)|(([A-Z-[QVX]][0-9][A-HJKPSTUW])|([A-Z-[QVX]][A-Z-[IJZ]][0-9][ABEHMNPRVWXY])))) [0-9][A-Z-[CIKMOV]]{2})
+ (BOOL)checkPostalcodeInUK:(NSString *)postalcode
{
    NSString *strRegex = @"^(([gG][iI][rR] {0,}0[aA]{2})|((([a-pr-uwyzA-PR-UWYZ][a-hk-yA-HK-Y]?[0-9][0-9]?)|(([a-pr-uwyzA-PR-UWYZ][0-9][a-hjkstuwA-HJKSTUW])|([a-pr-uwyzA-PR-UWYZ][a-hk-yA-HK-Y][0-9][abehmnprv-yABEHMNPRV-Y]))) {0,}[0-9][abd-hjlnp-uw-zABD-HJLNP-UW-Z]{2}))$";
    NSPredicate *strTest = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", strRegex];
    return [strTest evaluateWithObject:postalcode];
}

+ (BOOL)checkMobileNumber:(NSString *)mobileNumber
{
//    NSError *error = NULL;
//
//    NSRegularExpression *regex = [NSRegularExpression regularExpressionWithPattern:REG_EXP_MOBILE options:NSRegularExpressionCaseInsensitive error:&error];
//    
//    __block BOOL bOK = FALSE;
//    [regex enumerateMatchesInString:mobileNumber
//                            options:NSMatchingReportCompletion
//                              range:NSMakeRange(0, [mobileNumber length])
//                         usingBlock:^(NSTextCheckingResult *result, NSMatchingFlags flags, BOOL *stop ) {
//                             NSRange range = [result rangeAtIndex:0];
//                             
//                             if( range.location == 0 && range.length == [mobileNumber length] )
//                                 bOK = TRUE;
//                         }];
//    
//    return bOK;
    
    NSString *phoneRegex = @"^([0-9]{3})[0-9]{3}-[0-9]{4}$";
    NSPredicate *phoneTest = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", phoneRegex];
    return [phoneTest evaluateWithObject:mobileNumber];
}

+ (BOOL)checkPhoneNumber:(NSString *)telNumber
{
    NSError *error = NULL;
    NSRegularExpression *regex = [NSRegularExpression regularExpressionWithPattern:REG_EXP_PHONE options:NSRegularExpressionCaseInsensitive error:&error];
    
    __block BOOL bOK = FALSE;
    [regex enumerateMatchesInString:telNumber
                            options:NSMatchingReportCompletion
                              range:NSMakeRange(0, [telNumber length])
                         usingBlock:^(NSTextCheckingResult *result, NSMatchingFlags flags, BOOL *stop ) {
                             NSRange range = [result rangeAtIndex:0];
                             
                             if( range.location == 0 && range.length == [telNumber length] )
                                 bOK = TRUE;
                         }];
    
    return bOK;
}

+ (BOOL)checkTelNumber:(NSString *)telNumber
{
    NSError *error = NULL;
    NSRegularExpression *regex = [NSRegularExpression regularExpressionWithPattern:REG_EXP_TEL options:NSRegularExpressionCaseInsensitive error:&error];
    
    __block BOOL bOK = FALSE;
    [regex enumerateMatchesInString:telNumber
                            options:NSMatchingReportCompletion
                              range:NSMakeRange(0, [telNumber length])
                         usingBlock:^(NSTextCheckingResult *result, NSMatchingFlags flags, BOOL *stop ) {
                             NSRange range = [result rangeAtIndex:0];
                             
                             if( range.location == 0 && range.length == [telNumber length] )
                                 bOK = TRUE;
                         }];
    
    return bOK;
}

+ (BOOL)checkCellPhone:(NSString *)cellNumber
{
    NSError *error = NULL;
    NSRegularExpression *regex = [NSRegularExpression regularExpressionWithPattern:REG_EXP_CELLPHONE options:NSRegularExpressionCaseInsensitive error:&error];
    
    __block BOOL bOK = FALSE;
    [regex enumerateMatchesInString:cellNumber
                            options:NSMatchingReportCompletion
                              range:NSMakeRange(0, [cellNumber length])
                         usingBlock:^(NSTextCheckingResult *result, NSMatchingFlags flags, BOOL *stop ) {
                             NSRange range = [result rangeAtIndex:0];
                             
                             if( range.location == 0 && range.length == [cellNumber length] )
                                 bOK = TRUE;
                         }];
    
    return bOK;
}


+ (BOOL)isValidEmail:(NSString *)checkString
{
    BOOL stricterFilter = NO;
    NSString *stricterFilterString = @"^[A-Z0-9a-z\\._%+-]+@([A-Za-z0-9-]+\\.)+[A-Za-z]{2,4}$";
    NSString *laxString = @"^.+@([A-Za-z0-9-]+\\.)+[A-Za-z]{2}[A-Za-z]*$";
    NSString *emailRegex = stricterFilter ? stricterFilterString : laxString;
    NSPredicate *emailTest = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", emailRegex];
    return [emailTest evaluateWithObject:checkString];
}


@end

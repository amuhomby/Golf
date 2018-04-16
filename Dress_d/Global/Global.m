//
//  Global.m
//  Periscope
//
//  Created by MacAdmin on 4/2/16.
//  Copyright © 2016 MacAdmin. All rights reserved.
//

#import "Global.h"

@implementation Global
{
    
}


Global* _sharedGlobal = nil;

+ (Global*)sharedGlobal
{
    if( _sharedGlobal == nil )
    {
        _sharedGlobal = [[Global alloc] init];
        [_sharedGlobal LoadParam];
    }
    
    return _sharedGlobal;
}

- (void) initParam
{
    self.bLogin = NO;
    self.bFBLogin = NO;
    self.fcmToken   = @"";
    
    self.userid     = @"";
    self.token      = @"";
    self.mobile     = @"";
    self.username   = @"";
    self.fullname   = @"";
    self.email      = @"";
    self.password   = @"";
    self.avatar  = @"";
    self.vcode      = @"";
    self.strRegion  = @"";
    self.postCode   = @"";
    self.userPhoto  = nil;
    self.strPhoto   = @"";
    self.strFirstName = @"";
    self.strLastName = @"";
    self.strOrganization = @"";
    self.strGender = @"";
    self.strAddress = @"";
    self.strJob = @"";
    self.strAbout = @"";
    self.strBirthday = @"";
    
    self.fbEmail = @"";
    self.fbid = @"";
    self.fbfname = @"";
    self.fblname = @"";
    self.fbname = @"";
    self.szNoti = @"";
    self.szFri = @"";
    self.fbToken = @"";
    self.userStyle = @"";
    self.whoProfile = @"";
    self.lat = @"";
    self.lon = @"";
    self.city = @"";
    self.state = @"";
    self.country = @"";
    self.usingApp = @"using";
    self.tabIndex = @"0";
    self.bakeToAdd = @"no";
    self.cameraBack = @"no";
    self.tocamera = @"no";
    
    
    self.arrStyle = [[NSMutableArray alloc] init];
    [self SaveParam];
}

- (void)LoadParam
{
    NSUserDefaults  *defaults = [NSUserDefaults standardUserDefaults];
    BOOL            bInstalled = [defaults boolForKey:@"Launch Application"];
    
    if( !bInstalled )
    {
        [defaults setBool:YES forKey:@"Launch Application"];
        
        [self initParam];
    }
    else
    {
        self.bLogin    = [[defaults valueForKey:@"login"] boolValue];
        self.bFBLogin    = [[defaults valueForKey:@"fblogin"] boolValue];
        self.fcmToken   = [defaults valueForKey:@"fcmtoken"];
        self.pushKey    = [defaults valueForKey:@"pushkey"];
        self.userid     = [defaults valueForKey:@"userid"];
        self.token      = [defaults valueForKey:@"token"];
        self.mobile     = [defaults valueForKey:@"mobile"];
        self.username   = [defaults valueForKey:@"username"];
        self.fullname   = [defaults valueForKey:@"fullname"];
        self.email      = [defaults valueForKey:@"email"];
        self.password   = [defaults valueForKey:@"password"];
        self.avatar   = [defaults valueForKey:@"avatar"];
        self.vcode      = [defaults valueForKey:@"vcode"];
        self.strRegion  = [defaults valueForKey:@"region"];
        self.postCode   = [defaults valueForKey:@"postcode"];
        self.strPhoto   = [defaults valueForKey:@"photo"];
        self.strFirstName    = [defaults valueForKey:@"firstname"];
        self.strLastName     = [defaults valueForKey:@"lastname"];
        self.strOrganization = [defaults valueForKey:@"organization"];
        self.strGender   = [defaults valueForKey:@"gender"];
        self.strAddress  = [defaults valueForKey:@"address"];
        self.strJob      = [defaults valueForKey:@"job"];
        self.strAbout    = [defaults valueForKey:@"about"];
        self.strBirthday = [defaults valueForKey:@"birth"];
        
        
        self.fbEmail = [defaults valueForKey:@"fbEmail"];
        self.fbid = [defaults valueForKey:@"fbid"];
        self.fbfname = [defaults valueForKey:@"fbfname"];
        self.fblname = [defaults valueForKey:@"fblname"];
        self.fbname = [defaults valueForKey:@"fbname"];
        self.szNoti = [defaults valueForKey:@"szNoti"];
        self.szFri = [defaults valueForKey:@"szFri"];
        self.fbToken = [defaults valueForKey:@"fbToken"];
        self.userStyle = [defaults valueForKey:@"userStyle"];
        self.whoProfile = [defaults valueForKey:@"whoProfile"];
        self.lat = [defaults valueForKey:@"lat"];
        self.lon = [defaults valueForKey:@"lon"];
        self.city = [defaults valueForKey:@"city"];
        self.state = [defaults valueForKey:@"state"];
        self.country = [defaults valueForKey:@"country"];
        self.usingApp = [defaults valueForKey:@"usingApp"];
        self.tabIndex = [defaults valueForKey:@"tabIndex"];
        self.bakeToAdd = [defaults valueForKey:@"bakeToAdd"];
        self.cameraBack =[ defaults valueForKey:@"cameraBack"];
        self.tocamera =[ defaults valueForKey:@"tocamera"];
        
        NSString *path = [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) lastObject];
        NSString    *filePath = [path stringByAppendingPathComponent:@"myphoto.jpg"];
        self.userPhoto = [UIImage imageWithContentsOfFile:filePath];
    }
}

- (void)SaveParam
{
    NSUserDefaults  *defaults = [NSUserDefaults standardUserDefaults];
    
    [defaults setValue:[NSNumber numberWithBool:self.bLogin] forKey:@"login"];
    [defaults setValue:[NSNumber numberWithBool:self.bFBLogin] forKey:@"fblogin"];
    
    [defaults setValue:self.pushKey    forKey:@"pushkey"];
    [defaults setValue:self.userid     forKey:@"userid"];
    [defaults setValue:self.fcmToken   forKey:@"fcmtoken"];
    [defaults setValue:self.token      forKey:@"token"];
    [defaults setValue:self.mobile     forKey:@"mobile"];
    [defaults setValue:self.username   forKey:@"username"];
    [defaults setValue:self.fullname   forKey:@"fullname"];
    [defaults setValue:self.email      forKey:@"email"];
    [defaults setValue:self.password   forKey:@"password"];
    [defaults setValue:self.avatar   forKey:@"avatar"];
    [defaults setValue:self.vcode      forKey:@"vcode"];
    [defaults setValue:self.strRegion  forKey:@"region"];
    [defaults setValue:self.postCode   forKey:@"postcode"];
    [defaults setValue:self.strPhoto   forKey:@"photo"];
    [defaults setValue:self.strFirstName    forKey:@"firstname"];
    [defaults setValue:self.strLastName     forKey:@"lastname"];
    [defaults setValue:self.strOrganization forKey:@"organization"];
    [defaults setValue:self.strGender   forKey:@"gender"];
    [defaults setValue:self.strAddress  forKey:@"address"];
    [defaults setValue:self.strJob      forKey:@"job"];
    [defaults setValue:self.strAbout    forKey:@"about"];
    [defaults setValue:self.strBirthday forKey:@"birth"];
    
    
    [defaults setValue:self.fbEmail forKey:@"fbEmail"];
    [defaults setValue:self.fbid forKey:@"fbid"];
    [defaults setValue:self.fbfname forKey:@"fbfname"];
    [defaults setValue:self.fblname forKey:@"fblname"];
    [defaults setValue:self.fbname forKey:@"fbname"];
    [defaults setValue:self.szNoti forKey:@"szNoti"];
    [defaults setValue:self.szFri forKey:@"szFri"];
    [defaults setValue:self.fbToken forKey:@"fbToken"];
    [defaults setValue:self.userStyle forKey:@"userStyle"];
    [defaults setValue:self.whoProfile forKey:@"whoProfile"];
    [defaults setValue:self.lat forKey:@"lat"];
    [defaults setValue:self.lon forKey:@"lon"];
    [defaults setValue:self.city forKey:@"city"];
    [defaults setValue:self.state forKey:@"state"];
    [defaults setValue:self.country forKey:@"country"];
    [defaults setValue:self.usingApp forKey:@"usingApp"];
    [defaults setValue:self.tabIndex forKey:@"tabIndex"];
    [defaults setValue:self.bakeToAdd forKey:@"bakeToAdd"];
    [defaults setValue:self.cameraBack forKey:@"cameraBack"];
    [defaults setValue:self.tocamera forKey:@"tocamera"];
    
    
//    [defaults setValue:self.arrStyle forKey:@"arrStyle"];
    

    
    [defaults synchronize];
    
    NSString *path = [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) lastObject];
    NSString    *filePath = [path stringByAppendingPathComponent:@"myphoto.jpg"];
    
    NSData*     pngImgData = UIImageJPEGRepresentation(self.userPhoto, 1.0f);
    [pngImgData writeToFile:filePath atomically:YES];
}

+ (NSString*)getCurMonthDate
{
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setDateFormat:@"MMMM dd, yyyy"];
    
    NSString*   curDateString = [dateFormatter stringFromDate:[NSDate date]];
    
    return curDateString;
}

+ (NSString*)getMonthDate:(NSTimeInterval)timeInterval
{
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setDateFormat:@"MMMM dd, yyyy"];
    
    NSDate *date = [NSDate dateWithTimeIntervalSince1970:timeInterval];
    
    NSString*   dateString = [dateFormatter stringFromDate:date];
    
    return dateString;
}

+ (NSString*)getDiffDaysFromDate:(NSDate*)date
{
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setDateFormat:@"MMMM dd, yyyy"];
    NSString*   dateString = [dateFormatter stringFromDate:date];

    NSDate *curDate = [NSDate date];
    
    NSTimeInterval diffTime = [curDate timeIntervalSinceDate:date];
    
    int days = (int)diffTime/(24*3600);
    if ( days == 0 )
    {
        int nHours = (int)diffTime/3600;
        if ( nHours > 0 )
        {
            if ( nHours == 1 )
                return @"1 hour ago";
            else
                return [NSString stringWithFormat:@"%d hours ago", nHours];
        }
        else
        {
            int nMins = (int)diffTime/60;
            if ( nMins > 1 )
            {
                return [NSString stringWithFormat:@"%d mins ago", nMins];
            }
            else
                return @"1 min ago";
        }
    }
    else if ( days == 1 )
    {
        return @"1 day ago";
    }
    else if ( days <= 30 )
    {
        return [NSString stringWithFormat:@"%d days ago", days];
    }
    else if ( days > 30 )
        return dateString;

    return dateString;
}



@end

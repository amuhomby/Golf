//
//  Global.h
//  Periscope
//
//  Created by MacAdmin on 4/2/16.
//  Copyright © 2016 MacAdmin. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "sqlite.h"

#define FROM_FRIEND @"FRIEND"
#define CONNECT_ERROR @"Connection error!"

#define mainGreenColor [UIColor colorWithRed:(149.0/255) green:(181.0/255) blue:(202.0/255) alpha:1.0]
#define mainGrayColor [UIColor colorWithRed:(143.0/255) green:(145.0/255) blue:(146.0/255) alpha:1.0]

#define mainGoldColor [UIColor colorWithRed:(208.0/255) green:(163.0/255) blue:(104.0/255) alpha:1.0]
#define mainDarkColor [UIColor colorWithRed:(25.0/255) green:(25.0/255) blue:(33.0/255) alpha:1.0]
#define mainTransColor [UIColor colorWithRed:(25.0/255) green:(25.0/255) blue:(33.0/255) alpha:0.0]
#define mainTripBackColor [UIColor colorWithRed:(45.0/255) green:(47.0/255) blue:(60.0/255) alpha:0.0]
#define mainProfileBackColor [UIColor colorWithRed:(55.0/255) green:(57.0/255) blue:(50.0/255) alpha:1.0]
#define GrayButtonColor [UIColor colorWithRed:(63.0/255) green:(64.0/255) blue:(69.0/255) alpha:1.0]


#define PHOTO_RATIO 1.25

#define USERDEFAULT [NSUserDefaults standardUserDefaults]
#define APPDELEGATE [AppDelegate sharedAppDelegate]

@interface Global : NSObject
{

}

@property (nonatomic, readwrite) BOOL bLogin;
@property (nonatomic, readwrite) BOOL bFBLogin;
@property (nonatomic, retain) NSString *fcmToken;

@property (nonatomic, retain) NSString *fbEmail;
@property (nonatomic, retain) NSString *fbid;
@property (nonatomic, retain) NSString *fbfname;
@property (nonatomic, retain) NSString *fblname;
@property (nonatomic, retain) NSString *fbname;
@property (nonatomic, retain) NSString *szNoti;
@property (nonatomic, retain) NSString *szFri;
@property (nonatomic, retain) NSString *fbToken;
@property (nonatomic, retain) NSString *userStyle;
@property (nonatomic, retain) NSString *avatar;
@property (nonatomic, retain) NSString *whoProfile;
@property (nonatomic, retain) NSString *lat;
@property (nonatomic, retain) NSString *lon;
@property (nonatomic, retain) NSString *city;
@property (nonatomic, retain) NSString *state;
@property (nonatomic, retain) NSString *country;
@property (nonatomic, retain) NSString *usingApp;

@property (nonatomic, retain) NSString *pushKey;
@property (nonatomic, retain) NSString *userid;
@property (nonatomic, retain) NSString *token;
@property (nonatomic, retain) NSString *mobile;
@property (nonatomic, retain) NSString *username;
@property (nonatomic, retain) NSString *fullname;
@property (nonatomic, retain) NSString *email;
@property (nonatomic, retain) NSString *password;
@property (nonatomic, retain) NSString *vcode;
@property (nonatomic, retain) NSString *postCode;
@property (nonatomic, retain) NSString *strGender;
@property (nonatomic, retain) NSString *strJob;
@property (nonatomic, retain) NSString *strAddress;
@property (nonatomic, retain) NSString *strAbout;
@property (nonatomic, retain) NSString *strBirthday;
@property (nonatomic, retain) NSString *strRegion;
@property (nonatomic, retain) NSString *strPhoto;
@property (nonatomic, retain) NSString *strFirstName;
@property (nonatomic, retain) NSString *strLastName;
@property (nonatomic, retain) NSString *strOrganization;

@property (nonatomic, retain) UIImage *userPhoto;
@property (nonatomic, retain) NSString *tabIndex;
@property (nonatomic, retain) NSString *bakeToAdd;
@property (nonatomic, retain) NSMutableArray * arrStyle;
@property (nonatomic, retain) NSString *cameraBack;
@property (nonatomic, retain) NSString *tocamera;



+ (Global *)sharedGlobal;

- (void)SaveParam;

- (void) initParam;

+ (NSString*)getDiffDaysFromDate:(NSDate*)date;


@end

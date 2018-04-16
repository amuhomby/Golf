
#import <Foundation/Foundation.h>

#import "ASIProgressDelegate.h"

//#define     SERVER_TEST_MODE

#ifdef SERVER_TEST_MODE   // test server

#define     SERVER_URL                @"http://192.168.1.91/api"
#define     PHOTO_URL                 @"http://192.168.1.91/img/posts/"

#else   // global server

#define     SERVER_URL                @"http://app.dressd.us/api"
#define     PHOTO_URL                 @"http://app.dressd.us/img/posts/"


#endif  //----------------------------------------------------//

#define FB_LOGO @"http://app.dressd.us/img/dress_logo6.png"

#define FB_APP_LINK @"http://app.dressd.us/dresslink"

#define     STR_RESULT_KEY_CODE             @"code"

#define     STR_COMM_RESULT_OK              @"1"
#define     STR_COMM_RESULT_PASS_PERIOD     @"0"
#define     STR_COMM_RESULT_NO_PARAM        @"100"
#define     STR_COMM_RESULT_NO_VERIFY       @"202"
#define     STR_COMM_RESULT_SERVER_ERROR    @"403"
#define     STR_COMM_RESULT_EMAIL_ERROR     @"413"
#define     STR_COMM_RESULT_NOPERMIT        @"304"
#define     STR_COMM_RESULT_NOUSER          @"300"
#define     STR_COMM_RESULT_FAILPASSWORD    @"400"
#define     STR_COMM_RESULT_INVALIDANSWER   @"443"
#define     STR_COMM_RESULT_NO_CHAT_TIME    @"208"
#define     STR_COMM_RESULT_IC_NO_EXIST     @"423"
#define     STR_COMM_RESULT_COMPANY_NO_EXIST @"433"

#define     STR_RESKEY_RESULT               @"result"

#define     STR_RESKEY_CONTENT              @"content"

#define     BANNER_SLIDE_TIME_GAP           5.0f

typedef enum {
    kCommResultOk,
    kCommResultPassPeriod,
    kCommResultFailNetwork,
    kCommResultNoParam,
    kCommResultServerError,
    kCommResultNoPermit,
    kCommResultNoUser,
    kCommResultNoVerifyUser,
    kCommResultFailPassword,
    kCommResultEmailError,
    kCommResultNotLogin,
    kCommResultInvalidAnswer,
    kCommResultNoChatTime,
    kCommResultICNoExist,
    kCommResultCompanyNoExist,
    kCommResultUnknownError
} CommResult;

#define MOREVIEWCNT 15

@interface UtilComm : NSObject

+ (NSDictionary *)requestCommand:(NSString *)strCmd withParams:(NSDictionary *)dicParam withMethod:(NSString*)strMethod;

+ (CommResult)analizeResultCode:(NSDictionary *)result;

+ (NSDictionary*)loginUser:(NSDictionary *)params;

+ (NSDictionary*)saveStyle:(NSDictionary *)params;

+ (NSDictionary*)getStyle:(NSDictionary *)params;

+ (NSDictionary*)invitetofriends:(NSDictionary *)params;

+ (NSDictionary*)getallactivepost:(NSDictionary *)params;

+ (NSDictionary*)getallactivepostwithstyle:(NSDictionary *)params;

+ (NSDictionary*)getpostdetail:(NSDictionary *)params;

+ (NSDictionary*)addlike:(NSDictionary *)params;

+ (NSDictionary*)commentpost:(NSDictionary *)params;

+ (NSDictionary*)getpostbyuser:(NSDictionary *)params;

+ (NSDictionary*)savepost:(NSDictionary *)params;

+ (NSDictionary*)deletepost:(NSDictionary *)params;

+ (NSDictionary*)updatepost:(NSDictionary *)params;

+ (NSDictionary*)friendlist:(NSDictionary *)params;

+ (NSDictionary*)searchusers:(NSDictionary *)params;

+ (NSDictionary*) addPost:(NSString*)strPhotoFile :(NSData*)photo :(NSString*)strPhotoFile2 :(NSData*)photo2 :(NSString*)strPhotoFile3 :(NSData*)photo3 :(NSString*)strPhotoFile4 :(NSData*)photo4 :(NSDictionary *)params;

+ (NSDictionary*)getuserstyle:(NSDictionary *)params;

+ (NSDictionary*)getpostsbyuserstyle:(NSDictionary *)params;

+ (NSDictionary*)getnotifications:(NSDictionary *)params;

+ (NSDictionary*)accepttofriend:(NSDictionary *)params;

+ (NSDictionary*)deletefriend:(NSDictionary *)params;

+ (NSDictionary*)setNotificationSettings:(NSDictionary *)params;

+ (NSDictionary*)getNotificationSettings:(NSDictionary *)params;

+ (NSDictionary*)setPrivacy:(NSDictionary *)params;

+ (NSDictionary*)getPrivacy:(NSDictionary *)params;

+ (NSDictionary*)deleteuserstyle:(NSDictionary *)params;

+ (NSDictionary*)adduserstyle:(NSDictionary *)params;

+ (NSDictionary*)inviteuserList:(NSDictionary *)params;

+ (NSDictionary*)deletecomment:(NSDictionary *)params;

+ (NSDictionary*)likelist:(NSDictionary *)params;

+ (NSDictionary*)addbio:(NSDictionary *)params;

+ (NSDictionary*)getbio:(NSDictionary *)params;

+ (NSDictionary*)mutefriend:(NSDictionary *)params;

+ (NSDictionary*)friendstate:(NSDictionary *)params;

+ (NSDictionary*)searchbrand:(NSDictionary *)params;

+ (NSDictionary*)getpostwithbrand:(NSDictionary *)params;

+ (NSDictionary*)report:(NSDictionary *)params;

+ (NSDictionary*)block:(NSDictionary *)params;

+ (NSDictionary*)unblock:(NSDictionary *)params;

+ (NSDictionary*)getalluserwithfb:(NSDictionary *)params;

+ (NSDictionary*) signup:(NSString*)strPhotoFile :(NSData*)photo :(NSDictionary *)params;

+ (NSDictionary*)signin:(NSDictionary *)params;

+ (NSDictionary*)sendcode:(NSDictionary *)params;

+ (NSDictionary*)changepassword:(NSDictionary *)params;

+ (NSDictionary*) avatarupdate:(NSString*)strPhotoFile :(NSData*)photo :(NSDictionary *)params;

+ (NSDictionary*)getshopstyle:(NSDictionary *)params;


+ (NSDictionary*) photopreview:(NSString*)strPhotoFile :(NSData*)photo :(NSDictionary *)params;

@end

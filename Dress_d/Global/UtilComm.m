
#import "UtilComm.h"
#import "AppDelegate.h"
#import "ASIFormDataRequest.h"
#import "NSDictionary+JSonString.h"
#import "JSON.h"

@implementation UtilComm

+ (NSData *)sendUrlDataToServer:(NSString*)strCmd :(NSString*)postString
{
    NSString    *requestURL = SERVER_URL;
    requestURL = [NSString stringWithFormat:@"%@/%@%@", requestURL, strCmd, postString];
    
    NSData *strData = [NSData dataWithContentsOfURL:[NSURL URLWithString:requestURL]];
    
    return strData;
}

+ (NSData *)sendPostDataToServer:(NSString*)strCmd :(NSString*)postString :(NSString*)strMethod
{
    NSString    *requestURL = SERVER_URL;
    requestURL = [NSString stringWithFormat:@"%@/%@", requestURL, strCmd];
    NSData      *postData = [postString dataUsingEncoding:NSUTF8StringEncoding];
    NSString    *postLength = [NSString stringWithFormat:@"%d", (int)[postData length]];
    
    
    NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:[NSURL URLWithString:requestURL] cachePolicy:NSURLRequestUseProtocolCachePolicy timeoutInterval:5.0f];
    
    [request setHTTPMethod:strMethod];
    [request setValue:@"application/x-www-form-urlencoded" forHTTPHeaderField:@"Content-Type"];
    [request setHTTPBody:postData];
    [request setValue:postLength forHTTPHeaderField:@"Content-Length"];
    
    
#ifdef SERVER_TEST_MODE
    [request setTimeoutInterval:5.0f];
#else
    [request setTimeoutInterval:15.0f];
#endif
    
    NSError             *error;
    NSHTTPURLResponse   *response;
    NSData              *urlData = [NSURLConnection sendSynchronousRequest:request returningResponse:&response error:&error];
    
    return urlData;
}

+ (NSData *)sendJsonDataToServer:(NSString*)strCmd :(NSDictionary*)postDic :(NSString*)strMethod
{
    NSString    *requestURL = SERVER_URL;
    requestURL = [NSString stringWithFormat:@"%@/%@", requestURL, strCmd];
    
    NSData * postData = [NSJSONSerialization dataWithJSONObject:postDic options:0 error:nil];
    //NSString    *postLength = [NSString stringWithFormat:@"%d", (int)[postData length]];
    
    
    NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:[NSURL URLWithString:requestURL] cachePolicy:NSURLRequestUseProtocolCachePolicy timeoutInterval:5.0f];
    
    [request setHTTPMethod:strMethod];
    [request setValue:@"application/json" forHTTPHeaderField:@"Content-Type"];
    [request setHTTPBody:postData];
//    [request setValue:postLength forHTTPHeaderField:@"Content-Length"];
    
#ifdef SERVER_TEST_MODE
    [request setTimeoutInterval:5.0f];
#else
    [request setTimeoutInterval:15.0f];
#endif
    
    NSError             *error;
    NSHTTPURLResponse   *response;
    NSData              *urlData = [NSURLConnection sendSynchronousRequest:request returningResponse:&response error:&error];
    
    return urlData;
}

+ (NSDictionary*)requestCommand:(NSString*)strCmd withParams:(NSDictionary*)dicParam withMethod:(NSString*)strMethod
{
    NSString *postString = @"";
    
    NSString *token = @"";
    
    for( NSString* key in dicParam )
    {
        NSString    *value;
        value = (NSString*)[dicParam objectForKey:key];
        if ( [key isEqualToString:@"_token"] )
        {
            token = [NSString stringWithFormat:@"%@", value];
            continue;
        }

        if ( [postString isEqualToString:@""] )
            postString      = [postString stringByAppendingFormat:@"%@=%@", key, value];
        else
            postString      = [postString stringByAppendingFormat:@"&%@=%@", key, value];
    }
    
    if ( token.length > 0 )
    {
        postString = [NSString stringWithFormat:@"?_token=%@&%@", token, postString];
    }
    
    NSData* urlData = nil;
    if ( [strMethod isEqualToString:@"POST"] )
        urlData = [UtilComm sendJsonDataToServer:strCmd :dicParam :strMethod];
    else if ( [strMethod isEqualToString:@"GET"] )
        urlData = [UtilComm sendUrlDataToServer:strCmd :postString];
    
    if( urlData == nil)
        return nil;
    
    NSString    *strResult = [[NSString alloc] initWithData:urlData encoding:NSUTF8StringEncoding];
    strResult = [strResult stringByReplacingOccurrencesOfString:@"\n" withString:@""];
    strResult = [strResult stringByReplacingOccurrencesOfString:@"\r" withString:@""];
    strResult = [strResult stringByReplacingOccurrencesOfString:@"\t" withString:@""];
    
    NSDictionary *jsonData = [strResult JSONValue];
    
    return jsonData;
}


+ (CommResult)analizeResultCode:(NSDictionary*)result
{
    if( result == nil )
        return kCommResultFailNetwork;
    
    int nCode = [[result objectForKey:STR_RESULT_KEY_CODE] intValue];    
    NSString*   retCode = [NSString stringWithFormat:@"%d", nCode];
    
    if( retCode == nil )
        return kCommResultUnknownError;
    
    if( [retCode isEqualToString:STR_COMM_RESULT_OK] )
        return kCommResultOk;

    if( [retCode isEqualToString:STR_COMM_RESULT_NO_PARAM] )
        return kCommResultNoParam;
    else if( [retCode isEqualToString:STR_COMM_RESULT_NOPERMIT] )
        return kCommResultNoPermit;
    else if( [retCode isEqualToString:STR_COMM_RESULT_SERVER_ERROR] )
        return kCommResultServerError;
    else if( [retCode isEqualToString:STR_COMM_RESULT_NOUSER] )
        return kCommResultNoUser;
    else if( [retCode isEqualToString:STR_COMM_RESULT_NO_VERIFY] )
        return kCommResultNoVerifyUser;
    else if( [retCode isEqualToString:STR_COMM_RESULT_FAILPASSWORD] )
        return kCommResultFailPassword;
    else if( [retCode isEqualToString:STR_COMM_RESULT_EMAIL_ERROR] )
        return kCommResultEmailError;
    else if( [retCode isEqualToString:STR_COMM_RESULT_PASS_PERIOD] )
        return kCommResultPassPeriod;
    else if( [retCode isEqualToString:STR_COMM_RESULT_INVALIDANSWER] )
        return kCommResultInvalidAnswer;
    else if( [retCode isEqualToString:STR_COMM_RESULT_NO_CHAT_TIME] )
        return kCommResultNoChatTime;
    else if( [retCode isEqualToString:STR_COMM_RESULT_IC_NO_EXIST] )
        return kCommResultICNoExist;
    else if( [retCode isEqualToString:STR_COMM_RESULT_COMPANY_NO_EXIST] )
        return kCommResultCompanyNoExist;

    return kCommResultUnknownError;
}


+ (NSDictionary*)loginUser:(NSDictionary *)params
{
    NSString *strCmd = @"authorization";
    
    NSData* urlData = nil;
    urlData = [UtilComm sendJsonDataToServer:strCmd :params :@"POST"];
    
    if( urlData == nil )
        return nil;
    
    NSString    *strResult = [[NSString alloc] initWithData:urlData encoding:NSUTF8StringEncoding];
    strResult = [strResult stringByReplacingOccurrencesOfString:@"\n" withString:@""];
    strResult = [strResult stringByReplacingOccurrencesOfString:@"\r" withString:@""];
    strResult = [strResult stringByReplacingOccurrencesOfString:@"\t" withString:@""];
    
    NSDictionary *jsonData = [strResult JSONValue];
    
    return jsonData;

}


+ (NSDictionary*)saveStyle:(NSDictionary *)params{

    NSDictionary*   result = [UtilComm requestCommand:@"setuserstyles" withParams:params withMethod:@"GET"];
    
    return result;

}

+ (NSDictionary*)getStyle:(NSDictionary *)params{
    NSDictionary*   result = [UtilComm requestCommand:@"stylelist" withParams:params withMethod:@"GET"];
    
    return result;
  
}

+ (NSDictionary*)invitetofriends:(NSDictionary *)params{

    NSDictionary*   result = [UtilComm requestCommand:@"invitetofriend" withParams:params withMethod:@"GET"];
    
    return result;

}

+ (NSDictionary*)getallactivepost:(NSDictionary *)params{
    
    NSDictionary*   result = [UtilComm requestCommand:@"getallactivepost" withParams:params withMethod:@"GET"];
    
    return result;
}

+ (NSDictionary*)getallactivepostwithstyle:(NSDictionary *)params{
    
    NSDictionary*   result = [UtilComm requestCommand:@"getallactivepostwithstyle" withParams:params withMethod:@"GET"];
    
    return result;
}

+ (NSDictionary*)getpostdetail:(NSDictionary *)params{
    NSDictionary*   result = [UtilComm requestCommand:@"getpostdetail" withParams:params withMethod:@"GET"];
    
    return result;
   
}

+ (NSDictionary*)addlike:(NSDictionary *)params{
    NSDictionary*   result = [UtilComm requestCommand:@"addlike" withParams:params withMethod:@"GET"];
    
    return result;
}


+ (NSDictionary*)commentpost:(NSDictionary *)params{
   
    NSString *strCmd = @"commentpost";
    
    NSData* urlData = nil;
    urlData = [UtilComm sendJsonDataToServer:strCmd :params :@"POST"];
    
    if( urlData == nil )
        return nil;
    
    NSString    *strResult = [[NSString alloc] initWithData:urlData encoding:NSUTF8StringEncoding];
    strResult = [strResult stringByReplacingOccurrencesOfString:@"\n" withString:@""];
    strResult = [strResult stringByReplacingOccurrencesOfString:@"\r" withString:@""];
    strResult = [strResult stringByReplacingOccurrencesOfString:@"\t" withString:@""];
    
    NSDictionary *jsonData = [strResult JSONValue];
    
    return jsonData;

}

+ (NSDictionary*)getpostbyuser:(NSDictionary *)params{
    NSDictionary*   result = [UtilComm requestCommand:@"getpostbyuser" withParams:params withMethod:@"GET"];
    
    return result;
}

+ (NSDictionary*)savepost:(NSDictionary *)params{
    NSDictionary*   result = [UtilComm requestCommand:@"savepost" withParams:params withMethod:@"GET"];
    
    return result;
 }


+ (NSDictionary*)deletepost:(NSDictionary *)params{
    NSDictionary*   result = [UtilComm requestCommand:@"deletepost" withParams:params withMethod:@"GET"];
    
    return result;
}

+ (NSDictionary*)updatepost:(NSDictionary *)params{
   
    NSString *strCmd = @"updatepost";
    
    NSData* urlData = nil;
    urlData = [UtilComm sendJsonDataToServer:strCmd :params :@"POST"];
    
    if( urlData == nil )
        return nil;
    
    NSString    *strResult = [[NSString alloc] initWithData:urlData encoding:NSUTF8StringEncoding];
    strResult = [strResult stringByReplacingOccurrencesOfString:@"\n" withString:@""];
    strResult = [strResult stringByReplacingOccurrencesOfString:@"\r" withString:@""];
    strResult = [strResult stringByReplacingOccurrencesOfString:@"\t" withString:@""];
    
    NSDictionary *jsonData = [strResult JSONValue];
    
    return jsonData;
}

+ (NSDictionary*)friendlist:(NSDictionary *)params{
    NSDictionary*   result = [UtilComm requestCommand:@"friendlist" withParams:params withMethod:@"GET"];
    return result;
}

+ (NSDictionary*)searchusers:(NSDictionary *)params{
    NSDictionary*   result = [UtilComm requestCommand:@"searchusers" withParams:params withMethod:@"GET"];
    
    return result;
}



+ (NSDictionary*) addPost:(NSString *) strPhotoFile :(NSData *)photo :(NSString *) strPhotoFile2 :(NSData *) photo2 :(NSString *) strPhotoFile3 :(NSData *) photo3 :(NSString *) strPhotoFile4 :(NSData *) photo4 : (NSDictionary *) params
{
    NSArray     *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString    *documentsDirectory = [paths objectAtIndex:0];
    NSString    *filePath = [documentsDirectory stringByAppendingPathComponent:strPhotoFile];
    
    [photo writeToFile:filePath atomically:YES];
    
    NSArray     *paths2 = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString    *documentsDirectory2 = [paths2 objectAtIndex:0];
    NSString    *filePath2 = [documentsDirectory2 stringByAppendingPathComponent:strPhotoFile2];
    
    [photo2 writeToFile:filePath2 atomically:YES];
    
    NSArray * paths3 = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString * documentsDirectory3 = [paths3 objectAtIndex:0];
    NSString * filePath3 = [documentsDirectory3 stringByAppendingPathComponent:strPhotoFile3];
    
    [photo3 writeToFile:filePath3 atomically:YES];

    NSArray * paths4 = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString * documentsDirectory4 = [paths4 objectAtIndex:0];
    NSString * filePath4 = [documentsDirectory4 stringByAppendingPathComponent:strPhotoFile4];
    [photo4 writeToFile:filePath4 atomically:YES];
    
    NSString * user_id = [params objectForKey:@"user_id"];
    NSString * subject = [params objectForKey:@"subject"];
    
    NSData *nsdata = [subject dataUsingEncoding:NSUTF8StringEncoding];
    NSString *base64Encoded = [nsdata base64EncodedStringWithOptions:0];
    
    NSString * strBrand = [params objectForKey:@"brand"];
    
    
    NSString * style_ids = [params objectForKey:@"style"];
    NSString * expiredhour = [params objectForKey:@"exp"];
    NSString * _token = [params objectForKey:@"_token"];
    NSString * noexpire = [params objectForKey:@"noexpire"];
    
    
    NSString *strServerUrl = SERVER_URL;
    //    strServerUrl = [NSString stringWithFormat:@"%@/user/upload?token=%@", strServerUrl, [Global sharedGlobal].token];
    strServerUrl = [NSString stringWithFormat:@"%@/addpost", strServerUrl];
    
    
    ASIFormDataRequest *request = [ASIFormDataRequest requestWithURL:[NSURL URLWithString:strServerUrl]];
    [request setFile:filePath forKey:@"photo1"];
    if(photo2 != nil){
        [request setFile:filePath2 forKey:@"photo2"];
    }
    if(photo3 != nil){
        [request setFile:filePath3 forKey:@"photo3"];
    }
    if(photo4 != nil){
        [request setFile:filePath4 forKey:@"photo4"];
    }
   
    [request setPostValue:user_id forKey:@"user_id"];
    [request setPostValue:base64Encoded forKey:@"subject"];
    [request setPostValue:strBrand forKey:@"brand"];
    [request setPostValue:style_ids forKey:@"style_ids"];
    [request setPostValue:expiredhour forKey:@"expiredhour"];
    [request setPostValue:_token forKey:@"_token"];
    [request setPostValue:noexpire forKey:@"noexpire"];
    [request setTimeOutSeconds:60];

    [request startSynchronous];
    
    NSError *error = [request error];
    
    NSMutableDictionary * resultData = [[NSMutableDictionary alloc]init];
    if( error  != nil){
        [resultData setObject:@"0" forKey:@"code"];
        return resultData;
    }
    NSString *response = [request responseString];
    NSData *urlData = [response dataUsingEncoding:NSUTF8StringEncoding];
    if( urlData == nil ){
        [resultData setObject:@"0" forKey:@"code"];
        return resultData;
    }
    
    NSError      *e = nil;
    NSDictionary *result = [NSJSONSerialization JSONObjectWithData:urlData options:NSJSONReadingMutableContainers error:&e];
    
    
    //CommResult  retCode = [UtilComm analizeResultCode:result];
    
    return result;
}

+ (NSDictionary*)getuserstyle:(NSDictionary *)params{
    NSDictionary*   result = [UtilComm requestCommand:@"getuserstyle" withParams:params withMethod:@"GET"];
    
    return result;
}

+ (NSDictionary*)getpostsbyuserstyle:(NSDictionary *)params{
    NSDictionary*   result = [UtilComm requestCommand:@"getpostsbyuserstyle" withParams:params withMethod:@"GET"];
    
    return result;

}

+ (NSDictionary*)getnotifications:(NSDictionary *)params{
    NSDictionary*   result = [UtilComm requestCommand:@"getnotifications" withParams:params withMethod:@"GET"];
    
    return result;
}

+ (NSDictionary*)accepttofriend:(NSDictionary *)params{
    
    NSString *strCmd = @"accepttofriend";
    
    NSData* urlData = nil;
    urlData = [UtilComm sendJsonDataToServer:strCmd :params :@"POST"];
    
    if( urlData == nil )
        return nil;
    
    NSString    *strResult = [[NSString alloc] initWithData:urlData encoding:NSUTF8StringEncoding];
    strResult = [strResult stringByReplacingOccurrencesOfString:@"\n" withString:@""];
    strResult = [strResult stringByReplacingOccurrencesOfString:@"\r" withString:@""];
    strResult = [strResult stringByReplacingOccurrencesOfString:@"\t" withString:@""];
    
    NSDictionary *jsonData = [strResult JSONValue];
    
    return jsonData;
    
}

+ (NSDictionary*)deletefriend:(NSDictionary *)params{
    NSDictionary*   result = [UtilComm requestCommand:@"deletefriend" withParams:params withMethod:@"GET"];
    return result;
}

+ (NSDictionary*)getPrivacy:(NSDictionary *)params
{
    NSDictionary*   result = [UtilComm requestCommand:@"getprivacy" withParams:params withMethod:@"GET"];
    
    return result;
}

+ (NSDictionary*)setPrivacy:(NSDictionary *)params
{
    NSDictionary*   result = [UtilComm requestCommand:@"setprivacy" withParams:params withMethod:@"GET"];
    
    return result;
}

+ (NSDictionary*)getNotificationSettings:(NSDictionary *)params
{
    NSDictionary*   result = [UtilComm requestCommand:@"getnotificationsetting" withParams:params withMethod:@"GET"];
    
    return result;
}

+ (NSDictionary*)setNotificationSettings:(NSDictionary *)params
{
    NSDictionary*   result = [UtilComm requestCommand:@"settingnotification" withParams:params withMethod:@"GET"];
    
    return result;
}

+ (NSDictionary*)deleteuserstyle:(NSDictionary *)params{
    NSDictionary*   result = [UtilComm requestCommand:@"deleteuserstyle" withParams:params withMethod:@"GET"];
    
    return result;
}

+ (NSDictionary*)adduserstyle:(NSDictionary *)params{
    NSDictionary*   result = [UtilComm requestCommand:@"adduserstyle" withParams:params withMethod:@"GET"];
    
    return result;
}

+(NSDictionary *)inviteuserList:(NSDictionary *)params{
    NSDictionary * result = [UtilComm requestCommand:@"inviteuserlist" withParams:params withMethod:@"GET"];
    return result;
}

+ (NSDictionary*)deletecomment:(NSDictionary *)params{
    NSDictionary * result = [UtilComm requestCommand:@"deletecomment" withParams:params withMethod:@"GET"];
    return result;
}

+ (NSDictionary*)likelist:(NSDictionary *)params{
    NSDictionary*   result = [UtilComm requestCommand:@"likelist" withParams:params withMethod:@"GET"];
    
    return result;
}

+ (NSDictionary*)addbio:(NSDictionary *)params{
    
    NSString *strCmd = @"addbio";
    
    NSData* urlData = nil;
    urlData = [UtilComm sendJsonDataToServer:strCmd :params :@"POST"];
    
    if( urlData == nil )
        return nil;
    
    NSString    *strResult = [[NSString alloc] initWithData:urlData encoding:NSUTF8StringEncoding];
    strResult = [strResult stringByReplacingOccurrencesOfString:@"\n" withString:@""];
    strResult = [strResult stringByReplacingOccurrencesOfString:@"\r" withString:@""];
    strResult = [strResult stringByReplacingOccurrencesOfString:@"\t" withString:@""];
    
    NSDictionary *jsonData = [strResult JSONValue];
    
    return jsonData;

}

+ (NSDictionary*)getbio:(NSDictionary *)params{
    NSDictionary*  result = [UtilComm requestCommand:@"getbio" withParams:params withMethod:@"GET"];
    
    return result;
}

+ (NSDictionary*)mutefriend:(NSDictionary *)params{
    NSDictionary*   result = [UtilComm requestCommand:@"mutefriend" withParams:params withMethod:@"GET"];
    
    return result;
}


+ (NSDictionary*)friendstate:(NSDictionary *)params{
    NSDictionary*   result = [UtilComm requestCommand:@"friendstate" withParams:params withMethod:@"GET"];
    
    return result;

}


+ (NSDictionary*)searchbrand:(NSDictionary *)params{
    NSDictionary*   result = [UtilComm requestCommand:@"searchbrand" withParams:params withMethod:@"GET"];
    
    return result;
}


+ (NSDictionary*)getpostwithbrand:(NSDictionary *)params{
//    NSDictionary*   result = [UtilComm requestCommand:@"getpostwithbrand" withParams:params withMethod:@"GET"];
//    
//    return result;
    NSString *strCmd = @"getpostwithbrand";
    
    NSData* urlData = nil;
    urlData = [UtilComm sendJsonDataToServer:strCmd :params :@"POST"];
    
    if( urlData == nil )
        return nil;
    
    NSString    *strResult = [[NSString alloc] initWithData:urlData encoding:NSUTF8StringEncoding];
    strResult = [strResult stringByReplacingOccurrencesOfString:@"\n" withString:@""];
    strResult = [strResult stringByReplacingOccurrencesOfString:@"\r" withString:@""];
    strResult = [strResult stringByReplacingOccurrencesOfString:@"\t" withString:@""];
    
    NSDictionary *jsonData = [strResult JSONValue];
    
    return jsonData;

}

+ (NSDictionary*)report:(NSDictionary *)params{
    NSDictionary*   result = [UtilComm requestCommand:@"report" withParams:params withMethod:@"GET"];
    
    return result;
}

+ (NSDictionary*)block:(NSDictionary *)params{
    NSDictionary*   result = [UtilComm requestCommand:@"block" withParams:params withMethod:@"GET"];
    return result;
}
+ (NSDictionary*)unblock:(NSDictionary *)params{
    NSDictionary*   result = [UtilComm requestCommand:@"unblock" withParams:params withMethod:@"GET"];
    return result;
}


+ (NSDictionary*)getalluserwithfb:(NSDictionary *)params{
    NSDictionary*   result = [UtilComm requestCommand:@"getalluserwithfb" withParams:params withMethod:@"GET"];
    
    return result;
    
}

+ (NSDictionary*) signup:(NSString*)strPhotoFile :(NSData*)photo :(NSDictionary *)params{
    NSArray     *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString    *documentsDirectory = [paths objectAtIndex:0];
    NSString    *filePath = [documentsDirectory stringByAppendingPathComponent:strPhotoFile];
    
    [photo writeToFile:filePath atomically:YES];
    
    NSString * fname = [params objectForKey:@"firstname"];
    NSString * lname = [params objectForKey:@"lastname"];
    
    NSString * email = [params objectForKey:@"email"];
    
    
    NSString * password = [params objectForKey:@"password"];
    
    
    NSString *strServerUrl = SERVER_URL;
    //    strServerUrl = [NSString stringWithFormat:@"%@/user/upload?token=%@", strServerUrl, [Global sharedGlobal].token];
    strServerUrl = [NSString stringWithFormat:@"%@/signup", strServerUrl];
    
    ASIFormDataRequest *request = [ASIFormDataRequest requestWithURL:[NSURL URLWithString:strServerUrl]];
    [request setFile:filePath forKey:@"profile"];
    [request setPostValue:fname forKey:@"firstname"];
    [request setPostValue:lname forKey:@"lastname"];
    [request setPostValue:email forKey:@"email"];
    [request setPostValue:password forKey:@"password"];
    [request setTimeOutSeconds:30];
    
    [request startSynchronous];
    
    NSError *error = [request error];
    
    NSMutableDictionary * resultData = [[NSMutableDictionary alloc]init];
    if( error  != nil){
        [resultData setObject:@"0" forKey:@"code"];
        return resultData;
    }
    NSString *response = [request responseString];
    NSData *urlData = [response dataUsingEncoding:NSUTF8StringEncoding];
    if( urlData == nil ){
        [resultData setObject:@"0" forKey:@"code"];
        return resultData;
    }
    
    NSError      *e = nil;
    NSDictionary *result = [NSJSONSerialization JSONObjectWithData:urlData options:NSJSONReadingMutableContainers error:&e];
    
    
    //CommResult  retCode = [UtilComm analizeResultCode:result];
    
    return result;

}

+ (NSDictionary*)signin:(NSDictionary *)params{
    NSDictionary*   result = [UtilComm requestCommand:@"signin?" withParams:params withMethod:@"GET"];
    return result;
}
+ (NSDictionary*)sendcode:(NSDictionary *)params{
    NSDictionary*   result = [UtilComm requestCommand:@"sendverifycode?" withParams:params withMethod:@"GET"];
    return result;
}
+ (NSDictionary*)changepassword:(NSDictionary *)params{
    NSDictionary*   result = [UtilComm requestCommand:@"changepassword?" withParams:params withMethod:@"GET"];
    return result;
}

+ (NSDictionary*) avatarupdate:(NSString*)strPhotoFile :(NSData*)photo :(NSDictionary *)params{
    NSArray     *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString    *documentsDirectory = [paths objectAtIndex:0];
    NSString    *filePath = [documentsDirectory stringByAppendingPathComponent:strPhotoFile];
    
    [photo writeToFile:filePath atomically:YES];
    
    
    NSString * user_id = [params objectForKey:@"user_id"];
    
    
    NSString * _token = [params objectForKey:@"_token"];
    
    
    NSString *strServerUrl = SERVER_URL;
    //    strServerUrl = [NSString stringWithFormat:@"%@/user/upload?token=%@", strServerUrl, [Global sharedGlobal].token];
    strServerUrl = [NSString stringWithFormat:@"%@/avatarupdate", strServerUrl];
    
    ASIFormDataRequest *request = [ASIFormDataRequest requestWithURL:[NSURL URLWithString:strServerUrl]];
    [request setFile:filePath forKey:@"profile"];
    [request setPostValue:user_id forKey:@"user_id"];
    [request setPostValue:_token forKey:@"_token"];
    [request setTimeOutSeconds:30];
    
    [request startSynchronous];
    
    NSError *error = [request error];
    
    NSMutableDictionary * resultData = [[NSMutableDictionary alloc]init];
    if( error  != nil){
        [resultData setObject:@"0" forKey:@"code"];
        return resultData;
    }
    NSString *response = [request responseString];
    NSData *urlData = [response dataUsingEncoding:NSUTF8StringEncoding];
    if( urlData == nil ){
        [resultData setObject:@"0" forKey:@"code"];
        return resultData;
    }
    
    NSError      *e = nil;
    NSDictionary *result = [NSJSONSerialization JSONObjectWithData:urlData options:NSJSONReadingMutableContainers error:&e];
    
    
    //CommResult  retCode = [UtilComm analizeResultCode:result];
    
    return result;
    
  
}

+ (NSDictionary*)getshopstyle:(NSDictionary *)params{
    NSDictionary*   result = [UtilComm requestCommand:@"getshopstyle" withParams:params withMethod:@"GET"];
    return result;
}

+ (NSDictionary*) photopreview:(NSString *)strPhotoFile :(NSData *)photo :(NSDictionary *)params{
    NSArray     *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString    *documentsDirectory = [paths objectAtIndex:0];
    NSString    *filePath = [documentsDirectory stringByAppendingPathComponent:strPhotoFile];
    
    [photo writeToFile:filePath atomically:YES];
    
    NSString * user_id = [params objectForKey:@"user_id"];
    
    NSString * _token = [params objectForKey:@"_token"];
    
    NSString *strServerUrl = SERVER_URL;
    //    strServerUrl = [NSString stringWithFormat:@"%@/user/upload?token=%@", strServerUrl, [Global sharedGlobal].token];
    strServerUrl = [NSString stringWithFormat:@"%@/photopreview", strServerUrl];
    
    ASIFormDataRequest *request = [ASIFormDataRequest requestWithURL:[NSURL URLWithString:strServerUrl]];
    [request setFile:filePath forKey:@"photo"];
    [request setPostValue:user_id forKey:@"user_id"];
    [request setPostValue:_token forKey:@"_token"];
    [request setTimeOutSeconds:30];
    
    [request startSynchronous];
    
    NSError *error = [request error];
    
    NSMutableDictionary * resultData = [[NSMutableDictionary alloc]init];
    if( error  != nil){
        [resultData setObject:@"0" forKey:@"code"];
        return resultData;
    }
    NSString *response = [request responseString];
    NSData *urlData = [response dataUsingEncoding:NSUTF8StringEncoding];
    if( urlData == nil ){
        [resultData setObject:@"0" forKey:@"code"];
        return resultData;
    }
    
    NSError      *e = nil;
    NSDictionary *result = [NSJSONSerialization JSONObjectWithData:urlData options:NSJSONReadingMutableContainers error:&e];
    
    
    //CommResult  retCode = [UtilComm analizeResultCode:result];
    
    return result;
}

@end


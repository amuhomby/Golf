

#import "UtilPDF.h"
#import "UtilEncode.h"
#import "UtilFile.h"

@implementation UtilPDF

+(NSString*) loadPDFPathFromURL:(NSString*)url
{
    if( url == nil || [url isEqualToString:@""] )
        return @"";
    
    NSRange range = [url rangeOfString:@"/" options:NSBackwardsSearch];
    
    NSString    *fileID = nil;
    
#if 0
    if( range.location < 10 )
        range.location = 0;
    else
        range.location -= 10;
#endif
    
    if( range.length != 0 )
        fileID = [url substringFromIndex:range.location+1];
    else
        fileID = url;

    NSString    *fileName = [UtilEncode stringToHexArray:fileID];
    NSString    *filePath = [UtilFile getFullPathOfFile:fileName ofType:@"pdf"];

    if( [UtilFile isFileExits:filePath] )
        return filePath;
    
    url = [url stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
    
    NSURLRequest*       urlRequest = [NSURLRequest requestWithURL:[NSURL URLWithString:url] cachePolicy:NSURLRequestUseProtocolCachePolicy timeoutInterval:10.0f];

    NSError             *error;
    NSHTTPURLResponse   *response;
    NSData              *urlData = [NSURLConnection sendSynchronousRequest:urlRequest returningResponse:&response error:&error];
    if( urlData == nil )
        return @"";
    
    [urlData writeToFile:filePath atomically:YES];
    
    return filePath;
}

//===============================================================================================//

@end


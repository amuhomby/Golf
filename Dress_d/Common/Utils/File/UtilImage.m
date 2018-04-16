
#import "UtilImage.h"
#import "UtilEncode.h"
#import "UtilFile.h"
#import "UIImage+Utils.h"

@implementation UtilImage

+ (NSString*)extractFileNameFromURL:(NSString*)imgURL
{
    if( imgURL == nil || [imgURL isEqualToString:@""] )
        return @"";
    
    NSRange     range = [imgURL rangeOfString:@"/" options:NSBackwardsSearch];
    NSString    *fileName = nil;
    
    if( range.length != 0 )
        fileName = [imgURL substringFromIndex:range.location+1];
    else
        fileName = imgURL;
    
    return fileName;
}

+(UIImage *) loadImageFromURL:(NSString *)fileURL
{
    UIImage * result;
    
    NSData * data = [NSData dataWithContentsOfURL:[NSURL URLWithString:fileURL]];
    result = [UIImage imageWithData:data];

    return result;
}

+(void) saveImage:(UIImage *)image withFileName:(NSString *)imageName ofType:(NSString *)extension inDirectory:(NSString *)directoryPath
{
    if( [[extension lowercaseString] isEqualToString:@"png"] )
    {
        [UIImagePNGRepresentation(image) writeToFile:[directoryPath stringByAppendingPathComponent:[NSString stringWithFormat:@"%@.%@", imageName, @"png"]] options:NSAtomicWrite error:nil];
    }
    else if( [[extension lowercaseString] isEqualToString:@"jpg"] || [[extension lowercaseString] isEqualToString:@"jpeg"] )
    {
        [UIImageJPEGRepresentation(image, 1.0) writeToFile:[directoryPath stringByAppendingPathComponent:[NSString stringWithFormat:@"%@.%@", imageName, @"jpg"]] options:NSAtomicWrite error:nil];
    }
}

+ (UIImage *)loadImage:(NSString *)fileName ofType:(NSString *)extension inDirectory:(NSString *)directoryPath
{
    UIImage * result = [UIImage imageWithContentsOfFile:[NSString stringWithFormat:@"%@/%@.%@", directoryPath, fileName, extension]];
    
    return result;
}

+ (NSString*)getLocalFileTitleFromURL:(NSString*)url
{
    if( url == nil || [url isEqualToString:@""] )
        return @"";
    
    NSRange     range = [url rangeOfString:@"/" options:NSBackwardsSearch];
    NSString    *fileID = nil;
    
    if( range.length != 0 )
        fileID = [url substringFromIndex:range.location+1];
    else
        fileID = url;
    
#if 0
    NSString    *fileName = [EncodeUtil stringToHexArray:fileID];
#else
    range = [fileID rangeOfString:@"." options:NSBackwardsSearch];
    
    NSString    *fileName;
    if( range.length != 0 )
        fileName = [fileID substringToIndex:range.location];
    else
        fileName = fileID;
#endif
    
    return fileName;
}

+ (NSString*)getExistLocalImageFilePathFromURL:(NSString*)url
{
    NSString*   fileTitle = [UtilImage getLocalFileTitleFromURL:url];
    if( fileTitle == nil || [fileTitle isEqualToString:@""] )
        return nil;

    NSString    *filePath = [UtilFile getFullPathOfFile:fileTitle ofType:@"jpg"];
    
    if( [UtilFile isFileExits:filePath] )
        return filePath;

    return nil;
}

+ (NSString*)loadImagePathFromURL:(NSString*)url
{
    NSString*   fileTitle = [UtilImage getLocalFileTitleFromURL:url];
    if( fileTitle == nil || [fileTitle isEqualToString:@""] )
        return @"";
    
    NSString    *folderPath = [UtilFile getDirectoryPath];
    NSString    *filePath = [UtilFile getFullPathOfFile:fileTitle ofType:@"jpg"];
    
    if( [UtilFile isFileExits:filePath] )
        return filePath;

    UIImage *image = [UtilImage loadImageFromURL:url];

    [UtilImage saveImage:image withFileName:fileTitle ofType:@"jpg" inDirectory:folderPath];
    
    return filePath;
}

+ (void)saveImage:(UIImage*)image asURLFile:(NSString*)urlPath
{
    if( urlPath == nil || [urlPath isEqualToString:@""] )
        return;
    
    NSRange     range = [urlPath rangeOfString:@"/" options:NSBackwardsSearch];
    NSString    *fileID = nil;
    
    if( range.length != 0 )
        fileID = [urlPath substringFromIndex:range.location+1];
    else
        fileID = urlPath;
    
#if 0
    NSString    *fileName = [EncodeUtil stringToHexArray:fileID];
#else
    range = [fileID rangeOfString:@"." options:NSBackwardsSearch];
    
    NSString    *fileName;
    if( range.length != 0 )
        fileName = [fileID substringToIndex:range.location];
    else
        fileName = fileID;
#endif
    
    NSString    *folderPath = [UtilFile getDirectoryPath];
    NSString    *filePath = [UtilFile getFullPathOfFile:fileName ofType:@"jpg"];
    
    if( [UtilFile isFileExits:filePath] )
        return;
    
    [UtilImage saveImage:image withFileName:fileName ofType:@"jpg" inDirectory:folderPath];
}

+ (void)downloadImageToClientFromURL:(NSString*)url
{
    [UtilImage loadImagePathFromURL:url];
}

+ (UIImage*) loadImageFromClientByURL:(NSString*)url
{
    NSString*   filePath = [UtilImage loadImagePathFromURL:url];
    UIImage*    image = [UIImage imageWithContentsOfFile:filePath];
    
    return image;
}

+ (NSData*)getRawImageDataFromImage:(UIImage*)image ofType:(NSString*)type {
        
    if( [type isEqualToString:@"png"] || [type isEqualToString:@"PNG"] ) {
        return [NSData dataWithData:UIImagePNGRepresentation(image)];
    }
    
    return [NSData dataWithData:UIImageJPEGRepresentation(image, 1.0)];
}

//===============================================================================================//

+ (UIImage*)loadThumnailImageForVideoID:(NSString*)videoID
{
    NSString    *filePath = [UtilFile getFullPathOfFile:videoID ofType:@"jpg"];
    
    if( ![UtilFile isFileExits:filePath] )
        return nil;
    
    return [UIImage imageWithContentsOfFile:filePath];
}

+ (void)saveThumnailImage:(UIImage*)image ForVideoID:(NSString*)videoID
{
    NSString    *folderPath = [UtilFile getDirectoryPath];

    [UtilImage saveImage:image withFileName:videoID ofType:@"jpg" inDirectory:folderPath];
}

@end


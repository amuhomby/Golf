//
//  UtilFile.m
//  Community
//
//  Created by BST on 13-6-5.
//  Copyright 2013年 __MyCompanyName__. All rights reserved.
//

#import "UtilFile.h"


@implementation UtilFile

+ (BOOL)isFileExits:(NSString*)filePath
{
    BOOL fileExists = [[NSFileManager defaultManager] fileExistsAtPath:filePath];
    
    return fileExists;
}

+ (NSString*)getFullPathOfResourceFile:(NSString*)fileTitle ofType:(NSString*)type
{
    return [[NSBundle mainBundle] pathForResource:fileTitle ofType:type];
}

+ (NSString*)getDirectoryPath
{
    return [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) objectAtIndex:0];
}

+ (NSString*)getFullPathOfFile:(NSString*)fileName
{
    NSString * documentsDirectoryPath = [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) objectAtIndex:0];

    return [NSString stringWithFormat:@"%@/%@", documentsDirectoryPath, fileName];
}

+ (NSString*)getFullPathOfFile:(NSString*)fileName ofType:(NSString*)type
{
    NSString * documentsDirectoryPath = [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) objectAtIndex:0];
    
    return [NSString stringWithFormat:@"%@/%@.%@", documentsDirectoryPath, fileName, type];
}

+ (NSString*)extractFileTitle:(NSString*)filePath
{
    NSRange     range = [filePath rangeOfString:@"/" options:NSBackwardsSearch];
    NSString*   fileName;
    if( range.length == 0 )
        fileName = filePath;
    else
        fileName = [filePath substringFromIndex:range.location+1];
    
    range = [fileName rangeOfString:@"." options:NSBackwardsSearch];
    if( range.length == 0 )
        return fileName;
    
    return [fileName substringToIndex:range.location];
}

+ (NSString*)extractFileName:(NSString*)filePath
{
    NSRange     range = [filePath rangeOfString:@"/" options:NSBackwardsSearch];
    if( range.length == 0 )
        return @"";

    return [filePath substringFromIndex:range.location+1];
}

+ (NSString*)extractFileExtension:(NSString*)filePath
{
    NSRange     range = [filePath rangeOfString:@"." options:NSBackwardsSearch];
    if( range.length == 0 )
        return @"";
    
    return [filePath substringFromIndex:range.location+1];
}

+ (NSString*)extractFileNameFromURL:(NSString*)url
{
    if( url == nil || [url isEqualToString:@""] )
        return @"";
    
    NSRange     range = [url rangeOfString:@"/" options:NSBackwardsSearch];
    NSString    *fileName = nil;
    
    if( range.length != 0 )
        fileName = [url substringFromIndex:range.location+1];
    else
        fileName = url;
    
    return fileName;
}

+ (NSString*)getExistLocalFilePathFromURL:(NSString*)url
{
    NSString*   fileName = [UtilFile extractFileNameFromURL:url];
    if( fileName == nil || [fileName isEqualToString:@""] )
        return nil;
    
    NSString    *filePath = [UtilFile getFullPathOfFile:fileName];
    
    if( [UtilFile isFileExits:filePath] )
        return filePath;
    
    return nil;
}

+ (NSString*) downloadFileByURL:(NSString*)url
{
    NSString*   filePath = [UtilFile getExistLocalFilePathFromURL:url];
    if ( filePath == nil )
    {
        NSData * data = [NSData dataWithContentsOfURL:[NSURL URLWithString:filePath]];
        
        NSString*   fileName = [UtilFile extractFileNameFromURL:url];
        if( fileName == nil || [fileName isEqualToString:@""] )
            return nil;
        
        filePath = [UtilFile getFullPathOfFile:fileName];
        [data writeToFile:filePath atomically:YES];
    }
    
    return filePath;
}





@end
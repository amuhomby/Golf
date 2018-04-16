
#import <Foundation/Foundation.h>


@interface UtilFile : NSObject {
    
}

+ (BOOL)isFileExits:(NSString*)filePath;

+ (NSString*)getFullPathOfResourceFile:(NSString*) fileTitle ofType:(NSString*)type;

+ (NSString*)getDirectoryPath;

+ (NSString*)getFullPathOfFile:(NSString*)fileName;

+ (NSString*)getFullPathOfFile:(NSString*)fileName ofType:(NSString*)type;

+ (NSString*)extractFileTitle:(NSString*)filePath;

+ (NSString*)extractFileName:(NSString*)filePath;

+ (NSString*)extractFileExtension:(NSString*)filePath;

+ (NSString*)getExistLocalFilePathFromURL:(NSString*)url;

+ (NSString*)extractFileNameFromURL:(NSString*)url;

+ (NSString*) downloadFileByURL:(NSString*)url;

@end

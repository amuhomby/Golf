
#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

@interface UtilImage : NSObject {
    
}

+ (NSString*)extractFileNameFromURL:(NSString*)imgURL;

+ (UIImage *)loadImageFromURL:(NSString *)fileURL;

+ (void)saveImage:(UIImage *)image withFileName:(NSString *)imageName ofType:(NSString *)extension inDirectory:(NSString *)directoryPath;

+ (UIImage *)loadImage:(NSString *)fileName ofType:(NSString *)extension inDirectory:(NSString *)directoryPath;

+ (NSString*)getExistLocalImageFilePathFromURL:(NSString*)url;
+ (NSString*)loadImagePathFromURL:(NSString*)url;

+ (void)saveImage:(UIImage*)image asURLFile:(NSString*)urlPath;

+ (void)downloadImageToClientFromURL:(NSString*)url;

+ (UIImage*)loadImageFromClientByURL:(NSString*)url;

+ (NSData*)getRawImageDataFromImage:(UIImage*)image ofType:(NSString*)type;

+ (UIImage*)loadThumnailImageForVideoID:(NSString*)videoID;

+ (void)saveThumnailImage:(UIImage*)image ForVideoID:(NSString*)videoID;

@end

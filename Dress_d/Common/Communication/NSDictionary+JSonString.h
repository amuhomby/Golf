
#import <Foundation/Foundation.h>

@interface NSDictionary (BVJSONString)

- (NSString*)bv_jsonStringWithPrettyPrint:(BOOL) prettyPrint;
- (NSString*)jsonString;

@end

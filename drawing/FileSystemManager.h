#import <Foundation/Foundation.h>


@interface FileSystemManager : NSObject
+ (NSString *)pathToDrawings;

+ (NSString *)pathToDrawingWithName:(NSString *)drawingName;

+ (NSArray<NSString *> *)existentDrawingsNames;

+ (NSData *)drawingByName:name;
@end
#import <Foundation/Foundation.h>


@interface FileSystemUtils : NSObject
+ (NSString *)pathToDrawings;

+ (NSString *)pathToDrawingWithName:(NSString *)drawingName;

+ (NSArray<NSString *> *)existentDrawingsNames;

+ (NSData *)drawingByName:name;

+ (BOOL)createDrawingsDirIfNotExists;

+ (BOOL)saveDrawingAsPNG:(NSData *)drawing withName:(NSString *)name;
@end
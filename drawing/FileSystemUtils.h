#import <Foundation/Foundation.h>

@class Drawing;


@interface FileSystemUtils : NSObject

+ (NSString *)pathToDrawings;

+ (NSString *)pathToDrawingWithName:(NSString *)drawingName;

+ (NSArray<NSString *> *)existentDrawingsNames;

+ (BOOL)createPreviewsDirIfNotExists;

+ (BOOL)createDrawingsDirIfNotExists;

+ (BOOL)saveDrawing:(Drawing *)drawing withName:(NSString *)name;

+ (Drawing *)drawingByName:(NSString *)name;

+ (BOOL)savePreview:(NSData *)preview withName:(NSString *)name;

+ (NSData *)previewByName:(NSString *)name;

@end

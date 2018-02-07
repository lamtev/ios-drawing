#import <Foundation/Foundation.h>


@interface FileSystemUtils : NSObject

+ (NSString *)pathToDrawings;

+ (NSString *)pathToDrawingWithName:(NSString *)drawingName;

+ (NSArray<NSString *> *)existentDrawingsNames;

+ (BOOL)createPreviewsDirIfNotExists;

+ (BOOL)createDrawingsDirIfNotExists;

+ (BOOL)saveDrawingLines:(NSMutableArray *)lines withName:(NSString *)name;

+ (NSMutableArray *)drawingLinesByName:(NSString *)name;

+ (BOOL)savePreview:(NSData *)preview withName:(NSString *)name;

+ (NSData *)previewByName:(NSString *)name;

@end

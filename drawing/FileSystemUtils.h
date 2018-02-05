#import <Foundation/Foundation.h>


@interface FileSystemUtils : NSObject
+ (NSString *)pathToDrawings;

+ (NSString *)pathToDrawingWithName:(NSString *)drawingName;

+ (NSArray<NSString *> *)existentDrawingsNames;

+ (BOOL)createDrawingsDirIfNotExists;

+ (BOOL)saveDrawingLines:(NSMutableArray *)lines withName:(NSString *)name;

+ (NSMutableArray *)drawingLinesByName:(NSString *)name;
@end
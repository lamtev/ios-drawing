#import "FileSystemUtils.h"

@implementation FileSystemUtils

+ (NSString *)pathToDrawings {
    static NSString *drawingsPrefix = @"/Drawings";
    NSString *documentsPath = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES)[0];
    return [documentsPath stringByAppendingPathComponent:drawingsPrefix];
}

+ (NSString *)pathToDrawingWithName:(NSString *)drawingName {
    NSString *pathToDrawings = [self pathToDrawings];
    return [pathToDrawings stringByAppendingPathComponent:drawingName];
}

+ (NSArray<NSString *> *)existentDrawingsNames {
    NSFileManager *fileManager = [NSFileManager defaultManager];
    NSString *pathToDrawings = [self pathToDrawings];
    return [fileManager contentsOfDirectoryAtPath:pathToDrawings
                                            error:nil];
}

+ (BOOL)createDrawingsDirIfNotExists {
    NSFileManager *fileManager = [NSFileManager defaultManager];
    NSString *pathToDrawings = [self pathToDrawings];
    if (![fileManager fileExistsAtPath:pathToDrawings]) {
        return [fileManager createDirectoryAtPath:pathToDrawings
                      withIntermediateDirectories:NO
                                       attributes:nil
                                            error:nil];
    }
    return NO;
}

+ (BOOL)saveDrawingLines:(NSMutableArray *)lines withName:(NSString *)name {
    NSString *pathToDrawing = [FileSystemUtils pathToDrawingWithName:name];
    return [NSKeyedArchiver archiveRootObject:lines toFile:pathToDrawing];
}

+ (NSMutableArray *)drawingLinesByName:(NSString *)name {
    NSString *pathToDrawing = [self pathToDrawingWithName:name];
    return [NSKeyedUnarchiver unarchiveObjectWithFile:pathToDrawing];
}

@end

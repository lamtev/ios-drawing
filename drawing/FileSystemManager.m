#import "FileSystemManager.h"

@implementation FileSystemManager

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

+ (NSData *)drawingByName:(id)name {
    NSString *pathToDrawing = [self pathToDrawingWithName:name];
    return [NSData dataWithContentsOfFile:pathToDrawing];
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

+ (BOOL)saveDrawingAsPNG:(NSData *)drawing withName:(NSString *)name {
    NSString *pathToDrawing = [FileSystemManager pathToDrawingWithName:name];
    return [drawing writeToFile:pathToDrawing atomically:YES];
}

@end

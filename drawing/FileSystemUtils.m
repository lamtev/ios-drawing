#import "FileSystemUtils.h"

@implementation FileSystemUtils

+ (NSString *)pathToDrawings {
    static NSString *drawingsPrefix = @"/Drawings";
    NSString *documentsPath = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES)[0];
    return [documentsPath stringByAppendingPathComponent:drawingsPrefix];
}

+ (NSString *)pathToPreviews {
    static NSString *drawingsPrefix = @"/Previews";
    NSString *documentsPath = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES)[0];
    return [documentsPath stringByAppendingPathComponent:drawingsPrefix];
}

+ (NSString *)pathToDrawingWithName:(NSString *)drawingName {
    NSString *pathToDrawings = [self pathToDrawings];
    return [pathToDrawings stringByAppendingPathComponent:drawingName];
}

+ (NSString *)pathToPreviewWithName:(NSString *)previewName {
    NSString *pathToPreviews = [self pathToPreviews];
    return [pathToPreviews stringByAppendingPathComponent:previewName];
}

+ (NSArray<NSString *> *)existentDrawingsNames {
    NSFileManager *fileManager = [NSFileManager defaultManager];
    NSString *pathToDrawings = [self pathToDrawings];
    return [fileManager contentsOfDirectoryAtPath:pathToDrawings
                                            error:nil];
}

+ (BOOL)createPreviewsDirIfNotExists {
    NSString *pathToPreviews = [self pathToPreviews];
    return [self createDirIfNotExists:pathToPreviews];
}

+ (BOOL)createDrawingsDirIfNotExists {
    NSString *pathToDrawings = [self pathToDrawings];
    return [self createDirIfNotExists:pathToDrawings];
}

+ (BOOL)saveDrawing:(Drawing *)drawing withName:(NSString *)name {
    NSString *pathToDrawing = [FileSystemUtils pathToDrawingWithName:name];
    return [NSKeyedArchiver archiveRootObject:drawing toFile:pathToDrawing];
}

+ (Drawing *)drawingByName:(NSString *)name {
    NSString *pathToDrawing = [self pathToDrawingWithName:name];
    return [NSKeyedUnarchiver unarchiveObjectWithFile:pathToDrawing];
}

+ (BOOL)savePreview:(NSData *)preview withName:(NSString *)name {
    NSString *pathToPreview = [FileSystemUtils pathToPreviewWithName:name];
    return [preview writeToFile:pathToPreview atomically:YES];
}

+ (NSData *)previewByName:(NSString *)name {
    NSString *pathToPreview = [FileSystemUtils pathToPreviewWithName:name];
    return [NSData dataWithContentsOfFile:pathToPreview];
}

+ (BOOL)createDirIfNotExists:(NSString *)pathToDir {
    NSFileManager *fileManager = [NSFileManager defaultManager];
    if (![fileManager fileExistsAtPath:pathToDir]) {
        return [fileManager createDirectoryAtPath:pathToDir
                      withIntermediateDirectories:NO
                                       attributes:nil
                                            error:nil];
    }
    return NO;
}

@end

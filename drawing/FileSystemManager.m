#import "FileSystemManager.h"

@implementation FileSystemManager
+ (NSString *)pathToDrawings {
    static NSString *drawingsPrefix = @"/Drawings";
    return [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES)[0]
            stringByAppendingPathComponent:drawingsPrefix];
}

+ (NSString *)pathToDrawingWithName:(NSString *)drawingName {
    return [self.pathToDrawings stringByAppendingPathComponent:drawingName];
}

+ (NSArray<NSString *> *)existentDrawingsNames {
    NSFileManager *fm = NSFileManager.defaultManager;
    return [fm contentsOfDirectoryAtPath:self.pathToDrawings error:nil];
}

+ (NSData *)drawingByName:(id)name {
    return [NSData dataWithContentsOfFile:[self pathToDrawingWithName:name]];
}


@end

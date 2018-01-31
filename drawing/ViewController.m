#import "ViewController.h"
#import "FileSystemManager.h"

@interface ViewController ()

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    NSString *drawingsPath = FileSystemManager.pathToDrawings;

    if (![[NSFileManager defaultManager] fileExistsAtPath:drawingsPath])
        [[NSFileManager defaultManager] createDirectoryAtPath:drawingsPath
                                  withIntermediateDirectories:NO
                                                   attributes:nil
                                                        error:nil];
}

@end

#import "ViewController.h"
#import "FileSystemUtils.h"

@interface ViewController ()

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    dispatch_queue_t queue = dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0);
    dispatch_async(queue, ^{
        [FileSystemUtils createDrawingsDirIfNotExists];
    });
    dispatch_async(queue, ^{
        [FileSystemUtils createPreviewsDirIfNotExists];
    });
}

- (UIInterfaceOrientationMask)supportedInterfaceOrientations {
    return UIInterfaceOrientationMaskPortrait;
}

@end

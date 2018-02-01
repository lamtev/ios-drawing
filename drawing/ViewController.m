#import "ViewController.h"
#import "FileSystemUtils.h"

@interface ViewController ()

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    dispatch_queue_t queue;
    queue = dispatch_queue_create("serialDispatchQueue", NULL);
    dispatch_async(queue, ^{
        [FileSystemUtils createDrawingsDirIfNotExists];
    });
}

@end

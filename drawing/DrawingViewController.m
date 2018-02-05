#import "DrawingViewController.h"
#import "NSString+JStyle.h"
#import "FileSystemUtils.h"
#import "DrawingView.h"

@interface DrawingViewController ()
@property(nonatomic) IBOutlet UINavigationItem *navigationItem;
@property(nonatomic) NSString *drawingName;
@property(nonatomic) BOOL drawingExists;
@end

@implementation DrawingViewController

- (void)configureWithDrawingName:(NSString *)name andDrawingExists:(BOOL)exists {
    self.drawingName = name;
    self.drawingExists = exists;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.drawingName = [self.drawingName isEmpty] ? @"New drawing" : self.drawingName;
    self.navigationItem.title = self.drawingName;
    if (self.drawingExists) {
        [self loadExistentDrawing];
    }
}

- (void)loadExistentDrawing {
    dispatch_queue_t queue = dispatch_queue_create("serialDispatchQueue", NULL);
    dispatch_async(queue, ^{
        NSMutableArray *lines = [FileSystemUtils drawingLinesByName:self.drawingName];
        dispatch_async(dispatch_get_main_queue(), ^{
            DrawingView *drawingView = (DrawingView *) self.view;
            drawingView.lines = lines;
        });
    });
}

- (IBAction)thicknessSliderChanged:(UISlider *)sender {
    DrawingView *drawingView = (DrawingView *) self.view;
    drawingView.thickness = [sender value];
}

- (IBAction)clearButtonPressed:(UIBarButtonItem *)sender {
    DrawingView *drawingView = (DrawingView *) self.view;
    [drawingView clear];
}

- (IBAction)saveButtonPressed:(UIBarButtonItem *)sender {
    DrawingView *drawingView = (DrawingView *) self.view;
    NSMutableArray *lines = [drawingView lines];
    dispatch_queue_t queue = dispatch_queue_create("serialDispatchQueue", NULL);
    dispatch_async(queue, ^{
        [FileSystemUtils saveDrawingLines:lines
                                 withName:self.drawingName];
    });
}

@end

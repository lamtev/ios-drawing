#import "DrawingViewController.h"
#import "NSString+JStyle.h"
#import "FileSystemUtils.h"
#import "DrawingView.h"
#import "UIColor+ByName.h"
#import "Drawing.h"

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
    BOOL orientationIsPortrait = UIDeviceOrientationIsPortrait([[UIDevice currentDevice] orientation]);
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        Drawing *drawing = [FileSystemUtils drawingByName:self.drawingName];
        if (orientationIsPortrait) {
            drawing = [drawing portraitCopy];
        } else {
            drawing = [drawing landscapeCopy];
        }
        dispatch_async(dispatch_get_main_queue(), ^{
            DrawingView *drawingView = (DrawingView *) self.view;
            drawingView.drawing = drawing;
        });
    });
}

- (IBAction)thicknessSliderChanged:(UISlider *)sender {
    DrawingView *drawingView = (DrawingView *) self.view;
    drawingView.thickness = sender.value;
}

- (IBAction)clearButtonPressed:(UIBarButtonItem *)sender {
    DrawingView *drawingView = (DrawingView *) self.view;
    [drawingView clear];
}

- (IBAction)saveButtonPressed:(UIBarButtonItem *)sender {
    DrawingView *drawingView = (DrawingView *) self.view;
    Drawing *drawing = [drawingView.drawing copy];
    dispatch_queue_t queue = dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0);
    dispatch_async(queue, ^{
        [FileSystemUtils saveDrawing:drawing
                            withName:self.drawingName];
    });
    dispatch_async(queue, ^{
        UIImage *image = [drawingView previewImage];
        dispatch_async(queue, ^{
            [FileSystemUtils savePreview:UIImagePNGRepresentation(image)
                                withName:self.drawingName];
        });
    });
}

- (IBAction)colorButtonPressed:(UIBarButtonItem *)sender {
    UIAlertController *alertController =
            [UIAlertController alertControllerWithTitle:@"Choosing color"
                                                message:nil
                                         preferredStyle:UIAlertControllerStyleActionSheet];
    NSArray *colors = @[@"Black", @"Red", @"Green", @"Blue", @"Cyan",
            @"Orange", @"Purple", @"Magenta", @"Brown", @"White"];
    for (NSString *color in colors) {
        UIAlertAction *action = [UIAlertAction actionWithTitle:color
                                                         style:UIAlertActionStyleDefault
                                                       handler:^(UIAlertAction *a) {
                                                           DrawingView *drawingView = (DrawingView *) self.view;
                                                           drawingView.color = [UIColor colorWithName:color];
                                                       }];
        [alertController addAction:action];
    }
    UIAlertAction *cancel = [UIAlertAction actionWithTitle:@"Cancel"
                                                     style:UIAlertActionStyleCancel
                                                   handler:nil];
    [alertController addAction:cancel];
    [self presentViewController:alertController
                       animated:YES
                     completion:nil];
}

- (IBAction)undoButtonPressed:(UIBarButtonItem *)sender {
    DrawingView *drawingView = (DrawingView *) self.view;
    [drawingView undo];
}

- (IBAction)redoButtonPressed:(UIBarButtonItem *)sender {
    DrawingView *drawingView = (DrawingView *) self.view;
    [drawingView redo];
}

- (void)viewWillTransitionToSize:(CGSize)size
       withTransitionCoordinator:(id <UIViewControllerTransitionCoordinator>)coordinator {
    [super viewWillTransitionToSize:size withTransitionCoordinator:coordinator];
    DrawingView *drawingView = (DrawingView *) self.view;
    [drawingView scaleToSize:size];
}

- (UIInterfaceOrientationMask)supportedInterfaceOrientations {
    return UIInterfaceOrientationMaskAll;
}

@end

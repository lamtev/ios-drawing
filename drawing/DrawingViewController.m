#import "DrawingViewController.h"
#import "NSString+JStyle.h"
#import "FileSystemUtils.h"
#import "DrawingView.h"
#import "UIColor+ByName.h"

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
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        NSMutableArray *lines = [FileSystemUtils drawingLinesByName:self.drawingName];
        dispatch_async(dispatch_get_main_queue(), ^{
            DrawingView *drawingView = (DrawingView *) self.view;
            drawingView.lines = lines;
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
    NSMutableArray *lines = [[drawingView lines] copy];
    dispatch_queue_t queue = dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0);
    dispatch_async(queue, ^{
        [FileSystemUtils saveDrawingLines:lines
                                 withName:self.drawingName];
    });
    dispatch_async(queue, ^{
        [FileSystemUtils savePreview:UIImagePNGRepresentation(drawingView.previewImage)
                            withName:self.drawingName];
    });
}

- (IBAction)colorButtonPressed:(UIBarButtonItem *)sender {
    UIAlertController *alertController =
            [UIAlertController alertControllerWithTitle:@"Choosing color"
                                                message:nil
                                         preferredStyle:UIAlertControllerStyleActionSheet];
    NSArray *colors = @[@"Black", @"Red", @"Green", @"Blue", @"Orange", @"Purple", @"White"];
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

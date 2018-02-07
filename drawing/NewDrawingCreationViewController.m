#import "NewDrawingCreationViewController.h"
#import "DrawingViewController.h"

@interface NewDrawingCreationViewController ()
@property(nonatomic) IBOutlet UITextField *drawingNameField;
@end

@implementation NewDrawingCreationViewController

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    NSString *identifier = [segue identifier];
    if ([identifier isEqualToString:@"NewDrawingCreationToDrawing"]) {
        DrawingViewController *drawingViewController = [[segue destinationViewController] childViewControllers][0];
        [drawingViewController configureWithDrawingName:self.drawingNameField.text andDrawingExists:NO];
    }
}

- (IBAction)textFieldDoneEditing:(id)sender {
    [sender resignFirstResponder];
}

- (IBAction)backgroundTap:(id)sender {
    [self.drawingNameField resignFirstResponder];
}

- (UIInterfaceOrientationMask)supportedInterfaceOrientations {
    return UIInterfaceOrientationMaskPortrait;
}

@end

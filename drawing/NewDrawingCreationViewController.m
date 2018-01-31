//
//  NewDrawingCreationViewController.m
//  drawing
//
//  Created by anton.lamtev on 30.01.18.
//  Copyright © 2018 anton.lamtev. All rights reserved.
//

#import "NewDrawingCreationViewController.h"
#import "DrawingViewController.h"

@interface NewDrawingCreationViewController ()
@property(retain, nonatomic) IBOutlet UITextField *drawingNameField;

@end

@implementation NewDrawingCreationViewController

#pragma mark - Navigation

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    NSString *identifier = [[segue identifier] retain];
    if ([identifier isEqualToString:@"NewDrawingCreationToDrawing"]) {
        DrawingViewController *drawingViewController = [[segue destinationViewController] childViewControllers][0];
        [drawingViewController configureWithDrawingName:self.drawingNameField.text andDrawingExists:NO];
    }
    [identifier release];
}

- (IBAction)textFieldDoneEditing:(id)sender {
    [sender resignFirstResponder];
}

- (IBAction)backgroundTap:(id)sender {
    [self.drawingNameField resignFirstResponder];
}

- (void)dealloc {
    [self.drawingNameField release];
    [super dealloc];
}

@end

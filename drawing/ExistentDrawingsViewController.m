//
//  ExistentDrawingsViewController.m
//  drawing
//
//  Created by anton.lamtev on 31.01.18.
//  Copyright © 2018 anton.lamtev. All rights reserved.
//

#import "ExistentDrawingsViewController.h"
#import "DrawingViewController.h"


@interface ExistentDrawingsViewController ()
@property(copy, nonatomic) NSMutableArray *photoArray;
@property(retain, nonatomic) NSString *selectedCellDrawingName;
@end

@implementation ExistentDrawingsViewController {
}
@synthesize selectedCellDrawingName;

- (void)viewDidLoad {
    [super viewDidLoad];
    NSString *documentsPath = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES)[0];
    NSString *photosPath = [documentsPath stringByAppendingPathComponent:@"/Drawings"];
    NSFileManager *fm = [NSFileManager defaultManager];
    NSArray *dirContents = [fm contentsOfDirectoryAtPath:photosPath error:nil];
    self.photoArray = [[dirContents mutableCopy] autorelease];

    UITableView *tableView = (id) [self.view viewWithTag:1];
    UIEdgeInsets contentInset = tableView.contentInset;
    contentInset.top = 20;
    [tableView setContentInset:contentInset];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return [self.photoArray count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    static NSString *identifier = @"ExistentDrawingsCell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:identifier
                                                            forIndexPath:indexPath];
    if (cell == nil) {
        cell = [[[UITableViewCell alloc]
                initWithStyle:UITableViewCellStyleDefault
              reuseIdentifier:identifier] autorelease];
    }
    cell.textLabel.text = self.photoArray[(NSUInteger) indexPath.row];
    return cell;
}

- (NSIndexPath *)tableView:(UITableView *)tableView willSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    return indexPath;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    NSString *rowValue = self.photoArray[(NSUInteger) indexPath.row];
    self.selectedCellDrawingName = rowValue;
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    UINavigationController *controller =
            [self.storyboard instantiateViewControllerWithIdentifier:@"DrawingViewNavigationController"];

    DrawingViewController *drawingViewController = controller.viewControllers[0];
    [drawingViewController configureWithDrawingName:selectedCellDrawingName
                                           andDrawingExists:YES];
    [self presentViewController:controller
                       animated:YES
                     completion:nil];
}

- (void)dealloc {
    [self.selectedCellDrawingName release];
    [super dealloc];
}
@end

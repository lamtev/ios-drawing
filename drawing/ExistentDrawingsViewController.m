#import "ExistentDrawingsViewController.h"
#import "DrawingViewController.h"
#import "FileSystemUtils.h"


@interface ExistentDrawingsViewController ()
@property(nonatomic) NSMutableArray *drawingsNames;
@property(nonatomic) NSString *selectedCellDrawingName;
@end

@implementation ExistentDrawingsViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        self.drawingsNames = [[FileSystemUtils existentDrawingsNames] mutableCopy];
    });
    UITableView *tableView = (UITableView *) self.view;
    tableView.estimatedRowHeight = 50;
    tableView.tableFooterView = [[UIView alloc] initWithFrame:CGRectZero];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.drawingsNames.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    static NSString *identifier = @"ExistentDrawingsCell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:identifier
                                                            forIndexPath:indexPath];
    if (cell == nil) {
        cell = [[UITableViewCell alloc]
                initWithStyle:UITableViewCellStyleDefault
              reuseIdentifier:identifier];
    }
    NSString *name = self.drawingsNames[(NSUInteger) indexPath.row];
    cell.textLabel.text = name;
    NSData *imageData = [FileSystemUtils previewByName:name];
    UIImage *image = [UIImage imageWithData:imageData];
    NSLog(@"cell %@", image);
    cell.imageView.image = image;
    return cell;
}

- (NSIndexPath *)tableView:(UITableView *)tableView willSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    return indexPath;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    NSString *rowValue = self.drawingsNames[(NSUInteger) indexPath.row];
    self.selectedCellDrawingName = rowValue;
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    UINavigationController *controller =
            [self.storyboard instantiateViewControllerWithIdentifier:@"DrawingViewNavigationController"];

    DrawingViewController *drawingViewController = controller.viewControllers[0];
    [drawingViewController configureWithDrawingName:self.selectedCellDrawingName
                                   andDrawingExists:YES];
    [self presentViewController:controller
                       animated:YES
                     completion:nil];
}

- (UIInterfaceOrientationMask)supportedInterfaceOrientations {
    return UIInterfaceOrientationMaskPortrait;
}

@end

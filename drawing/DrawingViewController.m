#import "DrawingViewController.h"
#import "NSString+JStyle.h"
#import "FileSystemManager.h"

@interface DrawingViewController ()
@property(nonatomic) IBOutlet UINavigationItem *navigationItem;
@property(nonatomic) IBOutlet UIImageView *drawingImage;
@end

@implementation DrawingViewController {
@private
    NSString *drawingName;
    CGPoint lastPoint;
    CGFloat red;
    CGFloat green;
    CGFloat blue;
    CGFloat thickness;
    CGFloat opacity;
    BOOL touchIsSingle;
    BOOL drawingExists;
}

- (void)configureWithDrawingName:(NSString *)name andDrawingExists:(BOOL)exists {
    drawingName = name;
    drawingExists = exists;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    red = green = blue = 0.0;
    thickness = 10.0;
    opacity = 1.0;
    drawingName = [drawingName isEmpty] ? @"New drawing" : drawingName;
    self.navigationItem.title = drawingName;
    if (drawingExists) {
        NSData *pngData = [FileSystemManager drawingByName:drawingName];
        self.drawingImage.image = [UIImage imageWithData:pngData];
    }
}

- (IBAction)thicknessSliderChanged:(UISlider *)sender {
    float value = [sender value];
    thickness = value;
}

- (IBAction)clearButtonPressed:(UIBarButtonItem *)sender {
    self.drawingImage.image = nil;
}

- (IBAction)saveButtonPressed:(UIBarButtonItem *)sender {
    UIImage *image = self.drawingImage.image;
    if (!image) {
        UIGraphicsBeginImageContextWithOptions(self.drawingImage.image.size, NO, 0.0);
        image = UIGraphicsGetImageFromCurrentImageContext();
        UIGraphicsEndImageContext();
    }
    NSString *filePath = [FileSystemManager pathToDrawingWithName:self.navigationItem.title];
    NSData *pngData = UIImagePNGRepresentation(image);
    [pngData writeToFile:filePath atomically:YES];
}

- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event {
    touchIsSingle = YES;
    UITouch *touch = [touches anyObject];
    lastPoint = [touch locationInView:self.drawingImage];
}

- (void)touchesMoved:(NSSet *)touches withEvent:(UIEvent *)event {

    touchIsSingle = NO;
    UITouch *touch = [touches anyObject];
    CGPoint destinationPoint = [touch locationInView:self.drawingImage];

    CGSize size = self.drawingImage.frame.size;
    UIGraphicsBeginImageContext(size);
    [self.drawingImage.image drawInRect:CGRectMake(0, 0, size.width, size.height)];

    CGContextRef context = UIGraphicsGetCurrentContext();
    [self setUpContext:context];
    [self strokePathToDestinationPoint:destinationPoint
                             onContext:context];
    self.drawingImage.image = UIGraphicsGetImageFromCurrentImageContext();
    self.drawingImage.alpha = opacity;
    lastPoint = destinationPoint;
    UIGraphicsEndImageContext();
}

- (void)touchesEnded:(NSSet *)touches withEvent:(UIEvent *)event {
    CGSize size = self.drawingImage.frame.size;
    if (touchIsSingle) {
        UIGraphicsBeginImageContext(size);
        [self.drawingImage.image drawInRect:CGRectMake(0, 0, size.width, size.height)];
        CGContextRef context = UIGraphicsGetCurrentContext();
        [self setUpContext:context];
        [self strokePathToDestinationPoint:lastPoint
                                 onContext:context];
        self.drawingImage.image = UIGraphicsGetImageFromCurrentImageContext();
        UIGraphicsEndImageContext();
    }
    UIGraphicsBeginImageContext(size);
    [self.drawingImage.image drawInRect:CGRectMake(0, 0, size.width, size.height)
                              blendMode:kCGBlendModeNormal
                                  alpha:opacity];
    UIGraphicsEndImageContext();
}

- (void)setUpContext:(CGContextRef)context {
    CGContextSetLineCap(context, kCGLineCapRound);
    CGContextSetLineWidth(context, thickness);
    CGContextSetRGBStrokeColor(context, red, green, blue, opacity);
    CGContextSetBlendMode(context, kCGBlendModeNormal);
}

- (void)strokePathToDestinationPoint:(CGPoint)point onContext:(CGContextRef)context {
    CGContextMoveToPoint(context, lastPoint.x, lastPoint.y);
    CGContextAddLineToPoint(context, point.x, point.y);
    CGContextStrokePath(context);
}

@end

#import "DrawingViewController.h"
#import "NSString+JStyle.h"
#import "FileSystemManager.h"

@interface DrawingViewController ()
@property(nonatomic) IBOutlet UINavigationItem *navigationItem;
@property(nonatomic) IBOutlet UIImageView *drawingImage;
@property(nonatomic) NSString *drawingName;
@property(nonatomic) CGPoint lastPoint;
@property(nonatomic) CGFloat red;
@property(nonatomic) CGFloat green;
@property(nonatomic) CGFloat blue;
@property(nonatomic) CGFloat thickness;
@property(nonatomic) CGFloat opacity;
@property(nonatomic) BOOL touchIsSingle;
@property(nonatomic) BOOL drawingExists;
@end

@implementation DrawingViewController

- (void)configureWithDrawingName:(NSString *)name andDrawingExists:(BOOL)exists {
    self.drawingName = name;
    self.drawingExists = exists;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.red = self.green = self.blue = 0.0;
    self.thickness = 10.0;
    self.opacity = 1.0;
    self.drawingName = [self.drawingName isEmpty] ? @"New drawing" : self.drawingName;
    self.navigationItem.title = self.drawingName;
    if (self.drawingExists) {
        dispatch_queue_t queue = dispatch_queue_create("serialDispatchQueue", NULL);
        dispatch_async(queue, ^{
            NSData *drawingPNG = [FileSystemManager drawingByName:self.drawingName];
            dispatch_async(dispatch_get_main_queue(), ^{
                self.drawingImage.image = [UIImage imageWithData:drawingPNG];
            });
        });
    }
}

- (IBAction)thicknessSliderChanged:(UISlider *)sender {
    float value = [sender value];
    self.thickness = value;
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
    dispatch_queue_t queue = dispatch_queue_create("serialDispatchQueue", NULL);
    dispatch_async(queue, ^{
        [FileSystemManager saveDrawingAsPNG:UIImagePNGRepresentation(image)
                                   withName:self.drawingName];
    });
}

- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event {
    self.touchIsSingle = YES;
    UITouch *touch = [touches anyObject];
    self.lastPoint = [touch locationInView:self.drawingImage];
}

- (void)touchesMoved:(NSSet *)touches withEvent:(UIEvent *)event {

    self.touchIsSingle = NO;
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
    self.drawingImage.alpha = self.opacity;
    self.lastPoint = destinationPoint;
    UIGraphicsEndImageContext();
}

- (void)touchesEnded:(NSSet *)touches withEvent:(UIEvent *)event {
    CGSize size = self.drawingImage.frame.size;
    if (self.touchIsSingle) {
        UIGraphicsBeginImageContext(size);
        [self.drawingImage.image drawInRect:CGRectMake(0, 0, size.width, size.height)];
        CGContextRef context = UIGraphicsGetCurrentContext();
        [self setUpContext:context];
        [self strokePathToDestinationPoint:self.lastPoint
                                 onContext:context];
        self.drawingImage.image = UIGraphicsGetImageFromCurrentImageContext();
        UIGraphicsEndImageContext();
    }
    UIGraphicsBeginImageContext(size);
    [self.drawingImage.image drawInRect:CGRectMake(0, 0, size.width, size.height)
                              blendMode:kCGBlendModeNormal
                                  alpha:self.opacity];
    UIGraphicsEndImageContext();
}

- (void)setUpContext:(CGContextRef)context {
    CGContextSetLineCap(context, kCGLineCapRound);
    CGContextSetLineWidth(context, self.thickness);
    CGContextSetRGBStrokeColor(context, self.red, self.green, self.blue, self.opacity);
    CGContextSetBlendMode(context, kCGBlendModeNormal);
}

- (void)strokePathToDestinationPoint:(CGPoint)point onContext:(CGContextRef)context {
    CGContextMoveToPoint(context, self.lastPoint.x, self.lastPoint.y);
    CGContextAddLineToPoint(context, point.x, point.y);
    CGContextStrokePath(context);
}

@end

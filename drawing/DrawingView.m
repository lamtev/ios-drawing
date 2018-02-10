#import "DrawingView.h"
#import "Line.h"
#import "MutableArrayStack.h"
#import "UIImage+Scale.h"
#import "Drawing.h"

@interface DrawingView ()
@property(nonatomic, assign) CGPoint lastPoint;
@property(nonatomic, assign) BOOL touchIsSingle;
@property(nonatomic) MutableArrayStack *undoStack;
@property(nonatomic) MutableArrayStack *redoStack;
@end

@implementation DrawingView

- (instancetype)initWithCoder:(NSCoder *)coder {
    self = [super initWithCoder:coder];
    if (self) {
        [self setUp];
    }
    return self;
}

- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        [self setUp];
    }
    return self;
}

- (void)setUp {
    _color = [UIColor blackColor];
    _thickness = 5.0;
    _drawing = [Drawing drawingWithSize:self.frame.size];
    _undoStack = [MutableArrayStack stack];
    _redoStack = [MutableArrayStack stack];
    self.backgroundColor = [UIColor whiteColor];
    self.opaque = NO;
}

- (void)setDrawing:(Drawing *)drawing {
    _drawing = [drawing mutableCopy];
    [self setNeedsDisplay];
}

- (void)drawRect:(CGRect)rect {
    CGContextRef context = UIGraphicsGetCurrentContext();
    [self drawToContext:context];
}

- (void)drawToContext:(struct CGContext *const)context {
    CGContextBeginPath(context);
    CGContextSetLineCap(context, kCGLineCapRound);
    for (Line *line in [[self.drawing copy] lines]) {
        CGContextSetLineWidth(context, line.thickness);
        CGContextMoveToPoint(context, line.startPoint.x, line.startPoint.y);
        CGContextAddLineToPoint(context, line.endPoint.x, line.endPoint.y);
        CGFloat red, green, blue, alpha;
        [line.color getRed:&red green:&green blue:&blue alpha:&alpha];
        CGContextSetRGBStrokeColor(context, red, green, blue, alpha);
        CGContextStrokePath(context);
    }
}

- (UIImage *)previewImage {
    CGSize oldSize = self.frame.size;
    CGSize newSize = CGSizeMake(oldSize.width / 20, oldSize.width / 15);
    UIImage *image = [[self imageFromCurrentDrawing] scaleToSize:newSize];
    return image;
}

- (UIImage *)imageFromCurrentDrawing {
    CGRect rect = self.frame;
    CGFloat scale = [UIScreen mainScreen].scale;
    UIGraphicsBeginImageContextWithOptions(rect.size, NO, scale);
    CGContextRef context = UIGraphicsGetCurrentContext();
    [self drawToContext:context];
    UIImage *image = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    return image;
}

- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(nullable UIEvent *)event {
    UITouch *touch = [touches anyObject];
    self.lastPoint = [touch locationInView:self];
    self.touchIsSingle = YES;
    [self.undoStack push:[self.drawing mutableCopy]];
    [self.redoStack removeAllObjects];
}

- (void)touchesMoved:(NSSet<UITouch *> *)touches withEvent:(nullable UIEvent *)event {
    UITouch *touch = [touches anyObject];
    CGPoint currentPoint = [touch locationInView:self];
    Line *line = [Line lineWithStartPoint:self.lastPoint
                              andEndPoint:currentPoint
                                 andColor:self.color
                             andThickness:self.thickness];
    [self.drawing.lines addObject:line];
    self.lastPoint = currentPoint;
    self.touchIsSingle = NO;
    [self setNeedsDisplay];
}

- (void)touchesEnded:(NSSet<UITouch *> *)touches withEvent:(nullable UIEvent *)event {
    if (self.touchIsSingle) {
        [self touchesMoved:touches withEvent:event];
    }
}

- (void)clear {
    [self.undoStack push:[self.drawing mutableCopy]];
    [self.drawing.lines removeAllObjects];
    [self setNeedsDisplay];
}

- (BOOL)undo {
    if ([self.undoStack isEmpty]) {
        return NO;
    }
    Drawing *drawing = [self.undoStack pop];
    [self.redoStack push:self.drawing];
    self.drawing = drawing;
    [self setNeedsDisplay];
    return YES;
}

- (BOOL)redo {
    if ([self.redoStack isEmpty]) {
        return NO;
    }
    [self.undoStack push:self.drawing];
    self.drawing = [self.redoStack pop];
    [self setNeedsDisplay];
    return YES;
}

- (void)scaleToSize:(CGSize)size {
    [self.drawing scaleToSize:size];
    [self setNeedsDisplay];
}

@end

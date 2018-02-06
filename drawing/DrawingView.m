#import "DrawingView.h"
#import "Line.h"
#import "MutableArrayStack.h"

@interface DrawingView ()
@property(nonatomic, assign) CGPoint lastPoint;
@property(nonatomic, assign) BOOL touchIsSingle;
@property(nonatomic) MutableArrayStack *undoStack;
@property(nonatomic) MutableArrayStack *redoStack;
@property (nonatomic) UIImage *previewImage;
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
    _lines = [NSMutableArray array];
    _undoStack = [[MutableArrayStack alloc] init];
    _redoStack = [[MutableArrayStack alloc] init];
    self.backgroundColor = [UIColor whiteColor];
    self.opaque = NO;
}

- (void)setLines:(NSMutableArray *)lines {
    _lines = [lines mutableCopy];
    [self setNeedsDisplay];
}

- (void)drawRect:(CGRect)rect {
    CGContextRef context = UIGraphicsGetCurrentContext();
    CGContextBeginPath(context);
    CGContextSetLineCap(context, kCGLineCapRound);
    for (Line *line in self.lines) {
        CGContextSetLineWidth(context, line.thickness);
        CGContextMoveToPoint(context, line.startPoint.x, line.startPoint.y);
        CGContextAddLineToPoint(context, line.endPoint.x, line.endPoint.y);
        CGFloat red, green, blue, alpha;
        [line.color getRed:&red green:&green blue:&blue alpha:&alpha];
        CGContextSetRGBStrokeColor(context, red, green, blue, alpha);
        CGContextStrokePath(context);
    }
    //TODO image;
}

- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(nullable UIEvent *)event {
    UITouch *touch = [touches anyObject];
    self.lastPoint = [touch locationInView:self];
    self.touchIsSingle = YES;
    [self.undoStack push:[self.lines mutableCopy]];
    [self.redoStack removeAllObjects];
}

- (void)touchesMoved:(NSSet<UITouch *> *)touches withEvent:(nullable UIEvent *)event {
    UITouch *touch = [touches anyObject];
    CGPoint currentPoint = [touch locationInView:self];
    Line *line = [Line alloc];
    line = [line initWithStartPoint:self.lastPoint
                        andEndPoint:currentPoint
                           andColor:self.color
                       andThickness:self.thickness];
    [self.lines addObject:line];
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
    [self.undoStack push:[self.lines mutableCopy]];
    [self.lines removeAllObjects];
    [self setNeedsDisplay];
}

- (BOOL)undo {
    if ([self.undoStack isEmpty]) {
        return NO;
    }
    NSMutableArray *lines = [self.undoStack pop];
    [self.redoStack push:self.lines];
    self.lines = lines;
    [self setNeedsDisplay];
    return YES;
}

- (BOOL)redo {
    if ([self.redoStack isEmpty]) {
        return NO;
    }
    [self.undoStack push:self.lines];
    self.lines = [self.redoStack pop];
    [self setNeedsDisplay];
    return YES;
}

- (void)scaleToSize:(CGSize)size {
    CGFloat coeff = size.width / [self frame].size.width;
    if (coeff != 1) {
        for (Line *line in self.lines) {
            [line scaleByCoeff:coeff];
        }
        [self setNeedsDisplay];
    }
}

@end

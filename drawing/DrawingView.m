#import "DrawingView.h"
#import "Line.h"

@interface DrawingView ()
@property(nonatomic, assign) CGPoint lastPoint;
@property(nonatomic, assign) BOOL touchIsSingle;
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
    self.backgroundColor = [UIColor whiteColor];
    self.opaque = NO;
}

- (void)setLines:(NSMutableArray *)lines {
    _lines = lines;
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
}

- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(nullable UIEvent *)event {
    UITouch *touch = [touches anyObject];
    self.lastPoint = [touch locationInView:self];
    self.touchIsSingle = YES;
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
    [self.lines removeAllObjects];
    [self setNeedsDisplay];
}

@end

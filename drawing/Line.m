#import "Line.h"

@interface Line ()
@property(assign, readwrite) CGPoint startPoint;
@property(assign, readwrite) CGPoint endPoint;
@property(readwrite) UIColor *color;
@property(assign, readwrite) CGFloat thickness;
@end

@implementation Line

+ (instancetype)lineWithStartPoint:(CGPoint)startPoint andEndPoint:(CGPoint)endPoint andColor:(UIColor *)color andThickness:(CGFloat)thickness {
    Line *line = [Line alloc];
    return [line initWithStartPoint:startPoint
                        andEndPoint:endPoint
                           andColor:color
                       andThickness:thickness];
}

- (instancetype)initWithStartPoint:(CGPoint)startPoint andEndPoint:(CGPoint)endPoint
                          andColor:(UIColor *)color andThickness:(CGFloat)thickness {
    self = [super init];
    if (self) {
        _startPoint = startPoint;
        _endPoint = endPoint;
        _color = color;
        _thickness = thickness;
    }
    return self;
}

- (void)encodeWithCoder:(NSCoder *)coder {
    [coder encodeCGPoint:self.startPoint forKey:@"startPoint"];
    [coder encodeCGPoint:self.endPoint forKey:@"endPoint"];
    [coder encodeObject:self.color forKey:@"color"];
    [coder encodeDouble:self.thickness forKey:@"thickness"];
}

- (instancetype)initWithCoder:(NSCoder *)coder {
    self = [super init];
    if (self) {
        self.startPoint = [coder decodeCGPointForKey:@"startPoint"];
        self.endPoint = [coder decodeCGPointForKey:@"endPoint"];
        self.color = [coder decodeObjectForKey:@"color"];
        self.thickness = [coder decodeDoubleForKey:@"thickness"];
    }
    return self;
}

- (id)copyWithZone:(nullable NSZone *)zone {
    return [Line lineWithStartPoint:self.startPoint
                        andEndPoint:self.endPoint
                           andColor:[self.color copy]
                       andThickness:self.thickness];
}

- (void)scaleByCoeff:(CGFloat)coeff {
    self.startPoint = CGPointMake(self.startPoint.x * coeff, self.startPoint.y / coeff);
    self.endPoint = CGPointMake(self.endPoint.x * coeff, self.endPoint.y / coeff);
}

@end

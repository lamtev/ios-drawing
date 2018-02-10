#import <UIKit/UIKit.h>

@interface Line : NSObject <NSCoding, NSCopying>

@property(assign, readonly) CGPoint startPoint;
@property(assign, readonly) CGPoint endPoint;
@property(readonly) UIColor *color;
@property(assign, readonly) CGFloat thickness;

+ (instancetype)lineWithStartPoint:(CGPoint)startPoint andEndPoint:(CGPoint)endPoint
                          andColor:(UIColor *)color andThickness:(CGFloat)thickness;

- (void)scaleByCoeff:(CGFloat)coeff;

@end

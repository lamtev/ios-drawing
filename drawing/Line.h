#import <UIKit/UIKit.h>

@interface Line : NSObject <NSCoding>

@property(assign, readonly) CGPoint startPoint;
@property(assign, readonly) CGPoint endPoint;
@property(readonly) UIColor *color;
@property(assign, readonly) CGFloat thickness;

- (instancetype)initWithStartPoint:(CGPoint)startPoint andEndPoint:(CGPoint)endPoint
                          andColor:(UIColor *)color andThickness:(CGFloat)thickness;
@end

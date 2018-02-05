#import <UIKit/UIKit.h>

@interface DrawingView : UIView

@property(nonatomic) UIColor *color;
@property(nonatomic, assign) CGFloat thickness;
@property(nonatomic) NSMutableArray *lines;

- (void)clear;

@end

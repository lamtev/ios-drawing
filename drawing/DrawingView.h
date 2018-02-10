#import <UIKit/UIKit.h>

@class Drawing;

@interface DrawingView : UIView

@property(nonatomic) UIColor *color;
@property(nonatomic, assign) CGFloat thickness;
@property(nonatomic) Drawing *drawing;

- (UIImage *)previewImage;

- (void)clear;

- (BOOL)undo;

- (BOOL)redo;

- (void)scaleToSize:(CGSize)size;

@end

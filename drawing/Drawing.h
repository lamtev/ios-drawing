#import <UIKit/UIKit.h>


@interface Drawing : NSObject <NSCoding, NSCopying, NSMutableCopying>

@property (nonatomic, readonly) NSMutableArray *lines;
@property(nonatomic, assign, readonly) CGSize size;

+ (instancetype)drawingWithSize:(CGSize)size;

- (BOOL)isInPortraitMode;

- (Drawing *)portraitCopy;

- (void)scaleToSize:(CGSize)size;

- (Drawing *)landscapeCopy;

@end

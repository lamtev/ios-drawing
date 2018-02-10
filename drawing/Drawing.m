#import "Drawing.h"
#import "Line.h"


@interface Drawing ()
@property (nonatomic) NSMutableArray *lines;
@property(nonatomic, assign) CGSize size;
@end

@implementation Drawing

+ (instancetype)drawingWithSize:(CGSize)size {
    Drawing *drawing = [Drawing alloc];
    return [drawing initWithSize:size];
}

- (instancetype)initWithSize:(CGSize)size {
    self = [super init];
    if (self) {
        _lines = [NSMutableArray arrayWithCapacity:10];
        _size = size;
    }
    return self;
}

- (BOOL)isInPortraitMode {
    return self.size.height > self.size.width;
}

- (Drawing *)portraitCopy {
    Drawing *drawing = [self mutableCopy];
    if ([drawing isInPortraitMode]) {
        return drawing;
    }
    CGSize landscapeSize = drawing.size;
    CGSize portraitSize = CGSizeMake(landscapeSize.height, landscapeSize.width);
    [drawing scaleToSize:portraitSize];
    return drawing;
}

- (Drawing *)landscapeCopy {
    Drawing *drawing = [self mutableCopy];
    if (![drawing isInPortraitMode]) {
        return drawing;
    }
    CGSize portraitSize = drawing.size;
    CGSize landscapeSize = CGSizeMake(portraitSize.height, portraitSize.width);
    [drawing scaleToSize:landscapeSize];
    return drawing;
}

- (void)scaleToSize:(CGSize)size {
    CGFloat coeff = size.width / self.size.width;
    if (coeff != 1) {
        for (Line *line in self.lines) {
            [line scaleByCoeff:coeff];
        }
        self.size = size;
    }
}

- (void)encodeWithCoder:(NSCoder *)coder {
    [coder encodeObject:self.lines forKey:@"lines"];
    [coder encodeCGSize:self.size forKey:@"size"];
}

- (instancetype)initWithCoder:(NSCoder *)coder {
    self = [super init];
    if (self) {
        self.lines = [coder decodeObjectForKey:@"lines"];
        self.size = [coder decodeCGSizeForKey:@"size"];
    }
    return self;
}

- (id)copyWithZone:(nullable NSZone *)zone {
    Drawing *drawing = [[Drawing alloc] init];
    drawing.lines = [self.lines copy];
    drawing.size = self.size;
    return drawing;
}

- (id)mutableCopyWithZone:(nullable NSZone *)zone {
    Drawing *drawing = [[Drawing alloc] init];
    drawing.lines = [self.lines mutableCopy];
    drawing.size = self.size;
    return drawing;
}

@end

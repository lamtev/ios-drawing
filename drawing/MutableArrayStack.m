#import "MutableArrayStack.h"


@interface MutableArrayStack ()
@property NSMutableArray *array;
@end

@implementation MutableArrayStack

- (instancetype)init {
    return [self initWithCapacity:10];
}

- (instancetype)initWithCapacity:(NSUInteger)capacity {
    self = [super init];
    if (self) {
        _array = [NSMutableArray arrayWithCapacity:(NSUInteger) capacity];
    }
    return self;
}

- (BOOL)push:(nonnull id)element {
    NSUInteger size = [self.array count];
    [self.array addObject:element];
    return [self.array count] != size;
}

- (id)pop {
    [self checkSize];
    id lastElement = [self.array lastObject];
    [self.array removeLastObject];
    return lastElement;
}

- (NSUInteger)count {
    return [self.array count];
}

- (BOOL)isEmpty {
    return [self count] == 0;
}

- (void)removeAllObjects {
    [self.array removeAllObjects];
}

- (id)top {
    [self checkSize];
    return [self.array lastObject];
}

- (void)checkSize {
    if ([self isEmpty]) {
        @throw [NSException exceptionWithName:@"NoSuchElementException"
                                       reason:@"Stack is empty"
                                     userInfo:nil];
    }
}

@end
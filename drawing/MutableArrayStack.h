#import <Foundation/Foundation.h>
#import "Stack.h"

/**
 * Non thread safe Stack protocol implementation
 */
@interface MutableArrayStack : NSObject <Stack>

+ (instancetype)stack;

+ (instancetype)stackWithCapacity:(NSUInteger)capacity;

@end

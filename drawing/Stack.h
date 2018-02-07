#import <Foundation/Foundation.h>

@protocol Stack

- (BOOL)push:(nonnull id)element;

- (nonnull id)pop;

- (NSUInteger)count;

- (BOOL)isEmpty;

- (void)removeAllObjects;

- (nonnull id)top;

@end

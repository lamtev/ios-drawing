#import <XCTest/XCTest.h>
#import "MutableArrayStack.h"

@interface MutableArrayStackTest : XCTestCase

@end

@implementation MutableArrayStackTest

- (void)testPushPop {
    MutableArrayStack *stack = [[MutableArrayStack alloc] init];
    XCTAssert([stack isEmpty]);
    [stack push:@"str"];
    XCTAssertEqual(1, [stack count]);
    XCTAssertEqualObjects(@"str", [stack pop]);
    @try {
        [stack pop];
    } @catch (NSException *e) {
        XCTAssertEqualObjects(@"Stack is empty", [e reason]);
    }
}

@end

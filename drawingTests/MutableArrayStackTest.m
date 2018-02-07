#import <XCTest/XCTest.h>
#import "MutableArrayStack.h"

@interface MutableArrayStackTest : XCTestCase

@end

@implementation MutableArrayStackTest

- (void)testPushPop {
    MutableArrayStack *stack = [[MutableArrayStack alloc] init];
    XCTAssert([stack isEmpty]);
    NSString *el = @"str";
    [stack push:el];
    XCTAssertEqual(1, [stack count]);
    XCTAssertEqualObjects(el, [stack top]);
    XCTAssertEqual(1, [stack count]);
    XCTAssertEqualObjects(el, [stack pop]);
    XCTAssertEqual(0, [stack count]);
    @try {
        [stack pop];
    } @catch (NSException *e) {
        XCTAssertEqualObjects(@"Stack is empty", [e reason]);
    }
}

@end

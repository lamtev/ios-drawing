#import "UIColor+ByName.h"

@implementation UIColor (ByName)

+ (UIColor *)colorWithName:(NSString *)name {
    name = [name lowercaseString];
    if ([name isEqualToString:@"black"]) {
        return [UIColor blackColor];
    } else if ([name isEqualToString:@"red"]) {
        return [UIColor redColor];
    } else if ([name isEqualToString:@"green"]) {
        return [UIColor greenColor];
    } else if ([name isEqualToString:@"blue"]) {
        return [UIColor blueColor];
    } else if ([name isEqualToString:@"orange"]) {
        return [UIColor orangeColor];
    } else if ([name isEqualToString:@"purple"]) {
        return [UIColor purpleColor];
    } else if ([name isEqualToString:@"white"]) {
        return [UIColor whiteColor];
    }
    return nil;
}

@end

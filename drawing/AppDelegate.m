#import "AppDelegate.h"

@interface AppDelegate ()

@end

@implementation AppDelegate

- (UIInterfaceOrientationMask)application:(UIApplication *)application supportedInterfaceOrientationsForWindow:(UIWindow *)window {
    UIViewController *topVC = [self topViewControllerWith:self.window.rootViewController];
    if ([topVC respondsToSelector:@selector(canRotate)]) {
        return UIInterfaceOrientationMaskAllButUpsideDown;
    }
    return UIInterfaceOrientationMaskPortrait;
}

- (UIViewController *)topViewControllerWith:(UIViewController *)rootViewController {
    if (rootViewController == nil) {
        return nil;
    }
    if ([rootViewController isKindOfClass:[UITabBarController class]]) {
        return [self topViewControllerWith:((UITabBarController *) rootViewController).selectedViewController];
    } else if ([rootViewController isKindOfClass:[UINavigationController class]]) {
        return [self topViewControllerWith:((UINavigationController *) rootViewController).visibleViewController];
    } else if (rootViewController.presentedViewController != nil) {
        return [self topViewControllerWith:[rootViewController presentedViewController]];
    }
    return rootViewController;
}

@end

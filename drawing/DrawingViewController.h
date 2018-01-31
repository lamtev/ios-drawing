//
//  DrawingViewController.h
//  drawing
//
//  Created by anton.lamtev on 30.01.18.
//  Copyright © 2018 anton.lamtev. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface DrawingViewController : UIViewController
- (void)configureWithDrawingName:(NSString *)name andDrawingExists:(BOOL)exists;
@end

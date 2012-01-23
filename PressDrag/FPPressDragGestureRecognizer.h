//
//  FPPressDragGestureRecognizer.h
//  PressDrag
//
//  Created by Erik Hollembeak on 1/21/12.
//  Copyright (c) 2012 Future Perfect Industries. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <UIKit/UIGestureRecognizerSubclass.h>

@interface FPPressDragGestureRecognizer : UIGestureRecognizer

@property (nonatomic) BOOL didLongPress;
@property (nonatomic) CGPoint anchorPoint;
@property (nonatomic) CGPoint dragPoint;

- (void)reset;
- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event;
- (void)touchesMoved:(NSSet *)touches withEvent:(UIEvent *)event;
- (void)touchesEnded:(NSSet *)touches withEvent:(UIEvent *)event;
- (void)touchesCancelled:(NSSet *)touches withEvent:(UIEvent *)event;

@end

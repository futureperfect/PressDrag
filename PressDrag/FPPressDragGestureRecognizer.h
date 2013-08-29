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

@property (nonatomic, readonly) CGPoint           anchorPoint;
@property (nonatomic, readonly) CGPoint           dragPoint;

@property (nonatomic, assign)   CGFloat           allowableMovement;      // Default as 10 pt
@property (nonatomic, assign)   CFTimeInterval    minimumPressDuration;   // Default as 0.233 seconds

@end

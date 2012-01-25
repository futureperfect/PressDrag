//
//  FPPressDragGestureRecognizer.m
//  PressDrag
//
//  Created by Erik Hollembeak on 1/21/12.
//  Copyright (c) 2012 Future Perfect Industries. All rights reserved.
//

#import "FPPressDragGestureRecognizer.h"

@interface FPPressDragGestureRecognizer ()

@property (nonatomic, retain) NSTimer *pressTimer;
@property (nonatomic) BOOL didLongPress;

@end

@implementation FPPressDragGestureRecognizer

@synthesize pressTimer = _pressTimer;
@synthesize didLongPress = _didLongPress;

@synthesize anchorPoint = _anchorPoint;
@synthesize dragPoint = _dragPoint;

@synthesize allowableMovement = _allowableMovement;
@synthesize minimumPressDuration = _minimumPressDuration;

#pragma mark -
#pragma mark Initialization


- (id)init {
    if (self = [super init]) {
        self.allowableMovement = 10;
        self.minimumPressDuration = 0.5;
    }
    return self;
}

- (id)initWithTarget:(id)target action:(SEL)action {
    if (self = [super initWithTarget:target action:action]) {
        self.allowableMovement = 10;
        self.minimumPressDuration = 0.5;
    }
    return self;
}

#pragma mark -

- (NSString *)description {
    return [NSString stringWithFormat:@"FPPressDragGestureRecognizer didLongPress=%i anchorPoint=(%d, %d) dragPoint(%d, %d)", self.didLongPress, self.anchorPoint.x, self.anchorPoint.y, self.dragPoint.x, self.dragPoint.y];
}

#pragma mark -
#pragma mark Utility methods

- (BOOL)stayedCloseEnough:(CGPoint)touchLocation to:(CGPoint)previousTouchLocation {
    CGFloat dx = touchLocation.x - previousTouchLocation.x;
    CGFloat dy = touchLocation.y - previousTouchLocation.y;
    BOOL didIt = sqrt(dx*dx + dy*dy) <= self.allowableMovement;
    return didIt;
}

- (void)longPressed:(NSTimer*)theTimer {
    if (theTimer == self.pressTimer) {
        self.state = UIGestureRecognizerStateBegan;
        self.didLongPress = YES;
        [theTimer invalidate];
        self.pressTimer = nil;
    }
}

#pragma mark -
#pragma mark UIGestureRecognizer implementation

- (void)reset {
    [super reset];
    self.anchorPoint = CGPointZero;
    self.didLongPress = NO;
    if (self.pressTimer) {
        [self.pressTimer invalidate];
    }
    self.pressTimer = nil;
}

- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event {
    [super touchesBegan:touches withEvent:event];
    if ([touches count] != 1 || [[touches anyObject] tapCount] > 1) {
        self.state = UIGestureRecognizerStateFailed;
        return;
    }
    NSTimer *timer = [NSTimer scheduledTimerWithTimeInterval:self.minimumPressDuration
                                                      target:self selector:@selector(longPressed:)
                                                    userInfo:nil repeats:NO];
    self.pressTimer = timer;
    self.anchorPoint = [[touches anyObject] locationInView:self.view];
}

- (void)touchesMoved:(NSSet *)touches withEvent:(UIEvent *)event {
    [super touchesMoved:touches withEvent:event];
    if (self.state == UIGestureRecognizerStateFailed) return;
    
    if (!self.didLongPress) {
        if ([self stayedCloseEnough:[[touches anyObject] locationInView:self.view] to:self.anchorPoint]) {
            return;
        } else {
            [self.pressTimer invalidate];
            self.pressTimer = nil;
            self.state = UIGestureRecognizerStateFailed;
        }
    } else {
        self.dragPoint = [[touches anyObject] locationInView:self.view];
        self.state = UIGestureRecognizerStateChanged;
    }
    
    return;
}

- (void)touchesEnded:(NSSet *)touches withEvent:(UIEvent *)event {
    [super touchesEnded:touches withEvent:event];
    if (self.pressTimer) {
        [self.pressTimer invalidate];
    }
    self.pressTimer = nil;
    self.state = UIGestureRecognizerStateEnded;
}

- (void)touchesCancelled:(NSSet *)touches withEvent:(UIEvent *)event {
    [super touchesEnded:touches withEvent:event];
    if (self.pressTimer) {
        [self.pressTimer invalidate];
    }
    self.pressTimer = nil;
    self.state = UIGestureRecognizerStateFailed;
}

@end

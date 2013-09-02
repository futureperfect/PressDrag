//
//  FPPressDragGestureRecognizer.m
//  PressDrag
//
//  Created by Erik Hollembeak on 1/21/12.
//  Copyright (c) 2012 Future Perfect Industries. All rights reserved.
//

#import "FPPressDragGestureRecognizer.h"

#define kDefaultAllowableMovement   (10.0f)
#define kDefaultPressDuration       (0.233f)

#pragma mark -
#pragma mark (Extension)

@interface FPPressDragGestureRecognizer ()

@property (nonatomic, assign) CGPoint   anchorPoint;    // rewrite property
@property (nonatomic, assign) CGPoint   dragPoint;      // rewrite property

@property (nonatomic, retain) NSTimer   *pressTimer;
@property (nonatomic, assign) BOOL      didLongPress;

@end

#pragma mark -
#pragma mark (Private)

@interface FPPressDragGestureRecognizer (Private)

- (void)_init;

@end

@implementation FPPressDragGestureRecognizer (Private)

- (void)_init {
    self.allowableMovement = kDefaultAllowableMovement;
    self.minimumPressDuration = kDefaultPressDuration;
}

@end

#pragma mark -

@implementation FPPressDragGestureRecognizer

#pragma mark -
#pragma mark Initialization

- (id)init {
    if (self = [super init]) {
        [self _init];
    }
    return self;
}

- (id)initWithTarget:(id)target action:(SEL)action {
    if (self = [super initWithTarget:target action:action]) {
        [self _init];
    }
    return self;
}

#pragma mark -
#pragma mark NSObject Override

- (NSString *)description {
    return [NSString stringWithFormat:@"FPPressDragGestureRecognizer didLongPress=%i anchorPoint=(%f, %f) dragPoint(%f, %f)", self.didLongPress, self.anchorPoint.x, self.anchorPoint.y, self.dragPoint.x, self.dragPoint.y];
}

#pragma mark -
#pragma mark Utility methods

- (BOOL)stayedCloseEnough:(CGPoint)touchLocation to:(CGPoint)previousTouchLocation {
    CGFloat dx = touchLocation.x - previousTouchLocation.x;
    CGFloat dy = touchLocation.y - previousTouchLocation.y;
    BOOL didIt = sqrt(dx * dx + dy * dy) <= self.allowableMovement;
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
#pragma mark UIGestureRecognizer Override

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
    
    if (UIGestureRecognizerStatePossible == self.state) {
        self.state = UIGestureRecognizerStateFailed;
    } else {
        self.state = UIGestureRecognizerStateEnded;
    }
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

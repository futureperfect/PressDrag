//
//  FPDemoView.m
//  PressDrag
//
//  Created by Erik Hollembeak on 1/23/12.
//  Copyright (c) 2012 Future Perfect Industries. All rights reserved.
//

#import "FPDemoView.h"

@implementation FPDemoView

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        self.shouldDraw = NO;
        self.circleCenter = CGPointZero;
        self.radius = 0;
    }
    return self;
}

@synthesize circleCenter, radius, shouldDraw;


// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect
{
    // Drawing code
    if (self.shouldDraw) {
        [[UIColor redColor] setFill];
        [[UIColor blueColor] setStroke];
        //draw center as dot
        UIBezierPath *anchor = [UIBezierPath bezierPath];
        [anchor addArcWithCenter:self.circleCenter
                            radius:20
                        startAngle:0.0
                          endAngle:2.0 * M_PI
                         clockwise:NO];
        [anchor fill];
        //draw radius as translucent circle
        UIBezierPath *boundary = [UIBezierPath bezierPath];
        [boundary addArcWithCenter:self.circleCenter
                        radius:self.radius
                    startAngle:0.0
                      endAngle:2.0 * M_PI
                     clockwise:NO];
        [boundary stroke];        

    }
}


@end

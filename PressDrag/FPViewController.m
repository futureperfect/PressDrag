//
//  FPViewController.m
//  PressDrag
//
//  Created by Erik Hollembeak on 1/21/12.
//  Copyright (c) 2012 Future Perfect Industries. All rights reserved.
//

#import "FPDemoView.h"
#import "FPViewController.h"
#import "FPPressDragGestureRecognizer.h"

@implementation FPViewController

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Release any cached data, images, etc that aren't in use.
}

#pragma mark - View lifecycle

- (void)viewDidLoad
{
    [super viewDidLoad];
    FPPressDragGestureRecognizer *pressDragRecognizer = [[FPPressDragGestureRecognizer alloc] initWithTarget:self action:@selector(handlePressDragGesture:)];
    [self.view addGestureRecognizer:pressDragRecognizer];
	// Do any additional setup after loading the view, typically from a nib.
}

- (void)viewDidUnload
{
    [super viewDidUnload];
    // Release any retained subviews of the main view.
    // e.g. self.myOutlet = nil;
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
}

- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
}

- (void)viewWillDisappear:(BOOL)animated
{
	[super viewWillDisappear:animated];
}

- (void)viewDidDisappear:(BOOL)animated
{
	[super viewDidDisappear:animated];
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    // Return YES for supported orientations
    return YES;
}

#pragma mark -
#pragma mark UIPressDragGestureRecognizer handler

- (IBAction)handlePressDragGesture:(UIGestureRecognizer *)sender {
    if ([sender isMemberOfClass:[FPPressDragGestureRecognizer class]]) {
        if (sender.state == UIGestureRecognizerStateBegan || sender.state == UIGestureRecognizerStateChanged) {
            CGPoint anchorPoint = ((FPPressDragGestureRecognizer *)sender).anchorPoint;
            CGPoint dragPoint = ((FPPressDragGestureRecognizer *)sender).dragPoint;
            
            ((FPDemoView *)self.view).circleCenter = anchorPoint;
            
            CGFloat dx = dragPoint.x - anchorPoint.x;
            CGFloat dy = dragPoint.y - anchorPoint.y;
            if (sender.state == UIGestureRecognizerStateBegan) {
                ((FPDemoView *)self.view).radius = 0;
            } else {
                ((FPDemoView *)self.view).radius = sqrt(dx*dx + dy*dy);
            }
            
            ((FPDemoView *)self.view).shouldDraw = YES;
        } else {
            ((FPDemoView *)self.view).shouldDraw = NO;
        }
        [self.view setNeedsDisplay];
    }
}

@end

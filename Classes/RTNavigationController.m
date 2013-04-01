//
//  RTNavigationController.m
//  RTNavigationController
//
//  Created by ricky on 13-3-30.
//  Copyright (c) 2013年 ricky. All rights reserved.
//

#import "RTNavigationController.h"

@interface RTNavigationController ()

- (void)onPan:(UIPanGestureRecognizer*)pan;
- (void)onSwipe:(UISwipeGestureRecognizer*)swipe;

@end

@implementation RTNavigationController

- (void)dealloc
{
    SAFE_RELEASE(_pan);
    SAFE_RELEASE(_swipe);
    
    SAFE_DEALLOC(super);
}

- (id)init
{
    self = [super init];
    if (self) {
        // Custom initialization
        
        _pan = [[UIPanGestureRecognizer alloc] initWithTarget:self
                                                       action:@selector(onPan:)];
        _pan.delegate = self;
        
        _swipe = [[UISwipeGestureRecognizer alloc] initWithTarget:self
                                                           action:@selector(onSwipe:)];
        _swipe.direction = UISwipeGestureRecognizerDirectionLeft | UISwipeGestureRecognizerDirectionRight;
        _swipe.delegate = self;
        
    }
    return self;
}

- (id)initWithRootViewController:(UIViewController *)controller
{
    self = [self init];
    if (self) {
        
        [self addChildViewController:controller];
        _topViewController = controller;
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    [self.view addGestureRecognizer:_pan];
    [self.view addGestureRecognizer:_swipe];
    
    [self.view addSubview:self.topViewController.view];
    self.topViewController.view.frame = self.view.bounds;
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Methods

- (void)onPan:(UIPanGestureRecognizer *)pan
{
    NSLog(@"Pan");
}

- (void)onSwipe:(UISwipeGestureRecognizer *)swipe
{
    NSLog(@"Swipe");
    
    NSUInteger count = self.childViewControllers.count;
    if (count > 1) {
        UIViewController *lastController = [self.childViewControllers objectAtIndex:count - 2];
        UINavigationController *nav = [[[UINavigationController alloc] initWithRootViewController:lastController] autorelease];
        [self addChildViewController:nav];
        
        [self transitionFromViewController:self.topViewController
                          toViewController:nav
                                  duration:0.35
                                   options:UIViewAnimationOptionTransitionFlipFromLeft
                                animations:^{
                                    
                                }
                                completion:^(BOOL finished) {
                                    
                                }];
    }
}

#pragma mark - UIGesture Delegate

- (BOOL)gestureRecognizer:(UIGestureRecognizer *)gestureRecognizer
       shouldReceiveTouch:(UITouch *)touch
{
    return YES;
}

- (BOOL)gestureRecognizer:(UIGestureRecognizer *)gestureRecognizer
shouldRecognizeSimultaneouslyWithGestureRecognizer:(UIGestureRecognizer *)otherGestureRecognizer
{
    return YES;
}

- (BOOL)gestureRecognizerShouldBegin:(UIGestureRecognizer *)gestureRecognizer
{
    if (_pan == gestureRecognizer) {
        CGPoint p = [_pan translationInView:self.view];
        return fabsf(p.x) > fabsf(p.y);
    }
    else if (_swipe == gestureRecognizer) {
        
    }
    return YES;
}

@end

//
//  RTNavigationController.m
//  RTNavigationController
//
//  Created by ricky on 13-3-30.
//  Copyright (c) 2013年 ricky. All rights reserved.
//

#import "RTNavigationController.h"

@interface RTNavigationController () <UINavigationBarDelegate>

- (void)onPan:(UIPanGestureRecognizer*)pan;
- (void)onSwipe:(UISwipeGestureRecognizer*)swipe;

- (void)swapViews;

@end

@implementation RTNavigationController

- (void)dealloc
{
    SAFE_RELEASE(_pan);
    SAFE_RELEASE(_swipe);
    
    SAFE_RELEASE(_navigationBar);
    SAFE_RELEASE(_navigationBarTmp);
    SAFE_RELEASE(_containerView);
    SAFE_RELEASE(_containerViewTmp);
    SAFE_RELEASE(_viewTmp);
    
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
        
        [self pushViewController:controller
                        animated:NO];
    }
    return self;
}

- (void)loadView
{
    [super loadView];
    //self.wantsFullScreenLayout;
    
    _navigationBar = [[UINavigationBar alloc] init];
    [_navigationBar sizeToFit];
    
    _containerView = [[UIView alloc] initWithFrame:CGRectMake(0, CGRectGetHeight(_navigationBar.frame),
                                                              CGRectGetWidth(self.view.frame), CGRectGetHeight(self.view.frame) - CGRectGetHeight(_navigationBar.frame))];
    [self.view addSubview:_containerView];
    [self.view addSubview:_navigationBar];
}

- (void)loadViewTmp
{
    
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    [self.view addGestureRecognizer:_pan];
    [self.view addGestureRecognizer:_swipe];
    
    self.topViewController.view.frame = _containerView.bounds;
    [_containerView addSubview:self.topViewController.view];
    [_navigationBar pushNavigationItem:self.topViewController.navigationItem
                              animated:NO];
}

- (void)viewDidUnload
{
    [super viewDidUnload];
    
    SAFE_RELEASE(_navigationBar);
    SAFE_RELEASE(_navigationBarTmp);
    SAFE_RELEASE(_containerView);
    SAFE_RELEASE(_containerViewTmp);
    SAFE_RELEASE(_viewTmp);
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Methods

- (void)swapViews
{
    SAFE_RELEASE(_navigationBar);
    SAFE_RELEASE(_containerView);
    
    [self.view removeFromSuperview];
    self.view = _viewTmp;
    _navigationBar = _navigationBarTmp;
    _containerView = _containerViewTmp;
    
    _navigationBarTmp = nil;
    _containerViewTmp = nil;
    _viewTmp = nil;
}

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

#pragma mark - Public Methods

- (void)pushViewController:(UIViewController *)viewController
                  animated:(BOOL)animated
{
    [self addChildViewController:viewController];

    if (!_topViewController) {
        _topViewController = viewController;
        if (self.isViewLoaded) {
            [self viewDidLoad];
        }
        return;
    }

    [self transitionFromViewController:self.topViewController
                      toViewController:viewController
                              duration:UINavigationControllerHideShowBarDuration
                               options:UIViewAnimationOptionCurveEaseInOut | UIViewAnimationOptionTransitionFlipFromLeft
                            animations:^{
                                [_navigationBar pushNavigationItem:viewController.navigationItem
                                                          animated:animated];
                            }
                            completion:^(BOOL finished) {
                                _topViewController = viewController;
                            }];
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

#pragma mark - UINavigationBar Delegate

- (BOOL)navigationBar:(UINavigationBar *)navigationBar
        shouldPopItem:(UINavigationItem *)item
{
    
    return YES;
}

@end

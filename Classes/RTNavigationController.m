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
    
    _navigationBar = [[UINavigationBar alloc] init];
    _navigationBar.delegate = self;
    [_navigationBar sizeToFit];
    
    _contentView = [[UIView alloc] initWithFrame:CGRectMake(0, CGRectGetHeight(_navigationBar.bounds), CGRectGetWidth(self.view.bounds),
                                                            CGRectGetHeight(self.view.bounds) - CGRectGetHeight(_navigationBar.bounds))];
    
    [self.view addSubview:_contentView];
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
    
    [_contentView addSubview:self.topViewController.view];
    self.topViewController.view.frame = _contentView.bounds;
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
    SAFE_RELEASE(_contentView);
    
    [self.view removeFromSuperview];
    self.view = _viewTmp;
    _navigationBar = _navigationBarTmp;
    _contentView = _contentViewTmp;
    
    _navigationBarTmp = nil;
    _contentViewTmp = nil;
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
            
        }
    }

    [_navigationBar pushNavigationItem:viewController.navigationItem
                              animated:animated];
    [self transitionFromViewController:self.topViewController
                      toViewController:viewController
                              duration:UINavigationControllerHideShowBarDuration
                               options:UIViewAnimationOptionCurveEaseInOut | UIViewAnimationOptionTransitionFlipFromLeft
                            animations:^{
                                
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

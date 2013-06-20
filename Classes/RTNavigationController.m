//
//  RTNavigationController.m
//  RTNavigationController
//
//  Created by ricky on 13-3-30.
//  Copyright (c) 2013年 ricky. All rights reserved.
//

#import "RTNavigationController.h"
#import <QuartzCore/QuartzCore.h>

#define PAN_THRESHOLD 64.0f


@interface RTNavigationController () <UINavigationBarDelegate>
@property (nonatomic, readwrite) NavigationState state;

- (void)onPan:(UIPanGestureRecognizer*)pan;

- (void)swapViews;
- (void)loadViewTmp;
- (void)unloadViewTmp;
- (void)applyTranslationForView:(UIView*)view
                     withOffset:(CGFloat)offset;

- (void)showCurrent;
- (void)showTmp;

@end

@implementation RTNavigationController
@synthesize navigationBarHidden = _navigationBarHidden;

- (void)dealloc
{
    SAFE_RELEASE(_pan);
    
    SAFE_RELEASE(_navigationBar);
    SAFE_RELEASE(_navigationBarTmp);
    SAFE_RELEASE(_containerView);
    SAFE_RELEASE(_containerViewTmp);
    SAFE_RELEASE(_contentView);
    SAFE_RELEASE(_contentViewTmp);
    
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

        
        _maskView = [[UIView alloc] init];
        _maskView.backgroundColor = [UIColor blackColor];
        _maskView.userInteractionEnabled = NO;
        _maskView.alpha = 0.0f;
        _maskView.hidden = YES;
        
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
    
    self.view.backgroundColor = [UIColor clearColor];
    
    _maskView.frame = self.view.bounds;
    [self.view addSubview:_maskView];
    
    _contentView = [[UIView alloc] initWithFrame:self.view.bounds];
    [self.view addSubview:_contentView];
    
    _navigationBar = [[UINavigationBar alloc] init];
    _navigationBar.delegate = self;
    [_navigationBar sizeToFit];
    
    _containerView = [[UIView alloc] initWithFrame:CGRectMake(0, CGRectGetHeight(_navigationBar.frame),
                                                              CGRectGetWidth(self.view.frame), CGRectGetHeight(self.view.frame) - CGRectGetHeight(_navigationBar.frame))];
    [_contentView addSubview:_containerView];
    [_contentView addSubview:_navigationBar];
}

- (void)loadViewTmp
{
    _contentViewTmp = [[UIView alloc] initWithFrame:self.view.bounds];
    _contentViewTmp.backgroundColor = [UIColor clearColor]; 
    
    _navigationBarTmp = [[UINavigationBar alloc] initWithFrame:_navigationBar.bounds];
    _navigationBarTmp.transform = _navigationBar.transform;
    _containerViewTmp = [[UIView alloc] initWithFrame:_containerView.frame];
    
    [_contentViewTmp addSubview:_containerViewTmp];
    [_contentViewTmp addSubview:_navigationBarTmp];
    
    if (self.state == NavigationStatePoping) {
        [self.view bringSubviewToFront:_contentView];
        [self.view insertSubview:_contentViewTmp
                    belowSubview:_maskView];
        
        [_contentView addObserver:self
                       forKeyPath:@"transform"
                          options:NSKeyValueObservingOptionNew
                          context:NULL];
    }
    else if (self.state == NavigationStatePushing) {
        UIBezierPath *path = [UIBezierPath bezierPathWithRect:CGRectMake(-4, -8, 8, self.view.bounds.size.height + 16)];
        _contentViewTmp.layer.shadowColor = [UIColor blackColor].CGColor;
        _contentViewTmp.layer.shadowOffset = CGSizeZero;
        _contentViewTmp.layer.shadowOpacity = 0.75;
        _contentViewTmp.layer.shadowPath = path.CGPath;
        
        _contentViewTmp.transform = CGAffineTransformMakeTranslation(self.view.bounds.size.width, 0);
        [self.view addSubview:_contentViewTmp];
        [self.view insertSubview:_maskView
                    belowSubview:_contentViewTmp];
        
        [_contentViewTmp addObserver:self
                          forKeyPath:@"transform"
                             options:NSKeyValueObservingOptionNew
                             context:NULL];
    }
}

- (void)unloadViewTmp
{
    SAFE_RELEASE(_containerViewTmp);
    SAFE_RELEASE(_navigationBarTmp);
    [_contentViewTmp removeFromSuperview];
    SAFE_RELEASE(_contentViewTmp);
    
    self.state = NavigationStateNormal;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    [self.view addGestureRecognizer:_pan];
    
    CATransform3D t = CATransform3DIdentity;
    //t.m34 = -0.002;
    self.view.layer.sublayerTransform = t;
    
    self.topViewController.view.frame = _containerView.bounds;
    [_containerView addSubview:self.topViewController.view];
    [_navigationBar pushNavigationItem:self.topViewController.navigationItem
                              animated:NO];
    NSAssert(_navigationBar.delegate == self, @"You should NOT handle UINavigationBar delegate yourself !");
}

- (void)viewDidUnload
{
    [super viewDidUnload];
    
    SAFE_RELEASE(_navigationBar);
    SAFE_RELEASE(_navigationBarTmp);
    SAFE_RELEASE(_containerView);
    SAFE_RELEASE(_containerViewTmp);
    SAFE_RELEASE(_contentView);
    SAFE_RELEASE(_contentViewTmp);
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Methods

- (void)observeValueForKeyPath:(NSString *)keyPath
                      ofObject:(id)object
                        change:(NSDictionary *)change
                       context:(void *)context
{
    if (self.state == NavigationStatePoping && object == _contentView) {
        CGFloat offset = _contentView.frame.origin.x;
        offset = MIN(1.0, MAX(0.0, offset / self.view.bounds.size.width));
        [self applyTranslationForView:_contentViewTmp
                           withOffset:offset];
    }
    else if (self.state == NavigationStatePushing && object == _contentViewTmp) {
        CGFloat offset = _contentViewTmp.frame.origin.x;
        offset = MIN(1.0, MAX(0.0, offset / self.view.bounds.size.width));
        [self applyTranslationForView: _contentView
                           withOffset:offset];
    }
}

- (void)swapViews
{
    SAFE_RELEASE(_navigationBar);
    SAFE_RELEASE(_containerView);
    
    [_contentView removeFromSuperview];
    SAFE_RELEASE(_contentView);
    
    _navigationBar = _navigationBarTmp;
    _navigationBar.delegate = self;
    _containerView = _containerViewTmp;
    _contentView = _contentViewTmp;
    
    _navigationBarTmp = nil;
    _containerViewTmp = nil;
    _contentViewTmp = nil;
    
    self.state = NavigationStateNormal;
}

- (void)applyTranslationForView:(UIView *)view
                     withOffset:(CGFloat)offset
{
    _maskView.hidden = YES;
    _maskView.alpha = 0.0;
    
    switch (self.translationStyle) {
        case NavigationTranslationStyleDeeper:
            view.transform = CGAffineTransformMakeScale(0.96 + 0.04*offset, 0.96 + 0.04*offset);
        case NavigationTranslationStyleFade:
            _maskView.hidden = NO;
            _maskView.alpha = 0.8 * (1 - fabs(offset));
            break;
        default:
            break;
    }
}

- (void)showTmp
{
    if (self.state == NavigationStatePoping) {
        __block CGAffineTransform t = CGAffineTransformMakeTranslation(self.view.bounds.size.width, 0);
        
        [UIView animateWithDuration:0.35
                              delay:0.0
                            options:UIViewAnimationOptionCurveEaseInOut | UIViewAnimationOptionBeginFromCurrentState
                         animations:^{
                             _contentView.transform = t;
                         }
                         completion:^(BOOL finished) {
                             [_contentView removeObserver:self
                                               forKeyPath:@"transform"];
                             [self swapViews];
                             _contentView.transform = CGAffineTransformIdentity;
                             [self.topViewController removeFromParentViewController];
                             _topViewController = self.childViewControllers.lastObject;
                         }];
    }
    else {

        [UIView animateWithDuration:0.35
                              delay:0.0
                            options:UIViewAnimationOptionCurveEaseInOut | UIViewAnimationOptionBeginFromCurrentState
                         animations:^{
                             _contentViewTmp.transform = CGAffineTransformIdentity;
                         }
                         completion:^(BOOL finished) {
                             while ([_navigationBarTmp popNavigationItemAnimated:NO]);
                             for (UIViewController *c in self.childViewControllers) {
                                 [_navigationBarTmp pushNavigationItem:c.navigationItem
                                                              animated:NO];
                             }
                             
                             [_contentViewTmp removeObserver:self
                                                  forKeyPath:@"transform"];
                             [self swapViews];
                             [self.topViewController.view removeFromSuperview];
                             _topViewController = self.childViewControllers.lastObject;
                            
                         }];
    }
}

- (void)showCurrent
{
    if (self.state == NavigationStatePoping) {
        
        [UIView animateWithDuration:0.35
                              delay:0.0
                            options:UIViewAnimationOptionCurveEaseInOut | UIViewAnimationOptionBeginFromCurrentState
                         animations:^{
                             _contentView.transform = CGAffineTransformIdentity;
                         }
                         completion:^(BOOL finished) {
                             [_contentView removeObserver:self
                                               forKeyPath:@"transform"];
                             [self unloadViewTmp];
                         }];
    }
    else if (self.state == NavigationStatePushing) {
        __block CGAffineTransform t = CGAffineTransformMakeTranslation(self.view.bounds.size.width, 0);

        [UIView animateWithDuration:0.35
                              delay:0.0
                            options:UIViewAnimationOptionCurveEaseInOut | UIViewAnimationOptionBeginFromCurrentState
                         animations:^{
                             _contentViewTmp.transform = t;
                         }
                         completion:^(BOOL finished) {
                             [_contentViewTmp removeObserver:self
                                                  forKeyPath:@"transform"];
                             [self unloadViewTmp];
                             [self.childViewControllers.lastObject removeFromParentViewController];
                             _topViewController = self.childViewControllers.lastObject;
                         }];
    }
}

- (void)setState:(NavigationState)state
{
    if (_state == state)
        return;
    
    switch (state) {
        case NavigationStateNormal:
            _contentView.layer.shadowColor = NULL;
            _contentView.layer.shadowOffset = CGSizeZero;
            _contentView.layer.shadowOpacity = 0.0;
            _contentView.layer.shadowPath = NULL;
            break;
        case NavigationStatePoping:
        {
            UIBezierPath *path = [UIBezierPath bezierPathWithRect:CGRectMake(-4, -8, 8, self.view.bounds.size.height + 16)];
            _contentView.layer.shadowColor = [UIColor blackColor].CGColor;
            _contentView.layer.shadowOffset = CGSizeZero;
            _contentView.layer.shadowOpacity = 0.75;
            _contentView.layer.shadowPath = path.CGPath;
        }
            break;
        case NavigationStatePushing:
        {
            UIBezierPath *path = [UIBezierPath bezierPathWithRect:CGRectMake(-4, -8, 8, self.view.bounds.size.height + 16)];
            _contentViewTmp.layer.shadowColor = [UIColor blackColor].CGColor;
            _contentViewTmp.layer.shadowOffset = CGSizeZero;
            _contentViewTmp.layer.shadowOpacity = 0.75;
            _contentViewTmp.layer.shadowPath = path.CGPath;
        }
            break;
        default:
            break;
    }
    
    _state = state;
}

- (void)onPan:(UIPanGestureRecognizer *)pan
{
    switch (_pan.state) {
        case UIGestureRecognizerStateBegan:
        {
            [self loadViewTmp];
            
            CGPoint p = [_pan translationInView:self.view];
            
            UIViewController *viewController = nil;
            if (p.x > 0)
                viewController = [self.childViewControllers objectAtIndex:self.childViewControllers.count - 2];
            else {
                viewController = [(id<RTNavigationControllerDatasource>)self.topViewController nextViewControllerForRTNavigationController:self];
                [self addChildViewController:viewController];
            }
            
            viewController.view.transform = CGAffineTransformIdentity;
            viewController.view.frame = _containerViewTmp.bounds;
            [_containerViewTmp addSubview:viewController.view];

            if (self.state == NavigationStatePoping) {
                _currentTrans = _contentView.transform;
                
                for (int i = 0; i < self.childViewControllers.count - 1; ++i) {
                    UIViewController *c = [self.childViewControllers objectAtIndex:i];
                                        
                    [_navigationBarTmp pushNavigationItem:c.navigationItem
                                                 animated:NO];
                }
            }
            else if (self.state == NavigationStatePushing) {
                _currentTrans = _contentViewTmp.transform;
                for (UIViewController *c in self.childViewControllers) {
                    [_navigationBarTmp pushNavigationItem:[NSKeyedUnarchiver unarchiveObjectWithData:[NSKeyedArchiver archivedDataWithRootObject:c.navigationItem]]
                                                 animated:NO];
                }
            }
        }
            break;
        case UIGestureRecognizerStateChanged:
        {
            CGPoint p = [_pan translationInView:self.view];
            CGFloat tx = MAX(0.0,p.x  + _currentTrans.tx);
            
            if (self.state == NavigationStatePoping)
                _contentView.transform = CGAffineTransformMakeTranslation(tx, 0);
            else if (self.state == NavigationStatePushing)
                _contentViewTmp.transform = CGAffineTransformMakeTranslation(MIN(tx,_currentTrans.tx), 0);
            
        }
            break;
        case UIGestureRecognizerStateEnded:
        case UIGestureRecognizerStateCancelled:
        {
            CGPoint v = [_pan velocityInView:self.view];
            if (fabs(v.x) < 32.0) {
                CGPoint p = [_pan translationInView:self.view];
                if (fabs(p.x) > PAN_THRESHOLD) {
                    [self showTmp];
                }
                else
                    [self showCurrent];
            }
            else {
                if ((self.state == NavigationStatePoping && v.x > 0) ||
                    (self.state == NavigationStatePushing && v.x < 0))
                    [self showTmp];
                else
                    [self showCurrent];
            }
            _scrollView.panGestureRecognizer.enabled = YES;
            _scrollView = nil;
        }
            break;
        default:
            break;
    }
}

#pragma mark - Public Methods

- (void)setNavigationBarHidden:(BOOL)navigationBarHidden
{
    [self setNavigationBarHidden:navigationBarHidden
                        animated:NO];
}

- (void)setNavigationBarHidden:(BOOL)hidden animated:(BOOL)animated
{
    if (self.isNavigationBarHidden == hidden)
        return;
    _navigationBarHidden = hidden;
    
    if (!hidden)
        [_contentView addSubview:_navigationBar];
    
    [UIView animateWithDuration:animated?0.25:0.0
                          delay:0.0
                        options:UIViewAnimationOptionCurveEaseOut
                     animations:^{
                         CGFloat h = _navigationBar.bounds.size.height;
                         _navigationBar.transform = CGAffineTransformMakeTranslation(0, hidden ? -h : 0);
                         CGRect rect = _contentView.bounds;
                         rect.origin.y = hidden ? 0 : h;
                         rect.size.height -= hidden ? 0 : h;
                         _containerView.frame = rect;
                     }
                     completion:^(BOOL finished) {
                         if (hidden)
                             [_navigationBar removeFromSuperview];
                     }];
}

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
    
    if (!viewController.isViewLoaded) {
        viewController.view.frame = _containerView.bounds;
        viewController.view.transform = CGAffineTransformMakeTranslation(CGRectGetWidth(self.view.bounds), 0);
    }
    
    [_navigationBar pushNavigationItem:viewController.navigationItem
                              animated:animated];
    
    [self transitionFromViewController:self.topViewController
                      toViewController:viewController
                              duration:0.35
                               options:UIViewAnimationOptionCurveEaseInOut
                            animations:^{
                                viewController.view.transform = CGAffineTransformIdentity;
                                self.topViewController.view.transform = CGAffineTransformMakeTranslation(-CGRectGetWidth(self.view.bounds), 0);
                            }
                            completion:^(BOOL finished) {
                                [_topViewController.view removeFromSuperview];
                                _topViewController = viewController;
                            }];
}

- (UIViewController*)popViewControllerAnimated:(BOOL)animated
{
    [_navigationBar popNavigationItemAnimated:animated];
    return self.topViewController;
}


#pragma mark - UIGesture Delegate

- (BOOL)gestureRecognizer:(UIGestureRecognizer *)gestureRecognizer
       shouldReceiveTouch:(UITouch *)touch
{
    if (_pan == gestureRecognizer) {
        _scrollView = nil;
        UIView *v = touch.view;
        while (v) {
            if ([v isKindOfClass:[UIScrollView class]]) {
                _scrollView = (UIScrollView*)v;
                break;
            }
            v = v.superview;
        }
    }
    return YES;
}

- (BOOL)gestureRecognizer:(UIGestureRecognizer *)gestureRecognizer
shouldRecognizeSimultaneouslyWithGestureRecognizer:(UIGestureRecognizer *)otherGestureRecognizer
{
    return NO;
}

- (BOOL)gestureRecognizerShouldBegin:(UIGestureRecognizer *)gestureRecognizer
{
    if (_pan == gestureRecognizer) {
        CGPoint p = [_pan translationInView:self.view];
        BOOL begin = fabsf(p.x) > fabsf(p.y);
        if (begin) {
            if (p.x < 0) {
                begin = [self.topViewController respondsToSelector:@selector(nextViewControllerForRTNavigationController:)];
                if (begin)
                    self.state = NavigationStatePushing;
                
                CGFloat offset = _scrollView.contentOffset.x + _scrollView.bounds.size.width - _scrollView.contentInset.right;
                if (offset >= _scrollView.contentSize.width && begin)
                    _scrollView.panGestureRecognizer.enabled = NO;
            }
            else {
                if (self.childViewControllers.count > 1) {
                    self.state = NavigationStatePoping;
                    
                    CGFloat offset = _scrollView.contentOffset.x + _scrollView.contentInset.left;
                    if (offset <= 0.0 && begin)
                        _scrollView.panGestureRecognizer.enabled = NO;
                }
                else
                    begin = NO;
            }
        }
        return begin;
    }

    return YES;
}

#pragma mark - UINavigationBar Delegate

- (BOOL)navigationBar:(UINavigationBar *)navigationBar
        shouldPopItem:(UINavigationItem *)item
{
    UIViewController *viewController = [self.childViewControllers objectAtIndex:self.childViewControllers.count - 2];
    
    viewController.view.transform = CGAffineTransformIdentity;
    viewController.view.frame = _containerView.bounds;
    viewController.view.transform = CGAffineTransformMakeTranslation(-CGRectGetWidth(self.view.bounds), 0);
    
    [self transitionFromViewController:self.topViewController
                      toViewController:viewController
                              duration:0.35
                               options:UIViewAnimationOptionCurveEaseInOut
                            animations:^{
                                viewController.view.transform = CGAffineTransformIdentity;
                                self.topViewController.view.transform = CGAffineTransformMakeTranslation(CGRectGetWidth(self.view.bounds), 0);
                            }
                            completion:^(BOOL finished) {
                                [_topViewController removeFromParentViewController];
                                
                                _topViewController = viewController;
                            }];
    
    return YES;
}

@end


@implementation UIViewController (RTNavigationControllerItem)

- (RTNavigationController*)navigationController
{
    UIViewController *c = self.parentViewController;
    while (c) {
        if ([c isKindOfClass:[RTNavigationController class]])
            return (RTNavigationController*)c;
        c = c.parentViewController;
    }
    return nil;
}

@end

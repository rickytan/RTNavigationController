//
//  RTNavigationController.h
//  RTNavigationController
//
//  Created by ricky on 13-3-30.
//  Copyright (c) 2013年 ricky. All rights reserved.
//

#import <UIKit/UIKit.h>

#ifndef SAFE_RELEASE
#if __has_feature(objc_arc)
#define SAFE_RELEASE(o) ((o) = nil)
#define SAFE_DEALLOC(o) {}
#else
#define SAFE_RELEASE(o) ([(o) release], (o) = nil)
#define SAFE_AUTORELEASE(o) ([(o) autorelease])
#define SAFE_DEALLOC(o) [o dealloc]
#endif
#endif

@class RTNavigationController;

@protocol RTNavigationControllerDatasource <NSObject>
@optional
- (UIViewController*)nextViewControllerForRTNavigationController:(RTNavigationController*)controller;

@end

typedef enum {
    NavigationTranslationStyleNormal,
    NavigationTranslationStyleFade,
    NavigationTranslationStyleDeeper = NavigationTranslationStyleNormal,
}NavigationTranslationStyle;

typedef enum {
    NavigationStateNormal,
    NavigationStatePoping,
    NavigationStatePushing
}NavigationState;

@interface RTNavigationController : UIViewController <UIGestureRecognizerDelegate>
{
@private
    UIPanGestureRecognizer                  * _pan;
    
    UIViewController                        * _topViewController;
    
    CGAffineTransform                         _currentTrans;
    
    UINavigationBar                         * _navigationBar;
    UINavigationBar                         * _navigationBarTmp;
    
    UIView                                  * _containerView;
    UIView                                  * _containerViewTmp;
    
    UIView                                  * _contentView;
    UIView                                  * _contentViewTmp;
    
    UIScrollView                            * _scrollView;
    
    UIView                                  * _maskView;
}

//@property (nonatomic, strong) id<RTNavigationControllerDatasource> dataSource;
@property (nonatomic, readonly) UIViewController *topViewController;

@property (nonatomic, assign) NavigationTranslationStyle translationStyle;
@property (nonatomic, readonly) NavigationState state;

- (id)initWithRootViewController:(UIViewController*)controller;

- (void)pushViewController:(UIViewController*)viewController
                  animated:(BOOL)animated;
- (UIViewController*)popViewControllerAnimated:(BOOL)animated;

@property(nonatomic,getter=isNavigationBarHidden) BOOL navigationBarHidden;
- (void)setNavigationBarHidden:(BOOL)hidden animated:(BOOL)animated;

/*
- (NSArray*)popToRootViewControllerAnimated:(BOOL)animated;
- (NSArray*)popToViewController:(UIViewController *)viewController
                       animated:(BOOL)animated;
 */

@end


@interface UIViewController (RTNavigationControllerItem)
@property (nonatomic, readonly) RTNavigationController *navigationController;
@end

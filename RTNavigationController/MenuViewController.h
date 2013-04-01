//
//  MenuViewController.h
//  RTNavigationController
//
//  Created by ricky on 13-4-1.
//  Copyright (c) 2013年 ricky. All rights reserved.
//

#import <UIKit/UIKit.h>

@class MenuViewController;

@protocol MenuDelegate <NSObject>

- (void)menuViewController:(MenuViewController*)menu
      didSelectMenuAtIndex:(NSUInteger)index;

@end

@interface MenuViewController : UITableViewController
@property (nonatomic, assign) id<MenuDelegate> delegate;
@end

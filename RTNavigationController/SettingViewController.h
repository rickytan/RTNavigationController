//
//  SettingViewController.h
//  RTNavigationController
//
//  Created by ricky on 13-4-1.
//  Copyright (c) 2013年 ricky. All rights reserved.
//

#import <UIKit/UIKit.h>

@class SettingViewController;

@protocol SettingDelegate <NSObject>

- (void)settingViewController:(SettingViewController*)setting didSelectSettingAtIndex:(NSUInteger)index;

@end

@interface SettingViewController : UITableViewController
@property (nonatomic, assign) id<SettingDelegate> delegate;
@end

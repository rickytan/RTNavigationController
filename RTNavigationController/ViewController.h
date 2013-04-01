//
//  ViewController.h
//  RTNavigationController
//
//  Created by ricky on 13-3-30.
//  Copyright (c) 2013年 ricky. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "MenuViewController.h"
#import "SettingViewController.h"
#import "RedViewController.h"
#import "BlueViewController.h"


#import "RTNavigationController.h"
#import "RTSiderViewController.h"

@interface ViewController : UIViewController
<RTSiderViewControllerDatasource,
SettingDelegate,
MenuDelegate>
{
    RTSiderViewController           * sider;
}
@end

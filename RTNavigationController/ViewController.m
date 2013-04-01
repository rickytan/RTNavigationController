//
//  ViewController.m
//  RTNavigationController
//
//  Created by ricky on 13-3-30.
//  Copyright (c) 2013年 ricky. All rights reserved.
//

#import "ViewController.h"


@interface ViewController ()
- (IBAction)onButton:(id)sender;
@end

@implementation ViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view, typically from a nib.
    
    sider = [[RTSiderViewController alloc] init];
    sider.dataSource = self;
    sider.view.frame = self.view.bounds;
    sider.translationStyle = SlideTranslationStylePull;
    
    [sider setMiddleViewController:[[[RedViewController alloc] init] autorelease]
                          animated:YES];
    
    MenuViewController *menu = [[[MenuViewController alloc] initWithStyle:UITableViewStylePlain] autorelease];
    menu.delegate = self;
    
    [sider setLeftViewController:menu];
    
    SettingViewController *setting = [[[SettingViewController alloc] initWithStyle:UITableViewStyleGrouped] autorelease];
    setting.delegate = self;
    
    [sider setRightViewController:setting];
    
    [self.view addSubview:sider.view];
    [self addChildViewController:sider];
    [sider release];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)onButton:(id)sender
{
    UITableViewController *table = [[UITableViewController alloc] initWithStyle:UITableViewStyleGrouped];
    [self.navigationController pushViewController:table
                                         animated:YES];
    [table release];
}

#pragma mark - RTSiderView Datasource

- (BOOL)shouldAdjustWidthOfRightViewController
{
    return YES;
}

- (CGFloat)siderViewControllerMarginForSlidingToLeft:(RTSiderViewController *)controller
{
    return 100.0;
}

#pragma mark - Menu Delegate

- (void)menuViewController:(MenuViewController *)menu
      didSelectMenuAtIndex:(NSUInteger)index
{
    sider.translationStyle = index;
}

#pragma mark - Setting Delegate

- (void)settingViewController:(SettingViewController *)setting
      didSelectSettingAtIndex:(NSUInteger)index
{
    if (index == 0)
        [sider setMiddleViewController:[[[RedViewController alloc] init] autorelease] animated:YES];
    else if (index == 1)
        [sider setMiddleViewController:[[[BlueViewController alloc] init] autorelease] animated:YES];
}

@end

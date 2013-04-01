//
//  ViewController.m
//  RTNavigationController
//
//  Created by ricky on 13-3-30.
//  Copyright (c) 2013年 ricky. All rights reserved.
//

#import "ViewController.h"
#import "MainViewController.h"

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
    sider.middleTranslationStyle = MiddleViewTranslationStyleStay;
    
    [sider setMiddleViewController:[[[MainViewController alloc] init] autorelease]
                          animated:YES];
    
    MenuViewController *menu = [[[MenuViewController alloc] initWithStyle:UITableViewStylePlain] autorelease];
    
    [sider setLeftViewController:menu];
    
    SettingViewController *setting = [[[SettingViewController alloc] initWithStyle:UITableViewStyleGrouped] autorelease];
    
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
    return 50.0;
}

- (CATransform3D)siderViewController:(RTSiderViewController *)controller
                 transformWithOffset:(CGFloat)offset
                       andFadingView:(UIView *)view
{
    view.hidden = NO;
    view.alpha = 1.0 - fabs(offset);

    CATransform3D t = CATransform3DMakeTranslation(0, -controller.view.bounds.size.height * (1 - fabs(offset)), 0);
    return t;
}

@end

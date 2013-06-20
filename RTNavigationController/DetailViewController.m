//
//  DetailViewController.m
//  RTNavigationController
//
//  Created by ricky on 13-4-4.
//  Copyright (c) 2013年 ricky. All rights reserved.
//

#import "DetailViewController.h"

@interface DetailViewController ()

@end

@implementation DetailViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
        self.title = @"Detail View";
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    
    UIBarButtonItem *commentItem = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemAction
                                                                                 target:self
                                                                                 action:@selector(onComment:)];
    self.navigationItem.rightBarButtonItem = commentItem;
    [commentItem release];
}


- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    NSLog(@"%@ will appear",NSStringFromClass(self.class));
}

- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    NSLog(@"%@ did appear",NSStringFromClass(self.class));
}

- (void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    NSLog(@"%@ will disappear",NSStringFromClass(self.class));
}

- (void)viewDidDisappear:(BOOL)animated
{
    [super viewDidDisappear:animated];
    NSLog(@"%@ did disappear",NSStringFromClass(self.class));
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)onComment:(id)sender
{
    [self.navigationController pushViewController:[self nextViewControllerForRTNavigationController:nil]
                                         animated:YES];
}

#pragma mark - RTNavigation Datasource

- (UIViewController*)nextViewControllerForRTNavigationController:(RTNavigationController*)controller
{
    UIViewController *c = [[[UITableViewController alloc] initWithStyle:UITableViewStyleGrouped] autorelease];
    c.title = @"Comment";
    return c;
}

@end

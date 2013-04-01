//
//  SettingViewController.m
//  RTNavigationController
//
//  Created by ricky on 13-4-1.
//  Copyright (c) 2013年 ricky. All rights reserved.
//

#import "SettingViewController.h"
#import "RTSiderViewController.h"
#import "RedViewController.h"
#import "BlueViewController.h"
#import "MainViewController.h"

@interface SettingViewController ()

@end

@implementation SettingViewController

- (id)initWithStyle:(UITableViewStyle)style
{
    self = [super initWithStyle:style];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    // Uncomment the following line to preserve selection between presentations.
    // self.clearsSelectionOnViewWillAppear = NO;
    
    // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
    // self.navigationItem.rightBarButtonItem = self.editButtonItem;
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 2;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if (section == 0)
        return 3;
    return 3;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"Cell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (!cell) {
        cell = [[[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault
                                       reuseIdentifier:CellIdentifier] autorelease];
    }
    
    // Configure the cell...
    if (indexPath.section == 0) {
        switch (indexPath.row) {
            case 0:
                cell.textLabel.text = @"Main View";
                break;
            case 1:
                cell.textLabel.text = @"Red View";
                break;
            case 2:
                cell.textLabel.text = @"Blue View";
                break;
            default:
                break;
        }
    }
    else {
        switch (indexPath.row) {
            case 0:
            {
                cell.textLabel.text = @"Allow Over Drag";
                
                UISwitch *allow = [[UISwitch alloc] init];
                allow.tag = 10;
                allow.on = self.siderViewController.allowOverDrag;
                [allow addTarget:self
                          action:@selector(onAllow:)
                forControlEvents:UIControlEventValueChanged];
                cell.accessoryView = allow;
                [allow release];
            }
                break;
            case 1:
            {
                cell.textLabel.text = @"Tap To Center";
                
                UISwitch *allow = [[UISwitch alloc] init];
                allow.on = self.siderViewController.tapToCenter;
                [allow addTarget:self
                          action:@selector(onAllow:)
                forControlEvents:UIControlEventValueChanged];
                cell.accessoryView = allow;
                [allow release];
            }
            default:
                break;
        }
    }
    
    return cell;
}

#pragma mark - Table view delegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.section == 0) {
        switch (indexPath.row) {
            case 0:
                [self.siderViewController setMiddleViewController:[[[MainViewController alloc] init] autorelease] animated:YES];
                break;
            case 1:
                [self.siderViewController setMiddleViewController:[[[RedViewController alloc] init] autorelease] animated:YES];
                break;
            case 2:
                [self.siderViewController setMiddleViewController:[[[BlueViewController alloc] init] autorelease] animated:YES];
                break;
            default:
                break;
        }
    }
}

#pragma mark - Methods

- (void)onAllow:(UISwitch*)on
{
    if (on.tag == 10)
        self.siderViewController.allowOverDrag = on.isOn;
    else
        self.siderViewController.tapToCenter = on.isOn;
}

@end

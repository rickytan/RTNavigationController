//
//  MenuViewController.m
//  RTNavigationController
//
//  Created by ricky on 13-4-1.
//  Copyright (c) 2013年 ricky. All rights reserved.
//

#import "MenuViewController.h"
#import "RTSiderViewController.h"

@interface MenuViewController ()

@end

@implementation MenuViewController

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
        return 7;
    return 2;
}

- (NSString*)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section
{
    if (section == 0)
        return @"SlideTranslationStyle";
    return @"MiddleViewTranslationStyle";
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
                cell.textLabel.text = @"Normal";
                break;
            case 1:
                cell.textLabel.text = @"Fade";
                break;
            case 2:
                cell.textLabel.text = @"Pull";
                break;
            case 3:
                cell.textLabel.text = @"HalfPull";
                break;
            case 4:
                cell.textLabel.text = @"DeeperAndFade";
                break;
            case 5:
                cell.textLabel.text = @"Lean";
                break;
            case 6:
                cell.textLabel.text = @"Custom";
                break;
            default:
                break;
        }
    }
    else {
        switch (indexPath.row) {
            case 0:
                cell.textLabel.text = @"Stay";
                break;
            case 1:
                cell.textLabel.text = @"BackIn";
                break;
            default:
                break;
        }
    }
    
    return cell;
}

#pragma mark - Table view delegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.section == 0)
        self.siderViewController.translationStyle = indexPath.row;
    else
        self.siderViewController.middleTranslationStyle = indexPath.row;
}

@end

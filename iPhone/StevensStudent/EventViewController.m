//
//  EventViewController.m
//  StevensStudent
//
//  Created by toby on 5/28/14.
//  Copyright (c) 2014 arrowtop. All rights reserved.
//

#import "EventViewController.h"
#import "EventDetailsViewController.h"

@interface EventViewController ()<UITableViewDelegate, UITableViewDataSource>

@end

@implementation EventViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return 1;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell *cell = [self.tableView dequeueReusableCellWithIdentifier:@"EventCell"];
    
    cell.textLabel.numberOfLines = 2;
    cell.textLabel.font = [ UIFont fontWithName: @"Arial" size: 13.0 ];
    cell.textLabel.text = @"Graduate Admissions: Accepted Students Chat Session";
    
    return cell;
    
}

#pragma mark - Navigation

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    EventDetailsViewController *ndvc = [self.storyboard instantiateViewControllerWithIdentifier:@"EventDetailsViewController"];
    
    [self.navigationController setNavigationBarHidden:NO];
    [self.navigationController pushViewController:ndvc animated:YES];
    
}

@end

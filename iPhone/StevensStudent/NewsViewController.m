//
//  NewsViewController.m
//  StevensStudent
//
//  Created by toby on 5/28/14.
//  Copyright (c) 2014 arrowtop. All rights reserved.
//

#import "NewsViewController.h"
#import "NewsCell.h"
#import "NewsDetailsViewController.h"

@interface NewsViewController ()<UITableViewDelegate, UITableViewDataSource>

@end

@implementation NewsViewController

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
    static NSString *CellIdentifier = @"NewsCell";
    NewsCell *cell = (NewsCell *)[self.tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    
    // Configure the cell...
    if (cell == nil) {
        cell = [[NewsCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
    }
    
    NSString *imageTitle = @"example.png";
    cell.imageNail.image = [UIImage imageNamed:imageTitle];
    cell.titleView.text = @"Is America Ready? Investment Levels in Education and Research Raise Questions About U.S. Economic Competitiveness";
    
    return cell;
    
}

#pragma mark - Navigation

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    NewsDetailsViewController *ndvc = [self.storyboard instantiateViewControllerWithIdentifier:@"NewsDetailsViewController"];
    
    [self.navigationController setNavigationBarHidden:NO];
    [self.navigationController pushViewController:ndvc animated:YES];
    
}


@end

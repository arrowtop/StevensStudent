//
//  BuildingViewController.m
//  StevensStudent
//
//  Created by toby on 5/14/14.
//  Copyright (c) 2014 arrowtop. All rights reserved.
//

#import "BuildingViewController.h"
#import "BuildingTableViewCell.h"
#import "BuildingDetailsViewController.h"

@interface BuildingViewController ()<UITableViewDelegate, UITableViewDataSource>
{
    NSArray *buildings;
    NSArray *searchResults;
}

@end

@implementation BuildingViewController

- (void) viewDidLoad
{
    [super viewDidLoad];
    [self fetchData];
}

#pragma mark - Fetch Data
- (void) fetchData
{
    dispatch_queue_t fetchQ = dispatch_queue_create("Building Fetcher", NULL);
    dispatch_async(fetchQ, ^{
        NSString* dataPath = [[NSBundle mainBundle] pathForResource:@"building" ofType:@"json"];
        buildings = [NSJSONSerialization JSONObjectWithData:[NSData dataWithContentsOfFile:dataPath]
                                               options:0
                                                 error:nil];
    });
}

#pragma mark - searchView

-(void) filterContentForSearchText:searchText
{
    NSPredicate *resultPredicate = [NSPredicate predicateWithFormat:@"code beginswith[c] %@ OR name beginswith[c] %@", searchText, searchText];
    searchResults = [buildings filteredArrayUsingPredicate:resultPredicate];    
}

- (BOOL)searchDisplayController:(UISearchDisplayController *)controller shouldReloadTableForSearchString:(NSString *)searchString
{
    [self filterContentForSearchText:searchString];
    return YES;
}

#pragma -mark TableView Methods
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if (tableView == self.searchDisplayController.searchResultsTableView) {
        return [searchResults count];
        
    } else {
        return [buildings count];
    }
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"BuildingCell";
    BuildingTableViewCell *cell = (BuildingTableViewCell *)[self.tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    
    // Configure the cell...
    if (cell == nil) {
        cell = [[BuildingTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
    }
    
    // Display details in the table cell
    NSString *code;
    NSString *name;
    if (tableView == self.searchDisplayController.searchResultsTableView) {
        name = [[searchResults objectAtIndex:indexPath.row] valueForKey:@"name"];
        code = [[searchResults objectAtIndex:indexPath.row] valueForKey:@"code"];
    } else {
        name = [[buildings objectAtIndex:indexPath.row] valueForKey:@"name"];
        code = [[buildings objectAtIndex:indexPath.row] valueForKey:@"code"];
    }
    
    cell.buildingCode.text = code;
    cell.buildingName.text = name;
    
    return cell;
}

#pragma mark - Navigation

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    BuildingDetailsViewController *bdvc = [self.storyboard instantiateViewControllerWithIdentifier:@"BuildingDetailsViewController"];
    /*
    if (tableView == self.searchDisplayController.searchResultsTableView) {
        
        bdvc.segueResult = [[searchResults objectAtIndex:indexPath.row] valueForKey:@"name"];
        bdvc.segueLongitude = [[searchResults objectAtIndex:indexPath.row] valueForKey:@"longitude"];
        bdvc.segueLatitude = [[searchResults objectAtIndex:indexPath.row] valueForKey:@"latitude"];
        
    } else {
        bdvc.segueResult = [[buildings objectAtIndex:indexPath.row] valueForKey:@"name"];
        bdvc.segueLongitude = [[buildings objectAtIndex:indexPath.row] valueForKey:@"longitude"];
        bdvc.segueLatitude = [[buildings objectAtIndex:indexPath.row] valueForKey:@"latitude"];
    }
     */
    [self.tableView deselectRowAtIndexPath:indexPath animated:YES];
    [self.navigationController setNavigationBarHidden:NO];
    [self.navigationController pushViewController:bdvc animated:YES];
    
}


@end

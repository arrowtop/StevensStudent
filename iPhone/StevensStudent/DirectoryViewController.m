//
//  DirectoryVC.m
//  StevensStudent
//
//  Created by toby on 5/23/14.
//  Copyright (c) 2014 arrowtop. All rights reserved.
//

#import "DirectoryViewController.h"
#import "People.h"
#import "DirectoryDetailsViewController.h"

@interface DirectoryViewController ()<UITableViewDataSource, UITabBarControllerDelegate>

@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property (weak, nonatomic) IBOutlet UISearchBar *searchBar;
@property (weak, nonatomic) IBOutlet UIButton *recentSearched1;
@property (weak, nonatomic) IBOutlet UIButton *recentSearched2;
@property (weak, nonatomic) IBOutlet UIButton *recentSearched3;

@end

@implementation DirectoryViewController
{
    NSArray *peoples;
    NSArray *searchResults;
    bool isSearchBarEmpty;
}

#define Rgb2UIColor(r, g, b)  [UIColor colorWithRed:((r) / 255.0) green:((g) / 255.0) blue:((b) / 255.0) alpha:1.0]

- (void) viewDidLoad
{
    isSearchBarEmpty = true;
    [super viewDidLoad];
    [self.tableView setHidden:YES];
    self.searchBar.showsCancelButton = YES;
    [self.searchBar setShowsCancelButton:YES animated:YES];
    [self fetchData];
    [self checkDocument];
    [self loadRecentSearched];
}

- (void) fetchData
{
    dispatch_queue_t fetchQ = dispatch_queue_create("Directory Fetcher", NULL);
    dispatch_async(fetchQ, ^{
        NSString* dataPath = [[NSBundle mainBundle] pathForResource:@"directory" ofType:@"json"];
        peoples = [NSJSONSerialization JSONObjectWithData:[NSData dataWithContentsOfFile:dataPath]
                                                  options:0
                                                    error:nil];
    });
}

- (void) saveData
{
    [peoples enumerateObjectsUsingBlock:^(id obj, NSUInteger idx, BOOL *stop) {
        People *people = [NSEntityDescription
                          insertNewObjectForEntityForName:@"People"
                          inManagedObjectContext:self.document.managedObjectContext];
        people.name = [obj objectForKey:@"name"];
        people.title = [obj objectForKey:@"title"];
        people.building = [obj objectForKey:@"building"];
        people.room = [obj objectForKey:@"room"];
        people.phone = [obj objectForKey:@"phone"];
        people.fax = [obj objectForKey:@"fax"];
        people.email = [obj objectForKey:@"email"];
        people.school = [obj objectForKey:@"school"];
        people.department = [obj objectForKey:@"department"];
        
        NSError *error;
        if (![self.document.managedObjectContext save:&error]) {
            NSLog(@"Whoops, couldn't save: %@", [error localizedDescription]);
        }
        
        NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
        
        [userDefaults setBool:YES forKey:@"saveData"];
        [userDefaults synchronize];
    }];
}

- (void) checkDocument {
    
    BOOL fileExists = [[NSFileManager defaultManager] fileExistsAtPath:[self.url path]];
    if (!fileExists){
        [self.document saveToURL:self.url forSaveOperation:UIDocumentSaveForCreating completionHandler:^(BOOL success) {
            if (!success) NSLog(@"couldn't open document at %@", self.url);
        }];
    } else {
        [self.document openWithCompletionHandler:^(BOOL success) {
            if (![[NSUserDefaults standardUserDefaults] boolForKey:@"saveData"]) [self saveData];
            if (!success) NSLog(@"couldn't open document at %@", self.url);
        }];
    }
}

#pragma mark - searchView

- (BOOL)searchBarShouldBeginEditing:(UISearchBar *)searchBar
{
    [self.tableView setHidden:NO];
    [self.tableView reloadData];
    return YES;
}

- (void)filterContentForSearchText:(NSString *)searchText
{
    NSFetchRequest *request = [NSFetchRequest fetchRequestWithEntityName: @"People"];
    request.predicate = [NSPredicate predicateWithFormat:@"name beginswith[c] %@", searchText];
    request.sortDescriptors = @[[NSSortDescriptor sortDescriptorWithKey:@"name" ascending:YES]];
    NSError *error;
    searchResults = [self.document.managedObjectContext executeFetchRequest:request error:&error];
}

-(void)searchBar:(UISearchBar *)searchBar textDidChange:(NSString *)searchText
{
    if(![searchText isEqualToString:@""]) {
       isSearchBarEmpty = false;
    } else {
        isSearchBarEmpty = true;
    }
    [self filterContentForSearchText:searchText];
    [self.tableView reloadData];
}


- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return isSearchBarEmpty == false ? [searchResults count] : [peoples count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    static NSString *CellIdentifier = @"DirectoryCell";
    UITableViewCell *cell = [self.tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    
    // Display details in the table cell
    NSManagedObject *people;
    if (isSearchBarEmpty == false) {
        people = [searchResults objectAtIndex:indexPath.row];
    } else {
        people = [peoples objectAtIndex:indexPath.row];
    }
    cell.textLabel.text = [NSString stringWithFormat:@"%@", [people valueForKey:@"name"]];
    cell.detailTextLabel.text = [NSString stringWithFormat:@"%@", [people valueForKey:@"title"]];
    cell.textLabel.textColor = [UIColor redColor];
    cell.detailTextLabel.textColor = Rgb2UIColor(120, 189, 254);
    return cell;
    
}

- (void)searchBarCancelButtonClicked:(UISearchBar *)searchBar
{
    searchBar.text = @"";
    [searchBar resignFirstResponder];
    [self.tableView setHidden:YES];
}

#pragma mark - Navigation

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    DirectoryDetailsViewController *ddvc = [self.storyboard instantiateViewControllerWithIdentifier:@"DirectoryDetailsViewController"];
        
    NSManagedObject *people;
    if (isSearchBarEmpty == false) {
        people = [searchResults objectAtIndex:indexPath.row];
    } else {
        people = [peoples objectAtIndex:indexPath.row];
    }
    ddvc.title = [NSString stringWithFormat:@"%@", [people valueForKey:@"name"]];
    ddvc.pTitle = [NSString stringWithFormat:@"%@", [people valueForKey:@"title"]];
    ddvc.pBuilding = [NSString stringWithFormat:@"%@", [people valueForKey:@"building"]];
    ddvc.pRoom = [NSString stringWithFormat:@"%@", [people valueForKey:@"room"]];
    ddvc.pFax = [NSString stringWithFormat:@"%@", [people valueForKey:@"fax"]];
    ddvc.pEmail = [NSString stringWithFormat:@"%@", [people valueForKey:@"email"]];
    ddvc.pPhone = [NSString stringWithFormat:@"%@", [people valueForKey:@"phone"]];
    ddvc.pSchool = [NSString stringWithFormat:@"%@", [people valueForKey:@"school"]];
    ddvc.pDep = [NSString stringWithFormat:@"%@", [people valueForKey:@"department"]];

    [self.tableView deselectRowAtIndexPath:indexPath animated:YES];
    [self.navigationController setNavigationBarHidden:NO];
    [self.navigationController pushViewController:ddvc animated:YES];
    
}

#pragma mark - search history & bookmarks
- (void) loadRecentSearched
{
    NSString *recentSearchedKeyD1 = @"recentSearchedKeyD1";
    NSString *recentSearchedKeyD2 = @"recentSearchedKeyD2";
    NSString *recentSearchedKeyD3 = @"recentSearchedKeyD3";
    NSString *recentSearchedValueD1 = (NSString *)[[NSUserDefaults standardUserDefaults] objectForKey:recentSearchedKeyD1];
    NSString *recentSearchedValueD2 = (NSString *)[[NSUserDefaults standardUserDefaults] objectForKey:recentSearchedKeyD2];
    NSString *recentSearchedValueD3 = (NSString *)[[NSUserDefaults standardUserDefaults] objectForKey:recentSearchedKeyD3];
    if (recentSearchedValueD1 == nil) {
        [self.recentSearched1 setHidden:true];
    } else {
        [self.recentSearched1 setTitle:recentSearchedValueD1 forState:UIControlStateNormal];
    }
    if (recentSearchedValueD2 == nil) {
        [self.recentSearched2 setHidden:true];
    } else {
        [self.recentSearched2 setTitle:recentSearchedValueD2 forState:UIControlStateNormal];
    }
    if (recentSearchedValueD3 == nil) {
        [self.recentSearched3 setHidden:true];
    } else {
        [self.recentSearched3 setTitle:recentSearchedValueD3 forState:UIControlStateNormal];
    }
}

- (void) saveRecentSearched: (NSString *) courseMark
{
    NSString *recentSearchedKeyD1 = @"recentSearchedKeyD1";
    NSString *recentSearchedKeyD2 = @"recentSearchedKeyD2";
    NSString *recentSearchedKeyD3 = @"recentSearchedKeyD3";
    NSString *recentSearchedValueD1 = (NSString *)[[NSUserDefaults standardUserDefaults] objectForKey:recentSearchedKeyD1];
    NSString *recentSearchedValueD2 = (NSString *)[[NSUserDefaults standardUserDefaults] objectForKey:recentSearchedKeyD2];
    NSString *recentSearchedValueD3 = (NSString *)[[NSUserDefaults standardUserDefaults] objectForKey:recentSearchedKeyD3];
    if (recentSearchedValueD1 == nil) {
        NSDictionary *appDefaults  = [NSDictionary dictionaryWithObjectsAndKeys:courseMark, recentSearchedKeyD1, nil];
        
        [[NSUserDefaults standardUserDefaults] registerDefaults:appDefaults];
        [[NSUserDefaults standardUserDefaults] synchronize];
    } else if (recentSearchedValueD2 == nil) {
        NSDictionary *appDefaults  = [NSDictionary dictionaryWithObjectsAndKeys:courseMark, recentSearchedKeyD2, nil];
        
        [[NSUserDefaults standardUserDefaults] registerDefaults:appDefaults];
        [[NSUserDefaults standardUserDefaults] synchronize];
        
    } else if (recentSearchedValueD3 == nil) {
        NSDictionary *appDefaults  = [NSDictionary dictionaryWithObjectsAndKeys:courseMark, recentSearchedKeyD3, nil];
        
        [[NSUserDefaults standardUserDefaults] registerDefaults:appDefaults];
        [[NSUserDefaults standardUserDefaults] synchronize];
    } else {
        [[NSUserDefaults standardUserDefaults] setObject:recentSearchedValueD2 forKey:recentSearchedKeyD1];
        [[NSUserDefaults standardUserDefaults] setObject:recentSearchedValueD3 forKey:recentSearchedKeyD2];
        [[NSUserDefaults standardUserDefaults] setObject:courseMark forKey:recentSearchedKeyD3];
    }
}
@end

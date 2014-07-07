//
//  CourseVC.m
//  StevensStudent
//
//  Created by toby on 5/15/14.
//  Copyright (c) 2014 arrowtop. All rights reserved.
//

#import "CourseViewController.h"
#import "Course.h"
#import "CourseDetailsViewController.h"
#import "BuildingTableViewCell.h"
#import "CourseBookmarkDetailsViewController.h"
#import <QuartzCore/QuartzCore.h>

@interface CourseViewController ()<UITableViewDataSource, UITabBarControllerDelegate>

@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property (weak, nonatomic) IBOutlet UISearchBar *searchBar;
@property (weak, nonatomic) IBOutlet UIButton *recentSearched1;
@property (weak, nonatomic) IBOutlet UIButton *recentSearched2;
@property (weak, nonatomic) IBOutlet UIButton *recentSearched3;
@property (weak, nonatomic) IBOutlet UIScrollView *scrollView;
@property (strong, nonatomic) NSMutableArray *courseBookmarks;

@end

@implementation CourseViewController
{
    NSArray *courses;
    NSArray *searchResults;

}

#define Rgb2UIColor(r, g, b)  [UIColor colorWithRed:((r) / 255.0) green:((g) / 255.0) blue:((b) / 255.0) alpha:1.0]

- (void) viewDidLoad
{
    [super viewDidLoad];
    [self.tableView setHidden:YES];
    self.searchBar.showsCancelButton = YES;
    [self.searchBar setShowsCancelButton:YES animated:YES];
    //self.view.backgroundColor = Rgb2UIColor(247, 247, 247);
    [self fetchData];
    [self checkDocument];
    [self loadRecentSearched];
    [self loadBookmarks];
}

- (void) fetchData
{
    dispatch_queue_t fetchQ = dispatch_queue_create("Course Fetcher", NULL);
    dispatch_async(fetchQ, ^{
        NSString* dataPath = [[NSBundle mainBundle] pathForResource:@"course" ofType:@"json"];
        courses = [NSJSONSerialization JSONObjectWithData:[NSData dataWithContentsOfFile:dataPath]
                                                  options:0
                                                    error:nil];
    });
}

- (void) saveData
{
    [courses enumerateObjectsUsingBlock:^(id obj, NSUInteger idx, BOOL *stop) {
        Course *course = [NSEntityDescription
                          insertNewObjectForEntityForName:@"Course"
                          inManagedObjectContext:self.document.managedObjectContext];
        course.courseId = [obj objectForKey:@"courseId"];
        course.name = [obj objectForKey:@"name"];
        course.number = [obj objectForKey:@"number"];
        course.professor = [obj objectForKey:@"professor"];
        course.time = [obj objectForKey:@"time"];
        course.buildingCode = [obj objectForKey:@"buildingCode"];
        course.room = [obj objectForKey:@"room"];
        
        NSError *error;
        if (![self.document.managedObjectContext save:&error]) {
            NSLog(@"Whoops, couldn't save: %@", [error localizedDescription]);
        }
        
        NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
        
        [userDefaults setBool:YES forKey:@"saveData2"];
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
            if (![[NSUserDefaults standardUserDefaults] objectForKey:@"saveData2"])
                [self saveData];
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
    NSFetchRequest *request = [NSFetchRequest fetchRequestWithEntityName: @"Course"];
    request.predicate = [NSPredicate predicateWithFormat:@"courseId beginswith[c] %@ OR name beginswith[c] %@", searchText, searchText];
    request.sortDescriptors = @[[NSSortDescriptor sortDescriptorWithKey:@"name" ascending:YES]];
    NSError *error;
    searchResults = [self.document.managedObjectContext executeFetchRequest:request error:&error];    
}

-(void)searchBar:(UISearchBar *)searchBar textDidChange:(NSString *)searchText
{
    [self filterContentForSearchText:searchText];
    [self.tableView reloadData];
}


- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return [searchResults count] != 0? [searchResults count] : [courses count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"CourseCell";
    BuildingTableViewCell *cell = (BuildingTableViewCell *)[self.tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    
    // Configure the cell...
    if (cell == nil) {
        cell = [[BuildingTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
    }
    
    // Display details in the table cell
    
    if ([searchResults count] != 0) {
        cell.buildingCode.text = [[searchResults objectAtIndex:indexPath.row] valueForKey:@"courseId"];
        cell.buildingName.text = [[searchResults objectAtIndex:indexPath.row] valueForKey:@"name"];
    } else {
        cell.buildingCode.text = [[courses objectAtIndex:indexPath.row] valueForKey:@"courseId"];
        cell.buildingName.text = [[courses objectAtIndex:indexPath.row] valueForKey:@"name"];
    }
    
    return cell;
    
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    CourseDetailsViewController *cdvc = [self.storyboard instantiateViewControllerWithIdentifier:@"CourseDetailsViewController"];
    NSManagedObject *course;
    if ([searchResults count] != 0) {
        course = [searchResults objectAtIndex:indexPath.row];
        
    } else {
        course = [courses objectAtIndex:indexPath.row];
    }
    NSString *courseMark = [NSString stringWithFormat:@"%@",[course valueForKey:@"courseId"]];
    [self saveRecentSearched: courseMark];
    cdvc.course = (Course *)course;
    [self.tableView deselectRowAtIndexPath:indexPath animated:YES];
    [self.navigationController setNavigationBarHidden:NO];
    [self.navigationController pushViewController:cdvc animated:YES];
}

- (void)searchBarCancelButtonClicked:(UISearchBar *)searchBar
{
    searchBar.text = @"";
    [searchBar resignFirstResponder];
    [self.tableView setHidden:YES];
}

#pragma mark - search history & bookmarks
- (void) loadRecentSearched
{
    NSString *recentSearchedKey1 = @"recentSearchedKey1";
    NSString *recentSearchedKey2 = @"recentSearchedKey2";
    NSString *recentSearchedKey3 = @"recentSearchedKey3";
    NSString *recentSearchedValue1 = (NSString *)[[NSUserDefaults standardUserDefaults] objectForKey:recentSearchedKey1];
    NSString *recentSearchedValue2 = (NSString *)[[NSUserDefaults standardUserDefaults] objectForKey:recentSearchedKey2];
    NSString *recentSearchedValue3 = (NSString *)[[NSUserDefaults standardUserDefaults] objectForKey:recentSearchedKey3];
    if (recentSearchedValue1 == nil) {
        [self.recentSearched1 setHidden:true];
    } else {
        [self.recentSearched1 setTitle:recentSearchedValue1 forState:UIControlStateNormal];
    }
    if (recentSearchedValue2 == nil) {
        [self.recentSearched2 setHidden:true];
    } else {
        [self.recentSearched2 setTitle:recentSearchedValue2 forState:UIControlStateNormal];
    }
    if (recentSearchedValue3 == nil) {
        [self.recentSearched3 setHidden:true];
    } else {
        [self.recentSearched3 setTitle:recentSearchedValue3 forState:UIControlStateNormal];
    }
}

- (void) saveRecentSearched: (NSString *) courseMark
{
    NSString *recentSearchedKey1 = @"recentSearchedKey1";
    NSString *recentSearchedKey2 = @"recentSearchedKey2";
    NSString *recentSearchedKey3 = @"recentSearchedKey3";
    NSString *recentSearchedValue1 = (NSString *)[[NSUserDefaults standardUserDefaults] objectForKey:recentSearchedKey1];
    NSString *recentSearchedValue2 = (NSString *)[[NSUserDefaults standardUserDefaults] objectForKey:recentSearchedKey2];
    NSString *recentSearchedValue3 = (NSString *)[[NSUserDefaults standardUserDefaults] objectForKey:recentSearchedKey3];
    if (recentSearchedValue1 == nil) {
        NSDictionary *appDefaults  = [NSDictionary dictionaryWithObjectsAndKeys:courseMark, recentSearchedKey1, nil];

        [[NSUserDefaults standardUserDefaults] registerDefaults:appDefaults];
        [[NSUserDefaults standardUserDefaults] synchronize];
    } else if (recentSearchedValue2 == nil) {
        NSDictionary *appDefaults  = [NSDictionary dictionaryWithObjectsAndKeys:courseMark, recentSearchedKey2, nil];
        
        [[NSUserDefaults standardUserDefaults] registerDefaults:appDefaults];
        [[NSUserDefaults standardUserDefaults] synchronize];

    } else if (recentSearchedValue3 == nil) {
        NSDictionary *appDefaults  = [NSDictionary dictionaryWithObjectsAndKeys:courseMark, recentSearchedKey3, nil];
        
        [[NSUserDefaults standardUserDefaults] registerDefaults:appDefaults];
        [[NSUserDefaults standardUserDefaults] synchronize];
    } else {
        [[NSUserDefaults standardUserDefaults] setObject:recentSearchedValue2 forKey:recentSearchedKey1];
        [[NSUserDefaults standardUserDefaults] setObject:recentSearchedValue3 forKey:recentSearchedKey2];
        [[NSUserDefaults standardUserDefaults] setObject:courseMark forKey:recentSearchedKey3];
    }
}

#define COURSE_BOOKMARKS_KEY @"courseBookmarks"
#define MAX_BOOKMARKS_NUMBER 2
#define BUTTON_WIDTH 320
#define BUTTON_HEIGHT 56
#define BUTTON_HEIGHT_OFFSET 8

- (NSMutableArray *)courseBookmarks {
    if (!_courseBookmarks) {
        _courseBookmarks = (NSMutableArray *)[[NSUserDefaults standardUserDefaults] objectForKey:COURSE_BOOKMARKS_KEY];
    }
    return _courseBookmarks;
}

- (void)loadBookmarks
{
    for (int i = 0; i < [self.courseBookmarks count]; i++){
        UIButton *button = [[UIButton alloc] initWithFrame: CGRectMake(0, BUTTON_HEIGHT*i, BUTTON_WIDTH, BUTTON_HEIGHT+BUTTON_HEIGHT_OFFSET)];
        [self.scrollView addSubview:button];
        [button setTag: i];
        [button addTarget:self action:@selector(buttonPressed:) forControlEvents:UIControlEventTouchUpInside];
        NSDictionary *course = [self.courseBookmarks objectAtIndex: i];
        NSString *courseMark = [NSString stringWithFormat:@"%@: %@", [course valueForKey:@"courseId"], [course valueForKey:@"name"]];
        button.titleLabel.text = courseMark;
        [button setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        [button setTitle:courseMark forState:UIControlStateNormal];
        
        button.backgroundColor = (i % 2 == 0) ? Rgb2UIColor(142, 142, 147) : Rgb2UIColor(120, 189, 254);
        button.layer.cornerRadius = BUTTON_HEIGHT_OFFSET;
        button.contentVerticalAlignment = UIControlContentVerticalAlignmentTop;
        [button setTag: i];
    }
}

#pragma mark - Navigation

-(void)buttonPressed:(UIButton *)sender {
    long index = sender.tag;
    CourseBookmarkDetailsViewController *cbdvc = [self.storyboard instantiateViewControllerWithIdentifier:@"CourseBookmarkDetailsViewController"];
    cbdvc.course = [self.courseBookmarks objectAtIndex:index];
    cbdvc.tabColor = (index % 2 == 0) ? Rgb2UIColor(142, 142, 147) : Rgb2UIColor(120, 189, 254);
    cbdvc.btnColor = (index % 2 != 0) ? Rgb2UIColor(142, 142, 147) : Rgb2UIColor(120, 189, 254);
    [self presentViewController:cbdvc animated:YES completion:nil];
}
@end


//
//  CourseDetailsViewController.m
//  StevensStudent
//
//  Created by toby on 4/30/14.
//  Copyright (c) 2014 arrowtop. All rights reserved.
//

#import "CourseDetailsViewController.h"

@interface CourseDetailsViewController ()
@property (weak, nonatomic) IBOutlet UILabel *idLabel;
@property (weak, nonatomic) IBOutlet UILabel *numberLabel;
@property (weak, nonatomic) IBOutlet UILabel *professorLabel;
@property (weak, nonatomic) IBOutlet UILabel *timeLabel;
@property (weak, nonatomic) IBOutlet UILabel *buildingLabel;
@property (weak, nonatomic) IBOutlet UILabel *roomLabel;
@property (strong, nonatomic) NSMutableArray *courseBookmarks;
@property (weak, nonatomic) IBOutlet UIButton *bookmarkButton;

@end

@implementation CourseDetailsViewController
{
    bool isBookmarked;
    int positionInBookmarks;
}

- (void)viewDidLoad
{
    self.title = [NSString stringWithFormat:@"%@", [self.course valueForKey:@"name"]];
    self.idLabel.text = [NSString stringWithFormat:@"%@", [self.course valueForKey:@"courseId"]];
    self.numberLabel.text = [NSString stringWithFormat:@"%@", [self.course valueForKey:@"number"]];
    self.professorLabel.text = [NSString stringWithFormat:@"%@", [self.course valueForKey:@"professor"]];
    self.timeLabel.text = [NSString stringWithFormat:@"%@", [self.course valueForKey:@"time"]];
    self.buildingLabel.text = [NSString stringWithFormat:@"%@", [self.course valueForKey:@"buildingCode"]];
    self.roomLabel.text = [NSString stringWithFormat:@"%@", [self.course valueForKey:@"room"]];
    [self checkBookmark];
}

- (void) checkBookmark {
    for(int i = 0; i < [self.courseBookmarks count]; i++) {
        NSDictionary *bookmark = [self.courseBookmarks objectAtIndex:i];
        if ([[bookmark valueForKey:@"number"] isEqualToString: [self.course valueForKey:@"number"]]) {
            isBookmarked = true;
            [self.bookmarkButton setTitle:@"Remove Bookmark" forState:UIControlStateNormal];
            positionInBookmarks = i;
            break;
        }
    }
}

#define COURSE_BOOKMARKS_KEY @"courseBookmarks"
#define MAX_BOOKMARKS_NUMBER 5
- (NSMutableArray *)courseBookmarks {
    if (!_courseBookmarks) {
        NSMutableArray *courseBookmarkArray = (NSMutableArray *)[[NSUserDefaults standardUserDefaults] objectForKey:COURSE_BOOKMARKS_KEY];
        if (courseBookmarkArray  == nil) {
            courseBookmarkArray  = [[NSMutableArray alloc] init];
            NSDictionary *appDefaults  = [NSDictionary dictionaryWithObjectsAndKeys:courseBookmarkArray , COURSE_BOOKMARKS_KEY, nil];
            [[NSUserDefaults standardUserDefaults] registerDefaults:appDefaults];
            [[NSUserDefaults standardUserDefaults] synchronize];
        }
        _courseBookmarks = [courseBookmarkArray mutableCopy];
    }
    return _courseBookmarks;
}

- (IBAction)bookmarkCourse:(id)sender {
    if(isBookmarked) {
        [self.courseBookmarks removeObjectAtIndex:positionInBookmarks];
        [[NSUserDefaults standardUserDefaults] setObject:self.courseBookmarks forKey:COURSE_BOOKMARKS_KEY];
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Success"
                                                        message:[NSString stringWithFormat:@"Bookmark Removed!"]
                                                       delegate:nil
                                              cancelButtonTitle:@"OK"
                                              otherButtonTitles:nil];
        [alert show];
        isBookmarked = false;
        [self.bookmarkButton setTitle:@"Bookmark This Course" forState:UIControlStateNormal];
    }
    else {
        if ([self.courseBookmarks count] < MAX_BOOKMARKS_NUMBER) {
            NSDictionary *courseDictionary = [[NSDictionary alloc]
                                         initWithObjectsAndKeys:[self.course valueForKey:@"name"],@"name",
                                         [self.course valueForKey:@"number"],@"number",
                                         [self.course valueForKey:@"professor"],@"professor",
                                         [self.course valueForKey:@"courseId"],@"courseId",
                                         [self.course valueForKey:@"time"],@"time",
                                         [self.course valueForKey:@"buildingCode"],@"buildingCode",
                                         [self.course valueForKey:@"room"],@"room",
                                         nil];
            [self.courseBookmarks addObject:courseDictionary];
            [[NSUserDefaults standardUserDefaults] setObject:self.courseBookmarks forKey:COURSE_BOOKMARKS_KEY];
            UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Success"
                                                            message:[NSString stringWithFormat:@"Bookmark Added!"]
                                                           delegate:nil
                                                  cancelButtonTitle:@"OK"
                                                  otherButtonTitles:nil];
            [alert show];
            [self checkBookmark];
            
        } else {
            UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Sorry"
                                                            message:[NSString stringWithFormat:@"You can only add up to %d bookmarks!", MAX_BOOKMARKS_NUMBER]
                                                           delegate:nil
                                                  cancelButtonTitle:@"OK"
                                                  otherButtonTitles:nil];
            [alert show];
        }
    }
}

- (IBAction)segueBuilding:(id)sender {
    
}

@end

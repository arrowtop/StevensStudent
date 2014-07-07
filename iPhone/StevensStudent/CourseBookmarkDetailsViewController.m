//
//  CourseBookmarkDetailsViewController.m
//  StevensStudent
//
//  Created by toby on 5/22/14.
//  Copyright (c) 2014 arrowtop. All rights reserved.
//

#import "CourseBookmarkDetailsViewController.h"

@interface CourseBookmarkDetailsViewController ()
@property (weak, nonatomic) IBOutlet UILabel *titleLabel;
@property (weak, nonatomic) IBOutlet UILabel *idLabel;
@property (weak, nonatomic) IBOutlet UILabel *numberLabel;
@property (weak, nonatomic) IBOutlet UILabel *professorLabel;
@property (weak, nonatomic) IBOutlet UILabel *timeLabel;
@property (weak, nonatomic) IBOutlet UILabel *buildingLabel;
@property (weak, nonatomic) IBOutlet UILabel *roomLabel;
@property (weak, nonatomic) IBOutlet UIView *topView;

@end

@implementation CourseBookmarkDetailsViewController

- (void)viewDidLoad
{
    self.titleLabel.text = [NSString stringWithFormat:@"%@", [self.course valueForKey:@"name"]];
    self.idLabel.text = [NSString stringWithFormat:@"%@", [self.course valueForKey:@"courseId"]];
    self.numberLabel.text = [NSString stringWithFormat:@"%@", [self.course valueForKey:@"number"]];
    self.professorLabel.text = [NSString stringWithFormat:@"%@", [self.course valueForKey:@"professor"]];
    self.timeLabel.text = [NSString stringWithFormat:@"%@", [self.course valueForKey:@"time"]];
    self.buildingLabel.text = [NSString stringWithFormat:@"%@", [self.course valueForKey:@"buildingCode"]];
    self.roomLabel.text = [NSString stringWithFormat:@"%@", [self.course valueForKey:@"room"]];
    self.topView.backgroundColor = self.tabColor;
}

- (IBAction)done
{
    [self.presentingViewController dismissViewControllerAnimated:YES completion:nil];
}


@end

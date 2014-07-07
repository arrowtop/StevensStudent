//
//  BuildingDetailsViewController.m
//  StevensStudent
//
//  Created by toby on 5/22/14.
//  Copyright (c) 2014 arrowtop. All rights reserved.
//

#import "BuildingDetailsViewController.h"
#import "MapViewController.h"

@interface BuildingDetailsViewController ()
@property (weak, nonatomic) IBOutlet UIImageView *imageView;
@property (weak, nonatomic) IBOutlet UITextView *textView;

@end

@implementation BuildingDetailsViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    //[self setRightBarButtonItem];
    [self loadData];
}

- (void) loadData
{
    self.textView.text = @"Located at the Stevens Institute of Technology is the 8-story Burchard Memorial Science and Engineering Building from 1957. The facade features horizontal bands of windows alternating with pale brick bands. The secondary facades and base of the building are clad in red brick. The building’s metal signage to the right of the recessed entrance also looks original.";
    NSString *imageTitle = [NSString stringWithFormat: @"burchard.png"];
    self.imageView.image = [UIImage imageNamed:imageTitle];
}

/*
- (void) setRightBarButtonItem
{
    UIBarButtonItem *rButton =[[UIBarButtonItem alloc] init];
    rButton.image = [UIImage imageNamed:@"map2.png"];
    [rButton setTarget:self];
    [rButton setAction:@selector(segueToMap)];
    self.navigationItem.rightBarButtonItem=rButton;
}

#pragma mark - Navigation
- (void) segueToMap
{
    MapViewController *mapvc = [self.storyboard instantiateViewControllerWithIdentifier:@"MapViewController"];
    
    mapvc.segueResult = self.segueResult;
    mapvc.segueLongitude = self.segueLongitude;
    mapvc.segueLatitude = self.segueLatitude;
    
    [self.navigationController setNavigationBarHidden:NO];
    [self.navigationController pushViewController:mapvc animated:YES];
}
*/

@end

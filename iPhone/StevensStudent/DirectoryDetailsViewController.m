//
//  DirectoryDetailsViewController.m
//  StevensStudent
//
//  Created by toby on 4/30/14.
//  Copyright (c) 2014 arrowtop. All rights reserved.
//

#import "DirectoryDetailsViewController.h"

@interface DirectoryDetailsViewController ()

@property (weak, nonatomic) IBOutlet UILabel *titleLabel;
@property (weak, nonatomic) IBOutlet UILabel *buildingLabel;
@property (weak, nonatomic) IBOutlet UILabel *roomLabel;
@property (weak, nonatomic) IBOutlet UILabel *phoneLabel;
@property (weak, nonatomic) IBOutlet UILabel *emailLabel;
@property (weak, nonatomic) IBOutlet UILabel *faxLabel;
@property (weak, nonatomic) IBOutlet UILabel *schoolLabel;
@property (weak, nonatomic) IBOutlet UILabel *depLabel;


@end

@implementation DirectoryDetailsViewController

- (void) viewDidLoad
{
    [super viewDidLoad];
    self.titleLabel.text = self.pTitle;
    self.buildingLabel.text = self.pBuilding;
    self.roomLabel.text = self.pRoom;
    self.phoneLabel.text = self.pPhone;
    self.emailLabel.text = self.pEmail;
    self.faxLabel.text = self.pFax;
    self.schoolLabel.text = self.pSchool;
    self.depLabel.text = self.pDep;
}

- (IBAction)callPhone:(id)sender {
    NSString *call = [@"tel:" stringByAppendingString:self.pPhone];
    [[UIApplication sharedApplication] openURL:[NSURL URLWithString:call]];
}

- (IBAction)sendEmail:(id)sender {
    NSString *email = [@"mailto:" stringByAppendingString:self.pEmail];
    [[UIApplication sharedApplication] openURL:[NSURL URLWithString:email]];
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end

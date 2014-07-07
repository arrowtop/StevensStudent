//
//  AboutViewController.m
//  StevensStudent
//
//  Created by toby on 4/30/14.
//  Copyright (c) 2014 arrowtop. All rights reserved.
//

#import "AboutViewController.h"
#import <MediaPlayer/MediaPlayer.h>
#import <MobileCoreServices/MobileCoreServices.h>

@interface AboutViewController ()

@property (nonatomic,strong) MPMoviePlayerController* moviePlayerController;

@end

@implementation AboutViewController

- (void) viewDidLoad
{
    //Best practice
    [super viewDidLoad];
    NSURL *url = [[NSBundle mainBundle] URLForResource:@"movie" withExtension:@"mp4"];
    self.moviePlayerController = [[MPMoviePlayerController alloc] initWithContentURL:url];
    [self.moviePlayerController setShouldAutoplay:NO];
    [self.moviePlayerController prepareToPlay];
    [self.moviePlayerController setFullscreen:YES];
    [self.moviePlayerController.view setFrame:self.view.bounds];
    [self.view addSubview:self.moviePlayerController.view];
}

- (void)viewWillLayoutSubviews
{
    [self.moviePlayerController.view setFrame:self.view.bounds];

}

-(BOOL)shouldAutorotate {
    return YES;
}

- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
    
    if (self.isMovingFromParentViewController || self.isBeingDismissed) {
        [self.moviePlayerController stop];
    }
}


@end

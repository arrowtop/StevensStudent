//
//  LinkViewController.m
//  StevensStudent
//
//  Created by toby on 5/1/14.
//  Copyright (c) 2014 arrowtop. All rights reserved.
//

#import "LinkViewController.h"
#import "WebViewController.h"

@interface LinkViewController ()

@property (strong, nonatomic) UIScrollView *scrollView;
//@property (strong, nonatomic) NSMutableArray *buttons;

@end

@implementation LinkViewController
{
    int button_number;
    NSArray *buttonTitle;
    NSArray *webUrl;
}

- (UIImage *)applyBlurOnImage: (UIImage *)imageToBlur withRadius: (CGFloat)blurRadius
{
    CIImage *image = [CIImage imageWithCGImage:imageToBlur.CGImage];
    CIFilter *gaussianBlurFilter = [CIFilter filterWithName: @"CIGaussianBlur"];
    [gaussianBlurFilter setValue:image forKeyPath:@"inputImage"];
    [gaussianBlurFilter setValue:[NSNumber numberWithFloat: blurRadius] forKeyPath:@"inputRadius"];
    CIImage *filteredImage = [gaussianBlurFilter valueForKey:@"outputImage"];
    
    UIImage *blurredImage = [[UIImage alloc] initWithCIImage:filteredImage];
    
    return blurredImage;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    //Get the backgroundImage and apply blur on it
    UIImage *image = [UIImage imageNamed:@"stevens1.png"];
    UIImage *backgroundImage = [self applyBlurOnImage: image withRadius:10];
    
    //Place the UIImage in a UIImageView
    UIImageView *backgroundImageView = [[UIImageView alloc] initWithImage:backgroundImage];
    
    [self.view addSubview:backgroundImageView];
    [self.view sendSubviewToBack:backgroundImageView];

    
    button_number = 6;
    buttonTitle = @[@"Graduate Admissions", @"Undergraduate Admissions", @"Mystevens", @"Moodle", @"Campus Life", @"Library"];
    webUrl = @[@"http://www.stevens.edu/sit/graduate", @"http://www.stevens.edu/sit/admissions", @"http://www.stevens.edu/mystevens", @"http://moodle.stevens.edu", @"http://ugstudentlife.stevens.edu/",@"http://www.stevens.edu/library"];
    [self addView];
}

#define NEVIGATION_BAR_HEIGHT 75
#define BUTTON_WIDTH 320
#define BUTTON_HEIGHT 70
#define BUTTON_OFFSET 10

- (void)addView
{
    self.scrollView = [[UIScrollView alloc] initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, self.view.frame.size.height)];
    
    for (int i = 0; i < button_number; i++){
        UIButton *button = [[UIButton alloc] initWithFrame: CGRectMake(0, NEVIGATION_BAR_HEIGHT + (BUTTON_HEIGHT + BUTTON_OFFSET) * i, BUTTON_WIDTH, BUTTON_HEIGHT)];
        [self.scrollView addSubview:button];
        [button setTag: i];
        [button addTarget:self action:@selector(buttonPressed:) forControlEvents:UIControlEventTouchUpInside];
        NSString *imageTitle = [NSString stringWithFormat: @"%@.png", [buttonTitle objectAtIndex:i]];
        UIImage *graduate_admission_i = [UIImage imageNamed:imageTitle];
        [button setImage:graduate_admission_i forState:UIControlStateNormal];
    }
    
    [self.view addSubview:self.scrollView];
    
    CGRect contentRect = CGRectZero;
    for (UIView *view in self.scrollView.subviews)
        contentRect = CGRectUnion(contentRect, view.frame);
    self.scrollView.contentSize = contentRect.size;
    [self.view addSubview:self.scrollView];
        
}

#pragma mark - Navigation

-(void)buttonPressed:(UIButton *)sender {
    long index = sender.tag;
    WebViewController *wvc = [self.storyboard instantiateViewControllerWithIdentifier:@"WebViewController"];
    wvc.url = [NSURL URLWithString:[NSString stringWithFormat:@"%@", [webUrl objectAtIndex:index]]];
    wvc.title_name = [NSString stringWithFormat:@"%@", [buttonTitle objectAtIndex:index]];
    [self.navigationController setNavigationBarHidden:NO];
    [self.navigationController pushViewController:wvc animated:YES];
}

@end

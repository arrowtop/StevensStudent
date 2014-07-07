//
//  StevensStudentViewController.m
//  StevensStudent
//
//  Created by toby on 4/23/14.
//  Copyright (c) 2014 arrowtop. All rights reserved.
//

#import "StevensStudentViewController.h"
#import "NewsViewController.h"
#import "WebViewController.h"
#import "EventViewController.h"
#import "CalculatorViewController.h"
#import "CourseViewController.h"
#import "DirectoryViewController.h"
#import "ScannerViewController.h"
#import "MapViewController.h"
#import "LinkViewController.h"
#import "AboutViewController.h"
#import "FeedbackViewController.h"

@interface StevensStudentViewController ()<UIActionSheetDelegate, UIScrollViewDelegate, UIAlertViewDelegate>

@property (strong, nonatomic) UIScrollView *scrollView;
@property (nonatomic, strong) UIPageControl *pageControl;

@property (nonatomic, strong) UILabel *navTitleLabel1;
@property (nonatomic, strong) UILabel *navTitleLabel2;

@end

@implementation StevensStudentViewController
{
    NSArray *btnsForView1;
    NSArray *btnsForView2;
    NSArray *urlsForView2;
    NSURL *itunes_url;
}

#pragma mark - View Initialization

- (void) viewDidLoad
{
    [super viewDidLoad];
    
    //Get the backgroundImage and apply blur on it
    UIImage *image = [UIImage imageNamed:@"stevens1.png"];
    UIImage *backgroundImage = [self applyBlurOnImage: image withRadius:10];

    //Place the UIImage in a UIImageView
    UIImageView *backgroundImageView = [[UIImageView alloc] initWithImage:backgroundImage];
    
    [self.view addSubview:backgroundImageView];
    [self.view sendSubviewToBack:backgroundImageView];
    [self checkDocument];
}

- (void) viewWillAppear:(BOOL)animated
{
    self.navTitleLabel1.hidden = NO;
    self.pageControl.hidden = NO;
}

#define BUTTON_START_WIDTH 20
#define BUTTON_START_HEIGHT 120
#define BUTTON_WIDTH 60
#define BUTTON_HEIGHT 60
#define LABEL_START_HEIGHT 180
#define WIDTH_OFFSET 110
#define HEIGHT_OFFSET 93
#define LABEL_WIDTH 60
#define LABEL_HEIGHT 17
#define Rgb2UIColor(r, g, b)  [UIColor colorWithRed:((r) / 255.0) green:((g) / 255.0) blue:((b) / 255.0) alpha:1.0]

- (void)loadView
{
    [super loadView];
    self.scrollView = [[UIScrollView alloc] initWithFrame:self.view.frame];
    //btnsForView1 = @[@"News", @"Athletics", @"Event", @"Calculator", @"Courses", @"Directory", @"Scanner", @"Map", @"Links", @"About", @"Dining"];
    btnsForView1 = @[@"Athletics",@"Courses", @"Directory", @"Scanner", @"Map", @"Links", @"About"];
    btnsForView2 = @[@"Stevens", @"Duckbills", @"Shuttle", @"Booktrade"];
    urlsForView2 = @[@"https://itunes.apple.com/us/app/stevens-institute-technology/id372838640?mt=8", @"https://itunes.apple.com/us/app/stevens-duckbills/id829826784?mt=8", @"https://itunes.apple.com/us/app/transloc-rider-transit-tracking/id751972942?mt=8", @"https://itunes.apple.com/us/app/stevens-book-exchange/id637194526?mt=8"];
    self.scrollView.pagingEnabled = YES;
    self.scrollView.showsHorizontalScrollIndicator = NO;
    self.scrollView.delegate = self;
    self.scrollView.bounces = NO;
    self.scrollView.contentSize = (CGSize){320*2, CGRectGetHeight(self.view.frame)};
    [self.view addSubview:self.scrollView];

    UIView *page1View = [UIView new];
    page1View.frame = (CGRect){0, 0, 320, CGRectGetHeight(self.view.frame)};
    
    for (int i = 0; i < [btnsForView1 count]; i++) {
        int column = i % 3;
        int row = (i - column)/3;
        UIButton *button = [[UIButton alloc] initWithFrame: CGRectMake(BUTTON_START_WIDTH + WIDTH_OFFSET * column, BUTTON_START_HEIGHT + HEIGHT_OFFSET * row, BUTTON_WIDTH, BUTTON_HEIGHT)];
        [page1View addSubview:button];
        UILabel *label = [[UILabel alloc] initWithFrame: CGRectMake(BUTTON_START_WIDTH + WIDTH_OFFSET * column, LABEL_START_HEIGHT + HEIGHT_OFFSET * row, LABEL_WIDTH, LABEL_HEIGHT)];
        [button setTag: i];
        [button addTarget:self action:@selector(buttonPressed1:) forControlEvents:UIControlEventTouchUpInside];
        NSString *imageTitle = [NSString stringWithFormat: @"%@.png", [btnsForView1 objectAtIndex:i]];
        UIImage *btn_image = [UIImage imageNamed:imageTitle];
        [button setImage:btn_image forState:UIControlStateNormal];
        label.font = [UIFont fontWithName:@"Arial-BoldMT" size:12];
        label.text = [NSString stringWithFormat: @"%@", [btnsForView1 objectAtIndex:i]];
        label.textAlignment = NSTextAlignmentCenter;
        [page1View addSubview:label];

    }
    [self.scrollView addSubview:page1View];
    
    UIView *page2View = [UIView new];
    page2View.frame = (CGRect){320, 0, 320, CGRectGetHeight(self.view.frame)};
    for (int i = 0; i < [btnsForView2 count]; i++) {
        int column = i % 3;
        int row = (i - column)/3;
        UIButton *button = [[UIButton alloc] initWithFrame: CGRectMake(BUTTON_START_WIDTH + WIDTH_OFFSET * column, BUTTON_START_HEIGHT + HEIGHT_OFFSET * row, BUTTON_WIDTH, BUTTON_HEIGHT)];
        [page2View addSubview:button];
        UILabel *label = [[UILabel alloc] initWithFrame: CGRectMake(BUTTON_START_WIDTH + WIDTH_OFFSET * column, LABEL_START_HEIGHT + HEIGHT_OFFSET * row, LABEL_WIDTH, LABEL_HEIGHT)];
        [button setTag: i];
        [button addTarget:self action:@selector(buttonPressed2:) forControlEvents:UIControlEventTouchUpInside];
        NSString *imageTitle = [NSString stringWithFormat: @"%@.png", [btnsForView2 objectAtIndex:i]];
        UIImage *btn_image = [UIImage imageNamed:imageTitle];
        [button setImage:btn_image forState:UIControlStateNormal];
        label.font = [UIFont fontWithName:@"Arial-BoldMT" size:12];
        label.text = [NSString stringWithFormat: @"%@", [btnsForView2 objectAtIndex:i]];
        label.textAlignment = NSTextAlignmentCenter;
        [page2View addSubview:label];
        
    }
    [self.scrollView addSubview:page2View];
    
    self.navTitleLabel1 = [UILabel new];
    self.navTitleLabel1.text = @"Home";
    self.navTitleLabel1.frame = (CGRect){130, 8, 160, 20};
    self.navTitleLabel1.textColor = [UIColor whiteColor];
    [self.navigationController.navigationBar addSubview:self.navTitleLabel1];
    
    self.navTitleLabel2 = [UILabel new];
    self.navTitleLabel2.text = @"Other Apps";
    self.navTitleLabel2.frame = (CGRect){210, 8, 160, 20};
    self.navTitleLabel2.textColor = [UIColor whiteColor];
    self.navTitleLabel2.alpha = 0;
    [self.navigationController.navigationBar addSubview:self.navTitleLabel2];

    self.pageControl = [[UIPageControl alloc] init];
    self.pageControl.frame = (CGRect){153, 35, 0, 0};
    self.pageControl.numberOfPages = 2;
    self.pageControl.currentPage = 0;
    self.pageControl.currentPageIndicatorTintColor = [UIColor whiteColor];
    self.pageControl.pageIndicatorTintColor = Rgb2UIColor(209, 238, 252);
    [self.navigationController.navigationBar addSubview:self.pageControl];

}

- (void)scrollViewDidScroll:(UIScrollView *)scrollView {
    
    CGFloat xOffset = scrollView.contentOffset.x;
    
    self.navTitleLabel1.frame = (CGRect){130 - xOffset/3.2, 8, 160, 20};
    self.navTitleLabel2.frame = (CGRect){210 - xOffset/3.2, 8, 160, 20};
    
    self.navTitleLabel1.alpha = 1 - xOffset / 320;
    if (xOffset <= 320) {
        self.navTitleLabel2.alpha = xOffset / 320;
    } else {
        self.navTitleLabel2.alpha = 1 - (xOffset - 320) / 320;
    }

}

- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView {
    
    CGFloat xOffset = scrollView.contentOffset.x;
    
    if (xOffset < 1.0) {
        self.pageControl.currentPage = 0;
    } else {
        self.pageControl.currentPage = 1;
    }
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

- (IBAction)setting:(id)sender {
    UIActionSheet *actionSheet = [[UIActionSheet alloc] initWithTitle:@"Setting" delegate:self cancelButtonTitle:@"Cancel" destructiveButtonTitle:nil otherButtonTitles:@"Clear All Saved Bookmarks", @"Send Feedback", nil];
    
    actionSheet.actionSheetStyle = UIActionSheetStyleDefault;
    [actionSheet showInView:self.view];
}

- (void)actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex
{
    switch (buttonIndex)
    {
        case 0:
            break;
        case 1:
            [self feedback];
            break;
    } 
}
-(void)feedback {
    FeedbackViewController *fvc = [self.storyboard instantiateViewControllerWithIdentifier:@"FeedbackViewController"];
    [self presentViewController:fvc animated:YES completion:nil];
}

- (UIManagedDocument *)document
{
    if (!_document) {
        NSFileManager *fileManager = [NSFileManager defaultManager];
        NSURL *documentsDirectory = [[fileManager URLsForDirectory:NSDocumentDirectory inDomains:NSUserDomainMask] firstObject];
        NSString *documentName = @"StevensDocument";
        self.url = [documentsDirectory URLByAppendingPathComponent:documentName];
        _document = [[UIManagedDocument alloc] initWithFileURL: self.url];
    }
    return _document;
}

- (void)checkDocument {
    
    BOOL fileExists = [[NSFileManager defaultManager] fileExistsAtPath:[self.url path]];
    if (!fileExists){
        [self.document saveToURL:self.url forSaveOperation:UIDocumentSaveForCreating completionHandler:^(BOOL success) {
            
        }];
    } else {
        [self.document openWithCompletionHandler:^(BOOL success) {
            
        }];
    }
}

#pragma mark - Navigation

#define STEVENS_ATHLETICS_URL "http://www.stevensducks.com"
#define STEVENS_ATHLETICS_TITLE "Athletics"

-(void)buttonPressed1:(UIButton *)sender {
    
    long index = sender.tag;
    /*
    if (index == 0) {
        NewsViewController *nvc = [self.storyboard instantiateViewControllerWithIdentifier:@"NewsViewController"];
        [self.navigationController setNavigationBarHidden:NO];
        [self.navigationController pushViewController:nvc animated:YES];
    }
     */
    if (index == 0) {
        WebViewController *wvc = [self.storyboard instantiateViewControllerWithIdentifier:@"WebViewController"];
        wvc.url = [NSURL URLWithString:[NSString stringWithFormat:@"%s", STEVENS_ATHLETICS_URL]];
        wvc.title_name = [NSString stringWithFormat:@"%s", STEVENS_ATHLETICS_TITLE];
        [self.navigationController setNavigationBarHidden:NO];
        [self.navigationController pushViewController:wvc animated:YES];
    }
    /*
    if (index == 2) {
        EventViewController *evc = [self.storyboard instantiateViewControllerWithIdentifier:@"EventViewController"];
        [self.navigationController setNavigationBarHidden:NO];
        [self.navigationController pushViewController:evc animated:YES];
    }
    if (index == 3) {
        CalculatorViewController *cvc = [self.storyboard instantiateViewControllerWithIdentifier:@"CalculatorViewController"];
        [self.navigationController setNavigationBarHidden:NO];
        [self.navigationController pushViewController:cvc animated:YES];
    }
     */
    if (index == 1) {
        CourseViewController *cvc = [self.storyboard instantiateViewControllerWithIdentifier:@"CourseViewController"];
        cvc.document = self.document;
        cvc.url = self.url;
        [self.navigationController setNavigationBarHidden:NO];
        [self.navigationController pushViewController:cvc animated:YES];
    }
    if (index == 2) {
        DirectoryViewController *dvc = [self.storyboard instantiateViewControllerWithIdentifier:@"DirectoryViewController"];
        dvc.document = self.document;
        dvc.url = self.url;
        [self.navigationController setNavigationBarHidden:NO];
        [self.navigationController pushViewController:dvc animated:YES];
    }
    if (index == 3) {
        ScannerViewController *svc = [self.storyboard instantiateViewControllerWithIdentifier:@"ScannerViewController"];
        [self.navigationController setNavigationBarHidden:NO];
        [self.navigationController pushViewController:svc animated:YES];
    }
    if (index == 4) {
        MapViewController *mvc = [self.storyboard instantiateViewControllerWithIdentifier:@"MapViewController"];
        [self.navigationController setNavigationBarHidden:NO];
        [self.navigationController pushViewController:mvc animated:YES];
    }
    if (index == 5) {
        LinkViewController *lvc = [self.storyboard instantiateViewControllerWithIdentifier:@"LinkViewController"];
        [self.navigationController setNavigationBarHidden:NO];
        [self.navigationController pushViewController:lvc animated:YES];
    }
    if (index == 6) {
        AboutViewController *avc = [self.storyboard instantiateViewControllerWithIdentifier:@"AboutViewController"];
        [self.navigationController setNavigationBarHidden:NO];
        [self.navigationController pushViewController:avc animated:YES];
    }
    self.navTitleLabel1.hidden = YES;
    self.pageControl.hidden = YES;
}

-(void)buttonPressed2:(UIButton *)sender {
    long index = sender.tag;
    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"" message:@"This will leave the application and open iTunes. Do you want to continue?" delegate:self cancelButtonTitle:@"No" otherButtonTitles:nil];
    // optional - add more buttons:
    [alert addButtonWithTitle:@"Yes"];
    [alert show];
    itunes_url = [NSURL URLWithString:[urlsForView2 objectAtIndex:index]];
}

- (void)alertView:(UIAlertView *)alertView didDismissWithButtonIndex:(NSInteger)buttonIndex {
    if (buttonIndex == 1 && itunes_url) {
       [[UIApplication sharedApplication] openURL:itunes_url];
        itunes_url = nil;
    }
}


@end

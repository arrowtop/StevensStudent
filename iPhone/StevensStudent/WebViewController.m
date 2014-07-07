//
//  WebViewController.m
//  StevensStudent
//
//  Created by toby on 5/1/14.
//  Copyright (c) 2014 arrowtop. All rights reserved.
//

#import "WebViewController.h"

@interface WebViewController ()<UIWebViewDelegate>

@property (weak, nonatomic) IBOutlet UIWebView *webView;

@end

@implementation WebViewController

- (void) viewDidLoad
{
    [super viewDidLoad];
    
    self.navigationItem.title = self.title_name;
    [self loadWebView];
}
- (IBAction)openInSafari:(id)sender {
    [[UIApplication sharedApplication] openURL:self.url];
}

- (void) loadWebView
{
    if (self.url != nil){
        self.webView.scalesPageToFit = YES;
        NSURLRequest *request = [NSURLRequest requestWithURL:self.url];
        [self.webView loadRequest:request];
    }
}
@end

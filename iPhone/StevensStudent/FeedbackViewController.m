//
//  FeedbackViewController.m
//  StevensStudent
//
//  Created by toby on 5/27/14.
//  Copyright (c) 2014 arrowtop. All rights reserved.
//

#import "FeedbackViewController.h"
#import <QuartzCore/QuartzCore.h>

@interface FeedbackViewController ()<UITextViewDelegate>

@property (weak, nonatomic) IBOutlet UITextView *textView;
@property (weak, nonatomic) IBOutlet UILabel *textCount;
@property (weak, nonatomic) IBOutlet UIView *topBar;

@end

@implementation FeedbackViewController

#define MAX_TEXTVIEW_LENGTH 300
#define Rgb2UIColor(r, g, b)  [UIColor colorWithRed:((r) / 255.0) green:((g) / 255.0) blue:((b) / 255.0) alpha:1.0]

- (void)viewDidLoad
{
    [super viewDidLoad];
    [self.textView becomeFirstResponder];
    self.textCount.text = [NSString stringWithFormat:@"%d", MAX_TEXTVIEW_LENGTH];
    self.textCount.textColor = [UIColor lightGrayColor];
    self.topBar.backgroundColor = Rgb2UIColor(120, 189, 254);
}

- (BOOL)textView:(UITextView *)textView shouldChangeTextInRange:(NSRange)range replacementText:(NSString *)text
{
    return [self isAcceptableTextLength:self.textView.text.length - range.length];
}

- (BOOL)isAcceptableTextLength:(NSUInteger)length {
    return length < MAX_TEXTVIEW_LENGTH ;
}

-(void)textViewDidChange:(UITextView *)textView
{
    NSInteger count = MAX_TEXTVIEW_LENGTH - self.textView.text.length;
    self.textCount.text = [NSString stringWithFormat:@"%ld", (long)count];
    if (count > 10) {
        self.textCount.textColor = [UIColor lightGrayColor];
    } else {
        self.textCount.textColor = [UIColor redColor];
        
    }
}

- (IBAction)done:(id)sender
{
    if([self.textView.text length] < 10) {
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Sorry"
                                                        message:@"Feedback is too short!"
                                                       delegate:nil
                                              cancelButtonTitle:@"OK"
                                              otherButtonTitles:nil];
        [alert show];
    } else {
        [UIView animateWithDuration:0.5
                         animations:^{
                             [self.textView setFrame:CGRectMake(360, 114, self.textView.bounds.size.width, self.textView.bounds.size.height)];
                         }
                         completion:^(BOOL finished){
                             self.textView.hidden = YES;
                             [self dismissViewControllerAnimated:YES completion:nil];
                         }];
    }
}


- (IBAction)cancel:(id)sender
{
    [self dismissViewControllerAnimated:YES completion:nil];
}

@end


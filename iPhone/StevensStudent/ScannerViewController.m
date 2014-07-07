//
//  ScannerViewController.m
//  StevensStudent
//
//  Created by toby on 5/23/14.
//  Copyright (c) 2014 arrowtop. All rights reserved.
//

#import "ScannerViewController.h"
#import <AVFoundation/AVFoundation.h>
#import <ImageIO/ImageIO.h>

@interface ScannerViewController () <AVCaptureMetadataOutputObjectsDelegate>

@property (weak, nonatomic) IBOutlet UIView *viewPreview;
@property (weak, nonatomic) IBOutlet UITextView *resultView;
@property (nonatomic, strong) AVCaptureSession *captureSession;
@property (nonatomic, strong) AVCaptureVideoPreviewLayer *videoPreviewLayer;
@property (nonatomic, strong) NSURL *url;
@property (weak, nonatomic) IBOutlet UIButton *openUrlBtn;
@property (weak, nonatomic) IBOutlet UIButton *shareUrlBtn;

@end

@implementation ScannerViewController

#define Rgb2UIColor(r, g, b)  [UIColor colorWithRed:((r) / 255.0) green:((g) / 255.0) blue:((b) / 255.0) alpha:1.0]

- (void)viewDidLoad
{
    [super viewDidLoad];
    self.captureSession = nil;
    self.openUrlBtn.hidden = YES;
    self.shareUrlBtn.hidden = YES;
    self.view.backgroundColor = Rgb2UIColor(247, 247, 247);
    [self startReading];
}

#pragma mark - IBAction method implementation

- (IBAction)startStopReading:(id)sender {
    [self startReading];
}

#pragma mark - Private method implementation

- (BOOL)startReading {
    
    NSError *error;
    
    // Get an instance of the AVCaptureDevice class to initialize a device object and provide the video
    // as the media type parameter.
    AVCaptureDevice *captureDevice = [AVCaptureDevice defaultDeviceWithMediaType:AVMediaTypeVideo];
    
    // Get an instance of the AVCaptureDeviceInput class using the previous device object.
    AVCaptureDeviceInput *input = [AVCaptureDeviceInput deviceInputWithDevice:captureDevice error:&error];
    
    if (!input) {
        // If any error occurs, simply log the description of it and don't continue any more.
        NSLog(@"%@", [error localizedDescription]);
        return NO;
    }
    
    // Initialize the captureSession object.
    self.captureSession = [[AVCaptureSession alloc] init];
    // Set the input device on the capture session.
    [self.captureSession addInput:input];
    
    
    // Initialize a AVCaptureMetadataOutput object and set it as the output device to the capture session.
    AVCaptureMetadataOutput *captureMetadataOutput = [[AVCaptureMetadataOutput alloc] init];
    [self.captureSession addOutput:captureMetadataOutput];
    
    // Create a new serial dispatch queue.
    dispatch_queue_t dispatchQueue;
    dispatchQueue = dispatch_queue_create("QRQueue", NULL);
    [captureMetadataOutput setMetadataObjectsDelegate:self queue:dispatchQueue];
    [captureMetadataOutput setMetadataObjectTypes:[NSArray arrayWithObject:AVMetadataObjectTypeQRCode]];
    
    // Initialize the video preview layer and add it as a sublayer to the viewPreview view's layer.
    self.videoPreviewLayer = [[AVCaptureVideoPreviewLayer alloc] initWithSession:self.captureSession];
    [self.videoPreviewLayer setVideoGravity:AVLayerVideoGravityResizeAspectFill];
    [self.videoPreviewLayer setFrame:self.viewPreview.layer.bounds];
    [self.viewPreview.layer addSublayer:_videoPreviewLayer];
    
    
    // Start video capture.
    [self.captureSession startRunning];
    
    return YES;
}


-(void)stopReading{
    
    // Stop video capture and make the capture session object nil.
    [self.captureSession stopRunning];
    self.captureSession = nil;
    
    // Remove the video preview layer from the viewPreview view's layer.
    [self.videoPreviewLayer removeFromSuperlayer];
}

#pragma mark - AVCaptureMetadataOutputObjectsDelegate method implementation

-(void)captureOutput:(AVCaptureOutput *)captureOutput didOutputMetadataObjects:(NSArray *)metadataObjects fromConnection:(AVCaptureConnection *)connection{
    
    // Check if the metadataObjects array is not nil and it contains at least one object.
    if (metadataObjects != nil && [metadataObjects count] > 0) {
        // Get the metadata object.
        AVMetadataMachineReadableCodeObject *metadataObj = [metadataObjects objectAtIndex:0];
        if ([[metadataObj type] isEqualToString:AVMetadataObjectTypeQRCode]) {
            // If the found metadata is equal to the QR code metadata then update the status label's text,
            // stop reading and change the bar button item's title and the flag's value.
            // Everything is done on the main thread.
            dispatch_async(dispatch_get_main_queue(), ^{
                self.url = [NSURL URLWithString: [metadataObj stringValue]];
                if (self.url) {
                    if(![[[metadataObj stringValue] lowercaseString] hasPrefix:@"http://"]) {
                        NSString *urlString = [NSString stringWithFormat:@"http://%@", [metadataObj stringValue]];
                        self.url = [NSURL URLWithString: urlString];
                    }
                    self.resultView.text = [NSString stringWithFormat:@"URL:\n\n%@", [metadataObj stringValue]];
                    self.openUrlBtn.hidden = NO;
                    self.shareUrlBtn.hidden = NO;
                } else {
                    self.resultView.text = [NSString stringWithFormat:@"Result:\n\n%@", [metadataObj stringValue]];
                    self.openUrlBtn.hidden = YES;
                    self.shareUrlBtn.hidden = YES;
                }
                [self stopReading];
            });
        }
    }
    
}

#pragma mark - URL Methods

- (IBAction)openURL:(id)sender {
    [[UIApplication sharedApplication] openURL:self.url];
}


@end

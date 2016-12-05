//
//  DPSConfirmationViewController.m
//  Plugin Tester
//
//  Created by Neuber Oliveira on 02/12/16.
//
//

#import "DPSConfirmationViewController.h"

@interface DPSConfirmationViewController ()

@end

@implementation DPSConfirmationViewController

- (void)viewDidLoad {
    [super viewDidLoad];
	
	[self.preview setImage:self.imagePicked];
}

-(IBAction)acceptImage:(UIButton*)sender {
	NSURL *uri = [[NSURL alloc] initFileURLWithPath:self.imagePickedPath];
	
	[DPSCameraGuide.instance backToWebView];
	[DPSCameraGuide.instance fireSuccess:uri.absoluteString];
}

-(IBAction)rejectImage:(UIButton*)sender {
	[DPSCameraGuide.instance back];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end

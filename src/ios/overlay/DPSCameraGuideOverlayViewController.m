//
//  DPSCameraGuideOverlayViewController.m
//  Camera Guide Test
//
//  Created by Neuber Oliveira on 22/11/16.
//
//

#import "DPSCameraGuideOverlayViewController.h"

@interface DPSCameraGuideOverlayViewController ()

@end

@implementation DPSCameraGuideOverlayViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
	
	if( DPSCameraGuide.instance.optionUrl ){
		NSURL *url = [NSURL URLWithString:DPSCameraGuide.instance.optionUrl];
		NSData *data = [NSData dataWithContentsOfURL:url];
		UIImage *image = [UIImage imageWithData:data];
		self.compareImage.image = image;
		self.compareImage.alpha = self.opacitySlider.value;
	}else{
		[self.controlsSwitch setOn:NO];
		[self toggleControls:self.controlsSwitch];
		self.controlsSwitch.hidden = YES;
	}
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/


#pragma mark - UIImagePicker Delegates
-(void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary *)info {
	UIImage *imagePicked = info[UIImagePickerControllerOriginalImage];
	imagePicked = [DPSCameraGuide.instance scaleImage:imagePicked];
	/*picker.delegate = self;
	[picker dismissViewControllerAnimated:YES completion:nil];*/
	
	NSDate *now = [NSDate date];
	NSDateFormatter *dateFormat = [[NSDateFormatter alloc] init];
	[dateFormat setDateFormat:@"yyyy-MM-dd-HH-mm-ss"];
	NSString *theDate = [dateFormat stringFromDate:now];
	
	NSArray *paths = NSSearchPathForDirectoriesInDomains(NSCachesDirectory, NSUserDomainMask, YES);
	NSString *filename = [NSString stringWithFormat:@"DPS_%@", theDate];
	NSString *filePath = [[paths objectAtIndex:0] stringByAppendingPathComponent:filename];
	
	// Save image.
	[UIImagePNGRepresentation(imagePicked) writeToFile:filePath atomically:YES];
	
	//NSLog(@"PATH: %@", filePath);
	
	//start confirmation view
	DPSConfirmationViewController *vc = [DPSConfirmationViewController new];
	vc.imagePicked = imagePicked;
	vc.imagePickedPath = filePath;
	[DPSCameraGuide.instance pushViewController:vc];
}

-(void)imagePickerControllerDidCancel:(UIImagePickerController *)picker {
	[self dismissViewControllerAnimated:YES completion:NULL];
}

#pragma mark - IBACtions
-(IBAction)takePicture:(id)sender {
	[self.pickerReference takePicture];
}

-(IBAction)toggleControls:(UISwitch*)sender {
	self.controlsActive = !sender.isOn;
	
	self.opacitySlider.hidden = self.controlsActive;
	self.compareImage.hidden = self.controlsActive;
}

-(IBAction)sliderUpdate:(UISlider*)slider {
	self.compareImage.alpha = slider.value;
}

-(IBAction)closeCamera:(UIButton*)sender {
	[DPSCameraGuide.instance backToWebView];
	[DPSCameraGuide.instance fireError:@"user canceled image"];
}
@end

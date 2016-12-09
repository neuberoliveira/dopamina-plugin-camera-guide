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
	self.controlsActive = NO;
	[self toggleLoaderScreen:YES];
}

-(void)viewDidAppear:(BOOL)animated {
	[super viewDidAppear:animated];
	
	// Do any additional setup after loading the view from its nib.
	if( DPSCameraGuide.instance.optionUrl ){
		dispatch_queue_t q = dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_HIGH, 0ul);
		dispatch_async(q, ^{
			/* Fetch the image from the server... */
			NSURL *url = [NSURL URLWithString:DPSCameraGuide.instance.optionUrl];
			NSData *data = [NSData dataWithContentsOfURL:url];
			UIImage *image = [UIImage imageWithData:data];
			
			dispatch_async(dispatch_get_main_queue(), ^{
				/* This is the main thread again, where we set the tableView's image to
				 be what we just fetched. */
				self.compareImage.image = image;
				self.compareImage.alpha = self.opacitySlider.value;
				
				[self toggleLoaderScreen:NO];
			});
		});
	}else{
		[self toggleLoaderScreen:NO];
		[self toggleMainControls:YES];
		[self toggleControlsVisibility:NO];
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
	self.controlsActive = sender.isOn;
	[self toggleControlsVisibility:self.controlsActive];
}

-(IBAction)sliderUpdate:(UISlider*)slider {
	self.compareImage.alpha = slider.value;
}

-(IBAction)closeCamera:(UIButton*)sender {
	[DPSCameraGuide.instance backToWebView];
	[DPSCameraGuide.instance fireError:@"user canceled image"];
}


#pragma mark
-(void)toggleControlsVisibility:(bool)visible {
	self.opacitySlider.hidden = !visible;
	self.compareImage.hidden = !visible;
}

-(void)toggleMainControls:(bool)visible {
	self.btTakePicture.hidden = !visible;
	self.btCloseCamera.hidden = !visible;
	self.controlsSwitch.hidden = !visible;
}

-(void)toggleLoaderScreen:(bool)visible {
	self.controlsActive = !visible;
	
	[self toggleMainControls:!visible];
	[self toggleControlsVisibility:!visible];
	
	if(visible)
		[self displayLoader];
	else
		[self hideLoader];
}

-(void)displayLoader {
	self.loader.hidden = NO;
	[self.loader startAnimating];
}


-(void)hideLoader {
	self.loader.hidden = YES;
	[self.loader stopAnimating];
}
@end

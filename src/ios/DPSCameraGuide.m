#import "DPSCameraGuide.h"
#import <Cordova/CDVPlugin.h>

@implementation DPSCameraGuide

static DPSCameraGuide *instance;


+(DPSCameraGuide*) instance{
	@synchronized(self){
		return instance;
	}
}
+(void)setInstance:(DPSCameraGuide*)val {
	@synchronized(self){
		instance = val;
	}
}

/*-(id)init {
	if(self = [super init]){
		self.viewControllerStack = [NSMutableArray new];
		self.currentView = self.viewController;
	}
	
	return self;
}*/

-(void)pluginInitialize {
	[super pluginInitialize];
	
	[self resetStack];
}

-(void)resetStack {
	self.viewControllerStack = [NSMutableArray new];
	self.currentView = self.viewController;
}

-(void)initCamera {
	@try {
		self.picker = [[UIImagePickerController alloc] init];
		self.picker.sourceType = UIImagePickerControllerSourceTypeCamera;
		self.picker.cameraCaptureMode = UIImagePickerControllerCameraCaptureModePhoto;
		self.picker.cameraDevice = UIImagePickerControllerCameraDeviceRear;
		
		self.picker.showsCameraControls = NO;
		self.picker.navigationBarHidden = NO;
		self.picker.toolbarHidden = YES;
		self.picker.cameraFlashMode = UIImagePickerControllerCameraFlashModeOff;
		
		/*CGSize screenBounds = [UIScreen mainScreen].bounds.size;
		CGFloat cameraAspectRatio = 4.0f/3.0f;
		CGFloat camViewHeight = screenBounds.width * cameraAspectRatio;
		CGFloat scale = screenBounds.height / camViewHeight;
		
		self.picker.cameraViewTransform = CGAffineTransformMakeTranslation(0, (screenBounds.height - camViewHeight) / 2.0);
		self.picker.cameraViewTransform = CGAffineTransformScale(self.picker.cameraViewTransform, scale, scale);*/
		self.picker.cameraViewTransform = CGAffineTransformScale(self.picker.cameraViewTransform, 1.8, 1.8);
		// Insert the overlay
		self.overlay = [[DPSCameraGuideOverlayViewController alloc] initWithNibName:@"DPSCameraGuideOverlayViewController" bundle:nil];
		self.overlay.pickerReference = self.picker;
		
		self.picker.cameraOverlayView = self.overlay.view;
		self.picker.delegate = self.overlay;
	} @catch (NSException *exception) {
		NSLog(@"Camera Start ERROR: %@", exception);
	}
	
	//[self.viewController presentViewController:self.picker animated:NO completion:nil];
	[self pushViewController: self.picker];
}

-(void)start:(CDVInvokedUrlCommand*)command {
	self.command = command;
	self.optionUrl = [command argumentAtIndex:0 withDefault:nil];
	self.optionWidth = [[command argumentAtIndex:1 withDefault:[NSNumber numberWithInt:-1]] intValue];
	self.optionHeight = [[command argumentAtIndex:2 withDefault:[NSNumber numberWithInt:-1]] intValue];
	
	DPSCameraGuide.instance = self;
	[self initCamera];
}

-(void)fireSuccess:(NSString*)message {
	CDVPluginResult* pluginResult = [CDVPluginResult resultWithStatus:CDVCommandStatus_OK messageAsString:message];
	[self.commandDelegate sendPluginResult:pluginResult callbackId:self.command.callbackId];
}

-(void)fireError:(NSString*)err {
	CDVPluginResult* pluginResult = [CDVPluginResult resultWithStatus:CDVCommandStatus_ERROR messageAsString:err];
	[self.commandDelegate sendPluginResult:pluginResult callbackId:self.command.callbackId];
}

-(UIImage *)scaleImage:(UIImage *)image {
	if(self.optionWidth<=0)
		return image;
	
	CGSize original = CGSizeMake(image.size.width, image.size.height);
	CGSize newSize = [self scale:original width:self.optionWidth];
	
	//UIGraphicsBeginImageContext(newSize);
	// In next line, pass 0.0 to use the current device's pixel scaling factor (and thus account for Retina resolution).
	// Pass 1.0 to force exact pixel size.
	UIGraphicsBeginImageContextWithOptions(newSize, NO, 1.0);
	[image drawInRect:CGRectMake(0, 0, newSize.width, newSize.height)];
	UIImage *newImage = UIGraphicsGetImageFromCurrentImageContext();
	UIGraphicsEndImageContext();
	
	return newImage;
}

-(CGSize)scale:(CGSize)original width:(int)width {
	int newWidth = 0;
	int newHeight = 0;
	
	//(original height / original width) x new width = new height
	//(1200 / 1600) x 400 = 300
	
	newWidth = width;
	newHeight = original.height/original.width * width;
	
	return CGSizeMake(newWidth, newHeight);
}

#pragma mark - NavigationController SQN
-(void)pushViewController:(UIViewController*)vc {
	[self.viewControllerStack insertObject:vc atIndex:0];
	[self.currentView presentViewController:vc animated:YES completion:nil];
	
	self.currentView = vc;
}

-(void)back {
	UIViewController *vc = (UIViewController*)[self.viewControllerStack objectAtIndex:0];
	[vc dismissViewControllerAnimated:YES completion:nil];
	
	[self.viewControllerStack removeObjectAtIndex:0];
	self.currentView = [self.viewControllerStack objectAtIndex:0];
}


-(void)backToWebView{
	UIViewController *vc;
	for(int i=0; i<self.viewControllerStack.count; i++){
		vc = (UIViewController*)[self.viewControllerStack objectAtIndex:i];
		[vc dismissViewControllerAnimated:NO completion:nil];
	}
	
	[self resetStack];
}

@end

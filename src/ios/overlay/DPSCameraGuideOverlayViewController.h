//
//  DPSCameraGuideOverlayViewController.h
//  Camera Guide Test
//
//  Created by Neuber Oliveira on 22/11/16.
//
//

#import <UIKit/UIKit.h>
#import "DPSConfirmationViewController.h"
#import "DPSCameraGuide.h"

@interface DPSCameraGuideOverlayViewController : UIViewController<UINavigationControllerDelegate, UIImagePickerControllerDelegate>

@property(nonatomic, weak) UIImagePickerController *pickerReference;

@property(nonatomic, strong) IBOutlet UISlider *opacitySlider;
@property(nonatomic, strong) IBOutlet UIImageView *compareImage;
@property(nonatomic, strong) IBOutlet UISwitch *controlsSwitch;
@property(nonatomic, strong) IBOutlet UIView *loaderContainer;
@property(nonatomic, strong) IBOutlet UIActivityIndicatorView *loader;
@property(nonatomic, strong) IBOutlet UIButton *btTakePicture;
@property(nonatomic, strong) IBOutlet UIButton *btCloseCamera;

@property BOOL isLoading;

@property BOOL controlsActive;

-(IBAction)toggleControls:(UISwitch*)sender;
-(IBAction)takePicture:(id)sender;
-(IBAction)sliderUpdate:(UISlider*)slider;
-(IBAction)closeCamera:(UIButton*)sender;
@end

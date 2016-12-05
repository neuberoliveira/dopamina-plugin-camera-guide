#import <Cordova/CDVPlugin.h>
#import "DPSCameraGuideOverlayViewController.h"

@class DPSCameraGuideOverlayViewController;

@interface DPSCameraGuide : CDVPlugin
@property(nonatomic, strong) UIImagePickerController *picker;
@property(nonatomic, strong) DPSCameraGuideOverlayViewController *overlay;
@property(nonatomic, strong) CDVInvokedUrlCommand *command;

@property(nonatomic, strong) NSMutableArray *viewControllerStack;
@property(nonatomic, strong) UIViewController *currentView;

@property(nonatomic, strong) NSString *optionUrl;
@property int optionWidth;
@property int optionHeight;

+(DPSCameraGuide*) instance;

-(void)start:(CDVInvokedUrlCommand*)command;
-(void)fireSuccess:(NSString*)message;
-(void)fireError:(NSString*)err;

-(UIImage *)scaleImage:(UIImage *)image;

-(void)pushViewController:(UIViewController*)vc;
-(void)back;
-(void)backToWebView;
@end

//
//  DPSConfirmationViewController.h
//  Plugin Tester
//
//  Created by Neuber Oliveira on 02/12/16.
//
//

#import <UIKit/UIKit.h>
#import "DPSCameraGuide.h"

@class DPSCameraGuide;
@interface DPSConfirmationViewController : UIViewController

@property(nonatomic, strong) IBOutlet UIImageView *preview;

@property(nonatomic, strong) UIImage *imagePicked;
@property(nonatomic, strong) NSString *imagePickedPath;


-(IBAction)acceptImage:(UIButton*)sender;
-(IBAction)rejectImage:(UIButton*)sender;

@end

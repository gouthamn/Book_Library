//
//  SlideViewController.m
//  BookLibrary
//
//  Created by Goutham on 25/09/2013.
//  Copyright (c) 2013 byteridge. All rights reserved.
//

#import "SlideViewController.h"

@interface SlideViewController ()

@end

@implementation SlideViewController
@synthesize slider,lbl,Container;
- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    UIGraphicsBeginImageContext(self.view.frame.size);
    [[UIImage imageNamed:@"lockscreen.jpeg"] drawInRect:self.view.bounds];
    UIImage *image = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    self.view.backgroundColor=[UIColor colorWithPatternImage:image];
    UIImage *stetchLeftTrack= [[UIImage imageNamed:@"Nothing.png"]
                               stretchableImageWithLeftCapWidth:30.0 topCapHeight:0.0];
	UIImage *stetchRightTrack= [[UIImage imageNamed:@"Nothing.png"]
                                stretchableImageWithLeftCapWidth:30.0 topCapHeight:0.0];
	[slider setThumbImage: [UIImage imageNamed:@"SlideToStop.png"] forState:UIControlStateNormal];
	[slider setMinimumTrackImage:stetchLeftTrack forState:UIControlStateNormal];
	[slider setMaximumTrackImage:stetchRightTrack forState:UIControlStateNormal];
	// Do any additional setup after loading the view.
}
-(IBAction)fadeLabel {
    
    
    
    lbl.alpha = 1.0 - slider.value;
    
    
    
}
-(IBAction)UnLockIt {
    
    
        if (slider.value ==1.0) {  // if user slide to the most right side, stop the operation
            
            // Put here what happens when it is unlocked
            
            
            
            slider.hidden = YES;
            
          
            
            lbl.hidden = YES;
            Container.hidden=YES;
            
           
            
        } else {
            
            // user did not slide far enough, so return back to 0 position
            
            
            
            [UIView beginAnimations: @"SlideCanceled" context: nil];
            
            [UIView setAnimationDelegate: self];
            
            [UIView setAnimationDuration: 0.35];  
            
            // use CurveEaseOut to create "spring" effect  
            
            [UIView setAnimationCurve: UIViewAnimationCurveEaseOut];   
            
            slider.value = 0.0;
            
            
            
            [UIView commitAnimations];  
            
            
            
        }  
        
    }   
    

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end

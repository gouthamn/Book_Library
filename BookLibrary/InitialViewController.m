//
//  InitialViewController.m
//  BookLibrary
//
//  Created by Goutham on 10/10/2013.
//  Copyright (c) 2013 byteridge. All rights reserved.
//

#import "InitialViewController.h"
#import "SWRevealViewController.h"
@interface InitialViewController ()

@end

@implementation InitialViewController
@synthesize btn;
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
	// Do any additional setup after loading the view.
    UIGraphicsBeginImageContext(self.view.frame.size);
    [[UIImage imageNamed:@"lockscreen.jpeg"] drawInRect:self.view.bounds];
    UIImage *image = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    self.view.backgroundColor=[UIColor colorWithPatternImage:image];
    [btn useAlertStyle];
   // [blackButton useBlackStyle];
   // [whiteButton useWhiteStyle];
   // [alertButton useAlertStyle];
   // [orangeButton useSimpleOrangeStyle];
   // [redButton useRedDeleteStyle];
  //  [greenButton useGreenConfirmStyle];
  //  [whiteActionButton useWhiteActionSheetStyle];
  //  [blackActionButton useBlackActionSheetStyle];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end

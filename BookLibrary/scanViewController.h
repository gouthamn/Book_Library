//
//  scanViewController.h
//  SidebarDemo
//
//  Created by Goutham on 12/09/2013.
//  Copyright (c) 2013 Appcoda. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ZBarSDK.h"
@interface scanViewController : UIViewController<ZBarReaderDelegate,UIActionSheetDelegate,UITextFieldDelegate>
{
    UIImageView *resultImage;
    UITextField *resultText;
}
@property (nonatomic, retain) IBOutlet UIImageView *resultImage;
@property (nonatomic, retain) IBOutlet UITextField *resultText;
@property (weak, nonatomic) IBOutlet UIBarButtonItem *sidebarButton;
@property (weak, nonatomic) IBOutlet UIBarButtonItem *camerabutton;
- (IBAction) scanButtonTapped;


@end

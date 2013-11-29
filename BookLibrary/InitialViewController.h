//
//  InitialViewController.h
//  BookLibrary
//
//  Created by Goutham on 10/10/2013.
//  Copyright (c) 2013 byteridge. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "GradientButton.h"
@interface InitialViewController : UIViewController
{
    GradientButton *btn;
}
@property (nonatomic, retain) IBOutlet  GradientButton *btn;
@end

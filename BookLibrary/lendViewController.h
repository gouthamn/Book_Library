//
//  lendViewController.h
//  SidebarDemo
//
//  Created by Goutham on 13/09/2013.
//  Copyright (c) 2013 Appcoda. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface lendViewController : UIViewController<UIActionSheetDelegate,UITextFieldDelegate>
{
    UIPopoverController *popoverController;
    UIActionSheet *menu;
    NSString *pagetitle;
    NSString *isbn;
}
@property (nonatomic, retain) NSMutableArray *datasource;
@property (nonatomic, retain) IBOutlet UIDatePicker *datepicker;
@property (nonatomic, retain) IBOutlet UITextField *emailid;
@property (nonatomic, retain) IBOutlet UITextField *name;
@property (nonatomic, retain) IBOutlet UITextField *date;
@property (nonatomic, strong) NSString *pagetitle;
@property (nonatomic, strong) NSString *isbn;
@property(nonatomic,strong) IBOutlet UIPopoverController *popoverController;
-(IBAction)changedate:(UIButton*)sender;
-(IBAction)textFieldBeginEditing:(UITextField *)textField;
@end

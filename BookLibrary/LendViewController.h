//
//  lendViewController.h
//  SidebarDemo
//
//  Created by Goutham on 13/09/2013.
//  Copyright (c) 2013 Appcoda. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface lendViewController : UIViewController<UIActionSheetDelegate,UITextFieldDelegate,UITableViewDelegate,UITableViewDataSource>
{
    
    UIPopoverController *popoverController;
    UIActionSheet *menu;
    NSString *pagetitle;
    NSString *isbn;
    int flag;

}
@property (nonatomic, retain) NSMutableArray *datasource;
@property (nonatomic, retain) IBOutlet UIDatePicker *datepicker;
@property (nonatomic, retain) IBOutlet UITextField *emailid;
@property (nonatomic, retain) IBOutlet UITextField *name;
@property (nonatomic, retain) IBOutlet UITextField *date;
@property (nonatomic, strong) NSString *pagetitle;
@property (nonatomic, strong) NSString *isbn;
@property (nonatomic,assign) int flag;
@property(nonatomic,strong) IBOutlet UIPopoverController *popoverController;
@property (nonatomic,retain) IBOutlet UITableView *tableview;
@property (nonatomic, retain) NSMutableArray *autocompletemails;
@property (nonatomic, retain) NSMutableArray *pastemails;
@property (nonatomic, retain) NSDate *duedate;
@property (nonatomic, retain) NSMutableArray *outputarray;
@end

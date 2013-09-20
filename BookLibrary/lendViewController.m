//
//  lendViewController.m
//  SidebarDemo
//
//  Created by Goutham on 13/09/2013.
//  Copyright (c) 2013 Appcoda. All rights reserved.
//

#import "lendViewController.h"
#import "DBManager.h"
@interface lendViewController ()

@end

@implementation lendViewController
@synthesize datepicker,emailid,date,name,popoverController,pagetitle,isbn,datasource;
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
  
    self.title=pagetitle;
    UIBarButtonItem *bar=[[UIBarButtonItem alloc] initWithTitle:@"Done" style:UIBarButtonItemStyleDone target:self action:@selector(submit:)];
    self.navigationItem.rightBarButtonItems=[NSArray arrayWithObject:bar];
   // UIBarButtonItem *btn = [[UIBarButtonItem alloc] initWithImage:[UIImage imageNamed:@"back-button.png"] style:UIBarButtonItemStyleBordered target:self action:nil];
    
    //[self.navigationItem setBackBarButtonItem:btn];
	// Do any additional setup after loading the view.
}
-(BOOL)textFieldShouldReturn:(UITextField *)textField
{
   
    [textField resignFirstResponder];
    return YES;
}
-(IBAction)submit:(id)sender
{
    NSDate *currentdate=[NSDate date];
    NSDateFormatter *dateFormat = [[NSDateFormatter alloc] init];
    [dateFormat setDateFormat:@"dd-MM-yyyy"];
    NSString *str1=[dateFormat stringFromDate:currentdate];

    [[DBManager getSharedInstance] saveData:isbn username:name.text emailid:emailid.text issuedate:str1 duedate:date.text status:1];
}
-(IBAction)textFieldBeginEditing:(UITextField *)textField
{
    menu = [[UIActionSheet alloc] initWithTitle:nil
                                                      delegate:self
                                             cancelButtonTitle:nil
                                        destructiveButtonTitle:nil
                                             otherButtonTitles:nil];
    UIDatePicker *pickerView = [[UIDatePicker alloc] init];
    pickerView.datePickerMode = UIDatePickerModeDate;
     [pickerView addTarget:self action:@selector(datechanged:) forControlEvents:UIControlEventValueChanged];
    //[textField setInputView:pickerView];
    
    UIToolbar *pickerToolbar = [[UIToolbar alloc] initWithFrame:CGRectMake(0, 0, 320, 40)];
    pickerToolbar.barStyle = UIBarStyleBlackOpaque;
    [pickerToolbar sizeToFit];
    
    NSMutableArray *barItems = [[NSMutableArray alloc] init];
    
    UIBarButtonItem *flexSpace = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemFlexibleSpace target:self action:nil];
    [barItems addObject:flexSpace];
    
    UIBarButtonItem *doneBtn = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemDone target:self action:@selector(doneButtonPressed:)];
    [barItems addObject:doneBtn];
    
        
    [pickerToolbar setItems:barItems animated:YES];
    
     [menu addSubview:pickerView];
    [menu addSubview:pickerToolbar];
   
    [menu showInView:self.view];
    [menu setBounds:CGRectMake(0,0,320,500)];
    CGRect pickerRect = pickerView.bounds;
    pickerRect.origin.y = -40;
    pickerView.bounds = pickerRect;
}

-(IBAction)doneButtonPressed:(UIDatePicker*)sender
{
    [menu dismissWithClickedButtonIndex:0 animated:YES];
    [date resignFirstResponder];
   
}
-(void)datechanged:(UIDatePicker*)sender
{
    NSDateFormatter *dateformat=[[NSDateFormatter alloc] init];
    [dateformat setDateFormat:@"dd-MM-YYYY"];
    
    date.text=[dateformat stringFromDate:[sender date]];
}
- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
-(void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event
{
    [self.view endEditing:YES];
}

@end

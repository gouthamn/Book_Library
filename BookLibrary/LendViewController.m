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
@synthesize datepicker,emailid,date,name,popoverController,pagetitle,isbn,datasource,flag;
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
    if (emailid.text.length==0 || date.text.length == 0) {
        UIAlertView *alertview=[[UIAlertView alloc] initWithTitle:@"Error!!" message:@"Mandatory fields cannot be left empty" delegate:self cancelButtonTitle:@"OK" otherButtonTitles:nil ];
        [alertview show];
    }
    else
    {
        NSDate *currentdate=[NSDate date];
        NSDateFormatter *dateFormat = [[NSDateFormatter alloc] init];
        [dateFormat setDateFormat:@"dd-MM-yyyy"];
        NSString *str1=[dateFormat stringFromDate:currentdate];
       if(flag == 1)
       {
        BOOL success=[[DBManager getSharedInstance] saveData:isbn username:name.text emailid:emailid.text issuedate:str1 duedate:date.text status:1];
            if (success==YES) {
            [[DBManager getSharedInstance] updateCopies:isbn copies:-1];
            UIAlertView *alertview=[[UIAlertView alloc] initWithTitle:@"Info!!" message:@"Book succesfully lent" delegate:self cancelButtonTitle:@"OK" otherButtonTitles:nil ];
            [alertview show];
            emailid.text=@"";
            date.text=@"";
            name.text=@"";
                 [self.navigationController popViewControllerAnimated:YES];
            }
            else
            {
            UIAlertView *alertview=[[UIAlertView alloc] initWithTitle:@"Error!!" message:@"Invalid Details" delegate:self cancelButtonTitle:@"OK" otherButtonTitles:nil ];
            [alertview show];
            }
        }
       else
       {
       BOOL success= [[DBManager getSharedInstance] saveData:isbn username:name.text emailid:emailid.text issuedate:str1 duedate:date.text status:0];
           if (success==YES) {
               [[DBManager getSharedInstance] updateCopies:isbn copies:1];
               UIAlertView *alertview=[[UIAlertView alloc] initWithTitle:@"Info!!" message:@"Book succesfully Borrowed" delegate:self cancelButtonTitle:@"OK" otherButtonTitles:nil ];
               [alertview show];
               emailid.text=@"";
               date.text=@"";
               name.text=@"";
               
               [self performSelectorInBackground:@selector(fetchAndInsertData) withObject:nil];
               [self.navigationController popViewControllerAnimated:YES];
           }
       }
    }
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
-(void)dateChanged:(UIDatePicker*)sender
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
- (void)fetchAndInsertData{
    //parse out the json data
    
        
    datasource=[[DBManager getSharedInstance] findDetailsByISBN:isbn];
    if (datasource==nil) {
    NSString *str=[NSString stringWithFormat:@"https://www.googleapis.com/books/v1/volumes?q=isbn:%@",isbn];
        
    NSURL* jsonURL = [NSURL URLWithString:str];
    NSData* data = [NSData dataWithContentsOfURL:jsonURL];
                
    NSError* error;
    NSDictionary* json = [NSJSONSerialization
                          JSONObjectWithData:data //1
                          
                          options:kNilOptions
                          error:&error];
    if (json != nil &&
        error == nil)
    {
        NSString *publisher;
        NSString *author;
        NSString *category;
        NSString *description;
        NSString *rating;
        NSString *imgURL;
        NSString *title;
        NSData *imgdata;
        
        
        NSDictionary* items = [json objectForKey:@"items"];
        for(NSDictionary *dict in items)
        {
            title= [[  dict objectForKey:@"volumeInfo"] objectForKey:@"title"] ;
            publisher  = [[  dict objectForKey:@"volumeInfo"] objectForKey:@"publisher"] ;
            author     = [[[ dict objectForKey:@"volumeInfo"] objectForKey:@"authors"]objectAtIndex:0];
            category   = [[[ dict objectForKey:@"volumeInfo"] objectForKey:@"categories"]objectAtIndex:0];
            description= [[  dict objectForKey:@"volumeInfo"] objectForKey:@"description"];
            rating     = [[  dict objectForKey:@"volumeInfo"] objectForKey:@"averageRating"];
            imgURL     = [[[ dict objectForKey:@"volumeInfo"] objectForKey:@"imageLinks"] objectForKey:@"thumbnail"];
        }
        
        imgdata=[NSData dataWithContentsOfURL:[NSURL URLWithString:imgURL]];
        
        NSUserDefaults *defaults=[NSUserDefaults standardUserDefaults];
        [defaults setObject:imgdata forKey:isbn];
      [[DBManager getSharedInstance] saveData:isbn title:title author:author publisher:publisher category:category description:description rating:rating copies:1 archive:0];
        
        
    }
}

}

@end

//
//  lendViewController.m
//  SidebarDemo
//
//  Created by Goutham on 13/09/2013.
//  Copyright (c) 2013 Appcoda. All rights reserved.
//

#import "lendViewController.h"
#import "DBManager.h"
#import "Reachability.h"
@interface lendViewController ()

@end

@implementation lendViewController
@synthesize datepicker,emailid,date,name,popoverController,pagetitle,isbn,datasource,flag,tableview,autocompletemails,pastemails,duedate,outputarray;
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
    pastemails=[[NSMutableArray alloc] init];
   
    pastemails=[[DBManager getSharedInstance] getUniqueUsers];
    tableview = [[UITableView alloc] initWithFrame:
                 CGRectMake(119,80,168,30) style:UITableViewStylePlain];
	tableview.delegate = self;
	tableview.dataSource = self;
	tableview.hidden = YES;
    [self.view addSubview:tableview];
    self.date.text=[self twoWeekFromCurrentDay];
}
-(NSString *)twoWeekFromCurrentDay
{
    NSCalendar *calendar=[NSCalendar currentCalendar];
    NSDateComponents *components = [[NSDateComponents alloc]init];
    components.day = 14;
    NSDate *fireDate =[calendar dateByAddingComponents:components toDate:[NSDate date] options:0];
    NSString *dateInStringFormat=[self nsdateToString:fireDate];
    return dateInStringFormat;
    
}
-(NSString *)nsdateToString:(NSDate *)date1
{
    NSDateFormatter *dateFormat = [[NSDateFormatter alloc] init];
    [dateFormat setDateFormat:@"dd-MM-yyyy"];
    NSString *dateInStringFormat=[dateFormat stringFromDate:date1];
    
    return dateInStringFormat;
    
    
}
-(BOOL)textFieldShouldReturn:(UITextField *)textField
{
   
    [textField resignFirstResponder];
    return YES;
}

-(BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string
{
   
    if(textField==emailid)
    {
      
        NSString *substring=emailid.text;
        if ([string isEqualToString:@""]) {
            substring=[substring substringToIndex:[substring length] -1];
        }
        else
        {
        substring = [substring
                     stringByReplacingCharactersInRange:NSMakeRange(substring.length, 0) withString:string];
        }
        
        [self searchAutocompleteEntriesWithSubstring:substring];
      
        if([string isEqualToString:@"\n"])
        {
        [textField resignFirstResponder];
        }
    }
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
        //lend book online
       if(flag == 1)
       {
           BOOL success=[[DBManager getSharedInstance] saveData:isbn username:name.text emailid:emailid.text issuedate:str1 duedate:date.text status:1];
           if (success==YES) {
               [self lendBook];
               
               [self.navigationController popViewControllerAnimated:YES];
               [[NSNotificationCenter defaultCenter] postNotificationName:@"lent" object:nil];
               [self scheduleNotification];
           }
           else
           {
               UIAlertView *alertview=[[UIAlertView alloc] initWithTitle:@"Error!!" message:@"Invalid Details" delegate:self cancelButtonTitle:@"OK" otherButtonTitles:nil ];
               [alertview show];
           }
        }
        // lend book offline
        else if (flag==2)
        {
            BOOL success=[[DBManager getSharedInstance] saveData:isbn username:name.text emailid:emailid.text issuedate:str1 duedate:date.text status:1];
            if (success==YES) {
                [self lendBook];
                [[DBManager getSharedInstance] saveData:isbn title:@"" author:@"" publisher:@"" category:@"" description:@"" rating:@"" copies:1 archive:0];
                [[NSNotificationCenter defaultCenter] postNotificationName:@"lent" object:nil];
                [self.navigationController popViewControllerAnimated:YES];
                
            }
            else
            {
                UIAlertView *alertview=[[UIAlertView alloc] initWithTitle:@"Error!!" message:@"Invalid Details" delegate:self cancelButtonTitle:@"OK" otherButtonTitles:nil ];
                [alertview show];
            }
        }
        //borrow book
       else
       {
       BOOL success= [[DBManager getSharedInstance] saveData:isbn username:name.text emailid:emailid.text issuedate:str1 duedate:date.text status:0];
           if (success==YES) {
               [[DBManager getSharedInstance] updateCopies:isbn copies:1];
              UIAlertView *alertview=[[UIAlertView alloc] initWithTitle:@"Info!!" message:@"Book succesfully Borrowed" delegate:self cancelButtonTitle:@"OK" otherButtonTitles:nil ];
               [alertview show];
               Reachability *networkreachability=[Reachability reachabilityForInternetConnection];
               NetworkStatus networkstatus=[networkreachability currentReachabilityStatus];
               if (networkstatus==NotReachable) {
                   datasource=[[DBManager getSharedInstance] findDetailsByISBN:isbn];
                   if (datasource == nil) {
                       [[DBManager getSharedInstance] saveData:isbn title:@"" author:@"" publisher:@"" category:@"" description:@"" rating:@"" copies:1 archive:0];
                   }
               
               }
               else
               {
                   [self performSelectorInBackground:@selector(fetchAndInsertData) withObject:nil];
               }
               [self.navigationController popViewControllerAnimated:YES];
               
           }
       }
    }
}
-(void)scheduleNotification
{
//book name   person name   date
    NSDateFormatter *dateformat=[[NSDateFormatter alloc] init];
    [dateformat setDateFormat:@"dd-MM-yyyy"];

   UILocalNotification* localNotification = [[UILocalNotification alloc] init];
    localNotification.fireDate = [dateformat dateFromString:date.text];
    if (flag==0) {
        localNotification.alertBody=localNotification.alertBody =[NSString stringWithFormat:@"You borrowed a book named \"%@\" from %@ on %@. Please return the book.",[outputarray objectAtIndex:1],emailid.text,date.text,nil];
    }
    else
    {
    localNotification.alertBody =[NSString stringWithFormat:@"You had given a book named \"%@\" to %@ on %@. Please take back your book.",[outputarray objectAtIndex:1],emailid.text,date.text,nil];
    }
  //  localNotification.alertAction = NSLocalizedString(@"View Details", nil);
   
    localNotification.soundName = UILocalNotificationDefaultSoundName;
    localNotification.timeZone = [NSTimeZone defaultTimeZone];
    localNotification.applicationIconBadgeNumber = [[UIApplication sharedApplication] applicationIconBadgeNumber] + 1;
    NSDictionary *infoDict = [NSDictionary dictionaryWithObject:isbn forKey:@"isbn"];
    localNotification.userInfo = infoDict;
    [[UIApplication sharedApplication] scheduleLocalNotification:localNotification];
    emailid.text=@"";
    date.text=@"";
    name.text=@"";  
}
-(void)lendBook
{
   
        [[DBManager getSharedInstance] updateCopies:isbn copies:-1];
        UIAlertView *alertview=[[UIAlertView alloc] initWithTitle:@"Info!!" message:@"Book succesfully lent" delegate:self cancelButtonTitle:@"OK" otherButtonTitles:nil ];
      [alertview show];
        
}

-(void)actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex
{
    
    if (buttonIndex==0) {
        
        NSCalendar *calendar=[NSCalendar currentCalendar];
        NSDateComponents *components = [[NSDateComponents alloc]init];
        components.day = 21;
        NSDate *fireDate =[calendar dateByAddingComponents:components toDate:[NSDate date] options:0];
        
        self.date.text=[self nsdateToString:fireDate];
        
        
    }
    else if (buttonIndex==1) {
        NSDateComponents* dateComponents = [[NSDateComponents alloc]init];
        [dateComponents setMonth:1];
        NSCalendar* calendar = [NSCalendar currentCalendar];
        NSDate* newDate = [calendar dateByAddingComponents:dateComponents toDate:[NSDate date] options:0];
        self.date.text=[self nsdateToString:newDate];
       
        
    }
    else if (buttonIndex==2) {
        NSDateComponents* dateComponents = [[NSDateComponents alloc]init];
        [dateComponents setMonth:2];
        NSCalendar* calendar = [NSCalendar currentCalendar];
        NSDate* newDate = [calendar dateByAddingComponents:dateComponents toDate:[NSDate date] options:0];
        self.date.text=[self nsdateToString:newDate];
      
    }
    else if (buttonIndex==3) {
        menu = [[UIActionSheet alloc] initWithTitle:nil
                                           delegate:self
                                  cancelButtonTitle:nil
                             destructiveButtonTitle:nil
                                  otherButtonTitles:nil];
        UIDatePicker *pickerView = [[UIDatePicker alloc] init];
        pickerView.datePickerMode = UIDatePickerModeDate;
        [pickerView addTarget:self action:@selector(dateChanged:) forControlEvents:UIControlEventValueChanged];
        
        
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
    [date resignFirstResponder];
}
-(IBAction)textFieldBeginEditing:(UITextField *)textField
{
    UIActionSheet *actionSheet = [[UIActionSheet alloc] initWithTitle:@"Choose Date"
                                                             delegate:self
                                                    cancelButtonTitle:@"Cancel"
                                               destructiveButtonTitle:nil
                                                    otherButtonTitles:@"3 Weeks",@"1 Month",@"2 Month",@"Select Specific Date", nil];
    
    [actionSheet showInView:self.view];
}

-(IBAction)doneButtonPressed:(UIDatePicker*)sender
{
    [menu dismissWithClickedButtonIndex:0 animated:YES];
    [date resignFirstResponder];
   
}
-(void)dateChanged:(UIDatePicker*)sender
{
    NSDateFormatter *dateformat=[[NSDateFormatter alloc] init];
    [dateformat setDateFormat:@"dd-MM-yyyy"];
    duedate=[sender date];
    date.text=[dateformat stringFromDate:duedate];
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
        if(title.length==0)
        {
            title=@"";
        }
        if(publisher.length==0)
        {
            publisher=@"";
        }
        
        if(category.length==0)
        {
            
            category=@"Uncategorised";
        }
        if(author.length==0)
        {
            author=@"";
        }
        if(description.length==0)
        {
            description=@"";
        }
        if(!rating)
        {
            rating=@"";
        }
        if(imgURL.length==0)
        {
            
        }
        else
        {
        imgdata=[NSData dataWithContentsOfURL:[NSURL URLWithString:imgURL]];
            NSUserDefaults *defaults=[NSUserDefaults standardUserDefaults];
            [defaults setObject:imgdata forKey:isbn];
        }
        
      [[DBManager getSharedInstance] saveData:isbn title:title author:author publisher:publisher category:category description:description rating:rating copies:1 archive:0];
        
     self.outputarray=   [[NSMutableArray alloc] initWithObjects:isbn,title,author,publisher,category,description,rating,[NSNumber numberWithInt:1],nil];
        [self scheduleNotification];
        
    }
}

}


- (void)searchAutocompleteEntriesWithSubstring:(NSString *)substring {
	
	// Put anything that starts with this substring into the autocompleteUrls array
	// The items in this array is what will show up in the table view
    // NSLog(@"%@",substring);
    
	 autocompletemails=[[NSMutableArray alloc] init];
    
	for(NSString *curString in pastemails) {
		NSRange substringRange = [curString rangeOfString:substring];
		if (substringRange.location == 0) {
			[autocompletemails addObject:curString];
		}
	}
    if (autocompletemails.count!=0) {
        tableview.hidden=NO;
        [tableview reloadData];
    }
    else
        
    {
        tableview.hidden=YES;
    }
   
	
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 1;
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger) section {
	return autocompletemails.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
	UITableViewCell *cell = nil;
	static NSString *AutoCompleteRowIdentifier = @"AutoCompleteRowIdentifier";
	cell = [tableView dequeueReusableCellWithIdentifier:AutoCompleteRowIdentifier];
	if (cell == nil) {
		cell = [[UITableViewCell alloc]
                initWithStyle:UITableViewCellStyleDefault reuseIdentifier:AutoCompleteRowIdentifier];
	}
	
	cell.textLabel.text = [autocompletemails objectAtIndex:indexPath.row];
	return cell;
}

#pragma mark UITableViewDelegate methods

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
	
	UITableViewCell *selectedCell = [tableView cellForRowAtIndexPath:indexPath];
    
    emailid.text=selectedCell.textLabel.text;
    
    tableView.hidden=TRUE;
	
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 40;
}

@end

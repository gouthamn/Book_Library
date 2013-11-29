//
//  bookdetailsViewController.m
//  SidebarDemo
//
//  Created by Goutham on 12/09/2013.
//  Copyright (c) 2013 Appcoda. All rights reserved.
//

#import "bookdetailsViewController.h"
#import "tablecell.h"
#import "lendViewController.h"
#import "DBManager.h"
#import <QuartzCore/QuartzCore.h>
@interface bookdetailsViewController ()

@end

@implementation bookdetailsViewController
@synthesize outputarray,tabledatasource,flag,pickerview,pickersource,tableview;
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
    NSLog(@"book detail");
    self.title=@"Book Details";
    headers=@[@"Publisher",@"Genre",@"Description",@"Status"];
   [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(reload:) name:@"lent" object:nil];
    NSLog(@"%d",[tabledatasource count]);
//UIBarButtonItem *bar=[[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemAdd target:self action:@selector(addCopies)];
   // self.navigationItem.rightBarButtonItems=[NSArray arrayWithObject:bar];
   
}
-(void)reload:(NSNotification*)notification
{
   
    NSInteger copies=[[DBManager getSharedInstance] searchCopies:[tabledatasource objectAtIndex:0]];
   
    if (copies>0) {
        flag=1;
    }
    else
    {
        flag=2;
    }
    
    [self.tableview reloadRowsAtIndexPaths:[NSArray arrayWithObjects:[NSIndexPath indexPathForRow:1 inSection:0], nil] withRowAnimation:UITableViewRowAnimationFade];
     [[NSNotificationCenter defaultCenter] removeObserver:self name:@"lent" object:nil];
}


- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return 2;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"tablecell";
    
    
    tablecell *cell = [tableView
                       dequeueReusableCellWithIdentifier:CellIdentifier];
   
    if (cell == nil)
    {
        cell = [[tablecell alloc]
                initWithStyle:UITableViewCellStyleDefault
                reuseIdentifier:CellIdentifier];
    }
     NSUserDefaults *defaults=[NSUserDefaults standardUserDefaults];
   
    if (indexPath.row==0) {
       
    
            UIImage *image=[UIImage imageWithData:[defaults objectForKey:[tabledatasource objectAtIndex:0]]];
       
          
       /* [cell.imgview.layer setBorderColor: [[UIColor purpleColor] CGColor]];
        [cell.imgview.layer setBorderWidth: 2.0];
       cell.imgview.layer.shadowColor = [UIColor purpleColor].CGColor;
        cell.imgview.layer.shadowOffset = CGSizeMake(-3.0, 3.0);
        cell.imgview.layer.shadowOpacity = 1;
        cell.imgview.layer.shadowRadius = 3.0;
        cell.imgview.clipsToBounds = NO;*/
        [cell.imgview.layer setBorderColor: [[UIColor whiteColor] CGColor]];
        [cell.imgview.layer setBorderWidth: 8.0f];
        cell.imgview.layer.shadowColor = [UIColor blackColor].CGColor;
        cell.imgview.layer.shadowOffset = CGSizeMake(1.0, 3.0);
        cell.imgview.layer.shadowOpacity = 0.9f;
        cell.imgview.layer.shadowRadius = 4.0;
        cell.imgview.clipsToBounds = NO;
            cell.imgview.image=image;
            cell.nameLabel.text=[tabledatasource objectAtIndex:1];
            cell.idLabel.text=[tabledatasource objectAtIndex:2];
            
            CGSize expsize = [cell.nameLabel.text sizeWithFont:cell.nameLabel.font constrainedToSize:CGSizeMake(278.0, INFINITY) lineBreakMode:cell.nameLabel.lineBreakMode];
            CGSize expsize2 = [cell.idLabel.text sizeWithFont:cell.idLabel.font constrainedToSize:CGSizeMake(278.0, INFINITY) lineBreakMode:cell.idLabel.lineBreakMode];
         
            customnumberofstars = [[DLStarRatingControl alloc] initWithFrame:CGRectMake(-25,expsize.height + expsize2.height +15, 140, 41) andStars:5 isFractional:YES];
            customnumberofstars.delegate=self;
            customnumberofstars.backgroundColor=[UIColor clearColor];
            customnumberofstars.rating=[[tabledatasource objectAtIndex:6] doubleValue];
            customnumberofstars.enabled=false;
            [cell.contentView addSubview:customnumberofstars];
                        
            return cell;
    }
    else
    {
        tablecell *cell2 = [tableView
                           dequeueReusableCellWithIdentifier:@"Cell2"];
        if (cell2 == nil)
        {
            cell2 = [[tablecell alloc]
                    initWithStyle:UITableViewCellStyleDefault
                    reuseIdentifier:CellIdentifier];
        }
        switch (flag) {
            case 1:
                cell2.borrow.enabled=false;
                cell2.ret.enabled=false;
                cell2.lend.enabled=true;
                cell2.borrow.alpha=0.5;
                cell2.ret.alpha=0.5;
                break;
            case 2:
                cell2.borrow.enabled=false;
                cell2.ret.enabled=true;
                cell2.lend.enabled=false;
                cell2.borrow.alpha=0.5;
                cell2.lend.alpha=0.5;
                break;
            case 3:
                cell2.borrow.enabled=false;
                cell2.ret.enabled=false;
                cell2.lend.enabled=false;
                cell2.borrow.alpha=0.5;
                cell2.lend.alpha=0.5;
                cell2.ret.alpha=0.5;
            default:
                break;
        }
        [cell2.lend useAlertStyle];
        [cell2.borrow useAlertStyle];
        [cell2.ret useAlertStyle];
        return cell2;
    }
    
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    //UIFont *font=[UIFont systemFontOfSize:14];
    //CGSize expsize = [str sizeWithFont:font constrainedToSize:CGSizeMake(274.0, INFINITY) lineBreakMode:UILineBreakModeWordWrap];
    static NSString *CellIdentifier = @"tablecell";
    
    tablecell *cell = [tableView
                       dequeueReusableCellWithIdentifier:CellIdentifier];
    CGSize expsize = [[tabledatasource objectAtIndex:1] sizeWithFont:cell.nameLabel.font constrainedToSize:CGSizeMake(278.0, INFINITY) lineBreakMode:cell.nameLabel.lineBreakMode];
    CGSize expsize2 = [[tabledatasource objectAtIndex:2] sizeWithFont:cell.idLabel.font constrainedToSize:CGSizeMake(278.0, INFINITY) lineBreakMode:cell.idLabel.lineBreakMode];
    
    if (indexPath.row==0) {
        return 210+expsize.height+expsize2.height+50;
    }
    return 54;

}
-(IBAction)takeBook:(id)sender
{
    pickersource=[[DBManager getSharedInstance] searchEmailidsByISBN:[tabledatasource objectAtIndex:0]];
    if (pickersource.count>0) {
        
    
   action = [[UIActionSheet alloc] initWithTitle:@"Select Email ID"
                                       delegate:self
                              cancelButtonTitle:nil
                         destructiveButtonTitle:nil
                              otherButtonTitles:nil];
    //action.actionSheetStyle=UIActionSheetStyleBlackOpaque;
   
    pickerview=[[UIPickerView alloc] initWithFrame:CGRectMake(0, 40, 320, 216)];
    pickerview.delegate=self;
    pickerview.dataSource=self;
    pickerview.showsSelectionIndicator=YES;

   
  
    
    UIToolbar *pickerToolbar = [[UIToolbar alloc] initWithFrame:CGRectMake(0, 0, 320, 40)];
    pickerToolbar.barStyle = UIBarStyleBlackOpaque;
    [pickerToolbar sizeToFit];
    
    NSMutableArray *barItems = [[NSMutableArray alloc] init];
    
    UIBarButtonItem *flexSpace = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemFlexibleSpace target:self action:nil];
    [barItems addObject:flexSpace];
    UIBarButtonItem *cancelBtn = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemCancel target:self action:@selector(cancel:)];
    [barItems addObject:cancelBtn];
    UIBarButtonItem *doneBtn = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemDone target:self action:@selector(doneButtonPressed)];
    [barItems addObject:doneBtn];
    
    
    [pickerToolbar setItems:barItems animated:YES];
    
    [action addSubview:pickerview];
    [action addSubview:pickerToolbar];
    
    [action showInView:self.view];
    [action setBounds:CGRectMake(0,0,320,450)];
    }
    else
    {
        UIAlertView *alertview=[[UIAlertView alloc] initWithTitle:@"Info" message:@"No Email ID's found" delegate:self cancelButtonTitle:@"OK" otherButtonTitles:nil ];
        
        [alertview show];
    }
  /*  CGRect pickerRect = pickerview.bounds;
    pickerRect.origin.y = -40;
    pickerview.bounds = pickerRect;*/
}

-(IBAction)doneButtonPressed
{
    NSInteger row=  [self.pickerview selectedRowInComponent:0];
  
    NSString *issuedate=[[DBManager getSharedInstance] deleteTransaction:[tabledatasource objectAtIndex:0] email:[pickersource objectAtIndex:row]];
    [[DBManager getSharedInstance] updateCopies:[tabledatasource objectAtIndex:0] copies:1];
    
    NSDate *currentdate=[NSDate date];
    NSDateFormatter *dateFormat = [[NSDateFormatter alloc] init];
    [dateFormat setDateFormat:@"dd-MM-yyyy"];
    NSString *str1=[dateFormat stringFromDate:currentdate];
    [[DBManager getSharedInstance] saveData:[tabledatasource objectAtIndex:0] emailid:[pickersource objectAtIndex:row] issuedate:issuedate returndate:str1];
    [action dismissWithClickedButtonIndex:0 animated:YES];
    UIAlertView *alertview=[[UIAlertView alloc] initWithTitle:@"Info" message:@"Book Successfully Returned" delegate:self cancelButtonTitle:@"OK" otherButtonTitles:nil ];
  
    
    [alertview show];
    [self.navigationController popViewControllerAnimated:YES];
}
-(IBAction)cancel:(id)sender
{
     [action dismissWithClickedButtonIndex:0 animated:YES];
}
- (NSInteger)numberOfComponentsInPickerView:(UIPickerView *)pickerView
{
    return 1;
}

// returns the # of rows in each component..
- (NSInteger)pickerView:(UIPickerView *)pickerView numberOfRowsInComponent: (NSInteger)component
{
    return [pickersource count];
}
-(NSString *)pickerView:(UIPickerView *)pickerView titleForRow:(NSInteger)row forComponent:(NSInteger)component
{
    
    return [self.pickersource objectAtIndex:row];
    
}
- (void)pickerView:(UIPickerView *)pickerView didSelectRow:(NSInteger)row   inComponent:(NSInteger)component{
    NSLog(@"%@",[pickersource objectAtIndex:row]);
}

-(IBAction)lendAndBorrow:(id)sender
{
    int copies= [[tabledatasource objectAtIndex:7] intValue];
    if (copies>0) {
        [self performSegueWithIdentifier:@"" sender:self];
    }
}
-(void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    UIButton *button=(UIButton*)sender;
    lendViewController *lend=[segue destinationViewController];
    if(button.tag==0)
    {
        lend.pagetitle=@"Lend Book";
        lend.flag=1;
        lend.isbn=[tabledatasource objectAtIndex:0];
        lend.outputarray=tabledatasource;
    }
    else
    {
    lend.pagetitle=@"Borrow Book";
        lend.isbn=[tabledatasource objectAtIndex:0];
        lend.flag=0;
        lend.outputarray=tabledatasource;
       // lend.datasource=[[DBManager getSharedInstance]finddetailsbyisbn:[tabledatasource objectAtIndex:0]];
    }
}
-(void)viewWillAppear:(BOOL)animated
{
    
    [super viewWillAppear:animated];
    
    NSInteger copies=[[DBManager getSharedInstance] searchCopies:[tabledatasource objectAtIndex:0]];
    if (copies>0) {
        flag=1;
    }
    else
    {
        flag=2;
    }
    [tableview reloadRowsAtIndexPaths:[NSArray arrayWithObjects:[NSIndexPath indexPathForRow:1 inSection:0], nil] withRowAnimation:UITableViewRowAnimationFade];
}
@end

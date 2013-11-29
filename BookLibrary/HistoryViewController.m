//
//  historyViewController.m
//  SidebarDemo
//
//  Created by Goutham on 12/09/2013.
//  Copyright (c) 2013 Appcoda. All rights reserved.
//

#import "historyViewController.h"
#import "SWRevealViewController.h"
#import "tablecell.h"
#import "DBManager.h"
@interface historyViewController ()

@end

@implementation historyViewController
@synthesize seg,lentbooks,borrowedbooks,completed,tableview,remind,mailComposer,SelectedIndexes,lbl;
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
    self.title = @"History";
    _sidebarButton.tintColor = [UIColor colorWithWhite:0.96f alpha:0.2f];
     
    // Set the side bar button action. When it's tapped, it'll show up the sidebar.
    _sidebarButton.target = self.revealViewController;
    _sidebarButton.action = @selector(revealToggle:);
    
    // Set the gesture
    [self.view addGestureRecognizer:self.revealViewController.panGestureRecognizer];
     
	// Do any additional setup after loading the view.
    SelectedIndexes=[[NSMutableArray alloc] init];
    
    self.lentbooks=[[DBManager getSharedInstance] getTransactionsByStatus:1];
   self.borrowedbooks=[[DBManager getSharedInstance] getTransactionsByStatus:0];
    self.completed=[[DBManager getSharedInstance] completedTransactions];
    lbl=[[UILabel alloc] initWithFrame:CGRectMake(90,180, 300, 30)];
    lbl.text=@"No Books Available";
    [lbl setFont:[UIFont fontWithName:@"" size:16.0]];
    
    lbl.backgroundColor = [UIColor clearColor];
    [self.view addSubview:lbl];
    if (self.lentbooks.count==0) {
        
        tableview.hidden=TRUE;
    
    }
    else
    {
        lbl.hidden=TRUE;
    }
    
    self.tableview.tableFooterView=[[UIView alloc] init];
    
}
-(int)differenceBetDays:(NSDate *)stringdate
{
   
    NSDate *currentDate = [NSDate date];

    NSTimeInterval secondsBetTwoDates=[stringdate timeIntervalSinceDate:currentDate];
    
    if (secondsBetTwoDates<=0) {
        return 0;
    }
    else
    {
    int noOfDaysLeft=(secondsBetTwoDates/86400);
   
        return noOfDaysLeft+1;
    }
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    
    switch (flag) {
        case 1:
            return [borrowedbooks count];
            break;
        case 2:
            return [completed count];
            break;
        default:
            return [lentbooks count];
            break;
    }

}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSString *cellidentifier=[NSString stringWithFormat:@"cell%d",flag];
    tablecell *cell = [tableView
                       dequeueReusableCellWithIdentifier:cellidentifier];
   
    
    if (cell == nil)
    {
        cell = [[tablecell alloc]
                initWithStyle:UITableViewCellStyleDefault
                reuseIdentifier:cellidentifier];
    }
    NSUserDefaults *defaults=[NSUserDefaults standardUserDefaults];
    switch (flag) {
        case 1:
        {
            NSString *isbn= [[borrowedbooks objectAtIndex:indexPath.row] objectForKey:@"isbn"];
            NSDate *duedate =[[borrowedbooks objectAtIndex:indexPath.row] objectForKey:@"duedate"];
            if ([defaults objectForKey:isbn]!=nil) {
                 cell.imgview.image=[UIImage imageWithData:[defaults objectForKey:isbn]];
            }
            else
            {
                cell.imgview.image=[UIImage imageNamed:@"download1.jpeg"];
            }
           
            cell.nameLabel.text=[[borrowedbooks objectAtIndex:indexPath.row] objectForKey:@"emailid"];
            int i= [self differenceBetDays:duedate];
            if (i == 0) {
                cell.datelbl.text=@"Time limit exceeded";
                cell.contentView.backgroundColor=[UIColor colorWithRed:1 green:1 blue:0.75 alpha:1];
            }
            else if(i==1)
            {
                cell.datelbl.text=[NSString stringWithFormat:@"%d day remaining",i];
                cell.contentView.backgroundColor=[UIColor clearColor];
            }
            else
            {
                cell.datelbl.text=[NSString stringWithFormat:@"%d days remaining",i];
                cell.contentView.backgroundColor=[UIColor clearColor];
            }
           
            cell.titlelbl.text=[[DBManager getSharedInstance] getBookNameByISBN:isbn];
        }
            break;
        case 2:
        {
            NSString *isbn= [[completed objectAtIndex:indexPath.row] objectForKey:@"isbn"];
            NSString *issuedate =[[completed objectAtIndex:indexPath.row] objectForKey:@"issuedate"];
            NSString *returndate =[[completed objectAtIndex:indexPath.row] objectForKey:@"returndate"];
            if ([defaults objectForKey:isbn]!=nil) {
                cell.imgview.image=[UIImage imageWithData:[defaults objectForKey:isbn]];
            }
            else
            {
                cell.imgview.image=[UIImage imageNamed:@"download1.jpeg"];
            }
            cell.nameLabel.text=[[completed objectAtIndex:indexPath.row] objectForKey:@"emailid"];
            cell.datelbl.text= [NSString stringWithFormat:@"Issue Date:%@",issuedate];
            cell.Hrslbl.text=[NSString stringWithFormat:@"Return Date:%@",returndate];
            cell.titlelbl.text=[[DBManager getSharedInstance] getBookNameByISBN:isbn];
        }
            break;
        default:
        
        {
            NSString *isbn= [[lentbooks objectAtIndex:indexPath.row] objectForKey:@"isbn"];
            NSDate *duedate =[[lentbooks objectAtIndex:indexPath.row] objectForKey:@"duedate"];
            if ([defaults objectForKey:isbn]!=nil) {
                cell.imgview.image=[UIImage imageWithData:[defaults objectForKey:isbn]];
            }
            else
            {
                cell.imgview.image=[UIImage imageNamed:@"download1.jpeg"];
            }
          
            cell.nameLabel.text=[[lentbooks objectAtIndex:indexPath.row] objectForKey:@"emailid"];
             
            int i= [self differenceBetDays:duedate];
           
            if (i == 0) {
            cell.datelbl.text=@"Time limit exceeded";
                cell.contentView.backgroundColor=[UIColor colorWithRed:1 green:1 blue:0.75 alpha:1];
            }
            else if(i==1)
            {
                cell.datelbl.text=[NSString stringWithFormat:@"%d day remaining",i];
                cell.contentView.backgroundColor=[UIColor clearColor];
            }
            else
            {
            cell.datelbl.text=[NSString stringWithFormat:@"%d days remaining",i];
                cell.contentView.backgroundColor=[UIColor clearColor];
            }
            cell.titlelbl.text=[[DBManager getSharedInstance] getBookNameByISBN:isbn];
            [cell.button addTarget:self action:@selector(sendMail:) forControlEvents:UIControlEventTouchUpInside];
            cell.button.tag=indexPath.row;
        }
            break;
    }
                
    
    return cell;
}




  

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    /*if (flag==0) {
        
    
        UITableViewCell *cell = [tableview cellForRowAtIndexPath:indexPath];
        
            if(cell.accessoryType==UITableViewCellAccessoryCheckmark)
            {
                cell.accessoryType=UITableViewCellAccessoryNone;
                
            [SelectedIndexes removeObject:[[lentbooks objectAtIndex:indexPath.row] objectForKey:@"emailid"]];
                
            }
            else
            {
                cell.accessoryType = UITableViewCellAccessoryCheckmark;
                [SelectedIndexes addObject:[[lentbooks objectAtIndex:indexPath.row] objectForKey:@"emailid"]];
                
                
            }
        [tableview deselectRowAtIndexPath:indexPath animated:YES];
    }*/
    
}

-(IBAction)segControlClicked:(id)sender
{
    switch (seg.selectedSegmentIndex) {
        case 0:
            flag=0;
            if (self.lentbooks.count==0) {
                tableview.hidden=true;
                lbl.hidden=FALSE;
            }
            else
            {
                tableview.hidden=false;
                lbl.hidden=true;
                
            }
            break;
        case 1:
            flag=1;
            if (self.borrowedbooks.count==0) {
                tableview.hidden=true;
                lbl.hidden=FALSE;
            }
            else
            {
                tableview.hidden=false;
                lbl.hidden=true;
                
            }
                        break;
        case 2:
            flag=2;
            if (self.completed.count==0) {
                tableview.hidden=true;
                lbl.hidden=FALSE;
            }
            else
            {
                tableview.hidden=false;
                lbl.hidden=true;
                
            }
                        break;
        default:
            break;
    }
    [tableview reloadData];
}
-(void)sendMail:(id)sender{
    //if selected indexes count not zero
    UIButton *btn=(UIButton*)sender;
    mailComposer = [[MFMailComposeViewController alloc]init];
    mailComposer.mailComposeDelegate = self;
    [mailComposer setTitle:@"Send Mail"];
    [mailComposer setSubject:@"Return Book"];
    [mailComposer setMessageBody:@"Please Return My Book Immediately as you've crossed due date" isHTML:NO];
    
    [mailComposer setToRecipients:[NSArray arrayWithObject:[[lentbooks objectAtIndex:btn.tag] objectForKey:@"emailid"]]];
    [self presentViewController:mailComposer animated:YES completion:nil];
   
}
-(void)mailComposeController:(MFMailComposeViewController*)controller didFinishWithResult:(MFMailComposeResult)result error:(NSError*)error {
    switch (result) {
        case MFMailComposeResultCancelled:
           
            alert=[[UIAlertView alloc] initWithTitle:@"Info!!" message:@"Mail: cancelled" delegate:self cancelButtonTitle:@"OK" otherButtonTitles:nil];
            [alert show];
            break;
        case MFMailComposeResultSaved:
            
            alert=[[UIAlertView alloc] initWithTitle:@"Info!!" message:@"Mail: saved" delegate:self cancelButtonTitle:@"OK" otherButtonTitles:nil];
            [alert show];
            break;
        case MFMailComposeResultSent:
            
            alert=[[UIAlertView alloc] initWithTitle:@"Info!!" message:@"Mail: sent" delegate:self cancelButtonTitle:@"OK" otherButtonTitles:nil];
            [alert show];
            break;
        case MFMailComposeResultFailed:
           
            alert=[[UIAlertView alloc] initWithTitle:@"Info!!" message:@"Mail: failed" delegate:self cancelButtonTitle:@"OK" otherButtonTitles:nil];
            [alert show];
            break;
        default:
            
            alert=[[UIAlertView alloc] initWithTitle:@"Info!!" message:@"Mail: not sent" delegate:self cancelButtonTitle:@"OK" otherButtonTitles:nil];
            [alert show];
            break;
    
    }
    [self dismissViewControllerAnimated:YES completion:nil];
}
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    switch (flag) {
        case 1:
            return 100;
            break;
        case 2:
            return 100;
            break;
        default:
            return 105;
            break;
    }
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end

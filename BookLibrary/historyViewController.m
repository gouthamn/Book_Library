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
@interface historyViewController ()

@end

@implementation historyViewController
@synthesize seg,lentbooks,borrowedbooks,completed,tableview,remind,mailComposer,SelectedIndexes;
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
            return 1;
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
    
    switch (flag) {
        case 1:
            cell.imgview.image=[UIImage imageNamed:@"books.jpeg"];
            cell.nameLabel.text=@"Beginning iPhone Development";
            cell.idLabel.text=@"Exploring the iPhone SDK";
            break;
        case 2:
            cell.imgview.image=[UIImage imageNamed:@"books.jpeg"];
            cell.nameLabel.text=@"Beginning iPhone Development";
            cell.idLabel.text=@"Exploring the iPhone SDK";
            break;
        default:
            if ([SelectedIndexes containsObject:[NSNumber numberWithInt:indexPath.row]]) {
                cell.accessoryType=UITableViewCellAccessoryCheckmark;
            }
            else
            {
                cell.accessoryType=UITableViewCellAccessoryNone;
            }
            cell.imgview.image=[UIImage imageNamed:@"books.jpeg"];
            cell.nameLabel.text=@"Beginning iPhone Development";
            cell.idLabel.text=@"Exploring the iPhone SDK";

            break;
    }
                
    
    return cell;
}
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    if (flag==0) {
        
    
        UITableViewCell *cell = [tableview cellForRowAtIndexPath:indexPath];
        
            if(cell.accessoryType==UITableViewCellAccessoryCheckmark)
            {
                cell.accessoryType=UITableViewCellAccessoryNone;
                
            [SelectedIndexes removeObject:[lentbooks objectAtIndex:indexPath.row]];
                
            }
            else
            {
                cell.accessoryType = UITableViewCellAccessoryCheckmark;
                [SelectedIndexes addObject:[lentbooks objectAtIndex:indexPath.row]];
                
                
            }
        [tableview deselectRowAtIndexPath:indexPath animated:YES];
    }
    
}

-(IBAction)segcontrolclicked:(id)sender
{
    switch (seg.selectedSegmentIndex) {
        case 0:
            flag=0;
            break;
        case 1:
            flag=1;
            break;
        case 2:
            flag=2;
            break;
        default:
            break;
    }
    [tableview reloadData];
}
-(void)sendMail:(id)sender{
    //if selected indexes count not zero
    mailComposer = [[MFMailComposeViewController alloc]init];
    mailComposer.mailComposeDelegate = self;
    [mailComposer setTitle:@"Send Mail"];
    [mailComposer setSubject:@"Test mail"];
    [mailComposer setMessageBody:@"Testing message for the test mail" isHTML:NO];
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

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end

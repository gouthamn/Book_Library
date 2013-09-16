//
//  bookdetailsViewController.m
//  SidebarDemo
//
//  Created by Goutham on 12/09/2013.
//  Copyright (c) 2013 Appcoda. All rights reserved.
//

#import "bookdetailsViewController.h"
#import "tablecell.h"
@interface bookdetailsViewController ()

@end

@implementation bookdetailsViewController
@synthesize outputarray,tabledatasource;
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
    self.title=@"Book Details";
    headers=@[@"Author",@"Publisher",@"Genre",@"Description",@"Status"];
    tabledatasource=[[NSMutableArray alloc] initWithObjects:@"Dave Mark & Jeff Lavarche",@"Apress(July21,2009)",@"computers",@"Features the best practices in the art and science of constructing software--topics include design, applying good techniques to construction, eliminating errors, planning, managing construction activities, and relating personal character to superior software. Original. (Intermediate)",@"Available", nil];
   // UIBarButtonItem *btn = [[UIBarButtonItem alloc] initWithImage:[UIImage imageNamed:@"back-button.png"] style:UIBarButtonItemStylePlain target:self action:nil];
    
   // [self.navigationItem setLeftBarButtonItem:btn];
	// Do any additional setup after loading the view.
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
    return 7;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"tablecell";
    
    tablecell *cell = [tableView
                       dequeueReusableCellWithIdentifier:CellIdentifier];
    UITableViewCell *cell1=[tableView dequeueReusableCellWithIdentifier:@"Cell"];
    UITableViewCell *cell2=[tableView dequeueReusableCellWithIdentifier:@"Cell2"];
    if (cell == nil)
    {
        cell = [[tablecell alloc]
                initWithStyle:UITableViewCellStyleDefault
                reuseIdentifier:CellIdentifier];
    }
    if (cell1 == nil)
    {
        cell1 = [[UITableViewCell alloc]
                initWithStyle:UITableViewCellStyleDefault
                reuseIdentifier:@"Cell"];
    }
    if (cell2 == nil)
    {
        cell2 = [[UITableViewCell alloc]
                 initWithStyle:UITableViewCellStyleDefault
                 reuseIdentifier:@"Cell2"];
    }
    
    switch (indexPath.row) {
        case 0:
            cell.imgview.image=[UIImage imageNamed:@"books.jpeg"];
            cell.nameLabel.text=@"Beginning iPhone Development";
            cell.idLabel.text=@"Exploring the iPhone SDK";
           
            CGSize expsize = [cell.nameLabel.text sizeWithFont:cell.nameLabel.font constrainedToSize:CGSizeMake(165.0, INFINITY) lineBreakMode:cell.nameLabel.lineBreakMode];
            CGSize expsize2 = [cell.idLabel.text sizeWithFont:cell.idLabel.font constrainedToSize:CGSizeMake(165.0, INFINITY) lineBreakMode:cell.idLabel.lineBreakMode];
         
            customnumberofstars = [[DLStarRatingControl alloc] initWithFrame:CGRectMake(88,expsize.height + expsize2.height +20, 140, 41) andStars:5 isFractional:YES];
            customnumberofstars.delegate=self;
            customnumberofstars.backgroundColor=[UIColor clearColor];
            customnumberofstars.rating=4.0;
            customnumberofstars.enabled=false;
            [cell.contentView addSubview:customnumberofstars];
            return cell;
            break;
         case 6:
            return cell2;
            break;
        default:
            cell1.detailTextLabel.text=[tabledatasource objectAtIndex:indexPath.row-1];
            cell1.textLabel.text=[headers objectAtIndex:indexPath.row-1];
            return cell1;
            break;
    }
       
}
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    if (indexPath.row==0) {
        return 130;
    }
    else if (indexPath.row==6)
    {
        return 54;
    }
    else
    {
        NSString *str=[tabledatasource objectAtIndex:indexPath.row-1];
        UIFont *font=[UIFont systemFontOfSize:14];
        CGSize expsize = [str sizeWithFont:font constrainedToSize:CGSizeMake(274.0, INFINITY) lineBreakMode:UILineBreakModeWordWrap];
        
        return expsize.height+30;
    }
    
}

@end

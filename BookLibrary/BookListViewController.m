//
//  booklistViewController.m
//  SidebarDemo
//
//  Created by Goutham on 12/09/2013.
//  Copyright (c) 2013 Appcoda. All rights reserved.
//

#import "booklistViewController.h"
#import "tablecell.h"
#import "DBManager.h"
#import "BookDetailsViewController.h"
@interface booklistViewController ()

@end

@implementation booklistViewController

@synthesize tabledatasource,results,category,tableview,isArchive;
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
    self.title=category;
   
// Do any additional setup after loading the view.
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(BOOL)searchDisplayController:(UISearchDisplayController *)controller
shouldReloadTableForSearchString:(NSString *)searchString
{
    
    [self filterContentForSearchText:searchString
                               scope:[[self.searchDisplayController.searchBar scopeButtonTitles]
                                      objectAtIndex:[self.searchDisplayController.searchBar
                                                     selectedScopeButtonIndex]]];
    
    
    return YES;
}

- (BOOL)searchDisplayController:(UISearchDisplayController *)controller
shouldReloadTableForSearchScope:(NSInteger)searchOption
{
    [self filterContentForSearchText:[self.searchDisplayController.searchBar text]
                               scope:[[self.searchDisplayController.searchBar scopeButtonTitles]
                                      objectAtIndex:searchOption]];
    
    return YES;
}

- (void)filterContentForSearchText:(NSString*)searchText scope:(NSString*)scope

{
    int j=0;
    results=[[NSMutableArray alloc] init];
    NSMutableArray *searcharray=[[NSMutableArray alloc] init];
    for (int i=0;i<[tabledatasource count]; i++) {
        [searcharray addObject:[[tabledatasource objectAtIndex:i] objectForKey:@"title"]];
    }
    
   
    for (NSString *sTemp in searcharray) {
        NSRange range=[sTemp rangeOfString:searchText options:NSCaseInsensitiveSearch];
        if (range.length!=0) {
            [results addObject:[tabledatasource objectAtIndex:j]];
        }
        j++;
    }
  
}
-(void)searchDisplayControllerWillBeginSearch:(UISearchDisplayController *)controller
{
   self.searchDisplayController.searchResultsTableView.rowHeight=100;
}
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}



- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if ([tableView isEqual:self.searchDisplayController.searchResultsTableView]) {
        return [self.results count];
    }
    return [tabledatasource count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"tablecell";
    
    tablecell *cell = [self.tableview
                       dequeueReusableCellWithIdentifier:CellIdentifier];
    
    if (cell == nil)
    {
        cell = [[tablecell alloc]
                initWithStyle:UITableViewCellStyleDefault
                reuseIdentifier:CellIdentifier];
    }
     NSUserDefaults *defaults=[NSUserDefaults standardUserDefaults];
    customnumberofstars = [[DLStarRatingControl alloc] initWithFrame:CGRectMake(70,55,140, 41) andStars:5 isFractional:YES];
   customnumberofstars.delegate=self;
    customnumberofstars.backgroundColor=[UIColor clearColor];
    customnumberofstars.enabled=false;
   [cell.contentView addSubview:customnumberofstars];
    if ([tableView isEqual:self.searchDisplayController.searchResultsTableView]) {
        
        if ([defaults objectForKey:[[self.results objectAtIndex:indexPath.row] objectForKey:@"isbn" ]]!=nil) {
            cell.imgview.image=[UIImage imageWithData:[defaults objectForKey:[[self.results
                                                                               objectAtIndex:indexPath.row] objectForKey:@"isbn" ]]];
        }
        else
        {
            cell.imgview.image=[UIImage imageNamed:@"download1.jpeg"];
        }

       
        cell.nameLabel.text=[[self.results objectAtIndex:indexPath.row] objectForKey:@"title"] ;
        NSLog(@"%@",[[self.results objectAtIndex:indexPath.row] objectForKey:@"title"]);
        cell.idLabel.text=  [[self.results objectAtIndex:indexPath.row] objectForKey:@"author"];
        customnumberofstars.rating=[[[self.results objectAtIndex:indexPath.row] objectForKey:@"rating" ] doubleValue] ;
    }
    else
    {
        if ([defaults objectForKey:[[self.tabledatasource objectAtIndex:indexPath.row] objectForKey:@"isbn" ]]!=nil) {
            cell.imgview.image=[UIImage imageWithData:[defaults objectForKey:[[self.tabledatasource objectAtIndex:indexPath.row] objectForKey:@"isbn" ]]];
        }
        else
        {
            cell.imgview.image=[UIImage imageNamed:@"download1.jpeg"];
        }
         
          cell.nameLabel.text=[[self.tabledatasource objectAtIndex:indexPath.row] objectForKey:@"title"] ;
          cell.idLabel.text=  [[self.tabledatasource objectAtIndex:indexPath.row] objectForKey:@"author"];//assigning author name
          
          customnumberofstars.rating=[[[self.tabledatasource objectAtIndex:indexPath.row] objectForKey:@"rating" ] doubleValue] ;
    }
    
    return cell;
}
-(void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    
    NSIndexPath *indexPath=[self.tableview indexPathForSelectedRow];
    
    bookdetailsViewController *bookDetail=segue.destinationViewController;
    bookDetail.tabledatasource         =[NSMutableArray arrayWithObjects:[[self.tabledatasource objectAtIndex:indexPath.row] objectForKey:@"isbn" ],
                                       [[self.tabledatasource objectAtIndex:indexPath.row] objectForKey:@"title"],
                                       [[self.tabledatasource objectAtIndex:indexPath.row] objectForKey:@"author"],
                                       [[self.tabledatasource objectAtIndex:indexPath.row] objectForKey:@"publisher"],
                                       [[self.tabledatasource objectAtIndex:indexPath.row] objectForKey:@"category" ],
                                       [[self.tabledatasource objectAtIndex:indexPath.row] objectForKey:@"description"],
                                       [[self.tabledatasource objectAtIndex:indexPath.row] objectForKey:@"rating"],
                                       [[self.tabledatasource objectAtIndex:indexPath.row] objectForKey:@"copies"], nil];
    if (!isArchive) {
    
            if ([[[self.tabledatasource objectAtIndex:indexPath.row] objectForKey:@"copies"] isEqualToNumber:[NSNumber numberWithInt:0]]) {
                bookDetail.flag=2;
            }
            else
            {
                bookDetail.flag=1;
            }
    }
    else{
        bookDetail.flag=3;
    }
}
-(NSString*)tableView:(UITableView *)tableView titleForDeleteConfirmationButtonForRowAtIndexPath:(NSIndexPath *)indexPath
{
  
    return @"Archive";
}
-(UITableViewCellEditingStyle)tableView:(UITableView *)tableView editingStyleForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (isArchive) {
        return UITableViewCellEditingStyleNone;
    }
    return UITableViewCellEditingStyleDelete;
}
-(UIView*)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section
{
    return [UIView new];
}
-(void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath{
    
    
        if(editingStyle == UITableViewCellEditingStyleDelete){
        [[DBManager getSharedInstance] moveToArchive:[[self.tabledatasource objectAtIndex:indexPath.row] objectForKey:@"isbn" ]];
        [tabledatasource removeObjectAtIndex:indexPath.row];
        [tableView deleteRowsAtIndexPaths:[NSArray arrayWithObject:indexPath] withRowAnimation:UITableViewRowAnimationFade];
        [[NSNotificationCenter defaultCenter] postNotificationName:@"deleted" object:nil];
       }
    
}


-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    
    NSIndexPath *index=[self.tableview indexPathForSelectedRow];
    if(index!=nil)
    {
        [self.tableview deselectRowAtIndexPath:index animated:YES];
    }
}
@end

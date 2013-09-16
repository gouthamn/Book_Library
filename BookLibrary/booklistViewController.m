//
//  booklistViewController.m
//  SidebarDemo
//
//  Created by Goutham on 12/09/2013.
//  Copyright (c) 2013 Appcoda. All rights reserved.
//

#import "booklistViewController.h"
#import "tablecell.h"
@interface booklistViewController ()

@end

@implementation booklistViewController
@synthesize tabledatasource,results,category,tableview;
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
    self.title=[category stringByAppendingString:@" Books"];
    
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
    NSMutableArray *searcharray=[[NSMutableArray alloc] init];
    for (int i=0;i<[tabledatasource count]; i++) {
        [searcharray addObject:[tabledatasource objectAtIndex:i]];
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
    self.searchDisplayController.searchResultsTableView.rowHeight=89;
}
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}



- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if ([tableView isEqual:self.searchDisplayController.searchResultsTableView]) {
        return [results count];
    }
    return 1;
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
    if ([tableView isEqual:self.searchDisplayController.searchResultsTableView]) {
     
    }
    else
    {
        cell.imgview.image=[UIImage imageNamed:@"books.jpeg"];
        cell.nameLabel.text=@"Beginning iPhone Development";
        cell.idLabel.text=@"Exploring the iPhone SDK";
        customnumberofstars = [[DLStarRatingControl alloc] initWithFrame:CGRectMake(70,55,140, 41) andStars:5 isFractional:YES];
        customnumberofstars.delegate=self;
        customnumberofstars.backgroundColor=[UIColor clearColor];
        customnumberofstars.rating=4.0;
        customnumberofstars.enabled=false;
        [cell.contentView addSubview:customnumberofstars];
    }
    return cell;
}

-(void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath{
    
    if(editingStyle == UITableViewCellEditingStyleDelete){
        
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

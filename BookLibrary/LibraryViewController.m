//
//  libraryViewController.m
//  SidebarDemo
//
//  Created by Goutham on 12/09/2013.
//  Copyright (c) 2013 Appcoda. All rights reserved.
//

#import "libraryViewController.h"
#import "SWRevealViewController.h"
#import "booklistViewController.h"
#import "InitialViewController.h"
#import "DBManager.h"
#import "GradientButton.h"
@interface libraryViewController ()

@end

@implementation libraryViewController
@synthesize tabledatasource,archivedlist,tableview;
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
    if ([[NSUserDefaults standardUserDefaults] boolForKey:@"HasLaunchedOnce"] && [[DBManager getSharedInstance] totalBooks]==0) {
       [[NSUserDefaults standardUserDefaults] setBool:NO forKey:@"HasLaunchedOnce"];
        tableview.hidden=TRUE;
        
        GradientButton *scanbtn=[GradientButton buttonWithType:UIButtonTypeCustom];
        [scanbtn useGreenConfirmStyle];
        [scanbtn setTitle:@"Touch to Scan Book" forState:UIControlStateNormal];
       
        [scanbtn.titleLabel setShadowOffset:CGSizeMake(-3, 3)];
        scanbtn.titleLabel.shadowColor=[UIColor purpleColor];
        
        [scanbtn addTarget:self action:@selector(scanBook) forControlEvents:UIControlEventTouchUpInside];
        scanbtn.frame=CGRectMake(80,176,193, 107);
        [self.view addSubview:scanbtn];
        self.navigationController.navigationBarHidden=TRUE;
    UIGraphicsBeginImageContext(self.view.frame.size);
    [[UIImage imageNamed:@"book.jpg"] drawInRect:self.view.bounds];
    UIImage *image = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    self.view.backgroundColor=[UIColor colorWithPatternImage:image];
         // [self.revealViewController performSelector:@selector(revealToggle:) withObject:self];
    }
    
    else
    {
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(reload:) name:@"deleted" object:nil];
    self.title = @"Home";
   
    self.tabledatasource=[[DBManager getSharedInstance] getUniqueCategories];
    self.archivedlist=   [[DBManager getSharedInstance] findDetailForArchivedCategory];
    if ([archivedlist count]!=0) {
        NSMutableDictionary *dict=[[NSMutableDictionary alloc] init];
        [dict setValue:@"Archive" forKey:@"category"];
        [dict setValue:[NSNumber numberWithInt:[archivedlist count]] forKey:@"count"];
        [tabledatasource addObject:dict];
        }
        
        _sidebarButton.tintColor = [UIColor colorWithWhite:0.96f alpha:0.2f];
        
        // Set the side bar button action. When it's tapped, it'll show up the sidebar.
        _sidebarButton.target = self.revealViewController;
        _sidebarButton.action = @selector(revealToggle:);
        
        // Set the gesture
        [self.view addGestureRecognizer:self.revealViewController.panGestureRecognizer];
    }
    
  
}
-(void)scanBook
{
    [self performSegueWithIdentifier:@"scan" sender:self];
}
-(void)reload:(NSNotification*)notification
{
    NSLog(@"reload");
    [[NSNotificationCenter defaultCenter] removeObserver:self name:@"deleted" object:nil];
    [self viewDidLoad];
    [tableview reloadData];
}


- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    // Return the number of sections.
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    // Return the number of rows in the section.
    return [self.tabledatasource count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"Cell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier forIndexPath:indexPath];
    cell.textLabel.text=[[self.tabledatasource objectAtIndex:indexPath.row] objectForKey:@"category"];
    NSInteger i= [[[self.tabledatasource objectAtIndex:indexPath.row] objectForKey:@"count"] integerValue];
    if (i==1) {
       cell.detailTextLabel.text=[NSString stringWithFormat:@"(%@ Book)", [[self.tabledatasource objectAtIndex:indexPath.row] objectForKey:@"count"]]; 
    }
    else
    {
        cell.detailTextLabel.text=[NSString stringWithFormat:@"(%@ Books)", [[self.tabledatasource objectAtIndex:indexPath.row] objectForKey:@"count"]];
    }
    return cell;
}

-(NSString*)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section
{
    return @"Categories";
}
-(UIView*)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section
{
    return [UIView new];
}
-(void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    if ([segue.identifier isEqualToString:@"booklist"]) {
       
        NSIndexPath *indexPath=[self.tableview indexPathForSelectedRow];
        booklistViewController *booklist=segue.destinationViewController;
        NSString *category=[[self.tabledatasource objectAtIndex:indexPath.row]objectForKey:@"category"];
        booklist.category=category;
        if ([category isEqualToString:@"Archive"]) {
            booklist.tabledatasource=self.archivedlist;
            booklist.isArchive=TRUE;
        }
        else
        {
            booklist.tabledatasource=[[DBManager getSharedInstance] findDetailForCategory:booklist.category ];
        }
    }
    if ( [segue isKindOfClass: [SWRevealViewControllerSegue class]] ) {
        SWRevealViewControllerSegue *swSegue = (SWRevealViewControllerSegue*) segue;
        
        swSegue.performBlock = ^(SWRevealViewControllerSegue* rvc_segue, UIViewController* svc, UIViewController* dvc) {
            
            UINavigationController* navController = (UINavigationController*)self.revealViewController.frontViewController;
            [navController setViewControllers: @[dvc] animated: NO ];
            [self.revealViewController setFrontViewPosition: FrontViewPositionLeft animated: YES];
        };
        
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

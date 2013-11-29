//
//  AppDelegate.m
//  SidebarDemo
//
//  Created by Simon on 28/6/13.
//  Copyright (c) 2013 Appcoda. All rights reserved.
//

#import "AppDelegate.h"
#import "DBManager.h"
#import "Reachability.h"
#import "HistoryViewController.h"
@implementation AppDelegate
@synthesize reach,isbnlist;
- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions
{
    UILocalNotification *locationNotification = [launchOptions objectForKey:UIApplicationLaunchOptionsLocalNotificationKey];
    if (locationNotification) {
        // Set icon badge number to zero
        application.applicationIconBadgeNumber = 0;
    }
    // Override point for customization after application launch.
    
    UIImage *navBackgroundImage = [UIImage imageNamed:@"nav_bg"];
    [[UINavigationBar appearance] setBackgroundImage:navBackgroundImage forBarMetrics:UIBarMetricsDefault];
    
    [[UINavigationBar appearance] setTitleTextAttributes: [NSDictionary dictionaryWithObjectsAndKeys:
                                                           [UIColor colorWithRed:10.0/255.0 green:10.0/255.0 blue:10.0/255.0 alpha:1.0], UITextAttributeTextColor,
                                                           [UIColor colorWithRed:0.0 green:0.0 blue:0.0 alpha:0.8],UITextAttributeTextShadowColor,
                                                           [NSValue valueWithUIOffset:UIOffsetMake(0, 0)],
                                                           UITextAttributeTextShadowOffset,
                                                           [UIFont fontWithName:@"Helvetica-Light" size:20.0], UITextAttributeFont, nil]];
   
    [[NSUserDefaults standardUserDefaults] setBool:YES forKey:@"HasLaunchedOnce"];
    [[NSUserDefaults standardUserDefaults] synchronize];
    self.reach=[Reachability reachabilityForInternetConnection];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(checkConnection) name:kReachabilityChangedNotification object:nil];
    
    
    [self.reach startNotifier];
    
   /* if ([[DBManager getSharedInstance] totalBooks ]==0) {
        
    
    [[DBManager getSharedInstance] saveData:@"145551604x" title:@"Cross Roads"author:@"Paul Young" publisher:@"" category:@"Fiction" description:@"" rating:@"4" copies:0 archive:0];
    [[DBManager getSharedInstance] saveData:@"1937785459" title:@"Practical Programming: An Introduction to Computer Science Using Python 3"author:@"Paul Gries" publisher:@"" category:@"Computers" description:@"" rating:@"3.5" copies:0 archive:0];
    [[DBManager getSharedInstance] saveData:@"9780955301001" title:@"Ave Atque vale"author:@"Paul Young" publisher:@"" category:@"Uncategorised" description:@"" rating:@"0" copies:1 archive:0];
    [[DBManager getSharedInstance] saveData:@"0735619670" title:@"Code Complete"author:@"Steve McConnell" publisher:@"" category:@"Computers" description:@"" rating:@"4" copies:1 archive:1];
    [[DBManager getSharedInstance] saveData:@"1782163271" title:@"Boost. Asio C++ Network Programming"author:@"John Torjo" publisher:@"" category:@"Computers" description:@"" rating:@"4" copies:0 archive:0];
    
    
    [[DBManager getSharedInstance] saveData:@"1937785459" username:@"vivek" emailid:@"vivek@gmail.com" issuedate:@"15-10-2013" duedate:@"15-10-2013" status:1];
    [[DBManager getSharedInstance] saveData:@"145551604x" username:@"goutham" emailid:@"gouthamn@gmail.com" issuedate:@"15-10-2013" duedate:@"16-10-2013" status:1];
  [[DBManager getSharedInstance] saveData:@"1782163271" username:@"ujwal" emailid:@"ujwalp@gmail.com" issuedate:@"15-10-2013" duedate:@"18-10-2013" status:1];
    
    }*/
    
    return YES;
}
							
- (void)applicationWillResignActive:(UIApplication *)application
{
    // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
    // Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
}

- (void)applicationDidEnterBackground:(UIApplication *)application
{
    
    // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later. 
    // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
}

- (void)applicationWillEnterForeground:(UIApplication *)application
{
    // Called as part of the transition from the background to the inactive state; here you can undo many of the changes made on entering the background.
}

-(void)application:(UIApplication *)application didReceiveLocalNotification:(UILocalNotification *)notification
{
     application.applicationIconBadgeNumber = 0;
 //  UIApplicationState state = [application applicationState];
 //   if (state == UIApplicationStateActive) {
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Reminder"
                                                        message:notification.alertBody
                                                       delegate:self cancelButtonTitle:@"OK"
                                              otherButtonTitles:nil];
        [alert show];
    
    
    
    // Set icon badge number to zero
   
}
-(void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    NSLog(@"%d",buttonIndex);
    if (buttonIndex==[alertView cancelButtonIndex]) {
       
    }
}

- (void)applicationDidBecomeActive:(UIApplication *)application
{
    // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
    
    
}
-(void)checkConnection
{
    NSLog(@"check connecton");
    NetworkStatus networkstatus=[self.reach currentReachabilityStatus];
    if (networkstatus== NotReachable) {
        
    }
    else
    {
         
        [self performSelectorInBackground:@selector(updateData) withObject:nil];
    }
    
}
-(void)updateData
{
    
    isbnlist=[[NSMutableArray alloc] init];
    isbnlist=[[DBManager getSharedInstance] emptyISBN];
   
    if (isbnlist!=nil) {
        for (int i=0; i<[isbnlist count]; i++) {
            NSString *str=[NSString stringWithFormat:@"https://www.googleapis.com/books/v1/volumes?q=isbn:%@",[isbnlist objectAtIndex:i]];
                                                                                                            
            NSURL* jsonURL = [NSURL URLWithString:str];
            
                NSData* data = [NSData dataWithContentsOfURL:
                                jsonURL];
            [self fetchedData:data index:i];
       
            
        }
    }
    
}
- (void)fetchedData:(NSData *)responseData index:(int)i{
    //parse out the json data
    
    NSLog(@"fetched data");
    NSError* error;
    NSDictionary* json = [NSJSONSerialization
                          JSONObjectWithData:responseData //1
                          
                          options:kNilOptions
                          error:&error];
    if (json != nil &&
        error == nil)
    {
        if( [[json objectForKey:@"totalItems"] isEqualToNumber:[NSNumber numberWithInt:1]])
        {
            //extracting data from json object
            NSLog(@"Successfully deserialized...");
            
            NSDictionary* items = [json objectForKey:@"items"];
            NSString *publisher;
            NSString *author;
            NSString *category;
            NSString *description;
            NSString *rating;
            NSString *imgURL;
            NSString *title;
            NSData *imgdata;
            for(NSDictionary *dict in items)
            {
                
               title      = [[  dict objectForKey:@"volumeInfo"] objectForKey:@"title"] ;
                publisher  = [[  dict objectForKey:@"volumeInfo"] objectForKey:@"publisher"] ;
                author     = [[[ dict objectForKey:@"volumeInfo"] objectForKey:@"authors"]objectAtIndex:0];
                category   = [[[ dict objectForKey:@"volumeInfo"] objectForKey:@"categories"]objectAtIndex:0];
                description= [[  dict objectForKey:@"volumeInfo"] objectForKey:@"description"];
                description=[description stringByReplacingOccurrencesOfString:@"\"" withString:@"'"];
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
                [defaults setObject:imgdata forKey:[isbnlist objectAtIndex:i]];
            }
            
            [[DBManager getSharedInstance] updateISBN:[isbnlist objectAtIndex:i] title:title author:author publisher:publisher category:category description:description rating:rating];
            return;
        }
        
    }
    
}

- (void)applicationWillTerminate:(UIApplication *)application
{
    [[NSNotificationCenter defaultCenter] removeObserver:self name:kReachabilityChangedNotification object:nil];
    // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
}

@end

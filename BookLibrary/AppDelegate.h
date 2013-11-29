//
//  AppDelegate.h
//  SidebarDemo
//
//  Created by Simon on 28/6/13.
//  Copyright (c) 2013 Appcoda. All rights reserved.
//

// 145551604X
// 1937785459
// 1782163271
// 0735619670
// 9780955301001

#import <UIKit/UIKit.h>
@class Reachability;
@interface AppDelegate : UIResponder <UIApplicationDelegate,UIAlertViewDelegate>
{
    Reachability *reach;
}
@property (strong, nonatomic) UIWindow *window;
@property(nonatomic,retain) Reachability *reach;
@property(nonatomic,retain) NSMutableArray *isbnlist;
@end

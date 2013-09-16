//
//  bookdetailsViewController.h
//  SidebarDemo
//
//  Created by Goutham on 12/09/2013.
//  Copyright (c) 2013 Appcoda. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "DLStarRatingControl.h"
@interface bookdetailsViewController : UIViewController<UITableViewDataSource,UITableViewDelegate,DLStarRatingDelegate>
{
    NSMutableArray *outputarray;
    NSMutableArray *tabledatasource;
    NSArray *headers;
     DLStarRatingControl *customnumberofstars;
}
@property (nonatomic,retain) IBOutlet NSMutableArray *outputarray;
@property (nonatomic,retain) IBOutlet NSMutableArray *tabledatasource;

@end

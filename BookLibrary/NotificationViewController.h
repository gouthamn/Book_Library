//
//  NotificationViewController.h
//  BookLibrary
//
//  Created by Goutham on 08/10/2013.
//  Copyright (c) 2013 byteridge. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface NotificationViewController : UIViewController<UITableViewDataSource,UITableViewDelegate>
{
    
}
@property (nonatomic,retain) NSMutableArray *tabledatasource;
@property (nonatomic,retain) IBOutlet UITableView *tableview;
@end

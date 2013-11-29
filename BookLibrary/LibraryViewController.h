//
//  libraryViewController.h
//  SidebarDemo
//
//  Created by Goutham on 12/09/2013.
//  Copyright (c) 2013 Appcoda. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface libraryViewController : UIViewController<UITableViewDataSource,UITableViewDelegate>
{
    NSMutableArray *tabledatasource,*archivedlist;
}
@property (weak, nonatomic) IBOutlet UIBarButtonItem *sidebarButton;
@property (nonatomic,retain) NSMutableArray *tabledatasource,*archivedlist;
@property (nonatomic,retain) IBOutlet UITableView *tableview;
@end


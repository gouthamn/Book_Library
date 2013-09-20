//
//  DBManager.h
//  BookLibrary
//
//  Created by Goutham on 18/09/2013.
//  Copyright (c) 2013 byteridge. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <sqlite3.h>
@interface DBManager : NSObject
{
    NSString *databasePath;
}

+(DBManager*)getSharedInstance;
-(BOOL)createDB;
+(void)finalize;
- (BOOL) saveData:(NSString*)isbn title:(NSString*)title
           author:(NSString*)author publisher:(NSString*)publisher category:(NSString*)category description:(NSString*)description rating:(NSString*)rating copies:(NSInteger)copies archive:(BOOL)archive;
- (BOOL) saveData:(NSString*)isbn username:(NSString*)username
          emailid:(NSString*)emailid issuedate:(NSString*)issuedate duedate:(NSString*)duedate status:(BOOL)status;
- (BOOL) saveData:(NSString*)isbn
          emailid:(NSString*)emailid issuedate:(NSString*)issuedate duedate:(NSString*)duedate;
- (NSInteger)searchISBN:(NSString*)isbn;
-(NSInteger)searchcopies:(NSString*)isbn;
-(BOOL)updatecopies:(NSString*)isbn copies:(NSInteger)copies;
-(NSMutableArray*) finddetailsbyisbn:(NSString*)isbn;
@end

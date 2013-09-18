//
//  DBManager.m
//  BookLibrary
//
//  Created by Goutham on 18/09/2013.
//  Copyright (c) 2013 byteridge. All rights reserved.
//

#import "DBManager.h"

static DBManager *sharedInstance = nil;
static sqlite3 *database = nil;
static sqlite3_stmt *statement = nil;

@implementation DBManager

+(DBManager*)getSharedInstance{
    if (!sharedInstance) {
        sharedInstance = [[super allocWithZone:NULL]init];
        [sharedInstance createDB];
    }
    return sharedInstance;
}
 
-(BOOL)createDB{
    NSString *docsDir;
    NSArray *dirPaths;
    // Get the documents directory
    dirPaths = NSSearchPathForDirectoriesInDomains
    (NSDocumentDirectory, NSUserDomainMask, YES);
    docsDir = dirPaths[0];
    // Build the path to the database file
    databasePath = [[NSString alloc] initWithString:
                    [docsDir stringByAppendingPathComponent: @"booklibrary.db"]];
    BOOL isSuccess = YES;
    NSFileManager *filemgr = [NSFileManager defaultManager];
    if ([filemgr fileExistsAtPath: databasePath ] == NO)
    {
        NSLog(@"hello");
        const char *dbpath = [databasePath UTF8String];
        if (sqlite3_open(dbpath, &database) == SQLITE_OK)
        {
            char *errMsg;
            const char *sql_stmt =
            "CREATE TABLE IF NOT EXISTS BookDetail (ISBN TEXT,TITLE TEXT,AUTHOR TEXT, PUBLISHER TEXT, CATEGORY TEXT,DESCRIPTION TEXT,RATING TEXT,IMAGE BLOB,copies TEXT,archive bool)";
            if (sqlite3_exec(database, sql_stmt, NULL, NULL, &errMsg)
                != SQLITE_OK)
            {
                isSuccess = NO;
                
                NSLog(@"%s",sqlite3_errmsg(database));
                NSLog(@"Failed to create table");
            }
            else
            {
               sql_stmt= "CREATE TABLE IF NOT EXISTS transactions(ISBN TEXT,username TEXT,emailid TEXT, issuedate TEXT, duedate TEXT,status bool)";
                if (sqlite3_exec(database, sql_stmt, NULL, NULL, &errMsg)
                    != SQLITE_OK)
                {
                    isSuccess = NO;
                     NSLog(@"%s",sqlite3_errmsg(database));
                    NSLog(@"Failed to create table");
                }
                else
                {
                    sql_stmt= "CREATE TABLE IF NOT EXISTS completed(ISBN TEXT,emailid TEXT,issuedate TEXT,duedate TEXT)";
                    if (sqlite3_exec(database, sql_stmt, NULL, NULL, &errMsg)
                        != SQLITE_OK)
                    {
                        isSuccess = NO;
                         NSLog(@"%s",sqlite3_errmsg(database));
                        NSLog(@"Failed to create table");
                    }

                }
            }
            sqlite3_close(database);
            return  isSuccess;
        }
        else {
            isSuccess = NO;
            NSLog(@"Failed to open/create database");
        }
    }
    return isSuccess;
}
- (UIImage *)GetRawImage:(NSString *)imageUrlPath
{
    NSURL *imageURL = [NSURL URLWithString:imageUrlPath];
    NSData *data = [NSData dataWithContentsOfURL:imageURL];
    UIImage *image = [[UIImage alloc] initWithData:data];
    return image;
}
- (BOOL) saveData:(NSString*)isbn title:(NSString*)title
       author:(NSString*)author publisher:(NSString*)publisher category:(NSString*)category description:(NSString*)description rating:(NSString*)rating imgurl:(NSString*)imgurl copies:(NSString*)copies archive:(BOOL)archive
{
    const char *dbpath = [databasePath UTF8String];
    UIImage *myImage =  [self GetRawImage:imgurl]; //Get image from method below
    if(myImage != nil)
    {
        NSData *imgData = UIImagePNGRepresentation(myImage);
    if (sqlite3_open(dbpath, &database) == SQLITE_OK)
    {
    NSString *insertSQL = [NSString stringWithFormat:@"insert into BookDetail values(\"%@\",\"%@\", \"%@\", \"%@\",\"%@\",\"%@\",\"%@\",\"%@\",\"%@\",\"%d\")",isbn,title,author,publisher,category,description,rating,imgData,copies,archive];
                               const char *insert_stmt = [insertSQL UTF8String];
                                sqlite3_prepare_v2(database, insert_stmt,-1, &statement, NULL);
                                if (sqlite3_step(statement) == SQLITE_DONE)
                                {
                                    return YES;
                                }
                                else {
                                    return NO;
                                }
                                sqlite3_reset(statement);
                                }
    }
                                return NO;
                                
}
- (BOOL) saveData:(NSString*)isbn username:(NSString*)username
           emailid:(NSString*)emailid issuedate:(NSString*)issuedate duedate:(NSString*)duedate status:(BOOL)status
{
    const char *dbpath = [databasePath UTF8String];
    if (sqlite3_open(dbpath, &database) == SQLITE_OK)
    {
        NSString *insertSQL = [NSString stringWithFormat:@"insert into BookDetail values(\"%@\",\"%@\", \"%@\", \"%@\",\"%@\",\"%d\")",isbn,username,emailid,issuedate,duedate,status];
        const char *insert_stmt = [insertSQL UTF8String];
        sqlite3_prepare_v2(database, insert_stmt,-1, &statement, NULL);
        if (sqlite3_step(statement) == SQLITE_DONE)
        {
            return YES;
        }
        else {
            return NO;
        }
        sqlite3_reset(statement);
    }
    return NO;
}
- (BOOL) saveData:(NSString*)isbn
          emailid:(NSString*)emailid issuedate:(NSString*)issuedate duedate:(NSString*)duedate
{
    const char *dbpath = [databasePath UTF8String];
    if (sqlite3_open(dbpath, &database) == SQLITE_OK)
    {
        NSString *insertSQL = [NSString stringWithFormat:@"insert into BookDetail values(\"%@\",\"%@\", \"%@\", \"%@\")",isbn,emailid,issuedate,duedate];
        const char *insert_stmt = [insertSQL UTF8String];
        sqlite3_prepare_v2(database, insert_stmt,-1, &statement, NULL);
        if (sqlite3_step(statement) == SQLITE_DONE)
        {
            return YES;
        }
        else {
            return NO;
        }
        sqlite3_reset(statement);
    }
    return NO;
}
- (NSArray*) findByRegisterNumber:(NSString*)registerNumber
{
            const char *dbpath = [databasePath UTF8String];
            if (sqlite3_open(dbpath, &database) == SQLITE_OK)
            {
                NSString *querySQL = [NSString stringWithFormat:
                                      @"select name, department, year from studentsDetail where regno=\"%@\"",registerNumber];
                const char *query_stmt = [querySQL UTF8String];
                NSMutableArray *resultArray = [[NSMutableArray alloc]init];
                if (sqlite3_prepare_v2(database,
                                       query_stmt, -1, &statement, NULL) == SQLITE_OK)
                {
                    if (sqlite3_step(statement) == SQLITE_ROW)
                    {
                        NSString *name = [[NSString alloc] initWithUTF8String:
                                          (const char *) sqlite3_column_text(statement, 0)];
                        [resultArray addObject:name];
                        NSString *department = [[NSString alloc] initWithUTF8String:
                                                (const char *) sqlite3_column_text(statement, 1)];
                        [resultArray addObject:department];
                        NSString *year = [[NSString alloc]initWithUTF8String:
                                          (const char *) sqlite3_column_text(statement, 2)];
                        [resultArray addObject:year];
                        return resultArray;
                    }
                    else{
                        NSLog(@"Not found");
                        return nil;
                    }
                    sqlite3_reset(statement);
                }
            }
            return nil;
        }
@end

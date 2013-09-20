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
   // /Users/goutham/Library/Application Support/iPhone Simulator/6.1/Applications/B62CF871-0C8B-4DC2-802F-FEB41126BABA/Documents/booklibrary.db
    NSLog(@"%@",databasePath);
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
            "CREATE TABLE IF NOT EXISTS BookDetail (ISBN TEXT,TITLE TEXT,AUTHOR TEXT, PUBLISHER TEXT, CATEGORY TEXT,DESCRIPTION TEXT,RATING TEXT,copies int,archive bool)";
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
           author:(NSString*)author publisher:(NSString*)publisher category:(NSString*)category description:(NSString*)description rating:(NSString*)rating copies:(NSInteger)copies archive:(BOOL)archive;
{
   /* const char *dbpath = [databasePath UTF8String];
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
                                    NSLog(@"%s",sqlite3_errmsg(database));
                                    return NO;
                                }
                                sqlite3_reset(statement);
                                }
    }
    NSLog(@"%s",sqlite3_errmsg(database));
                                return NO;
    */
    
    BOOL isInserted=YES;
    sqlite3_stmt *statement;
   
    
        const char *dbpath = [databasePath UTF8String];
        
        if (sqlite3_open(dbpath, &database) == SQLITE_OK)
        {
            NSString *insertSQL = [NSString stringWithFormat:@"insert into BookDetail values(\"%@\",\"%@\", \"%@\", \"%@\",\"%@\",\"%@\",\"%@\",\"%d\",\"%d\")",isbn,title,author,publisher,category,description,rating,copies,archive];
           
           
            const char *insert_stmt = [insertSQL UTF8String];
            if(sqlite3_prepare_v2(database, insert_stmt, -1, &statement, NULL) == SQLITE_OK)
            {
           
            if (sqlite3_step(statement) == SQLITE_DONE)
            {
                NSLog(@"string added");
                
            } else
            {
                NSLog(@"%s",sqlite3_errmsg(database));
                isInserted=NO;
            }
            }
            sqlite3_finalize(statement);
            sqlite3_close(database);
        }
    
    return isInserted;
}

- (BOOL) saveData:(NSString*)isbn username:(NSString*)username
           emailid:(NSString*)emailid issuedate:(NSString*)issuedate duedate:(NSString*)duedate status:(BOOL)status
{
    bool isinserted=NO;
    const char *dbpath = [databasePath UTF8String];
    if (sqlite3_open(dbpath, &database) == SQLITE_OK)
    {
        NSString *insertSQL = [NSString stringWithFormat:@"insert into transactions values(\"%@\",\"%@\", \"%@\", \"%@\",\"%@\",\"%d\")",isbn,username,emailid,issuedate,duedate,status];
        const char *insert_stmt = [insertSQL UTF8String];
        sqlite3_prepare_v2(database, insert_stmt,-1, &statement, NULL);
        if (sqlite3_step(statement) == SQLITE_DONE)
        {
            isinserted=YES;
        }
        else {
            isinserted=NO;
        }
        sqlite3_reset(statement);
    }
    sqlite3_close(database);
    return isinserted;
}
- (BOOL) saveData:(NSString*)isbn
          emailid:(NSString*)emailid issuedate:(NSString*)issuedate duedate:(NSString*)duedate
{
    bool isinserted=NO;
    const char *dbpath = [databasePath UTF8String];
    if (sqlite3_open(dbpath, &database) == SQLITE_OK)
    {
        NSString *insertSQL = [NSString stringWithFormat:@"insert into completed values(\"%@\",\"%@\", \"%@\", \"%@\")",isbn,emailid,issuedate,duedate];
        const char *insert_stmt = [insertSQL UTF8String];
        sqlite3_prepare_v2(database, insert_stmt,-1, &statement, NULL);
        if (sqlite3_step(statement) == SQLITE_DONE)
        {
            isinserted=YES;
            
        }
        else {
            isinserted=NO;
        }
        sqlite3_reset(statement);
    }
    return isinserted;
}
- (NSInteger)searchISBN:(NSString*)isbn
{
    NSInteger count=0;
    const char *dbpath = [databasePath UTF8String];
    if (sqlite3_open(dbpath, &database) == SQLITE_OK)
    {
        NSString *querySQL = [NSString stringWithFormat:
                              @"select count(*) from bookDetail where isbn=\"%@\" and archive=0",isbn];
        const char *query_stmt = [querySQL UTF8String];
        if (sqlite3_prepare_v2(database,
                               query_stmt, -1, &statement, NULL) == SQLITE_OK)
        {
            if (sqlite3_step(statement) == SQLITE_ROW)
            {
                count=sqlite3_column_int(statement, 0);
            }
            sqlite3_reset(statement);
        }
       
        
    }
    sqlite3_close(database);
    return count;
}
-(NSMutableArray*) finddetailsbyisbn:(NSString*)isbn
{
    NSMutableArray *arr;
    const char *dbpath = [databasePath UTF8String];
    if (sqlite3_open(dbpath, &database) == SQLITE_OK)
    {
        NSString *querySQL = [NSString stringWithFormat:
                              @"select * from bookDetail where isbn=\"%@\" and archive=0",isbn];
       
        const char *query_stmt = [querySQL UTF8String];
        if (sqlite3_prepare_v2(database,
                               query_stmt, -1, &statement, NULL) == SQLITE_OK)
        {
            if (sqlite3_step(statement) == SQLITE_ROW)
            {
                NSString *publisher = [[NSString alloc] initWithUTF8String:(const char *) sqlite3_column_text(statement, 3)];
                NSString *author=[[NSString alloc] initWithUTF8String:(const char *) sqlite3_column_text(statement, 2)];
                NSString *category=[[NSString alloc] initWithUTF8String:(const char *) sqlite3_column_text(statement, 4)];
                NSString *description=[[NSString alloc] initWithUTF8String:(const char *) sqlite3_column_text(statement, 5)];
                NSString *rating=[[NSString alloc] initWithUTF8String:(const char *) sqlite3_column_text(statement, 6)];
              //  NSData *imgdata=[NSData dataWithBytes:sqlite3_column_blob(statement, 7) length:sqlite3_column_bytes(statement, 7)] ;
                NSString *title=[[NSString alloc] initWithUTF8String:(const char *) sqlite3_column_text(statement, 1)];
                int copies=sqlite3_column_int(statement, 8);
            
            arr=[[NSMutableArray alloc] initWithObjects:isbn,title,author,publisher,category,description,rating,copies,nil];
               
            }
            sqlite3_reset(statement);
        }
         sqlite3_close(database);
    }
    return arr;
    
}
-(NSInteger)searchcopies:(NSString*)isbn
{
    NSInteger count=0;
    const char *dbpath = [databasePath UTF8String];
    if (sqlite3_open(dbpath, &database) == SQLITE_OK)
    {
        NSString *querySQL = [NSString stringWithFormat:
                              @"select copies from bookDetail where isbn=\"%@\" and archive=0",isbn];
        const char *query_stmt = [querySQL UTF8String];
        if (sqlite3_prepare_v2(database,
                               query_stmt, -1, &statement, NULL) == SQLITE_OK)
        {
            if (sqlite3_step(statement) == SQLITE_ROW)
            {
                count=sqlite3_column_int(statement, 0);

            }
            sqlite3_reset(statement);
        }
        
        
    }
    sqlite3_close(database);
    return count;

}
-(BOOL)updatecopies:(NSString*)isbn copies:(NSInteger)copies
{
    NSInteger count=[self searchcopies:isbn];
    NSInteger sum=count + copies;
    BOOL success=NO;
    const char *dbpath = [databasePath UTF8String];
    if (sqlite3_open(dbpath, &database) == SQLITE_OK)
    {
        
        NSString *updateSQL = [NSString stringWithFormat:
                              @"update bookDetail set copies=\"%d\" where isbn=\"%@\" and archive=0",sum,isbn];
        const char *query_stmt = [updateSQL UTF8String];
        if (sqlite3_prepare_v2(database,
                               query_stmt, -1, &statement, NULL) == SQLITE_OK)
        {
            if (sqlite3_step(statement) == SQLITE_DONE)
            {
                success=YES;
            }
            else {
                NSLog(@"%s",sqlite3_errmsg(database));
                success=NO;
            }
            sqlite3_reset(statement);

            
        }
        
        
    }
    sqlite3_close(database);
    return success;
    
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

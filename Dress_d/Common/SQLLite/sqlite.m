//
//  sqlite.m
//  LBSUserApp
//
//  Created by iMac on 11-7-15.
//  Copyright 2011年 __MyCompanyName__. All rights reserved.
//

#import "sqlite.h"

@implementation SQLLite
@synthesize path;
@synthesize arrayColume;
@synthesize columeCount;

- (BOOL)createEditableCopyOfDatabaseIfNeeded:(NSString*)db_file
{
    if ([db_file isEqualToString:@""])
        return NO;
    
    // Testing for existence
    BOOL success;
    NSFileManager *fileManager = [NSFileManager defaultManager];
    NSError *error;
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory,
                                                         NSUserDomainMask, YES);
    NSString *documentsDirectory = [paths objectAtIndex:0];
    NSString *writableDBPath =
    [documentsDirectory stringByAppendingPathComponent:db_file];
    
    self.path = writableDBPath;
    
    success = [fileManager fileExistsAtPath:writableDBPath];
    if (success)
        return YES;
    
    // The writable database does not exist, so copy the default to
    // the appropriate location.
    NSString *defaultDBPath = [[[NSBundle mainBundle] resourcePath]
                               stringByAppendingPathComponent:db_file];
    success = [fileManager copyItemAtPath:defaultDBPath
                                   toPath:writableDBPath
                                    error:&error];
    if(!success)
    {
        NSAssert1(0,@"Failed to create writable database file with Message : '%@'.", [error localizedDescription]);
        return NO;
    }
    
    return YES;
}

- (id)initWithPath:(NSString*)dbPath
{ 
    self = [super init];
    
    arrayColume = [[NSMutableArray alloc] init];
    [self createEditableCopyOfDatabaseIfNeeded:dbPath];
 
    return self;     
} 

- (sqlite3_stmt *)prepare:(NSString*)sql
{
    if ( inUse )
        return 0;
    
//    ////NSLog(@"path-%@", path);
    int rc; 
    // DB 열기 
    rc = sqlite3_open([path UTF8String], &mdb);
    if ( mdb == NULL )
        return 0;
//    ////NSLog(@"rc-%d", rc);
    if ( rc == SQLITE_OK ) 
    { 
//        ////NSLog(@"prepare");
        const char *utfsql = [sql UTF8String];
        sqlite3_stmt *statement;
        if ( sqlite3_prepare_v2(mdb, utfsql, -1, &statement, NULL)==SQLITE_OK )
            return statement;
        else
            return 0;
    }
    else if ( rc == SQLITE_BUSY )
    {
        do
        {
            inUse = YES;
            rc = sqlite3_open([path UTF8String], &mdb);
            usleep(5);
        }
        while ( rc != SQLITE_OK );
        
        const char *utfsql = [sql UTF8String];
        sqlite3_stmt *statement;
        if ( sqlite3_prepare_v2(mdb, utfsql, -1, &statement, NULL)==SQLITE_OK )
            return statement;
        else
            return 0;
    }
    else
        return 0;
}

- (NSString *)lookupSingularSQL:(NSString*)sql column:(int)col
{
    sqlite3_stmt *statement = [self prepare:sql];
    NSString * rt=nil;
    char buf[500];
    if ( statement ) 
    {
        if ( sqlite3_step(statement) == SQLITE_ROW ) 
        {
            if ( sqlite3_column_type(statement, col) == SQLITE_TEXT ) 
            {
                rt = [NSString stringWithUTF8String:(const char*)sqlite3_column_text(statement, col)];
            } 
            else if ( sqlite3_column_type(statement, col) == SQLITE_INTEGER ) 
            {
                sprintf(buf, "%d", sqlite3_column_int(statement, col));
                rt = [NSString stringWithUTF8String: buf];
            } 
            else //필드가 빈 경우
            {
                rt = @"";
            }
        }
    }
    inUse = NO;
    sqlite3_finalize(statement);
    sqlite3_close(mdb);
//    ////NSLog(@"close");

    //if ( [rt isEqualToString:@"a"] == NO )
        return rt;
    //else
     //   return nil;
}

- (NSMutableArray *)lookupSQL:(NSString*)sql column:(int)col
{
    NSMutableArray *result = [[NSMutableArray alloc] init];
    sqlite3_stmt *statement = [self prepare:sql];
    char buf[500];
    if ( statement ) 
    {
        while ( sqlite3_step(statement) == SQLITE_ROW ) 
        {
            if ( sqlite3_column_type(statement, col) == SQLITE_TEXT ) 
            {
                NSString* rt = [NSString stringWithUTF8String:(const char*)sqlite3_column_text(statement, col)];
                if ( [rt isEqualToString:@"a"] == NO )
                    [result addObject:rt];
            } 
            else if ( sqlite3_column_type(statement, col) == SQLITE_INTEGER ) 
            {
                sprintf(buf, "%d", sqlite3_column_int(statement, col));
                NSString* rt = [NSString stringWithUTF8String: buf];
                if ( [rt isEqualToString:@"a"] == NO )//a- 빈 필드 
                   [result addObject:rt];
            } 
            else //필드가 빈 경우
            {
                [result addObject:@""];
            }
        }
    }
    inUse = NO;
    sqlite3_finalize(statement);
    sqlite3_close(mdb);
//    ////NSLog(@"close");

    return result;
}

- (void)updateSQL:(NSString *)sql
{
    sqlite3_stmt *statement = [self prepare:sql];
    if ( statement )
    { 
        sqlite3_step(statement);
    }
    
    inUse = NO;
    sqlite3_finalize(statement);
    sqlite3_close(mdb);
}


- (void)getColumeInfo:(NSString *)sql
{
    [arrayColume removeAllObjects];
    columeCount = 0;
    
    sqlite3_stmt *statement = [self prepare:sql];
    char* field;
    if ( statement )
    { 
        columeCount =  sqlite3_column_count(statement);
        for (int i = 0; i < columeCount; i++) 
        {
            field = (char*)sqlite3_column_name(statement, i);
            NSString* fieldName = [NSString stringWithCString:(const char*)field encoding:NSUTF8StringEncoding];
            [arrayColume addObject:fieldName];
        }
    }
    
    inUse = NO;
    sqlite3_finalize(statement);
    sqlite3_close(mdb);
}

- (int)getColumeId:(NSString *)fieldName
{
    int nId = 0;
    
    for (int i = 0; i < columeCount; i++)
    {
        NSString* field = [arrayColume objectAtIndex:i];
        if ([fieldName isEqualToString:field] == YES)
        {
            nId = i;
            break;
        }
    }
    return nId;
}

- (void)bindObject:(id)obj toColumn:(int)idx inStatement:(sqlite3_stmt*)pStmt;
{
    if ( pStmt == 0 )
        return;
    
    if ((!obj) || ((NSNull *)obj == [NSNull null])) {
        sqlite3_bind_null(pStmt, idx);
    }
    
    // FIXME - someday check the return codes on these binds.
    else if ([obj isKindOfClass:[NSData class]]) {
        sqlite3_bind_blob(pStmt, idx, [obj bytes], (int)[obj length], SQLITE_STATIC);
    }
    else if ([obj isKindOfClass:[NSDate class]]) {
        sqlite3_bind_double(pStmt, idx, [obj timeIntervalSince1970]);
    }
    else if ([obj isKindOfClass:[NSNumber class]]) {
        
        if (strcmp([obj objCType], @encode(BOOL)) == 0) {
            sqlite3_bind_int(pStmt, idx, ([obj boolValue] ? 1 : 0));
        }
        else if (strcmp([obj objCType], @encode(int)) == 0) {
            sqlite3_bind_int64(pStmt, idx, [obj longValue]);
        }
        else if (strcmp([obj objCType], @encode(long)) == 0) {
            sqlite3_bind_int64(pStmt, idx, [obj longValue]);
        }
        else if (strcmp([obj objCType], @encode(long long)) == 0) {
            sqlite3_bind_int64(pStmt, idx, [obj longLongValue]);
        }
        else if (strcmp([obj objCType], @encode(float)) == 0) {
            sqlite3_bind_double(pStmt, idx, [obj floatValue]);
        }
        else if (strcmp([obj objCType], @encode(double)) == 0) {
            sqlite3_bind_double(pStmt, idx, [obj doubleValue]);
        }
        else {
            sqlite3_bind_text(pStmt, idx, [[obj description] UTF8String], -1, SQLITE_STATIC);
        }
    }
    else {
        sqlite3_bind_text(pStmt, idx, [[obj description] UTF8String], -1, SQLITE_STATIC);
    }
}

- (BOOL)executeUpdate:(NSString*)sql error:(NSError**)outErr withArgumentsInArray:(NSArray*)arrayArgs orVAList:(va_list)args
{
    
    int rc              = 0x00;
    int numberOfRetries = 0;
    
    BOOL retry          = NO;

    sqlite3_stmt *statement = [self prepare:sql];
    if ( statement )
    {
        id obj;
        int idx = 0;
        int queryCount = sqlite3_bind_parameter_count(statement);
        
        while (idx < queryCount) {
            
            inUse = YES;
            if (arrayArgs) {
                obj = [arrayArgs objectAtIndex:idx];
            }
            else {
                obj = va_arg(args, id);
            }
            
            
            if (traceExecution) {
                //NSLog(@"obj: %@", obj);
            }
            
            idx++;
            
            [self bindObject:obj toColumn:idx inStatement:statement];
        }
        
        if (idx != queryCount)
        {
            sqlite3_finalize(statement);
            sqlite3_close(mdb);
            inUse = NO;
            return NO;
        }
        
        /* Call sqlite3_step() to run the virtual machine. Since the SQL being
         ** executed is not a SELECT statement, we assume no data will be returned.
         */
        numberOfRetries = 0;
        do {
            inUse = YES;
            rc      = sqlite3_step(statement);
            retry   = NO;
            
            if (SQLITE_BUSY == rc) {
                // this will happen if the db is locked, like if we are doing an update or insert.
                // in that case, retry the step... and maybe wait just 10 milliseconds.
                retry = YES;
                usleep(20);
                
                if (busyRetryTimeout && (numberOfRetries++ > busyRetryTimeout)) {
                    //NSLog(@"%s:%d Database busy (%@)", __FUNCTION__, __LINE__, [self databasePath]);
                    //NSLog(@"Database busy");
                    retry = NO;
                }
            }
            else if (SQLITE_DONE == rc || SQLITE_ROW == rc) {
                // all is well, let's return.
            }
            else if (SQLITE_ERROR == rc) {
                //NSLog(@"Error calling sqlite3_step (%d: %s) SQLITE_ERROR", rc, sqlite3_errmsg(db));
                //NSLog(@"DB Query: %@", sql);
            }
            else if (SQLITE_MISUSE == rc) {
                // uh oh.
                //NSLog(@"Error calling sqlite3_step (%d: %s) SQLITE_MISUSE", rc, sqlite3_errmsg(db));
                //NSLog(@"DB Query: %@", sql);
            }
            else {
                // wtf?
                //NSLog(@"Unknown error calling sqlite3_step (%d: %s) eu", rc, sqlite3_errmsg(db));
                //NSLog(@"DB Query: %@", sql);
            }
            
        } while (retry);
    }
    
    
    /* Finalize the virtual machine. This releases all memory and other
    ** resources allocated by the sqlite3_prepare() call above.
    */
    rc = sqlite3_finalize(statement);
    sqlite3_close(mdb);

    inUse = NO;

    return (rc == SQLITE_OK);
}

- (BOOL)executeUpdate:(NSString*)sql, ...
{
    va_list args;
    va_start(args, sql);
    
    BOOL result = [self executeUpdate:sql error:nil withArgumentsInArray:nil orVAList:args];
    
    va_end(args);
    return result;
}

- (BOOL)executeUpdate:(NSString*)sql withArgumentsInArray:(NSArray *)arguments
{
    return [self executeUpdate:sql error:nil withArgumentsInArray:arguments orVAList:nil];
}

- (BOOL)update:(NSString*)sql error:(NSError**)outErr bind:(id)bindArgs, ... {
    va_list args;
    va_start(args, bindArgs);
    
    BOOL result = [self executeUpdate:sql error:outErr withArgumentsInArray:nil orVAList:args];
    
    va_end(args);
    return result;
}

- (void)insertRecordInTable:(NSString*)strTableName dic:(NSDictionary*)dicSql
{
    NSString *insertSql = [NSString stringWithFormat:@"INSERT INTO `%@` (", strTableName];

    for (NSString* strKey in dicSql) {
        insertSql = [insertSql stringByAppendingFormat:@"`%@`, ", strKey];
    }
    
    NSRange range = [insertSql rangeOfString:@"," options:NSBackwardsSearch];
    if ( range.location != NSNotFound )
        insertSql = [insertSql substringToIndex:range.location];

    insertSql = [insertSql stringByAppendingString:@") VALUES ("];
    
    for (NSString* strKey in dicSql)
    {
        NSString* strValue = [dicSql objectForKey:strKey];
        
        insertSql = [NSString stringWithFormat:@"%@'%@', ", insertSql, strValue];
    }
    
    range = [insertSql rangeOfString:@"," options:NSBackwardsSearch];
    if ( range.location != NSNotFound )
        insertSql = [insertSql substringToIndex:range.location];
    
    insertSql = [insertSql stringByAppendingString:@")"];
    
    [self updateSQL:insertSql];
}

- (NSString *)SQL:(NSString *)sql inTable:(NSString *)table
{
	return [NSString stringWithFormat:sql, table];
}

- (void)deleteAllRecordsInTable:(NSString*)strTableName
{
    NSString* deleteSql = [NSString stringWithFormat:@"DELETE FROM %@", strTableName];
    [self updateSQL:deleteSql];
}

- (void)deleteRecordInTable:(NSString*)strTableName dic:(NSDictionary*)dicSqlWhere
{
    NSString* deleteSql = [NSString stringWithFormat:@"DELETE FROM `%@` WHERE ", strTableName];
    
    for (NSString* strKey in dicSqlWhere) {
        deleteSql = [deleteSql stringByAppendingFormat:@"`%@` = ? AND", strKey];
    }

    NSRange range = [deleteSql rangeOfString:@"?" options:NSBackwardsSearch];
    if ( range.location != NSNotFound )
        deleteSql = [deleteSql substringToIndex:range.location + 1];

    NSArray* arrArgs = [[NSArray alloc]init];
    for (NSString* strKey in dicSqlWhere) {
        NSString* strValue = [dicSqlWhere objectForKey:strKey];
        arrArgs = [arrArgs arrayByAddingObject:strValue];
    }

    [self executeUpdate:deleteSql withArgumentsInArray:arrArgs];
}

- (void)updateRecordInTable:(NSString*)strTableName dicSET:(NSDictionary*)dicSqlSET dicWHERE:(NSDictionary*)dicSqlWhere
{
   
    NSString* updateSql = [NSString stringWithFormat:@"UPDATE `%@` SET ", strTableName];
    for (NSString* strKey in dicSqlSET) {
        updateSql = [updateSql stringByAppendingFormat:@"`%@` = ?, ", strKey];
    }
    
    NSRange range = [updateSql rangeOfString:@"," options:NSBackwardsSearch];
    if ( range.location != NSNotFound )
        updateSql = [updateSql substringToIndex:range.location];

    updateSql = [updateSql stringByAppendingString:@" WHERE "];
    for (NSString* strKey in dicSqlWhere) {
        updateSql = [updateSql stringByAppendingFormat:@"`%@` = ?, ", strKey];
    }

    range = [updateSql rangeOfString:@"," options:NSBackwardsSearch];
    if ( range.location != NSNotFound )
        updateSql = [updateSql substringToIndex:range.location];

    NSArray* arrArgs = [[NSArray alloc]init];
    for (NSString* strKey in dicSqlSET) {
        NSString* strValue = [dicSqlSET objectForKey:strKey];
        arrArgs = [arrArgs arrayByAddingObject:strValue];
    }

    for (NSString* strKey in dicSqlWhere) {
        NSString* strValue = [dicSqlWhere objectForKey:strKey];
        arrArgs = [arrArgs arrayByAddingObject:[NSString stringWithFormat:@"%@",strValue]];
    }

    [self executeUpdate:updateSql withArgumentsInArray:arrArgs];
    
    return;
}

- (NSMutableDictionary *)queryOneData:(NSString *)strQuery
{
    [self getColumeInfo:strQuery];
    
    int nColumnCount = (int)self.columeCount;
    if( nColumnCount <= 0 )
        return nil;
    
    NSMutableArray *arrColumns = [[NSMutableArray alloc] initWithCapacity:0];
    
    for ( int i = 0; i < nColumnCount; i++ )
    {
        NSArray *arrColumnData = [self lookupSQL:strQuery column:i];
        [arrColumns addObject:arrColumnData];
    }
    
    NSMutableDictionary *dicRowItem = [[NSMutableDictionary alloc] initWithCapacity:0];

    int nRecordCount = (int)[[arrColumns objectAtIndex:0] count];
    if( nRecordCount <= 0 )
        return dicRowItem;

    for( int nCol = 0; nCol < nColumnCount; nCol++ )
    {
        [dicRowItem setObject:[[arrColumns objectAtIndex:nCol] objectAtIndex:0] forKey:[arrayColume objectAtIndex:nCol]];
    }

    return dicRowItem;
}

- (NSMutableArray *)queryArrayData:(NSString *)strQuery
{
    NSMutableArray  *arrQueryData = [NSMutableArray arrayWithCapacity:0];
    
    [self getColumeInfo:strQuery];

    int nColumnCount = (int)self.columeCount;
    if( nColumnCount <= 0 )
        return arrQueryData;

    NSMutableArray *arrColumns = [[NSMutableArray alloc] initWithCapacity:0];
    
    for ( int i = 0; i < nColumnCount; i++ )
    {
        NSArray *arrColumnData = [self lookupSQL:strQuery column:i];
        [arrColumns addObject:arrColumnData];
    }
    
    int nRecordCount = (int)[[arrColumns objectAtIndex:0] count];
    
    for( int nRow = 0; nRow < nRecordCount; nRow++ )
    {
        NSMutableDictionary *dicRowItem = [[NSMutableDictionary alloc] initWithCapacity:0];
        
        for( int nCol = 0; nCol < nColumnCount; nCol++ )
        {
            NSArray *arr = [arrColumns objectAtIndex:nCol];
            if ( arr && arr.count > nRow )
            [dicRowItem setObject:[arr objectAtIndex:nRow] forKey:[arrayColume objectAtIndex:nCol]];
        }
        
        [arrQueryData addObject:dicRowItem];
    }

    return arrQueryData;
}

- (int)getMaxValueOfField:(NSString *)strFldName ofTable:(NSString *)strTblName
{
    NSString *strQuery = [NSString stringWithFormat:@"SELECT MAX(%@) FROM %@", strFldName, strTblName];

    NSMutableDictionary *item = [self queryOneData:strQuery];

    if( item == nil )
        return 0;

    NSString *strKey = [NSString stringWithFormat:@"MAX(%@)", strFldName];
    int nValue = [[item objectForKey:strKey] intValue];

    return nValue;
}

- (int)getMaxIDofTable:(NSString *)strTblName
{
    return [self getMaxValueOfField:@"id" ofTable:strTblName];
}

@end
//
//  sqlite.h
//  LBSUserApp
//
//  Created by iMac on 11-7-15.
//  Copyright 2011年 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>
#include <sqlite3.h> 

@interface SQLLite : NSObject
{
    sqlite3         *mdb;
    sqlite3_stmt    *stmt;
    NSString        *path;

    BOOL  logsErrors;
    BOOL  crashOnErrors;
    BOOL  inUse;
    BOOL  inTransaction;
    BOOL  traceExecution;
    BOOL  checkedOut;
    int   busyRetryTimeout;
    BOOL  shouldCacheStatements;
}

@property (nonatomic, retain) NSString *path;
@property (nonatomic, retain) NSMutableArray *arrayColume;
@property (nonatomic, readwrite) NSInteger columeCount;

- (id)initWithPath:(NSString*)dbPath;

- (sqlite3_stmt*)prepare:(NSString*)sql;
- (NSString *)lookupSingularSQL:(NSString*)sql column:(int)col;
- (NSMutableArray*)lookupSQL:(NSString*)sql column:(int)col;

- (void)updateSQL:(NSString *)sql;
- (void)getColumeInfo:(NSString *)sql;

- (int)getColumeId:(NSString *)fieldName;

- (BOOL)update:(NSString*)sql error:(NSError**)outErr bind:(id)bindArgs, ...;
- (BOOL)executeUpdate:(NSString*)sql, ...;
- (BOOL)executeUpdate:(NSString*)sql withArgumentsInArray:(NSArray *)arguments;
- (BOOL)executeUpdate:(NSString*)sql error:(NSError**)outErr withArgumentsInArray:(NSArray*)arrayArgs orVAList:(va_list)args;

- (void)insertRecordInTable:(NSString*)strTableName dic:(NSDictionary*)dicSql;
- (void)updateRecordInTable:(NSString*)strTableName dicSET:(NSDictionary*)dicSqlSET dicWHERE:(NSDictionary*)dicSqlWhere;

- (void)deleteRecordInTable:(NSString*)strTableName dic:(NSDictionary*)dicSql;
- (void)deleteAllRecordsInTable:(NSString*)strTableName;

- (NSMutableDictionary *)queryOneData:(NSString *)strQuery;
- (NSMutableArray *)queryArrayData:(NSString *)strQuery;

- (int)getMaxValueOfField:(NSString *)strFldName ofTable:(NSString *)strTblName;

- (int)getMaxIDofTable:(NSString *)strTblName;

@end
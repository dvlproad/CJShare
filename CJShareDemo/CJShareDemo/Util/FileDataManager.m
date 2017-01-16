//
//  FileDataManager.m
//  CJShareDemo
//
//  Created by 李超前 on 2016/12/28.
//  Copyright © 2016年 dvlproad. All rights reserved.
//

#import "FileDataManager.h"

@implementation FileDataManager

+ (FileDataManager *)sharedInstance {
    static FileDataManager *_sharedInstance = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        _sharedInstance = [[self alloc] init];
    });
    return _sharedInstance;
}


+ (NSArray *)allCreateTableSqls {
    NSString *sql = [FileFMDBUtil sqlForCreateTable];
    NSArray *createTableSqls = @[sql];
    
    return createTableSqls;
}

+ (void)createFileDatabaseForUserName:(NSString *)userName {
    //[[FileDataManager sharedInstance] setDataBaseName:@"demofmdb.db"];
    //[[FileDataManager sharedInstance] setDataBaseName:@"fmdb.db"];
    
    NSString *databaseName = @"";
    if ([userName hasSuffix:@".db"]) {
        databaseName = userName;
    } else {
        databaseName = [NSString stringWithFormat:@"%@.db", userName];
    }
    
    __weak typeof(self)weakSelf = self;
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        NSArray *createTableSqls = [self allCreateTableSqls];
        [[FileDataManager sharedInstance] createDatabaseWithName:databaseName
                                                subDirectoryPath:@"FileManager"
                                                 createTableSqls:createTableSqls
                                                 ifExistDoAction:CJFMDBFileExistActionTypeUseOld];
    });
}

@end

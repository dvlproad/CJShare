//
//  CJFileFMDBFileManager.m
//  CJShareDemo
//
//  Created by 李超前 on 2016/12/28.
//  Copyright © 2016年 dvlproad. All rights reserved.
//

#import "CJFileFMDBFileManager.h"

@implementation CJFileFMDBFileManager

+ (CJFileFMDBFileManager *)sharedInstance {
    static CJFileFMDBFileManager *_sharedInstance = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        _sharedInstance = [[self alloc] init];
    });
    return _sharedInstance;
}


+ (void)createDatabaseForUserName:(NSString *)userName {
    NSAssert(userName != nil && [userName length] > 0, @"userName不能为空");
    
    [[CJFileFMDBFileManager sharedInstance] cancelManagerAnyDatabase];
    
    NSString *databaseName = @"";
    if ([userName hasSuffix:@".db"]) {
        databaseName = userName;
    } else {
        databaseName = [NSString stringWithFormat:@"%@.db", userName];
    }
    
    //创建数据库
    NSString *directoryRelativePath =
    [CJFileManager getLocalDirectoryPathType:CJLocalPathTypeRelative
                          bySubDirectoryPath:@"FileManager"
                       inSearchPathDirectory:NSDocumentDirectory
                             createIfNoExist:YES];
    NSString *fileRelativePath = [directoryRelativePath stringByAppendingPathComponent:databaseName];
    
    NSArray *createTableSqls = [self allCreateTableSqls];
    [[CJFileFMDBFileManager sharedInstance] createDatabaseInFileRelativePath:fileRelativePath byCreateTableSqls:createTableSqls ifExistDoAction:CJFMDBFileExistActionTypeRerecertIt];
}

+ (NSArray *)allCreateTableSqls {
    NSString *sqlForCreateLocalFile = [CJLocalFileTableSQL sqlForCreateTable];
    NSString *sqlForCreateNetworkFile = [CJNetworkFileTableSQL sqlForCreateTable];
    NSArray *createTableSqls = @[sqlForCreateLocalFile, sqlForCreateNetworkFile];
    
    return createTableSqls;
}

+ (void)reCreateCurrentDatabase {
    NSArray *createTableSqls = [self allCreateTableSqls];
    [[CJFileFMDBFileManager sharedInstance] recreateDatabase:createTableSqls];
}

+ (BOOL)deleteFMDBDirectory {
    return [[CJFileFMDBFileManager sharedInstance] deleteCurrentFMDBDirectory];
}

#pragma mark - LocalFile
+ (BOOL)insertLocalSandboxFileInfos:(NSArray<FileModel *> *)infos useTransaction:(BOOL)useTransaction {
    NSMutableArray *sqls = [[NSMutableArray alloc] init];
    for (FileModel *info in infos) {
        info.fileSourceType = CJFileSourceTypeLocalSandbox;
        NSString *sql = [CJLocalFileTableSQL sqlForInsertInfo:info];
        [sqls addObject:sql];
    }
    
    return [[CJFileFMDBFileManager sharedInstance] cjExecuteUpdate:sqls useTransaction:useTransaction];
}

+ (BOOL)insertLocalBundleFileInfos:(NSArray<FileModel *> *)infos useTransaction:(BOOL)useTransaction {
    NSMutableArray *sqls = [[NSMutableArray alloc] init];
    for (FileModel *info in infos) {
        info.fileSourceType = CJFileSourceTypeLocalBundle;
        NSString *sql = [CJLocalFileTableSQL sqlForInsertInfo:info];
        [sqls addObject:sql];
    }
    
    return [[CJFileFMDBFileManager sharedInstance] cjExecuteUpdate:sqls useTransaction:useTransaction];
}

+ (NSMutableArray<FileModel *> *)selectLocalInfos {
    NSString *sql = [CJLocalFileTableSQL sqlForSelectInfos];
    
    NSArray *dictionarys = [[CJFileFMDBFileManager sharedInstance] query:sql];
    if (dictionarys.count == 0) {
        return nil;
    }
    
    NSMutableArray *localFiles = [[NSMutableArray alloc] init];
    for (NSDictionary *dictionary in dictionarys) {
        //FileModel *info = [MTLJSONAdapter modelOfClass:[FileModelDB class] fromJSONDictionary:dictionarys[0] error:nil];
        FileModel *info = [[FileModel alloc] initWithDictionary:dictionary error:nil];
        
        [localFiles addObject:info];
    }
    
    return localFiles;
}

+ (FileModel *)selectLocalInfoWhereLocalRelativePath:(NSString *)localRelativePath {
    NSString *sql = [CJLocalFileTableSQL sqlForSelectInfoWhereUniqueId:localRelativePath];
    
    NSArray *dictionarys = [[CJFileFMDBFileManager sharedInstance] query:sql];
    if (dictionarys.count == 0) {
        return nil;
    }
    
    //FileModel *info = [MTLJSONAdapter modelOfClass:[FileModelDB class] fromJSONDictionary:dictionarys[0] error:nil];
    FileModel *info = [[FileModel alloc] initWithDictionary:dictionarys[0] error:nil];
    
    return info;
}

+ (BOOL)deleteLocalInfoWhereLocalRelativePath:(NSString *)localRelativePath {
    NSString *sql = [CJLocalFileTableSQL sqlForDeleteInfoWhereUniqueId:localRelativePath];
    
    return [[CJFileFMDBFileManager sharedInstance] cjExecuteUpdate:@[sql]];
}

#pragma mark - NetworkFile
+ (BOOL)insertNetworkFileInfo:(FileModel *)info {
    NSString *sql = [CJNetworkFileTableSQL sqlForInsertInfo:info];
    
    return [[CJFileFMDBFileManager sharedInstance] cjExecuteUpdate:@[sql]];
}

+ (NSMutableArray<FileModel *> *)selectNetworkInfos {
    NSString *sql = [CJNetworkFileTableSQL sqlForSelectInfos];
    
    NSArray *dictionarys = [[CJFileFMDBFileManager sharedInstance] query:sql];
    if (dictionarys.count == 0) {
        return nil;
    }
    
    NSMutableArray *networkFiles = [[NSMutableArray alloc] init];
    for (NSDictionary *dictionary in dictionarys) {
        //FileModel *info = [MTLJSONAdapter modelOfClass:[FileModelDB class] fromJSONDictionary:dictionarys[0] error:nil];
        FileModel *info = [[FileModel alloc] initWithDictionary:dictionary error:nil];
        
        [networkFiles addObject:info];
    }
    
    return networkFiles;
}

+ (FileModel *)selectNetworkInfoWhereNetworkReturnUrl:(NSString *)networkReturnUrl {
    NSString *sql = [CJNetworkFileTableSQL sqlForSelectInfoWhereUniqueId:networkReturnUrl];
    
    NSArray *dictionarys = [[CJFileFMDBFileManager sharedInstance] query:sql];
    if (dictionarys.count == 0) {
        return nil;
    }
    
    //FileModel *info = [MTLJSONAdapter modelOfClass:[FileModelDB class] fromJSONDictionary:dictionarys[0] error:nil];
    FileModel *info = [[FileModel alloc] initWithDictionary:dictionarys[0] error:nil];
    
    return info;
    
}


+ (BOOL)deleteNetworkInfoWhereNetworkReturnUrl:(NSString *)networkReturnUrl {
    NSString *sql = [CJNetworkFileTableSQL sqlForDeleteInfoWhereUniqueId:networkReturnUrl];
    
    return [[CJFileFMDBFileManager sharedInstance] cjExecuteUpdate:@[sql]];
}

@end

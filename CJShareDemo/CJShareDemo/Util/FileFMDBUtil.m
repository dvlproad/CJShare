//
//  FileFMDBUtil.m
//  CJShareDemo
//
//  Created by 李超前 on 2016/12/27.
//  Copyright © 2016年 dvlproad. All rights reserved.
//

#import "FileFMDBUtil.h"

static NSString *kCurrentTableName = @"FileManager";

@implementation FileFMDBUtil

+ (NSString *)sqlForCreateTable {
    NSString *sql = [NSString stringWithFormat:@"create table if not exists %@ (fileType Text, fileName TEXT, fileUrl TEXT, fileExtension Text, fileSize Text, createTime Text, temp Text, PRIMARY KEY(fileUrl));", kCurrentTableName];
    return sql;
}

#pragma mark - insert

+ (BOOL)insertInfo:(FileModel *)info {
    NSAssert(info, @"info cannot be nil!");
    
    NSString *sql = [NSString stringWithFormat:
                     @"INSERT OR REPLACE INTO %@ (fileType, fileName, fileUrl, fileExtension, fileSize, createTime, temp) VALUES ('%@', '%@', '%@', '%@', '%@', '%@', '%@')", kCurrentTableName, info.fileType, info.fileName, info.fileUrl, info.type, info.fileSize, info.createTime, @"temp"];
    
    return [[FileDataManager sharedInstance] insert:sql];
}

#pragma mark - update

+ (BOOL)updateInfo:(FileModel *)info whereFileId:(NSString *)fileId {
    NSString *sql = [NSString stringWithFormat:
                     @"UPDATE %@ SET fileType = '%@', fileName = '%@', fileExtension = '%@', fileSize = '%@', createTime = '%@', temp = '%@' WHERE fileId = '%@'", kCurrentTableName, info.fileType, info.fileName, info.type, info.fileSize, info.createTime, @"temp", fileId];
    return [[FileDataManager sharedInstance] update:sql];
}

#pragma mark - query

+ (FileModel *)selectInfoWhereFileId:(NSString *)fileId {
    NSString *sql = [NSString stringWithFormat:@"SELECT * FROM %@ where fileId = '%@'", kCurrentTableName, fileId];
    
    NSArray *dictionarys = [[FileDataManager sharedInstance] query:sql];
    if (dictionarys.count == 0) {
        return nil;
    }
    
//    FileModel *info = [MTLJSONAdapter modelOfClass:[FileModelDB class] fromJSONDictionary:dictionarys[0] error:nil];
    FileModel *info = [[FileModel alloc] initWithDictionary:dictionarys[0] error:nil];
    
    return info;
    
}

+ (NSMutableArray<FileModel *> *)selectInfosWhereFileType:(NSString *)fileType {
    NSString *sql = [NSString stringWithFormat:@"SELECT * FROM %@ where fileType = '%@'", kCurrentTableName, fileType];
    
    NSArray *dictionarys = [[FileDataManager sharedInstance] query:sql];
    if (dictionarys.count == 0) {
        return nil;
    }
    
    NSMutableArray *infos = [[NSMutableArray alloc] init];
    for (NSDictionary *dictionary in dictionarys) {
//        FileModel *info = [MTLJSONAdapter modelOfClass:[FileModelDB class] fromJSONDictionary:dictionary error:nil];
        FileModel *info = [[FileModel alloc] initWithDictionary:dictionary error:nil];
        [infos addObject:info];
    }
    return infos;
}

+ (BOOL)deleteInfoByFileId:(NSString *)fileUrl {
    NSString *sql = [NSString stringWithFormat:@"delete from %@ where fileUrl = '%@'", kCurrentTableName, fileUrl];
    return [[FileDataManager sharedInstance] remove:sql];
}

@end

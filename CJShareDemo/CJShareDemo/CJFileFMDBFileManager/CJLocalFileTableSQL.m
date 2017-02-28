//
//  CJLocalFileTableSQL.m
//  CJShareDemo
//
//  Created by 李超前 on 2016/12/27.
//  Copyright © 2016年 dvlproad. All rights reserved.
//

#import "CJLocalFileTableSQL.h"

static NSString *kCurrentTableName = @"LocalFile";

@implementation CJLocalFileTableSQL

#pragma mark - create
+ (NSString *)sqlForCreateTable {
    NSString *sql = [NSString stringWithFormat:@"create table if not exists %@ (fileSourceType Integer, localRelativePath Text, networkReturnUrl Text, fileName Text, fileExtension Text, fileSize Text, createTime Text, updateTime Text, temp Text, PRIMARY KEY(localRelativePath));", kCurrentTableName];
    return sql;
}

#pragma mark - insert
+ (NSString *)sqlForInsertInfo:(FileModel *)info {
    NSAssert(info, @"info cannot be nil!");
    
    NSString *sql = [NSString stringWithFormat:@"INSERT OR REPLACE INTO %@ (fileSourceType, localRelativePath, networkReturnUrl, fileName, fileExtension, fileSize, createTime, updateTime, temp) VALUES ('%ld', '%@', '%@', '%@', '%@', '%@', '%@', '%@', '%@')", kCurrentTableName, info.fileSourceType, info.localRelativePath, info.networkReturnUrl, info.fileName, info.fileExtension, info.fileSize, info.createTime, info.updateTime, @""];
    
    return sql;
}

#pragma mark - update
+ (NSString *)sqleForUpdateInfo:(FileModel *)info whereUniqueId:(NSString *)localRelativePath {
    NSString *sql = [NSString stringWithFormat:@"update %@ set fileSourceType = '%ld', networkReturnUrl = '%@', fileName = '%@', fileExtension = '%@', fileSize = '%@', createTime = '%@', updateTime = '%@', temp = '%@' WHERE localRelativePath = '%@'", kCurrentTableName, info.fileSourceType, info.networkReturnUrl, info.fileName, info.fileExtension, info.fileSize, info.createTime, info.updateTime, @"", localRelativePath];
    return sql;
}

#pragma mark - query
+ (NSString *)sqlForSelectInfos {
    NSString *sql = [NSString stringWithFormat:@"SELECT * FROM %@", kCurrentTableName];
    
    return sql;
}

+ (NSString *)sqlForSelectInfoWhereUniqueId:(NSString *)localRelativePath {
    NSString *sql = [NSString stringWithFormat:@"SELECT * FROM %@ where localRelativePath = '%@'", kCurrentTableName, localRelativePath];
    
    return sql;
}

#pragma mark - delete
+ (NSString *)sqlForDeleteInfoWhereUniqueId:(NSString *)localRelativePath {
    NSString *sql = [NSString stringWithFormat:@"delete from %@ where localRelativePath = '%@'", kCurrentTableName, localRelativePath];
    return sql;
}

@end

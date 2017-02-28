//
//  CJNetworkFileTableSQL.m
//  CJShareDemo
//
//  Created by 李超前 on 2016/12/27.
//  Copyright © 2016年 dvlproad. All rights reserved.
//

#import "CJNetworkFileTableSQL.h"

static NSString *kCurrentTableName = @"NetworkFile";
static CJFileSourceType currentFileSourceType = CJFileSourceTypeNetwork;

@implementation CJNetworkFileTableSQL

#pragma mark - create
+ (NSString *)sqlForCreateTable {
    NSString *sql = [NSString stringWithFormat:@"create table if not exists %@ (fileSourceType Integer, localRelativePath Text, networkReturnUrl Text, fileName Text, fileExtension Text, fileSize Text, createTime Text, updateTime Text, temp Text, PRIMARY KEY(networkReturnUrl));", kCurrentTableName];
    return sql;
}

#pragma mark - insert
+ (NSString *)sqlForInsertInfo:(FileModel *)info {
    NSAssert(info, @"info cannot be nil!");
    
    NSString *sql = [NSString stringWithFormat:@"INSERT OR REPLACE INTO %@ (fileSourceType, localRelativePath, networkReturnUrl, fileName, fileExtension, fileSize, createTime, updateTime, temp) VALUES ('%ld', '%@', '%@', '%@', '%@', '%@', '%@', '%@', '%@')", kCurrentTableName, currentFileSourceType, info.localRelativePath, info.networkReturnUrl, info.fileName, info.fileExtension, info.fileSize, info.createTime, info.updateTime, @""];
    
    return sql;
}

#pragma mark - update
+ (NSString *)sqleForUpdateInfo:(FileModel *)info whereUniqueId:(NSString *)networkReturnUrl {
    NSString *sql = [NSString stringWithFormat:@"update %@ set fileSourceType = '%ld', localRelativePath = '%@', fileName = '%@', fileExtension = '%@', fileSize = '%@', createTime = '%@', updateTime = '%@', temp = '%@' WHERE networkReturnUrl = '%@'", kCurrentTableName, currentFileSourceType, info.networkReturnUrl, info.fileName, info.fileExtension, info.fileSize, info.createTime, info.updateTime, @"", networkReturnUrl];
    return sql;
}

#pragma mark - query
+ (NSString *)sqlForSelectInfos {
    NSString *sql = [NSString stringWithFormat:@"SELECT * FROM %@", kCurrentTableName];
    
    return sql;
}

+ (NSString *)sqlForSelectInfoWhereUniqueId:(NSString *)networkReturnUrl {
    NSString *sql = [NSString stringWithFormat:@"SELECT * FROM %@ where networkReturnUrl = '%@'", kCurrentTableName, networkReturnUrl];
    
    return sql;
}

#pragma mark - delete
+ (NSString *)sqlForDeleteInfoWhereUniqueId:(NSString *)networkReturnUrl {
    NSString *sql = [NSString stringWithFormat:@"delete from %@ where networkReturnUrl = '%@'", kCurrentTableName, networkReturnUrl];
    return sql;
}

@end

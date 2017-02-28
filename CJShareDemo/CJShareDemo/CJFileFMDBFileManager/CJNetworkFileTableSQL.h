//
//  CJNetworkFileTableSQL.h
//  CJShareDemo
//
//  Created by 李超前 on 2016/12/27.
//  Copyright © 2016年 dvlproad. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "FileModel.h"

@interface CJNetworkFileTableSQL : NSObject

#pragma mark - create
+ (NSString *)sqlForCreateTable;

#pragma mark - insert
+ (NSString *)sqlForSelectInfos;
+ (NSString *)sqlForInsertInfo:(FileModel *)info;

#pragma mark - update
+ (NSString *)sqleForUpdateInfo:(FileModel *)info whereUniqueId:(NSString *)networkRelativeUrl;

#pragma mark - query
+ (NSString *)sqlForSelectInfoWhereUniqueId:(NSString *)networkRelativeUrl;

#pragma mark - delete
+ (NSString *)sqlForDeleteInfoWhereUniqueId:(NSString *)networkRelativeUrl;

@end

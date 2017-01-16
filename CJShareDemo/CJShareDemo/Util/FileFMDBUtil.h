//
//  FileFMDBUtil.h
//  CJShareDemo
//
//  Created by 李超前 on 2016/12/27.
//  Copyright © 2016年 dvlproad. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "FileDataManager.h"
#import "FileModel.h"
#import "FileModelDB.h"

@interface FileFMDBUtil : NSObject

+ (NSString *)sqlForCreateTable;

+ (BOOL)insertInfo:(FileModel *)info;

+ (FileModel *)selectInfoWhereFileId:(NSString *)fileId;
+ (NSMutableArray<FileModel *> *)selectInfosWhereFileType:(NSString *)fileType;

+ (BOOL)deleteInfoByFileId:(NSString *)fileUrl;

@end

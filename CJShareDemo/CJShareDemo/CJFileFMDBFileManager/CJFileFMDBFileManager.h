//
//  CJFileFMDBFileManager.h
//  CJShareDemo
//
//  Created by 李超前 on 2016/12/28.
//  Copyright © 2016年 dvlproad. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CJFMDBFileManager/CJFMDBFileManager.h>
#import "CJLocalFileTableSQL.h"
#import "CJNetworkFileTableSQL.h"

@interface CJFileFMDBFileManager : CJFMDBFileManager

+ (CJFileFMDBFileManager *)sharedInstance;

+ (void)createDatabaseForUserName:(NSString *)userName;

+ (void)reCreateCurrentDatabase;

+ (BOOL)deleteFMDBDirectory;


#pragma mark - LocalFile
+ (BOOL)insertLocalSandboxFileInfos:(NSArray<FileModel *> *)infos useTransaction:(BOOL)useTransaction;
+ (BOOL)insertLocalBundleFileInfos:(NSArray<FileModel *> *)infos useTransaction:(BOOL)useTransaction;

+ (NSMutableArray<FileModel *> *)selectLocalInfos;
+ (FileModel *)selectLocalInfoWhereLocalRelativePath:(NSString *)localRelativePath;
+ (BOOL)deleteLocalInfoWhereLocalRelativePath:(NSString *)localRelativePath;

#pragma mark - NetworkFile
+ (BOOL)insertNetworkFileInfo:(FileModel *)info;
+ (NSMutableArray<FileModel *> *)selectNetworkInfos;
+ (FileModel *)selectNetworkInfoWhereNetworkReturnUrl:(NSString *)networkReturnUrl;
+ (BOOL)deleteNetworkInfoWhereNetworkReturnUrl:(NSString *)networkReturnUrl;

@end

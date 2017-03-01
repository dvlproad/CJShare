//
//  CJFMDBFileManager.m
//  CommonFMDBUtilDemo
//
//  Created by lichq on 6/25/15.
//  Copyright (c) 2015 ciyouzen. All rights reserved.
//

#import "CJFMDBFileManager.h"

@interface CJFMDBFileManager () {
    
}
@property (nonatomic, copy, readonly) NSString *fileAbsolutePath;   /**< 当前数据库的绝对路径 */

@end



@implementation CJFMDBFileManager

/** 完整的描述请参见文件头部 */
- (void)cancelManagerAnyDatabase {
    NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
    NSString *managerFileRelativePathKey = [self managerFileRelativePathKey];
    [userDefaults removeObjectForKey:managerFileRelativePathKey];
    [userDefaults synchronize];
}

#pragma mark - 创建数据库、数据表
/** 完整的描述请参见文件头部 */
- (BOOL)createDatabaseInFileRelativePath:(NSString *)fileRelativePath
                      byCopyDatabasePath:(NSString *)copyDatabasePath
               ifExistDoAction:(CJFMDBFileExistActionType)FMDBFileExistAction
{
    BOOL canCreate = [self canCreateDatabaseFileInFileRelativePath:fileRelativePath ifExistDoAction:FMDBFileExistAction];
    if (canCreate == NO) {
        return NO;
    }
    NSString *homeDirectory = NSHomeDirectory();
    NSString *fileAbsolutePath = [homeDirectory stringByAppendingPathComponent:fileRelativePath];
    
    //复制数据库文件到我们指定的目录
    NSError *error = nil;
    BOOL copySuccess = [[NSFileManager defaultManager] copyItemAtPath:copyDatabasePath toPath:fileAbsolutePath error:&error];
    if (copySuccess) {
        NSLog(@"复制数据库文件%@到指定目录%@成功", [copyDatabasePath lastPathComponent], fileAbsolutePath);
    } else {
        NSLog(@"复制数据库文件%@到指定目录%@失败，因为%@", [copyDatabasePath lastPathComponent], fileAbsolutePath, [error localizedDescription]);
    }
    
    return copySuccess;
}

/** 完整的描述请参见文件头部 */
- (BOOL)createDatabaseInFileRelativePath:(NSString *)fileRelativePath
                       byCreateTableSqls:(NSArray<NSString *> *)createTableSqls
                         ifExistDoAction:(CJFMDBFileExistActionType)FMDBFileExistAction
{
    BOOL canCreate = [self canCreateDatabaseFileInFileRelativePath:fileRelativePath ifExistDoAction:FMDBFileExistAction];
    if (canCreate == NO) {
        return NO;
    }
    NSString *homeDirectory = NSHomeDirectory();
    NSString *fileAbsolutePath = [homeDirectory stringByAppendingPathComponent:fileRelativePath];
    
    //创建数据库文件到我们指定的目录
    FMDatabase *db = [FMDatabase databaseWithPath:fileAbsolutePath];
    if (![db open]) { //执行open的时候，如果数据库不存在则会自动创建
        NSAssert(NO, @"创建数据库文件失败!", fileAbsolutePath);
        return NO;
        
    } else {
        NSLog(@"创建数据库到指定目录%@成功", fileAbsolutePath);
        for (NSString *createTableSql in createTableSqls) {
            BOOL result = [db executeUpdate:createTableSql];
            if (result == NO) {
                NSLog(@"操作数据表失败:%@", createTableSql);
            }
        }
        
        [db close];
        
        return YES;
    }
}

/** 完整的描述请参见文件头部 */
- (BOOL)recreateDatabase:(NSArray<NSString *> *)createTableSqls {
    CJFMDBFileDeleteResult *deleteResult = [self deleteCurrentFMDBFile];
    
    NSString *fileRelativePath = deleteResult.fileRelativePath;
    BOOL recreateSuccess = [self createDatabaseInFileRelativePath:fileRelativePath
                                                byCreateTableSqls:createTableSqls
                                                  ifExistDoAction:CJFMDBFileExistActionTypeRerecertIt];
    return recreateSuccess;
}

#pragma mark - 删除数据库目录/数据库文件
/** 完整的描述请参见文件头部 */
- (CJFMDBFileDeleteResult *)deleteCurrentFMDBFile {
    CJFMDBFileDeleteResult *deleteResult = [[CJFMDBFileDeleteResult alloc] init];
    
    NSString *fileRelativePath = self.currentFileRelativePath;
    
    deleteResult.fileRelativePath = fileRelativePath;
    
    BOOL deleteFileSuccess = NO;
    if ([fileRelativePath length] == 0) {
        deleteResult.success = YES;
        
        //NSLog(@"总结：删除%@数据库文件：%@, 因为该文件路径不存在，默认删除成功(比如这里有可能是重复删除)", deleteResult.fileRelativePath, deleteResult.success ? @"成功":@"失败");
        return deleteResult;
        
    } else {
        NSString *home = NSHomeDirectory();
        NSString *fileAbsolutePath = [home stringByAppendingPathComponent:fileRelativePath];
        
        NSFileManager *fileManager = [NSFileManager defaultManager];
        deleteFileSuccess = [fileManager removeItemAtPath:fileAbsolutePath error:nil];
        if (deleteFileSuccess) {
            NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
            NSString *fileRelativePathKey = [self fileRelativePathKey];
            
            [userDefaults removeObjectForKey:fileRelativePathKey];
            _fileRelativePath = nil;
        }
        deleteResult.success = deleteFileSuccess;
        
        //NSLog(@"总结：删除%@数据库文件：%@", deleteResult.fileRelativePath, deleteResult.success ? @"成功":@"失败");
        return deleteResult;
    }
}

/** 完整的描述请参见文件头部 */
- (BOOL)deleteCurrentFMDBDirectory {
    NSString *fileAbsolutePath = self.fileAbsolutePath; //重启后为空
    
    NSString *lastPathComponent = [fileAbsolutePath lastPathComponent];
    NSString *directoryAbsolutePath = [self.fileAbsolutePath substringToIndex:self.fileAbsolutePath.length-(lastPathComponent.length+1) - 1];
    
    BOOL deleteDirectorySuccess = NO;
    if ([directoryAbsolutePath length] == 0) {
        //NSLog(@"文件夹不存在，默认删除成功");
        deleteDirectorySuccess = YES;
        
    } else {
        NSFileManager *fileManager = [NSFileManager defaultManager];
        deleteDirectorySuccess = [fileManager removeItemAtPath:directoryAbsolutePath error:nil];
    }
    if (deleteDirectorySuccess) {

        NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
        [userDefaults removeObjectForKey:[self fileRelativePath]];
        
        _fileRelativePath = nil;
    }
    
    return deleteDirectorySuccess;
}



#pragma mark - 数据库表操作
- (BOOL)create:(NSString *)sql {
    NSAssert(sql, @"sql cannot be nil!");
    
    return [self executeUpdate:sql args:nil];
}


- (BOOL)insert:(NSString *)sql {
    NSAssert(sql, @"sql cannot be nil!");
    
    return [self executeUpdate:sql args:nil];
}

- (BOOL)remove:(NSString *)sql {
    NSAssert(sql, @"sql cannot be nil!");
    
    return [self executeUpdate:sql args:nil];
}

- (BOOL)update:(NSString *)sql {
    NSAssert(sql, @"sql cannot be nil!");
    
    return [self executeUpdate:sql args:nil];
}

- (NSMutableArray *)query:(NSString *)sql
{
    NSAssert(sql, @"sql cannot be nil!");
    
    NSMutableArray *result = [[NSMutableArray alloc] init];
    
    FMDatabase *db = [FMDatabase databaseWithPath:self.fileAbsolutePath];
    
    if ([db open]) {
        FMResultSet *rs = [db executeQuery:sql];
        while ([rs next]) {
            [result addObject:[rs resultDictionary]];
        }
        
        [db close];
    }
    
    db = nil;
    
    return result;
}



#pragma mark - private method

- (BOOL)executeUpdate:(NSString *)sql args:(NSArray *)args
{
    BOOL success = NO;
    
    FMDatabase *db = [FMDatabase databaseWithPath:self.fileAbsolutePath];
    
    if ([db open]) {
        success = [db executeUpdate:sql withArgumentsInArray:args];
        
        [db close];
    }
    
    db = nil;
    
    return success;
}

#pragma mark - Setter
/**
 *  复制数据库到某个目录下
 *
 *  @param databaseName         新建的数据库的名字
 *  @param subDirectoryPath     复制数据库到哪里
 *  @param bundleDatabaseName   要复制的数据库的名字
 *  @param FMDBFileExistAction  如果存在执行什么操作
 *
 *  return  是否新建成功
 */
- (BOOL)canCreateDatabaseFileInFileRelativePath:(NSString *)fileRelativePath
                                ifExistDoAction:(CJFMDBFileExistActionType)FMDBFileExistAction {
    //保存本类当前操作的具体数据库，用于在账户切换的时候，先取消对之前具体的数据库的控制，进而控制新的数据库
    NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
    NSString *managerFileRelativePathKey = [self managerFileRelativePathKey];
    NSString *managerFileRelativePath = [userDefaults objectForKey:[self managerFileRelativePathKey]];
    if ([managerFileRelativePath length] > 0 && ![managerFileRelativePath isEqualToString:fileRelativePath]) {
        NSAssert(NO, @"%@数据库控制器已用来管理数据库%@,请重新选择其他控制器来管理%@。或者您可以在创建/复制数据库前，通过cancelManagerAnyDatabase方法来取消%@对之前的数据库%@的管理，以此来让它管理现在的数据库%@", NSStringFromClass([self class]), managerFileRelativePath, fileRelativePath, NSStringFromClass([self class]), managerFileRelativePath, fileRelativePath);
    }
    [userDefaults setObject:fileRelativePath forKey:managerFileRelativePathKey];
    
    NSString *fileRelativePathKey = [self fileRelativePathKey];
    //NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
    [userDefaults setObject:fileRelativePath forKey:fileRelativePathKey];
    [userDefaults synchronize];
    
    NSString *home = NSHomeDirectory();
    NSString *fileAbsolutePath = [home stringByAppendingPathComponent:fileRelativePath];
    if ([[NSFileManager defaultManager] fileExistsAtPath:fileAbsolutePath]) {
        if (FMDBFileExistAction == CJFMDBFileExistActionTypeShowError) {
            NSAssert(NO, @"创建数据库到指定目录失败，因为该目录已存在同名文件%@ !", fileAbsolutePath);
            return NO;
            
        } else if (FMDBFileExistAction == CJFMDBFileExistActionTypeUseOld) {
            //NSLog(@"该目录已存在同名文件%@ !，故不重复创建，继续使用之前的", databasePath);
            return NO;
            
        } else if (FMDBFileExistAction == CJFMDBFileExistActionTypeRerecertIt) {
            [self deleteCurrentFMDBFile]; //会将_fileRelativePath设为nil
        }
    }
    
    _fileRelativePath = fileRelativePath;
    
    return YES;
}


#pragma mark - Getter
- (NSString *)fileAbsolutePath {
    NSString *home = NSHomeDirectory();
    NSString *fileAbsolutePath = [home stringByAppendingPathComponent:self.currentFileRelativePath];
    
    return fileAbsolutePath;
}

- (NSString *)currentFileRelativePath {
    if (_fileRelativePath && [_fileRelativePath length] > 0) {
        return _fileRelativePath;
    }
    
    //重启后内存释放会导致获取不到，所以之前要保存fileRelativePath到plist，以备此时使用
    NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
    NSString *fileRelativePath = [userDefaults objectForKey:self.fileRelativePathKey];
    
    return fileRelativePath;
}

- (NSString *)managerFileRelativePathKey {
    NSString *currentFMDBFileManagerName = NSStringFromClass([self class]); //加前缀是为了区分key的不同
    NSString *managerFileRelativePathKey = [NSString stringWithFormat:@"%@_%@", currentFMDBFileManagerName, @"managerFileRelativePathKey"]; /**< 该数据库管理器被用来管理哪个数据库(如果为空，则表示该数据库管理器未被使用来管理任何数据库)  */
    
    return managerFileRelativePathKey;
}

- (NSString *)fileRelativePathKey {
    NSString *currentFMDBFileManagerName = NSStringFromClass([self class]); //加前缀是为了区分key的不同
    NSString *fileRelativePathKey = [NSString stringWithFormat:@"%@_%@", currentFMDBFileManagerName, @"fileRelativePathKey"];
    
    return fileRelativePathKey;
}




@end

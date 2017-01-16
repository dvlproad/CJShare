//
//  CJFileManager.m
//  CommonFMDBUtilDemo
//
//  Created by lichq on 6/25/15.
//  Copyright (c) 2015 ciyouzen. All rights reserved.
//

#import "CJFileManager.h"

@implementation CJFileManager

#pragma mark - 文件操作
/** 完整的描述请参见文件头部 */
+ (BOOL)deleteFileWithFileName:(NSString *)fileName
              subDirectoryPath:(NSString *)subDirectoryPath
         inSearchPathDirectory:(NSSearchPathDirectory)searchPathDirectory {
    NSAssert(fileName, @"fileName cannot be nil!");
    
    NSString *filePath = [CJFileManager getFilePathWithFileName:fileName
                                               subDirectoryPath:subDirectoryPath
                                          inSearchPathDirectory:searchPathDirectory];
    if ([filePath length] == 0) {
        NSLog(@"%@文件不存在，默认删除成功", fileName);
    }
    
    NSFileManager *fileManager = [NSFileManager defaultManager];
    BOOL deleteFileSuccess = [fileManager removeItemAtPath:filePath error:nil];
    return deleteFileSuccess;
}

/** 完整的描述请参见文件头部 */
+ (NSString *)getFilePathWithFileName:(NSString *)fileName
                     subDirectoryPath:(NSString *)subDirectoryPath
                inSearchPathDirectory:(NSSearchPathDirectory)searchPathDirectory {
    NSAssert(fileName, @"fileName cannot be nil!");
    
    NSString *directoryPath = [CJFileManager getDirectoryPathBySubDirectoryPath:subDirectoryPath inSearchPathDirectory:searchPathDirectory createIfNoExist:NO];
    NSString *filePath = [directoryPath stringByAppendingPathComponent:fileName];
    
    return filePath;
}


#pragma mark - 文件夹操作
/** 完整的描述请参见文件头部 */
+ (BOOL)deleteDirectoryBySubDirectoryPath:(NSString *)subDirectoryPath
                    inSearchPathDirectory:(NSSearchPathDirectory)searchPathDirectory {
    if ([subDirectoryPath length] == 0) {
        NSLog(@"没有删除任何文件夹");
        return YES;
    }
    
    NSString *directoryPath = [CJFileManager getDirectoryPathBySubDirectoryPath:subDirectoryPath inSearchPathDirectory:searchPathDirectory createIfNoExist:NO];
    if ([directoryPath length] == 0) {
        NSLog(@"文件夹不存在，默认删除成功");
        return  YES;
        
    } else {
        NSFileManager *fileManager = [NSFileManager defaultManager];
        return [fileManager removeItemAtPath:directoryPath error:nil];
    }
}

/** 完整的描述请参见文件头部 */
+ (NSString *)getDirectoryPathBySubDirectoryPath:(NSString *)subDirectoryPath
                           inSearchPathDirectory:(NSSearchPathDirectory)searchPathDirectory
                                 createIfNoExist:(BOOL)createIfNoExist {
    NSArray *paths = NSSearchPathForDirectoriesInDomains(searchPathDirectory, NSUserDomainMask, YES);
    NSString *pathDocuments = [paths objectAtIndex:0];
    
    NSString *directoryPath = nil;
    if ([subDirectoryPath length] == 0) {
        directoryPath = pathDocuments;
        return directoryPath;
        
    } else {
        directoryPath = [NSString stringWithFormat:@"%@/%@", pathDocuments, subDirectoryPath];
        
        NSFileManager *fileManager = [[NSFileManager alloc] init];
        if ([[NSFileManager defaultManager] fileExistsAtPath:directoryPath]) { //文件夹存在
            NSLog(@"directoryPath is exists.");
            return directoryPath;
            
        } else {    //文件夹不存在
            if (createIfNoExist) {
                [fileManager createDirectoryAtPath:directoryPath //创建文件夹
                       withIntermediateDirectories:YES
                                        attributes:nil
                                             error:nil];
                return directoryPath;
                
            } else {
                return nil;
            }
        }
    }
}

@end

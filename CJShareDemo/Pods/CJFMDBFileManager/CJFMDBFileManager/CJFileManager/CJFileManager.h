//
//  CJFileManager.h
//  CommonFMDBUtilDemo
//
//  Created by lichq on 6/25/15.
//  Copyright (c) 2015 ciyouzen. All rights reserved.
//

#import <Foundation/Foundation.h>

typedef NS_ENUM(NSUInteger, CJFileSizeUnitType) {
    CJFileSizeUnitTypeBestUnit,
    CJFileSizeUnitTypeB,
    CJFileSizeUnitTypeKB,
    CJFileSizeUnitTypeMB,
    CJFileSizeUnitTypeGB
};

@interface CJFileManager : NSObject

#pragma mark - 文件操作
/**
 *  删除searchPathDirectory文件夹下子文件夹中的文件
 *
 *  @param fileName             文件名
 *  @param subDirectoryPath     子文件夹的路径/名字(可多层xx/yy，也可为空)
 *  @param searchPathDirectory  searchPathDirectory
 *
 *  return 是否删除成功
 */

+ (BOOL)deleteFileWithFileName:(NSString *)fileName
              subDirectoryPath:(NSString *)subDirectoryPath
         inSearchPathDirectory:(NSSearchPathDirectory)searchPathDirectory;

/**
 *  获取searchPathDirectory文件夹下子文件夹中的文件路径
 *
 *  @param fileName             文件名
 *  @param subDirectoryPath     子文件夹的路径/名字(可多层xx/yy，也可为空)
 *  @param searchPathDirectory  searchPathDirectory
 *
 *  return 文件名（如果不存在，返回nil）
 */
+ (NSString *)getFilePathWithFileName:(NSString *)fileName
                     subDirectoryPath:(NSString *)subDirectoryPath
                inSearchPathDirectory:(NSSearchPathDirectory)searchPathDirectory;


#pragma mark - 文件夹操作
/**
 *  删除searchPathDirectory文件夹下子文件夹
 *
 *  @param subDirectoryPath     子文件夹的路径/名字(可多层xx/yy，也可为空)
 *  @param searchPathDirectory  searchPathDirectory
 *
 *  return 是否删除成功
 */
+ (BOOL)deleteDirectoryBySubDirectoryPath:(NSString *)subDirectoryPath
                    inSearchPathDirectory:(NSSearchPathDirectory)searchPathDirectory;

/**
 *  获取searchPathDirectory文件夹下子文件夹的路径
 *
 *  @param subDirectoryPath     子文件夹的路径/名字(可多层xx/yy，也可为空)
 *  @param searchPathDirectory  searchPathDirectory
 *  @param createIfNoExist      createIfNoExist（文件夹不存在的时候是否创建）
 *
 *  return 文件夹的名字
 */
+ (NSString *)getDirectoryPathBySubDirectoryPath:(NSString *)subDirectoryPath
                           inSearchPathDirectory:(NSSearchPathDirectory)searchPathDirectory
                                 createIfNoExist:(BOOL)createIfNoExist;

@end

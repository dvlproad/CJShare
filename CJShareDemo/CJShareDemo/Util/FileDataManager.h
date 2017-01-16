//
//  FileDataManager.h
//  CJShareDemo
//
//  Created by 李超前 on 2016/12/28.
//  Copyright © 2016年 dvlproad. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CJFMDBFileManager/CJFMDBFileManager.h>
#import "FileFMDBUtil.h"

@interface FileDataManager : CJFMDBFileManager

+ (FileDataManager *)sharedInstance;
+ (void)createFileDatabaseForUserName:(NSString *)userName;

@end

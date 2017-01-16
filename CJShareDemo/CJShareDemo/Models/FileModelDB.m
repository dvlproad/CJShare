//
//  FileModelDB.m
//  ijinbu
//
//  Created by 李超前 on 2016/12/29.
//  Copyright © 2016年 haixiaedu. All rights reserved.
//

#import "FileModelDB.h"

@implementation FileModelDB

+ (NSDictionary *)JSONKeyPathsByPropertyKey {
    return @{
             @"fileName":   @"fileName",
             @"type":       @"fileExtension",
             @"fileSize":   @"fileSize"
             };
}

@end

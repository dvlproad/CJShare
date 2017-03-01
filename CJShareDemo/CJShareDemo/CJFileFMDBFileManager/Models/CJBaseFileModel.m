//
//  CJBaseFileModel.m
//  CJShareDemo
//
//  Created by 李超前 on 2017/2/28.
//  Copyright © 2017年 dvlproad. All rights reserved.
//

#import "CJBaseFileModel.h"

@implementation CJBaseFileModel

- (NSString *)localAbsolutePath {
    if (self.fileSourceType == CJFileSourceTypeLocalBundle) {
        if (self.fileName == nil || [self.fileName length] == 0) {
            return nil;
        }
        NSString *localAbsolutePath = [[NSBundle mainBundle] pathForResource:self.fileName ofType:nil];
        return localAbsolutePath;
        
    } else {
        if (self.localRelativePath == nil || [self.localRelativePath length] == 0) {
            return nil;
        }
        NSString *localAbsolutePath = [NSHomeDirectory() stringByAppendingPathComponent:self.localRelativePath];
        return localAbsolutePath;
    }
}

- (NSURL *)fileValidURL {
    return nil;
}

@end

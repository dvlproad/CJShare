//
//  FileModel.m
//  CJShareDemo
//
//  Created by 李超前 on 2016/12/27.
//  Copyright © 2016年 dvlproad. All rights reserved.
//

#import "FileModel.h"

@implementation FileModel

- (NSString *)fileUrlFull {
    if ([self.fileType integerValue] == CJFileTypeLocal) {
        NSString *home = NSHomeDirectory();
        NSString *string = [NSString stringWithFormat:@"%@/Documents/Inbox/%@", home, self.fileUrl];
        
        return string;
    } else {
        //NSURL *URL = [NetworkClient urlForString:self.fileUrl];
        NSURL *URL = [NSURL URLWithString:self.fileUrl];
        NSString *string = [URL absoluteString];
        return string;
    }
    
}

+ (NSDictionary *)JSONKeyPathsByPropertyKey {
    return @{
             @"networkId":  @"id",
             @"fileId":     @"infoId",
             @"fileName":   @"originalName",
             @"fileUrl":    @"url",
             @"fileSize":   @"size",
             @"status":     @"status",
             };
}
//
//+ (NSValueTransformer *)leaderJSONTransformer {
//    return [MTLValueTransformer mtl_JSONDictionaryTransformerWithModelClass:[HPStaffEntity class]];
//}
//

- (UIImage *)fileIconForType {
    NSString *name = @"cjFileTypeWord";
    NSString *t = [self.type lowercaseString];
    if ([t isEqualToString:@"doc"] || [t isEqualToString:@"docx"]) {
        name = @"cjFileTypeWord";
    } else if ([t isEqualToString:@"xls"] || [t isEqualToString:@"xlsx"]) {
        name = @"cjFileTypeExcel";
    } else if ([t isEqualToString:@"ppt"] || [t isEqualToString:@"pptx"]) {
        name = @"cjFileTypePPT";
    } else if ([t isEqualToString:@"jpg"] || [t isEqualToString:@"jpeg"] || [t isEqualToString:@"png"]) {
        name = @"cjFileTypeImage";
    }
    return [UIImage imageNamed:name];
}

- (NSString *)readableFileSize {
    return self.fileSize;
}

- (NSString *)formatFileSize:(CGFloat)size {
    NSString *unit = nil;
    if (size < 1024) {
        unit = @"B";
    } else if (size < 1024*1024) {
        size /= 1024;
        unit = @"K";
    } else {
        size /= 1024*1024;
        unit = @"M";
    }
    return [NSString stringWithFormat:@"%.2lf%@", size, unit];
}

- (BOOL)isSoundFile {
    NSString *t = [self.type lowercaseString];
    return [t isEqualToString:@"aac"] || [t isEqualToString:@"arm"] || [t isEqualToString:@"mp3"];
}

- (BOOL)isImageFile {
    NSString *t = [self.type lowercaseString];
    return [t isEqualToString:@"jpg"] || [t isEqualToString:@"jpeg"] || [t isEqualToString:@"png"];
}


@end

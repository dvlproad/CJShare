//
//  FileModel.m
//  CJShareDemo
//
//  Created by 李超前 on 2016/12/27.
//  Copyright © 2016年 dvlproad. All rights reserved.
//

#import "FileModel.h"

@implementation FileModel

- (NSURL *)fileValidURL {
    if (self.fileSourceType == CJFileSourceTypeNetwork) {
        NSURL *URL = [NSURL URLWithString:self.networkReturnUrl];
        return URL;
        
    } else {
        NSURL *URL = [NSURL fileURLWithPath:self.localAbsolutePath];
        
        return URL;
    }
}

+ (NSDictionary *)JSONKeyPathsByPropertyKey {
    return @{@"localRelativePath":  @"localRelativePath",
             @"networkReturnUrl":   @"networkReturnUrl",
             
             @"fileName":       @"fileName",
             @"fileExtension":  @"fileExtension",
             @"fileSize":       @"fileSize",
             
             @"networkId":  @"id",
             @"fileId":     @"infoId",
             @"status":     @"status",
             };
}

+ (BOOL)propertyIsOptional:(NSString *)propertyName {
    return YES;
}

//
//+ (NSValueTransformer *)leaderJSONTransformer {
//    return [MTLValueTransformer mtl_JSONDictionaryTransformerWithModelClass:[HPStaffEntity class]];
//}
//

- (UIImage *)fileIconForType {
    NSString *name = @"cjFileTypeWord";
    NSString *t = [self.fileExtension lowercaseString];
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
    NSString *t = [self.fileExtension lowercaseString];
    return [t isEqualToString:@"aac"] || [t isEqualToString:@"arm"] || [t isEqualToString:@"mp3"];
}

- (BOOL)isImageFile {
    NSString *t = [self.fileExtension lowercaseString];
    return [t isEqualToString:@"jpg"] || [t isEqualToString:@"jpeg"] || [t isEqualToString:@"png"];
}


@end

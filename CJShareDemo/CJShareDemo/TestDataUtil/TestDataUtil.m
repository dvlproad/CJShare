//
//  TestDataUtil.m
//  CJShareDemo
//
//  Created by 李超前 on 2017/1/12.
//  Copyright © 2017年 dvlproad. All rights reserved.
//

#import "TestDataUtil.h"
#import "FileModel.h"

@implementation TestDataUtil

+ (NSArray *)getTestLocalFilesInBundle {
    NSString *fileType = [NSString stringWithFormat:@"%ld", CJFileTypeLocal];
    
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setDateFormat:@"yyyy-MM-dd HH:mm:ss"];
    NSString *fileCreateTime = [dateFormatter stringFromDate:[NSDate date]];
    
    FileModel *imageFile = [[FileModel alloc] init];
    imageFile.fileType = fileType;
    imageFile.fileName = @"Image Document";
    //imageFile.fileUrl = [[NSBundle mainBundle] pathForResource:@"Image Document" ofType:@"jpg"];
    imageFile.fileUrl = [[[NSBundle mainBundle] URLForResource:@"Image Document" withExtension:@"jpg"] absoluteString];
    //    NSString *Url = [[NSBundle mainBundle] pathForResource:@"Image Document" ofType:@"jpg"];
    //    NSURL *URL = [[NSBundle mainBundle] URLForResource:@"Image Document" withExtension:@"jpg"];
    //    NSLog(@"Url = %@", Url);
    //    NSLog(@"URL = %@", [URL absoluteString]);
    imageFile.createTime = fileCreateTime;
    
    FileModel *PDFFile = [[FileModel alloc] init];
    PDFFile.fileType = fileType;
    PDFFile.fileName = @"PDF Document";
    //PDFFile.fileUrl = [[NSBundle mainBundle] pathForResource:@"PDF Document" ofType:@"pdf"];
    PDFFile.fileUrl = [[[NSBundle mainBundle] URLForResource:@"PDF Document" withExtension:@"pdf"] absoluteString];
    PDFFile.createTime = fileCreateTime;
    
    FileModel *TextFile = [[FileModel alloc] init];
    TextFile.fileType = fileType;
    TextFile.fileName = @"Text Document";
    //TextFile.fileUrl = [[NSBundle mainBundle] pathForResource:@"Text Document" ofType:@"txt"];
    TextFile.fileUrl = [[[NSBundle mainBundle] URLForResource:@"Text Document" withExtension:@"txt"] absoluteString];
    TextFile.createTime = fileCreateTime;
    
    FileModel *HTMLFile = [[FileModel alloc] init];
    HTMLFile.fileType = fileType;
    HTMLFile.fileName = @"HTML Document";
    //HTMLFile.fileUrl = [[NSBundle mainBundle] pathForResource:@"HTML Document" ofType:@"html"];
    HTMLFile.fileUrl = [[[NSBundle mainBundle] URLForResource:@"HTML Document" withExtension:@"html"] absoluteString];
    HTMLFile.createTime = fileCreateTime;
    
    return @[imageFile, PDFFile, TextFile, HTMLFile];
}

@end

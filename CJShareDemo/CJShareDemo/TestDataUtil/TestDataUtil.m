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
    CJFileSourceType fileSourceType = CJFileSourceTypeLocalBundle;
    
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setDateFormat:@"yyyy-MM-dd HH:mm:ss"];
    NSString *fileCreateTime = [dateFormatter stringFromDate:[NSDate date]];
    
    FileModel *imageFile = [[FileModel alloc] init];
    imageFile.fileSourceType = fileSourceType;
    imageFile.fileName = @"Image Document.jpg";
    //imageFile.fileUrl = [[NSBundle mainBundle] pathForResource:@"Image Document" ofType:@"jpg"];
    imageFile.localRelativePath = [[[NSBundle mainBundle] URLForResource:@"Image Document" withExtension:@"jpg"] absoluteString];
    imageFile.createTime = fileCreateTime;
    
    FileModel *wordFile = [[FileModel alloc] init];
    wordFile.fileSourceType = fileSourceType;
    wordFile.fileName = @"Word Document.doc";
    //wordFile.fileUrl = [[NSBundle mainBundle] pathForResource:@"Word Document" ofType:@"jpg"];
    wordFile.localRelativePath = [[[NSBundle mainBundle] URLForResource:@"Word Document" withExtension:@"doc"] absoluteString];
    wordFile.createTime = fileCreateTime;
    
    FileModel *excelFile = [[FileModel alloc] init];
    excelFile.fileSourceType = fileSourceType;
    excelFile.fileName = @"Excel Document.xlsx";
    //excelFile.fileUrl = [[NSBundle mainBundle] pathForResource:@"Excel Document" ofType:@"jpg"];
    excelFile.localRelativePath = [[[NSBundle mainBundle] URLForResource:@"Excel Document" withExtension:@"xlsx"] absoluteString];
    excelFile.createTime = fileCreateTime;
    
    FileModel *PDFFile = [[FileModel alloc] init];
    PDFFile.fileSourceType = fileSourceType;
    PDFFile.fileName = @"PDF Document.pdf";
    //PDFFile.fileUrl = [[NSBundle mainBundle] pathForResource:@"PDF Document" ofType:@"pdf"];
    PDFFile.localRelativePath = [[[NSBundle mainBundle] URLForResource:@"PDF Document" withExtension:@"pdf"] absoluteString];
    PDFFile.createTime = fileCreateTime;
    
    FileModel *TextFile = [[FileModel alloc] init];
    TextFile.fileSourceType = fileSourceType;
    TextFile.fileName = @"Text Document.txt";
    //TextFile.fileUrl = [[NSBundle mainBundle] pathForResource:@"Text Document" ofType:@"txt"];
    TextFile.localRelativePath = [[[NSBundle mainBundle] URLForResource:@"Text Document" withExtension:@"txt"] absoluteString];
    TextFile.createTime = fileCreateTime;
    
    FileModel *HTMLFile = [[FileModel alloc] init];
    HTMLFile.fileSourceType = fileSourceType;
    HTMLFile.fileName = @"HTML Document.html";
    //HTMLFile.fileUrl = [[NSBundle mainBundle] pathForResource:@"HTML Document" ofType:@"html"];
    HTMLFile.localRelativePath = [[[NSBundle mainBundle] URLForResource:@"HTML Document" withExtension:@"html"] absoluteString];
    HTMLFile.createTime = fileCreateTime;
    
    return @[imageFile, wordFile, excelFile, PDFFile, TextFile, HTMLFile];
}

@end

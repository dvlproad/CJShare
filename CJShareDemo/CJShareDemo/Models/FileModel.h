//
//  FileModel.h
//  CJShareDemo
//
//  Created by 李超前 on 2016/12/27.
//  Copyright © 2016年 dvlproad. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <Foundation/Foundation.h>
#import <JSONModel/JSONModel.h>

#import "CJFileModel.h"


@interface FileModel : CJFileModel

@property (nonatomic, copy) NSString *fileId;
@property (nonatomic, copy) NSString *status;   //有效性
@property (nonatomic, copy) NSString *viewUrl;

@property (nonatomic, assign) BOOL isSearchResult;  /**< 是否是搜索出来 */
@property (nonatomic, assign) BOOL containInSelf;   /**< 本身包含 */
@property (nonatomic, assign) BOOL containInMember; /**< 成员中包含 */

- (UIImage *)fileIconForType;
- (NSString *)readableFileSize;
- (NSString *)formatFileSize:(CGFloat)size;
- (BOOL)isSoundFile;
- (BOOL)isImageFile;

@end

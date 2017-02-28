//
//  CJBaseFileModel.h
//  CJShareDemo
//
//  Created by 李超前 on 2017/2/28.
//  Copyright © 2017年 dvlproad. All rights reserved.
//

#import <JSONModel/JSONModel.h>

typedef NS_ENUM(NSUInteger, CJFileSourceType) {
    CJFileSourceTypeLocalSandbox,   /**< 文件原本来源于本地沙盒,上传时候可能有网络路径 */
    CJFileSourceTypeNetwork,        /**< 文件原本来源于网络，下载时候可能有本地路径 */
    CJFileSourceTypeLocalBundle,    /**< 文件来源于本地Bundle */
};

@interface CJBaseFileModel : JSONModel

@property (nonatomic, assign) CJFileSourceType fileSourceType;
@property (nonatomic, copy) NSString *fileName;

@property (nonatomic, copy, readonly) NSString *localAbsolutePath; /**< 本地绝对路径 */
@property (nonatomic, copy) NSString *localRelativePath; /**< 本地相对路径(因为沙盒路径会变) */
@property (nonatomic, copy) NSString *networkAbsoluteUrl;/**< 网络绝对路径(有时会省略前缀) */
@property (nonatomic, copy, readonly) NSString *networkReturnUrl; /**< 网络返回的路径(相对/绝对) */

- (NSURL *)fileValidURL;

@end

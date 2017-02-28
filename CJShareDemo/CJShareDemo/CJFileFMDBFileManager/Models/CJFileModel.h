//
//  CJFileModel.h
//  CJShareDemo
//
//  Created by 李超前 on 2017/2/28.
//  Copyright © 2017年 dvlproad. All rights reserved.
//

#import "CJBaseFileModel.h"

@interface CJFileModel : CJBaseFileModel

@property (nonatomic, copy) NSString *fileSize;
@property (nonatomic, copy) NSString *createTime;
@property (nonatomic, copy) NSString *updateTime;
@property (nonatomic, copy) NSString *fileExtension;

//@property (nonatomic, copy) NSString *localId;
//@property (nonatomic, copy) NSString *networkId;

@end

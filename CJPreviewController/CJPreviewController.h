//
//  CJPreviewController.h
//  CJShareDemo
//
//  Created by 李超前 on 2017/2/28.
//  Copyright © 2017年 dvlproad. All rights reserved.
//

#import <QuickLook/QuickLook.h>
#import "CJFileModel.h"

@interface CJPreviewController : QLPreviewController

@property (nonatomic, strong) NSArray<CJFileModel *> *fileModels;

@end

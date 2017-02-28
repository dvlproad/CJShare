//
//  CJAllPreviewViewController.h
//  CJShareDemo
//
//  Created by 李超前 on 2017/2/28.
//  Copyright © 2017年 dvlproad. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <QuickLook/QuickLook.h>
#import "CJFileModel.h"

@interface CJAllPreviewViewController : UIViewController {
    
}

- (UIViewController *)previewFileModels:(NSArray<CJFileModel *> *)fileModels andShowItemIndex:(NSInteger)currentPreviewItemIndex;

@end

//
//  FileListViewController.h
//  CJShareDemo
//
//  Created by 李超前 on 2016/12/26.
//  Copyright © 2016年 dvlproad. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <QuickLook/QuickLook.h>
#import "FileFMDBUtil.h"
#import <CJBaseSearchViewController/CJBaseSearchTableViewController.h>

@interface FileListViewController : CJBaseSearchTableViewController <UISearchBarDelegate, UISearchDisplayDelegate, QLPreviewControllerDataSource, QLPreviewControllerDelegate> {
    
}

@property (nonatomic, strong) FileModel *previewFileModel;

@end

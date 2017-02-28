//
//  FileListViewController.h
//  CJShareDemo
//
//  Created by 李超前 on 2016/12/26.
//  Copyright © 2016年 dvlproad. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <CJBaseSearchViewController/CJBaseSearchTableViewController.h>
#import "CJFileFMDBFileManager.h"

@interface FileListViewController : CJBaseSearchTableViewController <UISearchBarDelegate, UISearchDisplayDelegate> {
    
}

@property (nonatomic, strong) FileModel *previewFileModel;

@end

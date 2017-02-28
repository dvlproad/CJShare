//
//  CJPreviewController.m
//  CJShareDemo
//
//  Created by 李超前 on 2017/2/28.
//  Copyright © 2017年 dvlproad. All rights reserved.
//

#import "CJPreviewController.h"

@interface CJPreviewController () <QLPreviewControllerDataSource, QLPreviewControllerDelegate>

@end

@implementation CJPreviewController

- (instancetype)init {
    self = [super init];
    if (self) {
        [self commonInit];
    }
    
    return self;
}

- (void)commonInit {
    self.dataSource = self;
    self.delegate = self;
}

#pragma mark - QLPreviewControllerDataSource && QLPreviewControllerDelegate
- (NSInteger)numberOfPreviewItemsInPreviewController:(QLPreviewController *)controller {
    return [self.fileModels count];
}

- (id<QLPreviewItem>)previewController:(QLPreviewController *)controller previewItemAtIndex:(NSInteger)index {
    CJFileModel *fileModle = [self.fileModels objectAtIndex:index];
    NSURL *URL = fileModle.fileValidURL;
    
    return URL;
}

- (CGRect)previewController:(QLPreviewController *)controller frameForPreviewItem:(id<QLPreviewItem>)item inSourceView:(UIView *__autoreleasing  _Nullable *)view {
    //return self.view.bounds;
    return CGRectMake(100, 100, 200, 300);
}

- (void)previewControllerWillDismiss:(QLPreviewController *)controller {
    CJFileModel *fileModle = [self.fileModels objectAtIndex:controller.currentPreviewItemIndex];
    NSLog(@"self.fileURL = %@", fileModle.fileValidURL);
    
    NSString *fileName = [fileModle.fileValidURL lastPathComponent];
    self.navigationItem.title = [NSString stringWithFormat:@"刚显示的为:%@", fileName];
}



- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end

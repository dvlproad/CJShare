//
//  PreviewController.m
//  CJShareDemo
//
//  Created by 李超前 on 2016/12/26.
//  Copyright © 2016年 dvlproad. All rights reserved.
//

#import "PreviewController.h"

@interface PreviewController ()

@end

@implementation PreviewController

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    
    NSString *fileName = [self.fileURL lastPathComponent];
    self.navigationItem.title = fileName;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    
}

#pragma mark - QLPreviewControllerDataSource
- (NSInteger)numberOfPreviewItemsInPreviewController:(QLPreviewController *)controller {
    return 1;
}

- (id<QLPreviewItem>)previewController:(QLPreviewController *)controller previewItemAtIndex:(NSInteger)index {
    return self.fileURL;
}

#pragma mark - QLPreviewControllerDelegate
- (CGRect)previewController:(QLPreviewController *)controller frameForPreviewItem:(id<QLPreviewItem>)item inSourceView:(UIView *__autoreleasing  _Nullable *)view {
//    return self.view.bounds;
    return CGRectMake(100, 100, 200, 300);
}

- (void)previewControllerWillDismiss:(QLPreviewController *)controller {
    NSLog(@"self.fileURL = %@", [self.fileURL absoluteString]);
    
    NSString *fileName = [self.fileURL lastPathComponent];
    [self.label setText:fileName];
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

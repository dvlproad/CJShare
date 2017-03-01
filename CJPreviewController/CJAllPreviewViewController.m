//
//  CJAllPreviewViewController.m
//  CJShareDemo
//
//  Created by 李超前 on 2017/2/28.
//  Copyright © 2017年 dvlproad. All rights reserved.
//

#import "CJAllPreviewViewController.h"
#import <MWPhotoBrowser/MWPhotoBrowser.h>

@interface CJAllPreviewViewController () <MWPhotoBrowserDelegate, QLPreviewControllerDataSource, QLPreviewControllerDelegate> {
    
}
@property (nonatomic, strong) NSArray<CJFileModel *> *fileModels;
@property (nonatomic, strong) NSMutableArray<CJFileModel *> *photos;
//@property (nonatomic, strong) UIViewController *belongViewController;

@property (nonatomic, strong) QLPreviewController *previewController;

@end

@implementation CJAllPreviewViewController

- (instancetype)init {
    self = [super init];
    if (self) {
        [self commonInit];
    }
    
    return self;
}

- (void)commonInit {
    self.photos = [[NSMutableArray alloc] init];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
}

- (BOOL)isImageFile:(CJFileModel *)fileModel {
    NSString *fileExtension = [[fileModel.fileName pathExtension] lowercaseString];
    BOOL isImageFile = [fileExtension isEqualToString:@"jpg"] || [fileExtension isEqualToString:@"jpeg"] || [fileExtension isEqualToString:@"png"];
    
    return isImageFile;
}

- (UIViewController *)previewFileModels:(NSArray<CJFileModel *> *)fileModels andShowItemIndex:(NSInteger)currentPreviewItemIndex {
    _fileModels = fileModels;
    
    [self.photos removeAllObjects];
    for (CJFileModel *fileModel in fileModels) {
        if ([self isImageFile:fileModel]) {
            [self.photos addObject:fileModel];
        }
    }
    
    CJFileModel *previewFileModel = [fileModels objectAtIndex:currentPreviewItemIndex];
    
    if ([self isImageFile:previewFileModel]) { //如果是图片使用图片自己的预览
        NSInteger photoIndex = -1;
        NSInteger photoCount = self.photos.count;
        for (NSInteger index = 0; index < photoCount; index++) {
            CJFileModel *fileModel = [self.photos objectAtIndex:index];
            if (fileModel == previewFileModel) {
                photoIndex = index;
            }
        }
        if (photoIndex == -1 ) {
            NSLog(@"Error:未找到photoIndex");
            return nil;
        }
        
        
        MWPhotoBrowser *browser = [[MWPhotoBrowser alloc] initWithDelegate:self];
        browser.enableGrid = NO;
        browser.enableSwipeToDismiss = YES;
        [browser setCurrentPhotoIndex:photoIndex];
        
        //[belongViewController.navigationController pushViewController:self.previewController animated:YES];
        return browser;
        
    } else if (previewFileModel.fileSourceType == CJFileSourceTypeLocalSandbox ||
               previewFileModel.fileSourceType == CJFileSourceTypeLocalBundle) {
        QLPreviewController *previewController = [[QLPreviewController alloc] init];
        previewController.dataSource = self;
        previewController.delegate = self;
        previewController.currentPreviewItemIndex = currentPreviewItemIndex;
        
        return previewController;
        
    } else {
//        WebsiteViewController *vc = [[WebsiteViewController alloc] init];
//        vc.address = e.viewUrl;
//        vc.willPopViewController = self.willPopPreViewController;
//        vc.webTitle = [[e.originalName componentsSeparatedByString:@"."] firstObject];
//        [self.viewController.navigationController pushViewController:vc animated:YES];
        
        return nil;
    }
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



#pragma mark - MWPhotoBrowser Delegate
- (NSUInteger)numberOfPhotosInPhotoBrowser:(MWPhotoBrowser *)photoBrowser {
    return self.photos.count;
}

- (id<MWPhoto>)photoBrowser:(MWPhotoBrowser *)photoBrowser photoAtIndex:(NSUInteger)index {
    CJFileModel *fileModel = [self.photos objectAtIndex:index];
    MWPhoto *photo = [MWPhoto photoWithURL:fileModel.fileValidURL];
    
    return photo;
}

- (void)photoBrowserDidFinishModalPresentation:(MWPhotoBrowser *)photoBrowser {
    //[self.viewController dismissViewControllerAnimated:YES completion:nil];
    self.photos = nil;
    self.fileModels = nil;
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

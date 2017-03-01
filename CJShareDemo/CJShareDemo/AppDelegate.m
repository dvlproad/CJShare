//
//  AppDelegate.m
//  CJShareDemo
//
//  Created by 李超前 on 2016/12/26.
//  Copyright © 2016年 dvlproad. All rights reserved.
//

#import "AppDelegate.h"
#import "FileListViewController.h"
#import "PreviewController.h"
#import "CJFileFMDBFileManager.h"
#import <CJFMDBFileManager/CJFileManager+CalculateFileSize.h>
#import "ViewController.h"

#import "TestDataUtil.h"

@interface AppDelegate ()

@end

@implementation AppDelegate


- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    // Override point for customization after application launch.
    
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        //耗时的操作
        [CJFileFMDBFileManager createDatabaseForUserName:@"dvlproadFile.db"];
        
        NSArray<FileModel *> *files = [TestDataUtil getTestLocalFilesInBundle];
        NSMutableArray *sqls = [[NSMutableArray alloc] init];
        for (FileModel *file in files) {
            file.fileSourceType = CJFileSourceTypeLocalBundle;
            NSString *sql = [CJLocalFileTableSQL sqlForInsertInfo:file];
            [sqls addObject:sql];
        }
        
        for (NSInteger i = 0; i < 10; i++) {
            NSLog(@"-----------------------");
            [CJFileFMDBFileManager insertLocalBundleFileInfos:files useTransaction:NO];
            [CJFileFMDBFileManager insertLocalBundleFileInfos:files useTransaction:YES];
            
            [[CJFileFMDBFileManager sharedInstance] cjExecuteUpdate:sqls useTransaction:YES];
            [[CJFileFMDBFileManager sharedInstance] cjExecuteUpdate:sqls useTransaction:NO];
        }
        
        
        dispatch_async(dispatch_get_main_queue(), ^{
            //更新界面
        });
    });
    
    
    return YES;
}


#pragma mark -
#pragma mark Image view

//#if __IPHONE_OS_VERSION_MAX_ALLOWED < __IPHONE_9_0
//- (BOOL)application:(UIApplication *)application openURL:(NSURL *)url sourceApplication:(nullable NSString *)sourceApplication annotation:(id)annotation
//{
//    UINavigationController *navigation = (UINavigationController *)application.keyWindow.rootViewController;
//    ViewController *displayController = (ViewController *)navigation.topViewController;
//
//    [displayController.imageView setImage:[UIImage imageWithData:[NSData dataWithContentsOfURL:url]]];
//    [displayController.label setText:sourceApplication];
//
//    return YES;
//}
//
//#else
//- (BOOL)application:(UIApplication *)application openURL:(NSURL *)url options:(nonnull NSDictionary<NSString *,id> *)options
//{
//    UINavigationController *navigation = (UINavigationController *)application.keyWindow.rootViewController;
//    ViewController *displayController = (ViewController *)navigation.topViewController;
//
//    [displayController.imageView setImage:[UIImage imageWithData:[NSData dataWithContentsOfURL:url]]];
//    [displayController.label setText:[options objectForKey:UIApplicationOpenURLOptionsSourceApplicationKey]];
//
//    return YES;
//}
//#endif

///////////////////////////////////////////////////////////////////////////////////////////////////////////
#pragma mark -
#pragma mark Quick Look

//#if __IPHONE_OS_VERSION_MAX_ALLOWED < __IPHONE_9_0
- (BOOL)application:(UIApplication *)application
            openURL:(NSURL *)url
  sourceApplication:(NSString *)sourceApplication
         annotation:(id)annotation
{
    [self doFileInapplication:application openURL:url];
    
    return YES;
}


//#else
- (BOOL)application:(UIApplication *)application openURL:(NSURL *)url options:(nonnull NSDictionary<NSString *,id> *)options
{
    [self doFileInapplication:application openURL:url];
    
    return YES;
}
//#endif

- (void)doFileInapplication:(UIApplication *)application openURL:(NSURL *)url {
    NSLog(@"openUrl = %@", url);
    
    if (![[url absoluteString] hasPrefix:@"file:"]) {
        return;
    }
    
    FileModel *fileModel = [[FileModel alloc] init];
    fileModel.fileSourceType = CJFileSourceTypeLocalSandbox;
    fileModel.fileName = [url lastPathComponent];
    fileModel.localRelativePath = [url lastPathComponent];
    
    NSInteger fileSize = [CJFileManager calculateFileSizeForFilePath:[url absoluteString]];
    NSString *fileSizeString = [CJFileManager showFileSize:fileSize unitType:CJFileSizeUnitTypeKB];
    fileModel.fileSize = fileSizeString;
    fileModel.fileExtension = [url pathExtension];
    
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setDateFormat:@"yyyy-MM-dd HH:mm:ss"];
    fileModel.createTime = [dateFormatter stringFromDate:[NSDate date]];
    
    if ([fileSizeString integerValue] > 3 * 1000) { //大于3M
        NSString *message = [NSString stringWithFormat:@"文件太大，请选择小于3M的文件"];
        NSLog(@"%@", message);
        //[UIGlobal showMessage:message];
        
        [[NSFileManager defaultManager] removeItemAtPath:[url absoluteString] error:nil];
        
    } else {
        
//        HPUser *user = [HPUser current];
//        BOOL isLogin = [user.userName length] > 0 ? YES : NO;
        BOOL isLogin = YES;
        if (isLogin) {
            [self application:application goFileListViewControllerAndOpenFileModel:fileModel];
        } else {
            [self applicationGoLoginViewController:application];
        }
    }
}

- (void)applicationGoLoginViewController:(UIApplication *)application {
    /*
    [UIGlobal showMessage:@"请先登录"];
    
    UINavigationController *navigation = (UINavigationController *)application.keyWindow.rootViewController;
    
    LoginViewController *rootView = [[LoginViewController alloc] initWithNibName:@"LoginViewController" bundle:nil];
    [navigation setViewControllers:@[rootView] animated:YES];
    */
}

- (void)application:(UIApplication *)application goFileListViewControllerAndOpenFileModel:(FileModel *)fileModel {
    BOOL insertSuccess = [CJFileFMDBFileManager insertLocalSandboxFileInfos:@[fileModel] useTransaction:YES];
    if (insertSuccess) {
        NSString *messge = [NSString stringWithFormat:@"已成功添加《%@》为附件到我的文档", fileModel.fileName];
        NSLog(@"message = %@", messge);
        //[UIGlobal showMessage:messge];
    }
    
    dispatch_async(dispatch_get_main_queue(), ^{
        UINavigationController *navigation = (UINavigationController *)application.keyWindow.rootViewController;
        NSArray *navigationViewControllers = navigation.viewControllers;
        if (navigationViewControllers.count == 0) {
            return;
        }
        
        NSInteger xxx = 0;
        NSInteger count = navigationViewControllers.count;
        for (NSInteger i = 0; i < count; i++) {
            UIViewController *viewController = [navigationViewControllers objectAtIndex:i];
            if ([viewController isKindOfClass:[ViewController class]]) {
                xxx = i;
                break;
            }
        }
        ViewController *viewController = (ViewController *)[navigationViewControllers objectAtIndex:xxx];
        
        FileListViewController *fileListViewController = [[FileListViewController alloc] init];
        fileListViewController.previewFileModel = fileModel;
        
        [navigation setViewControllers:@[viewController, fileListViewController] animated:YES];
    });
}



- (void)getPreviewController {
    
}

- (void)applicationWillResignActive:(UIApplication *)application {
    // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
    // Use this method to pause ongoing tasks, disable timers, and invalidate graphics rendering callbacks. Games should use this method to pause the game.
}


- (void)applicationDidEnterBackground:(UIApplication *)application {
    // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
    // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
}


- (void)applicationWillEnterForeground:(UIApplication *)application {
    // Called as part of the transition from the background to the active state; here you can undo many of the changes made on entering the background.
}


- (void)applicationDidBecomeActive:(UIApplication *)application {
    // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
}


- (void)applicationWillTerminate:(UIApplication *)application {
    // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
}


@end

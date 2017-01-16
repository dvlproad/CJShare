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
#import "FileDataManager.h"

@interface AppDelegate ()

@end

@implementation AppDelegate


- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    // Override point for customization after application launch.
    
    [FileDataManager createFileDatabaseForUserName:@"dvlproadFile.db"];
    
    
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

#if __IPHONE_OS_VERSION_MAX_ALLOWED < __IPHONE_9_0
- (BOOL)application:(UIApplication *)application openURL:(NSURL *)url sourceApplication:(nullable NSString *)sourceApplication annotation:(id)annotation
{
    UINavigationController *navigation = (UINavigationController *)application.keyWindow.rootViewController;
    [navigation popToRootViewControllerAnimated:NO];
    
    PreviewController *displayController = (PreviewController *)navigation.topViewController;
    
    displayController.fileURL = url;
    
    QLPreviewController *preview = [[QLPreviewController alloc] initWithNibName:nil bundle:nil];
    preview.dataSource = displayController;
    preview.delegate = displayController;
    [preview setCurrentPreviewItemIndex:0];
    
    [navigation pushViewController:preview animated:YES];
    return YES;
}

#else
- (BOOL)application:(UIApplication *)application openURL:(NSURL *)url options:(nonnull NSDictionary<NSString *,id> *)options
{
    FileModel *fileModel = [[FileModel alloc] init];
    fileModel.fileType = [NSString stringWithFormat:@"%ld", CJFileTypeLocal];
    fileModel.fileName = [url lastPathComponent];
    NSString *Url = [url absoluteString];
    fileModel.fileUrl = Url;
    
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setDateFormat:@"yyyy-MM-dd HH:mm:ss"];
    fileModel.createTime = [dateFormatter stringFromDate:[NSDate date]];
    
    BOOL insertSuccess = [FileFMDBUtil insertInfo:fileModel];
    if (insertSuccess) {
        NSString *messge = [NSString stringWithFormat:@"已成功添加《%@》为附件到我的文档", fileModel.fileName];
        NSLog(@"message = %@", messge);
        /*
        [[[UIAlertView alloc] initWithTitle:nil
                                    message:messge
                                   delegate:nil
                          cancelButtonTitle:@"确定"
                          otherButtonTitles:nil] show];
        */
    }
    
    UINavigationController *navigation = (UINavigationController *)application.keyWindow.rootViewController;
//    [navigation popToRootViewControllerAnimated:NO];
    
    FileListViewController *fileListViewController = [[FileListViewController alloc] initWithNibName:@"FileListViewController" bundle:nil];
    fileListViewController.previewFileModel = fileModel;
    [navigation setViewControllers:@[fileListViewController] animated:YES];
    
//    QLPreviewController *preview = [[QLPreviewController alloc] initWithNibName:nil bundle:nil];
//    preview.dataSource = fileListViewController;
//    preview.delegate = fileListViewController;
//    [preview setCurrentPreviewItemIndex:0];
    
    /*
    PreviewController *displayController = [[PreviewController alloc] initWithNibName:@"PreviewController" bundle:nil];
    displayController.fileURL = url;
    
    QLPreviewController *preview = [[QLPreviewController alloc] initWithNibName:nil bundle:nil];
    preview.dataSource = displayController;
    preview.delegate = displayController;
    [preview setCurrentPreviewItemIndex:0];
    navigation.viewControllers = @[fileListViewController];
    */
    
//    [navigation pushViewController:preview animated:YES];
    return YES;
}
#endif


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

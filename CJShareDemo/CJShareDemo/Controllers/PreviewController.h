//
//  PreviewController.h
//  CJShareDemo
//
//  Created by 李超前 on 2016/12/26.
//  Copyright © 2016年 dvlproad. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <QuickLook/QuickLook.h>

@interface PreviewController : UIViewController <QLPreviewControllerDataSource, QLPreviewControllerDelegate> {
    
}
@property (weak, nonatomic) IBOutlet UILabel *label;
@property (weak, nonatomic) IBOutlet UIImageView *imageView;
@property (copy, nonatomic) NSURL *fileURL;

@end

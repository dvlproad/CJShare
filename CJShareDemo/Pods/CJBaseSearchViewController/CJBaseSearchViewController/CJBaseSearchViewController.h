//
//  CJBaseSearchViewController.h
//  AllScrollViewDemo
//
//  Created by dvlproad on 2016/11/21.
//  Copyright © 2016年 ciyouzen. All rights reserved.
//

#import <UIKit/UIKit.h>

#ifndef kIsDebugCJSortedAndSearchUtil
    #import <CJSortedAndSearchUtil/CJSearchUtil.h>   //提交Pod时候使用
#else
    #import "CJSearchUtil.h"  //调试时候使用
#endif

typedef void(^CJSearchCompleteBlock)();

@interface CJBaseSearchViewController : UIViewController <UISearchBarDelegate, UISearchResultsUpdating> {
    
}
@property (nonatomic, strong) NSMutableArray<CJSectionDataModel *> *originSectionDataModels;
@property (nonatomic, strong) NSMutableArray<CJSectionDataModel *> *resultSectionDataModels;

//在IOS8之前都是用UISearchDisplayController, 但是IOS8之后就用UISearchController, UISearchController用起来很方便, 它本身就带有searchBar, 而且自动会模态推到导航栏
//@property (nonatomic, strong) UISearchBar *searchBar;
//@property (nonatomic, strong) UISearchDisplayController *searchController;
@property (nonatomic, strong) UISearchController *searchController;

@property (nonatomic, copy) CJSearchCompleteBlock searchCompleteBlock; /**< 搜索结束时候执行 */
@property (nonatomic, assign) BOOL implementSearchMethodByMyself;

@end

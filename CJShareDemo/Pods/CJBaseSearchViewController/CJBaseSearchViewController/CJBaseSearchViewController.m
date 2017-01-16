//
//  CJBaseSearchViewController.m
//  AllScrollViewDemo
//
//  Created by dvlproad on 2016/11/21.
//  Copyright © 2016年 ciyouzen. All rights reserved.
//

#import "CJBaseSearchViewController.h"
#import <NSOperationQueueUtil/NSOperationQueueUtil.h>

@interface CJBaseSearchViewController () {
    
}
@property (nonatomic, strong) NSOperationQueue *searchOperationQueue;

@end

@implementation CJBaseSearchViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
}

#pragma mark - UISearchResultsUpdating
- (void)updateSearchResultsForSearchController:(UISearchController *)searchController {
    NSString *searchString = [self.searchController.searchBar text];
    [self doSearchText:searchString];
}

/*
- (BOOL)searchDisplayController:(UISearchDisplayController *)controller shouldReloadTableForSearchString:(NSString *)searchString {
    [self doSearchText:searchString];
    
    return YES;//刷新表格
}
*/


#pragma mark - 搜索功能实现
- (void)doSearchText:(NSString *)searchText {
    __weak typeof(self)weakSelf = self;
    
    NSOperation *operation1 = [NSBlockOperation blockOperationWithBlock:^{
        weakSelf.resultSectionDataModels = [CJSearchUtil searchText:searchText inSectionDataModels:weakSelf.originSectionDataModels dataModelSearchSelector:@selector(name) supportPinyin:YES];
    }];
    NSArray *operations = @[operation1];
    
    NSOperation *operationLast = [NSBlockOperation blockOperationWithBlock:^{
        //NSLog(@"搜索结果 %@", weakSelf.resultSectionDataModels);
        
        dispatch_async(dispatch_get_main_queue(), ^{
            if (self.searchCompleteBlock) {
                self.searchCompleteBlock();
            }
        });
    }];
    
    self.searchOperationQueue = [NSOperationQueueUtil createOperationQueueWithOperations:operations lastOperation:operationLast];
}

#pragma mark - Getter
- (UISearchController *)searchController {
    if (_searchController == nil) {
        _searchController = [[UISearchController alloc] initWithSearchResultsController:nil];
        _searchController.searchResultsUpdater = self;
        _searchController.dimsBackgroundDuringPresentation = NO;
        _searchController.hidesNavigationBarDuringPresentation = YES;//搜索的时候是否遮挡导航栏
        
        UISearchBar *searchBar = _searchController.searchBar;
        searchBar.delegate = self;
        
        //        searchBar.translucent = NO;
        //        searchBar.barTintColor = [UIColor redColor];//边框背景
        //        searchBar.layer.borderWidth = 1;
        //        searchBar.layer.borderColor = [[UIColor brownColor] CGColor];
        searchBar.placeholder = NSLocalizedString(@"搜索", nil);
    }
    
    return _searchController;
}

#pragma mark - UISearchBarDelegate
- (BOOL)searchBarShouldBeginEditing:(UISearchBar *)searchBar {
    return YES;
}

- (BOOL)searchBarShouldEndEditing:(UISearchBar *)searchBar {
    return YES;
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

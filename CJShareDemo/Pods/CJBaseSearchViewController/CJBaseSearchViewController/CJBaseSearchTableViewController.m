//
//  CJBaseSearchTableViewController.m
//  AllScrollViewDemo
//
//  Created by dvlproad on 2016/11/21.
//  Copyright © 2016年 ciyouzen. All rights reserved.
//

#import "CJBaseSearchTableViewController.h"

@interface CJBaseSearchTableViewController () <UITableViewDataSource, UITableViewDelegate>  {
    
}

@end

@implementation CJBaseSearchTableViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    [self cj_setupViews];
    
    __weak typeof(self)weakSelf = self;
    self.searchCompleteBlock = ^(void) {
        [weakSelf.tableView reloadData];//刷新表格
    };
}

- (void)cj_setupViews {
    self.searchController.searchResultsUpdater = self;
    self.searchController.searchBar.delegate = self;
    self.tableView.tableHeaderView = self.searchController.searchBar;
    
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    [self.tableView registerClass:[UITableViewCell class] forCellReuseIdentifier:@"cell"];
    [self cj_makeView:self.view addSubView:self.tableView withEdgeInsets:UIEdgeInsetsZero];
}

#pragma mark - getter UISearchBar && UISearchDisplayController
- (UITableView *)tableView {
    if (!_tableView) {
        _tableView = [[UITableView alloc] initWithFrame:CGRectZero style:UITableViewStylePlain];
        _tableView.delegate = self;
        _tableView.dataSource = self;
        _tableView.tableFooterView = [[UIView alloc] init];
        _tableView.allowsMultipleSelection = YES;
        
        //清空tableview多余的空格线
        [_tableView setTableFooterView:[[UIView alloc] initWithFrame:CGRectZero]];
    }
    return _tableView;
}

#pragma mark - UITableViewDataSource && UITableViewDelegate
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    BOOL isSearching = self.searchController.active;
    return [self cj_numberOfSectionsInTableView:tableView isSearching:isSearching];
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    BOOL isSearching = self.searchController.active;
    return [self cj_tableView:tableView numberOfRowsInSection:section isSearching:isSearching];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    BOOL isSearching = self.searchController.active;
    return [self cj_tableView:tableView cellForRowAtIndexPath:indexPath isSearching:isSearching];
}
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    BOOL isSearching = self.searchController.active;
    [self cj_tableView:tableView didSelectRowAtIndexPath:indexPath isSearching:isSearching];
}

//header
- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    return [self cj_tableView:tableView heightForHeaderInSection:section];
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {
    return [self cj_tableView:tableView viewForHeaderInSection:section];
}

//footer
- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section {
    return [self cj_tableView:tableView heightForFooterInSection:section];
}

- (UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section {
    return [self cj_tableView:tableView viewForFooterInSection:section];
}

#pragma mark - 共同的方法
- (NSInteger)cj_numberOfSectionsInTableView:(UITableView *)tableView
                                isSearching:(BOOL)isSearchingTableView
{
    NSArray<CJSectionDataModel *> *sectionDataModels = nil;
    if (!isSearchingTableView) {
        sectionDataModels = self.originSectionDataModels;
    } else {
        sectionDataModels = self.resultSectionDataModels;
    }
    
    NSInteger sectionCount = [sectionDataModels count];
    return sectionCount;
}

- (NSInteger)cj_tableView:(UITableView *)tableView
    numberOfRowsInSection:(NSInteger)section
              isSearching:(BOOL)isSearchingTableView
{
    NSArray<CJSectionDataModel *> *sectionDataModels = nil;
    if (!isSearchingTableView) {
        sectionDataModels = self.originSectionDataModels;
    } else {
        sectionDataModels = self.resultSectionDataModels;
    }
    
    CJSectionDataModel *sectionDataModel = [sectionDataModels objectAtIndex:section];
    return sectionDataModel.values.count;
}


- (UITableViewCell *)cj_tableView:(UITableView *)tableView
            cellForRowAtIndexPath:(NSIndexPath *)indexPath
                      isSearching:(BOOL)isSearchingTableView
{
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"cell" forIndexPath:indexPath];
    /*
    NSArray<CJSectionDataModel *> *sectionDataModels = nil;
    if (!isSearchingTableView) {
        sectionDataModels = self.originSectionDataModels;
    } else {
        sectionDataModels = self.resultSectionDataModels;
    }
    
    CJSectionDataModel *sectionDataModel = [sectionDataModels objectAtIndex:indexPath.section];
    id dataModel = [sectionDataModel.values objectAtIndex:indexPath.row];
    
    [cell configureForDataModel:dataModel]; //是否等同于cell.dataModel，哪个好
    */
    cell.textLabel.text = @"暂时未赋值";
    
    return cell;
}

- (void)cj_tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath isSearching:(BOOL)isSearchingTableView
{
    NSLog(@"点击了%zd-%zd", indexPath.section, indexPath.row);
    //    <#statements#>
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
    /*
    NSArray<CJSectionDataModel *> *sectionDataModels = nil;
    if (!isSearchingTableView) {
        sectionDataModels = self.originSectionDataModels;
    } else {
        sectionDataModels = self.resultSectionDataModels;
    }
    
    CJSectionDataModel *sectionDataModel = [sectionDataModels objectAtIndex:indexPath.section];
    id dataModel = [sectionDataModel.values objectAtIndex:indexPath.row];
    
    NSLog(@"dataModel.name = %@", dataModel.name);
    */
}

- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section {
    BOOL isSearchingTableView = self.searchController.active;
    
    NSArray<CJSectionDataModel *> *sectionDataModels = nil;
    if (!isSearchingTableView) {
        sectionDataModels = self.originSectionDataModels;
    } else {
        sectionDataModels = self.resultSectionDataModels;
    }
    
    CJSectionDataModel *sectionDataModel = [sectionDataModels objectAtIndex:section];
    
    return sectionDataModel.theme;
}

//header
- (CGFloat)cj_tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    return 44;
}

- (UIView *)cj_tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {
    return nil;
}

//footer
- (CGFloat)cj_tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section {
    return 0;
}

- (UIView *)cj_tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section {
    return nil;
}

#pragma mark - addSubView
- (void)cj_makeView:(UIView *)superView addSubView:(UIView *)subView withEdgeInsets:(UIEdgeInsets)edgeInsets {
    [superView addSubview:subView];
    subView.translatesAutoresizingMaskIntoConstraints = NO;
    //left
    [superView addConstraint:[NSLayoutConstraint constraintWithItem:subView
                                                          attribute:NSLayoutAttributeLeft
                                                          relatedBy:NSLayoutRelationEqual
                                                             toItem:superView
                                                          attribute:NSLayoutAttributeLeft
                                                         multiplier:1
                                                           constant:edgeInsets.left]];
    //right
    [superView addConstraint:[NSLayoutConstraint constraintWithItem:subView
                                                          attribute:NSLayoutAttributeRight
                                                          relatedBy:NSLayoutRelationEqual
                                                             toItem:superView
                                                          attribute:NSLayoutAttributeRight
                                                         multiplier:1
                                                           constant:edgeInsets.right]];
    //top
    [superView addConstraint:[NSLayoutConstraint constraintWithItem:subView
                                                          attribute:NSLayoutAttributeTop
                                                          relatedBy:NSLayoutRelationEqual
                                                             toItem:superView
                                                          attribute:NSLayoutAttributeTop
                                                         multiplier:1
                                                           constant:edgeInsets.top]];
    //bottom
    [superView addConstraint:[NSLayoutConstraint constraintWithItem:subView
                                                          attribute:NSLayoutAttributeBottom
                                                          relatedBy:NSLayoutRelationEqual
                                                             toItem:superView
                                                          attribute:NSLayoutAttributeBottom
                                                         multiplier:1
                                                           constant:edgeInsets.bottom]];
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

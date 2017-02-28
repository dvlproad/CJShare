//
//  CJBaseSearchTableViewController.h
//  AllScrollViewDemo
//
//  Created by dvlproad on 2016/11/21.
//  Copyright © 2016年 ciyouzen. All rights reserved.
//

#import "CJBaseSearchViewController.h"

@interface CJBaseSearchTableViewController : CJBaseSearchViewController {
    
}
@property (nonatomic, strong) UITableView *tableView;
@property (nonatomic, assign) BOOL showTableViewSectionHeader;  /**< 是否显示每个section的头(默认YES) */

//以下方法可重写，也可不重写
- (void)cj_setupViews;

- (UITableViewCell *)cj_tableView:(UITableView *)tableView
            cellForRowAtIndexPath:(NSIndexPath *)indexPath
                      isSearching:(BOOL)isSearchingTableView;

- (void)cj_tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath isSearching:(BOOL)isSearchingTableView;

//header
- (CGFloat)cj_tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section;
- (UIView *)cj_tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section;

//footer
- (CGFloat)cj_tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section;
- (UIView *)cj_tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section;

@end

//
//  FileListViewController.m
//  CJShareDemo
//
//  Created by 李超前 on 2016/12/26.
//  Copyright © 2016年 dvlproad. All rights reserved.
//

#import "FileListViewController.h"
#import <CJSortedAndSearchUtil/CJSectionDataModel.h>
#import <PureLayout/PureLayout.h>

#import "CJPreviewController.h"
#import "CJAllPreviewViewController.h"

@interface FileListViewController () {
    
}
@property (nonatomic, strong) CJAllPreviewViewController *previewController;

@end

@implementation FileListViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    self.navigationItem.title = NSLocalizedString(@"我的文档", nil);
    
    self.dataModelSearchSelector = @selector(fileName);
    
    [self.tableView registerClass:[UITableViewCell class] forCellReuseIdentifier:@"cell"];
    
    self.originSectionDataModels = [self getDataFromDB];
}


- (NSMutableArray<CJSectionDataModel *> *)getDataFromDB {
    NSMutableArray *sectionDatas = [[NSMutableArray alloc] init];
    
    NSMutableArray *localFiles = [CJFileFMDBFileManager selectLocalInfos];
    if ([localFiles count] > 0) {
        CJSectionDataModel *sectionDataModel = [[CJSectionDataModel alloc] init];
        sectionDataModel.type = CJFileSourceTypeLocalSandbox;
        sectionDataModel.theme = @"本地文件";
        sectionDataModel.values = localFiles;
        
        [sectionDatas addObject:sectionDataModel];
    }
    
    NSMutableArray *networkFiles = [CJFileFMDBFileManager selectNetworkInfos];
    if ([networkFiles count] > 0) {
        CJSectionDataModel *sectionDataModel = [[CJSectionDataModel alloc] init];
        sectionDataModel.type = CJFileSourceTypeNetwork;
        sectionDataModel.theme = @"网络文件";
        sectionDataModel.values = networkFiles;
        
        [sectionDatas addObject:sectionDataModel];
    }
    
    NSLog(@"sectionDatas = %@", sectionDatas);
    return sectionDatas;
}

//*
#pragma mark - 重写父类方法
- (void)cj_setupViews {
    self.searchController.searchResultsUpdater = self;
    self.searchController.searchBar.delegate = self;
    self.tableView.tableHeaderView = self.searchController.searchBar;
    
    //    UISearchBar *searchBar = self.searchController.searchBar;
    //    [searchBar autoPinEdge:ALEdgeLeft toEdge:ALEdgeLeft ofView:self.view withOffset:0];
    //    [searchBar autoPinEdge:ALEdgeRight toEdge:ALEdgeRight ofView:self.view withOffset:0];
    //    [searchBar autoPinEdge:ALEdgeTop toEdge:ALEdgeTop ofView:self.view withOffset:0];
    //    [searchBar autoPinEdgesToSuperviewEdgesWithInsets:UIEdgeInsetsMake(0, 0, 0, 0) excludingEdge:ALEdgeBottom];
    ////    [searchBar autoSetDimension:ALDimensionHeight toSize:44];
    
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    [self.tableView registerClass:[UITableViewCell class] forCellReuseIdentifier:@"cell"];
    [self.view addSubview:self.tableView];
    
    //[self.tableView autoPinEdge:<#(ALEdge)#> toEdge:<#(ALEdge)#> ofView:<#(nonnull UIView *)#> withOffset:<#(CGFloat)#> relation:<#(NSLayoutRelation)#>];
    [self.tableView autoPinEdge:ALEdgeTop toEdge:ALEdgeTop ofView:self.view withOffset:64];
    [self.tableView autoPinEdge:ALEdgeBottom toEdge:ALEdgeBottom ofView:self.view withOffset:0];
    [self.tableView autoPinEdge:ALEdgeLeft toEdge:ALEdgeLeft ofView:self.view withOffset:0];
    [self.tableView autoPinEdge:ALEdgeRight toEdge:ALEdgeRight ofView:self.view withOffset:0];
    //[self.tableView autoPinEdgesToSuperviewEdgesWithInsets:UIEdgeInsetsMake(0, 0, 0, 0)];
}
//*/
//*
- (UITableViewCell *)cj_tableView:(UITableView *)tableView
            cellForRowAtIndexPath:(NSIndexPath *)indexPath
                      isSearching:(BOOL)isSearchingTableView
{
    NSArray<CJSectionDataModel *> *sectionDataModels = nil;
    if (!isSearchingTableView) {
        sectionDataModels = self.originSectionDataModels;
    } else {
        sectionDataModels = self.resultSectionDataModels;
    }
    
    CJSectionDataModel *sectionDataModel = [sectionDataModels objectAtIndex:indexPath.section];
    FileModel *dataModel = [sectionDataModel.values objectAtIndex:indexPath.row];
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"cell" forIndexPath:indexPath];
    //    [cell configureForDataModel:dataModel]; //是否等同于cell.dataModel，哪个好
    cell.textLabel.text = dataModel.fileName;
    
    return cell;
}

- (void)cj_tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath isSearching:(BOOL)isSearchingTableView
{
    NSLog(@"点击了%ld-%ld", indexPath.section, indexPath.row);
    //    <#statements#>
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
    NSArray<CJSectionDataModel *> *sectionDataModels = nil;
    if (!isSearchingTableView) {
        sectionDataModels = self.originSectionDataModels;
    } else {
        sectionDataModels = self.resultSectionDataModels;
    }
    
    CJSectionDataModel *sectionDataModel = [sectionDataModels objectAtIndex:indexPath.section];
    FileModel *fileModel = [sectionDataModel.values objectAtIndex:indexPath.row];
    
    NSLog(@"fileModel.name = %@", fileModel.fileName);
    
    self.previewFileModel = fileModel;
    
    /*
    CJPreviewController *previewController = [[CJPreviewController alloc] init];
    previewController.fileModels = @[fileModel];
    previewController.currentPreviewItemIndex = 0;
    */
    
    CJAllPreviewViewController *previewController = [[CJAllPreviewViewController alloc] init];
    UIViewController *viewController = [previewController previewFileModels:@[fileModel] andShowItemIndex:0];
    self.previewController = previewController; //强制持有防止,里面的delegate被释放
    
//    [self presentViewController:previewController animated:YES completion:nil];
    [self.navigationController pushViewController:viewController animated:YES];
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

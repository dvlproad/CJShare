//
//  CJSearchUtil.m
//  AllScrollViewDemo
//
//  Created by dvlproad on 2016/06/23.
//  Copyright © 2016年 ciyouzen. All rights reserved.
//

#import "CJSearchUtil.h"
#import "CJDataModelUtil.h"
#import "CJPinyinHelper.h"

@implementation CJSearchUtil

//typedef void (^CJSearchResultsBlock)(NSArray *searchResults);

#pragma mark - 在sectionDataModels中搜索(每个sectionDataModel中的values属性值为dataModels数组)
/** 完整的描述请参见文件头部 */
+ (NSMutableArray *)searchText:(NSString *)searchText
           inSectionDataModels:(NSArray<CJSectionDataModel *> *)sectionDataModels
       dataModelSearchSelector:(SEL)dataModelSearchSelector
                 supportPinyin:(BOOL)supportPinyin
{
    NSMutableArray *resultSectionDataModels = [[NSMutableArray alloc] init];
    
    for (CJSectionDataModel *sectionDataModel in sectionDataModels) {
        NSArray *dataModels = sectionDataModel.values;
        
        NSMutableArray *resultDataModels =
        [CJSearchUtil searchText:searchText
                    inDataModels:dataModels
         dataModelSearchSelector:dataModelSearchSelector
                   supportPinyin:supportPinyin];;
        if (resultDataModels.count > 0) {
            CJSectionDataModel *resultSectionDataModel = [[CJSectionDataModel alloc] init];
            resultSectionDataModel.type = sectionDataModel.type;
            resultSectionDataModel.theme = sectionDataModel.theme;
            resultSectionDataModel.values = resultDataModels;
            
            [resultSectionDataModels addObject:resultSectionDataModel];
        }
    }
    
    return resultSectionDataModels;
}

/** 完整的描述请参见文件头部 */
+ (NSMutableArray *)searchText:(NSString *)searchText
           inSectionDataModels:(NSArray<CJSectionDataModel *> *)sectionDataModels
       dataModelSearchSelector:(SEL)dataModelSearchSelector
andSearchInEveryDataModelMember:(SEL)dataModelMemberSelector
 dataModelMemberSearchSelector:(SEL)dataModelMemberSearchSelector
                 supportPinyin:(BOOL)supportPinyin
{
    NSMutableArray *resultSectionDataModels = [[NSMutableArray alloc] init];
    
    for (CJSectionDataModel *sectionDataModel in sectionDataModels) {
        NSArray *dataModels = sectionDataModel.values;
        
        NSMutableArray *resultDataModels =
        [CJSearchUtil searchText:searchText
                    inDataModels:dataModels
         dataModelSearchSelector:dataModelSearchSelector
 andSearchInEveryDataModelMember:dataModelMemberSelector
   dataModelMemberSearchSelector:dataModelMemberSearchSelector
                   supportPinyin:supportPinyin];
        if (resultDataModels.count > 0) {
            CJSectionDataModel *resultSectionDataModel = [[CJSectionDataModel alloc] init];
            resultSectionDataModel.type = sectionDataModel.type;
            resultSectionDataModel.theme = sectionDataModel.theme;
            resultSectionDataModel.values = resultDataModels;
            
            [resultSectionDataModels addObject:resultSectionDataModel];
        }
    }
    
    return resultSectionDataModels;
}


#pragma mark - 在数组dataModels中搜索
/** 完整的描述请参见文件头部 */
+ (NSMutableArray *)searchText:(NSString *)searchText
                  inDataModels:(NSArray *)dataModels
       dataModelSearchSelector:(SEL)dataModelSearchSelector
                 supportPinyin:(BOOL)supportPinyin
{
    
    NSMutableArray *searchResults = [[NSMutableArray alloc] init];
    if (searchText.length == 0) {
        [searchResults addObjectsFromArray:dataModels];
        
    } else {
        for (id dataModel in dataModels) {
            BOOL isContainSearchText =
            [CJSearchUtil isContainSearchText:searchText
                                  inDataModel:dataModel
                      dataModelSearchSelector:dataModelSearchSelector
                                supportPinyin:supportPinyin];
            if (isContainSearchText) {
                [searchResults addObject:dataModel];
            }
        }
    }
    
    return searchResults;
}

/** 完整的描述请参见文件头部 */
+ (NSMutableArray<NSObject *> *)searchText:(NSString *)searchText
                              inDataModels:(NSArray<NSObject *> *)dataModels
                   dataModelSearchSelector:(SEL)dataModelSearchSelector
           andSearchInEveryDataModelMember:(SEL)dataModelMemberSelector
             dataModelMemberSearchSelector:(SEL)dataModelMemberSearchSelector
                             supportPinyin:(BOOL)supportPinyin
{
    NSMutableArray *resultDataModels = [[NSMutableArray alloc] init];
    for (NSObject *dataModel in dataModels) {
        
        NSObject *resultDataModel = [CJSearchUtil searchText:searchText
                                                 inDataModel:dataModel
                                     dataModelSearchSelector:dataModelSearchSelector
                             andSearchInEveryDataModelMember:dataModelMemberSelector
                               dataModelMemberSearchSelector:dataModelMemberSearchSelector
                                               supportPinyin:supportPinyin];
        if (resultDataModel) {
            [resultDataModels addObject:resultDataModel];
        }
    }
    
    return resultDataModels;
}

#pragma mark - 在dataModel或fromString中搜索
/** 完整的描述请参见文件头部 */
+ (BOOL)isContainSearchText:(NSString *)searchText
                inDataModel:(id)dataModel
    dataModelSearchSelector:(SEL)dataModelSearchSelector
              supportPinyin:(BOOL)supportPinyin
{
    NSString *dataModelSearchSelectorString = [CJDataModelUtil stringValueForDataSelector:dataModelSearchSelector inDataModel:dataModel];
    
    //搜索判断
    BOOL isContainSearchText = [self isContainSearchText:searchText
                                              fromString:dataModelSearchSelectorString
                                           supportPinyin:supportPinyin];
    
    return isContainSearchText;
}

/** 完整的描述请参见文件头部 */
+ (NSObject *)searchText:(NSString *)searchText
             inDataModel:(NSObject *)dataModel
 dataModelSearchSelector:(SEL)dataModelSearchSelector
andSearchInEveryDataModelMember:(SEL)dataModelMemberSelector
dataModelMemberSearchSelector:(SEL)dataModelMemberSearchSelector
           supportPinyin:(BOOL)supportPinyin
{
    
    dataModel.isSearchResult = YES;
    dataModel.isContainInSelf = NO;
    dataModel.isContainInMembers = NO;
    
    
    NSString *dataModelSearchSelectorString = [CJDataModelUtil stringValueForDataSelector:dataModelSearchSelector inDataModel:dataModel];
    
    //搜索判断
    BOOL isContainInSelf = [self isContainSearchText:searchText
                                          fromString:dataModelSearchSelectorString
                                       supportPinyin:supportPinyin];
    dataModel.isContainInSelf = isContainInSelf;
    
    //包含:xx、xx
    NSArray *members = [CJDataModelUtil arrayValueForDataSelector:dataModelMemberSelector inDataModel:dataModel];
    NSMutableArray *resultMembers =
    [CJSearchUtil searchText:searchText
                inDataModels:members
     dataModelSearchSelector:dataModelMemberSearchSelector
               supportPinyin:supportPinyin];
    dataModel.containMembers = resultMembers;
    dataModel.isContainInMembers = resultMembers.count ? YES : NO;
    
    if (dataModel.isContainInSelf || dataModel.isContainInMembers) {
        return dataModel;
        
    } else {
        return nil;
    }
}


/** 完整的描述请参见文件头部 */
+ (BOOL)isContainSearchText:(NSString *)searchText
                 fromString:(NSString *)fromString
              supportPinyin:(BOOL)supportPinyin {
    if (searchText == nil || fromString == nil) {
        return NO;
    }
    
    if (searchText.length == 0) {
        return YES;
    }
    
//    if (!searchText || !fromString || (fromString.length == 0 && searchText.length != 0)) {
//        return NO;
//    }
    
    NSString *searchSourceString = [fromString lowercaseString];
    NSString *searchTextString = [searchText lowercaseString];
    NSUInteger location = [searchSourceString rangeOfString:searchTextString].location;
    
    //搜索判断
    BOOL isContainSearchText = NO;
    if (location != NSNotFound) {
        isContainSearchText = YES;
    } else {
        if (supportPinyin) {
            NSString *searchSourceStringPinyin = [CJPinyinHelper pinyinFromChineseString:searchSourceString];
            searchSourceStringPinyin = [searchSourceStringPinyin lowercaseString];//保证大小写一致
            //NSLog(@"pinyin = %@, searchText = %@", searchSourceStringPinyin, searchTextString);
            
            location = [searchSourceStringPinyin rangeOfString:searchTextString].location;
            if(location != NSNotFound) {
                isContainSearchText = YES;
            }
        }
    }
    
    return isContainSearchText;
}







/* //去重、来自哪
+ (void)deal {
    NSMutableArray *allResultDataModelMembers = [[NSMutableArray alloc] init];
    for (CJSectionDataModel *resultSectionDataModel in resultSectionDataModels) {
        NSMutableArray *resultDataModels = resultSectionDataModel.values;
        for (NSObject *resultDataModel in resultDataModels) {
            [allResultDataModelMembers addObjectsFromArray:resultDataModel.containMembers];
        }
    }
    
    // 对搜索到的成员allResultDataModelContainMembers进行去重
    NSMutableArray *userIds = [[NSMutableArray alloc] init];
    NSMutableArray *userInfos = [[NSMutableArray alloc] init];
    for (id member in allResultDataModelMembers) {
        NSString *uniqueIdString = [CJDataModelUtil stringValueForDataSelector:dataModelMemberUniqueId inDataModel:member];
        
        if (![userIds containsObject:uniqueIdString]) {
            [userIds addObject:uniqueIdString];
            [userInfos addObject:member];
            
        } else {
            NSInteger oldUserInfoIndex = [userIds indexOfObject:uniqueIdString];
            id oldMember = [userInfos objectAtIndex:oldUserInfoIndex];
            
            //来自：xx、xx
            NSString *comeFrom = @"";
            NSString *memberSelectorString = [CJDataModelUtil stringValueForDataSelector:dataModelMemberSelector inDataModel:member];
            
            NSString *oldMemberSelectorString = [CJDataModelUtil stringValueForDataSelector:dataModelMemberSelector inDataModel:oldMember];
            
            NSString *appendingString = [NSString stringWithFormat:@"、%@", oldMemberSelectorString];
            memberSelectorString = [memberSelectorString stringByAppendingString:appendingString];
            
            [userInfos replaceObjectAtIndex:oldUserInfoIndex withObject:member];
        }
    }
    
    return resultSectionDataModels;
}
*/


@end

//
//  CJDataModelUtil.h
//  AllScrollViewDemo
//
//  Created by dvlproad on 2016/06/23.
//  Copyright © 2016年 ciyouzen. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface CJDataModelUtil : NSObject

+ (NSString *)stringValueForDataSelector:(SEL)dataSelector inDataModel:(id)dataModel;
+ (NSArray *)arrayValueForDataSelector:(SEL)dataSelector inDataModel:(id)dataModel;

@end

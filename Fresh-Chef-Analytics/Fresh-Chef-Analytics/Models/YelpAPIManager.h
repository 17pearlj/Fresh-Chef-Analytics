//
//  YelpAPIManager.h
//  Fresh-Chef-Analytics
//
//  Created by jpearl on 7/22/19.
//  Copyright © 2019 julia@ipearl.net. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface YelpAPIManager : NSObject
+ (instancetype) shared;
-(void)locationTopRatings:(NSString*)location withCategory:(nullable NSString *)category withPrice:(nullable NSString *)price;

@end

NS_ASSUME_NONNULL_END

//
//  OpenOrderButton.h
//  Fresh-Chef-Analytics
//
//  Created by jpearl on 7/25/19.
//  Copyright © 2019 julia@ipearl.net. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "OpenOrder.h"

NS_ASSUME_NONNULL_BEGIN

@interface OpenOrderButton : UIButton
@property (strong, nonatomic) NSArray <OpenOrder *>* openOrders;
@end

NS_ASSUME_NONNULL_END

//
//  ComfortableFormViewController.h
//  Fresh-Chef-Analytics
//
//  Created by jpearl on 7/16/19.
//  Copyright © 2019 julia@ipearl.net. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "order.h"
#import "Waiter.h"
#import "ComfortableTableViewCell.h"
#import "WaiterManager.h"
#import "UITextView+Placeholder.h"
#import "OpenOrder.h"

NS_ASSUME_NONNULL_BEGIN

@interface ComfortableFormViewController : UIViewController
- (IBAction)didSubmit:(UIButton *)sender;
@property (strong, nonatomic) NSMutableArray <order *>*customerOrder;
@property (strong, nonatomic) OpenOrder *openOrder;
@property (strong, nonatomic) NSString *customerNumber;
@property (strong, nonatomic) NSArray<OpenOrder *>*openOrders;


@end

NS_ASSUME_NONNULL_END

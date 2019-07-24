//
//  ClosedOrder.m
//  Fresh-Chef-Analytics
//
//  Created by selinons on 7/24/19.
//  Copyright © 2019 julia@ipearl.net. All rights reserved.
//

#import "ClosedOrder.h"

@implementation ClosedOrder

@dynamic orders;
@dynamic waiter;
@dynamic restaurant;

+ (nonnull NSString *)parseClassName {
    return @"ClosedOrder";
}
+ (void) postNewOrder: (NSArray *) order withRestaurant : (PFUser *) restaurant withWaiter : (Waiter *) waiter withCompletion : (PFBooleanResultBlock  _Nullable)completion
{
    ClosedOrder *newOrder = [ClosedOrder new];
    newOrder.restaurant = restaurant;
    newOrder.orders = order;
    newOrder.waiter = waiter;
    [newOrder saveInBackgroundWithBlock:completion];
}
@end


//  OrderManager.m
//  Fresh-Chef-Analytics
//
//  Created by selinons on 7/24/19.
//  Copyright © 2019 julia@ipearl.net. All rights reserved.
//

#import "OrderManager.h"

@implementation OrderManager
// singleton generates a single instance and initiates itself
+ (instancetype)shared {
    static OrderManager *sharedManager = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        sharedManager = [[self alloc] init];
    });
    return sharedManager;
}

- (void) fetchOpenOrderItems:(PFUser *) restaurant  withCompletion:(void (^)(NSArray * openOrders, NSError * error))fetchedOpenOrders
{
    PFQuery *openOrderQuery;
    openOrderQuery = [OpenOrder query];
    [openOrderQuery whereKey:@"restaurantId" equalTo:restaurant.objectId];
    [openOrderQuery findObjectsInBackgroundWithBlock:^(NSArray * openOrders, NSError * error) {
        if (!error)
        {
            self.allOpenOrders = openOrders;
            [self sortOrdersByTable];
            fetchedOpenOrders(self.allOpenOrders, nil);
        }
    }];
}
- (void) sortOrdersByTable
{
    self.openOrdersByTable = [[NSMutableDictionary alloc] init];
    NSArray *ordersByTable;
    for (OpenOrder *order in self.allOpenOrders)
    {
        [self addOrderToDict:order toArray:ordersByTable];
    }
}
- (void) addOrderToDict : (OpenOrder *) order toArray : (NSArray *) ordersOfTable
{
    NSString *table = [order.table stringValue];
    if (self.openOrdersByTable[table] != nil)
    {
        ordersOfTable = self.openOrdersByTable[table];
        ordersOfTable = [ordersOfTable arrayByAddingObject:order];
    }
    else
    {
        ordersOfTable = [NSArray arrayWithObject:order];
    }
    [self.openOrdersByTable setObject:ordersOfTable forKey:table];
}
- (void) fetchClosedOrderItems:(PFUser *) restaurant  withCompletion:(void (^)(NSArray * closedOrders, NSError * error))fetchedClosedOrders
{
    PFQuery *closedOrderQuery;
    closedOrderQuery = [ClosedOrder query];
    [closedOrderQuery whereKey:@"restaurantId" equalTo:restaurant.objectId];
    [closedOrderQuery findObjectsInBackgroundWithBlock:^(NSArray * closedOrders, NSError * error) {
        if (!error)
        {
            self.closedOrders = closedOrders;
            fetchedClosedOrders(self.closedOrders, nil);
        }
    }];
}

//- (void) fetchOrdersToClose : (PFUser * ) restaurant withTable : (NSNumber *) table forWaiter : (Waiter *) waiter withCompletion : (void (^)(NSArray *orders, NSError * error))completion
//{
//
//    PFQuery *orderQuery;
//    orderQuery = [OpenOrder query];
//    [orderQuery whereKey:@"restaurantId" equalTo:restaurant.objectId];
//    //[orderQuery includeKey:@"dish"];
//    //    [orderQuery whereKey:@"table" equalTo:table];
//    [orderQuery findObjectsInBackgroundWithBlock:^(NSArray *_Nullable orders, NSError * _Nullable error) {
//        if (orders)
//        {
//            self.ordersToDelete = orders;
//
//            completion(orders, nil);
//
//        }
//        else
//        {
//            NSLog(@"Error: %@", error.localizedDescription);
//            completion(nil, error);
//        }
//    }];
//
//}
- (void) fetchDishInOrdersToClose : (OpenOrder *) temp withCompletion : (void (^)(NSArray * dishes, NSError * error))completion
{
    PFQuery *dishQuery;
    dishQuery = [Dish query];
    [dishQuery whereKey:@"objectId" equalTo:temp.dish.objectId];
    [dishQuery findObjectsInBackgroundWithBlock:^(NSArray * _Nullable objects, NSError * _Nullable error) {
        if (!error)
        {
            completion(objects, nil);
        }
        else
        {
            NSLog(@"Error: %@", error.localizedDescription);
            completion(nil, error);
        }
    }];
    completion(nil, nil);

}
- (void) deletingOrderswithTable : (NSNumber *) table forWaiter : (Waiter *) waiter withCustomerNum : (NSNumber *) customerNum withCompletion : (void (^)(NSError * error))completion
{
    ClosedOrder *newAddition = [ClosedOrder new];
    newAddition.restaurant = PFUser.currentUser;
    newAddition.table = table;
    newAddition.numCustomers = customerNum;

    __block int doneWithArray = 0;
    __block NSString *dishName;
    __block NSNumber *dishAmount;

    NSArray *ordersToClose = self.openOrdersByTable[[table stringValue]];
    for (int i = 0; i < [ordersToClose count]; i++)
    {
        OpenOrder *temp = ordersToClose[i];
        [self fetchDishInOrdersToClose:temp withCompletion:^(NSArray *dishes, NSError *error) {
            if (dishes)
            {
                Dish * tempDish = dishes[0];
                dishName = tempDish.name;
                dishAmount = temp.amount;
                [ordersToClose[i] deleteInBackgroundWithBlock:^(BOOL succeeded, NSError * _Nullable error) {
                    if (succeeded)
                    {
                        NSLog(@"Order removed");
                        [newAddition addObject:dishName forKey:@"dishes"];
                        [newAddition addObject:dishAmount forKey:@"amounts"];
                        doneWithArray++;
                        if (doneWithArray >= [ordersToClose count])
                        {
                            [newAddition saveInBackgroundWithBlock:^(BOOL succeeded, NSError * _Nullable error) {
                                NSLog(@"executing something?");
                                if (!error)
                                {
                                    NSLog(@"Closed order saved");
                                    [self fetchOpenOrderItems:PFUser.currentUser
                                               withCompletion:^(NSArray * _Nonnull openOrders, NSError * _Nonnull error) {
                                        if (succeeded)
                                        {
                                            NSLog(@"Updated open orders");
                                            [self fetchClosedOrderItems:PFUser.currentUser withCompletion:^(NSArray * _Nonnull closedOrders, NSError * _Nonnull error) {
                                                if (!error)
                                                {
                                                    self.closedOrders = closedOrders;
                                                    NSLog(@"Updated closed orders");
                                                    completion(nil);
                                                }
                                                else
                                                {
                                                    completion(error);
                                                }
                                            }];
                                        }
                                        else
                                        {
                                            completion(error);
                                        }
                                    }];
                                }
                                else
                                {
                                    completion(error);
                                }
                            }];
                        }
                    }
                    else
                    {
                        NSLog(@"Error: %@", error.localizedDescription);
                        completion(error);
                    }
                }];
            }
        }];
    }
    completion(nil);
}

@end
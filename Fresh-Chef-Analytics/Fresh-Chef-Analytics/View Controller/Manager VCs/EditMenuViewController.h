//
//  EditMenuViewController.h
//  Fresh-Chef-Analytics
//
//  Created by jpearl on 7/16/19.
//  Copyright © 2019 julia@ipearl.net. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Dish.h"
#import "MenuManager.h"
#import "EditMenuCell.h"

NS_ASSUME_NONNULL_BEGIN

@interface EditMenuViewController : UIViewController <EditMenuCellDelegate, UITableViewDelegate, UITableViewDataSource, UINavigationControllerDelegate>



@end

NS_ASSUME_NONNULL_END

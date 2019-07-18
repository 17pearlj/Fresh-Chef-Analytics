//
//  FunFormViewController.m
//  Fresh-Chef-Analytics
//
//  Created by jpearl on 7/16/19.
//  Copyright © 2019 julia@ipearl.net. All rights reserved.
//

#import "FunFormViewController.h"

@interface FunFormViewController () <UITableViewDelegate, UITableViewDataSource>
@property (weak, nonatomic) IBOutlet UITableView *menuRatings;

@end

@implementation FunFormViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.menuRatings.delegate = self;
    self.menuRatings.dataSource = self;
    // Do any additional setup after loading the view.
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.customerOrder.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    FunTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier: @"Fun"];
    order *order = self.customerOrder[indexPath.row];
    cell.dish = order.dish;
    cell.dishName.text = order.dish.name;
    cell.dishType.text = order.dish.type;
    cell.dishDescription.text = order.dish.dishDescription;
    cell.amount.text = [NSString stringWithFormat:@"%.0f", order.amount];
    cell.image = nil;
    
//
//    @property (strong, nonatomic) Dish *dish;
//    @property (weak, nonatomic) IBOutlet UILabel *dishName;
//    @property (weak, nonatomic) IBOutlet UILabel *dishType;
//    @property (weak, nonatomic) IBOutlet UILabel *dishDescription;
//    @property (weak, nonatomic) IBOutlet UIImageView *image;
//    @property (weak, nonatomic) IBOutlet UILabel *amount;
//    cell.type.text = dish.type;
//    cell.stepper.dish = dish;
//    cell.stepper.value = [self searchForAmount:self.customerOrder withDish:dish];
//    cell.dishDescription.text = dish.dishDescription;
//    PFFileObject *dishImageFile = (PFFileObject *)dish.image;
//    [dishImageFile getDataInBackgroundWithBlock:^(NSData *imageData, NSError *error) {
//        if(!error){
//            cell.image.image = [UIImage imageWithData:imageData];
//        }
//    }];
//    cell.amount.text = [NSString stringWithFormat:@"%.0f", cell.stepper.value];
    return cell;
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

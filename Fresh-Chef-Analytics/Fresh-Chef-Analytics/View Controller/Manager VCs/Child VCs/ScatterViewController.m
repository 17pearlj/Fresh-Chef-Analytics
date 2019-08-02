//
//  ScatterViewController.m
//  Fresh-Chef-Analytics
//
//  Created by selinons on 7/22/19.
//  Copyright © 2019 julia@ipearl.net. All rights reserved.
//

#import "ScatterViewController.h"

@interface ScatterViewController ()
@property (weak, nonatomic) IBOutlet UIView *dataView;
@property (strong, nonatomic) NSMutableDictionary *categoriesOfDishes;
@property (strong, nonatomic) PNScatterChart *scatterChart;
@property (strong, nonatomic) NSArray *legend;
@property (strong, nonatomic) Dish *selectedDish;
@property (strong, nonatomic) NSArray *colorsFromUI;
@property (strong, nonatomic) NSArray *dataArray;
@property (strong, nonatomic) PNScatterChartData *shownDish;
@property (weak, nonatomic) IBOutlet UIButton *arrowButton1;
@property (strong, nonatomic) CAShapeLayer *square;
@property (weak, nonatomic) IBOutlet UIButton *arrowButton2;
@property (assign, nonatomic) __block double arrowMult;
@property (weak, nonatomic) IBOutlet UILabel *freqLabel;
@property (weak, nonatomic) IBOutlet UILabel *dishFreqLabel;
@property (weak, nonatomic) IBOutlet UILabel *dishRatingLabel;

@end

@implementation ScatterViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.square = [CAShapeLayer layer];
    [self.scatterChart.layer addSublayer:self.square];
    self.dishesTableView.delegate = self;
    self.dishesTableView.dataSource = self;
    self.categoriesOfDishes = [[MenuManager shared] categoriesOfDishes];
    self.legend = [[[MenuManager shared] categoriesOfDishes] allKeys];
    self.dataArray = [self populateDataByRatingAndFreq];
    self.colorsFromUI = @[@"#6b48ff", @"#ff6337", @"#b31e6f", @"#00bdaa", @"#58b368", @"#ff487e", @"#226b80", @"52437b"];
    self.arrowButton1.imageView.layer.cornerRadius = 0.5 * self.arrowButton1.imageView.bounds.size.height;
    self.arrowButton2.imageView.layer.cornerRadius = 0.5 * self.arrowButton2.imageView.bounds.size.height;

    [self.arrowButton2 setTransform: CGAffineTransformRotate([self.arrowButton2 transform], M_PI/2)];
    [self.arrowButton1 setTransform: CGAffineTransformRotate([self.arrowButton1 transform], M_PI/2)];
    self.arrowMult = -1;
    //[self.freqLabel.layer setAnchorPoint:CGPointMake(1.0, 1.0)];
    [self.freqLabel setTransform:CGAffineTransformMakeTranslation(-30, 30)];

    [self.freqLabel setTransform:CGAffineTransformRotate([self.freqLabel transform], -M_PI/2)];
    //For Scatter Chart
    self.scatterChart = [[PNScatterChart alloc] initWithFrame:CGRectMake(0, 0, self.dataView.bounds.size.width, self.dataView.bounds.size.height)];
    [self.scatterChart setAxisXWithMinimumValue:0 andMaxValue:10 toTicks:11];
    
    [self.scatterChart setAxisYWithMinimumValue:0 andMaxValue:50 toTicks:11];
    NSMutableArray <PNScatterChartData*> *categoryScatter = [[NSMutableArray alloc] init];
    
    //initialize data point
    self.shownDish = [PNScatterChartData new];
    self.shownDish.fillColor = [UIColor colorWithWhite:0.0 alpha:0.0];
    self.shownDish.size = 15;
    self.shownDish.itemCount = 1;
    self.shownDish.inflexionPointStyle = PNScatterChartPointStyleSquare;
    
    for (int i = 0; i < self.legend.count; i ++)
    {
        categoryScatter[i] = [PNScatterChartData new];
        categoryScatter[i].fillColor = [[Helpful_funs shared] colorFromHexString:self.colorsFromUI[i]];
        categoryScatter[i].size = 5;
        categoryScatter[i].itemCount = [[self.dataArray[i] objectAtIndex:0] count];
        categoryScatter[i].inflexionPointStyle = PNScatterChartPointStyleCircle;
        __block NSMutableArray *XAr1 = [NSMutableArray arrayWithArray:[self.dataArray[i] objectAtIndex:1]];
        __block NSMutableArray *YAr1 = [NSMutableArray arrayWithArray:[self.dataArray[i]
                                                                       objectAtIndex:2]];
        categoryScatter[i].getData = ^(NSUInteger index) {
            CGFloat xValue = [[XAr1 objectAtIndex:index] floatValue];
            CGFloat yValue = [[YAr1 objectAtIndex:index] floatValue];
            return [PNScatterChartDataItem dataItemWithX:xValue AndWithY:yValue];

        };
        [self.scatterChart setup];
        
        self.scatterChart.chartData = @[categoryScatter[i]];
        
    }

    self.scatterChart.delegate = self;
    
    [self.dataView addSubview:self.scatterChart];
    
}
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return self.categoriesOfDishes.count;
}
- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section
{
    return self.legend[section];
}
- (NSInteger)tableView:(nonnull UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return [self.categoriesOfDishes[self.legend[section]] count];
}
//- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
//{
//    UIView *headerView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, tableView.bounds.size.width, 30)];
//    [headerView setBackgroundColor:self.colorsFromUI[section]];
//    return headerView;
//}
- (void)tableView:(UITableView *)tableView willDisplayHeaderView:(UIView *)view forSection:(NSInteger)section
{
    UITableViewHeaderFooterView *header = (UITableViewHeaderFooterView *)view;
    [header.textLabel setTextColor: [[Helpful_funs shared] colorFromHexString:self.colorsFromUI[section]]];
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSInteger section = indexPath.section;
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"SimpleTableItem"];
    Dish *dish = self.categoriesOfDishes[self.legend[section]][indexPath.row];
    if (cell == nil){
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"SimpleTableItem"];
    }
    cell.textLabel.text = dish.name;
    return cell;

}
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSInteger section = indexPath.section;
    UITableViewCell *cell = [self.dishesTableView cellForRowAtIndexPath:indexPath];
    self.shownDish.fillColor = [UIColor colorWithWhite:0.0 alpha:0.0];
    UIColor *colorForDish = [[Helpful_funs shared] colorFromHexString:self.colorsFromUI[section]];
    [self.chooseDishButton setTitle:cell.textLabel.text forState:UIControlStateNormal];
   Dish *dish = self.categoriesOfDishes[self.legend[indexPath.section]][indexPath.row];
    self.dishFreqLabel.text = [[NSString stringWithFormat:@"%@", dish.orderFrequency] stringByAppendingString:@" orders"];
    [self.dishFreqLabel setTextColor:colorForDish];
    [self.dishRatingLabel setTextColor:colorForDish];
    self.dishRatingLabel.text = [[NSString stringWithFormat:@"%@", [[MenuManager shared] averageRating:dish]] stringByAppendingString:@" Stars"];
    [self.chooseDishButton setTitleColor:colorForDish
                                forState:UIControlStateNormal];
    self.selectedDish = self.categoriesOfDishes[self.legend[section]][indexPath.row];
    NSUInteger positionOfDish = [self.dataArray[section][0] indexOfObject:self.selectedDish.name];
    self.shownDish.getData = ^(NSUInteger index) {
        CGFloat xValue = [self.dataArray[section][1][positionOfDish] floatValue];
        CGFloat yValue = [self.dataArray[section][2][positionOfDish] floatValue];
        return [PNScatterChartDataItem dataItemWithX:xValue AndWithY:yValue];
    };
    self.shownDish.fillColor = [[Helpful_funs shared] colorFromHexString:self.colorsFromUI[section]];
    self.shownDish.strokeColor = [UIColor blackColor];
    [self.scatterChart changePointInGraph:self.shownDish forShape:self.square];
    [self.scatterChart.layer addSublayer:self.square];
//    self.scatterChart.layer.opacity = 1;
    [self.arrowButton1 setTransform:CGAffineTransformRotate([self.arrowButton1 transform], (self.arrowMult * M_PI))];
    [self.arrowButton2 setTransform:CGAffineTransformRotate([self.arrowButton2 transform], (self.arrowMult * M_PI))];
    self.arrowMult *= -1;
    self.dishesTableView.hidden = YES;
    
}
- (NSArray *)populateDataByRatingAndFreq
{
    NSMutableArray *theData = [NSMutableArray array];
    for (NSString *category in self.legend)
    {
        NSMutableArray *categoryData = [NSMutableArray array];
        NSArray *temp = self.categoriesOfDishes[category];
        NSMutableArray *theseRatings = [NSMutableArray array];
        NSMutableArray *theseFreqs = [NSMutableArray array];
        NSMutableArray *theseNames = [NSMutableArray array];
        for (Dish *dish in temp)
        {
            NSNumber *rating = [[MenuManager shared] averageRating:dish];
            [theseRatings addObject:rating];
            [theseFreqs addObject:dish.orderFrequency];
            [theseNames addObject:dish.name];
        }
        [categoryData addObject:theseNames];
        [categoryData addObject:theseRatings];
        [categoryData addObject:theseFreqs];
        [theData addObject:categoryData];
    }
    
    return theData;
}
- (IBAction)chooseDish:(id)sender {
    [self.arrowButton1 setTransform:CGAffineTransformRotate([self.arrowButton1 transform], (self.arrowMult * M_PI))];
    [self.arrowButton2 setTransform:CGAffineTransformRotate([self.arrowButton2 transform], (self.arrowMult * M_PI))];
    self.arrowMult *= -1;
    self.dishesTableView.hidden = !(self.dishesTableView.hidden);
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

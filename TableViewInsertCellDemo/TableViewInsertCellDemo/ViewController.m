//
//  ViewController.m
//  TableViewInsertCellDemo
//
//  Created by Wayne on 5/27/14.
//  Copyright (c) 2014 Wayne. All rights reserved.
//

#import "ViewController.h"
#import "MyCell.h"
#import "FilterConditionCell.h"
#import "ExpendAnalyze.h"
#import "ChartCell.h"
#import "CustomCellTest.h"
#import "AccountOverviewChart.h"

#define isFilterCell indexPath.section == 0 && indexPath.row == 0
#define isChartCell indexPath.section == 1 && indexPath.row == 0
#define UIColorFromRGB(rgbValue) [UIColor colorWithRed:((float)((rgbValue & 0xFF0000) >> 16))/255.0 green:((float)((rgbValue & 0xFF00) >> 8))/255.0 blue:((float)(rgbValue & 0xFF))/255.0 alpha:1.0]

typedef enum cellState{
    OPEN = 98,
    CLOSE
}CellState;

@interface ViewController ()

@property (strong, nonatomic) NSMutableArray *dataArray;
@property (strong, nonatomic) UITableViewCell *myCell;
@property (strong, nonatomic) FilterConditionCell *filterCell;
@property (strong, nonatomic) FilterConditionCell *chartLabelCell;
@property (strong, nonatomic) ChartCell *pieChartCell;
@property (strong, nonatomic) ExpendAnalyze *pieChart;
@property (strong, nonatomic) MyCell *myCustomCell;

@end

@implementation ViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view, typically from a nib.
    NSMutableArray *firstElement = [NSMutableArray arrayWithObjects:@"filter", nil];
    NSMutableArray *chartElement = [NSMutableArray arrayWithObjects:@"chart", nil];
    self.dataArray = [NSMutableArray arrayWithObjects:
                    firstElement,
                      chartElement,
                      @[@"one", @"two"], nil];
    self.myTableView.delegate = self;
    self.myTableView.dataSource = self;
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 3;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return [self.dataArray[section] count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    if (indexPath.section == 0) {
        if (indexPath.row == 0) {
           static NSString *filterLabelIdentifier = @"filterCell";
           self.filterCell = [tableView dequeueReusableCellWithIdentifier:filterLabelIdentifier];
           if (!self.filterCell) {
               self.filterCell = (FilterConditionCell *)[self getCustomCellByName:@"FilterConditionCell"];
               self.filterCell.tag = CLOSE;
           }
            self.filterCell.buttonLabel.layer.masksToBounds = YES;
            self.filterCell.buttonLabel.layer.cornerRadius = 10.0;
            self.filterCell.selectionStyle = UITableViewCellSelectionStyleNone;
            self.filterCell.titleLabel.text = @"篩選條件";
            [self.filterCell.buttonLabel setBackgroundColor:UIColorFromRGB(0x009966)];
            return self.filterCell;
        } else {
            static NSString *filterContentIdentifier = @"myCell";
            self.myCustomCell = (MyCell *)[tableView dequeueReusableCellWithIdentifier:filterContentIdentifier];
            if (!self.myCustomCell) {
                NSArray *views = [[NSBundle mainBundle] loadNibNamed:@"MyCell" owner:nil options:nil];
                for (UIView *view in views){
                   if ([view isKindOfClass:[MyCell class]]) {
                       self.myCustomCell = (MyCell *)view;
                   }
                }
            }
            self.myCustomCell.backgroundImage.hidden = NO;
                return self.myCustomCell;
        }
    } else if (indexPath.section == 1) {
        if (indexPath.row == 0) {
            static NSString *chartLabelIdentifier = @"filterCell";
            self.chartLabelCell = [tableView dequeueReusableCellWithIdentifier:chartLabelIdentifier];
            if (!self.chartLabelCell) {
                self.chartLabelCell = (FilterConditionCell *)[self getCustomCellByName:@"FilterConditionCell"];
                self.chartLabelCell.tag = CLOSE;
            }
            self.chartLabelCell.buttonLabel.layer.masksToBounds = YES;
            self.chartLabelCell.buttonLabel.layer.cornerRadius = 10.0;
            self.chartLabelCell.selectionStyle = UITableViewCellSelectionStyleNone;
            self.chartLabelCell.titleLabel.text = @"支出類型分析";
            [self.chartLabelCell.buttonLabel setBackgroundColor:UIColorFromRGB(0x009966)];
            return self.chartLabelCell;
        } else {
            static NSString *chartCellIdentifier = @"chartCell";
            self.pieChartCell = [tableView dequeueReusableCellWithIdentifier:chartCellIdentifier];
            if (!self.pieChartCell) {
                
                self.pieChartCell = (ChartCell *)[self getCustomCellByName:@"ChartCell"];
                [self setupPieChartWithRect:[self.pieChartCell frame]];
                [self.pieChartCell addSubview:self.pieChart];
            }
            NSLog(@"%.2f,%.2f",[self.pieChart frame].size.height, [self.pieChart bounds].size.width);
            return self.pieChartCell;
        }
    } else if (indexPath.section == 2) {
        static NSString *identifier2 = @"cell2";
        UITableViewCell *cell2 = [tableView dequeueReusableCellWithIdentifier:identifier2];
        if (!cell2) {
            cell2 = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:identifier2];
        }
        cell2.textLabel.text = [self.dataArray[indexPath.section] objectAtIndex:indexPath.row];
        return cell2;
    } else {
        return nil;
    }
}

- (id)getCustomCellByName:(NSString *)name{
    NSArray *views = [[NSBundle mainBundle] loadNibNamed:name owner:nil options:nil];
    Class customClass = NSClassFromString(name);
    UIView *view;
    for(view in views){
        if([view isKindOfClass:[customClass class]]){
            break;
        }
    }
    return view;
}

- (void)setupPieChartWithRect:(CGRect)rect{
    self.pieChart = [[ExpendAnalyze alloc] initWithFrame:rect];
    NSMutableArray *tempArray = [NSMutableArray array];
    for (int i = 0; i < 3; i++) {
        int randomValue = arc4random() % 10000;
        [tempArray addObject:[NSDecimalNumber decimalNumberWithString:[NSString stringWithFormat:@"%d", randomValue]]];
    }
    [self.pieChart setPieChartData:tempArray andColors:@[[UIColor blueColor],
                                                         [UIColor redColor],
                                                         [UIColor orangeColor]]];
    [self.pieChart initPlot];
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    if (isFilterCell) {
        if (self.filterCell.tag == CLOSE) {
            [self.myTableView beginUpdates];
            NSMutableArray *indexes = [NSMutableArray array];
            NSInteger indexCount = [self.dataArray[0] count];
            for (NSInteger i = indexCount; i < indexCount+1 ; i++) {
                [indexes addObject:[NSIndexPath indexPathForRow:i inSection:0]];
                [self.dataArray[0] addObject:[NSString stringWithFormat:@"%d",i+1]];
            }
            [self.filterCell.buttonLabel setBackgroundColor:[UIColor grayColor]];
            self.filterCell.buttonText.text = @"收合";
            self.filterCell.tag = OPEN;
            [self.myTableView insertRowsAtIndexPaths:indexes withRowAnimation:UITableViewRowAnimationMiddle];
            [self.myTableView endUpdates];
        } else if (self.filterCell.tag == OPEN) {
            [self.myTableView beginUpdates];
            NSMutableArray *indexes = [NSMutableArray array];
            NSInteger indexToDelete = [self.dataArray[0] count] - 1;
            [indexes addObject:[NSIndexPath indexPathForRow:indexToDelete inSection:0]];
            [self.dataArray[0] removeLastObject];
            [self.filterCell.buttonLabel setBackgroundColor:UIColorFromRGB(0x009966)];
//            self.myCustomCell.backgroundImage.hidden = YES;
            self.filterCell.buttonText.text = @"展開";
            self.filterCell.tag = CLOSE;
            [self.myTableView deleteRowsAtIndexPaths:indexes withRowAnimation:UITableViewRowAnimationMiddle];
            [self.myTableView endUpdates];
        }
    } else if (isChartCell) {
        if (self.chartLabelCell.tag == CLOSE) {
            [self.myTableView beginUpdates];
            NSMutableArray *indexes = [NSMutableArray array];
            NSInteger indexCount = [self.dataArray[1] count];
            for (NSInteger i = indexCount; i < indexCount+1 ; i++) {
                [indexes addObject:[NSIndexPath indexPathForRow:i inSection:1]];
                [self.dataArray[1] addObject:[NSString stringWithFormat:@"%d",i+1]];
            }
            [self.chartLabelCell.buttonLabel setBackgroundColor:[UIColor grayColor]];
            self.chartLabelCell.buttonText.text = @"收合";
            self.chartLabelCell.tag = OPEN;
            [self.myTableView insertRowsAtIndexPaths:indexes withRowAnimation:UITableViewRowAnimationMiddle];
            [self.myTableView endUpdates];
        } else if (self.chartLabelCell.tag == OPEN) {
            [self.myTableView beginUpdates];
            NSMutableArray *indexes = [NSMutableArray array];
            NSInteger indexToDelete = [self.dataArray[1] count] - 1;
            [indexes addObject:[NSIndexPath indexPathForRow:indexToDelete inSection:1]];
            [self.dataArray[1] removeLastObject];
            [self.chartLabelCell.buttonLabel setBackgroundColor:UIColorFromRGB(0x009966)];
            self.chartLabelCell.buttonText.text = @"展開";
            self.chartLabelCell.tag = CLOSE;
            [self.myTableView deleteRowsAtIndexPaths:indexes withRowAnimation:UITableViewRowAnimationMiddle];
            [self.myTableView endUpdates];
        }
    }
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    CGFloat height;
    if (indexPath.section == 0 && indexPath.row != 0) {
        height = 100.0;
    } else if (indexPath.section == 1 && indexPath.row != 0){
        height = 320;
    } else {
        height = 44.0;
    }
    return height;
}

@end

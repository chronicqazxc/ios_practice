//
//  ExtendTeableViewController.m
//  ChartDemo
//
//  Created by Wayne on 5/21/14.
//  Copyright (c) 2014 Wayne. All rights reserved.
//

#import "ExtendTeableViewController.h"
#import "RADataObject.h"
#import "FilterConditionCell.h"
#import "ExpendAnalyze.h"
#import "ChartCell.h"
#import "CustomCellTest.h"
#import "AccountOverviewChart.h"

#define UIColorFromRGB(rgbValue) [UIColor colorWithRed:((float)((rgbValue & 0xFF0000) >> 16))/255.0 green:((float)((rgbValue & 0xFF00) >> 8))/255.0 blue:((float)(rgbValue & 0xFF))/255.0 alpha:1.0]

@interface ExtendTeableViewController ()

@property (strong, nonatomic) NSArray *data;
@property (strong, nonatomic) id expanded;
@property (strong, nonatomic) FilterConditionCell *filterCell;
@property (strong, nonatomic) FilterConditionCell *filterCell2;
@property (strong, nonatomic) FilterConditionCell *pieCell;
@property (strong, nonatomic) FilterConditionCell *stackedBarCell;
@property (strong, nonatomic) ChartCell *pieChartCell;
@property (strong, nonatomic) ChartCell *stackedBarChartCell;
@property (strong, nonatomic) AccountOverviewChart *stackedBarChart;
@property (strong, nonatomic) ExpendAnalyze *pieChart;
@property (strong, nonatomic) CustomCellTest *customTestCell;

@end

@implementation ExtendTeableViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    RADataObject *condition1 = [RADataObject dataObjectWithName:@"Condition1" children:nil];
    RADataObject *condition2 = [RADataObject dataObjectWithName:@"Condition2" children:nil];
    RADataObject *filterView = [RADataObject dataObjectWithName:@"Conditions" children:[NSArray arrayWithObjects:condition1, condition2, nil]];
    
    RADataObject *pieChart1 = [RADataObject dataObjectWithName:@"PieChart1" children:nil];
    RADataObject *pieChart = [RADataObject dataObjectWithName:@"PieChart" children:[NSArray arrayWithObjects:pieChart1, nil]];
    
    RADataObject *stackedBarChart1 = [RADataObject dataObjectWithName:@"StackedBarChart1" children:nil];
    RADataObject *stackedBarChart = [RADataObject dataObjectWithName:@"StackedBarChart" children:[NSArray arrayWithObjects:stackedBarChart1, nil]];
    
    RADataObject *subData1 = [RADataObject dataObjectWithName:@"SubData1" children:nil];
    RADataObject *subData2 = [RADataObject dataObjectWithName:@"SubData2" children:nil];
    self.expanded = subData1;
    RADataObject *data1 = [RADataObject dataObjectWithName:@"Data1" children:[NSArray arrayWithObjects:subData1, subData2, nil]];
    RADataObject *data2 = [RADataObject dataObjectWithName:@"Data2" children:nil];
    RADataObject *data = [RADataObject dataObjectWithName:@"Data" children:[NSArray arrayWithObjects:data1, data2, nil]];
    
    self.data = [NSArray arrayWithObjects:filterView, pieChart, stackedBarChart, data, nil];
    
    self.treeView.delegate = self;
    self.treeView.dataSource = self;
    self.treeView.separatorStyle = RATreeViewCellSeparatorStyleSingleLine;
    
    [self.treeView reloadData];
//    [self.treeView setBackgroundColor:UIColorFromRGB(0xF7F7F7)];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)treeView:(RATreeView *)treeView willDisplayCell:(UITableViewCell *)cell forItem:(id)item treeNodeInfo:(RATreeNodeInfo *)treeNodeInfo
{
    if (treeNodeInfo.treeDepthLevel == 0) {
        cell.backgroundColor = UIColorFromRGB(0xF7F7F7);
    } else if (treeNodeInfo.treeDepthLevel == 1) {
//        cell.backgroundColor = UIColorFromRGB(0xD1EEFC);
    } else if (treeNodeInfo.treeDepthLevel == 2) {
        cell.backgroundColor = UIColorFromRGB(0xE0F8D8);
    }
}

#pragma mark TreeView Delegate methods
- (CGFloat)treeView:(RATreeView *)treeView heightForRowForItem:(id)item treeNodeInfo:(RATreeNodeInfo *)treeNodeInfo
{
    if ([((RADataObject *)item).name isEqualToString:@"PieChart1"] ||
        [((RADataObject *)item).name isEqualToString:@"StackedBarChart1"]) {
        return 320.0;
    } else {
        return 50.0;
    }
}

#pragma mark TreeView Data Source

- (UITableViewCell *)treeView:(RATreeView *)treeView cellForItem:(id)item treeNodeInfo:(RATreeNodeInfo *)treeNodeInfo
{
    NSInteger numberOfChildren = [treeNodeInfo.children count];
    
    UITableViewCell *cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:@"cell"];
    cell.detailTextLabel.text = [NSString stringWithFormat:@"Number of children %@", [@(numberOfChildren) stringValue]];
    cell.textLabel.text = ((RADataObject *)item).name;
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    
    if (treeNodeInfo.treeDepthLevel == 0) {
        cell.detailTextLabel.textColor = [UIColor blackColor];
    }
    
    NSString *determindName = ((RADataObject *)item).name;
    if ([determindName isEqualToString:@"Conditions"]) {
        if (!self.filterCell) {
            self.filterCell = [treeView dequeueReusableCellWithIdentifier:@"filterCell"];
            self.filterCell = (FilterConditionCell *)[self getCustomCellByName:@"FilterConditionCell"];
            self.filterCell.buttonLabel.layer.masksToBounds = YES;
            self.filterCell.buttonLabel.layer.cornerRadius = 10.0;
            self.filterCell.titleLabel.text = @"篩選條件";
            [self.filterCell.buttonLabel setBackgroundColor:UIColorFromRGB(0x009966)];
        }
        if (treeNodeInfo.isExpanded == YES)
            [self.filterCell.buttonLabel setBackgroundColor:[UIColor grayColor]];
        else
            [self.filterCell.buttonLabel setBackgroundColor:UIColorFromRGB(0x009966)];
        return self.filterCell;
    } else if ([determindName isEqualToString:@"PieChart1"]) {
        if (!self.pieChartCell) {
            self.pieChartCell = [treeView dequeueReusableCellWithIdentifier:@"chartCell"];
            self.pieChartCell = (ChartCell *)[self getCustomCellByName:@"ChartCell"];
            self.pieChartCell.cellBackgroundImage = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@""]];
            self.pieChartCell.cellBackgroundImage.frame = CGRectMake(-1, -10, 320, 0);
            [self.pieChartCell addSubview:self.pieChartCell.cellBackgroundImage];
            
            [self setupPieChartWithRect:[self.pieChartCell bounds]];
            [self.pieChartCell addSubview:self.pieChart];
            self.pieChart.frame = CGRectMake(0, 0, 100, 0);
            
            [UIView animateWithDuration:0.3f animations:^{
                CGRect rect = self.pieChartCell.cellBackgroundImage.frame;
                rect.size.height += 330.0f;
                self.pieChartCell.cellBackgroundImage.frame = rect;
                self.pieChart.frame = rect;
            }];
        }
        return self.pieChartCell;
    } else if ([determindName isEqualToString:@"PieChart"]) {
        if (!self.pieCell) {
            self.pieCell = (FilterConditionCell *)[self getCustomCellByName:@"FilterConditionCell"];
            self.pieCell.buttonLabel.layer.masksToBounds = YES;
            self.pieCell.buttonLabel.layer.cornerRadius = 10.0;
            self.pieCell.titleLabel.text = @"支出類型分析";
            [self.pieCell.buttonLabel setBackgroundColor:UIColorFromRGB(0x009966)];
        }
        return self.pieCell;
    } else if ([determindName isEqualToString:@"Condition2"]) {
        if (!self.customTestCell) {
            self.customTestCell = (CustomCellTest *)[self getCustomCellByName:@"CustomCellTest"];
        }
        return self.customTestCell;
    } else if ([determindName isEqualToString:@"StackedBarChart"]) {
        if (!self.stackedBarCell) {
            self.stackedBarCell = (FilterConditionCell *)[self getCustomCellByName:@"FilterConditionCell"];
            self.stackedBarCell.buttonLabel.layer.masksToBounds = YES;
            self.stackedBarCell.buttonLabel.layer.cornerRadius = 10.0;
            self.stackedBarCell.titleLabel.text = @"支出趨勢分析";
            [self.stackedBarCell.buttonLabel setBackgroundColor:UIColorFromRGB(0x009966)];
        }
        return self.stackedBarCell;
    } else if ([determindName isEqualToString:@"StackedBarChart1"]) {
        if (!self.stackedBarChartCell) {
            self.stackedBarChartCell = [treeView dequeueReusableCellWithIdentifier:@"chartCell"];
            self.stackedBarChartCell = (ChartCell *)[self getCustomCellByName:@"ChartCell"];
            self.stackedBarChartCell.cellBackgroundImage = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@""]];
            self.stackedBarChartCell.cellBackgroundImage.frame = CGRectMake(-1, -10, 320, 0);
            [self.stackedBarChartCell addSubview:self.pieChartCell.cellBackgroundImage];
            
            [self setupStackedBarChartWithRect:[self.stackedBarChartCell bounds]];
            [self.stackedBarChartCell addSubview:self.stackedBarChart];
            self.stackedBarChart.frame = CGRectMake(0, 0, 100, 0);
            
            [UIView animateWithDuration:0.3f animations:^{
                CGRect rect = self.stackedBarChartCell.cellBackgroundImage.frame;
                rect.size.height += 330.0f;
                self.stackedBarChartCell.cellBackgroundImage.frame = rect;
                self.stackedBarChart.frame = rect;
            }];
        }
        return self.stackedBarChartCell;
    }
    return cell;
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
//    self.pieChart = [[ExpendAnalyze alloc] initWithFrame:CGRectMake(0,0,rect.size.height*0.5,rect.size.height*0.5)];
    self.pieChart = [[ExpendAnalyze alloc] initWithFrame:CGRectMake(0,0,100, 100)];
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


- (void)setupStackedBarChartWithRect:(CGRect)rect{
    self.stackedBarChart = [[AccountOverviewChart alloc] init];
    NSMutableDictionary *dataTemp = [[NSMutableDictionary alloc] init];
    NSArray *xAxisContents = @[@"102/12",
                               @"103/1",
                               @"103/2",
                               @"103/3",
                               @"103/4",
                               @"103/5",
                               @"103/6",
                               @"103/7",
                               @"103/8",
                               @"103/9",
                               @"103/10",
                               @"103/11",
                               @"103/12",
                               @"103/goal"];
    [self.stackedBarChart generateXAxisContents:xAxisContents];
    NSDictionary *plotsWithColors = [NSDictionary dictionaryWithObjectsAndKeys:
                                     [UIColor darkGrayColor], @"保險",
                                     [UIColor orangeColor],   @"結構型商品",
                                     [UIColor redColor],      @"黃金存摺",
                                     [UIColor blueColor],     @"信託投資",
                                     [UIColor grayColor],     @"外幣存款",
                                     [UIColor greenColor],    @"台幣存款", nil];
    NSArray *sortedAccountItems = @[@"保險",
                                    @"結構型商品",
                                    @"黃金存摺",
                                    @"信託投資",
                                    @"外幣存款",
                                    @"台幣存款"];
    [self.stackedBarChart generatePlotsWithColors:plotsWithColors andSort:sortedAccountItems];
    for (NSString *xAxisContent in xAxisContents) {
        NSMutableDictionary *plotsWithValue = [NSMutableDictionary dictionary];
        for (NSString *keyForValue in [plotsWithColors allKeys]) {
            NSNumber *num = [NSNumber numberWithInteger:arc4random_uniform(100)+1];
            if ([xAxisContent isEqualToString:@"103/9"] ||
                [xAxisContent isEqualToString:@"103/10"] ||
                [xAxisContent isEqualToString:@"103/11"] ||
                [xAxisContent isEqualToString:@"103/12"]) {
                num = [NSNumber numberWithInt:0];
            } else if ([xAxisContent isEqualToString:@"103/goal"]){
                num = [NSNumber numberWithInt:83];
            }
            [plotsWithValue setObject:num forKey:keyForValue];
        }
        [dataTemp setObject:plotsWithValue forKey:xAxisContent];
    }
    
    self.stackedBarChart.isPlotColorWithGradient = NO;
    [self.stackedBarChart generateData:dataTemp];
    [self.stackedBarChart generateLayout];
}

- (NSInteger)treeView:(RATreeView *)treeView numberOfChildrenOfItem:(id)item
{
    RADataObject *data = item;
    if (item == nil) {
        return [self.data count];
    }
    
    return [data.children count];
}

- (id)treeView:(RATreeView *)treeView child:(NSInteger)index ofItem:(id)item
{
    RADataObject *data = item;
    if (item == nil) {
        return [self.data objectAtIndex:index];
    }
    
    return [data.children objectAtIndex:index];
}

- (void)treeView:(RATreeView *)treeView didSelectRowForItem:(id)item treeNodeInfo:(RATreeNodeInfo *)treeNodeInfo{
    NSString *determindName = ((RADataObject *)item).name;
    if ([determindName isEqualToString:@"Conditions"]) {
        if ([treeNodeInfo isExpanded] == NO) {
            [UIView animateWithDuration:0.3f animations:^{
                [self.filterCell.buttonLabel setBackgroundColor:[UIColor grayColor]];
                self.filterCell.buttonText.text = @"收合";
            }];
        } else {
            [UIView animateWithDuration:0.5f animations:^{
                [self.filterCell.buttonLabel setBackgroundColor:UIColorFromRGB(0x009966)];
                self.filterCell.buttonText.text = @"展開";
            }];
        }
    } else if ([determindName isEqualToString:@"PieChart"]) {
            if ([treeNodeInfo isExpanded] == YES) {
                [UIView animateWithDuration:0.3f animations:^{
                    [self.pieCell.buttonLabel setBackgroundColor:UIColorFromRGB(0x009966)];
                    self.pieCell.buttonText.text = @"展開";
                    
                    CGRect rect = self.pieChartCell.cellBackgroundImage.frame;
                    rect.size.height -= 320;
                    self.pieChartCell.cellBackgroundImage.frame = rect;
                    self.pieChart.frame = rect;
                }];
            } else {
                [UIView animateWithDuration:0.3f animations:^{
                    [self.pieCell.buttonLabel setBackgroundColor:[UIColor grayColor]];
                    self.pieCell.buttonText.text = @"收合";
                    
                    CGRect rect = self.pieChartCell.cellBackgroundImage.frame;
                    rect.size.height += 320.0f;
                    self.pieChartCell.cellBackgroundImage.frame = rect;
                    self.pieChart.frame = rect;
                }];
            }
    } else if ([determindName isEqualToString:@"StackedBarChart"]) {
        if ([treeNodeInfo isExpanded] == YES) {
            [UIView animateWithDuration:0.3f animations:^{
                [self.stackedBarCell.buttonLabel setBackgroundColor:UIColorFromRGB(0x009966)];
                self.stackedBarCell.buttonText.text = @"展開";
                
                CGRect rect = self.stackedBarChartCell.cellBackgroundImage.frame;
                rect.size.height -= 320;
                self.stackedBarChartCell.cellBackgroundImage.frame = rect;
                self.stackedBarChart.frame = rect;
            }];
        } else {
            [UIView animateWithDuration:0.3f animations:^{
                [self.stackedBarCell.buttonLabel setBackgroundColor:[UIColor grayColor]];
                self.stackedBarCell.buttonText.text = @"收合";
                
                CGRect rect = self.stackedBarChartCell.cellBackgroundImage.frame;
                rect.size.height += 320.0f;
                self.stackedBarChartCell.cellBackgroundImage.frame = rect;
                self.stackedBarChart.frame = rect;
            }];
        }
    }
}

- (void)treeView:(RATreeView *)treeView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowForItem:(id)item treeNodeInfo:(RATreeNodeInfo *)treeNodeInfo{

}

- (UITableViewCellEditingStyle)treeView:(RATreeView *)treeView editingStyleForRowForItem:(id)item treeNodeInfo:(RATreeNodeInfo *)treeNodeInfo{
    NSString *determindName = ((RADataObject *)item).name;
    if ([determindName isEqualToString:@"Data1"] || [determindName isEqualToString:@"Data2"]){
        return UITableViewCellEditingStyleDelete;
    } else {
        return UITableViewCellEditingStyleNone;
    }
}
@end

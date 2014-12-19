//
//  ViewController.m
//  GoTopButton
//
//  Created by Wayne on 12/19/14.
//  Copyright (c) 2014 Wayne. All rights reserved.
//

#import "ViewController.h"
#import "GoTopButton.h"

@interface ViewController () <UITableViewDataSource, UITableViewDelegate, GoTopButtonDelegate>
@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property (strong, nonatomic) NSMutableArray *dataArr;
@property (strong, nonatomic) GoTopButton *goTopButton;
@end

@implementation ViewController
#pragma mark - life cycle
- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor blackColor];
    self.tableView.backgroundColor = [UIColor blackColor];
    self.goTopButton = [[GoTopButton alloc] initWithFrame:self.view.frame];
    self.goTopButton.tableView = self.tableView;
    self.goTopButton.delegate = self;
    self.goTopButton.conditionForShow = 20;
    [self.view addSubview:self.goTopButton];
    [self setUpData];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma methods
- (void)setUpData {
    self.dataArr = [NSMutableArray array];
    for (int i=0; i<50 ; i++) {
        NSDictionary *dic = [NSDictionary dictionaryWithObjectsAndKeys:
                             [NSString stringWithFormat:@"Title:%d",i+1],[NSString stringWithFormat:@"%d",i+1], nil];
        [self.dataArr addObject:dic];
    }
}

#pragma mark - UITableViewDataSource
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return [self.dataArr count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    static NSString *cellIdentifier = @"Cell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellIdentifier];
    if (!cell) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:cellIdentifier];
    }
    NSString *detailText = [[[self.dataArr objectAtIndex:indexPath.row] allKeys] lastObject];
    NSString *titleText = [[[self.dataArr objectAtIndex:indexPath.row] allValues] lastObject];
    cell.textLabel.text = titleText;
    cell.textLabel.textColor = [UIColor whiteColor];
    cell.detailTextLabel.text = detailText;
    cell.detailTextLabel.textColor = [UIColor lightGrayColor];
    cell.backgroundColor = [UIColor blackColor];
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
}

#pragma mark - GoTopButtonDelegate
- (void)goTopButtonBeClicked {
    [self.goTopButton scrollToTop];
}
@end

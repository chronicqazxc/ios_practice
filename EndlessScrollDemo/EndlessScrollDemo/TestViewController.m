//
//  TestViewController.m
//  EndlessScrollDemo
//
//  Created by Wayne on 12/26/14.
//  Copyright (c) 2014 Wayne. All rights reserved.
//

#import "TestViewController.h"
#import "TestView.h"
#import "ViewController.h"

@interface TestViewController ()
@property (strong, nonatomic) TestView *testView;
@end

@implementation TestViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    NSArray *arr = [[NSBundle mainBundle] loadNibNamed:@"TestView" owner:self options:nil];
    self.testView = [arr firstObject];
    self.testView.frame = CGRectMake(100, 100, 200, 200);
    self.testView.layer.borderColor = [UIColor redColor].CGColor;
    self.testView.layer.borderWidth = 1.0f;
    [self.testView.button addTarget:self action:@selector(toCollectionView:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:self.testView];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)toCollectionView:(UIButton *)sender {
    ViewController *newView = [self.storyboard instantiateViewControllerWithIdentifier:@"CollectionViewController"];
    [self.navigationController pushViewController:newView animated:YES];
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

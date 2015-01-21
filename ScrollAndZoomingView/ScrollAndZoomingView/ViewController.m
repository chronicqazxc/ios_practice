//
//  ViewController.m
//  ScrollAndZoomingView
//
//  Created by Wayne on 1/21/15.
//  Copyright (c) 2015 Wayne. All rights reserved.
//

#import "ViewController.h"
#import "FullScreenScrollView.h"
#import "EndlessScrollGenerator.h"
#import "AppDelegate.h"

#define kScrollViewMaxScale 0.7
#define kScrollViewMinScale 0.3

@interface ViewController () <FullScreenScrollViewDelegate, EndlessScrollGeneratorDelegate, UIScrollViewDelegate>
@property (weak, nonatomic) AppDelegate *appDelegate;
@property (weak, nonatomic) NSMutableArray *images;
@property (strong, nonatomic) FullScreenScrollView *scrollview;
@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.appDelegate = (AppDelegate *)[[UIApplication sharedApplication] delegate];
    self.appDelegate.viewController = self;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)reloadImage:(NSUInteger)index withImages:(NSMutableArray *)images {
    CGRect screenRect = [[UIScreen mainScreen] bounds];
    CGFloat screenWidth = screenRect.size.width;
    CGFloat screenHeight = screenRect.size.height;
    
    self.scrollview = [[FullScreenScrollView alloc] init];
    EndlessScrollGenerator *generator = [[EndlessScrollGenerator alloc] initWithScrollViewContainer:self];
    NSMutableArray *newData = [generator setUpData:images];
    self.scrollview = [[FullScreenScrollView alloc] initWithImageViews:newData withFrame:CGRectMake(0,
                                                                                                   screenHeight/2,
                                                                                                   screenWidth,
                                                                                                   screenHeight*0.3)
                                                       minzoomingScale:kScrollViewMinScale maxzoomingScale:kScrollViewMaxScale delegate:self];
    [self.view addSubview:self.scrollview];
    [generator setUpScrollView:self.scrollview];
    [generator startPaging];
}

- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView {
    NSLog(@"scrollViewDidEndDecelerating");
}

#pragma mark - FullScreenScrollViewDelegate
- (void)pageChanged:(int)currentPage {
    switch (currentPage) {
        case 0:
            NSLog(@"0");
            break;
        case 1:
            NSLog(@"1");
            break;
        case 2:
            NSLog(@"2");
            break;
        default:
            break;
    }
}

- (void)nextPageNotify {
    NSLog(@"nextPageNotify");
}

- (void)previousPageNotify {
    NSLog(@"previousPageNotify");
}

@end

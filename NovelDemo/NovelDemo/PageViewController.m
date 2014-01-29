//
//  PageViewController.m
//  NovelDemo2
//
//  Created by Wayne on 1/15/14.
//  Copyright (c) 2014 Wayne. All rights reserved.
//

#import "PageViewController.h"
#import "DatabaseSQLite.h"

@interface PageViewController ()

@end

@implementation PageViewController{
    ModelController *modelController;
}

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
	// Do any additional setup after loading the view.
    
    // Set title
    DatabaseSQLite *database = [DatabaseSQLite new];
    self.title = [database titleForIndex: _startPage];
    
    // Set delegate
    self.delegate = self;
    
    // Set source controller
    modelController = [ModelController new];
    self.dataSource = modelController;
    
    // Set initital screen
    ContentViewController *contentViewController = [self.storyboard instantiateViewControllerWithIdentifier: @"ContentViewController"];
    
    contentViewController.page = _startPage;
    [self setViewControllers:[NSArray arrayWithObjects:contentViewController,nil]
                   direction:UIPageViewControllerNavigationOrientationHorizontal animated:1 completion:nil];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void) pageViewController:(UIPageViewController *) pageViewController didFinishAnimating:(BOOL) finished previousViewControllers: (NSArray *)previousViewControllers transitionCompleted: (BOOL) completed{
    if(!completed){
        ContentViewController *previousContentViewController = [previousViewControllers objectAtIndex: 0];
        DatabaseSQLite *database = [DatabaseSQLite new];
        self.title = [database titleForIndex:previousContentViewController.page];
    }
}
@end

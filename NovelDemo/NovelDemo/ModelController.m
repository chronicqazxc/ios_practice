//
//  ModelController.m
//  NovelDemo2
//
//  Created by Wayne on 1/15/14.
//  Copyright (c) 2014 Wayne. All rights reserved.
//

#import "ModelController.h"
#import "DatabaseSQLite.h"

@implementation ModelController{
    int currentPage, nextPage, lastPage, totalPages;
}
-(UIViewController *)pageViewController:(UIPageViewController *)pageViewController viewControllerAfterViewController:(UIViewController *)viewController{
    
    // Current ContentViewController
    ContentViewController *currentViewController = (ContentViewController *) viewController;
    
    // Current page
    currentPage = currentViewController.page;
    
    // Get all pages
    DatabaseSQLite *database = [DatabaseSQLite new];
    totalPages = [[database catagories] count];
    
    // Last page
    if (currentPage == totalPages-1) return nil;
    
    // Next page
    nextPage = currentPage + 1;
    
    // Set title on next page
    pageViewController.title = [database titleForIndex: nextPage];
    
    // Return ContentViewController for next page
    ContentViewController *nextPageContentViewController = [viewController.storyboard instantiateViewControllerWithIdentifier:@"ContentViewController"];
    nextPageContentViewController.page = nextPage;
    return nextPageContentViewController;
}

-(UIViewController *)pageViewController:(UIPageViewController *)pageViewController viewControllerBeforeViewController:(UIViewController *)viewController{
    
    // Current ContentViewController
    ContentViewController *currentViewController = (ContentViewController *)viewController;
    
    // Current page
    currentPage = currentViewController.page;
    
    // First page
    if(currentPage <= 1) return nil;
    
    // Get last page
    lastPage = currentPage - 1;
    
    // Set title on last page
    DatabaseSQLite *database = [DatabaseSQLite new];
    pageViewController.title = [database titleForIndex: lastPage];
    
    // Return ContentViewController for last page
    ContentViewController *lastPageContentViewController = [viewController.storyboard instantiateViewControllerWithIdentifier:@"ContentViewController"];
    lastPageContentViewController.page = lastPage;
    return lastPageContentViewController;
}

@end

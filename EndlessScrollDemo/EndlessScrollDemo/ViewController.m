//
//  ViewController.m
//  EndlessScrollDemo
//
//  Created by Wayne on 12/26/14.
//  Copyright (c) 2014 Wayne. All rights reserved.
//

#import "ViewController.h"
#import "CollectionViewCell.h"

@interface ViewController () <UICollectionViewDataSource, UICollectionViewDelegate>
@property (weak, nonatomic) IBOutlet UICollectionView *collectionView;
@property (strong, nonatomic) NSArray *dataArray;
@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.collectionView.dataSource = self;
    self.collectionView.delegate = self;
    self.collectionView.pagingEnabled = YES;
    [self setupDataForCollectionView];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void)setupDataForCollectionView {
    
    // Create the original set of data
    NSArray *originalArray = @[@"itemOne", @"itemTwo", @"itemThree"];
    
    // Grab references to the first and last items
    // They're typed as id so you don't need to worry about what kind
    // of objects the originalArray is holding
    id firstItem = originalArray[0];
    id lastItem = [originalArray lastObject];
    
    NSMutableArray *workingArray = [originalArray mutableCopy];
    
    // Add the copy of the last item to the beginning
    [workingArray insertObject:lastItem atIndex:0];
    
    // Add the copy of the first item to the end
    [workingArray addObject:firstItem];
    
    // Update the collection view's data source property
    self.dataArray = [NSArray arrayWithArray:workingArray];
    // @"itemThree", @"itemOne", @"itemTwo", "itemThree", @"itemOne"
    
}

-(void)scrollViewDidEndDecelerating:(UIScrollView *)scrollview {
    
    // Calculate where the collection view should be at the right-hand end item
    float contentOffsetWhenFullyScrolledRight = self.collectionView.frame.size.width * ([self.dataArray count] -1);
    NSLog(@"%.2f",contentOffsetWhenFullyScrolledRight);
    
    if (scrollview.contentOffset.x == contentOffsetWhenFullyScrolledRight) {
        
        // user is scrolling to the right from the last item to the 'fake' item 1.
        // reposition offset to show the 'real' item 1 at the left-hand end of the collection view
        
        NSIndexPath *newIndexPath = [NSIndexPath indexPathForItem:1 inSection:0];
        
        [self.collectionView scrollToItemAtIndexPath:newIndexPath atScrollPosition:UICollectionViewScrollPositionRight animated:NO];
        
    } else if (scrollview.contentOffset.x == 0)  {
        
        // user is scrolling to the left from the first item to the fake 'item N'.
        // reposition offset to show the 'real' item N at the right end end of the collection view
        
        NSIndexPath *newIndexPath = [NSIndexPath indexPathForItem:([self.dataArray count] -2) inSection:0];
        
        [self.collectionView scrollToItemAtIndexPath:newIndexPath atScrollPosition:UICollectionViewScrollPositionRight animated:NO];
        
    }
}


- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    return [self.dataArray count];
}

- (CollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    
    UINib *cellNib = [UINib nibWithNibName:@"CollectionViewCell" bundle:[NSBundle mainBundle]];
    [collectionView registerNib:cellNib forCellWithReuseIdentifier:@"Cell"];
    
    NSArray *arr = [[NSBundle mainBundle] loadNibNamed:@"CollectionViewCell" owner:self options:nil];
    CollectionViewCell *cell = [arr firstObject];
    cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"Cell" forIndexPath:indexPath];
    
    NSString *title = [self.dataArray objectAtIndex:indexPath.row];
    if ([title isEqualToString:@"itemOne"]) {
        cell.backgroundColor = [UIColor redColor];
    } else if ([title isEqualToString:@"itemTwo"]) {
        cell.backgroundColor = [UIColor orangeColor];
    } else if ([title isEqualToString:@"itemThree"]) {
        cell.backgroundColor = [UIColor greenColor];
    }
    return cell;
}
@end

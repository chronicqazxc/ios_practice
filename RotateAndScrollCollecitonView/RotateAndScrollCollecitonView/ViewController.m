//
//  ViewController.m
//  RotateAndScrollCollecitonView
//
//  Created by Wayne on 12/27/14.
//  Copyright (c) 2014 Wayne. All rights reserved.
//

#import "ViewController.h"
#import "Utilities.h"
#import "MyCollectionViewLayout.h"

@interface ViewController () <UICollectionViewDataSource, UICollectionViewDelegate>
@property (nonatomic) NSInteger numberOfCells;
@property (weak, nonatomic) IBOutlet UICollectionView *collectionView;
@property (strong, nonatomic) NSMutableArray *dataArr;
@property (weak, nonatomic) IBOutlet UIBarButtonItem *removeButton;
@property (strong, nonatomic) NSIndexPath *selectedIndexPath;
@property (strong, nonatomic) UIImageView *movingCell;
@end

@implementation ViewController
- (void)viewDidLoad {
    [super viewDidLoad];
    self.dataArr = [NSMutableArray array];
    self.numberOfCells = 3;
    self.collectionView.dataSource = self;
    self.collectionView.delegate = self;
    self.removeButton.enabled = NO;
    //    int i = 0;
    //    while (i < 8) {
    //        [self addCell:nil];
    //        i++;
    //    }
    
    UIPanGestureRecognizer *panGesture = [[UIPanGestureRecognizer alloc] initWithTarget:self action:@selector(pan:)];
    [self.view addGestureRecognizer:panGesture];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - gesture
- (void)pan:(UIPanGestureRecognizer *)gesture {
    CGPoint locationPoint = [gesture locationInView:self.collectionView];
    
    if (gesture.state == UIGestureRecognizerStateBegan) {
        
        NSIndexPath *indexPathOfMovingCell = [self.collectionView indexPathForItemAtPoint:locationPoint];
        UICollectionViewCell *cell = [self.collectionView cellForItemAtIndexPath:indexPathOfMovingCell];
        
        UIGraphicsBeginImageContext(cell.bounds.size);
        [cell.layer renderInContext:UIGraphicsGetCurrentContext()];
        UIImage *cellImage = UIGraphicsGetImageFromCurrentImageContext();
        UIGraphicsEndImageContext();
        
        self.movingCell = [[UIImageView alloc] initWithImage:cellImage];
        [self.movingCell setCenter:locationPoint];
        [self.movingCell setAlpha:0.75f];
        [self.collectionView addSubview:self.movingCell];
        
    }
    
    if (gesture.state == UIGestureRecognizerStateChanged) {
        [self.movingCell setCenter:locationPoint];
        [self remove:nil];
    }
    
    if (gesture.state == UIGestureRecognizerStateEnded) {
        [self.movingCell removeFromSuperview];
    }
}

#pragma mark - UICollectionViewDataSource
-(NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView {
    
    return 1; // The number of sections we want
}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    return [self.dataArr count];
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    UICollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"Cell" forIndexPath:indexPath];
    cell.contentView.backgroundColor = [self.dataArr objectAtIndex:indexPath.row];
    cell.layer.borderColor = [UIColor redColor].CGColor;
    if (indexPath == self.selectedIndexPath) {
        cell.layer.borderWidth = 2.0;
    } else {
        cell.layer.borderWidth = 0.0;
    }
    cell.layer.masksToBounds = YES;
    cell.layer.cornerRadius = 15.0;
    return cell;
}

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath
{
    //    [self removeItemAtIndex:indexPath];
    
    self.selectedIndexPath = indexPath;
    self.removeButton.enabled = YES;
    UICollectionViewCell *cell;
    for (NSIndexPath *index in [self.collectionView indexPathsForVisibleItems]) {
        cell = [self.collectionView cellForItemAtIndexPath:index];
        if (index == indexPath) {
            cell.layer.borderColor = [UIColor redColor].CGColor;
            cell.layer.borderWidth = 2.0f;
        } else {
            cell.layer.borderColor = [UIColor redColor].CGColor;
            cell.layer.borderWidth = 0.0f;
        }
    }
}
- (IBAction)remove:(UIBarButtonItem *)sender {
    if (self.selectedIndexPath)
        [self removeItemAtIndex:self.selectedIndexPath];
}

-(void)removeItemAtIndex:(NSIndexPath *)index {
    self.numberOfCells--;
    
    [self.dataArr removeObjectAtIndex:index.row];
    [self.collectionView deleteItemsAtIndexPaths:@[[NSIndexPath indexPathForItem:index.item inSection:0]]];
    
    self.selectedIndexPath = nil;
    self.removeButton.enabled = NO;
}

- (IBAction)addCell:(UIBarButtonItem *)sender {
    self.numberOfCells++;
    [self.dataArr addObject:[Utilities randomColor]];
    if (sender)
        [self.collectionView insertItemsAtIndexPaths:@[[NSIndexPath indexPathForItem:[self.dataArr count]-1 inSection:0]]];
}

- (CGPoint)getPointInMainViewPointInCollectionView:(CGPoint)pointInCollectionView {
    CGPoint pointInMainView = [self.collectionView.superview convertPoint:pointInCollectionView fromView:self.collectionView];
    return pointInMainView;
}

- (CGPoint)getCenterInMainViewCenterInCollectionView:(CGPoint)centerInCollectionView {
    CGPoint centerInMainView = [self.collectionView.superview convertPoint:centerInCollectionView fromView:self.collectionView];
    return centerInMainView;
}

- (IBAction)translateOne:(UIBarButtonItem *)sender {
    if (self.selectedIndexPath) {
        UICollectionViewCell *cell = [self.collectionView cellForItemAtIndexPath:self.selectedIndexPath];
        
        //        CGFloat horizontalCenter = (CGRectGetWidth(self.collectionView.bounds) / 2.0f);
        
        //        CGPoint pointInCollectionView = cell.frame.origin;
        //        CGPoint pointInMainView = [self getPointInMainViewPointInCollectionView:pointInCollectionView];
        
        CGPoint centerInCollectionView = cell.center;
        CGPoint centerInMainView = [self getCenterInMainViewCenterInCollectionView:centerInCollectionView];
        
        CGPoint rotationPoint = CGPointMake(self.collectionView.frame.size.width/2, self.collectionView.frame.size.height);
        
        CATransform3D transform = CATransform3DIdentity;
        transform.m34 = 1.0f / -1000.0f;
        transform = CATransform3DTranslate(transform, rotationPoint.x - centerInMainView.x, 0.0,  0.0);
        
        cell.layer.transform = transform;
    }
}

- (IBAction)rotate:(UIBarButtonItem *)sender {
    if (self.selectedIndexPath) {
        UICollectionViewCell *cell = [self.collectionView cellForItemAtIndexPath:self.selectedIndexPath];
        
        //        CGFloat horizontalCenter = (CGRectGetWidth(self.collectionView.bounds) / 2.0f);
        
        CGPoint pointInCollectionView = cell.frame.origin;
        CGPoint pointInMainView = [self getPointInMainViewPointInCollectionView:pointInCollectionView];
        
        CGPoint centerInCollectionView = cell.center;
        CGPoint centerInMainView = [self getCenterInMainViewCenterInCollectionView:centerInCollectionView];
        
        float rotateBy = [[[MyCollectionViewLayout alloc] init] calRotateDegree:pointInMainView.x];
        CGPoint rotationPoint = CGPointMake(self.collectionView.frame.size.width/2, self.collectionView.frame.size.height);
        
        CATransform3D transform = CATransform3DIdentity;
        transform.m34 = 1.0f / -1000.0f;
        transform = CATransform3DTranslate(transform, rotationPoint.x - centerInMainView.x, 0.0,  0.0);
        transform = CATransform3DRotate(transform, degToRad(rotateBy), 0.0, 0.0, 1.0);
        
        cell.layer.transform = transform;
    }
}

- (IBAction)translateTwo:(UIBarButtonItem *)sender {
    if (self.selectedIndexPath) {
        UICollectionViewCell *cell = [self.collectionView cellForItemAtIndexPath:self.selectedIndexPath];
        
        //        CGFloat horizontalCenter = (CGRectGetWidth(self.collectionView.bounds) / 2.0f);
        
        CGPoint pointInCollectionView = cell.frame.origin;
        CGPoint pointInMainView = [self getPointInMainViewPointInCollectionView:pointInCollectionView];
        
        CGPoint centerInCollectionView = cell.center;
        CGPoint centerInMainView = [self getCenterInMainViewCenterInCollectionView:centerInCollectionView];
        
        float rotateBy = [[[MyCollectionViewLayout alloc] init] calRotateDegree:pointInMainView.x];
        
        CGPoint rotationPoint = CGPointMake(self.collectionView.frame.size.width/2, self.collectionView.frame.size.height);
        
        CATransform3D transform = CATransform3DIdentity;
        transform.m34 = 1.0f / -1000.0f;
        transform = CATransform3DTranslate(transform, rotationPoint.x - centerInMainView.x, 0.0,  0.0);
        transform = CATransform3DRotate(transform, degToRad(rotateBy), 0.0, 0.0, 1.0);
        NSLog(@"%.2f",rotateBy);
        transform = CATransform3DTranslate(transform, centerInMainView.x - rotationPoint.x, 0.0, 0.0);
        
        cell.layer.transform = transform;
    }
}
@end

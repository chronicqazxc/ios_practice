//
//  PhototCollectionViewController.m
//  FBLoginTest
//
//  Created by Wayne on 4/22/14.
//  Copyright (c) 2014 Wayne. All rights reserved.
//

#import "PhototCollectionViewController.h"
#import "PhototCollectionCell.h"
#import <FacebookSDK/FacebookSDK.h>
#import "CheckPermissions.h"
#import "Friend.h"
#import "People.h"
#import "Photo.h"
#import "ImageDownload.h"
#import "Album.h"

@interface PhototCollectionViewController (){
    
    NSMutableArray *photoContainer;
    
    NSMutableArray *albumContainer;
    
    NSMutableDictionary *imageDownloadsInProgress;
}

@end

@implementation PhototCollectionViewController

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
    
    [self getAllPhotos];
}

- (void)getAllPhotos{
    
    [CheckPermissions checkForPermissions:@[@"friends_photos"]];
    
    NSString *requestPath = [NSString stringWithFormat:@"/%@/?fields=photos.fields(name,source,paging)",self.album.albumID];
    
    [FBRequestConnection startWithGraphPath:requestPath
                                 parameters:nil
                                 HTTPMethod:@"GET"
                          completionHandler:^(
                                              FBRequestConnection *connection,
                                              id result,
                                              NSError *error
                                              ) {
                              if(!error){
                                  
                                  photoContainer = [NSMutableArray array];
                                  
                                  [self parseResult:result isFirstPage:YES isFinalPage:NO];
                                  
                              }
                          }];
}

- (NSMutableArray *)parseResult:(id)result isFirstPage:(BOOL)isFirstPage isFinalPage:(BOOL)isFinalPage{
    
    NSDictionary *friendData = [NSDictionary dictionary];
    
    NSArray *friendPhotoData = [NSArray array];
    
    NSDictionary *pagingData = [NSDictionary dictionary];
    
    NSString *nextPage;
    
    if (isFirstPage){
        
        friendData = [result objectForKey:@"photos"];
        
        friendPhotoData = [friendData objectForKey:@"data"];
        
        pagingData = [friendData objectForKey:@"paging"];
        
        nextPage = [pagingData objectForKey:@"next"];
        
    }else{
        
        friendPhotoData = [result objectForKey:@"data"];
        
        nextPage = [[result objectForKey:@"paging"] objectForKey:@"next"];
    }
    
    
    for ( NSDictionary *imageContainers in friendPhotoData){
        
        Photo *photo = [[Photo alloc] init];
        
        photo.title = [imageContainers objectForKey:@"name"];
        
        photo.photoSource = [imageContainers objectForKey:@"source"];
        
        [photoContainer addObject:photo];
        
    }
    
    if (isFinalPage || nextPage == nil){
        
        [self.collectionView reloadData];
        
        [UIApplication sharedApplication].networkActivityIndicatorVisible = NO;
        
    }else{
        
        [self getNextPage:nextPage];
        
    }
    
    NSLog(@"count = %d", [photoContainer count]);
    
    
    return photoContainer;
}

- (void)getNextPage:(NSString *)page{
    
    page = [page substringFromIndex:26];
    
    [FBRequestConnection startWithGraphPath:page
                                 parameters:nil
                                 HTTPMethod:@"GET"
                          completionHandler:^(
                                              FBRequestConnection *connection,
                                              id result,
                                              NSError *error
                                              ) {
                              if(!error){
                                  
                                  if ([[result objectForKey:@"data"] count] > 0){
                                      
                                      [self parseResult:result isFirstPage:NO isFinalPage:NO];
                                      
                                  }else {
                                      
                                      [self parseResult:result isFirstPage:NO isFinalPage:YES];
                                      
                                  }
                                  
                              }
                          }];
    
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section{
    
    return [photoContainer count];
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath{
    
    static NSString *cellIdentifier = @"collectionCell";
    
    int nodeCount = [photoContainer count];
    
    PhototCollectionCell *cell = (PhototCollectionCell *)[collectionView dequeueReusableCellWithReuseIdentifier:cellIdentifier forIndexPath:indexPath];
    
    if (cell == nil){
        
        cell = [[PhototCollectionCell alloc] init];
    }
    
    if (nodeCount >0){
        
        Photo *photo = photoContainer[indexPath.row];
        
        if (!photo.photoImg){
            
            if(self.collectionView.dragging == 0 && self.collectionView.decelerating == 0)
                
                [self startImageDownload:photo forIndexPath:indexPath];
            
                cell.image.image = photo.photoImg;
            
        }else{
            
            cell.image.image = photo.photoImg;
            
        }
        
    }
    
    return cell;
    
}

- (void)startImageDownload:(Photo *)photo forIndexPath:(NSIndexPath *)indexPath{
    
    ImageDownload *imageDownload = [imageDownloadsInProgress objectForKey:indexPath];
    
    if (imageDownload == nil){
        
        imageDownload = [[ImageDownload alloc] init];
        
        imageDownload.photo = photo;
        
        imageDownload.indexPath = indexPath;
        
        imageDownload.delegate  = self;
        
        [imageDownloadsInProgress setObject:imageDownload forKey:indexPath];
        
        [imageDownload startDownload];
    }
}

- (void)appImageDidLoad:(NSIndexPath *)indexPath{
    
    ImageDownload *imageDownloader = [imageDownloadsInProgress objectForKey:indexPath];
    
    if(imageDownloader != nil){
        
        PhototCollectionCell *cell = (PhototCollectionCell *)[self.collectionView cellForItemAtIndexPath:imageDownloader.indexPath];
        
        cell.image.image = imageDownloader.photo.photoImg;
        
        [self.collectionView reloadData];
    }
    
}

#pragma mark -
#pragma mark Deferred image loading (UIScrollViewDelegate)

// Load images for all onscreen rows when scrolling is finished
- (void)scrollViewDidEndDragging:(UIScrollView *)scrollView willDecelerate:(BOOL)decelerate
{
    if (!decelerate)
	{
        [self loadImagesForOnScreenRows];
    }
}

- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView
{
    [self loadImagesForOnScreenRows];
}

- (void)loadImagesForOnScreenRows{
    if([photoContainer count] >0){
        
        NSArray *visiblePaths = [self.collectionView indexPathsForVisibleItems];
        
        for(NSIndexPath *indexPath in visiblePaths){
            
            Photo *appRecord = [photoContainer objectAtIndex:indexPath.row];
            
            if (!appRecord.photoImg)
                
                [self startImageDownload:appRecord forIndexPath:indexPath];
            
        }
    }
}
@end

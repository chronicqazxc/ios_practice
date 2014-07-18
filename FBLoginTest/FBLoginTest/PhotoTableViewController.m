//
//  PhotoTableViewController.m
//  FBLoginTest
//
//  Created by Wayne on 4/17/14.
//  Copyright (c) 2014 Wayne. All rights reserved.
//

#import "PhotoTableViewController.h"
#import <FacebookSDK/FacebookSDK.h>
#import "CheckPermissions.h"
#import "Friend.h"
#import "People.h"
#import "Photo.h"
#import "ImageDownload.h"
#import "PhotoCell.h"
#import "Album.h"

@interface PhotoTableViewController (){
    
    NSMutableArray *photoContainer;
    
    NSMutableArray *albumContainer;
    
    NSMutableDictionary *imageDownloadsInProgress;
}

@end

@implementation PhotoTableViewController

- (id)initWithStyle:(UITableViewStyle)style
{
    self = [super initWithStyle:style];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    imageDownloadsInProgress = [NSMutableDictionary dictionary];
    
    [super viewDidLoad];
    
    [self getAllPhotos];
    
    
    [UIApplication sharedApplication].networkActivityIndicatorVisible = YES;
}

- (void)viewWillDisappear:(BOOL)animated{
    
    [UIApplication sharedApplication].networkActivityIndicatorVisible = NO;
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
        
        [self.tableView reloadData];
        
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
    
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    
    
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{

    return [photoContainer count];
    
}


- (PhotoCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"photoCell";
    
    int nodeCount = [photoContainer count];
    
    if (nodeCount == 0 && indexPath.row == 0){
        
        PhotoCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
        
        if(cell == nil){
            
            NSArray *views = [[NSBundle mainBundle] loadNibNamed:@"PhotoCell" owner:nil options:nil];
            for(UIView *view in views){
                
                if([view isKindOfClass:[PhotoCell class]]){
                    
                    cell = (PhotoCell *)view;
                    
                }
            }
        }
    }
    
    PhotoCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    
    if(cell == nil){
        
        NSArray *views = [[NSBundle mainBundle] loadNibNamed:@"PhotoCell" owner:nil options:nil];
        for(UIView *view in views){
            
            if([view isKindOfClass:[PhotoCell class]]){
                
                cell = (PhotoCell *)view;
                
            }
        }
    }
    
    if (nodeCount >0){
        
        Photo *photo = photoContainer[indexPath.row];
        
        cell.title.text = photo.title;
        
        if (!photo.photoImg){
            
            if(self.tableView.dragging == 0 && self.tableView.decelerating == 0)
                [self startImageDownload:photo forIndexPath:indexPath];
    
                cell.photoContainer.image = photo.photoImg;
        }else{
            
            cell.photoContainer.image = photo.photoImg;
            
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
        
        PhotoCell *cell = (PhotoCell *)[self.tableView cellForRowAtIndexPath:imageDownloader.indexPath];
        
        cell.photoContainer.image = imageDownloader.photo.photoImg;
        
        [self.tableView reloadData];
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
        
        NSArray *visiblePaths = [self.tableView indexPathsForVisibleRows];
        
        for(NSIndexPath *indexPath in visiblePaths){
            
            Photo *appRecord = [photoContainer objectAtIndex:indexPath.row];
            
            if (!appRecord.photoImg)
                
                [self startImageDownload:appRecord forIndexPath:indexPath];
            
        }
    }
}

@end

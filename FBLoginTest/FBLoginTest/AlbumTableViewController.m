//
//  AlbumTableViewController.m
//  FBLoginTest
//
//  Created by Wayne on 4/21/14.
//  Copyright (c) 2014 Wayne. All rights reserved.
//

#import "AlbumTableViewController.h"
#import <FacebookSDK/FacebookSDK.h>
#import "CheckPermissions.h"
#import "Friend.h"
#import "People.h"
#import "Photo.h"
#import "ImageDownload.h"
#import "PhotoCell.h"
#import "Album.h"
#import "PhotoTableViewController.h"
#import "PhototCollectionViewController.h"

@interface AlbumTableViewController (){
    
    NSMutableArray *photoContainer;
    
    NSMutableArray *albumContainer;
    
    NSMutableDictionary *imageDownloadsInProgress;
    
    int selectedIndex;
}

@end

@implementation AlbumTableViewController

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
    
    [self getAllAlbums];
    
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)getAllAlbums{
    
    [CheckPermissions checkForPermissions:@[@"friends_photos"]];
    
    NSString *requestPath = [NSString stringWithFormat:@"/me/friends/%@/?fields=albums.fields(id,name)", self.theFriend.friendId];
    
    [FBRequestConnection startWithGraphPath:requestPath parameters:nil HTTPMethod:@"GET" completionHandler:^(FBRequestConnection *connection, id result, NSError *error) {
        
        if (!error){
            
            albumContainer = [NSMutableArray array];
            
            [self parseAlbumResult:result];
        }
    }];
}

- (void)parseAlbumResult:(id) result{
    
    NSDictionary *datas = [result objectForKey:@"data"][0];
    
    NSDictionary *albums = [[datas objectForKey:@"albums"] objectForKey:@"data"];
    
    for (NSDictionary *thAlbum in albums){
        
        Album *album = [[Album alloc] init];
        
        album.albumID = [thAlbum objectForKey:@"id"];
        
        album.albumName = [thAlbum objectForKey:@"name"];
        
        album.createTime = [(NSString *)[thAlbum objectForKey:@"created_time"] substringToIndex:10];
        
        [albumContainer addObject:album];
    }
    
    [self.tableView reloadData];
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    
    
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    
    return [albumContainer count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    NSString *cellIdentifier = @"AlbumCell";
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellIdentifier];
    
    if (!cell){
        
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:cellIdentifier];
    }
    
    cell.textLabel.text = [(Album *)albumContainer[indexPath.row] albumName];
    
    cell.detailTextLabel.text = [(Album *)albumContainer[indexPath.row] createTime];
    
    return cell;
    
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    
    selectedIndex = indexPath.row;
    
    [self performSegueWithIdentifier:@"ToPhotoView" sender:nil];
    
}

// for table view
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender{
    
    PhotoTableViewController *photoTableView = (PhotoTableViewController *)segue.destinationViewController;
    
    photoTableView.album = albumContainer[selectedIndex];
}

//- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender{
//    
//    PhototCollectionViewController *photoCollectionView = (PhototCollectionViewController *)segue.destinationViewController;
//    
//    photoCollectionView.album = albumContainer[selectedIndex];
//}
@end

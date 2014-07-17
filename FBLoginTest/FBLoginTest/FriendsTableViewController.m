//
//  FriendsTableViewController.m
//  FBLoginTest
//
//  Created by Wayne on 4/8/14.
//  Copyright (c) 2014 Wayne. All rights reserved.
//

#import "FriendsTableViewController.h"
#import "FriendCell.h"
#import "Friend.h"
#import "PhotoTableViewController.h"
#import "AlbumTableViewController.h"
#import "FBLoginTestAppDelegate.h"

@interface FriendsTableViewController (){
    int selectedIndex;
}

@end

@implementation FriendsTableViewController

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
    [super viewDidLoad];
    
    [gAppDelegate stopLoading];

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
    
    return [self.friends count];
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSString *const cellIdentifier = @"CellIdentifier";
    FriendCell *cell = [tableView dequeueReusableCellWithIdentifier:cellIdentifier];
    
    if(cell == nil){
        NSArray *views = [[NSBundle mainBundle] loadNibNamed:@"FriendCell" owner:nil options:nil];
        for(UIView *view in views){
            if([view isKindOfClass:[FriendCell class]]){
                cell = (FriendCell *)view;
            }
        }
    }
    
    cell.Name.text      = [self.friends[indexPath.row] firendName];
    cell.icon.profileID = [self.friends[indexPath.row] friendId];
    cell.brithday.text  = [self.friends[indexPath.row] friendBirthday];
    
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    
    selectedIndex = indexPath.row;
    
    [self performSegueWithIdentifier:@"ToAlbumView" sender:nil];
    
}

#pragma mark - Navigation

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    AlbumTableViewController *albumView = (AlbumTableViewController *)segue.destinationViewController;
    
    albumView.theFriend = self.friends[selectedIndex];
}


@end

//
//  MyAssetTableViewController.m
//  MyAssetDemo
//
//  Created by Wayne on 4/13/14.
//  Copyright (c) 2014 Wayne. All rights reserved.
//

#import "MyAssetTableViewController.h"
#import "AddConsumeTableViewController.h"
#import "Search.h"

@interface MyAssetTableViewController (){
    NSMutableArray *records;
}

@end

@implementation MyAssetTableViewController

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
    
    self.navigationItem.title = self.account.user_name;
    
    // Uncomment the following line to preserve selection between presentations.
    // self.clearsSelectionOnViewWillAppear = NO;
    
    // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
    // self.navigationItem.rightBarButtonItem = self.editButtonItem;
    
    records = [Search queryDateTimeWithUserID:self.account.user_id];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    // Return the number of sections.
    
    return [records count];
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    // Return the number of rows in the section.
    
    return 1;
}

- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section{
    
    NSString *title = [(DateTime *)records[section] date];
    
    return [title substringToIndex:16];
    
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSString *const CellIdentifier = @"myAssetCell";
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier forIndexPath:indexPath];
    
    if (cell == nil){
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:CellIdentifier];
    }
    
    cell.textLabel.text = [(DateTime *)records[indexPath.section] item];
    
    cell.detailTextLabel.text = [(DateTime *)records[indexPath.section] cost];
    
    return cell;
}

/*
// Override to support conditional editing of the table view.
- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath
{
    // Return NO if you do not want the specified item to be editable.
    return YES;
}
*/

/*
// Override to support editing the table view.
- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        // Delete the row from the data source
        [tableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationFade];
    } else if (editingStyle == UITableViewCellEditingStyleInsert) {
        // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
    }   
}
*/

/*
// Override to support rearranging the table view.
- (void)tableView:(UITableView *)tableView moveRowAtIndexPath:(NSIndexPath *)fromIndexPath toIndexPath:(NSIndexPath *)toIndexPath
{
}
*/

/*
// Override to support conditional rearranging of the table view.
- (BOOL)tableView:(UITableView *)tableView canMoveRowAtIndexPath:(NSIndexPath *)indexPath
{
    // Return NO if you do not want the item to be re-orderable.
    return YES;
}
*/


#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    AddConsumeTableViewController *addConsume = (AddConsumeTableViewController *)segue.destinationViewController;
    addConsume.account = self.account;
    addConsume.delegate = self;
}

- (void)reload{
    
    records = [Search queryDateTimeWithUserID:self.account.user_id];
    
    [self.tableView reloadData];
    
}

- (IBAction)clickLogout:(UIBarButtonItem *)sender {
    
    [[[UIAlertView alloc] initWithTitle:@"Log out" message:[NSString stringWithFormat:@"Bye, %@",self.account.user_name] delegate:nil cancelButtonTitle:@"OK" otherButtonTitles: nil] show];
    
    [self dismissViewControllerAnimated:YES completion:^{
        nil;
    }];
}
@end

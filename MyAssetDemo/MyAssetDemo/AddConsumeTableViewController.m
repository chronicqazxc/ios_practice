//
//  AddConsumeTableViewController.m
//  MyAssetDemo
//
//  Created by Wayne on 4/13/14.
//  Copyright (c) 2014 Wayne. All rights reserved.
//

#import "AddConsumeTableViewController.h"
#import "MyAssetTableViewController.h"
#import "ItemViewController.h"
#import "CostViewController.h"
#import "AddData.h"
#import "DateTime.h"

@interface AddConsumeTableViewController (){
    NSString *itemName;
    NSString *date;
    NSString *cost;
}

@end

@implementation AddConsumeTableViewController

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
    itemName = @"";
    
    // Uncomment the following line to preserve selection between presentations.
    // self.clearsSelectionOnViewWillAppear = NO;
    
    // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
    // self.navigationItem.rightBarButtonItem = self.editButtonItem;
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
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    // Return the number of rows in the section.
    return 3;
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSString *const CellIdentifier = @"addConsumeCell";
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier forIndexPath:indexPath];
    
    if (cell == nil){
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:CellIdentifier];
    }

    NSString *title, *subtitle;
    
    switch(indexPath.row){
        case 0:
            title = @"Item";
            subtitle = itemName;
            break;
        case 1:
            title = @"Time";
//            subtitle = date;
            subtitle = [date substringToIndex:16];
            break;
        case 2:
            title = @"Cost";
            subtitle = cost;
            break;
    }
    cell.textLabel.text = title;
    cell.detailTextLabel.text = subtitle;
    
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    
    switch (indexPath.row){
        case 0:
            [self performSegueWithIdentifier:@"ToAddItem" sender:nil];
            
            break;
        case 1:
            [self performSegueWithIdentifier:@"ToPickDate" sender:nil];
            break;
        case 2:
            [self performSegueWithIdentifier:@"ToCostView" sender:nil];
            break;
    }
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

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    if ([segue.identifier isEqualToString:@"ToAddItem"]){
        ItemViewController *itemViewController = (ItemViewController *)segue.destinationViewController;
        itemViewController.delegate = self;
    }else if([segue.identifier isEqualToString:@"ToPickDate"]){
        PickDateViewController *pickDateViewController = (PickDateViewController *)segue.destinationViewController;
        pickDateViewController.delegate = self;
    }else if([segue.identifier isEqualToString:@"ToCostView"]){
        CostViewController *costViewController = (CostViewController *)segue.destinationViewController;
        costViewController.delegate = self;
    }
}


- (IBAction)clickCancel:(UIBarButtonItem *)sender {
    [self dismissViewControllerAnimated:YES completion:^{
        nil;
    }];
}

- (IBAction)clickSave:(UIBarButtonItem *)sender {
    
    DateTime *dateTime = [[DateTime alloc] init];
    
    dateTime.date = date;
    dateTime.userID = self.account.user_id;
    dateTime.item = itemName;
    dateTime.cost = cost;
    
    if([AddData addDateWithDateTime:dateTime]){
        [self.delegate reload];
        
        [[[UIAlertView alloc] initWithTitle:@"Add data" message:@"success" delegate:nil cancelButtonTitle:@"OK" otherButtonTitles: nil] show];
        
        [self dismissViewControllerAnimated:YES completion:^{
            nil;
        }];
    }else{
        NSLog(@"Add data error!");
    }
    
}

#pragma mark - 
#pragma mark ItemViewControllerDelegate

- (void)reloadWithItem:(NSString *)item{
    itemName = item;
    [self.tableView reloadData];
}


#pragma mark PickDateViewControllerDelegate

- (void)reloadDataWithDate:(NSString *)aDate{
    date = aDate;
    [self.tableView reloadData];
}


#pragma mark CostViewControllerDelegate

- (void)reloadWithCost:(NSString *)aCost{
    cost = aCost;
    [self.tableView reloadData];
}
@end

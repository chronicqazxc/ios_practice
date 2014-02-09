//
//  TableViewController.m
//  CoreDataTest3
//
//  Created by Wayne on 2/8/14.
//  Copyright (c) 2014 Wayne. All rights reserved.
//

#import "TableViewController.h"
#import "Customer.h"
#import "Car.h"
#import "CoreDataOperator.h"
#import "ImageViewController.h"

@interface TableViewController (){
    Customer *customer;
    Car *car;
    UITableViewCell *tableViewCell;
    NSIndexPath *currentIndexPath;
    NSMutableDictionary *customersDictionary;
}

@end

@implementation TableViewController

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

    // Uncomment the following line to preserve selection between presentations.
    // self.clearsSelectionOnViewWillAppear = NO;
 
    // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
    // self.navigationItem.rightBarButtonItem = self.editButtonItem;
    currentIndexPath = [[NSIndexPath alloc]init];
    customersDictionary = [[NSMutableDictionary alloc]initWithDictionary:_individualCustomersDictionary];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
//#warning Potentially incomplete method implementation.
    // Return the number of sections.
    return [[customersDictionary allKeys]count];
}
- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section{
    NSString *header;
    int i;
    for(i=1;i<[[customersDictionary allKeys]count]+1;i++){
        customer = [customersDictionary objectForKey:[customersDictionary allKeys][section]][0];
        header = [NSString stringWithFormat:@"ID: %@ Name: %@",customer.customerId,customer.customerName];
    }
    
    return header;
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
//#warning Incomplete method implementation.
    // Return the number of rows in the section.
    NSInteger number;
//    switch (section){
//        case 0:
//            number = 1;
//            break;
//        case 1:
//            number = 2;
//            break;
//    }
    NSArray *cars = [[NSArray alloc]init];
    cars =[customersDictionary objectForKey:[customersDictionary allKeys][section]][1];
    number = [cars count];
    return number;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"Cell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier forIndexPath:indexPath];
    
    // Configure the cell...
    if(cell == nil){
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
    }
    
    int i;
    for(i=0;i<=indexPath.section;i++){
        cell.textLabel.text = [[[customersDictionary objectForKey:[customersDictionary allKeys][indexPath.section]][1] objectAtIndex:indexPath.row] plate];
    }
    tableViewCell = cell;
    return cell;
}

- (UITableViewCellEditingStyle)tableView:(UITableView *)tableView editingStyleForRowAtIndexPath:(NSIndexPath *)indexPath{
    return UITableViewCellEditingStyleDelete;
}

- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath{
    UITableViewCell *cell = [tableView cellForRowAtIndexPath:indexPath];
    CoreDataOperator *coreDataOperator = [[CoreDataOperator alloc]init];
    [coreDataOperator deleteCarByPlate:cell.textLabel.text];
    
    [[customersDictionary objectForKey:[customersDictionary allKeys][indexPath.section]][1] removeObjectAtIndex:indexPath.row];
    
    [tableView deleteRowsAtIndexPaths:[NSArray arrayWithObject:indexPath] withRowAnimation:UITableViewRowAnimationTop];
}

//- (void)tableView:(UITableView *)tableView didDeselectRowAtIndexPath:(NSIndexPath *)indexPath{
//    NSLog(@"click");
//    currentIndexPath = indexPath;
//    [self performSegueWithIdentifier:@"showImageView" sender:tableView];
//}

- (void)tableView:(UITableView *)tableView accessoryButtonTappedForRowWithIndexPath:(NSIndexPath *)indexPath{
    currentIndexPath = indexPath;
    [self performSegueWithIdentifier:@"showImageView" sender:tableView];
}
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)senders{
    if([segue.identifier isEqualToString:@"showImageView"]){
        ImageViewController *imageView = segue.destinationViewController;
        imageView.image = [[customersDictionary objectForKey:[customersDictionary allKeys][currentIndexPath.section]][1][currentIndexPath.row] image];
        imageView.navigatTitle = [[customersDictionary objectForKey:[customersDictionary allKeys][currentIndexPath.section]][1][currentIndexPath.row] plate];
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
    }   
    else if (editingStyle == UITableViewCellEditingStyleInsert) {
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

/*
#pragma mark - Navigation

// In a story board-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}

 */
@end

//
//  MasterViewController.m
//  NovelDemo2
//
//  Created by Wayne on 1/15/14.
//  Copyright (c) 2014 Wayne. All rights reserved.
//
typedef enum{
    scopeTitle,
    scopeContent
}searchScope;

#import "MasterViewController.h"

//#import "DetailViewController.h"

@interface MasterViewController () {
    NSMutableArray *_objects;
}
@end

@implementation MasterViewController{
    NSArray *titlesArray;
    NSMutableArray *searchResultsArray;
    searchScope decision;
    DatabaseSQLite *database;
    UITableView *currentTableView;
    UITableViewCell *currentCell;
}

- (void)awakeFromNib
{
    [super awakeFromNib];
}

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view, typically from a nib.
//    self.navigationItem.leftBarButtonItem = self.editButtonItem;
//
//    UIBarButtonItem *addButton = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemAdd target:self action:@selector(insertNewObject:)];
//    self.navigationItem.rightBarButtonItem = addButton;
    
    searchResultsArray = [[NSMutableArray alloc] init];
    titlesArray        = [[NSArray alloc] init];
    database           = [[DatabaseSQLite alloc] init];
    titlesArray        = [database catagories];
    self.title         = @"三國演義";
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)insertNewObject:(id)sender
{
    if (!_objects) {
        _objects = [[NSMutableArray alloc] init];
    }
    [_objects insertObject:[NSDate date] atIndex:0];
    NSIndexPath *indexPath = [NSIndexPath indexPathForRow:0 inSection:0];
    [self.tableView insertRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationAutomatic];
}

#pragma mark - < Table View >

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    NSInteger rows = 0;
    if(tableView == [self.searchDisplayController searchResultsTableView] ){
        // Search screen
        rows = [searchResultsArray count];
    }else{
        rows = [titlesArray count];
    }
    return rows;
}

// Return table cell element from indexPath
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
//    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"CellforIndexPath:indexPath];
//    NSDate *object = _objects[indexPath.row];
//    cell.textLabel.text = [object description];
//    return cell;
    
    // Initial cell
    static NSString *CellIdentifier = @"MaterCell";
    UITableViewCell *cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:CellIdentifier];
    cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
    
    
    // Determind the source for text of cell label
    if(tableView == [self.searchDisplayController searchResultsTableView]){
        cell.textLabel.text = [searchResultsArray objectAtIndex: indexPath.row];
    }else{
        cell.textLabel.text = [titlesArray objectAtIndex: indexPath.row];
    }
    return cell;
}

// When click on table cell
-(void) tableView: (UITableView *) tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    currentTableView = tableView;
    currentCell = [tableView cellForRowAtIndexPath:indexPath];
    [self performSegueWithIdentifier:@"PageViewSegue" sender: nil];
}
- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath
{
    // Return NO if you do not want the specified item to be editable.
    return YES;
}

- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        [_objects removeObjectAtIndex:indexPath.row];
        [tableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationFade];
    } else if (editingStyle == UITableViewCellEditingStyleInsert) {
        // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view.
    }
}

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


- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
//    if ([[segue identifier] isEqualToString:@"showDetail"]) {
//        NSIndexPath *indexPath = [self.tableView indexPathForSelectedRow];
//        NSDate *object = _objects[indexPath.row];
//        [[segue destinationViewController] setDetailItem:object];
//}
    
    PageViewController *pageViewController = (PageViewController *)segue.destinationViewController;
    NSIndexPath *indexPath;
    // Determind the source for text of cell label
    if(currentTableView == [self.searchDisplayController searchResultsTableView]){
        indexPath = [[self.searchDisplayController searchResultsTableView] indexPathForSelectedRow];
        pageViewController.startPage = [database indexForTitle:currentCell.textLabel.text];
    }else{
        indexPath = self.tableView.indexPathForSelectedRow;
        pageViewController.startPage = indexPath.row + 1;
    }
}

#pragma mark - < Search bar >
#pragma mark text did change
-(void) searchBar:(UISearchBar *) searchBar textDidChange: (NSString *) searchText{
//    [searchResultsArray removeAllObjects];
//    [searchResultsArray addObjectsFromArray:titlesArray];
//    [searchResultsArray filterUsingPredicate: [NSPredicate predicateWithFormat: @"SELF contains[c]%@",searchText]];
    
    [searchResultsArray removeAllObjects];
    
    switch(decision){
        case scopeTitle:
            [searchResultsArray addObjectsFromArray:[database titlesByInput: searchText]];
            break;
        case scopeContent:
            [searchResultsArray addObjectsFromArray:[database contentsByInput: searchText]];
            break;
    }
}

#pragma mark click search
-(void) searchBarSearchButtonClicked: (UISearchBar *) searchBar{
//    [searchResultsArray removeAllObjects];
//    
//    switch(decision){
//        case scopeTitle:
//            [searchResultsArray addObjectsFromArray:[database titlesByInput: searchBar.text]];
//            break;
//        case scopeContent:
//            [searchResultsArray addObjectsFromArray:[database contentsByInput: searchBar.text]];
//            break;
//    }
    [searchBar resignFirstResponder];
}

#pragma mark click cancel
-(void) searchBarCancelButtonClicked:(UISearchBar *) searchBar{
    [searchBar resignFirstResponder];
}

#pragma mark click scope
- (void)searchBar:(UISearchBar *)searchBar selectedScopeButtonIndexDidChange:(NSInteger)selectedScope {
    decision = selectedScope;
}
@end




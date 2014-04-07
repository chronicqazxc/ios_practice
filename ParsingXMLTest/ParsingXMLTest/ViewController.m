//
//  ViewController.m
//  ParsingXMLTest
//
//  Created by Wayne on 4/5/14.
//  Copyright (c) 2014 Wayne. All rights reserved.
//

#import "ViewController.h"
#import "AppDelegate.h"
#import "MyXMLData.h"
#import "TableViewCell.h"
#import "WebViewController.h"

#define kCustomRowCount     1

static NSString *const CellIdentifier = @"TableCell";
static NSString *const PlaceholderCellIdentifier = @"PlaceholderCell";

@interface ViewController (){
    NSString *link;
}
- (UITableViewCell *)performPlaceHolderCell:(UITableView *)tableView;
- (UITableViewCell *)performCustomCell:(UITableView *)tableView indexPath:(NSIndexPath *)indexPath;
- (TableViewCell *)findCustomCell:(UITableView *)tableView;
@end

@implementation ViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    AppDelegate *appDelegate = (AppDelegate *)[[UIApplication sharedApplication] delegate];
    appDelegate.viewController = self;
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
}


#pragma mark - UITableViewDataSource
#pragma mark init
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    int count = [_datas count];
    
    if(count ==0){
        return kCustomRowCount;
    }
    
    return count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    if([_datas count] == 0 && indexPath.row == 0)
        return [self performPlaceHolderCell:tableView];
    else
        return [self performCustomCell:tableView indexPath:indexPath];
}

- (UITableViewCell *)performPlaceHolderCell:(UITableView *)tableView{
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:PlaceholderCellIdentifier                                                              ];
    if(cell == nil){
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:PlaceholderCellIdentifier];
        cell.detailTextLabel.textAlignment = NSTextAlignmentCenter;
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
    }
    cell.detailTextLabel.text = @"Loading...";
    
    return cell;
}

- (UITableViewCell *)performCustomCell:(UITableView *)tableView indexPath:(NSIndexPath *)indexPath{
    
    MyXMLData *xmlData = _datas[indexPath.row];
    
    TableViewCell *cell = [self findCustomCell:tableView];
    cell.title.text = xmlData.title;
    cell.author.text = xmlData.author;
    cell.description.text = xmlData.description;
    
    return cell;
}

- (TableViewCell *)findCustomCell:(UITableView *)tableView{
    
    TableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    
    if(cell == nil){
        NSArray *views = [[NSBundle mainBundle] loadNibNamed:@"TableViewCell" owner:nil options:nil];
        for(UIView *view in views){
            if([view isKindOfClass:[TableViewCell class]]){
                cell = (TableViewCell *)view;
            }
        }
    }
    
    return cell;
}

#pragma mark select
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    link = [_datas[indexPath.row] link];
    [self performSegueWithIdentifier:@"SegueToWebView" sender:nil];
}

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender{
    WebViewController *webViewController = (WebViewController *) segue.destinationViewController;
    webViewController.link = link;
}
@end

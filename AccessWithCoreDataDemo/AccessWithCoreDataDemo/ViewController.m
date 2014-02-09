//
//  ViewController.m
//  CoreDataTest3
//
//  Created by Wayne on 2/8/14.
//  Copyright (c) 2014 Wayne. All rights reserved.
//

#import "ViewController.h"
#import "Customer.h"
#import "Car.h"
#import "TableViewController.h"
#import "CoreDataOperator.h"
#import "ManageViewController.h"

@interface ViewController (){
    Customer *customer;
    Car *car;
    CoreDataOperator *coreDataOperator;
    
    NSArray *individualCustomers;
    NSArray *cars;
    NSMutableArray *carsBelongCustomer;
    
    int determind;
    NSString *templateName;
    NSString *templateKey;
}

@end

@implementation ViewController

@synthesize individualCustomersDictionary = _individualCustomersDictionary;

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view, typically from a nib.
    _customerId.enabled = 1;
    _customerName.enabled = 1;
    _carPlate.enabled = 1;
    _imageURL.enabled = 1;
    _searchButton.enabled = 0;
    _addButton.enabled = 1;
    _customerId.delegate = self;
    _customerName.delegate = self;
    _carPlate.delegate = self;
    _imageURL.delegate = self;
    _individualCustomersDictionary = [[NSMutableDictionary alloc]init];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)viewDidDisappear:(BOOL)animated{
    [super viewDidDisappear:animated];
    [coreDataOperator saveContext];
}

- (IBAction)clickAdd:(UIButton *)sender {
    NSURL *url = [NSURL URLWithString:_imageURL.text];
    NSData *imageData = [NSData dataWithContentsOfURL:url];
    UIImage *image = [UIImage imageWithData:imageData];
    
    coreDataOperator = [[CoreDataOperator alloc]init];
    if([coreDataOperator addCustomerWithId:_customerId.text andName:_customerName.text andPlate:_carPlate.text andImage:image]){
        UIAlertView *alertView = [[UIAlertView alloc]initWithTitle:@"Add" message:@"Success" delegate:self cancelButtonTitle:@"OK" otherButtonTitles: nil];
        [alertView show];
        _customerId.text = nil;
        _customerName.text = nil;
        _carPlate.text = nil;
        _imageURL.text = nil;
    };

}

- (IBAction)clickSearch:(UIButton *)sender {
    NSString *condition;
    switch(determind){
        case 1:
            condition = _customerId.text;
            break;
        case 2:
            condition = _customerName.text;
            break;
        case 3:
            condition = _carPlate.text;
            break;
    }
    coreDataOperator = [[CoreDataOperator alloc]init];
    _individualCustomersDictionary = [coreDataOperator searchByDetermind:determind withCondition:condition];
    [self performSegueWithIdentifier:@"TableView" sender:nil];
}

- (IBAction)handleSegment:(UISegmentedControl *)sender {
    switch(sender.selectedSegmentIndex){
        case 0:
            _customerId.enabled = 1;
            _customerName.enabled = 1;
            _carPlate.enabled = 1;
            _imageURL.enabled = 1;
            _searchButton.enabled = 0;
            _addButton.enabled = 1;
            break;
        case 1:
            _customerId.enabled = 1;
            _customerName.enabled = 0;
            _carPlate.enabled = 0;
            _imageURL.enabled = 0;
            _customerName.text = nil;
            _carPlate.text = nil;
            _imageURL.text = nil;
            _searchButton.enabled = 1;
            _addButton.enabled = 0;
            [_customerId becomeFirstResponder];
            determind = 1;
            break;
        case 2:
            _customerId.enabled = 0;
            _customerName.enabled = 1;
            _carPlate.enabled = 0;
            _imageURL.enabled = 0;
            _customerId.text = nil;
            _carPlate.text = nil;
            _imageURL.text = nil;
            _searchButton.enabled = 1;
            _addButton.enabled = 0;
            [_customerName becomeFirstResponder];
            determind = 2;
            break;
        case 3:
            _customerId.enabled = 0;
            _customerName.enabled = 0;
            _carPlate.enabled = 1;
            _imageURL.enabled = 0;
            _customerId.text = nil;
            _customerName.text = nil;
            _imageURL.text = nil;
            _searchButton.enabled = 1;
            _addButton.enabled = 0;
            [_carPlate becomeFirstResponder];
            determind = 3;
            break;
    }
}

-(void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender{
    if([segue.identifier isEqualToString:@"TableView"]){
        TableViewController *tableView = (TableViewController *)segue.destinationViewController;
        tableView.individualCustomersDictionary = [[NSMutableDictionary alloc]initWithDictionary:_individualCustomersDictionary];
    }else if([segue.identifier isEqualToString:@"manageView"]){
        coreDataOperator = [[CoreDataOperator alloc]init];
        ManageViewController *manageView = (ManageViewController *)segue.destinationViewController;
        manageView.allCustomersArray = [coreDataOperator fetchAllCustomers];
    }
}

- (BOOL)textFieldShouldReturn:(UITextField *)textField{
    if([textField isFirstResponder])
        [textField resignFirstResponder];
    return 1;
}
@end

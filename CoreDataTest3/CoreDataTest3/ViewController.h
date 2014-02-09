//
//  ViewController.h
//  CoreDataTest3
//
//  Created by Wayne on 2/8/14.
//  Copyright (c) 2014 Wayne. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ViewController : UIViewController <UITextFieldDelegate, UIAlertViewDelegate>
@property (strong, nonatomic) IBOutlet UITextField *customerId;
@property (strong, nonatomic) IBOutlet UITextField *customerName;
@property (strong, nonatomic) IBOutlet UITextField *carPlate;
@property (strong, nonatomic) IBOutlet UITextField *imageURL;
- (IBAction)clickAdd:(UIButton *)sender;
- (IBAction)clickSearch:(UIButton *)sender;
- (IBAction)handleSegment:(UISegmentedControl *)sender;
@property (strong, nonatomic) IBOutlet UIButton *addButton;
@property (strong, nonatomic) IBOutlet UIButton *searchButton;
@property (nonatomic) NSMutableDictionary *individualCustomersDictionary;
@end

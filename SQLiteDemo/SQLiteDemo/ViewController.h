//
//  ViewController.h
//  SQLiteDemo
//
//  Created by Wayne on 1/11/14.
//  Copyright (c) 2014 Wayne. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ViewController : UIViewController <UIAlertViewDelegate, UITextFieldDelegate>
- (IBAction)loadDB:(UIButton *)sender;
- (IBAction)insertDB:(UIButton *)sender;

-(NSString *) databasePathWithName: (NSString *) databaseName;
-(void) initializeDatabase: (NSString *) databaseName;
-(void) readDataFromPath: (NSString *) databasePath;
@property (strong, nonatomic) IBOutlet UITextField *inputName;
@property (strong, nonatomic) IBOutlet UITextField *inputCarId;
@property (strong, nonatomic) IBOutlet UIButton *buttonSearch;

@property NSInteger determind;
@property (strong, nonatomic) NSString *receiveCar_id;


@end

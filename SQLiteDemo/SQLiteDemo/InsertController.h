//
//  InsertController.h
//  SQLiteDemo
//
//  Created by Wayne on 1/13/14.
//  Copyright (c) 2014 Wayne. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface InsertController : UIViewController <UIAlertViewDelegate, UITextFieldDelegate>
- (IBAction)submit:(UIButton *)sender;
- (IBAction)clickDelete:(UIButton *)sender;
- (IBAction)back:(UIButton *)sender;

@property (strong, nonatomic) IBOutletCollection(UITextField) NSArray *inputFields;
@property (strong, nonatomic) NSString *databasePath;
@property NSInteger determind;

@property (strong, nonatomic) NSMutableDictionary *dataDict;

-(BOOL) check;
-(void) alert:(NSString *) message;
-(void) setValueToField;
-(void) setBackgroundImg:(NSString *) imgName;
@end

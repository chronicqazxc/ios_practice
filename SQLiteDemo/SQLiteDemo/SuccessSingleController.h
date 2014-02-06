//
//  SuccessSingleController.h
//  SQLiteDemo
//
//  Created by Wayne on 1/12/14.
//  Copyright (c) 2014 Wayne. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface SuccessSingleController : UIViewController
@property (strong, nonatomic) IBOutlet UILabel *successName;
@property (strong, nonatomic) IBOutlet UILabel *successPhone;
@property (strong, nonatomic) IBOutlet UILabel *successAddress;
@property (strong, nonatomic) IBOutlet UILabel *successBrand;
@property (strong, nonatomic) IBOutlet UILabel *successCar;
@property (strong, nonatomic) IBOutlet UILabel *successYear;
@property (strong, nonatomic) IBOutlet UILabel *successPrice;
@property (strong, nonatomic) IBOutlet UILabel *successKilometer;
@property (strong, nonatomic) IBOutlet UILabel *successCar_id;


@property (strong, nonatomic) NSString *databasePath;
@property NSInteger count;
@property (strong, nonatomic) NSMutableDictionary *dataDict;
- (IBAction)edit:(UIButton *)sender;
- (IBAction)back:(UIButton *)sender;
-(void) setBackgroundImg:(NSString *) imgName;
@end

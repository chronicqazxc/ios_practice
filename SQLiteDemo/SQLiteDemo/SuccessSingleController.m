//
//  SuccessSingleController.m
//  SQLiteDemo
//
//  Created by Wayne on 1/12/14.
//  Copyright (c) 2014 Wayne. All rights reserved.
//

#import "SuccessSingleController.h"
#import "InsertController.h"

@interface SuccessSingleController ()

@end

@implementation SuccessSingleController{
    NSMutableArray
            // Seller array (Use for transition to SuccessSingleController)
                *arrayId,
                *arrayName,
                *arrayGender,
                *arrayAge,
                *arrayPhone,
                *arrayAddress,
            // Car array (Use for transition to SuccessSingleController)
                *arrayCar_id,
                *arrayBrand,
                *arrayType,
                *arrayCar_name,
                *arrayYear,
                *arrayPrice,
                *arrayKilometer;
    NSString
        // Seller element
            *nid,
            *name,
            *gender,
            *age,
            *phone,
            *address,
        // Car element (Use for receive result from sql be executed, and set to array)
            *car_id,
            *brand,
            *type,
            *car_name,
            *year,
            *price,
            *kilometer;
}

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view.
    arrayId         = [_dataDict objectForKey:@"nid"];
    arrayName       = [_dataDict objectForKey:@"name"];
    arrayGender     = [_dataDict objectForKey:@"gender"];
    arrayAge        = [_dataDict objectForKey:@"age"];
    arrayPhone      = [_dataDict objectForKey:@"phone"];
    arrayAddress    = [_dataDict objectForKey:@"address"];
    arrayCar_id     = [_dataDict objectForKey:@"car_id"];
    arrayBrand      = [_dataDict objectForKey:@"product"];
    arrayType       = [_dataDict objectForKey:@"type"];
    arrayCar_name   = [_dataDict objectForKey:@"car_name"];
    arrayYear       = [_dataDict objectForKey:@"year"];
    arrayPrice      = [_dataDict objectForKey:@"price"];
    arrayKilometer  = [_dataDict objectForKey:@"kilometer"];
    NSInteger i;
    for(i=0; i<_count; i++){
        name        = [arrayName objectAtIndex:i];
        phone         = [arrayPhone objectAtIndex:i];
        address     = [arrayAddress objectAtIndex:i];
        car_id      = [arrayCar_id objectAtIndex:i];
        brand       = [arrayBrand objectAtIndex:i];
        car_name    = [arrayCar_name objectAtIndex:i];
        year        = [arrayYear objectAtIndex:i];
        price       = [arrayPrice objectAtIndex:i];
        kilometer   = [arrayKilometer objectAtIndex:i];
    }
    
    _successName.text       = name;
    _successPhone.text      = phone;
    _successAddress.text    = address;
    _successAddress.text    = address;
    _successCar_id.text     = car_id;
    _successBrand.text      = brand;
    _successCar.text        = car_name;
    _successYear.text       = year;
    _successPrice.text      = price;
    _successKilometer.text  = kilometer;
    
    int random = arc4random() % 10 + 1;
    [self setBackgroundImg:[NSString stringWithFormat:@"%d.jpg",random]];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void) setBackgroundImg:(NSString *) imgName{
    
    // set background img
    UIGraphicsBeginImageContext(self.view.frame.size);
    [[UIImage imageNamed:[NSString stringWithFormat:@"%@.jpg",imgName]] drawInRect:self.view.bounds];
    UIImage *image = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    
    self.view.backgroundColor = [UIColor colorWithPatternImage: image];
}

// click edit
- (IBAction)edit:(UIButton *)sender{
    [self performSegueWithIdentifier:@"edit" sender: sender];
}

- (IBAction)back:(UIButton *)sender{
    [self performSegueWithIdentifier:@"backToMain" sender: nil];
}

-(void) prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender{
    if ([[segue identifier] isEqualToString:@"edit"]){
        InsertController *insert = (InsertController *)segue.destinationViewController;
        insert.dataDict = _dataDict;
        insert.determind = [(UIButton *)sender tag];
        insert.databasePath = _databasePath;
    }
}
@end

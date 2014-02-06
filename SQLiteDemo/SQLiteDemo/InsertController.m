//
//  InsertController.m
//  SQLiteDemo
//
//  Created by Wayne on 1/13/14.
//  Copyright (c) 2014 Wayne. All rights reserved.
//
typedef enum{
    nid,
    name,
    gender,
    age,
    phone,
    address,
    car_id,
    type,
    brand,
    car_name,
    year,
    price,
    kilometer,
    backToMain = 95,
    backToSuccess,
    add,
    delete,
    edit
}Files;

#import "InsertController.h"
#import <sqlite3.h>
#import "ViewController.h"

@interface InsertController ()

@end

@implementation InsertController{
    NSMutableArray
            // Seller array
                *arrayId,
                *arrayName,
                *arrayGender,
                *arrayAge,
                *arrayPhone,
                *arrayAddress,
            // Car array
                *arrayCar_id,
                *arrayBrand,
                *arrayType,
                *arrayCar_name,
                *arrayYear,
                *arrayPrice,
                *arrayKilometer;
    UITextField
            // Seller element
                *fnid,
                *fname,
                *fgender,
                *fage,
                *fphone,
                *faddress,
            // Car element
                *fcar_id,
                *fbrand,
                *ftype,
                *fcar_name,
                *fyear,
                *fprice,
                *fkilometer;
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
    int random = arc4random() % 10 + 1;
    [self setBackgroundImg:[NSString stringWithFormat:@"%d.jpg",random]];
    
    int i;
//    NSLog(@"database:%@",_databasePath);
    for(i=0; i<[_inputFields count]; i++){
        [_inputFields[i] setDelegate:self];
    }
    [_inputFields[nid] becomeFirstResponder];
    if(_determind == edit){
        [self setValueToField];
    }
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

// add
-(void) addDataToPath:(NSString *)databasePath
               withId:(NSString *)nid
                 name:(NSString *)name
               gender:(NSString *)gender
                  age:(NSString *)age
                phone:(NSString *)phone
              address:(NSString *)address
               car_id:(NSString *)car_id
                brand:(NSString *)brand
                 type:(NSString *)type
             car_name:(NSString *)car_name
                 year:(NSString *)year
                price:(NSString *)price
            kilometer:(NSString *)kilometer{
    sqlite3 *database;
    if(sqlite3_open([databasePath UTF8String], &database) == SQLITE_OK){
        
        NSString *stmtSeller, *stmtCar;
        NSMutableString *sql;
        sql = [[NSMutableString alloc]init];
        
        switch(_determind){
            case add:
                stmtSeller = [[NSString alloc] initWithFormat:
                                 @" insert into seller values('%@','%@','%@','%@','%@','%@','%@');",
                                 nid,name,gender,age,phone,address,car_id];
                stmtCar = [[NSString alloc] initWithFormat:
                               @"insert into car values('%@','%@','%@','%@','%@','%@','%@');",
                               car_id,brand,type,car_name,year,price,kilometer];
        
                break;
            case edit:
                stmtSeller = [[NSString alloc] initWithFormat:
                              @"UPDATE Seller SET  name='%@', gender='%@', age='%@', phone='%@', address='%@' WHERE car_id='%@';\n",name,gender,age,phone,address,car_id];
                stmtCar = [[NSString alloc] initWithFormat:
                           @"UPDATE Car SET  product='%@', type='%@', name='%@', year='%@', price='%@', kilometer='%@' WHERE car_id='%@';",brand,type,car_name,year,price,kilometer,car_id];
                break;
            case delete:
                stmtSeller = [[NSString alloc] initWithFormat:
                              @"DELETE FROM Seller WHERE car_id='%@';",car_id];
                stmtCar = [[NSString alloc] initWithFormat:
                           @"DELETE FROM Car WHERE car_id='%@';",car_id];
                break;
            default:
                break;
        }
        
        sql = [[NSMutableString alloc] initWithString: stmtSeller];
        [sql appendString: stmtCar];
        
        char *error;
        if(sqlite3_exec(database,[sql UTF8String],NULL,NULL,&error) == SQLITE_OK){
            int i;
            for(i=0;i < [_inputFields count];i++){
                [_inputFields[i] setEnabled:0];
            }
            UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Result" message:@"Success" delegate:self cancelButtonTitle:@"OK" otherButtonTitles:nil];
            [alert show];
        }else{
            [self alert:@"insert faild"];
        }
    }
}

// click submit
- (IBAction)submit:(UIButton *)sender{
    //    NSLog(@"type:%@",[_inputFields[nid] text]);
    if([self check]){
        if(_determind == edit){
            [self alert:@"Are you sure to edit?"];
        }else{
            [self addDataToPath:_databasePath
                         withId:[_inputFields[nid] text]
                           name:[_inputFields[name] text]
                         gender:[_inputFields[gender] text]
                            age:[_inputFields[age] text]
                          phone:[_inputFields[phone] text]
                        address:[_inputFields[address] text]
                         car_id:[_inputFields[car_id] text]
                          brand:[_inputFields[brand] text]
                           type:[_inputFields[type] text]
                       car_name:[_inputFields[car_name] text]
                           year:[_inputFields[year] text]
                          price:[_inputFields[price] text]
                      kilometer:[_inputFields[kilometer] text]];
        }
    }
}

// press return
-(BOOL) textFieldShouldReturn: (UITextField *) textField{
    [textField resignFirstResponder];
    
    switch(textField.tag){
        case 0:
            if([[_inputFields[nid] text] length] == 0){
                [self alert:@"not null"];
                [_inputFields[nid] becomeFirstResponder];
                break;
            }
            [_inputFields[name] becomeFirstResponder];
            break;
        case 1:
            if([[_inputFields[name] text] length] == 0){
                [self alert:@"not null"];
                [_inputFields[name] becomeFirstResponder];
                break;
            }
            [_inputFields[gender] becomeFirstResponder];
            break;
        case 2:
            if([[_inputFields[gender] text] length] == 0){
                [self alert:@"not null"];
                [_inputFields[gender] becomeFirstResponder];
                break;
            }
            [_inputFields[age] becomeFirstResponder];
            break;
        case 3:
            if([[_inputFields[age] text] length] == 0){
                [self alert:@"not null"];
                [_inputFields[age] becomeFirstResponder];
                break;
            }
            [_inputFields[phone] becomeFirstResponder];
            break;
        case 4:
            if([[_inputFields[phone] text] length] ==0){
                [self alert:@"not null"];
                [_inputFields[phone] becomeFirstResponder];
                break;
            }
            [_inputFields[address] becomeFirstResponder];
            break;
        case 5:
            if([[_inputFields[address] text] length] ==0){
                [self alert:@"not null"];
                [_inputFields[address] becomeFirstResponder];
                break;
            }
            [_inputFields[car_id] becomeFirstResponder];
            break;
        case 6:
            if([[_inputFields[car_id] text] length] == 0){
                [self alert:@"not null"];
                [_inputFields[car_id] becomeFirstResponder];
                break;
            }
            [_inputFields[type] becomeFirstResponder];
            break;
        case 7:
            if([[_inputFields[type] text] length] ==0){
                [self alert:@"not null"];
                [_inputFields[type] becomeFirstResponder];
                break;
            }
            [_inputFields[brand] becomeFirstResponder];
            break;
        case 8:
            if([[_inputFields[brand] text] length] ==0){
                [self alert:@"not null"];
                [_inputFields[brand] becomeFirstResponder];
                break;
            }
            [_inputFields[car_name] becomeFirstResponder];
            break;
        case 9:
            if([[_inputFields[car_name] text] length] ==0){
                [self alert:@"not null"];
                [_inputFields[car_name] becomeFirstResponder];
                break;
            }
            [_inputFields[year] becomeFirstResponder];
            break;
        case 10:
            if([[_inputFields[year] text] length] ==0){
                [self alert:@"not null"];
                [_inputFields[year] becomeFirstResponder];
                break;
            }
            [_inputFields[price] becomeFirstResponder];
            break;
        case 11:
            if([[_inputFields[price] text] length] ==0){
                [self alert:@"not null"];
                [_inputFields[price] becomeFirstResponder];
                break;
            }
            [_inputFields[kilometer] becomeFirstResponder];
            break;
        case 12:
            if([[_inputFields[kilometer] text] length] ==0){
                [self alert:@"not null"];
                [_inputFields[kilometer] becomeFirstResponder];
                break;
            }
            [_inputFields[kilometer] resignFirstResponder];
            break;
    }
    return 1;
}

// alert
-(void) alert: (NSString *) message{
    UIAlertView *alert;
    switch(_determind){
        case delete:
            alert = [[UIAlertView alloc] initWithTitle:@"Alert" message:message delegate: self
                                     cancelButtonTitle:@"Cancel" otherButtonTitles: @"Delete",nil];
            [alert show];
            break;
        case edit:
            alert = [[UIAlertView alloc] initWithTitle:@"Alert" message:message delegate: self
                                     cancelButtonTitle:@"Cancel" otherButtonTitles: @"Edit",nil];
            [alert show];
            break;
        default:
            alert = [[UIAlertView alloc] initWithTitle:@"Error" message:message delegate: self
                                     cancelButtonTitle:@"OK" otherButtonTitles: nil];
            [alert show];
            break;
    }
}

// check
-(BOOL) check{
    int i;
    for(i=0;i<[_inputFields count];i++){
        if([[_inputFields[i] text] length] == 0){
            [self alert:@"not null"];
            [_inputFields[i] becomeFirstResponder];
            return 0;
        }
    }
    return 1;
}

// set value from successSingle
-(void) setValueToField{
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
    
    fnid = _inputFields[nid];
    fname = _inputFields[name];
    fgender = _inputFields[gender];
    fage = _inputFields[age];
    fphone = _inputFields[phone];
    faddress = _inputFields[address];
    fcar_id = _inputFields[car_id];
    fbrand = _inputFields[brand];
    ftype = _inputFields[type];
    fcar_name = _inputFields[car_name];
    fyear = _inputFields[year];
    fprice = _inputFields[price];
    fkilometer = _inputFields[kilometer];
    
          fnid.text = [arrayId objectAtIndex: 0];
         fname.text = [arrayName objectAtIndex: 0];
       fgender.text = [arrayGender objectAtIndex: 0];
          fage.text = [arrayAge objectAtIndex: 0];
        fphone.text = [arrayPhone objectAtIndex: 0];
      faddress.text = [arrayAddress objectAtIndex: 0];
       fcar_id.text = [arrayCar_id objectAtIndex: 0];
        fbrand.text = [arrayBrand objectAtIndex: 0];
         ftype.text = [arrayType objectAtIndex: 0];
     fcar_name.text = [arrayCar_name objectAtIndex: 0];
         fyear.text = [arrayYear objectAtIndex: 0];
        fprice.text = [arrayPrice objectAtIndex: 0];
    fkilometer.text = [arrayKilometer objectAtIndex: 0];
    
    fnid.enabled = 0;
    fcar_id.enabled = 0;
}

- (IBAction)back:(UIButton *)sender{
        [self performSegueWithIdentifier:@"backToMain" sender:sender];
}

- (IBAction)clickDelete:(UIButton *)sender{
    if([self check]){
        _determind = sender.tag;
        [self alert:@"Are you sure to delete?"];
        
    }
}

-(void) prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender{
    if(_determind == edit){
        ViewController *controller = (ViewController *)segue.destinationViewController;
        [(UIButton *)sender setTag:backToSuccess];
        controller.determind = [(UIButton *)sender tag];
        controller.receiveCar_id = fcar_id.text;
    }
}


-(void) setBackgroundImg:(NSString *) imgName{
    
    // set background img
    UIGraphicsBeginImageContext(self.view.frame.size);
    [[UIImage imageNamed:[NSString stringWithFormat:@"%@.jpg",imgName]] drawInRect:self.view.bounds];
    UIImage *image = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    
    self.view.backgroundColor = [UIColor colorWithPatternImage: image];
}

-(void) alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex{
    if (_determind == delete || _determind == edit){
        switch(buttonIndex){
            case 0:
                break;
            case 1:
                [self addDataToPath:_databasePath
                             withId:[_inputFields[nid] text]
                               name:[_inputFields[name] text]
                             gender:[_inputFields[gender] text]
                                age:[_inputFields[age] text]
                              phone:[_inputFields[phone] text]
                            address:[_inputFields[address] text]
                             car_id:[_inputFields[car_id] text]
                              brand:[_inputFields[brand] text]
                               type:[_inputFields[type] text]
                           car_name:[_inputFields[car_name] text]
                               year:[_inputFields[year] text]
                              price:[_inputFields[price] text]
                          kilometer:[_inputFields[kilometer] text]];
                break;
            default:
                break;
        }
    }
}
@end

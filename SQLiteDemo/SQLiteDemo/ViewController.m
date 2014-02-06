//
//  ViewController.m
//  SQLiteDemo
//
//  Created by Wayne on 1/11/14.
//  Copyright (c) 2014 Wayne. All rights reserved.
//

#import "ViewController.h"
#import <sqlite3.h>
#import "SuccessSingleController.h"
#import "SuccessMutipleController.h"
#import "InsertController.h"

typedef enum{
    backToMain = 95,
    backToSuccess,
    add,
    delete,
    edit
}Files;

@interface ViewController ()

@end

@implementation ViewController{
    NSString
            // Database Path
                *databasePath,
            // Seller element (Use for receive result from sql be executed, and set to array)
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
    
                // Result dictionary (Use for transiton this dictionary to result controller)
    NSMutableDictionary *dic;
    NSInteger rowCount;
    NSMutableString *querySQL;
    NSMutableString *queryWhere;
    int tmp;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view, typically from a nib.
    
    // for test//////////////////////////////////////////////////////////////////////////
//    NSString *homePath = NSHomeDirectory();
//    NSBundle *appPaht = [NSBundle mainBundle];
//    NSLog(@"home path:%@",homePath);
//    NSFileManager *fileManager = [NSFileManager defaultManager];
//    NSDirectoryEnumerator *dirEnum = [fileManager enumeratorAtPath:homePath];
//    
//    NSArray *array = dirEnum.allObjects;
//    NSLog(@"count:%d",array.count);
//    int i;
//    for (i=0; i<array.count; i++){
//        NSLog(@"element[%d]:%@",i,array[i]);
//    }
    /////////////////////////////////////////////////////////////////////////////////////
    
    // TextFieldDelegate
    _inputName.delegate  = self;
    _inputCarId.delegate = self;
    
    // set background img
    int random = arc4random() % 10 + 1;
    UIGraphicsBeginImageContext(self.view.frame.size);
    [[UIImage imageNamed:[NSString stringWithFormat:@"%d.jpg",random]] drawInRect:self.view.bounds];
    UIImage *image = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    
    self.view.backgroundColor = [UIColor colorWithPatternImage: image];
    
    // initial database
    [self initializeDatabase: @"mydb"];
    if (_determind == backToSuccess){
        _inputCarId.text = _receiveCar_id;
    }
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Initialize database
// check is database copy
-(void) initializeDatabase: (NSString *) databaseName{
    databasePath = [self databasePathWithName: databaseName];
    
    // check database is exist and in Document path
    NSFileManager *fileManager = [NSFileManager defaultManager];
    BOOL success = [fileManager fileExistsAtPath: databasePath];
    // if exists
    if (success){
        return;
    }
    
    // if not exists
    NSString *resourcePath = [[NSBundle mainBundle] pathForResource: databaseName ofType: @"sqlite"];
    [fileManager copyItemAtPath: resourcePath toPath: databasePath error: nil];
}

// 1. get <Home>/Documents Path
-(NSString *) databasePathWithName: (NSString *) databaseName{
    NSString *docPath = [NSHomeDirectory() stringByAppendingPathComponent:@"Documents"];
    
    docPath = [docPath stringByAppendingPathComponent:databaseName];
    // <Home>/Documents/databasename
    return [docPath stringByAppendingString:@".sqlite"];
}


-(IBAction) insertDB: (UIButton *)sender{
    [self performSegueWithIdentifier: @"insert" sender: nil];
}

#pragma mark - Click search
- (IBAction)loadDB:(UIButton *)sender {
    tmp = 0;
    // determine whether fields are empty or filled
    if([_inputName.text length] > 0 && [_inputCarId.text length] == 0){
        tmp = 1;
    }else if([_inputName.text length] == 0 && [_inputCarId.text length] > 0){
        tmp = 2;
    }else if(!([_inputName.text length]==0) && !([_inputCarId.text length]==0)){
        tmp = 3;
    }
    [self initElement];
    [self readDataFromPath: databasePath];
}

#pragma mark - Query database
// load DB
-(void) readDataFromPath: (NSString *) databasePath{
    sqlite3 *database;
    // open database
    if (sqlite3_open([databasePath UTF8String], &database) == SQLITE_OK){
        [querySQL appendString: @"select a.id, a.name, a.gender, a.age, a.phone, a.address, " ];
        [querySQL appendString: @"b.car_id, b.product, b.type, b.name, b.year, b.price, b.kilometer "];
        [querySQL appendString: @"from seller a, car b where a.car_id = b.car_id"];
        
        switch(tmp){
            case 1:
                [queryWhere appendString: @" and a.id = ?"];
                [querySQL appendString: queryWhere];
                break;
            case 2:
                [queryWhere appendString:@" and a.car_id = ? and a.car_id = b.car_id"];
                [querySQL appendString: queryWhere];
                break;
            case 3:
                [queryWhere appendString: @" and a.name = ? and a.car_id = ?"];
                [querySQL appendString: queryWhere];
                break;
        }
        
        const char *sql=[querySQL UTF8String];
        sqlite3_stmt *stm;
        int result = sqlite3_prepare_v2(database,sql,-1,&stm,NULL);
        if(result == SQLITE_OK){
            // bind parameter
            switch(tmp){
                case 1:
                    sqlite3_bind_text(stm,1,[_inputName.text UTF8String],-1,SQLITE_TRANSIENT);
                    break;
                case 2:
                    sqlite3_bind_text(stm,1,[_inputCarId.text UTF8String],-1,SQLITE_TRANSIENT);
                    break;
                case 3:
                    sqlite3_bind_text(stm,1,[_inputName.text UTF8String],-1,SQLITE_TRANSIENT);
                    sqlite3_bind_text(stm,2,[_inputCarId.text UTF8String],-1,SQLITE_TRANSIENT);
                    break;
            }
            
            // load every data
            while(sqlite3_step(stm) == SQLITE_ROW){
                nid         = [NSString stringWithUTF8String: (char *)sqlite3_column_text(stm,0)];
                name        = [NSString stringWithUTF8String: (char *)sqlite3_column_text(stm,1)];
                gender      = [NSString stringWithUTF8String: (char *)sqlite3_column_text(stm,2)];
                age         = [NSString stringWithUTF8String: (char *)sqlite3_column_text(stm,3)];
                phone       = [NSString stringWithUTF8String: (char *)sqlite3_column_text(stm,4)];
                address     = [NSString stringWithUTF8String: (char *)sqlite3_column_text(stm,5)];
                car_id      = [NSString stringWithUTF8String: (char *)sqlite3_column_text(stm,6)];
                brand       = [NSString stringWithUTF8String: (char *)sqlite3_column_text(stm,7)];
                type        = [NSString stringWithUTF8String: (char *)sqlite3_column_text(stm,8)];
                car_name    = [NSString stringWithUTF8String: (char *)sqlite3_column_text(stm,9)];
                year        = [NSString stringWithUTF8String: (char *)sqlite3_column_text(stm,10)];
                price       = [NSString stringWithUTF8String: (char *)sqlite3_column_text(stm,11)];
                kilometer   = [NSString stringWithUTF8String: (char *)sqlite3_column_text(stm,12)];
                
                [arrayId         addObject:nid];
                [arrayName       addObject:name];
                [arrayGender     addObject:gender];
                [arrayAge        addObject:age];
                [arrayPhone      addObject:phone];
                [arrayAddress    addObject:address];
                [arrayCar_id     addObject:car_id];
                [arrayBrand      addObject:brand];
                [arrayType       addObject:type];
                [arrayCar_name   addObject:car_name];
                [arrayYear       addObject:year];
                [arrayPrice      addObject:price];
                [arrayKilometer  addObject:kilometer];
                rowCount++;
            }
            // release statement
            sqlite3_finalize(stm);
            
            dic = [[NSMutableDictionary alloc] init];
            [dic setValue: arrayId        forKey: @"nid"];
            [dic setValue: arrayName      forKey: @"name"];
            [dic setValue: arrayGender    forKey: @"gender"];
            [dic setValue: arrayAge       forKey: @"age"];
            [dic setValue: arrayPhone     forKey: @"phone"];
            [dic setValue: arrayAddress   forKey: @"address"];
            [dic setValue: arrayCar_id    forKey: @"car_id"];
            [dic setValue: arrayBrand     forKey: @"product"];
            [dic setValue: arrayType      forKey: @"type"];
            [dic setValue: arrayCar_name  forKey: @"car_name"];
            [dic setValue: arrayYear      forKey: @"year"];
            [dic setValue: arrayPrice     forKey: @"price"];
            [dic setValue: arrayKilometer forKey: @"kilometer"];
            
            switch(rowCount){
                case 0:
                    [self displayAlertView];
                    break;
                case 1:
                    [self performSegueWithIdentifier:@"successSingle" sender:nil];
                    break;
                default:
                    [self performSegueWithIdentifier:@"successMutiple" sender:nil];
            }
        }else{
            NSLog(@"statemant faild:%d",result);
        }
        // close database
        sqlite3_close(database);
    }
}

#pragma mark - Prepare for segue
-(void) prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender{
    if([[segue identifier] isEqualToString:@"successSingle"]){
        SuccessSingleController *success = (SuccessSingleController *)segue.destinationViewController;
        success.dataDict = dic;
        success.count = rowCount;
        success.databasePath = databasePath;
    }else if([[segue identifier] isEqualToString:@"successMutiple"]){
        SuccessMutipleController *success = (SuccessMutipleController *)segue.destinationViewController;
        success.dataDict = dic;
        success.count = rowCount;
    }else if([[segue identifier] isEqualToString:@"insert"]){
        InsertController *insert = (InsertController *)segue.destinationViewController;
        insert.databasePath = databasePath;
        insert.determind = add;
    }
}

#pragma mark - Display Alert
-(void) displayAlertView{
    UIAlertView *alertView = [[UIAlertView alloc] initWithTitle: @"Error" message: @"No data found"
                                                       delegate: self cancelButtonTitle: @"OK" otherButtonTitles: nil];
    [alertView show];
}

#pragma mark - Click return on keyboard
-(BOOL) textFieldShouldReturn: (UITextField *) textField{
    [textField resignFirstResponder];
    if(textField == _inputName){
        [_inputCarId becomeFirstResponder];
    }else if (textField == _inputCarId){
        [_inputCarId resignFirstResponder];
    }
    return 1;
}

#pragma mark - Initialize variables
-(void) initElement{
    arrayId         = [[NSMutableArray alloc]init];
    arrayName       = [[NSMutableArray alloc]init];
    arrayGender     = [[NSMutableArray alloc]init];
    arrayAge        = [[NSMutableArray alloc]init];
    arrayPhone      = [[NSMutableArray alloc]init];
    arrayAddress    = [[NSMutableArray alloc]init];
    arrayCar_id     = [[NSMutableArray alloc]init];
    arrayBrand      = [[NSMutableArray alloc]init];
    arrayType       = [[NSMutableArray alloc]init];
    arrayCar_name   = [[NSMutableArray alloc]init];
    arrayYear       = [[NSMutableArray alloc]init];
    arrayPrice      = [[NSMutableArray alloc]init];
    arrayKilometer  = [[NSMutableArray alloc]init];
    
    // initial sql statement
    querySQL = [[NSMutableString alloc] init];
    queryWhere = [[NSMutableString alloc] init];
}
@end

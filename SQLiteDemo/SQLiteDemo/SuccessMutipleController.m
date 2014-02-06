//
//  SuccessMutipleController.m
//  SQLiteDemo
//
//  Created by Wayne on 1/12/14.
//  Copyright (c) 2014 Wayne. All rights reserved.
//

#import "SuccessMutipleController.h"

@interface SuccessMutipleController ()

@end

@implementation SuccessMutipleController{
    NSMutableArray *arrayName, *arrayAge, *arrayAddress;
    NSMutableString *total;
    NSString *name, *age, *address;
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
    
    // set background img
    int random = arc4random() % 10 + 1;
    UIGraphicsBeginImageContext(self.view.frame.size);
    [[UIImage imageNamed:[NSString stringWithFormat:@"%d.jpg",random]] drawInRect:self.view.bounds];
    UIImage *image = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    
    self.view.backgroundColor = [UIColor colorWithPatternImage: image];
    
    arrayName    = [_dataDict objectForKey:@"name"];
    arrayAge     = [_dataDict objectForKey:@"age"];
    arrayAddress = [_dataDict objectForKey:@"address"];
    total        = [[NSMutableString alloc]init];
    NSInteger i;
    for(i=0; i<_count; i++){
        name    = [arrayName objectAtIndex:i];
        age     = [arrayAge objectAtIndex:i];
        address = [arrayAddress objectAtIndex:i];
        [total appendFormat: @"Name:%@\nAge:%@\nAddress:%@\n\n",name,age,address];
    }
    _successMutiple.text = total;
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end

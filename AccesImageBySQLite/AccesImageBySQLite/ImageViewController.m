//
//  ViewController.m
//  AccessImageWithDBTest
//
//  Created by Wayne on 2/7/14.
//  Copyright (c) 2014 Wayne. All rights reserved.
//

#import "ImageViewController.h"
#import "AppDelegate.h"

@interface ImageViewController (){
    sqlite3 *database;
    sqlite3_stmt *statement;
    UIImage *image;
    NSData *imageData;
    NSString *numberString;
    NSString *sqlString;
}
-(void)add;
-(void)search;
@end

@implementation ImageViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view, typically from a nib.
    _scrollView.delegate = self;
    AppDelegate *delegate = (AppDelegate *)[UIApplication sharedApplication].delegate;
    database = [delegate getDB];
    if(database != nil){
        // Prepare image
        switch(_determind){
            case 1:
                [self add];
                break;
            case 2:
                [self search];
                break;
        }
    }
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void)add{
    image = [[UIImage alloc] initWithData:[NSData dataWithContentsOfURL:[NSURL URLWithString:_imageURL]]];
    imageData = UIImagePNGRepresentation(image);
    numberString = [NSString stringWithFormat:@"%d",_number];
    sqlString = [NSString stringWithFormat:@"insert into image values (%@ ,? );",numberString];
    const char *sqlInsert = [sqlString UTF8String];
    sqlite3_prepare_v2(database,sqlInsert,-1,&statement,NULL);
    sqlite3_bind_blob(statement,1,[imageData bytes],[imageData length],NULL);
    
    char *error;
    //        if(sqlite3_exec(database,sqlInsert,NULL,NULL,&error) == SQLITE_OK)
    if(sqlite3_step(statement) == SQLITE_OK)
        NSLog(@"success");
    else
        NSLog(@"faild:%d",sqlite3_exec(database,sqlInsert,NULL,NULL,&error));
    
    sqlite3_finalize(statement);
}
-(void)search{
    numberString = [NSString stringWithFormat:@"%d",_number];
    sqlString = [NSString stringWithFormat:@"select * from image where seq_no = '%@'",numberString];
    const char *sqlSelect = [sqlString UTF8String];
    sqlite3_prepare_v2(database,sqlSelect,-1,&statement,NULL);
    while(sqlite3_step(statement) == SQLITE_ROW){
        int length = sqlite3_column_bytes(statement,1);
        imageData = [NSData dataWithBytes:sqlite3_column_blob(statement,1) length:length];
        _imageView.image = [UIImage imageWithData:imageData];
    }
    NSLog(@"sqlite3_step(statement):%d",sqlite3_step(statement));
    sqlite3_finalize(statement);
}

#pragma mark - UIScrollViewDelegate
-(UIView *)viewForZoomingInScrollView:(UIScrollView *)scrollView{
    return _imageView;
}
@end

//
//  ContentViewController.m
//  NovelDemo2
//
//  Created by Wayne on 1/15/14.
//  Copyright (c) 2014 Wayne. All rights reserved.
//

#import "ContentViewController.h"

@interface ContentViewController ()

@end

@implementation ContentViewController

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
    DatabaseSQLite *database = [DatabaseSQLite new];
    _textView.text = [database contentForIndex: _page];
    [self.textView setEditable:0];
    self.textView.delegate = self;
//    NSLog(@"editable:%d",[self textViewShouldBeginEditing:self.textView]);
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(BOOL) textViewShouldBeginEditing:(UITextView *)textView{
    return textView.editable;
}
@end

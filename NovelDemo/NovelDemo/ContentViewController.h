//
//  ContentViewController.h
//  NovelDemo2
//
//  Created by Wayne on 1/15/14.
//  Copyright (c) 2014 Wayne. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "DatabaseSQLite.h"

@interface ContentViewController : UIViewController <UITextViewDelegate>
@property (nonatomic) int page;
@property (strong, nonatomic) IBOutlet UITextView *textView;

@end

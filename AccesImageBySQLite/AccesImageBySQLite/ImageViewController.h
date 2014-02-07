//
//  ViewController.h
//  AccessImageWithDBTest
//
//  Created by Wayne on 2/7/14.
//  Copyright (c) 2014 Wayne. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ImageViewController : UIViewController <UIScrollViewDelegate>
@property (strong, nonatomic) IBOutlet UIImageView *imageView;
@property (nonatomic) int number;
@property (strong, nonatomic) NSString *imageURL;
@property (nonatomic) int determind;
@property (strong, nonatomic) IBOutlet UIScrollView *scrollView;
@end

//
//  Photo.h
//  FBLoginTest
//
//  Created by Wayne on 4/17/14.
//  Copyright (c) 2014 Wayne. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "People.h"

@interface Photo : NSObject

@property (strong, nonatomic) NSString *photoID;
@property (strong, nonatomic) NSString *photoSource;
@property (strong, nonatomic) People   *photoLikes;
@property (strong, nonatomic) UIImage  *photoImg;
@property (strong, nonatomic) NSString *title;

@end

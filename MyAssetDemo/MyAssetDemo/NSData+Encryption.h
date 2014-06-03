//
//  NSData+Encryption.h
//  MyAssetDemo
//
//  Created by Wayne on 4/11/14.
//  Copyright (c) 2014 Wayne. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NSData (Encryption)

- (NSData *)AES256EncryptWithKey:(NSString *)key;
- (NSData *)AES256DecryptWithKey:(NSString *)key;

@end

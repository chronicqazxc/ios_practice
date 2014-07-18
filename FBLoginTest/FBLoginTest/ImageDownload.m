//
//  ImageDownload.m
//  FBLoginTest
//
//  Created by Wayne on 4/17/14.
//  Copyright (c) 2014 Wayne. All rights reserved.
//

#import "ImageDownload.h"
#import "Photo.h"

#define kAppIconHeight 320
@implementation ImageDownload

- (void)startDownload{
    
    self.activeDownload = [NSMutableData data];
    
    NSString *URLString = self.photo.photoSource;
    
    NSURLRequest *request = [NSURLRequest requestWithURL: [NSURL URLWithString:URLString]];
    
    NSURLConnection *connection = [[NSURLConnection alloc] initWithRequest:request delegate:self];
    
    self.imageConnection = connection;
}

- (void)cancelDownload{
    
    [self.imageConnection cancel];
    
    self.imageConnection = nil;
    
    self.activeDownload = nil;
}

#pragma mark -
#pragma mark Download support (NSURLConnectionDelegate)

- (void)connection:(NSURLConnection *)connection didReceiveData:(NSData *)data
{
    [self.activeDownload appendData:data];
}

- (void)connection:(NSURLConnection *)connection didFailWithError:(NSError *)error
{
    self.activeDownload = nil;
    
    self.imageConnection = nil;
}

- (void)connectionDidFinishLoading:(NSURLConnection *)connection
{
    UIImage *image = [[UIImage alloc] initWithData:self.activeDownload];

//    if (image.size.width != kAppIconHeight && image.size.height != kAppIconHeight)
//	{
//        CGSize itemSize = CGSizeMake(kAppIconHeight, kAppIconHeight);
//		UIGraphicsBeginImageContext(itemSize);
//		CGRect imageRect = CGRectMake(0.0, 0.0, itemSize.width, itemSize.height);
//		[image drawInRect:imageRect];
//		self.photo.photoImg = UIGraphicsGetImageFromCurrentImageContext();
//		UIGraphicsEndImageContext();
//    }
//    else
//    {
//        self.photo.photoImg = image;
//    }
    
    self.photo.photoImg = image;
    
    self.activeDownload = nil;
    
    self.imageConnection = nil;
    
    [self.delegate appImageDidLoad:self.indexPath];
}
@end

//
//  IconDownloader.m
//  LazyLoadingTest
//
//  Created by Wayne on 4/7/14.
//  Copyright (c) 2014 Wayne. All rights reserved.
//

#import "IconDownloader.h"
#import "MyXMLData.h"

#define kAppIconHeight 48

@implementation IconDownloader

- (void)startDownload{
    _activeDownload = [NSMutableData data];
    
    NSURLConnection *connection = [[NSURLConnection alloc] initWithRequest:[NSURLRequest requestWithURL:[NSURL URLWithString:_appRecord.imageStr]] delegate:self];
    _imageConnnection = connection;
}

- (void)cancelDownload{
    [_imageConnnection cancel];
    _imageConnnection = nil;
    _activeDownload = nil;
}

#pragma mark -
#pragma mark Download support (NSURLConnectionDelegate)

- (void)connection:(NSURLConnection *)connection didReceiveData:(NSData *)data
{
    [_activeDownload appendData:data];
}

- (void)connection:(NSURLConnection *)connection didFailWithError:(NSError *)error
{
    _activeDownload = nil;
    
    _imageConnnection = nil;
}

- (void)connectionDidFinishLoading:(NSURLConnection *)connection
{
    UIImage *image = [[UIImage alloc] initWithData:self.activeDownload];
    
    if (image.size.width != kAppIconHeight && image.size.height != kAppIconHeight)
	{
        CGSize itemSize = CGSizeMake(kAppIconHeight, kAppIconHeight);
		UIGraphicsBeginImageContext(itemSize);
		CGRect imageRect = CGRectMake(0.0, 0.0, itemSize.width, itemSize.height);
		[image drawInRect:imageRect];
		self.appRecord.appIcon = UIGraphicsGetImageFromCurrentImageContext();
		UIGraphicsEndImageContext();
    }
    else
    {
        self.appRecord.appIcon = image;
    }
    
    self.activeDownload = nil;
    
    _imageConnnection = nil;
    
    [_delegate appImageDidLoad:_indexPathInTableView];
}
@end

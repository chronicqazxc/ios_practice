//
//  ViewController.m
//  ShortyURL
//
//  Created by Wayne on 4/25/14.
//  Copyright (c) 2014 Wayne. All rights reserved.
//

#import "ViewController.h"

@interface ViewController (){
    
    NSMutableData *shortURLData;
    
    NSURLConnection *shortenURLConnection;
}

@end

@implementation ViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view, typically from a nib.
    
    self.webView.delegate = self;
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)clipboardURL:(UIBarButtonItem *)sender {
    
    NSString *shortURLString = self.shortLabel.title;
    
    NSURL *shortURL = [NSURL URLWithString:shortURLString];
    
    [[UIPasteboard generalPasteboard] setURL:shortURL];
    
}

- (IBAction)loadLocation:(UIBarButtonItem *)sender {
    NSString *urlText = self.urlField.text;
    
    if (![urlText hasPrefix:@"http:"] && ![urlText hasPrefix:@"https:"]){
        
        if (![urlText hasPrefix:@"//"]){
            
            urlText = [@"//" stringByAppendingString:urlText];
            
        }
        
        urlText = [@"http:" stringByAppendingString:urlText];
    }
    
    NSURL *url = [NSURL URLWithString:urlText];
    
    [self.webView loadRequest:[NSURLRequest requestWithURL:url]];
    
}

- (IBAction)shortenURL:(UIBarButtonItem *)sender {
    
    NSString *urlToShorten = self.webView.request.URL.absoluteString;
    
    NSString *urlString = [NSString stringWithFormat:@"http://tinyurl.com/api-create.php?url=%@",[urlToShorten stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding]];
    
    shortURLData = [NSMutableData data];
    
    NSURLRequest *request = [NSURLRequest requestWithURL:[NSURL URLWithString:urlString]];
    
    shortenURLConnection = [NSURLConnection connectionWithRequest:request delegate:self];
    
}

#pragma mark -
#pragma mark - UIWebViewDelegate

- (void)webViewDidStartLoad:(UIWebView *)webView{
    
    self.shortenButton.enabled = NO;
    
    [[UIApplication sharedApplication] setNetworkActivityIndicatorVisible:YES];
}

- (void)webViewDidFinishLoad:(UIWebView *)webView{
    
    self.shortenButton.enabled = YES;
    
    self.urlField.text = webView.request.URL.absoluteString;
    
    [[UIApplication sharedApplication] setNetworkActivityIndicatorVisible:NO];
    
}

- (void)webView:(UIWebView *)webView didFailLoadWithError:(NSError *)error{
    
    NSString *errorMessage = [NSString stringWithFormat:@"Error occured trying to load page : %@", error.localizedDescription];
    
    [[[UIAlertView alloc] initWithTitle:@"Error" message:errorMessage delegate:nil cancelButtonTitle:@"OK" otherButtonTitles: nil] show];
    
}

#pragma mark - NSURLConnectionDelegate

- (void)connection:(NSURLConnection *)connection didFailWithError:(NSError *)error{
    
    self.shortLabel.title = @"faild";
    self.clipboardButton.enabled = NO;
    self.shortenButton.enabled = YES;
    
}

- (void)connection:(NSURLConnection *)connection didReceiveData:(NSData *)data{
    
    [shortURLData appendData:data];
    
}

- (void)connectionDidFinishLoading:(NSURLConnection *)connection{
    
    NSString *shortURLString = [[NSString alloc] initWithData:shortURLData encoding:NSUTF8StringEncoding];
    
    self.shortLabel.title = shortURLString;
    self.clipboardButton.enabled = YES;
}
@end

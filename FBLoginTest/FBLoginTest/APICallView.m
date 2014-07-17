//
//  APICallView.m
//  FBLoginTest
//
//  Created by Wayne on 7/17/14.
//  Copyright (c) 2014 Wayne. All rights reserved.
//

#import "APICallView.h"
#import "BusyView.h"
#import <FacebookSDK/FacebookSDK.h>

@interface APICallView()
@property (strong, nonatomic) UIView *busyView;
@end

@implementation APICallView

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
    }
    return self;
}

- (id) initWithCoder:(NSCoder *)aDecoder {
    self = [super initWithCoder:aDecoder];
    if (self) {
        self.messageTextView.delegate = self;
    }
    return self;
}

- (void)drawRect:(CGRect)rect
{
    self.dialogView.layer.masksToBounds = YES;
    self.dialogView.layer.cornerRadius = 10.0;
    self.messageTextView.layer.borderWidth = 0.5;
    self.messageTextView.layer.borderColor = [UIColor grayColor].CGColor;
    self.messageTextView.text = @"遠看以為是「藍色松綠石」　結果是兩隻蜥蜴在「喇舌」\n ETtodayETtoday – 2014年7月16日 下午3:50 國際中心／綜合報導「喇舌」不是人類專利，現在就連爬蟲類也愛玩親親。委內瑞拉一名48歲的藝術家，原本以為自己在亨利‧皮帝爾國家公園（Henri Pittier National Park）發現了一顆美麗的「藍色綠松石」，沒想到走近一看才發現，這是兩隻蜥蜴在喇舌。這名藝術家叫瑪雅娜（Mariana Rosa），她帶著2名兒子到熱帶雨林中探險，在爬到1789公尺處，她突然發現遠處有一顆美麗的石頭，於是拿起相機拍留念，沒想到兒子看了照片卻說「媽，這是兩隻蜥蜴在親親」。馬雅納聽了後重新察看照片，發現真如兒子所言，本來想要上前多拍幾張，但受到驚嚇的的雌蜥蜴早已逃之夭夭，留下雄蜥蜴在原地苦苦尋覓。據英國《每日郵報》報導，這種藍綠色蜥蜴又名彩虹鞭尾蜥蜴（Rainbow Whiptail lizard），主要分布在中南美洲以及加勒比海島上，由於牠的顏色鮮豔，也成了許多人喜愛的名貴寵物。";
}

- (void)popupShareDialog {
    self.dialogView.transform = CGAffineTransformMakeScale(0.1, 0.1);
    self.dialogView.alpha = 0;
    [UIView beginAnimations:nil context:nil];
    self.dialogView.transform = CGAffineTransformMakeScale(1.0, 1.0);
    [UIView setAnimationDelegate:self];
    self.dialogView.transform = CGAffineTransformMakeScale(1.1, 1.1);
    self.dialogView.alpha = 1;
    [UIView commitAnimations];
    
    
}



- (void)setOpaque:(BOOL)newIsOpaque
{
    // Ignore attempt to set opaque to YES.
}

- (IBAction)clickCancel:(UIButton *)sender {
    [self removeShareDialog];
}

- (IBAction)clickPublish:(UIButton *)sender {
    [FBRequestConnection startWithGraphPath:@"/me/feed" parameters:[self preparePublishByAPIParams] HTTPMethod:@"POST" completionHandler:^(FBRequestConnection *connection, id result, NSError *error) {
        
        if (!error){
            [[[UIAlertView alloc] initWithTitle:@"Publish success" message:nil delegate:self cancelButtonTitle:@"OK" otherButtonTitles: nil] show];
        }else{
            [[[UIAlertView alloc] initWithTitle:@"Publish faild" message:nil delegate:self cancelButtonTitle:@"OK" otherButtonTitles: nil] show];
        }
    }];
    
    NSArray *views = [[NSBundle mainBundle] loadNibNamed:@"BusyView" owner:nil options:nil];
    for (_busyView in views) {
        if ([_busyView isKindOfClass:[BusyView class]]) {
            break;
        }
    }
    if ([self.busyView isKindOfClass:[BusyView class]])
        [self.viewController.view addSubview:self.busyView];
}

- (NSDictionary *)preparePublishByAPIParams{
    NSError *error = nil;
    NSMutableDictionary *privacy = [[NSMutableDictionary alloc]initWithObjectsAndKeys:
                                    //                                    @"", @"allow", //Friends Id      separeted with commas.
                                    //                                    @"", @"deny",
                                    @"SELF", @"value",         //Privacy Custom Value
                                    nil];
    NSData *jsonData = [NSJSONSerialization dataWithJSONObject:privacy
                                                       options:NSJSONWritingPrettyPrinted
                                                         error:&error];
    NSString *jsonString;
    
    if (! jsonData) {
        NSLog(@"Got an error");
    } else {
        jsonString = [[NSString alloc] initWithData:jsonData encoding:NSUTF8StringEncoding];
    }
    
    NSMutableDictionary *params = [NSMutableDictionary dictionaryWithObjectsAndKeys:
                                   @"Sharing Tutorial", @"name",
                                   @"Build great social apps and get more installs.", @"caption",
                                   @"Allow your users to share stories on Facebook from your app using the iOS SDK.", @"description",
                                   @"https://developers.facebook.com/docs/ios/share/", @"link",
                                   @"http://i.imgur.com/g3Qc1HN.png", @"picture",
                                   self.messageTextView.text, @"message",
                                   nil];
    [params setObject:jsonString forKey:@"privacy"];
    
    return params;
}

- (void)removeShareDialog {
    [UIView animateWithDuration:0.3f animations:^{
        self.dialogView.transform = CGAffineTransformMakeScale(1.0, 1.0);
        [UIView setAnimationDelegate:self];
        self.dialogView.transform = CGAffineTransformMakeScale(0.1, 0.1);
        self.alpha = 0;
    }
     completion:^(BOOL finished) {
         [self removeFromSuperview];
     }];
}

#pragma mark - UITextFieldDelegate
- (BOOL)textFieldShouldReturn:(UITextField *)textField {
    [textField resignFirstResponder];
    return YES;
}

#pragma mark - UIAlerViewDelegate
- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex {
    if ([self.busyView isKindOfClass:[BusyView class]])
        [self.busyView removeFromSuperview];
    [self removeShareDialog];
}
@end
